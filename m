Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7CA1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A02C433EF;
	Wed, 28 Dec 2022 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242217;
	bh=BpzWDVsO3r6wcoi5AnkNBiNcLbYwtUgyrd0CgUXdI5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKhn5h3COGzZLpIBH+9IpsPHNH5HF8a+9LYTx/oHyagHQAXnyTT1e5+0k2GpoyVxL
	 V9s5RAnzwuF1Y5F+iUqv8rsYde3rk1RpWwfJFx49f03G8DplE4MZynLItA9JNi0tUb
	 xYb5Hh0T/D0TCznz573pXiti+buivP4nZPoT681c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 576/731] mfd: pm8008: Remove driver data structure pm8008_data
Date: Wed, 28 Dec 2022 15:41:23 +0100
Message-Id: <20221228144313.250289462@linuxfoundation.org>
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

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 915696927cd6e7838d25dab8fbd2ae05d4acce84 ]

Maintaining a local driver data structure that is never shared
outside of the core device is an unnecessary complexity.  Half of the
attributes were not used outside of a single function, one of which
was not used at all.  The remaining 2 are generic and can be passed
around as required.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14f8c55d48e0 ("mfd: pm8008: Fix return value check in pm8008_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/qcom-pm8008.c | 53 +++++++++++++++------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/qcom-pm8008.c b/drivers/mfd/qcom-pm8008.c
index c472d7f8103c..4b8ff947762f 100644
--- a/drivers/mfd/qcom-pm8008.c
+++ b/drivers/mfd/qcom-pm8008.c
@@ -54,13 +54,6 @@ enum {
 
 #define PM8008_PERIPH_OFFSET(paddr)	(paddr - PM8008_PERIPH_0_BASE)
 
-struct pm8008_data {
-	struct device *dev;
-	struct regmap *regmap;
-	int irq;
-	struct regmap_irq_chip_data *irq_data;
-};
-
 static unsigned int p0_offs[] = {PM8008_PERIPH_OFFSET(PM8008_PERIPH_0_BASE)};
 static unsigned int p1_offs[] = {PM8008_PERIPH_OFFSET(PM8008_PERIPH_1_BASE)};
 static unsigned int p2_offs[] = {PM8008_PERIPH_OFFSET(PM8008_PERIPH_2_BASE)};
@@ -150,7 +143,7 @@ static struct regmap_config qcom_mfd_regmap_cfg = {
 	.max_register	= 0xFFFF,
 };
 
-static int pm8008_init(struct pm8008_data *chip)
+static int pm8008_init(struct regmap *regmap)
 {
 	int rc;
 
@@ -160,34 +153,31 @@ static int pm8008_init(struct pm8008_data *chip)
 	 * This is required to enable the writing of TYPE registers in
 	 * regmap_irq_sync_unlock().
 	 */
-	rc = regmap_write(chip->regmap,
-			 (PM8008_TEMP_ALARM_ADDR | INT_SET_TYPE_OFFSET),
-			 BIT(0));
+	rc = regmap_write(regmap, (PM8008_TEMP_ALARM_ADDR | INT_SET_TYPE_OFFSET), BIT(0));
 	if (rc)
 		return rc;
 
 	/* Do the same for GPIO1 and GPIO2 peripherals */
-	rc = regmap_write(chip->regmap,
-			 (PM8008_GPIO1_ADDR | INT_SET_TYPE_OFFSET), BIT(0));
+	rc = regmap_write(regmap, (PM8008_GPIO1_ADDR | INT_SET_TYPE_OFFSET), BIT(0));
 	if (rc)
 		return rc;
 
-	rc = regmap_write(chip->regmap,
-			 (PM8008_GPIO2_ADDR | INT_SET_TYPE_OFFSET), BIT(0));
+	rc = regmap_write(regmap, (PM8008_GPIO2_ADDR | INT_SET_TYPE_OFFSET), BIT(0));
 
 	return rc;
 }
 
-static int pm8008_probe_irq_peripherals(struct pm8008_data *chip,
+static int pm8008_probe_irq_peripherals(struct device *dev,
+					struct regmap *regmap,
 					int client_irq)
 {
 	int rc, i;
 	struct regmap_irq_type *type;
 	struct regmap_irq_chip_data *irq_data;
 
-	rc = pm8008_init(chip);
+	rc = pm8008_init(regmap);
 	if (rc) {
-		dev_err(chip->dev, "Init failed: %d\n", rc);
+		dev_err(dev, "Init failed: %d\n", rc);
 		return rc;
 	}
 
@@ -207,10 +197,10 @@ static int pm8008_probe_irq_peripherals(struct pm8008_data *chip,
 				IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW);
 	}
 
-	rc = devm_regmap_add_irq_chip(chip->dev, chip->regmap, client_irq,
+	rc = devm_regmap_add_irq_chip(dev, regmap, client_irq,
 			IRQF_SHARED, 0, &pm8008_irq_chip, &irq_data);
 	if (rc) {
-		dev_err(chip->dev, "Failed to add IRQ chip: %d\n", rc);
+		dev_err(dev, "Failed to add IRQ chip: %d\n", rc);
 		return rc;
 	}
 
@@ -220,26 +210,23 @@ static int pm8008_probe_irq_peripherals(struct pm8008_data *chip,
 static int pm8008_probe(struct i2c_client *client)
 {
 	int rc;
-	struct pm8008_data *chip;
-
-	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
-	if (!chip)
-		return -ENOMEM;
+	struct device *dev;
+	struct regmap *regmap;
 
-	chip->dev = &client->dev;
-	chip->regmap = devm_regmap_init_i2c(client, &qcom_mfd_regmap_cfg);
-	if (!chip->regmap)
+	dev = &client->dev;
+	regmap = devm_regmap_init_i2c(client, &qcom_mfd_regmap_cfg);
+	if (!regmap)
 		return -ENODEV;
 
-	i2c_set_clientdata(client, chip);
+	i2c_set_clientdata(client, regmap);
 
-	if (of_property_read_bool(chip->dev->of_node, "interrupt-controller")) {
-		rc = pm8008_probe_irq_peripherals(chip, client->irq);
+	if (of_property_read_bool(dev->of_node, "interrupt-controller")) {
+		rc = pm8008_probe_irq_peripherals(dev, regmap, client->irq);
 		if (rc)
-			dev_err(chip->dev, "Failed to probe irq periphs: %d\n", rc);
+			dev_err(dev, "Failed to probe irq periphs: %d\n", rc);
 	}
 
-	return devm_of_platform_populate(chip->dev);
+	return devm_of_platform_populate(dev);
 }
 
 static const struct of_device_id pm8008_match[] = {
-- 
2.35.1



