Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCEA1DDF5;
	Thu, 15 Aug 2024 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728560; cv=none; b=GeEbbxUodNBvn/i77kTwOA6Z3ak411Trn1h2J+1DRb1PKcMGXxU2+Z0kYprRr5rnFS4aZMM+Au1C53cgHAPQnyBbdgp6Pi4uf/Kn3sOkAL743H2fIqgo9Y6kqdxKHESw9eIAk3D+FBiy2P/pDoUcGc29EgJqFEQysDpxmn1TePE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728560; c=relaxed/simple;
	bh=qO46iR8vXErsElOl9FCXqsN/l0iCDMTM3h3cDnqZIVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKDHj9jpax/+l+jGXUW+Wv8hdU4R1zpgRGu1Mj4a2wA/ZtBXZ1LKBG2QAw3hAErgO/4EFQ8wzsGgW2RSooR6ABLhA/IdOwBIko7J9FF/6qzBQ8sqJyH734qOtylcBlejSHnfvvUMlsqb63pwuz5vQHuFqzTyU7Uks7jChwJI+Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEC4d9G5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEC4d9G5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2039BC4AF0C;
	Thu, 15 Aug 2024 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728560;
	bh=qO46iR8vXErsElOl9FCXqsN/l0iCDMTM3h3cDnqZIVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEC4d9G5kgq0rb4hiyWY7MwLNyBK92hi7B7h+ADsYAu84+D85jX/Awpz4MpJRLH6I
	 sUT600E32H0Rhjfmqv7X5c102j+0NSfMhTRTeavMr5n1qmNeFvAaY6NAFX+CPFKVi9
	 RFKfwJK5zcBRSlTejz5Ma9hDvg5IHW1pzw9Sxo9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/196] hwmon: (max6697) Auto-convert to use SENSOR_DEVICE_ATTR_{RO, RW, WO}
Date: Thu, 15 Aug 2024 15:22:08 +0200
Message-ID: <20240815131852.506263132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 740c2f2b86a71ad673f329241ac25cfe647aacd4 ]

Conversion was done done using the coccinelle script at
https://github.com/groeck/coccinelle-patches/raw/master/hwmon/sensor-devattr-w6.cocci

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 1ea3fd1eb986 ("hwmon: (max6697) Fix swapped temp{1,8} critical alarms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6697.c | 144 ++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 80 deletions(-)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index 7e7f59c68ce6e..2103ba45de745 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -251,7 +251,7 @@ static struct max6697_data *max6697_update_device(struct device *dev)
 	return ret;
 }
 
-static ssize_t show_temp_input(struct device *dev,
+static ssize_t temp_input_show(struct device *dev,
 			       struct device_attribute *devattr, char *buf)
 {
 	int index = to_sensor_dev_attr(devattr)->index;
@@ -267,8 +267,8 @@ static ssize_t show_temp_input(struct device *dev,
 	return sprintf(buf, "%d\n", temp * 125);
 }
 
-static ssize_t show_temp(struct device *dev,
-			 struct device_attribute *devattr, char *buf)
+static ssize_t temp_show(struct device *dev, struct device_attribute *devattr,
+			 char *buf)
 {
 	int nr = to_sensor_dev_attr_2(devattr)->nr;
 	int index = to_sensor_dev_attr_2(devattr)->index;
@@ -284,7 +284,7 @@ static ssize_t show_temp(struct device *dev,
 	return sprintf(buf, "%d\n", temp * 1000);
 }
 
-static ssize_t show_alarm(struct device *dev, struct device_attribute *attr,
+static ssize_t alarm_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
 	int index = to_sensor_dev_attr(attr)->index;
@@ -299,9 +299,9 @@ static ssize_t show_alarm(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%u\n", (data->alarms >> index) & 0x1);
 }
 
-static ssize_t set_temp(struct device *dev,
-			struct device_attribute *devattr,
-			const char *buf, size_t count)
+static ssize_t temp_store(struct device *dev,
+			  struct device_attribute *devattr, const char *buf,
+			  size_t count)
 {
 	int nr = to_sensor_dev_attr_2(devattr)->nr;
 	int index = to_sensor_dev_attr_2(devattr)->index;
@@ -327,79 +327,63 @@ static ssize_t set_temp(struct device *dev,
 	return ret < 0 ? ret : count;
 }
 
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp_input, NULL, 0);
-static SENSOR_DEVICE_ATTR_2(temp1_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    0, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp1_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    0, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_temp_input, NULL, 1);
-static SENSOR_DEVICE_ATTR_2(temp2_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    1, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp2_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    1, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, show_temp_input, NULL, 2);
-static SENSOR_DEVICE_ATTR_2(temp3_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    2, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp3_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    2, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, show_temp_input, NULL, 3);
-static SENSOR_DEVICE_ATTR_2(temp4_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    3, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp4_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    3, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO, show_temp_input, NULL, 4);
-static SENSOR_DEVICE_ATTR_2(temp5_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    4, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp5_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    4, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp6_input, S_IRUGO, show_temp_input, NULL, 5);
-static SENSOR_DEVICE_ATTR_2(temp6_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    5, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp6_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    5, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp7_input, S_IRUGO, show_temp_input, NULL, 6);
-static SENSOR_DEVICE_ATTR_2(temp7_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    6, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp7_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    6, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp8_input, S_IRUGO, show_temp_input, NULL, 7);
-static SENSOR_DEVICE_ATTR_2(temp8_max, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    7, MAX6697_TEMP_MAX);
-static SENSOR_DEVICE_ATTR_2(temp8_crit, S_IRUGO | S_IWUSR, show_temp, set_temp,
-			    7, MAX6697_TEMP_CRIT);
-
-static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL, 22);
-static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, show_alarm, NULL, 16);
-static SENSOR_DEVICE_ATTR(temp3_max_alarm, S_IRUGO, show_alarm, NULL, 17);
-static SENSOR_DEVICE_ATTR(temp4_max_alarm, S_IRUGO, show_alarm, NULL, 18);
-static SENSOR_DEVICE_ATTR(temp5_max_alarm, S_IRUGO, show_alarm, NULL, 19);
-static SENSOR_DEVICE_ATTR(temp6_max_alarm, S_IRUGO, show_alarm, NULL, 20);
-static SENSOR_DEVICE_ATTR(temp7_max_alarm, S_IRUGO, show_alarm, NULL, 21);
-static SENSOR_DEVICE_ATTR(temp8_max_alarm, S_IRUGO, show_alarm, NULL, 23);
-
-static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL, 14);
-static SENSOR_DEVICE_ATTR(temp2_crit_alarm, S_IRUGO, show_alarm, NULL, 8);
-static SENSOR_DEVICE_ATTR(temp3_crit_alarm, S_IRUGO, show_alarm, NULL, 9);
-static SENSOR_DEVICE_ATTR(temp4_crit_alarm, S_IRUGO, show_alarm, NULL, 10);
-static SENSOR_DEVICE_ATTR(temp5_crit_alarm, S_IRUGO, show_alarm, NULL, 11);
-static SENSOR_DEVICE_ATTR(temp6_crit_alarm, S_IRUGO, show_alarm, NULL, 12);
-static SENSOR_DEVICE_ATTR(temp7_crit_alarm, S_IRUGO, show_alarm, NULL, 13);
-static SENSOR_DEVICE_ATTR(temp8_crit_alarm, S_IRUGO, show_alarm, NULL, 15);
-
-static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp3_fault, S_IRUGO, show_alarm, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp4_fault, S_IRUGO, show_alarm, NULL, 3);
-static SENSOR_DEVICE_ATTR(temp5_fault, S_IRUGO, show_alarm, NULL, 4);
-static SENSOR_DEVICE_ATTR(temp6_fault, S_IRUGO, show_alarm, NULL, 5);
-static SENSOR_DEVICE_ATTR(temp7_fault, S_IRUGO, show_alarm, NULL, 6);
-static SENSOR_DEVICE_ATTR(temp8_fault, S_IRUGO, show_alarm, NULL, 7);
+static SENSOR_DEVICE_ATTR_RO(temp1_input, temp_input, 0);
+static SENSOR_DEVICE_ATTR_2_RW(temp1_max, temp, 0, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp1_crit, temp, 0, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp2_input, temp_input, 1);
+static SENSOR_DEVICE_ATTR_2_RW(temp2_max, temp, 1, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp2_crit, temp, 1, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp3_input, temp_input, 2);
+static SENSOR_DEVICE_ATTR_2_RW(temp3_max, temp, 2, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp3_crit, temp, 2, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp4_input, temp_input, 3);
+static SENSOR_DEVICE_ATTR_2_RW(temp4_max, temp, 3, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp4_crit, temp, 3, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp5_input, temp_input, 4);
+static SENSOR_DEVICE_ATTR_2_RW(temp5_max, temp, 4, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp5_crit, temp, 4, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp6_input, temp_input, 5);
+static SENSOR_DEVICE_ATTR_2_RW(temp6_max, temp, 5, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp6_crit, temp, 5, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp7_input, temp_input, 6);
+static SENSOR_DEVICE_ATTR_2_RW(temp7_max, temp, 6, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp7_crit, temp, 6, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp8_input, temp_input, 7);
+static SENSOR_DEVICE_ATTR_2_RW(temp8_max, temp, 7, MAX6697_TEMP_MAX);
+static SENSOR_DEVICE_ATTR_2_RW(temp8_crit, temp, 7, MAX6697_TEMP_CRIT);
+
+static SENSOR_DEVICE_ATTR_RO(temp1_max_alarm, alarm, 22);
+static SENSOR_DEVICE_ATTR_RO(temp2_max_alarm, alarm, 16);
+static SENSOR_DEVICE_ATTR_RO(temp3_max_alarm, alarm, 17);
+static SENSOR_DEVICE_ATTR_RO(temp4_max_alarm, alarm, 18);
+static SENSOR_DEVICE_ATTR_RO(temp5_max_alarm, alarm, 19);
+static SENSOR_DEVICE_ATTR_RO(temp6_max_alarm, alarm, 20);
+static SENSOR_DEVICE_ATTR_RO(temp7_max_alarm, alarm, 21);
+static SENSOR_DEVICE_ATTR_RO(temp8_max_alarm, alarm, 23);
+
+static SENSOR_DEVICE_ATTR_RO(temp1_crit_alarm, alarm, 14);
+static SENSOR_DEVICE_ATTR_RO(temp2_crit_alarm, alarm, 8);
+static SENSOR_DEVICE_ATTR_RO(temp3_crit_alarm, alarm, 9);
+static SENSOR_DEVICE_ATTR_RO(temp4_crit_alarm, alarm, 10);
+static SENSOR_DEVICE_ATTR_RO(temp5_crit_alarm, alarm, 11);
+static SENSOR_DEVICE_ATTR_RO(temp6_crit_alarm, alarm, 12);
+static SENSOR_DEVICE_ATTR_RO(temp7_crit_alarm, alarm, 13);
+static SENSOR_DEVICE_ATTR_RO(temp8_crit_alarm, alarm, 15);
+
+static SENSOR_DEVICE_ATTR_RO(temp2_fault, alarm, 1);
+static SENSOR_DEVICE_ATTR_RO(temp3_fault, alarm, 2);
+static SENSOR_DEVICE_ATTR_RO(temp4_fault, alarm, 3);
+static SENSOR_DEVICE_ATTR_RO(temp5_fault, alarm, 4);
+static SENSOR_DEVICE_ATTR_RO(temp6_fault, alarm, 5);
+static SENSOR_DEVICE_ATTR_RO(temp7_fault, alarm, 6);
+static SENSOR_DEVICE_ATTR_RO(temp8_fault, alarm, 7);
 
 static DEVICE_ATTR(dummy, 0, NULL, NULL);
 
-- 
2.43.0



