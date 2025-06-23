Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E08B23BF9F;
	Mon, 23 Jun 2025 13:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684769; cv=none; b=jUb4oO7oe7qvnjzFEQ93awXJ7jM/2DIbQoTFaFPvDL6JVO8+9ql9MdTHaIb7PW1K8ZPpPOY8cOim6KkGkR3oxhISHD+deneIcAZqKUhXGyzBFMHhdU9tsCt7BYbuZDEo7talxccAPYBpjYMtjFF78OLJvpjDmXVCljaInjXi9ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684769; c=relaxed/simple;
	bh=tna1mXEk+CXaPTqq5rFgUd7hexb4tdfbMtp0+2jlAxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng53emSUKu0PABwaX53+dtZz+gMBSofurFyETemkQW3LNRF4ERQvA+fDdcy3QhRlFiC4lKHrHrHsCbZEw3Z16ENtAZM0+zMXsBq/S0Rt9GIBXFBSTYRwx5kBt26+Dc/dQFdhr6QQu0IUc7fAlhqTthuRARqUwO2ldlNygpQujDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpzPQqR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpzPQqR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C642FC4CEEA;
	Mon, 23 Jun 2025 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684769;
	bh=tna1mXEk+CXaPTqq5rFgUd7hexb4tdfbMtp0+2jlAxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpzPQqR/mMVHRJijT6KzYZRnnzHcOj5tQsFGOUlLxdETyxLjGbYYG/y0gWii2rJgT
	 Vd2T/QGaKdj7GEk8i9/ITvs0ljEriRtH7+BbAH4l7IibecHKQuyYSN3UdPPSVTI0pg
	 0dB4AnPwXZooLtNvFqHmNgAUQLeNsCgjm59/MZcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 204/592] iio: adc: ad7173: fix compiling without gpiolib
Date: Mon, 23 Jun 2025 15:02:42 +0200
Message-ID: <20250623130705.141135219@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit c553aa1b03719400a30d9387477190d4743fc1de upstream.

Fix compiling the ad7173 driver when CONFIG_GPIOLIB is not set by
selecting GPIOLIB to be always enabled and remove the #if.

Commit 031bdc8aee01 ("iio: adc: ad7173: add calibration support") placed
unrelated code in the middle of the #if IS_ENABLED(CONFIG_GPIOLIB) block
which caused the reported compile error.

However, later commit 7530ed2aaa3f ("iio: adc: ad7173: add openwire
detection support for single conversions") makes use of the gpio regmap
even when we aren't providing gpio controller support. So it makes more
sense to always enable GPIOLIB rather than trying to make it optional.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504220824.HVrTVov1-lkp@intel.com/
Fixes: 031bdc8aee01 ("iio: adc: ad7173: add calibration support")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250422-iio-adc-ad7173-fix-compile-without-gpiolib-v1-1-295f2c990754@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig  |  5 +++--
 drivers/iio/adc/ad7173.c | 15 +--------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 6529df1a498c..ba746754a816 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -129,8 +129,9 @@ config AD7173
 	tristate "Analog Devices AD7173 driver"
 	depends on SPI_MASTER
 	select AD_SIGMA_DELTA
-	select GPIO_REGMAP if GPIOLIB
-	select REGMAP_SPI if GPIOLIB
+	select GPIOLIB
+	select GPIO_REGMAP
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices AD7173 and similar ADC
 	  Currently supported models:
diff --git a/drivers/iio/adc/ad7173.c b/drivers/iio/adc/ad7173.c
index 69de5886474c..b3e6bd2a55d7 100644
--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -230,10 +230,8 @@ struct ad7173_state {
 	unsigned long long *config_cnts;
 	struct clk *ext_clk;
 	struct clk_hw int_clk_hw;
-#if IS_ENABLED(CONFIG_GPIOLIB)
 	struct regmap *reg_gpiocon_regmap;
 	struct gpio_regmap *gpio_regmap;
-#endif
 };
 
 static unsigned int ad4115_sinc5_data_rates[] = {
@@ -288,8 +286,6 @@ static const char *const ad7173_clk_sel[] = {
 	"ext-clk", "xtal"
 };
 
-#if IS_ENABLED(CONFIG_GPIOLIB)
-
 static const struct regmap_range ad7173_range_gpio[] = {
 	regmap_reg_range(AD7173_REG_GPIO, AD7173_REG_GPIO),
 };
@@ -543,12 +539,6 @@ static int ad7173_gpio_init(struct ad7173_state *st)
 
 	return 0;
 }
-#else
-static int ad7173_gpio_init(struct ad7173_state *st)
-{
-	return 0;
-}
-#endif /* CONFIG_GPIOLIB */
 
 static struct ad7173_state *ad_sigma_delta_to_ad7173(struct ad_sigma_delta *sd)
 {
@@ -1797,10 +1787,7 @@ static int ad7173_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	if (IS_ENABLED(CONFIG_GPIOLIB))
-		return ad7173_gpio_init(st);
-
-	return 0;
+	return ad7173_gpio_init(st);
 }
 
 static const struct of_device_id ad7173_of_match[] = {
-- 
2.50.0



