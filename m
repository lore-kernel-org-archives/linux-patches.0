Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182E82FDC4D;
	Thu, 15 Jan 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496967; cv=none; b=fg0UwXThgpZUal/mmzDRTagh5c3+1xrhigXUkmPiXeTGeUh0MUn/SHUWUTeZMj1rQ1CSDb85vj81gfwGV4raLEAqQh6yoVka+hAzpSscP2Mi0XF2Bs1naAg5/lPI1FQk5DOwCiK1cNNaru9+jBJQzklaHYq9KswvE3fxLdPKDAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496967; c=relaxed/simple;
	bh=hJiLbbHwMC7cDVNQeikXwl4VtvgqYjWVeaHJ6Zlao7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKNRX9j8KeDdjpgnC6mGHrht6kBmieRa9Hl+g62qIGtcVcd9UV95kTcHXEdItc8PYtDKqkXDwtb/HDRjn55hdXEfxMqnbOHX43Uzs94A37U/+JsX8PkgYU+SxqwDAJsYKWTXGA8TKUFJG/3BfZFwQdUJ4peN5BP/Kxj4utekbmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTvpib8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTvpib8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629BFC116D0;
	Thu, 15 Jan 2026 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496966;
	bh=hJiLbbHwMC7cDVNQeikXwl4VtvgqYjWVeaHJ6Zlao7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTvpib8Bp+CTp6bgfqDHtOxWJfpBAXXCcjivmUO8wbHZiMYNwSg6rCHmNIzJSd763
	 oz7eJldAbMh3R2aCZYHv5hS93mcyy8PC7UN14auv1YEp/0xu1tPCBHNmVWUFGheYc5
	 M5qJd18eVh64vOH3tFDHJQJK5SydnxpA0PW5T5KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 45/88] gpio: pca953x: Utilise temporary variable for struct device
Date: Thu, 15 Jan 2026 17:48:28 +0100
Message-ID: <20260115164147.940581307@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6811886ac91eb414b1b74920e05e6590c3f2a688 ]

We have a temporary variable to keep pointer to struct device.
Utilise it where it makes sense.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 014a17deb412 ("gpio: pca953x: handle short interrupt pulses on PCAL devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 3a0b999521e44..de965e6353c5b 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -781,11 +781,11 @@ static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
+	struct device *dev = &chip->client->dev;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
 	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
-		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
-			d->irq, type);
+		dev_err(dev, "irq %d: unsupported type %d\n", d->irq, type);
 		return -EINVAL;
 	}
 
@@ -902,7 +902,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	int ret;
 
 	if (dmi_first_match(pca953x_dmi_acpi_irq_info)) {
-		ret = pca953x_acpi_get_irq(&client->dev);
+		ret = pca953x_acpi_get_irq(dev);
 		if (ret > 0)
 			client->irq = ret;
 	}
@@ -940,10 +940,9 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	girq->threaded = true;
 	girq->first = irq_base; /* FIXME: get rid of this */
 
-	ret = devm_request_threaded_irq(&client->dev, client->irq,
-					NULL, pca953x_irq_handler,
-					IRQF_ONESHOT | IRQF_SHARED,
-					dev_name(&client->dev), chip);
+	ret = devm_request_threaded_irq(dev, client->irq, NULL, pca953x_irq_handler,
+					IRQF_ONESHOT | IRQF_SHARED, dev_name(dev),
+					chip);
 	if (ret)
 		return dev_err_probe(dev, client->irq, "failed to request irq\n");
 
@@ -951,13 +950,13 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 }
 
 #else /* CONFIG_GPIO_PCA953X_IRQ */
-static int pca953x_irq_setup(struct pca953x_chip *chip,
-			     int irq_base)
+static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 {
 	struct i2c_client *client = chip->client;
+	struct device *dev = &client->dev;
 
 	if (client->irq && irq_base != -1 && (chip->driver_data & PCA_INT))
-		dev_warn(&client->dev, "interrupt support not compiled in\n");
+		dev_warn(dev, "interrupt support not compiled in\n");
 
 	return 0;
 }
@@ -1048,11 +1047,11 @@ static int pca953x_probe(struct i2c_client *client)
 	int ret;
 	const struct regmap_config *regmap_config;
 
-	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
-	pdata = dev_get_platdata(&client->dev);
+	pdata = dev_get_platdata(dev);
 	if (pdata) {
 		irq_base = pdata->irq_base;
 		chip->gpio_start = pdata->gpio_base;
@@ -1069,8 +1068,7 @@ static int pca953x_probe(struct i2c_client *client)
 		 * using "reset" GPIO. Otherwise any of those platform
 		 * must use _DSD method with corresponding property.
 		 */
-		reset_gpio = devm_gpiod_get_optional(&client->dev, "reset",
-						     GPIOD_OUT_LOW);
+		reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 		if (IS_ERR(reset_gpio))
 			return dev_err_probe(dev, PTR_ERR(reset_gpio),
 					     "Failed to get reset gpio\n");
@@ -1090,10 +1088,10 @@ static int pca953x_probe(struct i2c_client *client)
 	pca953x_setup_gpio(chip, chip->driver_data & PCA_GPIO_MASK);
 
 	if (NBANK(chip) > 2 || PCA_CHIP_TYPE(chip->driver_data) == PCA957X_TYPE) {
-		dev_info(&client->dev, "using AI\n");
+		dev_info(dev, "using AI\n");
 		regmap_config = &pca953x_ai_i2c_regmap;
 	} else {
-		dev_info(&client->dev, "using no AI\n");
+		dev_info(dev, "using no AI\n");
 		regmap_config = &pca953x_i2c_regmap;
 	}
 
-- 
2.51.0



