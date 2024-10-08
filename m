Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C71DFE34;
	Tue,  8 Oct 2024 13:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394121; cv=none; b=gjxOxLsmScatd8loZpasku8KbQQUhRdLdjymXSvENiVSCKDaWM2cQfImbhdtDAyQJZElsnBVkD+zv5onSJGWXXdiA/cE+adsoAIEa9GmVa1nqmVG8jGdrawQsWOyRZMuG/gzWswpJytg7JN4PjW8ZCgTN+5EGwIZupV1zMzwGVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394121; c=relaxed/simple;
	bh=oNtodfFZNrxpbSTuQ3zRRDzQGUK/uIMGMZAQmn5FzME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCCuB9BsoeoYiLgFUBf/v/TXsrLlS/B5Sj4/n/mCkvij+ohpHG7EFtmWCtQQ19fwVtPODccNLkN0EHPgGRwCAbxEcXHSSsQbsqEwS1DdNrMBCuZWPjUsrS3X83tsA2MQJT2UabKlCegl0OV5v9Du7PEsYSnVeFRSY767gZ0otC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+34lUJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+34lUJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C977EC4CECC;
	Tue,  8 Oct 2024 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394121;
	bh=oNtodfFZNrxpbSTuQ3zRRDzQGUK/uIMGMZAQmn5FzME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+34lUJB4TSxAISTPyHChpYkp9XHKukRQh1ZHFkhwYQLDwNfbP68i+JHH1nvOk30D
	 4kxo5cvQCdOQpioeUq2R+l6lMdr2icSUl+Zgo4ji7b7QERKIvtDtOYw2k4WLCFxA9l
	 yLNwPRTmNXCjsmZCv+sLowZOH3wZ7Bbb1CBVBzsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angel Iglesias <ang.iglesiasg@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 353/386] iio: pressure: bmp280: Allow multiple chips id per family of devices
Date: Tue,  8 Oct 2024 14:09:58 +0200
Message-ID: <20241008115643.273181807@linuxfoundation.org>
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

From: Angel Iglesias <ang.iglesiasg@gmail.com>

[ Upstream commit 33564435c8084ff29837c9ed9bb9574ec957751d ]

Improve device detection in certain chip families known to have
various chip IDs. When no ID matches, give a warning but follow
along what device said on the firmware side and try to configure
it.

Signed-off-by: Angel Iglesias <ang.iglesiasg@gmail.com>
Link: https://lore.kernel.org/r/eade22d11e9de4405ea19fdaa5a8249143ae94df.1697994521.git.ang.iglesiasg@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: b9065b0250e1 ("iio: pressure: bmp280: Fix regmap for BMP280 device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-core.c | 35 ++++++++++++++++++++++--------
 drivers/iio/pressure/bmp280.h      |  3 ++-
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index a65630d5742f0..ac72b175ffcc1 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -794,10 +794,12 @@ static int bmp280_chip_config(struct bmp280_data *data)
 }
 
 static const int bmp280_oversampling_avail[] = { 1, 2, 4, 8, 16 };
+static const u8 bmp280_chip_ids[] = { BMP280_CHIP_ID };
 
 const struct bmp280_chip_info bmp280_chip_info = {
 	.id_reg = BMP280_REG_ID,
-	.chip_id = BMP280_CHIP_ID,
+	.chip_id = bmp280_chip_ids,
+	.num_chip_id = ARRAY_SIZE(bmp280_chip_ids),
 	.regmap_config = &bmp280_regmap_config,
 	.start_up_time = 2000,
 	.channels = bmp280_channels,
@@ -846,9 +848,12 @@ static int bme280_chip_config(struct bmp280_data *data)
 	return bmp280_chip_config(data);
 }
 
+static const u8 bme280_chip_ids[] = { BME280_CHIP_ID };
+
 const struct bmp280_chip_info bme280_chip_info = {
 	.id_reg = BMP280_REG_ID,
-	.chip_id = BME280_CHIP_ID,
+	.chip_id = bme280_chip_ids,
+	.num_chip_id = ARRAY_SIZE(bme280_chip_ids),
 	.regmap_config = &bmp280_regmap_config,
 	.start_up_time = 2000,
 	.channels = bmp280_channels,
@@ -1220,10 +1225,12 @@ static int bmp380_chip_config(struct bmp280_data *data)
 
 static const int bmp380_oversampling_avail[] = { 1, 2, 4, 8, 16, 32 };
 static const int bmp380_iir_filter_coeffs_avail[] = { 1, 2, 4, 8, 16, 32, 64, 128};
+static const u8 bmp380_chip_ids[] = { BMP380_CHIP_ID };
 
 const struct bmp280_chip_info bmp380_chip_info = {
 	.id_reg = BMP380_REG_ID,
-	.chip_id = BMP380_CHIP_ID,
+	.chip_id = bmp380_chip_ids,
+	.num_chip_id = ARRAY_SIZE(bmp380_chip_ids),
 	.regmap_config = &bmp380_regmap_config,
 	.start_up_time = 2000,
 	.channels = bmp380_channels,
@@ -1720,10 +1727,12 @@ static int bmp580_chip_config(struct bmp280_data *data)
 }
 
 static const int bmp580_oversampling_avail[] = { 1, 2, 4, 8, 16, 32, 64, 128 };
+static const u8 bmp580_chip_ids[] = { BMP580_CHIP_ID, BMP580_CHIP_ID_ALT };
 
 const struct bmp280_chip_info bmp580_chip_info = {
 	.id_reg = BMP580_REG_CHIP_ID,
-	.chip_id = BMP580_CHIP_ID,
+	.chip_id = bmp580_chip_ids,
+	.num_chip_id = ARRAY_SIZE(bmp580_chip_ids),
 	.regmap_config = &bmp580_regmap_config,
 	.start_up_time = 2000,
 	.channels = bmp380_channels,
@@ -1983,10 +1992,12 @@ static int bmp180_chip_config(struct bmp280_data *data)
 
 static const int bmp180_oversampling_temp_avail[] = { 1 };
 static const int bmp180_oversampling_press_avail[] = { 1, 2, 4, 8 };
+static const u8 bmp180_chip_ids[] = { BMP180_CHIP_ID };
 
 const struct bmp280_chip_info bmp180_chip_info = {
 	.id_reg = BMP280_REG_ID,
-	.chip_id = BMP180_CHIP_ID,
+	.chip_id = bmp180_chip_ids,
+	.num_chip_id = ARRAY_SIZE(bmp180_chip_ids),
 	.regmap_config = &bmp180_regmap_config,
 	.start_up_time = 2000,
 	.channels = bmp280_channels,
@@ -2077,6 +2088,7 @@ int bmp280_common_probe(struct device *dev,
 	struct bmp280_data *data;
 	struct gpio_desc *gpiod;
 	unsigned int chip_id;
+	unsigned int i;
 	int ret;
 
 	indio_dev = devm_iio_device_alloc(dev, sizeof(*data));
@@ -2142,12 +2154,17 @@ int bmp280_common_probe(struct device *dev,
 	ret = regmap_read(regmap, data->chip_info->id_reg, &chip_id);
 	if (ret < 0)
 		return ret;
-	if (chip_id != data->chip_info->chip_id) {
-		dev_err(dev, "bad chip id: expected %x got %x\n",
-			data->chip_info->chip_id, chip_id);
-		return -EINVAL;
+
+	for (i = 0; i < data->chip_info->num_chip_id; i++) {
+		if (chip_id == data->chip_info->chip_id[i]) {
+			dev_info(dev, "0x%x is a known chip id for %s\n", chip_id, name);
+			break;
+		}
 	}
 
+	if (i == data->chip_info->num_chip_id)
+		dev_warn(dev, "bad chip id: 0x%x is not a known chip id\n", chip_id);
+
 	if (data->chip_info->preinit) {
 		ret = data->chip_info->preinit(data);
 		if (ret)
diff --git a/drivers/iio/pressure/bmp280.h b/drivers/iio/pressure/bmp280.h
index 9d9f4ce2baa6e..a44ea33221635 100644
--- a/drivers/iio/pressure/bmp280.h
+++ b/drivers/iio/pressure/bmp280.h
@@ -418,7 +418,8 @@ struct bmp280_data {
 
 struct bmp280_chip_info {
 	unsigned int id_reg;
-	const unsigned int chip_id;
+	const u8 *chip_id;
+	int num_chip_id;
 
 	const struct regmap_config *regmap_config;
 
-- 
2.43.0



