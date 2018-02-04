#! /bin/bash
#
# GH 20180131 

# set the URL of the dashcams here - if you're connecting direct then it's
# http://192.168.62.1/ - if you have a port forward or tunnel then it might vary
# you must have the trailing / here
CAMURL="http://192.168.62.1/"

# set some cURL options here. we want slightly different ones for fetching indexes/
# file lists, than we do for fetching files proper

# --connect-timeout 60: abort if initial connection takes over 60 secs
# --speed-time 120 --speed-limit 10000: abort if transfer rate is below 10000 bytes/sec for 120secs
# --retry 5: up to 5 retries
# --retry-connrefused: consider connection refused to be retry'able
# -s: be silent (no progress indication)
# -S: but do show errors if we encounter them
CURLOPTSLIST="--connect-timeout 60 --speed-time 120 --speed-limit 10000 --retry 5 --retry-connrefused -s -S"

# the ones from above, without "silent" for now, and some more for files:
# -C -: continue automatically an interrupted transfer
# --fail: abort if we get an http error (otherwise we encounter https://github.com/curl/curl/issues/1163
# -R    : try to set the local file to the timestamp of the remote file
CURLOPTSFILE="--connect-timeout 60 --speed-time 120 --speed-limit 10000 --retry 5 --retry-connrefused -C - --fail -R"

# where you want the files to end up - no trailing /
TARGET="/data/dashcams"

echo "connect to the front camera's wifi here, or modify the script to do it for you"
read crap

# front camera
echo "FRONT CAMERA"
mkdir $TARGET/front > /dev/null 2> /dev/null
cd $TARGET/front
mkdir button > /dev/null 2> /dev/null
mkdir driving > /dev/null 2> /dev/null
mkdir parked > /dev/null 2> /dev/null
echo "button videos"
cd button
for i in `curl ${CURLOPTSLIST} ${CAMURL}api/videolist?type=4\&maxcount=8000|grep id|awk '{print $2}'|sed s/\"//|sed s/\"\,//`;
do
  echo "working on $i.mp4"
  curl ${CURLOPTSFILE} ${CAMURL}api/video?id=$i -o $i.mp4
done

echo "motion detected while parked videos"
cd ../parked
for i in `curl ${CURLOPTSLIST} ${CAMURL}api/videolist?type=2\&maxcount=8000|grep id|awk '{print $2}'|sed s/\"//|sed s/\"\,//`;
do
  echo "working on $i.mp4"
  curl ${CURLOPTSFILE} ${CAMURL}api/video?id=$i -o $i.mp4
done

echo "driving videos"
cd ../driving
for i in `curl ${CURLOPTSLIST} ${CAMURL}api/videolist?type=1\&maxcount=8000|grep id|awk '{print $2}'|sed s/\"//|sed s/\"\,//`;
do
  echo "working on $i.mp4"
  curl ${CURLOPTSFILE} ${CAMURL}api/video?id=$i -o $i.mp4
done

echo "connect to the rear camera's wifi here, or modify the script to do it for you"
read crap

# rear camera
echo
echo "REAR CAMERA"
echo
cd $TARGET/rear
mkdir button > /dev/null 2> /dev/null
mkdir driving > /dev/null 2> /dev/null
mkdir parked > /dev/null 2> /dev/null
echo "button videos"
cd button
for i in `curl ${CURLOPTSLIST} ${CAMURL}api/videolist?type=4\&maxcount=8000|grep id|awk '{print $2}'|sed s/\"//|sed s/\"\,//`;
do
  echo "working on $i.mp4"
  curl ${CURLOPTSFILE} ${CAMURL}api/video?id=$i -o $i.mp4
done

echo "motion detected while parked videos"
cd ../parked
for i in `curl ${CURLOPTSLIST} ${CAMURL}api/videolist?type=2\&maxcount=8000|grep id|awk '{print $2}'|sed s/\"//|sed s/\"\,//`;
do
  echo "working on $i.mp4"
  curl ${CURLOPTSFILE} ${CAMURL}api/video?id=$i -o $i.mp4
done

echo "driving videos"
cd ../driving
for i in `curl ${CURLOPTSLIST} ${CAMURL}api/videolist?type=1\&maxcount=8000|grep id|awk '{print $2}'|sed s/\"//|sed s/\"\,//`;
do
  echo "working on $i.mp4"
  curl ${CURLOPTSFILE} ${CAMURL}api/video?id=$i -o $i.mp4
done

rm /tmp/dashcam-lock

