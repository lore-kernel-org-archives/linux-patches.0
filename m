Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494B1266584;
	Fri, 21 Nov 2025 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732307; cv=none; b=DawCLGzygzHYvd0gDVRFBFDkhAuNaxkZyI7Nuv9TSlAjW7uS8iiui/owLHEnxwDigebrfSWZK1DpWmdEvQj44j/0VpOACcdnmgpQkHY65zYT754jY2y2u/bwjzZgn0Mrur+slIM+91b0UecM5mv/h7gwhP9HAV35pClPRoed8h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732307; c=relaxed/simple;
	bh=s1KGVmF0idSUBH7pHhXvXDARw4u8AQ1R+X9EtJOjQAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvPukMPcH1J2iLmQyMl3YBWafA3lmNyDfah8ILWvDiJ3LkBCG0MtZkH48SxubAZ6VHYx0Ggc5Figb8qRxEDforRIXnPAogSTGtCE8NZfrDUazieq+jVxEqO3H2hlScTybkbO0R+giuL7RfZfeZjIeHaoP+wgdUP1U+50Oi+Y5DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCC5js2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCC5js2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4B6C4CEF1;
	Fri, 21 Nov 2025 13:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732307;
	bh=s1KGVmF0idSUBH7pHhXvXDARw4u8AQ1R+X9EtJOjQAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCC5js2x1a7E9Q1w5Xprrl5yQfDTuY1pjoBGrko9tDsmn9I4xTRrUzEyakJHvr5TZ
	 w8XG1w7PUXZ4ezbvzJtWybV8LqyTf0gQRC34uIWI11tSOObKAh5zBHF0gfULJ6Qa+v
	 guRsT2FyhZM/6Zt1Eer61os8GWjdnX5egcf4e49s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuande Chen <chuachen@cisco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/529] hwmon: (sbtsi_temp) AMD CPU extended temperature range support
Date: Fri, 21 Nov 2025 14:06:15 +0100
Message-ID: <20251121130233.727784332@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuande Chen <chuachen@cisco.com>

[ Upstream commit d9d61f1da35038793156c04bb13f0a1350709121 ]

Many AMD CPUs can support this feature now. We would get a wrong CPU DIE
temperature if don't consider this. In low-temperature environments,
the CPU die temperature can drop below zero. So many platforms would like
to make extended temperature range as their default configuration.
Default temperature range (0C to 255.875C).
Extended temperature range (-49C to +206.875C).
Ref Doc: AMD V3000 PPR (Doc ID #56558).

Signed-off-by: Chuande Chen <chuachen@cisco.com>
Link: https://lore.kernel.org/r/20250814053940.96764-1-chenchuande@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sbtsi_temp.c | 46 +++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/sbtsi_temp.c b/drivers/hwmon/sbtsi_temp.c
index dd85cf89f008a..7c49fcf864143 100644
--- a/drivers/hwmon/sbtsi_temp.c
+++ b/drivers/hwmon/sbtsi_temp.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/bitfield.h>
 
 /*
  * SB-TSI registers only support SMBus byte data access. "_INT" registers are
@@ -29,8 +30,22 @@
 #define SBTSI_REG_TEMP_HIGH_DEC		0x13 /* RW */
 #define SBTSI_REG_TEMP_LOW_DEC		0x14 /* RW */
 
+/*
+ * Bit for reporting value with temperature measurement range.
+ * bit == 0: Use default temperature range (0C to 255.875C).
+ * bit == 1: Use extended temperature range (-49C to +206.875C).
+ */
+#define SBTSI_CONFIG_EXT_RANGE_SHIFT	2
+/*
+ * ReadOrder bit specifies the reading order of integer and decimal part of
+ * CPU temperature for atomic reads. If bit == 0, reading integer part triggers
+ * latching of the decimal part, so integer part should be read first.
+ * If bit == 1, read order should be reversed.
+ */
 #define SBTSI_CONFIG_READ_ORDER_SHIFT	5
 
+#define SBTSI_TEMP_EXT_RANGE_ADJ	49000
+
 #define SBTSI_TEMP_MIN	0
 #define SBTSI_TEMP_MAX	255875
 
@@ -38,6 +53,8 @@
 struct sbtsi_data {
 	struct i2c_client *client;
 	struct mutex lock;
+	bool ext_range_mode;
+	bool read_order;
 };
 
 /*
@@ -74,23 +91,11 @@ static int sbtsi_read(struct device *dev, enum hwmon_sensor_types type,
 {
 	struct sbtsi_data *data = dev_get_drvdata(dev);
 	s32 temp_int, temp_dec;
-	int err;
 
 	switch (attr) {
 	case hwmon_temp_input:
-		/*
-		 * ReadOrder bit specifies the reading order of integer and
-		 * decimal part of CPU temp for atomic reads. If bit == 0,
-		 * reading integer part triggers latching of the decimal part,
-		 * so integer part should be read first. If bit == 1, read
-		 * order should be reversed.
-		 */
-		err = i2c_smbus_read_byte_data(data->client, SBTSI_REG_CONFIG);
-		if (err < 0)
-			return err;
-
 		mutex_lock(&data->lock);
-		if (err & BIT(SBTSI_CONFIG_READ_ORDER_SHIFT)) {
+		if (data->read_order) {
 			temp_dec = i2c_smbus_read_byte_data(data->client, SBTSI_REG_TEMP_DEC);
 			temp_int = i2c_smbus_read_byte_data(data->client, SBTSI_REG_TEMP_INT);
 		} else {
@@ -122,6 +127,8 @@ static int sbtsi_read(struct device *dev, enum hwmon_sensor_types type,
 		return temp_dec;
 
 	*val = sbtsi_reg_to_mc(temp_int, temp_dec);
+	if (data->ext_range_mode)
+		*val -= SBTSI_TEMP_EXT_RANGE_ADJ;
 
 	return 0;
 }
@@ -146,6 +153,8 @@ static int sbtsi_write(struct device *dev, enum hwmon_sensor_types type,
 		return -EINVAL;
 	}
 
+	if (data->ext_range_mode)
+		val += SBTSI_TEMP_EXT_RANGE_ADJ;
 	val = clamp_val(val, SBTSI_TEMP_MIN, SBTSI_TEMP_MAX);
 	sbtsi_mc_to_reg(val, &temp_int, &temp_dec);
 
@@ -203,6 +212,7 @@ static int sbtsi_probe(struct i2c_client *client)
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct sbtsi_data *data;
+	int err;
 
 	data = devm_kzalloc(dev, sizeof(struct sbtsi_data), GFP_KERNEL);
 	if (!data)
@@ -211,8 +221,14 @@ static int sbtsi_probe(struct i2c_client *client)
 	data->client = client;
 	mutex_init(&data->lock);
 
-	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name, data, &sbtsi_chip_info,
-							 NULL);
+	err = i2c_smbus_read_byte_data(data->client, SBTSI_REG_CONFIG);
+	if (err < 0)
+		return err;
+	data->ext_range_mode = FIELD_GET(BIT(SBTSI_CONFIG_EXT_RANGE_SHIFT), err);
+	data->read_order = FIELD_GET(BIT(SBTSI_CONFIG_READ_ORDER_SHIFT), err);
+
+	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name, data,
+							 &sbtsi_chip_info, NULL);
 
 	return PTR_ERR_OR_ZERO(hwmon_dev);
 }
-- 
2.51.0



