Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876B4129E74;
	Tue, 14 May 2024 10:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683793; cv=none; b=A+BcrtqDGBI1K2cMQc2QIttfKlDihstucNDQhvQoLFU+hEfWm64cgAtNv1L3ygXemayYZcksPaQYp/aQvsbV1OOiQm8UNvObOj0l0zpvcvDX4vAEqN/sGQXkqzJ9OW0xKSIFcF79t05CFTJbPxJbgixHPHiEjJNNyqmRwAP+1yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683793; c=relaxed/simple;
	bh=cXRhl6dkY8kN0xoK1WR5k5fq3WM86iqcnviK4JUZHeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHgVlTSQzDLq/kx5DpzwunRx3EY5WAeCmaNaffwD9+CoEvrE+6KZlh7u8PI2DNpxlwjalmzLwSUkbrM9RIR1dWJgqLCrz6G+jsKsDjPSuFdi9/RkAM3lFL+JMUWHosqsf65py+ks0fRtFSYxBtJOVAcHw4DlsCNghehgOJCRxKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SI7MZmi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SI7MZmi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC780C2BD10;
	Tue, 14 May 2024 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683793;
	bh=cXRhl6dkY8kN0xoK1WR5k5fq3WM86iqcnviK4JUZHeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SI7MZmi/4y+2/AXUGhoveAyG6XGPuRgWU8av+PXmP8c9at9J8PnLV0WILDoQa4NJL
	 Pp/dJwlAZMFm+zqcVLWpV277UXRq1sLXtuBDk8I0qVAo+pR5TpKbC8RoFQ37yaU3kq
	 ux8sKDJBkuL/Ukzq7APUBv3CVjxNPnF2zUEocBLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.8 275/336] iio: pressure: Fixes SPI support for BMP3xx devices
Date: Tue, 14 May 2024 12:17:59 +0200
Message-ID: <20240514101049.005461903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit 5ca29ea4e4073b3caba750efe155b1bd4c597ca9 upstream.

Bosch does not use unique BMPxxx_CHIP_ID for the different versions
of the device which leads to misidentification of devices if their
ID is used. Use a new value in the chip_info structure instead of
the BMPxxx_CHIP_ID, in order to choose the correct regmap_bus to
be used.

Fixes: a9dd9ba32311 ("iio: pressure: Fixes BMP38x and BMP390 SPI support")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240316110743.1998400-3-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c | 1 +
 drivers/iio/pressure/bmp280-spi.c  | 9 ++-------
 drivers/iio/pressure/bmp280.h      | 1 +
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index fe8734468ed3..62e9e93d915d 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1233,6 +1233,7 @@ const struct bmp280_chip_info bmp380_chip_info = {
 	.chip_id = bmp380_chip_ids,
 	.num_chip_id = ARRAY_SIZE(bmp380_chip_ids),
 	.regmap_config = &bmp380_regmap_config,
+	.spi_read_extra_byte = true,
 	.start_up_time = 2000,
 	.channels = bmp380_channels,
 	.num_channels = 2,
diff --git a/drivers/iio/pressure/bmp280-spi.c b/drivers/iio/pressure/bmp280-spi.c
index 038d36aad3eb..4e19ea0b4d39 100644
--- a/drivers/iio/pressure/bmp280-spi.c
+++ b/drivers/iio/pressure/bmp280-spi.c
@@ -96,15 +96,10 @@ static int bmp280_spi_probe(struct spi_device *spi)
 
 	chip_info = spi_get_device_match_data(spi);
 
-	switch (chip_info->chip_id[0]) {
-	case BMP380_CHIP_ID:
-	case BMP390_CHIP_ID:
+	if (chip_info->spi_read_extra_byte)
 		bmp_regmap_bus = &bmp380_regmap_bus;
-		break;
-	default:
+	else
 		bmp_regmap_bus = &bmp280_regmap_bus;
-		break;
-	}
 
 	regmap = devm_regmap_init(&spi->dev,
 				  bmp_regmap_bus,
diff --git a/drivers/iio/pressure/bmp280.h b/drivers/iio/pressure/bmp280.h
index 4012387d7956..5812a344ed8e 100644
--- a/drivers/iio/pressure/bmp280.h
+++ b/drivers/iio/pressure/bmp280.h
@@ -423,6 +423,7 @@ struct bmp280_chip_info {
 	int num_chip_id;
 
 	const struct regmap_config *regmap_config;
+	bool spi_read_extra_byte;
 
 	const struct iio_chan_spec *channels;
 	int num_channels;
-- 
2.45.0



