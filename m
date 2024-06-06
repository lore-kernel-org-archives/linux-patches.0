Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191FE197508;
	Thu,  6 Jun 2024 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683507; cv=none; b=q7HtGARb8QvOHi+kJV1F1T6OYJ8jmQKjC2MPvYoAZLoWSATOSgC3X70Ia7gILaGduIYXqtt/KU5iwvhSGaQNwaL/tPuvCNTcHbNGaLROmdc/kXN3ZJDPJvcdAusatfNE3i2k1C/w4U9oYxIsAhwcablBpzj0xTufsrmkfMBbkko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683507; c=relaxed/simple;
	bh=wQcfZX5zy14Jcq4DfJwAH4IkgQAhlJ/GLWyG6dripYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USLGw1NpspIVPg1VePmPqkfGfMaf2DGnyelsvwimWpAI2CHwol5GaLxOS89roXhHEWwaYlKbLUMeeyuI+Im4lO9KhL3OOPtCU01x4TY8aVQwScbL4YdPIdJLfhyiHelxP0cTRxzh2/c6u8C9vlpqFpruAcqk6OVcE+BQYPUd1KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZYelAPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZYelAPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B6DC32786;
	Thu,  6 Jun 2024 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683506;
	bh=wQcfZX5zy14Jcq4DfJwAH4IkgQAhlJ/GLWyG6dripYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZYelAPijFHnldfrsuL6FGh0YszPpsO0cHG3k989xPCgJ988adfCl5W+6sD4GCYl7
	 OSwEOZKunNnVz3Wj9COqcHhzSdeziX/YKEhKVvgA8cx4hbfEsJPVKwBrvsPXMLmzPk
	 OIexi21vcbQTlV88BfIyP/HiIY2eEoxlKtnEARFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 448/744] iio: adc: adi-axi-adc: convert to regmap
Date: Thu,  6 Jun 2024 16:02:00 +0200
Message-ID: <20240606131746.870951545@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 21aa971d3e295c2c81d0887f8a3e85a95dd687c5 ]

Use MMIO regmap interface. It makes things easier for manipulating bits.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231207-iio-backend-prep-v2-8-a4a33bc4d70e@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: cf1c833f89e7 ("iio: adc: adi-axi-adc: only error out in major version mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/Kconfig       |  2 +-
 drivers/iio/adc/adi-axi-adc.c | 85 +++++++++++++++++++++--------------
 2 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 517b3db114b8e..0b94bda8be361 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -292,7 +292,7 @@ config ADI_AXI_ADC
 	select IIO_BUFFER
 	select IIO_BUFFER_HW_CONSUMER
 	select IIO_BUFFER_DMAENGINE
-	depends on HAS_IOMEM
+	select REGMAP_MMIO
 	depends on OF
 	help
 	  Say yes here to build support for Analog Devices Generic
diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index ae83ada7f9f2d..c247ff1541d28 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 
 #include <linux/iio/iio.h>
@@ -62,7 +63,7 @@ struct adi_axi_adc_state {
 	struct mutex				lock;
 
 	struct adi_axi_adc_client		*client;
-	void __iomem				*regs;
+	struct regmap				*regmap;
 };
 
 struct adi_axi_adc_client {
@@ -90,19 +91,6 @@ void *adi_axi_adc_conv_priv(struct adi_axi_adc_conv *conv)
 }
 EXPORT_SYMBOL_NS_GPL(adi_axi_adc_conv_priv, IIO_ADI_AXI);
 
-static void adi_axi_adc_write(struct adi_axi_adc_state *st,
-			      unsigned int reg,
-			      unsigned int val)
-{
-	iowrite32(val, st->regs + reg);
-}
-
-static unsigned int adi_axi_adc_read(struct adi_axi_adc_state *st,
-				     unsigned int reg)
-{
-	return ioread32(st->regs + reg);
-}
-
 static int adi_axi_adc_config_dma_buffer(struct device *dev,
 					 struct iio_dev *indio_dev)
 {
@@ -163,17 +151,20 @@ static int adi_axi_adc_update_scan_mode(struct iio_dev *indio_dev,
 {
 	struct adi_axi_adc_state *st = iio_priv(indio_dev);
 	struct adi_axi_adc_conv *conv = &st->client->conv;
-	unsigned int i, ctrl;
+	unsigned int i;
+	int ret;
 
 	for (i = 0; i < conv->chip_info->num_channels; i++) {
-		ctrl = adi_axi_adc_read(st, ADI_AXI_REG_CHAN_CTRL(i));
-
 		if (test_bit(i, scan_mask))
-			ctrl |= ADI_AXI_REG_CHAN_CTRL_ENABLE;
+			ret = regmap_set_bits(st->regmap,
+					      ADI_AXI_REG_CHAN_CTRL(i),
+					      ADI_AXI_REG_CHAN_CTRL_ENABLE);
 		else
-			ctrl &= ~ADI_AXI_REG_CHAN_CTRL_ENABLE;
-
-		adi_axi_adc_write(st, ADI_AXI_REG_CHAN_CTRL(i), ctrl);
+			ret = regmap_clear_bits(st->regmap,
+						ADI_AXI_REG_CHAN_CTRL(i),
+						ADI_AXI_REG_CHAN_CTRL_ENABLE);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -310,21 +301,32 @@ static int adi_axi_adc_setup_channels(struct device *dev,
 	}
 
 	for (i = 0; i < conv->chip_info->num_channels; i++) {
-		adi_axi_adc_write(st, ADI_AXI_REG_CHAN_CTRL(i),
-				  ADI_AXI_REG_CHAN_CTRL_DEFAULTS);
+		ret = regmap_write(st->regmap, ADI_AXI_REG_CHAN_CTRL(i),
+				   ADI_AXI_REG_CHAN_CTRL_DEFAULTS);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
 }
 
-static void axi_adc_reset(struct adi_axi_adc_state *st)
+static int axi_adc_reset(struct adi_axi_adc_state *st)
 {
-	adi_axi_adc_write(st, ADI_AXI_REG_RSTN, 0);
+	int ret;
+
+	ret = regmap_write(st->regmap, ADI_AXI_REG_RSTN, 0);
+	if (ret)
+		return ret;
+
 	mdelay(10);
-	adi_axi_adc_write(st, ADI_AXI_REG_RSTN, ADI_AXI_REG_RSTN_MMCM_RSTN);
+	ret = regmap_write(st->regmap, ADI_AXI_REG_RSTN,
+			   ADI_AXI_REG_RSTN_MMCM_RSTN);
+	if (ret)
+		return ret;
+
 	mdelay(10);
-	adi_axi_adc_write(st, ADI_AXI_REG_RSTN,
-			  ADI_AXI_REG_RSTN_RSTN | ADI_AXI_REG_RSTN_MMCM_RSTN);
+	return regmap_write(st->regmap, ADI_AXI_REG_RSTN,
+			    ADI_AXI_REG_RSTN_RSTN | ADI_AXI_REG_RSTN_MMCM_RSTN);
 }
 
 static void adi_axi_adc_cleanup(void *data)
@@ -335,12 +337,20 @@ static void adi_axi_adc_cleanup(void *data)
 	module_put(cl->dev->driver->owner);
 }
 
+static const struct regmap_config axi_adc_regmap_config = {
+	.val_bits = 32,
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.max_register = 0x0800,
+};
+
 static int adi_axi_adc_probe(struct platform_device *pdev)
 {
 	struct adi_axi_adc_conv *conv;
 	struct iio_dev *indio_dev;
 	struct adi_axi_adc_client *cl;
 	struct adi_axi_adc_state *st;
+	void __iomem *base;
 	unsigned int ver;
 	int ret;
 
@@ -361,15 +371,24 @@ static int adi_axi_adc_probe(struct platform_device *pdev)
 	cl->state = st;
 	mutex_init(&st->lock);
 
-	st->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(st->regs))
-		return PTR_ERR(st->regs);
+	base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	st->regmap = devm_regmap_init_mmio(&pdev->dev, base,
+					   &axi_adc_regmap_config);
+	if (IS_ERR(st->regmap))
+		return PTR_ERR(st->regmap);
 
 	conv = &st->client->conv;
 
-	axi_adc_reset(st);
+	ret = axi_adc_reset(st);
+	if (ret)
+		return ret;
 
-	ver = adi_axi_adc_read(st, ADI_AXI_REG_VERSION);
+	ret = regmap_read(st->regmap, ADI_AXI_REG_VERSION, &ver);
+	if (ret)
+		return ret;
 
 	if (cl->info->version > ver) {
 		dev_err(&pdev->dev,
-- 
2.43.0



