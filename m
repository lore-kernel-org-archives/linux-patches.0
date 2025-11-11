Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95BA261B77;
	Tue, 11 Nov 2025 01:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823965; cv=none; b=q4h5LLhsWI0JWVN4e+zcFr+PZwIeLCayW1y8076zxXKqrB4i78vBa6/stImbe8PqJZxry2uKNmrzQBAFcRFS1CYueMWB6o+fPEUqWDoc4p+PCgQUxUUROZEIuWZgGNHBy/b0nG/XlZhtpong3kngfof6LHsncjrTVs1qqm6Ntgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823965; c=relaxed/simple;
	bh=bbEH8/MvBagHuddh22niWUHmuR0q91sMixB4P7E2a5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGqjzDkvg2TWoaJrt7+IOaWfNsHMDypRgmRnxxw2roK+D1pN4J0xcuUGGWYtu/seoVk9bKY7cNOnIa9A44luDdwIydUo/Sw8dBn97Cb9rURKcIgeqjNHVSPXzCPYqMj+vvu3Fa7BHqgm/DuPvuemQ1F6MffUHQEQnoLsMdkct8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6ag8zsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6ag8zsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5115BC116B1;
	Tue, 11 Nov 2025 01:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823965;
	bh=bbEH8/MvBagHuddh22niWUHmuR0q91sMixB4P7E2a5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6ag8zsGJA7w9vBHrcurGUPLERy467fcyFfCw/mIC/ZFOkbqSTpaNbk52i6I1dVUU
	 wdFeVz8EztQ0ECJ8yXCOtFVB4bpqUcbjByLqKnxWWpPheKibXBA78afK2UP8RITl8G
	 L/inXjN5IBxnuDBiHBTw7dSaVPdpmyZGWElsKnyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 406/849] iio: adc: ad7124: do not require mclk
Date: Tue, 11 Nov 2025 09:39:36 +0900
Message-ID: <20251111004546.256801440@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit aead8e4cc04612f74c7277de137cc995df280829 ]

Make the "mclk" clock optional in the ad7124 driver. The MCLK is an
internal counter on the ADC, so it is not something that should be
coming from the devicetree. However, existing users may be using this
to essentially select the power mode of the ADC from the devicetree.
In order to not break those users, we have to keep the existing "mclk"
handling, but now it is optional.

Now, when the "mclk" clock is omitted from the devicetree, the driver
will default to the full power mode. Support for an external clock
and dynamic power mode switching can be added later if needed.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250828-iio-adc-ad7124-proper-clock-support-v3-2-0b317b4605e5@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 62 ++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 4d8c6bafd1c31..ed35d2a8bbf1b 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -174,7 +174,6 @@ struct ad7124_state {
 	struct ad_sigma_delta sd;
 	struct ad7124_channel *channels;
 	struct regulator *vref[4];
-	struct clk *mclk;
 	unsigned int adc_control;
 	unsigned int num_channels;
 	struct mutex cfgs_lock; /* lock for configs access */
@@ -254,7 +253,9 @@ static void ad7124_set_channel_odr(struct ad7124_state *st, unsigned int channel
 {
 	unsigned int fclk, odr_sel_bits;
 
-	fclk = clk_get_rate(st->mclk);
+	fclk = ad7124_master_clk_freq_hz[FIELD_GET(AD7124_ADC_CONTROL_POWER_MODE,
+						   st->adc_control)];
+
 	/*
 	 * FS[10:0] = fCLK / (fADC x 32) where:
 	 * fADC is the output data rate
@@ -1111,21 +1112,50 @@ static int ad7124_parse_channel_config(struct iio_dev *indio_dev,
 static int ad7124_setup(struct ad7124_state *st)
 {
 	struct device *dev = &st->sd.spi->dev;
-	unsigned int fclk, power_mode;
+	unsigned int power_mode;
+	struct clk *mclk;
 	int i, ret;
 
-	fclk = clk_get_rate(st->mclk);
-	if (!fclk)
-		return dev_err_probe(dev, -EINVAL, "Failed to get mclk rate\n");
+	/*
+	 * Always use full power mode for max performance. If needed, the driver
+	 * could be adapted to use a dynamic power mode based on the requested
+	 * output data rate.
+	 */
+	power_mode = AD7124_ADC_CONTROL_POWER_MODE_FULL;
 
-	/* The power mode changes the master clock frequency */
-	power_mode = ad7124_find_closest_match(ad7124_master_clk_freq_hz,
-					ARRAY_SIZE(ad7124_master_clk_freq_hz),
-					fclk);
-	if (fclk != ad7124_master_clk_freq_hz[power_mode]) {
-		ret = clk_set_rate(st->mclk, fclk);
-		if (ret)
-			return dev_err_probe(dev, ret, "Failed to set mclk rate\n");
+	/*
+	 * This "mclk" business is needed for backwards compatibility with old
+	 * devicetrees that specified a fake clock named "mclk" to select the
+	 * power mode.
+	 */
+	mclk = devm_clk_get_optional_enabled(dev, "mclk");
+	if (IS_ERR(mclk))
+		return dev_err_probe(dev, PTR_ERR(mclk), "Failed to get mclk\n");
+
+	if (mclk) {
+		unsigned long mclk_hz;
+
+		mclk_hz = clk_get_rate(mclk);
+		if (!mclk_hz)
+			return dev_err_probe(dev, -EINVAL,
+					     "Failed to get mclk rate\n");
+
+		/*
+		 * This logic is a bit backwards, which is why it is only here
+		 * for backwards compatibility. The driver should be able to set
+		 * the power mode as it sees fit and the f_clk/mclk rate should
+		 * be dynamic accordingly. But here, we are selecting a fixed
+		 * power mode based on the given "mclk" rate.
+		 */
+		power_mode = ad7124_find_closest_match(ad7124_master_clk_freq_hz,
+			ARRAY_SIZE(ad7124_master_clk_freq_hz), mclk_hz);
+
+		if (mclk_hz != ad7124_master_clk_freq_hz[power_mode]) {
+			ret = clk_set_rate(mclk, mclk_hz);
+			if (ret)
+				return dev_err_probe(dev, ret,
+						     "Failed to set mclk rate\n");
+		}
 	}
 
 	/* Set the power mode */
@@ -1303,10 +1333,6 @@ static int ad7124_probe(struct spi_device *spi)
 			return dev_err_probe(dev, ret, "Failed to register disable handler for regulator #%d\n", i);
 	}
 
-	st->mclk = devm_clk_get_enabled(&spi->dev, "mclk");
-	if (IS_ERR(st->mclk))
-		return dev_err_probe(dev, PTR_ERR(st->mclk), "Failed to get mclk\n");
-
 	ret = ad7124_soft_reset(st);
 	if (ret < 0)
 		return ret;
-- 
2.51.0



