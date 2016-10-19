## Coursera / Johns Hopkins: Getting and Cleaning the Data
## Walker Kehoe

library(plyr)

#import data
features <- read.table('features.txt')
labels <- read.table('activity_labels.txt')
X_train <- read.table('train/X_train.txt')
X_test <- read.table('test/X_test.txt')
subject_train <- read.table('train/subject_train.txt')
subject_test <- read.table('test/subject_test.txt')
y_train <- read.table('train/y_train.txt')
y_test <- read.table('test/y_test.txt')


#merge test and train data
X <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

#assigning names to columns 
colnames(X) <- features[,2]
colnames(y) <- c('activity')
colnames(subject) <- c('subject')

## 3. Changing activity numbers to descriptions
for(j in y) {
  y$activity <- labels[y$activity,2]
}

## 1. Merge feature and target data
df <- cbind(subject,X,y)

## 2. Extract only mean and sd 
df <- df[ , grepl( 'subject|mean\\(\\)|std\\(\\)|activity' , names( df ) ) ]

## 4. Rename features to include more description
names(df) <-gsub('^t','time', names(df))
names(df) <-gsub('^f','freq', names(df))
names(df) <-gsub('Acc','Accelerometer', names(df))
names(df) <-gsub('Mag','Magnitude', names(df))
names(df) <-gsub('BodyBody','Body', names(df))

## 5. Create a second, independent tidy data set with the average of each 
##    variable for each activity and each subject.
df_tidy <-aggregate(. ~subject + activity, df, mean)
df_tidy <-df_tidy[order(df_tidy$subject, df_tidy$activity), ]
write.table(df_tidy, file = "tidy.txt", row.name=FALSE)
