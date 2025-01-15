Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DCF156644;
	Wed, 15 Jan 2025 10:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938401; cv=none; b=u0dGDq/yG/r6eMMgcoCnRFT/mtyjuJzdWr2CacZ18ogxHBrvnDM3CR61bjRmdVqQS8cyvxWKRcSamfdiOe37BRKaa2XGVipJsVPaa/A9KNwsfU9viDbvK5zA+361buIMB4s+BixOfXnLVZSZmWtwKaHGkOVbXarRXclzvi09LsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938401; c=relaxed/simple;
	bh=xlmwhLE4b6kRDIzpZdpyu6nM2GCRhUfzb0lJFd6QL88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ngvIc+ZrOOK7+4Mdf5oYEqEBnBYksbBdpgcNI1BExziPVTv04ooGpaSJ1RU3RXvfGOznC5yO7+gHofGHdvDEmAoVQcipKALfvrfy0q6ic32V30qF2MZ/pml+7iIzDWSyWyZ6Q6apJdvcpBgkEXHDxk2n2578JMNqGyuksOlPCUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EKyCUeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EKyCUeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F34BC4CEDF;
	Wed, 15 Jan 2025 10:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938401;
	bh=xlmwhLE4b6kRDIzpZdpyu6nM2GCRhUfzb0lJFd6QL88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EKyCUeqVWRl7ylE6Z/h1LTHOd8akCSNcTB3IFwBHKS+tofjcAsI5qePnE+hd7YFT
	 B8DAGbO9rr3p7cyv6jy0jiqhETsJicxDa/KbUOdgOD9CLH+GCxjSGLxIC5RAEmeock
	 XskoDdezYQU7HSV3IvDYOQbCqqrRgmm+YL4yIu+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	David Lechner <dlechner@baylibre.com>,
	Guillaume Ranquet <granquet@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 172/189] iio: adc: ad7173: fix using shared static info struct
Date: Wed, 15 Jan 2025 11:37:48 +0100
Message-ID: <20250115103613.269879162@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 36a44e05cd807a54e5ffad4b96d0d67f68ad8576 upstream.

Fix a possible race condition during driver probe in the ad7173 driver
due to using a shared static info struct. If more that one instance of
the driver is probed at the same time, some of the info could be
overwritten by the other instance, leading to incorrect operation.

To fix this, make the static info struct const so that it is read-only
and make a copy of the info struct for each instance of the driver that
can be modified.

Reported-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Fixes: 76a1e6a42802 ("iio: adc: ad7173: add AD7173 driver")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Tested-by: Guillaume Ranquet <granquet@baylibre.com>
Link: https://patch.msgid.link/20241127-iio-adc-ad7313-fix-non-const-info-struct-v2-1-b6d7022b7466@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -198,6 +198,7 @@ struct ad7173_channel {
 
 struct ad7173_state {
 	struct ad_sigma_delta sd;
+	struct ad_sigma_delta_info sigma_delta_info;
 	const struct ad7173_device_info *info;
 	struct ad7173_channel *channels;
 	struct regulator_bulk_data regulators[3];
@@ -733,7 +734,7 @@ static int ad7173_disable_one(struct ad_
 	return ad_sd_write_reg(sd, AD7173_REG_CH(chan), 2, 0);
 }
 
-static struct ad_sigma_delta_info ad7173_sigma_delta_info = {
+static const struct ad_sigma_delta_info ad7173_sigma_delta_info = {
 	.set_channel = ad7173_set_channel,
 	.append_status = ad7173_append_status,
 	.disable_all = ad7173_disable_all,
@@ -1371,7 +1372,7 @@ static int ad7173_fw_parse_device_config
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "Interrupt 'rdy' is required\n");
 
-	ad7173_sigma_delta_info.irq_line = ret;
+	st->sigma_delta_info.irq_line = ret;
 
 	return ad7173_fw_parse_channel_config(indio_dev);
 }
@@ -1404,8 +1405,9 @@ static int ad7173_probe(struct spi_devic
 	spi->mode = SPI_MODE_3;
 	spi_setup(spi);
 
-	ad7173_sigma_delta_info.num_slots = st->info->num_configs;
-	ret = ad_sd_init(&st->sd, indio_dev, spi, &ad7173_sigma_delta_info);
+	st->sigma_delta_info = ad7173_sigma_delta_info;
+	st->sigma_delta_info.num_slots = st->info->num_configs;
+	ret = ad_sd_init(&st->sd, indio_dev, spi, &st->sigma_delta_info);
 	if (ret)
 		return ret;
 


