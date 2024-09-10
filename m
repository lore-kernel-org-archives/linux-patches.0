Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0A7581D;
	Tue, 10 Sep 2024 10:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964598; cv=none; b=dGOGQ3p7FqyfH6k5LZfNDc24bWj8usbbm2x1HgMC+cC+YShIhwB59u0USzwk5vFqp/P/j/hfGeU2ZWFyEDP0IM52rixb+nprdtOaoGB2uMGCGPdEQcMWmfJT3oWnC1F5FlI62ycP0/zOstewDKTvb322hKNBa8aDQaYvs6VTZgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964598; c=relaxed/simple;
	bh=peVc3cJyyWZnW4DC6SuL9ZmKIhjI9m3lWdpPryCNUI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msSbucQ0g56LPaj+UI9x0IBPCBPCzUi3yzKIF6ELbGiSGsYcjjAooR6WPAvWyp448OtRKiq5dPnXJ+nKSXkuvslhlu5/BpvYR0EycXy1J/SMi7wEO87BMgXYKYvuHM0C3fPE8oZ6kFikD9H8DgmyPzVEPcArsGLMbXW+j++55i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECSKlTk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECSKlTk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46564C4CEC3;
	Tue, 10 Sep 2024 10:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964597;
	bh=peVc3cJyyWZnW4DC6SuL9ZmKIhjI9m3lWdpPryCNUI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECSKlTk1ByY/7lYNXXpmqb5a7h2JAuBHMYIX3KpHkQ33f6JXWxOBm+sqHnnZPCgtI
	 qfABcWUGa18WtnxBy7lVak/ftBg11eH0cm3FWI2OItZk+D1lYd9yEw+MZlpeK11C/3
	 c1av9SQF1g/IyihYCqruSVfwB4RQi82YAIhSaqik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 209/269] iio: adc: ad7606: remove frstdata check for serial mode
Date: Tue, 10 Sep 2024 11:33:16 +0200
Message-ID: <20240910092615.487653189@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Guillaume Stols <gstols@baylibre.com>

commit 90826e08468ba7fb35d8b39645b22d9e80004afe upstream.

The current implementation attempts to recover from an eventual glitch
in the clock by checking frstdata state after reading the first
channel's sample: If frstdata is low, it will reset the chip and
return -EIO.

This will only work in parallel mode, where frstdata pin is set low
after the 2nd sample read starts.

For the serial mode, according to the datasheet, "The FRSTDATA output
returns to a logic low following the 16th SCLK falling edge.", thus
after the Xth pulse, X being the number of bits in a sample, the check
will always be true, and the driver will not work at all in serial
mode if frstdata(optional) is defined in the devicetree as it will
reset the chip, and return -EIO every time read_sample is called.

Hence, this check must be removed for serial mode.

Fixes: b9618c0cacd7 ("staging: IIO: ADC: New driver for AD7606/AD7606-6/AD7606-4")
Signed-off-by: Guillaume Stols <gstols@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240702-cleanup-ad7606-v3-1-18d5ea18770e@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7606.c     |   28 +------------------------
 drivers/iio/adc/ad7606.h     |    2 +
 drivers/iio/adc/ad7606_par.c |   48 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 49 insertions(+), 29 deletions(-)

--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -49,7 +49,7 @@ static const unsigned int ad7616_oversam
 	1, 2, 4, 8, 16, 32, 64, 128,
 };
 
-static int ad7606_reset(struct ad7606_state *st)
+int ad7606_reset(struct ad7606_state *st)
 {
 	if (st->gpio_reset) {
 		gpiod_set_value(st->gpio_reset, 1);
@@ -60,6 +60,7 @@ static int ad7606_reset(struct ad7606_st
 
 	return -ENODEV;
 }
+EXPORT_SYMBOL_NS_GPL(ad7606_reset, IIO_AD7606);
 
 static int ad7606_reg_access(struct iio_dev *indio_dev,
 			     unsigned int reg,
@@ -88,31 +89,6 @@ static int ad7606_read_samples(struct ad
 {
 	unsigned int num = st->chip_info->num_channels - 1;
 	u16 *data = st->data;
-	int ret;
-
-	/*
-	 * The frstdata signal is set to high while and after reading the sample
-	 * of the first channel and low for all other channels. This can be used
-	 * to check that the incoming data is correctly aligned. During normal
-	 * operation the data should never become unaligned, but some glitch or
-	 * electrostatic discharge might cause an extra read or clock cycle.
-	 * Monitoring the frstdata signal allows to recover from such failure
-	 * situations.
-	 */
-
-	if (st->gpio_frstdata) {
-		ret = st->bops->read_block(st->dev, 1, data);
-		if (ret)
-			return ret;
-
-		if (!gpiod_get_value(st->gpio_frstdata)) {
-			ad7606_reset(st);
-			return -EIO;
-		}
-
-		data++;
-		num--;
-	}
 
 	return st->bops->read_block(st->dev, num, data);
 }
--- a/drivers/iio/adc/ad7606.h
+++ b/drivers/iio/adc/ad7606.h
@@ -151,6 +151,8 @@ int ad7606_probe(struct device *dev, int
 		 const char *name, unsigned int id,
 		 const struct ad7606_bus_ops *bops);
 
+int ad7606_reset(struct ad7606_state *st);
+
 enum ad7606_supported_device_ids {
 	ID_AD7605_4,
 	ID_AD7606_8,
--- a/drivers/iio/adc/ad7606_par.c
+++ b/drivers/iio/adc/ad7606_par.c
@@ -7,6 +7,7 @@
 
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
+#include <linux/gpio/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/err.h>
@@ -21,8 +22,29 @@ static int ad7606_par16_read_block(struc
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct ad7606_state *st = iio_priv(indio_dev);
 
-	insw((unsigned long)st->base_address, buf, count);
 
+	/*
+	 * On the parallel interface, the frstdata signal is set to high while
+	 * and after reading the sample of the first channel and low for all
+	 * other channels.  This can be used to check that the incoming data is
+	 * correctly aligned.  During normal operation the data should never
+	 * become unaligned, but some glitch or electrostatic discharge might
+	 * cause an extra read or clock cycle.  Monitoring the frstdata signal
+	 * allows to recover from such failure situations.
+	 */
+	int num = count;
+	u16 *_buf = buf;
+
+	if (st->gpio_frstdata) {
+		insw((unsigned long)st->base_address, _buf, 1);
+		if (!gpiod_get_value(st->gpio_frstdata)) {
+			ad7606_reset(st);
+			return -EIO;
+		}
+		_buf++;
+		num--;
+	}
+	insw((unsigned long)st->base_address, _buf, num);
 	return 0;
 }
 
@@ -35,8 +57,28 @@ static int ad7606_par8_read_block(struct
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct ad7606_state *st = iio_priv(indio_dev);
-
-	insb((unsigned long)st->base_address, buf, count * 2);
+	/*
+	 * On the parallel interface, the frstdata signal is set to high while
+	 * and after reading the sample of the first channel and low for all
+	 * other channels.  This can be used to check that the incoming data is
+	 * correctly aligned.  During normal operation the data should never
+	 * become unaligned, but some glitch or electrostatic discharge might
+	 * cause an extra read or clock cycle.  Monitoring the frstdata signal
+	 * allows to recover from such failure situations.
+	 */
+	int num = count;
+	u16 *_buf = buf;
+
+	if (st->gpio_frstdata) {
+		insb((unsigned long)st->base_address, _buf, 2);
+		if (!gpiod_get_value(st->gpio_frstdata)) {
+			ad7606_reset(st);
+			return -EIO;
+		}
+		_buf++;
+		num--;
+	}
+	insb((unsigned long)st->base_address, _buf, num * 2);
 
 	return 0;
 }


