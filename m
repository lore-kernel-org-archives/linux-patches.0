Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C621217D8BB;
	Tue, 30 Jul 2024 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358782; cv=none; b=TNUMNBtihCQLxGUm1vNoJ5fRI0a35DJs7EmeCAvx+Z/A67HwUOuvwznFEeAp080+t7Et8LkVISxZQvs7/ni36U1P20HJtHIKVveki0irgYSmbl/GL7Rf6/kLiqCrvKRYe0azvN8ddbJNXHpq4LYeJJACHiG/wgVfSgaz3s5DL9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358782; c=relaxed/simple;
	bh=kKTbZ590EK6XDUCB1sYDfsqhaCu/I700a2dty4i6L/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgRCFKHr6wZvJlUdUh1yTZanNaHSOUMm4Wi9WAtkQA7qRU4s68VF71KGgi+mZxOeXjitwqaxEMqRKyy5/rIze0t85rSJRX7yrmGe7cxlT5UiLOAVtQbn7z3Y6b3yhQqtPRnYzvFhINc1k7h879gaGZe4Cf5teXnbEzeJBnlZJP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW3J3gbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW3J3gbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DD2C4AF0A;
	Tue, 30 Jul 2024 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358782;
	bh=kKTbZ590EK6XDUCB1sYDfsqhaCu/I700a2dty4i6L/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qW3J3gbPA19vmZnHZCcgLlChBe96pBLyCJk9NfgnzcmecZ0XgF/lkEbGnXv+SoYe3
	 D/ZhYCAOIkWMVfVD7F2vOpnFAjvHpLagkjVA2231LKEnuMVrlysMU9izo5jgDDURiw
	 txTBT8iP3d0FSFFgZZ+Y/y3wFQhkvEAFAjkk7YKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 396/809] iio: adc: ad9467: use DMA safe buffer for spi
Date: Tue, 30 Jul 2024 17:44:32 +0200
Message-ID: <20240730151740.321871535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 7a8e7f13f99b31c85b77b362cb7b7a23fead11d3 ]

Make sure we use a DMA safe buffer (IIO_DMA_MINALIGN) for all the spi
transfers. Only relevant for writes since for reads
spi_write_then_read() is used which does not require DMA safe buffers.

Also note that for consistency, ad9467_spi_read() is also taking struct
ad9467_state as a parameter (even if not really needed).

Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240522-dev-ad9467-dma-v2-1-a37bec463632@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad9467.c | 65 +++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/iio/adc/ad9467.c b/drivers/iio/adc/ad9467.c
index 8f5b9c3f6e3d6..1fd2211e29642 100644
--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -141,9 +141,10 @@ struct ad9467_state {
 	struct gpio_desc		*pwrdown_gpio;
 	/* ensure consistent state obtained on multiple related accesses */
 	struct mutex			lock;
+	u8				buf[3] __aligned(IIO_DMA_MINALIGN);
 };
 
-static int ad9467_spi_read(struct spi_device *spi, unsigned int reg)
+static int ad9467_spi_read(struct ad9467_state *st, unsigned int reg)
 {
 	unsigned char tbuf[2], rbuf[1];
 	int ret;
@@ -151,7 +152,7 @@ static int ad9467_spi_read(struct spi_device *spi, unsigned int reg)
 	tbuf[0] = 0x80 | (reg >> 8);
 	tbuf[1] = reg & 0xFF;
 
-	ret = spi_write_then_read(spi,
+	ret = spi_write_then_read(st->spi,
 				  tbuf, ARRAY_SIZE(tbuf),
 				  rbuf, ARRAY_SIZE(rbuf));
 
@@ -161,35 +162,32 @@ static int ad9467_spi_read(struct spi_device *spi, unsigned int reg)
 	return rbuf[0];
 }
 
-static int ad9467_spi_write(struct spi_device *spi, unsigned int reg,
+static int ad9467_spi_write(struct ad9467_state *st, unsigned int reg,
 			    unsigned int val)
 {
-	unsigned char buf[3];
+	st->buf[0] = reg >> 8;
+	st->buf[1] = reg & 0xFF;
+	st->buf[2] = val;
 
-	buf[0] = reg >> 8;
-	buf[1] = reg & 0xFF;
-	buf[2] = val;
-
-	return spi_write(spi, buf, ARRAY_SIZE(buf));
+	return spi_write(st->spi, st->buf, ARRAY_SIZE(st->buf));
 }
 
 static int ad9467_reg_access(struct iio_dev *indio_dev, unsigned int reg,
 			     unsigned int writeval, unsigned int *readval)
 {
 	struct ad9467_state *st = iio_priv(indio_dev);
-	struct spi_device *spi = st->spi;
 	int ret;
 
 	if (!readval) {
 		guard(mutex)(&st->lock);
-		ret = ad9467_spi_write(spi, reg, writeval);
+		ret = ad9467_spi_write(st, reg, writeval);
 		if (ret)
 			return ret;
-		return ad9467_spi_write(spi, AN877_ADC_REG_TRANSFER,
+		return ad9467_spi_write(st, AN877_ADC_REG_TRANSFER,
 					AN877_ADC_TRANSFER_SYNC);
 	}
 
-	ret = ad9467_spi_read(spi, reg);
+	ret = ad9467_spi_read(st, reg);
 	if (ret < 0)
 		return ret;
 	*readval = ret;
@@ -295,7 +293,7 @@ static int ad9467_get_scale(struct ad9467_state *st, int *val, int *val2)
 	unsigned int i, vref_val;
 	int ret;
 
-	ret = ad9467_spi_read(st->spi, AN877_ADC_REG_VREF);
+	ret = ad9467_spi_read(st, AN877_ADC_REG_VREF);
 	if (ret < 0)
 		return ret;
 
@@ -330,31 +328,31 @@ static int ad9467_set_scale(struct ad9467_state *st, int val, int val2)
 			continue;
 
 		guard(mutex)(&st->lock);
-		ret = ad9467_spi_write(st->spi, AN877_ADC_REG_VREF,
+		ret = ad9467_spi_write(st, AN877_ADC_REG_VREF,
 				       info->scale_table[i][1]);
 		if (ret < 0)
 			return ret;
 
-		return ad9467_spi_write(st->spi, AN877_ADC_REG_TRANSFER,
+		return ad9467_spi_write(st, AN877_ADC_REG_TRANSFER,
 					AN877_ADC_TRANSFER_SYNC);
 	}
 
 	return -EINVAL;
 }
 
-static int ad9467_outputmode_set(struct spi_device *spi, unsigned int mode)
+static int ad9467_outputmode_set(struct ad9467_state *st, unsigned int mode)
 {
 	int ret;
 
-	ret = ad9467_spi_write(spi, AN877_ADC_REG_OUTPUT_MODE, mode);
+	ret = ad9467_spi_write(st, AN877_ADC_REG_OUTPUT_MODE, mode);
 	if (ret < 0)
 		return ret;
 
-	return ad9467_spi_write(spi, AN877_ADC_REG_TRANSFER,
+	return ad9467_spi_write(st, AN877_ADC_REG_TRANSFER,
 				AN877_ADC_TRANSFER_SYNC);
 }
 
-static int ad9647_calibrate_prepare(const struct ad9467_state *st)
+static int ad9647_calibrate_prepare(struct ad9467_state *st)
 {
 	struct iio_backend_data_fmt data = {
 		.enable = false,
@@ -362,17 +360,17 @@ static int ad9647_calibrate_prepare(const struct ad9467_state *st)
 	unsigned int c;
 	int ret;
 
-	ret = ad9467_spi_write(st->spi, AN877_ADC_REG_TEST_IO,
+	ret = ad9467_spi_write(st, AN877_ADC_REG_TEST_IO,
 			       AN877_ADC_TESTMODE_PN9_SEQ);
 	if (ret)
 		return ret;
 
-	ret = ad9467_spi_write(st->spi, AN877_ADC_REG_TRANSFER,
+	ret = ad9467_spi_write(st, AN877_ADC_REG_TRANSFER,
 			       AN877_ADC_TRANSFER_SYNC);
 	if (ret)
 		return ret;
 
-	ret = ad9467_outputmode_set(st->spi, st->info->default_output_mode);
+	ret = ad9467_outputmode_set(st, st->info->default_output_mode);
 	if (ret)
 		return ret;
 
@@ -390,7 +388,7 @@ static int ad9647_calibrate_prepare(const struct ad9467_state *st)
 	return iio_backend_chan_enable(st->back, 0);
 }
 
-static int ad9647_calibrate_polarity_set(const struct ad9467_state *st,
+static int ad9647_calibrate_polarity_set(struct ad9467_state *st,
 					 bool invert)
 {
 	enum iio_backend_sample_trigger trigger;
@@ -401,7 +399,7 @@ static int ad9647_calibrate_polarity_set(const struct ad9467_state *st,
 		if (invert)
 			phase |= AN877_ADC_INVERT_DCO_CLK;
 
-		return ad9467_spi_write(st->spi, AN877_ADC_REG_OUTPUT_PHASE,
+		return ad9467_spi_write(st, AN877_ADC_REG_OUTPUT_PHASE,
 					phase);
 	}
 
@@ -437,19 +435,18 @@ static unsigned int ad9467_find_optimal_point(const unsigned long *calib_map,
 	return cnt;
 }
 
-static int ad9467_calibrate_apply(const struct ad9467_state *st,
-				  unsigned int val)
+static int ad9467_calibrate_apply(struct ad9467_state *st, unsigned int val)
 {
 	unsigned int lane;
 	int ret;
 
 	if (st->info->has_dco) {
-		ret = ad9467_spi_write(st->spi, AN877_ADC_REG_OUTPUT_DELAY,
+		ret = ad9467_spi_write(st, AN877_ADC_REG_OUTPUT_DELAY,
 				       val);
 		if (ret)
 			return ret;
 
-		return ad9467_spi_write(st->spi, AN877_ADC_REG_TRANSFER,
+		return ad9467_spi_write(st, AN877_ADC_REG_TRANSFER,
 					AN877_ADC_TRANSFER_SYNC);
 	}
 
@@ -462,7 +459,7 @@ static int ad9467_calibrate_apply(const struct ad9467_state *st,
 	return 0;
 }
 
-static int ad9647_calibrate_stop(const struct ad9467_state *st)
+static int ad9647_calibrate_stop(struct ad9467_state *st)
 {
 	struct iio_backend_data_fmt data = {
 		.sign_extend = true,
@@ -487,16 +484,16 @@ static int ad9647_calibrate_stop(const struct ad9467_state *st)
 	}
 
 	mode = st->info->default_output_mode | AN877_ADC_OUTPUT_MODE_TWOS_COMPLEMENT;
-	ret = ad9467_outputmode_set(st->spi, mode);
+	ret = ad9467_outputmode_set(st, mode);
 	if (ret)
 		return ret;
 
-	ret = ad9467_spi_write(st->spi, AN877_ADC_REG_TEST_IO,
+	ret = ad9467_spi_write(st, AN877_ADC_REG_TEST_IO,
 			       AN877_ADC_TESTMODE_OFF);
 	if (ret)
 		return ret;
 
-	return ad9467_spi_write(st->spi, AN877_ADC_REG_TRANSFER,
+	return ad9467_spi_write(st, AN877_ADC_REG_TRANSFER,
 			       AN877_ADC_TRANSFER_SYNC);
 }
 
@@ -846,7 +843,7 @@ static int ad9467_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	id = ad9467_spi_read(spi, AN877_ADC_REG_CHIP_ID);
+	id = ad9467_spi_read(st, AN877_ADC_REG_CHIP_ID);
 	if (id != st->info->id) {
 		dev_err(&spi->dev, "Mismatch CHIP_ID, got 0x%X, expected 0x%X\n",
 			id, st->info->id);
-- 
2.43.0



