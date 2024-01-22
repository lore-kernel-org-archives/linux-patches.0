Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AE14E1D8;
	Tue, 23 Jan 2024 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969992; cv=none; b=T6gtp/SKoM4DJ0Z7mWFM3cPgLPp2A3QWjvsEwJrnL305zhsWWxDHjI+DaP1SHyrWGGrNH+JnTn7UtpL5fJn94LXYjmNVW4hjTi9+CuA2Xyn+h9+nIe1uvTXiJByQqPGfTVCLU3zttZroJC524jDCGDHA3cM2kwKH8ARRg5hySiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969992; c=relaxed/simple;
	bh=mJwm7xESli2TF76Wiavti+8pDyFL0opb0YVsRVVMLik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C35W0HbBKygiY7pvD4WpVFEudG2jcb3viODLY8tIlYt93AyV9zY8kkFObKysKHvMrl7Bd+Cqi1CU/73d9olqqm4fRXjYzlOmTQW1CbdmoEshcvQSiNDks+7EMnloJ7TqmUE8FCHzB5+/9NmbSAgIdTEPEByQYUZIojTVnKMqNP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiNLDXzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiNLDXzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6793CC433F1;
	Tue, 23 Jan 2024 00:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969992;
	bh=mJwm7xESli2TF76Wiavti+8pDyFL0opb0YVsRVVMLik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiNLDXzRD+lF7w2j7CQLk8njsly69z96JVeWoBEC3ji7eTm4WY0b8HhOuW51xzr9s
	 cTTewQYMgNqQP2PU+vNOAznYLWzTBeZ8vVqcPJwr0kpRKeZfLRVExqNpwaOXcvQhLn
	 djoVtLGPwwjRuVsqdApuBcVLb+SChno/c9J21U3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 531/641] iio: adc: ad9467: fix scale setting
Date: Mon, 22 Jan 2024 15:57:15 -0800
Message-ID: <20240122235834.727695325@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit b73f08bb7fe5a0901646ca5ceaa1e7a2d5ee6293 ]

When reading in_voltage_scale we can get something like:

root@analog:/sys/bus/iio/devices/iio:device2# cat in_voltage_scale
0.038146

However, when reading the available options:

root@analog:/sys/bus/iio/devices/iio:device2# cat
in_voltage_scale_available
2000.000000 2100.000006 2200.000007 2300.000008 2400.000009 2500.000010

which does not make sense. Moreover, when trying to set a new scale we
get an error because there's no call to __ad9467_get_scale() to give us
values as given when reading in_voltage_scale. Fix it by computing the
available scales during probe and properly pass the list when
.read_available() is called.

While at it, change to use .read_available() from iio_info. Also note
that to properly fix this, adi-axi-adc.c has to be changed accordingly.

Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20231207-iio-backend-prep-v2-4-a4a33bc4d70e@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad9467.c            | 47 ++++++++++++++++++
 drivers/iio/adc/adi-axi-adc.c       | 74 ++++++-----------------------
 include/linux/iio/adc/adi-axi-adc.h |  4 ++
 3 files changed, 66 insertions(+), 59 deletions(-)

diff --git a/drivers/iio/adc/ad9467.c b/drivers/iio/adc/ad9467.c
index 104c6d394a3e..f668313730cb 100644
--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -120,6 +120,7 @@ struct ad9467_state {
 	struct spi_device		*spi;
 	struct clk			*clk;
 	unsigned int			output_mode;
+	unsigned int                    (*scales)[2];
 
 	struct gpio_desc		*pwrdown_gpio;
 	/* ensure consistent state obtained on multiple related accesses */
@@ -216,6 +217,7 @@ static void __ad9467_get_scale(struct adi_axi_adc_conv *conv, int index,
 	.channel = _chan,						\
 	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) |		\
 		BIT(IIO_CHAN_INFO_SAMP_FREQ),				\
+	.info_mask_shared_by_type_available = BIT(IIO_CHAN_INFO_SCALE), \
 	.scan_index = _si,						\
 	.scan_type = {							\
 		.sign = _sign,						\
@@ -370,6 +372,26 @@ static int ad9467_write_raw(struct adi_axi_adc_conv *conv,
 	}
 }
 
+static int ad9467_read_avail(struct adi_axi_adc_conv *conv,
+			     struct iio_chan_spec const *chan,
+			     const int **vals, int *type, int *length,
+			     long mask)
+{
+	const struct adi_axi_adc_chip_info *info = conv->chip_info;
+	struct ad9467_state *st = adi_axi_adc_conv_priv(conv);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SCALE:
+		*vals = (const int *)st->scales;
+		*type = IIO_VAL_INT_PLUS_MICRO;
+		/* Values are stored in a 2D matrix */
+		*length = info->num_scales * 2;
+		return IIO_AVAIL_LIST;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int ad9467_outputmode_set(struct spi_device *spi, unsigned int mode)
 {
 	int ret;
@@ -382,6 +404,26 @@ static int ad9467_outputmode_set(struct spi_device *spi, unsigned int mode)
 				AN877_ADC_TRANSFER_SYNC);
 }
 
+static int ad9467_scale_fill(struct adi_axi_adc_conv *conv)
+{
+	const struct adi_axi_adc_chip_info *info = conv->chip_info;
+	struct ad9467_state *st = adi_axi_adc_conv_priv(conv);
+	unsigned int i, val1, val2;
+
+	st->scales = devm_kmalloc_array(&st->spi->dev, info->num_scales,
+					sizeof(*st->scales), GFP_KERNEL);
+	if (!st->scales)
+		return -ENOMEM;
+
+	for (i = 0; i < info->num_scales; i++) {
+		__ad9467_get_scale(conv, i, &val1, &val2);
+		st->scales[i][0] = val1;
+		st->scales[i][1] = val2;
+	}
+
+	return 0;
+}
+
 static int ad9467_preenable_setup(struct adi_axi_adc_conv *conv)
 {
 	struct ad9467_state *st = adi_axi_adc_conv_priv(conv);
@@ -440,6 +482,10 @@ static int ad9467_probe(struct spi_device *spi)
 
 	conv->chip_info = &info->axi_adc_info;
 
+	ret = ad9467_scale_fill(conv);
+	if (ret)
+		return ret;
+
 	id = ad9467_spi_read(spi, AN877_ADC_REG_CHIP_ID);
 	if (id != conv->chip_info->id) {
 		dev_err(&spi->dev, "Mismatch CHIP_ID, got 0x%X, expected 0x%X\n",
@@ -450,6 +496,7 @@ static int ad9467_probe(struct spi_device *spi)
 	conv->reg_access = ad9467_reg_access;
 	conv->write_raw = ad9467_write_raw;
 	conv->read_raw = ad9467_read_raw;
+	conv->read_avail = ad9467_read_avail;
 	conv->preenable_setup = ad9467_preenable_setup;
 
 	st->output_mode = info->default_output_mode |
diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index aff0532a974a..ae83ada7f9f2 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -144,6 +144,20 @@ static int adi_axi_adc_write_raw(struct iio_dev *indio_dev,
 	return conv->write_raw(conv, chan, val, val2, mask);
 }
 
+static int adi_axi_adc_read_avail(struct iio_dev *indio_dev,
+				  struct iio_chan_spec const *chan,
+				  const int **vals, int *type, int *length,
+				  long mask)
+{
+	struct adi_axi_adc_state *st = iio_priv(indio_dev);
+	struct adi_axi_adc_conv *conv = &st->client->conv;
+
+	if (!conv->read_avail)
+		return -EOPNOTSUPP;
+
+	return conv->read_avail(conv, chan, vals, type, length, mask);
+}
+
 static int adi_axi_adc_update_scan_mode(struct iio_dev *indio_dev,
 					const unsigned long *scan_mask)
 {
@@ -228,69 +242,11 @@ struct adi_axi_adc_conv *devm_adi_axi_adc_conv_register(struct device *dev,
 }
 EXPORT_SYMBOL_NS_GPL(devm_adi_axi_adc_conv_register, IIO_ADI_AXI);
 
-static ssize_t in_voltage_scale_available_show(struct device *dev,
-					       struct device_attribute *attr,
-					       char *buf)
-{
-	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
-	struct adi_axi_adc_state *st = iio_priv(indio_dev);
-	struct adi_axi_adc_conv *conv = &st->client->conv;
-	size_t len = 0;
-	int i;
-
-	for (i = 0; i < conv->chip_info->num_scales; i++) {
-		const unsigned int *s = conv->chip_info->scale_table[i];
-
-		len += scnprintf(buf + len, PAGE_SIZE - len,
-				 "%u.%06u ", s[0], s[1]);
-	}
-	buf[len - 1] = '\n';
-
-	return len;
-}
-
-static IIO_DEVICE_ATTR_RO(in_voltage_scale_available, 0);
-
-enum {
-	ADI_AXI_ATTR_SCALE_AVAIL,
-};
-
-#define ADI_AXI_ATTR(_en_, _file_)			\
-	[ADI_AXI_ATTR_##_en_] = &iio_dev_attr_##_file_.dev_attr.attr
-
-static struct attribute *adi_axi_adc_attributes[] = {
-	ADI_AXI_ATTR(SCALE_AVAIL, in_voltage_scale_available),
-	NULL
-};
-
-static umode_t axi_adc_attr_is_visible(struct kobject *kobj,
-				       struct attribute *attr, int n)
-{
-	struct device *dev = kobj_to_dev(kobj);
-	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
-	struct adi_axi_adc_state *st = iio_priv(indio_dev);
-	struct adi_axi_adc_conv *conv = &st->client->conv;
-
-	switch (n) {
-	case ADI_AXI_ATTR_SCALE_AVAIL:
-		if (!conv->chip_info->num_scales)
-			return 0;
-		return attr->mode;
-	default:
-		return attr->mode;
-	}
-}
-
-static const struct attribute_group adi_axi_adc_attribute_group = {
-	.attrs = adi_axi_adc_attributes,
-	.is_visible = axi_adc_attr_is_visible,
-};
-
 static const struct iio_info adi_axi_adc_info = {
 	.read_raw = &adi_axi_adc_read_raw,
 	.write_raw = &adi_axi_adc_write_raw,
-	.attrs = &adi_axi_adc_attribute_group,
 	.update_scan_mode = &adi_axi_adc_update_scan_mode,
+	.read_avail = &adi_axi_adc_read_avail,
 };
 
 static const struct adi_axi_adc_core_info adi_axi_adc_10_0_a_info = {
diff --git a/include/linux/iio/adc/adi-axi-adc.h b/include/linux/iio/adc/adi-axi-adc.h
index 52620e5b8052..b7904992d561 100644
--- a/include/linux/iio/adc/adi-axi-adc.h
+++ b/include/linux/iio/adc/adi-axi-adc.h
@@ -41,6 +41,7 @@ struct adi_axi_adc_chip_info {
  * @reg_access		IIO debugfs_reg_access hook for the client ADC
  * @read_raw		IIO read_raw hook for the client ADC
  * @write_raw		IIO write_raw hook for the client ADC
+ * @read_avail		IIO read_avail hook for the client ADC
  */
 struct adi_axi_adc_conv {
 	const struct adi_axi_adc_chip_info		*chip_info;
@@ -54,6 +55,9 @@ struct adi_axi_adc_conv {
 	int (*write_raw)(struct adi_axi_adc_conv *conv,
 			 struct iio_chan_spec const *chan,
 			 int val, int val2, long mask);
+	int (*read_avail)(struct adi_axi_adc_conv *conv,
+			  struct iio_chan_spec const *chan,
+			  const int **val, int *type, int *length, long mask);
 };
 
 struct adi_axi_adc_conv *devm_adi_axi_adc_conv_register(struct device *dev,
-- 
2.43.0



