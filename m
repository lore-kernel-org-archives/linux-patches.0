Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53661364041;
	Tue,  6 Jan 2026 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721874; cv=none; b=VSJj0xGibFvesQetyK2NlCXnJGqx0TYsUtBjw4D3v0i+g0lW0zeihyFLpP6VNlO1RRSQgKCYUipIv0OEgIFirFtrqe/1xzUqsenJTcKTnR4YiJhnxgiiB2ijdZbJUNM/zlh88X3fnbrZUyr4pAesIKx342RVr+9UWDrXLdoNu38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721874; c=relaxed/simple;
	bh=XtM/SHiw3DmqkcNMzREby7yio5pBEhlnDdghOXVNwXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvJLi6UHcULpdYNnwYEbOBR3cNd+fKkK7BcB6ogjGYZwzGEzQs5A6wiX5MXBbixBOAxLjFZGjnhSP8sBn9/cUU/152+A/VY7YHUoSyCFSdixFs2jOqaLCLDnDKqWWA5w+8P113coi+7rWjrzIoWchc9W51LZn/+eyfs5t9BcAO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZ383k9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZ383k9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C266EC116C6;
	Tue,  6 Jan 2026 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721874;
	bh=XtM/SHiw3DmqkcNMzREby7yio5pBEhlnDdghOXVNwXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZ383k9Sw2cUWlAsIwus2KGaqfB0E8UQLVQDvtquq0Sla7lY+CPn0wh+LWD1GiNiy
	 WVnVqx8sA9XprTGXLxkB/FVNP3yG0ZuBrGbFc7u2suZdaGzxeaR/1VMSWHf7IZjVUv
	 WOyk59zJ7fgKteCSAa43v5039DwCTrWmzzuadp7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 098/312] ASoC: codecs: pm4125: Fix potential conflict when probing two devices
Date: Tue,  6 Jan 2026 18:02:52 +0100
Message-ID: <20260106170551.385020593@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit fd94857a934cbe613353810a024c84d54826ead3 upstream.

Qualcomm PM4125 codec is always a single device on the board, however
nothing stops board designers to have two of them, thus same device
driver could probe twice.

Device driver is not ready for that case, because it allocates
statically 'struct regmap_irq_chip' as non-const and stores during
component bind in 'irq_drv_data' member a pointer to per-probe state
container ('struct pm4125_priv').

Second component bind would overwrite the 'irq_drv_data' from previous
device probe, so interrupts would be executed in wrong context.

The fix makes use of currently unused 'struct pm4125_priv' member
'pm4125_regmap_irq_chip', but renames it to a shorter name.

Fixes: 8ad529484937 ("ASoC: codecs: add new pm4125 audio codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20251023-asoc-regmap-irq-chip-v1-1-17ad32680913@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/pm4125.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/pm4125.c
+++ b/sound/soc/codecs/pm4125.c
@@ -70,7 +70,7 @@ struct pm4125_priv {
 	struct wcd_mbhc_config mbhc_cfg;
 	struct wcd_mbhc_intr intr_ids;
 	struct irq_domain *virq;
-	const struct regmap_irq_chip *pm4125_regmap_irq_chip;
+	const struct regmap_irq_chip *chip_desc;
 	struct regmap_irq_chip_data *irq_chip;
 	struct snd_soc_jack *jack;
 	unsigned long status_mask;
@@ -179,7 +179,7 @@ static const u32 pm4125_config_regs[] =
 	PM4125_DIG_SWR_INTR_LEVEL_0,
 };
 
-static struct regmap_irq_chip pm4125_regmap_irq_chip = {
+static const struct regmap_irq_chip pm4125_regmap_irq_chip = {
 	.name = "pm4125",
 	.irqs = pm4125_irqs,
 	.num_irqs = ARRAY_SIZE(pm4125_irqs),
@@ -1320,10 +1320,8 @@ static int pm4125_irq_init(struct pm4125
 		return -EINVAL;
 	}
 
-	pm4125_regmap_irq_chip.irq_drv_data = pm4125;
-
 	return devm_regmap_add_irq_chip(dev, pm4125->regmap, irq_create_mapping(pm4125->virq, 0),
-					IRQF_ONESHOT, 0, &pm4125_regmap_irq_chip,
+					IRQF_ONESHOT, 0, pm4125->chip_desc,
 					&pm4125->irq_chip);
 }
 
@@ -1695,6 +1693,7 @@ static int pm4125_probe(struct platform_
 {
 	struct component_match *match = NULL;
 	struct device *dev = &pdev->dev;
+	struct regmap_irq_chip *chip_desc;
 	struct pm4125_priv *pm4125;
 	struct wcd_mbhc_config *cfg;
 	int ret;
@@ -1705,6 +1704,14 @@ static int pm4125_probe(struct platform_
 
 	dev_set_drvdata(dev, pm4125);
 
+	chip_desc = devm_kmemdup(dev, &pm4125_regmap_irq_chip,
+				 sizeof(pm4125_regmap_irq_chip),
+				 GFP_KERNEL);
+	if (!chip_desc)
+		return -ENOMEM;
+	chip_desc->irq_drv_data = pm4125;
+	pm4125->chip_desc = chip_desc;
+
 	ret = devm_regulator_bulk_get_enable(dev, ARRAY_SIZE(pm4125_power_supplies),
 					     pm4125_power_supplies);
 	if (ret)


