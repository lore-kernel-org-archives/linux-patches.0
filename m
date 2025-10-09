Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BB823182D;
	Thu,  9 Oct 2025 16:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025627; cv=none; b=MYrwXzfl0mMol08vdaXhhL44SUFf+IyeGEkSbSPHXiiT0DIU5ECq4ULmsfbtpBt3gfuR8COOCRdpzKMn+BBW0Ky6c7hedwSCjxTL7486mWybvI6CN1xr4IEb9Kzd9eQ2slC7p/tXPdpj+J8VApWvjSNlti6tG50Clgghb42AzVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025627; c=relaxed/simple;
	bh=txsrKCvNEwcMzkiGFCTS2GYjsOBNYrMSB+dTFSNi8SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BP8S284naXHLCrc0Fi1YOUZk5W5uPyD+Cn2qlyl52MeKppcF/NeVs1gLm2u21jVFEbQAxARy9aw4QcRQ/zAW8Xc7zgJPAIom1CjupbdL2kW/16rALVG8gEIG36+MMJASYRbDtKTQmxc4sBmKxTDyfAvajZTP2NIGTNTXETi1cgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9RKhik1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9RKhik1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BA1C4CEF7;
	Thu,  9 Oct 2025 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025627;
	bh=txsrKCvNEwcMzkiGFCTS2GYjsOBNYrMSB+dTFSNi8SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9RKhik1h97tGlfD9f+PJAUkZdQ4Cfqpdq054xNT1ZMz5dWMEmxDmnUJEZw/UZ6Xn
	 H1Ebjb4+z5B2I+kPX96wGHGD+n/hZM2YCDpvbqreyYdcaZ5X5s3NTsltJB+9NjcBFv
	 P/UUTBpGGlho0jk+KP/9ntiH9FA4aTRVmJYPIRMsOfPL90fa+bGQfZL+kZqqG+M23g
	 hExmuoiS88AB+8ejS/IV+R4sOMh33v18KjaTVY9T7r0xQMBPjniRL8u2/i+8fIJav4
	 GvSqAA+IFqIPWXaLwm+yTOo6fPnw+dcM/Ee4+JGvBYjqXcp5IPqgbHnl2yONBCdPqr
	 Ecqfgozyh5gKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chuande Chen <chuachen@cisco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.15] hwmon: (sbtsi_temp) AMD CPU extended temperature range support
Date: Thu,  9 Oct 2025 11:55:48 -0400
Message-ID: <20251009155752.773732-82-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – the change teaches `sbtsi_temp` to respect the controller’s
“extended range” bit so temperatures below 0 °C are no longer
misreported as large positives on newer AMD parts.

- `drivers/hwmon/sbtsi_temp.c:18-46` adds the missing config-bit
  definitions and the 49 000 m°C offset constant so the driver
  understands the SB-TSI extended range encoding documented in AMD PPR
  #56558.
- `drivers/hwmon/sbtsi_temp.c:52-56` extends `struct sbtsi_data` with
  cached `ext_range_mode`/`read_order` flags, letting runtime reads know
  whether the hardware is in extended range without re-querying the bus
  each sample.
- `drivers/hwmon/sbtsi_temp.c:96-118` now subtracts the 49 °C offset
  whenever `ext_range_mode` is set, ensuring `hwmon_temp_input` reports
  negative values correctly instead of bogus 0…255 °C readings seen on
  V3000 systems.
- `drivers/hwmon/sbtsi_temp.c:140-151` adjusts temperature limit writes
  by adding the same offset before clamping, so user-configured min/max
  thresholds stay aligned with the hardware representation in extended
  range mode.
- `drivers/hwmon/sbtsi_temp.c:178-190` reads `SBTSI_REG_CONFIG` once
  during probe to populate the two flags using `FIELD_GET()`, preserving
  the previous read-order behavior while enabling the new range
  handling.

Impact review: the patch is self-contained to one driver, follows
existing data paths, and fixes a user-visible regression (bad die
temps/limits on systems that ship with extended range enabled). No
architectural churn, no new dependencies, and it relies solely on fields
present since the driver was introduced—so it backports cleanly to
supported stable trees. The only behavioral change beyond the bug fix is
caching the config bits; SB-TSI documentation treats them as static
device configuration, so caching them reduces I²C traffic without adding
realistic risk. Overall this is a low-risk correctness fix and a good
stable backport candidate. Suggested next step: queue for the relevant
stable series that carry `drivers/hwmon/sbtsi_temp.c`.

 drivers/hwmon/sbtsi_temp.c | 46 +++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/sbtsi_temp.c b/drivers/hwmon/sbtsi_temp.c
index 3c839f56c4603..a6c439e376ff7 100644
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

