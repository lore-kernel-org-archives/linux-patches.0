Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1E91C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF0FC433D2;
	Wed, 28 Dec 2022 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244274;
	bh=3dyoOV2dBFkWLhdt9NL07C/fqvThjgd3Xxn8qEq4kSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMFZvi+oi0EoHxDJVLhOYigwVAlFAhA1XsPSZJjfQ8Zcop0V6Vtxrv//QBYw8AHFU
	 gs5S4IvZhHgi1SRSEpBK64bHdfVR9HMoryN7hlBiNUOpSs+TMBPO83pyk7sAcEoQbi
	 wKx+WjjQe2rztYNuq24iq91qlBHMh+FObedW7ojc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0680/1073] extcon: usbc-tusb320: Factor out extcon into dedicated functions
Date: Wed, 28 Dec 2022 15:37:48 +0100
Message-Id: <20221228144346.506834117@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 9483811a126a319ecac749f1b767ea5faecc7aed ]

Move extcon code into separate functions in preparation for addition of
USB TYPE-C support. No functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Stable-dep-of: 581c848b610d ("extcon: usbc-tusb320: Update state on probe even if no IRQ pending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-usbc-tusb320.c | 75 +++++++++++++++++-----------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index 6ba3d89b106d..aced4bbb455d 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -184,19 +184,9 @@ static struct tusb320_ops tusb320l_ops = {
 	.get_revision = tusb320l_get_revision,
 };
 
-static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
+static void tusb320_extcon_irq_handler(struct tusb320_priv *priv, u8 reg)
 {
-	struct tusb320_priv *priv = dev_id;
 	int state, polarity;
-	unsigned reg;
-
-	if (regmap_read(priv->regmap, TUSB320_REG9, &reg)) {
-		dev_err(priv->dev, "error during i2c read!\n");
-		return IRQ_NONE;
-	}
-
-	if (!(reg & TUSB320_REG9_INTERRUPT_STATUS))
-		return IRQ_NONE;
 
 	state = (reg >> TUSB320_REG9_ATTACHED_STATE_SHIFT) &
 		TUSB320_REG9_ATTACHED_STATE_MASK;
@@ -219,6 +209,22 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 	extcon_sync(priv->edev, EXTCON_USB_HOST);
 
 	priv->state = state;
+}
+
+static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
+{
+	struct tusb320_priv *priv = dev_id;
+	unsigned int reg;
+
+	if (regmap_read(priv->regmap, TUSB320_REG9, &reg)) {
+		dev_err(priv->dev, "error during i2c read!\n");
+		return IRQ_NONE;
+	}
+
+	if (!(reg & TUSB320_REG9_INTERRUPT_STATUS))
+		return IRQ_NONE;
+
+	tusb320_extcon_irq_handler(priv, reg);
 
 	regmap_write(priv->regmap, TUSB320_REG9, reg);
 
@@ -230,8 +236,32 @@ static const struct regmap_config tusb320_regmap_config = {
 	.val_bits = 8,
 };
 
-static int tusb320_extcon_probe(struct i2c_client *client,
-				const struct i2c_device_id *id)
+static int tusb320_extcon_probe(struct tusb320_priv *priv)
+{
+	int ret;
+
+	priv->edev = devm_extcon_dev_allocate(priv->dev, tusb320_extcon_cable);
+	if (IS_ERR(priv->edev)) {
+		dev_err(priv->dev, "failed to allocate extcon device\n");
+		return PTR_ERR(priv->edev);
+	}
+
+	ret = devm_extcon_dev_register(priv->dev, priv->edev);
+	if (ret < 0) {
+		dev_err(priv->dev, "failed to register extcon device\n");
+		return ret;
+	}
+
+	extcon_set_property_capability(priv->edev, EXTCON_USB,
+				       EXTCON_PROP_USB_TYPEC_POLARITY);
+	extcon_set_property_capability(priv->edev, EXTCON_USB_HOST,
+				       EXTCON_PROP_USB_TYPEC_POLARITY);
+
+	return 0;
+}
+
+static int tusb320_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
 {
 	struct tusb320_priv *priv;
 	const void *match_data;
@@ -257,12 +287,6 @@ static int tusb320_extcon_probe(struct i2c_client *client,
 
 	priv->ops = (struct tusb320_ops*)match_data;
 
-	priv->edev = devm_extcon_dev_allocate(priv->dev, tusb320_extcon_cable);
-	if (IS_ERR(priv->edev)) {
-		dev_err(priv->dev, "failed to allocate extcon device\n");
-		return PTR_ERR(priv->edev);
-	}
-
 	if (priv->ops->get_revision) {
 		ret = priv->ops->get_revision(priv, &revision);
 		if (ret)
@@ -272,16 +296,9 @@ static int tusb320_extcon_probe(struct i2c_client *client,
 			dev_info(priv->dev, "chip revision %d\n", revision);
 	}
 
-	ret = devm_extcon_dev_register(priv->dev, priv->edev);
-	if (ret < 0) {
-		dev_err(priv->dev, "failed to register extcon device\n");
+	ret = tusb320_extcon_probe(priv);
+	if (ret)
 		return ret;
-	}
-
-	extcon_set_property_capability(priv->edev, EXTCON_USB,
-				       EXTCON_PROP_USB_TYPEC_POLARITY);
-	extcon_set_property_capability(priv->edev, EXTCON_USB_HOST,
-				       EXTCON_PROP_USB_TYPEC_POLARITY);
 
 	/* update initial state */
 	tusb320_irq_handler(client->irq, priv);
@@ -313,7 +330,7 @@ static const struct of_device_id tusb320_extcon_dt_match[] = {
 MODULE_DEVICE_TABLE(of, tusb320_extcon_dt_match);
 
 static struct i2c_driver tusb320_extcon_driver = {
-	.probe		= tusb320_extcon_probe,
+	.probe		= tusb320_probe,
 	.driver		= {
 		.name	= "extcon-tusb320",
 		.of_match_table = tusb320_extcon_dt_match,
-- 
2.35.1



