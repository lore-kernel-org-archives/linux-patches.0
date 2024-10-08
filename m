Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A681E00B3;
	Tue,  8 Oct 2024 13:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394135; cv=none; b=UGPiPMxzqcJTFE7mbA64TiqHzXLS2Nq6Km+zhkYpBOg3102v5shL0phKkNEhqzPljbpxAdy1SIBs8bUyVKlsre3oiwZeWBgEl1Si0kPOeWf9DHidA6ELQ/jlqpfXazw1ToIr3Blvzt6/NjZo9dyymJbFTxUnN71oOAALITDR4qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394135; c=relaxed/simple;
	bh=7BUFmQs8ma2rJCHqWrKDEN1oUbEkgWj9t2KT3Vm6pO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvWUpuM7jtkiI2qJRGK9EFDxz5qkVckMQmDHIbqfFAmZtR3nmjRXtURPmljjuJ84Dt7UCZEiI1lo7CA92AxRCWwNvVZxToHc0kaCs60WnK4oUVkdT/71NZjOe3nWaNOZwxNOqcgeT2bxKM+o5aiCQZovO0B9RGQFCPfHSf36J8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STUdxfpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STUdxfpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F05DC4CEC7;
	Tue,  8 Oct 2024 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394134;
	bh=7BUFmQs8ma2rJCHqWrKDEN1oUbEkgWj9t2KT3Vm6pO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STUdxfpw9taGygk/5dIDSjfAPflcIwdr8uw1HwBHbgm7bKfj3IP0/mDFgG2AvEq0i
	 bHN3hdmEtlujFp2/VUjAkx18Qfq1IlFE+XJcWUnnuQW7xvNKTWaJs91JRV0NNwlF0D
	 2PBIwiFzZCQJMSUbjMbqDpkXAzCvUac43HQcrPRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 356/386] iio: pressure: bmp280: Fix regmap for BMP280 device
Date: Tue,  8 Oct 2024 14:10:01 +0200
Message-ID: <20241008115643.393259020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

[ Upstream commit b9065b0250e1705935445ede0a18c1850afe7b75 ]

Up to now, the BMP280 device is using the regmap of the BME280 which
has registers that exist only in the BME280 device.

Fixes: 14e8015f8569 ("iio: pressure: bmp280: split driver in logical parts")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://patch.msgid.link/20240711211558.106327-2-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-core.c   |  2 +-
 drivers/iio/pressure/bmp280-regmap.c | 45 ++++++++++++++++++++++++++--
 drivers/iio/pressure/bmp280.h        |  1 +
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index 8f70fd72f132a..3ba718b11c464 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -852,7 +852,7 @@ const struct bmp280_chip_info bme280_chip_info = {
 	.id_reg = BMP280_REG_ID,
 	.chip_id = bme280_chip_ids,
 	.num_chip_id = ARRAY_SIZE(bme280_chip_ids),
-	.regmap_config = &bmp280_regmap_config,
+	.regmap_config = &bme280_regmap_config,
 	.start_up_time = 2000,
 	.channels = bmp280_channels,
 	.num_channels = 3,
diff --git a/drivers/iio/pressure/bmp280-regmap.c b/drivers/iio/pressure/bmp280-regmap.c
index fa52839474b18..d27d68edd9065 100644
--- a/drivers/iio/pressure/bmp280-regmap.c
+++ b/drivers/iio/pressure/bmp280-regmap.c
@@ -41,7 +41,7 @@ const struct regmap_config bmp180_regmap_config = {
 };
 EXPORT_SYMBOL_NS(bmp180_regmap_config, IIO_BMP280);
 
-static bool bmp280_is_writeable_reg(struct device *dev, unsigned int reg)
+static bool bme280_is_writeable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case BMP280_REG_CONFIG:
@@ -54,7 +54,35 @@ static bool bmp280_is_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
+static bool bmp280_is_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case BMP280_REG_CONFIG:
+	case BMP280_REG_CTRL_MEAS:
+	case BMP280_REG_RESET:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static bool bmp280_is_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case BMP280_REG_TEMP_XLSB:
+	case BMP280_REG_TEMP_LSB:
+	case BMP280_REG_TEMP_MSB:
+	case BMP280_REG_PRESS_XLSB:
+	case BMP280_REG_PRESS_LSB:
+	case BMP280_REG_PRESS_MSB:
+	case BMP280_REG_STATUS:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool bme280_is_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case BME280_REG_HUMIDITY_LSB:
@@ -71,7 +99,6 @@ static bool bmp280_is_volatile_reg(struct device *dev, unsigned int reg)
 		return false;
 	}
 }
-
 static bool bmp380_is_writeable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -167,7 +194,7 @@ const struct regmap_config bmp280_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-	.max_register = BME280_REG_HUMIDITY_LSB,
+	.max_register = BMP280_REG_TEMP_XLSB,
 	.cache_type = REGCACHE_RBTREE,
 
 	.writeable_reg = bmp280_is_writeable_reg,
@@ -175,6 +202,18 @@ const struct regmap_config bmp280_regmap_config = {
 };
 EXPORT_SYMBOL_NS(bmp280_regmap_config, IIO_BMP280);
 
+const struct regmap_config bme280_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = BME280_REG_HUMIDITY_LSB,
+	.cache_type = REGCACHE_RBTREE,
+
+	.writeable_reg = bme280_is_writeable_reg,
+	.volatile_reg = bme280_is_volatile_reg,
+};
+EXPORT_SYMBOL_NS(bme280_regmap_config, IIO_BMP280);
+
 const struct regmap_config bmp380_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
diff --git a/drivers/iio/pressure/bmp280.h b/drivers/iio/pressure/bmp280.h
index 1a6903a917add..b60e551b7d318 100644
--- a/drivers/iio/pressure/bmp280.h
+++ b/drivers/iio/pressure/bmp280.h
@@ -468,6 +468,7 @@ extern const struct bmp280_chip_info bmp580_chip_info;
 /* Regmap configurations */
 extern const struct regmap_config bmp180_regmap_config;
 extern const struct regmap_config bmp280_regmap_config;
+extern const struct regmap_config bme280_regmap_config;
 extern const struct regmap_config bmp380_regmap_config;
 extern const struct regmap_config bmp580_regmap_config;
 
-- 
2.43.0



