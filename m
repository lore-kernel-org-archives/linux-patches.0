Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C16C13C9C4;
	Wed,  5 Feb 2025 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763580; cv=none; b=DjtAxlKvPWqS/Q2Gsiay/OIN4pOWtc5NJcme0HZXEKJrVCwiCKLmL18qQIW+AZwNLKeESZjQS0CGXgMDEjSlFlm1YgkFVyetCHsPDrO/XN+eRGH+ojm/SAF0Pkj+8yuwnpp0qUPciUVBDHUBZZ23I1+BFoixou0T+obN4p7Vk/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763580; c=relaxed/simple;
	bh=ig288cnFNJgYfAXWnxtKX7S12Ip674lqWx7qyXsOja0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ8P2DHt2nTGXDlfVep1H23GvMd0qMmgoizaHkfZ9dh/5UIldpM/1DcvnCFSvjjAEJXqoL9hFUhSdwHtkjOWo9JG7FGljK98xj4+sz4wDVlTRYCN+WB7hZKj1tJ1yk0rwAhW+ZQHS0qURVOP4o3KZbjueUn975cu/inzxggkDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAwR7Zvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAwR7Zvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9B8C4CED6;
	Wed,  5 Feb 2025 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763580;
	bh=ig288cnFNJgYfAXWnxtKX7S12Ip674lqWx7qyXsOja0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAwR7Zvj3+4Cl8GM1dvn+/ZQkQLncCSttjM/8Lev/jjpPKKIahyH+yLUYmxImZNGq
	 9tUIBlDXmZ57ncjfr6SmeuLK79qeB9WoGTfRKUME2SAoLevxyViAdAFZUzazL9O1d5
	 j2TDM0xfP1asYx24cCC17FKQXAmPxF4oPBrZWL9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/393] gpio: pca953x: Fully convert to device managed resources
Date: Wed,  5 Feb 2025 14:40:03 +0100
Message-ID: <20250205134423.507964842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 53c59d66c44c5eb98b34da9967f937e5387f8624 ]

Curtrently the error path is unsynchronised with removal due to
regulator being disabled before other device managed resources
are handled. Correct that by wrapping regulator enablement in
the respective call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 7cef813a91c4 ("gpio: pca953x: log an error when failing to get the reset GPIO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 68 +++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index b52548822ecc3..cf5d85c6c8925 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1047,13 +1047,40 @@ static int device_pca957x_init(struct pca953x_chip *chip)
 	return ret;
 }
 
+static void pca953x_disable_regulator(void *reg)
+{
+	regulator_disable(reg);
+}
+
+static int pca953x_get_and_enable_regulator(struct pca953x_chip *chip)
+{
+	struct device *dev = &chip->client->dev;
+	struct regulator *reg = chip->regulator;
+	int ret;
+
+	reg = devm_regulator_get(dev, "vcc");
+	if (IS_ERR(reg))
+		return dev_err_probe(dev, PTR_ERR(reg), "reg get err\n");
+
+	ret = regulator_enable(reg);
+	if (ret)
+	        return dev_err_probe(dev, ret, "reg en err\n");
+
+	ret = devm_add_action_or_reset(dev, pca953x_disable_regulator, reg);
+	if (ret)
+		return ret;
+
+	chip->regulator = reg;
+	return 0;
+}
+
 static int pca953x_probe(struct i2c_client *client)
 {
+	struct device *dev = &client->dev;
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
 	int irq_base;
 	int ret;
-	struct regulator *reg;
 	const struct regmap_config *regmap_config;
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
@@ -1088,16 +1115,9 @@ static int pca953x_probe(struct i2c_client *client)
 	if (!chip->driver_data)
 		return -ENODEV;
 
-	reg = devm_regulator_get(&client->dev, "vcc");
-	if (IS_ERR(reg))
-		return dev_err_probe(&client->dev, PTR_ERR(reg), "reg get err\n");
-
-	ret = regulator_enable(reg);
-	if (ret) {
-		dev_err(&client->dev, "reg en err: %d\n", ret);
+	ret = pca953x_get_and_enable_regulator(chip);
+	if (ret)
 		return ret;
-	}
-	chip->regulator = reg;
 
 	i2c_set_clientdata(client, chip);
 
@@ -1120,10 +1140,8 @@ static int pca953x_probe(struct i2c_client *client)
 	}
 
 	chip->regmap = devm_regmap_init_i2c(client, regmap_config);
-	if (IS_ERR(chip->regmap)) {
-		ret = PTR_ERR(chip->regmap);
-		goto err_exit;
-	}
+	if (IS_ERR(chip->regmap))
+		return PTR_ERR(chip->regmap);
 
 	regcache_mark_dirty(chip->regmap);
 
@@ -1158,28 +1176,13 @@ static int pca953x_probe(struct i2c_client *client)
 		ret = device_pca95xx_init(chip);
 	}
 	if (ret)
-		goto err_exit;
+		return ret;
 
 	ret = pca953x_irq_setup(chip, irq_base);
 	if (ret)
-		goto err_exit;
-
-	ret = devm_gpiochip_add_data(&client->dev, &chip->gpio_chip, chip);
-	if (ret)
-		goto err_exit;
-
-	return 0;
-
-err_exit:
-	regulator_disable(chip->regulator);
-	return ret;
-}
-
-static void pca953x_remove(struct i2c_client *client)
-{
-	struct pca953x_chip *chip = i2c_get_clientdata(client);
+		return ret;
 
-	regulator_disable(chip->regulator);
+	return devm_gpiochip_add_data(dev, &chip->gpio_chip, chip);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1347,7 +1350,6 @@ static struct i2c_driver pca953x_driver = {
 		.acpi_match_table = pca953x_acpi_ids,
 	},
 	.probe		= pca953x_probe,
-	.remove		= pca953x_remove,
 	.id_table	= pca953x_id,
 };
 
-- 
2.39.5



