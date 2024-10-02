Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370081CF28B;
	Wed,  2 Oct 2024 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875617; cv=none; b=qfGu19xOjRasE7zL3qS74qkDlYUrsbe5cwwBloyg6GHeOUO3p4W9iyN4u8cJvbgKgv8/TEnskWwlHoKrWnGmXbM2dFntR74sskPugMhY5gLdQONCNcJhqlCQIf3Ag4mYTj24TjsRq+r2JNHOWouORC75kCuwV9+d2H1ZkuayfOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875617; c=relaxed/simple;
	bh=6GasvonWjp5bIetq1snWvv9pubs6buN8cl+0yTBk4No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV/GVCk5cNQLOMXFeHNHDKfXJhlCopXq1h3rzHxniLfncuaOqzKa0djV2pSFvGqxuGl1CBXNqL3vBJgD5x44cPamkSj2BTOaeg5MMtRr7TmMwFRwjdqSDoFOgXWhxlwLEqDAgAX75OzTDgc82D27B2iig2IfTT3anVHf300nr4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHAnBrXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHAnBrXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20C0C4CEC5;
	Wed,  2 Oct 2024 13:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875617;
	bh=6GasvonWjp5bIetq1snWvv9pubs6buN8cl+0yTBk4No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHAnBrXTILXH8fihU/UqUVd4OgBp62zGXg9amNUDwhvh4NbFjgcpPir8Prx9IlJpK
	 RnK7tP5A8aV8ct04aFYE07Q55x60U60UxHVJ2rSqh1RhdnYRaJ2lJ2mEwmEPomhTj5
	 jTye4kZ0FLX9VrPF40ghakfT8f3b5ChC72RQ1TYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 163/695] ASoC: tas2781-i2c: Drop weird GPIO code
Date: Wed,  2 Oct 2024 14:52:41 +0200
Message-ID: <20241002125828.981788664@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit c2c0b67dca3cb3b3cea0dd60075a1c5ba77e2fcd ]

The tas2781-i2c driver gets an IRQ from either ACPI or device tree,
then proceeds to check if the IRQ has a corresponding GPIO and in
case it does enforce the GPIO as input and set a label on it.

This is abuse of the API:

- First we cannot guarantee that the numberspaces of the GPIOs and
  the IRQs are the same, i.e that an IRQ number corresponds to
  a GPIO number like that.

- Second, GPIO chips and IRQ chips should be treated as orthogonal
  APIs, the irqchip needs to ascertain that the backing GPIO line
  is set to input etc just using the irqchip.

- Third it is using the legacy <linux/gpio.h> API which should not
  be used in new code yet this was added just a year ago.

Delete the offending code.

If this creates problems the GPIO and irqchip maintainers can help
to fix the issues.

It *should* not create any problems, because the irq isn't
used anywhere in the driver, it's just obtained and then
left unused.

Fixes: ef3bcde75d06 ("ASoC: tas2781: Add tas2781 driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20240807-asoc-tas-gpios-v2-1-bd0f2705d58b@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781.h           |  7 +------
 sound/pci/hda/tas2781_hda_i2c.c   |  2 +-
 sound/soc/codecs/tas2781-comlib.c |  3 ---
 sound/soc/codecs/tas2781-fmwlib.c |  1 -
 sound/soc/codecs/tas2781-i2c.c    | 24 +++---------------------
 5 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/include/sound/tas2781.h b/include/sound/tas2781.h
index 18161d02a96f7..dbda552398b5b 100644
--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -81,11 +81,6 @@ struct tasdevice {
 	bool is_loaderr;
 };
 
-struct tasdevice_irqinfo {
-	int irq_gpio;
-	int irq;
-};
-
 struct calidata {
 	unsigned char *data;
 	unsigned long total_sz;
@@ -93,7 +88,6 @@ struct calidata {
 
 struct tasdevice_priv {
 	struct tasdevice tasdevice[TASDEVICE_MAX_CHANNELS];
-	struct tasdevice_irqinfo irq_info;
 	struct tasdevice_rca rcabin;
 	struct calidata cali_data;
 	struct tasdevice_fw *fmw;
@@ -115,6 +109,7 @@ struct tasdevice_priv {
 	unsigned int chip_id;
 	unsigned int sysclk;
 
+	int irq;
 	int cur_prog;
 	int cur_conf;
 	int fw_state;
diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index 89d8235537cd3..f58f434e7110e 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -818,7 +818,7 @@ static int tas2781_hda_i2c_probe(struct i2c_client *clt)
 	} else
 		return -ENODEV;
 
-	tas_hda->priv->irq_info.irq = clt->irq;
+	tas_hda->priv->irq = clt->irq;
 	ret = tas2781_read_acpi(tas_hda->priv, device_name);
 	if (ret)
 		return dev_err_probe(tas_hda->dev, ret,
diff --git a/sound/soc/codecs/tas2781-comlib.c b/sound/soc/codecs/tas2781-comlib.c
index 1fbf4560f5cc2..28d8b4d7b9855 100644
--- a/sound/soc/codecs/tas2781-comlib.c
+++ b/sound/soc/codecs/tas2781-comlib.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
@@ -411,8 +410,6 @@ EXPORT_SYMBOL_GPL(tasdevice_dsp_remove);
 
 void tasdevice_remove(struct tasdevice_priv *tas_priv)
 {
-	if (gpio_is_valid(tas_priv->irq_info.irq_gpio))
-		gpio_free(tas_priv->irq_info.irq_gpio);
 	mutex_destroy(&tas_priv->codec_lock);
 }
 EXPORT_SYMBOL_GPL(tasdevice_remove);
diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 8f9a3ae7153e9..f3a7605f07104 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -13,7 +13,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 01b0e1820b38f..5856a68d60d39 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
@@ -758,7 +757,7 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 {
 	struct i2c_client *client = (struct i2c_client *)tas_priv->client;
 	unsigned int dev_addrs[TASDEVICE_MAX_CHANNELS];
-	int rc, i, ndev = 0;
+	int i, ndev = 0;
 
 	if (tas_priv->isacpi) {
 		ndev = device_property_read_u32_array(&client->dev,
@@ -773,7 +772,7 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 				"ti,audio-slots", dev_addrs, ndev);
 		}
 
-		tas_priv->irq_info.irq_gpio =
+		tas_priv->irq =
 			acpi_dev_gpio_irq_get(ACPI_COMPANION(&client->dev), 0);
 	} else if (IS_ENABLED(CONFIG_OF)) {
 		struct device_node *np = tas_priv->dev->of_node;
@@ -785,7 +784,7 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 			dev_addrs[ndev++] = addr;
 		}
 
-		tas_priv->irq_info.irq_gpio = of_irq_get(np, 0);
+		tas_priv->irq = of_irq_get(np, 0);
 	} else {
 		ndev = 1;
 		dev_addrs[0] = client->addr;
@@ -801,23 +800,6 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 			__func__);
 
 	strcpy(tas_priv->dev_name, tasdevice_id[tas_priv->chip_id].name);
-
-	if (gpio_is_valid(tas_priv->irq_info.irq_gpio)) {
-		rc = gpio_request(tas_priv->irq_info.irq_gpio,
-				"AUDEV-IRQ");
-		if (!rc) {
-			gpio_direction_input(
-				tas_priv->irq_info.irq_gpio);
-
-			tas_priv->irq_info.irq =
-				gpio_to_irq(tas_priv->irq_info.irq_gpio);
-		} else
-			dev_err(tas_priv->dev, "%s: GPIO %d request error\n",
-				__func__, tas_priv->irq_info.irq_gpio);
-	} else
-		dev_err(tas_priv->dev,
-			"Looking up irq-gpio property failed %d\n",
-			tas_priv->irq_info.irq_gpio);
 }
 
 static int tasdevice_i2c_probe(struct i2c_client *i2c)
-- 
2.43.0



