Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8554714900B;
	Mon,  6 Jan 2025 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177223; cv=none; b=rN0aouFPzEaj1YtfZl5nhk0GqFsGvZ9baNjCJUfil0VMPBgxz8D9l3VHbwSTyfd5VeqWdcJBuUPeZMybuhAjZZT/vR0/8ex5AGE4oXu9arLFhoS4PKWyB5kDeZv0I1uBMab13eWlDCwJUO0nW0/+WHvxkS4o/dVpSqLtm24IEGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177223; c=relaxed/simple;
	bh=OwPlZY31EboWBmDBZE+309UauQGhjvvrnks6PUvn8BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etgl4+OxHH9QyYOhKiB/qk1m+T6cU/7bohp3R9Krl5K7mPxxJaH2VnYJaXTPCP8vxIhKogN/pJYKK8XRFMPYBbqnzVCxxvECcjcmSK5SkGO4kQzKnsxWkzXXz3ak8dnAOsdJcYsIrdQUhL2t6bkZ2nmlO5WzJ+U3+BA1XL61M4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdeljnD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdeljnD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09116C4CED2;
	Mon,  6 Jan 2025 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177223;
	bh=OwPlZY31EboWBmDBZE+309UauQGhjvvrnks6PUvn8BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdeljnD0b/W43G8o+U4d+AVOX1ImUUONiL8ED98stRTb32FT3zxfCozrILA2vk3nC
	 k9+oVhH7Dc4MivcG0jpytCeY5abmjojMoY5wryZJEs46jv2SzIFse0Sl4jwPP8I7zr
	 AkZEHJ64yDCl/9P7UD7tp7wZvxWukIyanX3WEqEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alisa-Dariana Roman <alisa.roman@analog.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/222] iio: adc: ad7192: Convert from of specific to fwnode property handling
Date: Mon,  6 Jan 2025 16:14:25 +0100
Message-ID: <20250106151152.918420440@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit c3708c829a0662af429897a90aed46b70f14a50b ]

Enables use of with other firmwware types.
Removes a case of device tree specific handlers that might get copied
into new drivers.

Cc: Alisa-Dariana Roman <alisa.roman@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240218172731.1023367-6-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: b7f99fa1b64a ("iio: adc: ad7192: properly check spi_get_device_match_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index b64fd365f83f..ecaf87af539b 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -16,7 +16,9 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
-#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/property.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -360,19 +362,19 @@ static inline bool ad7192_valid_external_frequency(u32 freq)
 		freq <= AD7192_EXT_FREQ_MHZ_MAX);
 }
 
-static int ad7192_of_clock_select(struct ad7192_state *st)
+static int ad7192_clock_select(struct ad7192_state *st)
 {
-	struct device_node *np = st->sd.spi->dev.of_node;
+	struct device *dev = &st->sd.spi->dev;
 	unsigned int clock_sel;
 
 	clock_sel = AD7192_CLK_INT;
 
 	/* use internal clock */
 	if (!st->mclk) {
-		if (of_property_read_bool(np, "adi,int-clock-output-enable"))
+		if (device_property_read_bool(dev, "adi,int-clock-output-enable"))
 			clock_sel = AD7192_CLK_INT_CO;
 	} else {
-		if (of_property_read_bool(np, "adi,clock-xtal"))
+		if (device_property_read_bool(dev, "adi,clock-xtal"))
 			clock_sel = AD7192_CLK_EXT_MCLK1_2;
 		else
 			clock_sel = AD7192_CLK_EXT_MCLK2;
@@ -381,7 +383,7 @@ static int ad7192_of_clock_select(struct ad7192_state *st)
 	return clock_sel;
 }
 
-static int ad7192_setup(struct iio_dev *indio_dev, struct device_node *np)
+static int ad7192_setup(struct iio_dev *indio_dev, struct device *dev)
 {
 	struct ad7192_state *st = iio_priv(indio_dev);
 	bool rej60_en, refin2_en;
@@ -403,7 +405,7 @@ static int ad7192_setup(struct iio_dev *indio_dev, struct device_node *np)
 	id &= AD7192_ID_MASK;
 
 	if (id != st->chip_info->chip_id)
-		dev_warn(&st->sd.spi->dev, "device ID query failed (0x%X != 0x%X)\n",
+		dev_warn(dev, "device ID query failed (0x%X != 0x%X)\n",
 			 id, st->chip_info->chip_id);
 
 	st->mode = AD7192_MODE_SEL(AD7192_MODE_IDLE) |
@@ -412,31 +414,31 @@ static int ad7192_setup(struct iio_dev *indio_dev, struct device_node *np)
 
 	st->conf = AD7192_CONF_GAIN(0);
 
-	rej60_en = of_property_read_bool(np, "adi,rejection-60-Hz-enable");
+	rej60_en = device_property_read_bool(dev, "adi,rejection-60-Hz-enable");
 	if (rej60_en)
 		st->mode |= AD7192_MODE_REJ60;
 
-	refin2_en = of_property_read_bool(np, "adi,refin2-pins-enable");
+	refin2_en = device_property_read_bool(dev, "adi,refin2-pins-enable");
 	if (refin2_en && st->chip_info->chip_id != CHIPID_AD7195)
 		st->conf |= AD7192_CONF_REFSEL;
 
 	st->conf &= ~AD7192_CONF_CHOP;
 	st->f_order = AD7192_NO_SYNC_FILTER;
 
-	buf_en = of_property_read_bool(np, "adi,buffer-enable");
+	buf_en = device_property_read_bool(dev, "adi,buffer-enable");
 	if (buf_en)
 		st->conf |= AD7192_CONF_BUF;
 
-	bipolar = of_property_read_bool(np, "bipolar");
+	bipolar = device_property_read_bool(dev, "bipolar");
 	if (!bipolar)
 		st->conf |= AD7192_CONF_UNIPOLAR;
 
-	burnout_curr_en = of_property_read_bool(np,
-						"adi,burnout-currents-enable");
+	burnout_curr_en = device_property_read_bool(dev,
+						    "adi,burnout-currents-enable");
 	if (burnout_curr_en && buf_en) {
 		st->conf |= AD7192_CONF_BURN;
 	} else if (burnout_curr_en) {
-		dev_warn(&st->sd.spi->dev,
+		dev_warn(dev,
 			 "Can't enable burnout currents: see CHOP or buffer\n");
 	}
 
@@ -1036,9 +1038,7 @@ static int ad7192_probe(struct spi_device *spi)
 	}
 	st->int_vref_mv = ret / 1000;
 
-	st->chip_info = of_device_get_match_data(&spi->dev);
-	if (!st->chip_info)
-		st->chip_info = (void *)spi_get_device_id(spi)->driver_data;
+	st->chip_info = spi_get_device_match_data(spi);
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
@@ -1065,7 +1065,7 @@ static int ad7192_probe(struct spi_device *spi)
 	if (IS_ERR(st->mclk))
 		return PTR_ERR(st->mclk);
 
-	st->clock_sel = ad7192_of_clock_select(st);
+	st->clock_sel = ad7192_clock_select(st);
 
 	if (st->clock_sel == AD7192_CLK_EXT_MCLK1_2 ||
 	    st->clock_sel == AD7192_CLK_EXT_MCLK2) {
@@ -1077,7 +1077,7 @@ static int ad7192_probe(struct spi_device *spi)
 		}
 	}
 
-	ret = ad7192_setup(indio_dev, spi->dev.of_node);
+	ret = ad7192_setup(indio_dev, &spi->dev);
 	if (ret)
 		return ret;
 
-- 
2.39.5



