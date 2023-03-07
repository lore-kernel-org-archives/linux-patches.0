Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919B8BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA70AC433D2;
	Tue,  7 Mar 2023 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209821;
	bh=UKj/Yz1lvupNizeVrO4etaeCaHmugzEYepmlLeh6XJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAV1H73EkatjNnD3JGU1dpDgDQayDOka45A0qUuwUuFdsiw/KQLC65PGOqHjDbw43
	 Epf8hZTutZ2kU5XC0jw83nXW6M/9UMVfY2dj/D613ifUTQblR0TUh70l8NYu2OWZi9
	 /4y2b2hw2/7OIpmf1yOUG6LXsBH2QqOPHAMPt9pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0342/1001] hwmon: (ftsteutates) Fix scaling of measurements
Date: Tue,  7 Mar 2023 17:51:54 +0100
Message-Id: <20230307170036.308265264@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit ca8fd8c16a8b77dfcf7f6ce52d2c863220693a78 ]

A user complained that the ftsteutates driver was displaying
bogus values since its introduction. This happens because the
sensor measurements need to be scaled in order to produce
meaningful results:
- the fan speed needs to be multiplied by 60 since its in RPS
- the temperature is in degrees celsius and needs an offset of 64
- the voltage is in 1/256 of 3.3V

The offical datasheet says the voltage needs to be divided by 256,
but this is likely an off-by-one-error, since even the BIOS
devides by 255 (otherwise 3.3V could not be measured).

The voltage channels additionally need a board-specific multiplier,
however this can be done by the driver since its board-specific.

The reason the missing scaling of measurements is the way Fujitsu
used this driver when it was still out-of-tree. Back then, all
scaling was done in userspace by libsensors, even the generic one.

Tested on a Fujitsu DS3401-B1.

Fixes: 08426eda58e0 ("hwmon: Add driver for FTS BMC chip "Teutates"")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20221224041855.83981-2-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/ftsteutates.rst |  4 ++++
 drivers/hwmon/ftsteutates.c         | 19 +++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/ftsteutates.rst b/Documentation/hwmon/ftsteutates.rst
index 58a2483d8d0da..198fa8e2819da 100644
--- a/Documentation/hwmon/ftsteutates.rst
+++ b/Documentation/hwmon/ftsteutates.rst
@@ -22,6 +22,10 @@ enhancements. It can monitor up to 4 voltages, 16 temperatures and
 8 fans. It also contains an integrated watchdog which is currently
 implemented in this driver.
 
+The 4 voltages require a board-specific multiplier, since the BMC can
+only measure voltages up to 3.3V and thus relies on voltage dividers.
+Consult your motherboard manual for details.
+
 To clear a temperature or fan alarm, execute the following command with the
 correct path to the alarm file::
 
diff --git a/drivers/hwmon/ftsteutates.c b/drivers/hwmon/ftsteutates.c
index f5b8e724a8ca1..ffa0bb3648775 100644
--- a/drivers/hwmon/ftsteutates.c
+++ b/drivers/hwmon/ftsteutates.c
@@ -12,6 +12,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -347,13 +348,15 @@ static ssize_t in_value_show(struct device *dev,
 {
 	struct fts_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(devattr)->index;
-	int err;
+	int value, err;
 
 	err = fts_update_device(data);
 	if (err < 0)
 		return err;
 
-	return sprintf(buf, "%u\n", data->volt[index]);
+	value = DIV_ROUND_CLOSEST(data->volt[index] * 3300, 255);
+
+	return sprintf(buf, "%d\n", value);
 }
 
 static ssize_t temp_value_show(struct device *dev,
@@ -361,13 +364,15 @@ static ssize_t temp_value_show(struct device *dev,
 {
 	struct fts_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(devattr)->index;
-	int err;
+	int value, err;
 
 	err = fts_update_device(data);
 	if (err < 0)
 		return err;
 
-	return sprintf(buf, "%u\n", data->temp_input[index]);
+	value = (data->temp_input[index] - 64) * 1000;
+
+	return sprintf(buf, "%d\n", value);
 }
 
 static ssize_t temp_fault_show(struct device *dev,
@@ -436,13 +441,15 @@ static ssize_t fan_value_show(struct device *dev,
 {
 	struct fts_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(devattr)->index;
-	int err;
+	int value, err;
 
 	err = fts_update_device(data);
 	if (err < 0)
 		return err;
 
-	return sprintf(buf, "%u\n", data->fan_input[index]);
+	value = data->fan_input[index] * 60;
+
+	return sprintf(buf, "%d\n", value);
 }
 
 static ssize_t fan_source_show(struct device *dev,
-- 
2.39.2



