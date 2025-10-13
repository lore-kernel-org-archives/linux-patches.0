Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182193168F7;
	Mon, 13 Oct 2025 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369273; cv=none; b=t7Kr8rWJhJMBDFvYmU0iOYVv27OWINs9RW4xnCjWPt72RKKmwZkoJZmWZWsj35YpcLr67NsNSj0TP79q9Gk+J23xekDTd5q86chuC6x7Hz2+yecSPOSA7A1uFSvTL9klrKOp80znxl2vgHzEPzMYVD1B75Q0YZ0lOLV3uk/dj2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369273; c=relaxed/simple;
	bh=/75/ZkxJTakp9og4O4DvZGJRBWtzSOU7j8LbFZ/rOeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKQJcRk/STZGw/8dUZF0jIKc/Kzmnb8QARHX1PnFc8FP+BGMxQYoEOADlfedTybViTKam0RWjsxGRGlKzgQFf+ZTPj7Wd6Lb0tNfs7HTrNE1c+MupixpIhLgBFTZRHW3au0XIPOkpHV0Psi/lFx2XMLnv6Eer7J5jWmVLPrUmYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bb9C8HUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bb9C8HUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7E6C4CEE7;
	Mon, 13 Oct 2025 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369272;
	bh=/75/ZkxJTakp9og4O4DvZGJRBWtzSOU7j8LbFZ/rOeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bb9C8HUJUQyMFqCsG7dm3s9Ew+mER2b6Zc4BMr6lAk2T+oOO+VNg63Q6fPN1UkGko
	 b6PVIRGm6HCtZ9vVOXLRLVkJSYMDLwguMgwkDdF1X6/CVIkUztGqQoqVbrMO42LMbK
	 wmt2ds9JCiwNtUgw7IyrQ0SgiLTAkmnTIuNSxxag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 188/563] power: supply: max77705_charger: rework interrupts
Date: Mon, 13 Oct 2025 16:40:49 +0200
Message-ID: <20251013144418.093786582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 12a1185a06e3377af777e792ba7436862f8e528a ]

Current implementation uses handle_post_irq to actually handle chgin
irq. This is not how things are meant to work in regmap-irq.

Remove handle_post_irq, and request a threaded interrupt for chgin.

Fixes: a6a494c8e3ce ("power: supply: max77705: Add charger driver for Maxim 77705")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max77705_charger.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/power/supply/max77705_charger.c b/drivers/power/supply/max77705_charger.c
index 2d2201a6ba687..a8762bdd2c7c6 100644
--- a/drivers/power/supply/max77705_charger.c
+++ b/drivers/power/supply/max77705_charger.c
@@ -40,13 +40,13 @@ static enum power_supply_property max77705_charger_props[] = {
 	POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT,
 };
 
-static int max77705_chgin_irq(void *irq_drv_data)
+static irqreturn_t max77705_chgin_irq(int irq, void *irq_drv_data)
 {
 	struct max77705_charger_data *chg = irq_drv_data;
 
 	queue_work(chg->wqueue, &chg->chgin_work);
 
-	return 0;
+	return IRQ_HANDLED;
 }
 
 static const struct regmap_irq max77705_charger_irqs[] = {
@@ -64,7 +64,6 @@ static struct regmap_irq_chip max77705_charger_irq_chip = {
 	.name			= "max77705-charger",
 	.status_base		= MAX77705_CHG_REG_INT,
 	.mask_base		= MAX77705_CHG_REG_INT_MASK,
-	.handle_post_irq	= max77705_chgin_irq,
 	.num_regs		= 1,
 	.irqs			= max77705_charger_irqs,
 	.num_irqs		= ARRAY_SIZE(max77705_charger_irqs),
@@ -493,12 +492,6 @@ static int max77705_charger_probe(struct i2c_client *i2c)
 					     "cannot allocate regmap field\n");
 	}
 
-	ret = regmap_update_bits(chg->regmap,
-				MAX77705_CHG_REG_INT_MASK,
-				MAX77705_CHGIN_IM, 0);
-	if (ret)
-		return ret;
-
 	pscfg.fwnode = dev_fwnode(dev);
 	pscfg.drv_data = chg;
 
@@ -508,7 +501,7 @@ static int max77705_charger_probe(struct i2c_client *i2c)
 
 	max77705_charger_irq_chip.irq_drv_data = chg;
 	ret = devm_regmap_add_irq_chip(chg->dev, chg->regmap, i2c->irq,
-					IRQF_ONESHOT | IRQF_SHARED, 0,
+					IRQF_ONESHOT, 0,
 					&max77705_charger_irq_chip,
 					&irq_data);
 	if (ret)
@@ -526,6 +519,15 @@ static int max77705_charger_probe(struct i2c_client *i2c)
 
 	max77705_charger_initialize(chg);
 
+	ret = devm_request_threaded_irq(dev, regmap_irq_get_virq(irq_data, MAX77705_CHGIN_I),
+					NULL, max77705_chgin_irq,
+					IRQF_TRIGGER_NONE,
+					"chgin-irq", chg);
+	if (ret) {
+		dev_err_probe(dev, ret, "Failed to Request chgin IRQ\n");
+		goto destroy_wq;
+	}
+
 	ret = max77705_charger_enable(chg);
 	if (ret) {
 		dev_err_probe(dev, ret, "failed to enable charge\n");
-- 
2.51.0



