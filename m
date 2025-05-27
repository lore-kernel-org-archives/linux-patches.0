Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0E727D784;
	Tue, 27 May 2025 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366771; cv=none; b=dMY1ut77SW7ba2fuNZpMqZIe9MxXuz8XhDUbzUrN1Gxmtni+/3F9TsT72B1yaC/jKI5aUICeSaz5BsjfOC6ZWiPgZLbLEbmvzgsjN2bRjvwoCniI9O197MOpYj1cOjPSLdkBmcyZG1GtHo3L+4ErZrlaV3dpXC/ebpw1kY2DfsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366771; c=relaxed/simple;
	bh=RIrazr47GTraotpSLQbcmD6nuuMvDQH2pvQKV50oYes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJKDlycO5etACLp6Jlf3HgNFC+V+39LkQ29d7Ww37MbHKrJcmXuGVsxidRfTqtx8P3+xJmp/KMcFJFSdmfY/72cgaEJPpYckBdZSsIYu+0GjggcfiA7Dhp2Ro2ifs1ZCcCThpCxsvSgcYb2442izuiqFgiLPsnbHdupML1I8OGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKpeNMFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKpeNMFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C493C4CEE9;
	Tue, 27 May 2025 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366771;
	bh=RIrazr47GTraotpSLQbcmD6nuuMvDQH2pvQKV50oYes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKpeNMFeFDnsLK6z5KrSOK97Q6yvNXCq6O9R9nvmgEprhpdGt0RgS5Vu2gnF6poP8
	 rLPqKbx3tljjbgyal3dXVPXX81fsT6SRZjbIWw7fG5vheYloSWRQOAGBS9ciGoCriJ
	 6SLQIVb1BgG8yoL62hAVEQVSqOJkpFCkiv0dMvrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 173/783] ASoC: pcm6240: Drop bogus code handling IRQ as GPIO
Date: Tue, 27 May 2025 18:19:30 +0200
Message-ID: <20250527162520.210383665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 17fdf318f5fbe5c27353ae917c0c5a2899d9c259 ]

The current code for the IRQ in pcm6240 makes no sense:
it looks up an IRQ with of_irq_get(), treat it as a GPIO
by issuing gpio_request(), gpio_direction_input()
and gpio_to_irq() on it.

This is just wrong, if the device tree assigns the IRQ
from a GPIO number this is just incorrect: it is clearly
stated that GPIO providers and IRQ providers are
orthogonal.

It is possible to look up an IRQ to a corresponding GPIO
line but this is taking an IRQ and pretending it's a
GPIO, which is just semantically wrong.

Drop the offending code and treat the IRQ that we get
from the device tree as any other IRQ, see for example
other codec drivers.

The DT bindings for this codec does not have any in-tree
DTS files, which may explain why things are weird.

As a bonus, this moves the driver away from the legacy
<linux/gpio.h> include.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20250312-pcm-codecs-v1-3-41ffc4f8fc5c@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm6240.c | 28 +++++++---------------------
 sound/soc/codecs/pcm6240.h |  7 +------
 2 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/sound/soc/codecs/pcm6240.c b/sound/soc/codecs/pcm6240.c
index 4ff39e0b95b27..b2bd2f172ae76 100644
--- a/sound/soc/codecs/pcm6240.c
+++ b/sound/soc/codecs/pcm6240.c
@@ -14,7 +14,7 @@
 
 #include <linux/unaligned.h>
 #include <linux/firmware.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/of_irq.h>
@@ -2035,10 +2035,8 @@ static const struct regmap_config pcmdevice_i2c_regmap = {
 
 static void pcmdevice_remove(struct pcmdevice_priv *pcm_dev)
 {
-	if (gpio_is_valid(pcm_dev->irq_info.gpio)) {
-		gpio_free(pcm_dev->irq_info.gpio);
-		free_irq(pcm_dev->irq_info.nmb, pcm_dev);
-	}
+	if (pcm_dev->irq)
+		free_irq(pcm_dev->irq, pcm_dev);
 	mutex_destroy(&pcm_dev->codec_lock);
 }
 
@@ -2109,7 +2107,7 @@ static int pcmdevice_i2c_probe(struct i2c_client *i2c)
 		ndev = 1;
 		dev_addrs[0] = i2c->addr;
 	}
-	pcm_dev->irq_info.gpio = of_irq_get(np, 0);
+	pcm_dev->irq = of_irq_get(np, 0);
 
 	for (i = 0; i < ndev; i++)
 		pcm_dev->addr[i] = dev_addrs[i];
@@ -2132,22 +2130,10 @@ static int pcmdevice_i2c_probe(struct i2c_client *i2c)
 
 	if (pcm_dev->chip_id == PCM1690)
 		goto skip_interrupt;
-	if (gpio_is_valid(pcm_dev->irq_info.gpio)) {
-		dev_dbg(pcm_dev->dev, "irq-gpio = %d", pcm_dev->irq_info.gpio);
-
-		ret = gpio_request(pcm_dev->irq_info.gpio, "PCMDEV-IRQ");
-		if (!ret) {
-			int gpio = pcm_dev->irq_info.gpio;
-
-			gpio_direction_input(gpio);
-			pcm_dev->irq_info.nmb = gpio_to_irq(gpio);
-
-		} else
-			dev_err(pcm_dev->dev, "%s: GPIO %d request error\n",
-				__func__, pcm_dev->irq_info.gpio);
+	if (pcm_dev->irq) {
+		dev_dbg(pcm_dev->dev, "irq = %d", pcm_dev->irq);
 	} else
-		dev_err(pcm_dev->dev, "Looking up irq-gpio failed %d\n",
-			pcm_dev->irq_info.gpio);
+		dev_err(pcm_dev->dev, "No irq provided\n");
 
 skip_interrupt:
 	ret = devm_snd_soc_register_component(&i2c->dev,
diff --git a/sound/soc/codecs/pcm6240.h b/sound/soc/codecs/pcm6240.h
index 1e125bb972860..2d8f9e798139a 100644
--- a/sound/soc/codecs/pcm6240.h
+++ b/sound/soc/codecs/pcm6240.h
@@ -208,11 +208,6 @@ struct pcmdevice_regbin {
 	struct pcmdevice_config_info **cfg_info;
 };
 
-struct pcmdevice_irqinfo {
-	int gpio;
-	int nmb;
-};
-
 struct pcmdevice_priv {
 	struct snd_soc_component *component;
 	struct i2c_client *client;
@@ -221,7 +216,7 @@ struct pcmdevice_priv {
 	struct gpio_desc *hw_rst;
 	struct regmap *regmap;
 	struct pcmdevice_regbin regbin;
-	struct pcmdevice_irqinfo irq_info;
+	int irq;
 	unsigned int addr[PCMDEVICE_MAX_I2C_DEVICES];
 	unsigned int chip_id;
 	int cur_conf;
-- 
2.39.5



