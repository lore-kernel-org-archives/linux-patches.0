Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDAA36BCD0;
	Tue,  6 Jan 2026 17:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722183; cv=none; b=tU/QpljKOjVnzB6exxsr29j/7hJiHqQ5cd+w2h8QsmRFZLJQDvu+p7AargLAGtrIpiYw6BXRselrqJ5ByQU+9iU+ZC4fV3oPSseX1ZVvlZAzFpt4Ie3gysjy1emn0y/HdSUJaLnyBP4ys7R2/yrISQ4uCp7QmEtQkvVCd8rtOPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722183; c=relaxed/simple;
	bh=5TK8J38FFhoZuBqD5ZU6Ea3IXRJDUbq6bKljbloIEHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzHf3KsKMuGkt3HbQMUfuvp6FMr/X/yDKsIoMn86yljqfRmXmoYh22yJpL7wJzVz9ZxfizISIqI8vEEQd67M0RUCdDxKuZyPv576PHTPqaY6sQic4sVxRAZ5ISS7ALuN+KwJNGKKhM3TUxVvHKv35nRT57GNAqIkup8PfMHRIao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIacGt89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIacGt89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A163EC116C6;
	Tue,  6 Jan 2026 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722183;
	bh=5TK8J38FFhoZuBqD5ZU6Ea3IXRJDUbq6bKljbloIEHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIacGt89xDmRvzRAOuloGLVvRBB+KHb4M5SDtATLxTkoZBEngAjNf+qwW9vKTWbAC
	 irHOnlwjLzJ1md08+hRlUCksvOV1nPUyYzaoQ9bBCrI1pzin7ynjcMmgurJ5mNqqOk
	 pmTKXYVczQO41Rc3Mr+cYnq5HAz+I6cDAoXshAlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 162/312] power: supply: max77705: Fix potential IRQ chip conflict when probing two devices
Date: Tue,  6 Jan 2026 18:03:56 +0100
Message-ID: <20260106170553.697338484@linuxfoundation.org>
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

commit 1cb053ea2e1dedd8f2d9653b7c3ca5b93c8c9275 upstream.

MAX77705 charger is most likely always a single device on the board,
however nothing stops board designers to have two of them, thus same
device driver could probe twice. Or user could manually try to probing
second time.

Device driver is not ready for that case, because it allocates
statically 'struct regmap_irq_chip' as non-const and stores during
probe in 'irq_drv_data' member a pointer to per-probe state
container ('struct max77705_charger_data').  devm_regmap_add_irq_chip()
does not make a copy of 'struct regmap_irq_chip' but stores the pointer.

Second probe - either successful or failure - would overwrite the
'irq_drv_data' from previous device probe, so interrupts would be
executed in a wrong context.

Fixes: a6a494c8e3ce ("power: supply: max77705: Add charger driver for Maxim 77705")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20251023102905.71535-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max77705_charger.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/power/supply/max77705_charger.c
+++ b/drivers/power/supply/max77705_charger.c
@@ -60,7 +60,7 @@ static const struct regmap_irq max77705_
 	REGMAP_IRQ_REG_LINE(MAX77705_AICL_I, BITS_PER_BYTE),
 };
 
-static struct regmap_irq_chip max77705_charger_irq_chip = {
+static const struct regmap_irq_chip max77705_charger_irq_chip = {
 	.name			= "max77705-charger",
 	.status_base		= MAX77705_CHG_REG_INT,
 	.mask_base		= MAX77705_CHG_REG_INT_MASK,
@@ -567,6 +567,7 @@ static int max77705_charger_probe(struct
 {
 	struct power_supply_config pscfg = {};
 	struct max77705_charger_data *chg;
+	struct regmap_irq_chip *chip_desc;
 	struct device *dev;
 	struct regmap_irq_chip_data *irq_data;
 	int ret;
@@ -580,6 +581,13 @@ static int max77705_charger_probe(struct
 	chg->dev = dev;
 	i2c_set_clientdata(i2c, chg);
 
+	chip_desc = devm_kmemdup(dev, &max77705_charger_irq_chip,
+				 sizeof(max77705_charger_irq_chip),
+				 GFP_KERNEL);
+	if (!chip_desc)
+		return -ENOMEM;
+	chip_desc->irq_drv_data = chg;
+
 	chg->regmap = devm_regmap_init_i2c(i2c, &max77705_chg_regmap_config);
 	if (IS_ERR(chg->regmap))
 		return PTR_ERR(chg->regmap);
@@ -599,11 +607,9 @@ static int max77705_charger_probe(struct
 	if (IS_ERR(chg->psy_chg))
 		return PTR_ERR(chg->psy_chg);
 
-	max77705_charger_irq_chip.irq_drv_data = chg;
 	ret = devm_regmap_add_irq_chip(chg->dev, chg->regmap, i2c->irq,
 					IRQF_ONESHOT, 0,
-					&max77705_charger_irq_chip,
-					&irq_data);
+					chip_desc, &irq_data);
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to add irq chip\n");
 


