Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9B61DFD1;
	Tue,  8 Oct 2024 13:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392627; cv=none; b=RFcJmuRY7BG6TU2pQ4fROPLE4n4R18pqgR4BHSRkQKgvS5gpNA0W3wNZv9d1/gaUAviKG3/6mBaPo91MCjbkgtuyCYij4MfPFnLWGXGzX66BqF9wu20WOYRsYH/9omG2+C+Bdt5kI+2a/aIThk/XiJrKpsn61kqmR2h8bjRtyLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392627; c=relaxed/simple;
	bh=oYjeE5bzIEbnI0fV8xf8zAjMX/frGp4PnoGNzgiBKwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0xG7Bnf05PBd2ap8KEl3ZCLLh/7FM+mv2XkLQz25F2ctSW/386k1iGjKMhMDECIJ6f6ZEZoWLAEgRDETNNBM2Fg8v9AwWCzofUQOZ6AhFR0vu/Mah235cocwDs0HkaEE5pRaRBs2wukkYCpDzqlwPTWVuGjKzlXn1hr+xZ2CFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyYF6tbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyYF6tbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8034DC4CEC7;
	Tue,  8 Oct 2024 13:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392627;
	bh=oYjeE5bzIEbnI0fV8xf8zAjMX/frGp4PnoGNzgiBKwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyYF6tbZ9q4TbTjmNy+YHifmF5A2Xi5dyte0A/EDlK6do5d4X31UOA6GgR0YWgFK/
	 3ZlDPKcMSPsFO05NZZOnjWSrwWKV6sH1Af+qcdl1qDbIfcIPcUB95N2FgJlqgywxml
	 WMmx2JA+65Z0IHp+kzxlDQfLaYxu1Zw6gZ+lULpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 471/558] iio: pressure: bmp280: Fix regmap for BMP280 device
Date: Tue,  8 Oct 2024 14:08:21 +0200
Message-ID: <20241008115720.780531707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit b9065b0250e1705935445ede0a18c1850afe7b75 upstream.

Up to now, the BMP280 device is using the regmap of the BME280 which
has registers that exist only in the BME280 device.

Fixes: 14e8015f8569 ("iio: pressure: bmp280: split driver in logical parts")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://patch.msgid.link/20240711211558.106327-2-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c   |    2 -
 drivers/iio/pressure/bmp280-regmap.c |   45 ++++++++++++++++++++++++++++++++---
 drivers/iio/pressure/bmp280.h        |    1 
 3 files changed, 44 insertions(+), 4 deletions(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -882,7 +882,7 @@ const struct bmp280_chip_info bme280_chi
 	.id_reg = BMP280_REG_ID,
 	.chip_id = bme280_chip_ids,
 	.num_chip_id = ARRAY_SIZE(bme280_chip_ids),
-	.regmap_config = &bmp280_regmap_config,
+	.regmap_config = &bme280_regmap_config,
 	.start_up_time = 2000,
 	.channels = bmp280_channels,
 	.num_channels = 3,
--- a/drivers/iio/pressure/bmp280-regmap.c
+++ b/drivers/iio/pressure/bmp280-regmap.c
@@ -41,7 +41,7 @@ const struct regmap_config bmp180_regmap
 };
 EXPORT_SYMBOL_NS(bmp180_regmap_config, IIO_BMP280);
 
-static bool bmp280_is_writeable_reg(struct device *dev, unsigned int reg)
+static bool bme280_is_writeable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case BMP280_REG_CONFIG:
@@ -54,9 +54,37 @@ static bool bmp280_is_writeable_reg(stru
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
 {
 	switch (reg) {
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
+{
+	switch (reg) {
 	case BME280_REG_HUMIDITY_LSB:
 	case BME280_REG_HUMIDITY_MSB:
 	case BMP280_REG_TEMP_XLSB:
@@ -71,7 +99,6 @@ static bool bmp280_is_volatile_reg(struc
 		return false;
 	}
 }
-
 static bool bmp380_is_writeable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -167,7 +194,7 @@ const struct regmap_config bmp280_regmap
 	.reg_bits = 8,
 	.val_bits = 8,
 
-	.max_register = BME280_REG_HUMIDITY_LSB,
+	.max_register = BMP280_REG_TEMP_XLSB,
 	.cache_type = REGCACHE_RBTREE,
 
 	.writeable_reg = bmp280_is_writeable_reg,
@@ -175,6 +202,18 @@ const struct regmap_config bmp280_regmap
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
--- a/drivers/iio/pressure/bmp280.h
+++ b/drivers/iio/pressure/bmp280.h
@@ -464,6 +464,7 @@ extern const struct bmp280_chip_info bmp
 /* Regmap configurations */
 extern const struct regmap_config bmp180_regmap_config;
 extern const struct regmap_config bmp280_regmap_config;
+extern const struct regmap_config bme280_regmap_config;
 extern const struct regmap_config bmp380_regmap_config;
 extern const struct regmap_config bmp580_regmap_config;
 


