Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4741863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105D8C433D2;
	Wed, 28 Dec 2022 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241191;
	bh=hafTzfsayXdeFYxoNO2rdQVl+0KVRalLJ956sh9huyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1mrS2uCO2pGvZpfP1SRF0EHUAzCeUxeBDcr8XagtUWijSojPNPQuY/gzNkHww+i6
	 V2d3fXh4bw25T4VLwJoHlLyx5otoWcrqzr6HnO6xpSEHZAJIQjswzhemc/HKQXMtlp
	 edgoaGmTpi3NmRHM809slOT6QGNiNN+I2eG56d6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/731] extcon: usbc-tusb320: Add support for mode setting and reset
Date: Wed, 28 Dec 2022 15:39:18 +0100
Message-Id: <20221228144309.627391443@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit 70c55d6be634e5f9894169340f3fe5c73f53ac2d ]

Reset the chip and set its mode to default (maintain mode set by PORT pin)
during probe to make sure it comes up in the default state.

Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Stable-dep-of: 581c848b610d ("extcon: usbc-tusb320: Update state on probe even if no IRQ pending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-usbc-tusb320.c | 85 ++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index 805af73b4152..1ed1dfe54206 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -19,15 +19,32 @@
 #define TUSB320_REG9_ATTACHED_STATE_MASK	0x3
 #define TUSB320_REG9_CABLE_DIRECTION		BIT(5)
 #define TUSB320_REG9_INTERRUPT_STATUS		BIT(4)
-#define TUSB320_ATTACHED_STATE_NONE		0x0
-#define TUSB320_ATTACHED_STATE_DFP		0x1
-#define TUSB320_ATTACHED_STATE_UFP		0x2
-#define TUSB320_ATTACHED_STATE_ACC		0x3
+
+#define TUSB320_REGA				0xa
+#define TUSB320_REGA_I2C_SOFT_RESET		BIT(3)
+#define TUSB320_REGA_MODE_SELECT_SHIFT		4
+#define TUSB320_REGA_MODE_SELECT_MASK		0x3
+
+enum tusb320_attached_state {
+	TUSB320_ATTACHED_STATE_NONE,
+	TUSB320_ATTACHED_STATE_DFP,
+	TUSB320_ATTACHED_STATE_UFP,
+	TUSB320_ATTACHED_STATE_ACC,
+};
+
+enum tusb320_mode {
+	TUSB320_MODE_PORT,
+	TUSB320_MODE_UFP,
+	TUSB320_MODE_DFP,
+	TUSB320_MODE_DRP,
+};
 
 struct tusb320_priv {
 	struct device *dev;
 	struct regmap *regmap;
 	struct extcon_dev *edev;
+
+	enum tusb320_attached_state state;
 };
 
 static const char * const tusb_attached_states[] = {
@@ -62,6 +79,53 @@ static int tusb320_check_signature(struct tusb320_priv *priv)
 	return 0;
 }
 
+static int tusb320_set_mode(struct tusb320_priv *priv, enum tusb320_mode mode)
+{
+	int ret;
+
+	/* Mode cannot be changed while cable is attached */
+	if (priv->state != TUSB320_ATTACHED_STATE_NONE)
+		return -EBUSY;
+
+	/* Write mode */
+	ret = regmap_write_bits(priv->regmap, TUSB320_REGA,
+		TUSB320_REGA_MODE_SELECT_MASK << TUSB320_REGA_MODE_SELECT_SHIFT,
+		mode << TUSB320_REGA_MODE_SELECT_SHIFT);
+	if (ret) {
+		dev_err(priv->dev, "failed to write mode: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int tusb320_reset(struct tusb320_priv *priv)
+{
+	int ret;
+
+	/* Set mode to default (follow PORT pin) */
+	ret = tusb320_set_mode(priv, TUSB320_MODE_PORT);
+	if (ret && ret != -EBUSY) {
+		dev_err(priv->dev,
+			"failed to set mode to PORT: %d\n", ret);
+		return ret;
+	}
+
+	/* Perform soft reset */
+	ret = regmap_write_bits(priv->regmap, TUSB320_REGA,
+			TUSB320_REGA_I2C_SOFT_RESET, 1);
+	if (ret) {
+		dev_err(priv->dev,
+			"failed to write soft reset bit: %d\n", ret);
+		return ret;
+	}
+
+	/* Wait for chip to go through reset */
+	msleep(95);
+
+	return 0;
+}
+
 static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 {
 	struct tusb320_priv *priv = dev_id;
@@ -96,6 +160,8 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 	extcon_sync(priv->edev, EXTCON_USB);
 	extcon_sync(priv->edev, EXTCON_USB_HOST);
 
+	priv->state = state;
+
 	regmap_write(priv->regmap, TUSB320_REG9, reg);
 
 	return IRQ_HANDLED;
@@ -145,6 +211,17 @@ static int tusb320_extcon_probe(struct i2c_client *client,
 	/* update initial state */
 	tusb320_irq_handler(client->irq, priv);
 
+	/* Reset chip to its default state */
+	ret = tusb320_reset(priv);
+	if (ret)
+		dev_warn(priv->dev, "failed to reset chip: %d\n", ret);
+	else
+		/*
+		 * State and polarity might change after a reset, so update
+		 * them again and make sure the interrupt status bit is cleared.
+		 */
+		tusb320_irq_handler(client->irq, priv);
+
 	ret = devm_request_threaded_irq(priv->dev, client->irq, NULL,
 					tusb320_irq_handler,
 					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-- 
2.35.1



