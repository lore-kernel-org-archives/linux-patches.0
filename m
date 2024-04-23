Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6758C143C57;
	Tue, 23 Apr 2024 21:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908605; cv=none; b=F5rmwwbmKeVsajj5uOdSd8DaICWB1MLu3ZSrxVkRAIBdPAQqlLWYAhYQd71yhlwwFenBbCZybROVkidACWyHbWdQi+UihAHnmQ16czd5ppwAJbXjV+bVtZ0hyR5yDpp06qm7q9L2BfsVnWor5KrzAxe/m89LEtw1ppSx0P3X2iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908605; c=relaxed/simple;
	bh=xJorBsdxMlluQWgs/1/LbUrLz+a3vhivj36VjGnNWrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCBQIzlMbmeaF+mfEjNBbg9uopDs1qh366HT1VGHhwMtPXmjKR1STOcdYA5tT1kjlUrDtFhr8mAaEtGXHSh3uqfWWR3iKqnQwnWFAh0D10ReCJ2rfqhhJKmn58fj/2Gj0Trm9NhHrimLov2Dn2bdTRyRdW7CgC6aofBc84NJlRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEvUTqdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEvUTqdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3651AC116B1;
	Tue, 23 Apr 2024 21:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908605;
	bh=xJorBsdxMlluQWgs/1/LbUrLz+a3vhivj36VjGnNWrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEvUTqdkql33GO/o51KY3l+4hjI/aC6hL1miKMgv9vk5cPDC8E4JMnev80cGdzy+R
	 28R/ayyvkpoAJK+F5p6btZrIc4m0Mj1ryTUnn5uVYu0nnXr0l/qioutZDrfvRvkpky
	 u/VoiUvTaokr/g3DNkUBNReZHyoXNSNJICKVd9tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/158] ASoC: ti: Convert Pandora ASoC to GPIO descriptors
Date: Tue, 23 Apr 2024 14:38:28 -0700
Message-ID: <20240423213858.071601050@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 319e6ac143b9e9048e527ab9dd2aabb8fdf3d60f ]

The Pandora uses GPIO descriptors pretty much exclusively, but not
for ASoC, so let's fix it. Register the pins in a descriptor table
in the machine since the ASoC device is not using device tree.

Use static locals for the GPIO descriptors because I'm not able
to experient with better state storage on any real hardware. Others
using the Pandora can come afterwards and improve this.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Link: https://lore.kernel.org/r/20230926-descriptors-asoc-ti-v1-4-60cf4f8adbc5@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 10 +++++
 sound/soc/ti/omap3pandora.c        | 63 +++++++++++-------------------
 2 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index c1c0121f478d6..b947bacf23a37 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -275,9 +275,19 @@ static struct platform_device pandora_backlight = {
 	.id	= -1,
 };
 
+static struct gpiod_lookup_table pandora_soc_audio_gpios = {
+	.dev_id = "soc-audio",
+	.table = {
+		GPIO_LOOKUP("gpio-112-127", 6, "dac", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("gpio-0-15", 14, "amp", GPIO_ACTIVE_HIGH),
+		{ }
+	},
+};
+
 static void __init omap3_pandora_legacy_init(void)
 {
 	platform_device_register(&pandora_backlight);
+	gpiod_add_lookup_table(&pandora_soc_audio_gpios);
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 
diff --git a/sound/soc/ti/omap3pandora.c b/sound/soc/ti/omap3pandora.c
index a287e9747c2a1..fa92ed97dfe3b 100644
--- a/sound/soc/ti/omap3pandora.c
+++ b/sound/soc/ti/omap3pandora.c
@@ -7,7 +7,7 @@
 
 #include <linux/clk.h>
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/delay.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
@@ -21,12 +21,11 @@
 
 #include "omap-mcbsp.h"
 
-#define OMAP3_PANDORA_DAC_POWER_GPIO	118
-#define OMAP3_PANDORA_AMP_POWER_GPIO	14
-
 #define PREFIX "ASoC omap3pandora: "
 
 static struct regulator *omap3pandora_dac_reg;
+static struct gpio_desc *dac_power_gpio;
+static struct gpio_desc *amp_power_gpio;
 
 static int omap3pandora_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params)
@@ -78,9 +77,9 @@ static int omap3pandora_dac_event(struct snd_soc_dapm_widget *w,
 			return ret;
 		}
 		mdelay(1);
-		gpio_set_value(OMAP3_PANDORA_DAC_POWER_GPIO, 1);
+		gpiod_set_value(dac_power_gpio, 1);
 	} else {
-		gpio_set_value(OMAP3_PANDORA_DAC_POWER_GPIO, 0);
+		gpiod_set_value(dac_power_gpio, 0);
 		mdelay(1);
 		regulator_disable(omap3pandora_dac_reg);
 	}
@@ -92,9 +91,9 @@ static int omap3pandora_hp_event(struct snd_soc_dapm_widget *w,
 	struct snd_kcontrol *k, int event)
 {
 	if (SND_SOC_DAPM_EVENT_ON(event))
-		gpio_set_value(OMAP3_PANDORA_AMP_POWER_GPIO, 1);
+		gpiod_set_value(amp_power_gpio, 1);
 	else
-		gpio_set_value(OMAP3_PANDORA_AMP_POWER_GPIO, 0);
+		gpiod_set_value(amp_power_gpio, 0);
 
 	return 0;
 }
@@ -229,35 +228,10 @@ static int __init omap3pandora_soc_init(void)
 
 	pr_info("OMAP3 Pandora SoC init\n");
 
-	ret = gpio_request(OMAP3_PANDORA_DAC_POWER_GPIO, "dac_power");
-	if (ret) {
-		pr_err(PREFIX "Failed to get DAC power GPIO\n");
-		return ret;
-	}
-
-	ret = gpio_direction_output(OMAP3_PANDORA_DAC_POWER_GPIO, 0);
-	if (ret) {
-		pr_err(PREFIX "Failed to set DAC power GPIO direction\n");
-		goto fail0;
-	}
-
-	ret = gpio_request(OMAP3_PANDORA_AMP_POWER_GPIO, "amp_power");
-	if (ret) {
-		pr_err(PREFIX "Failed to get amp power GPIO\n");
-		goto fail0;
-	}
-
-	ret = gpio_direction_output(OMAP3_PANDORA_AMP_POWER_GPIO, 0);
-	if (ret) {
-		pr_err(PREFIX "Failed to set amp power GPIO direction\n");
-		goto fail1;
-	}
-
 	omap3pandora_snd_device = platform_device_alloc("soc-audio", -1);
 	if (omap3pandora_snd_device == NULL) {
 		pr_err(PREFIX "Platform device allocation failed\n");
-		ret = -ENOMEM;
-		goto fail1;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(omap3pandora_snd_device, &snd_soc_card_omap3pandora);
@@ -268,6 +242,20 @@ static int __init omap3pandora_soc_init(void)
 		goto fail2;
 	}
 
+	dac_power_gpio = devm_gpiod_get(&omap3pandora_snd_device->dev,
+					"dac", GPIOD_OUT_LOW);
+	if (IS_ERR(dac_power_gpio)) {
+		ret = PTR_ERR(dac_power_gpio);
+		goto fail3;
+	}
+
+	amp_power_gpio = devm_gpiod_get(&omap3pandora_snd_device->dev,
+					"amp", GPIOD_OUT_LOW);
+	if (IS_ERR(amp_power_gpio)) {
+		ret = PTR_ERR(amp_power_gpio);
+		goto fail3;
+	}
+
 	omap3pandora_dac_reg = regulator_get(&omap3pandora_snd_device->dev, "vcc");
 	if (IS_ERR(omap3pandora_dac_reg)) {
 		pr_err(PREFIX "Failed to get DAC regulator from %s: %ld\n",
@@ -283,10 +271,7 @@ static int __init omap3pandora_soc_init(void)
 	platform_device_del(omap3pandora_snd_device);
 fail2:
 	platform_device_put(omap3pandora_snd_device);
-fail1:
-	gpio_free(OMAP3_PANDORA_AMP_POWER_GPIO);
-fail0:
-	gpio_free(OMAP3_PANDORA_DAC_POWER_GPIO);
+
 	return ret;
 }
 module_init(omap3pandora_soc_init);
@@ -295,8 +280,6 @@ static void __exit omap3pandora_soc_exit(void)
 {
 	regulator_put(omap3pandora_dac_reg);
 	platform_device_unregister(omap3pandora_snd_device);
-	gpio_free(OMAP3_PANDORA_AMP_POWER_GPIO);
-	gpio_free(OMAP3_PANDORA_DAC_POWER_GPIO);
 }
 module_exit(omap3pandora_soc_exit);
 
-- 
2.43.0



