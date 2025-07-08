Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092371E492;
	Tue,  8 Jul 2025 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994213; cv=none; b=ByR+Kg+4Bw4prBhbgn1F1LU03owL3TK7sstTfDrPZeXoTlOtiDWOGyPIbNRpd87ob8I47aPN/qzmIacy5poqGIL3shBemaE7IV1jkVRkJc6M/m5IoCnVoZfYuIh/FF2D2A2fjG7N9d23877YUvJ/OIbzjkxQFuf8CCdl8xIs74Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994213; c=relaxed/simple;
	bh=ljuGBNipfrt4rs83YwxONO8iqZsguWOEcC6ZBEzq71Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnwvYH7yARTHesz2zLj9zt39iC/ixuV/x6NGbuyTmNAYrAKepeuJhb6TPG0VoYxvOszG815fi2P0wqHf54CP1qxjfCD0bDporEW2oy3Tad6TozGccMqJBdrPY/LC9ZGKt4YWw7zPmA9opjuhXRzzha8qsTJMvrfvKvsPjK5ljaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Noty/Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Noty/Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869D6C4CEED;
	Tue,  8 Jul 2025 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994212;
	bh=ljuGBNipfrt4rs83YwxONO8iqZsguWOEcC6ZBEzq71Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Noty/EuagZ/MYgnJ+P7DCkb4eM6rF5gq/9+qv+q0XHHuZ8NI0dJk/0JFQuWrbpzV
	 B1sI3WPCkkfjlHObaOspIUX/PeQEdabdG+xhE5NNagXWlzs8bf+O5RAXFPUU6vIqXk
	 S9dU2mNdN66heOW7IvDQuRHi2VigY7mvWs71s+5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Neanne <jneanne@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/160] regulator: gpio: Add input_supply support in gpio_regulator_config
Date: Tue,  8 Jul 2025 18:22:55 +0200
Message-ID: <20250708162235.196311806@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Neanne <jneanne@baylibre.com>

[ Upstream commit adfdfcbdbd32b356323a3db6d3a683270051a7e6 ]

This is simillar as fixed-regulator.
Used to extract regulator parent from the device tree.

Without that property used, the parent regulator can be shut down (if not an always on).
Thus leading to inappropriate behavior:
On am62-SP-SK this fix is required to avoid tps65219 ldo1 (SDMMC rail) to be shut down after boot completion.

Signed-off-by: Jerome Neanne <jneanne@baylibre.com>
Link: https://lore.kernel.org/r/20220929132526.29427-2-jneanne@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c9764fd88bc7 ("regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/gpio-regulator.c       | 15 +++++++++++++++
 include/linux/regulator/gpio-regulator.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 5927d4f3eabd7..95e61a2f43f5d 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -220,6 +220,9 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np,
 				 regtype);
 	}
 
+	if (of_find_property(np, "vin-supply", NULL))
+		config->input_supply = "vin";
+
 	return config;
 }
 
@@ -259,6 +262,18 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 
 	drvdata->gpiods = devm_kzalloc(dev, sizeof(struct gpio_desc *),
 				       GFP_KERNEL);
+
+	if (config->input_supply) {
+		drvdata->desc.supply_name = devm_kstrdup(&pdev->dev,
+							 config->input_supply,
+							 GFP_KERNEL);
+		if (!drvdata->desc.supply_name) {
+			dev_err(&pdev->dev,
+				"Failed to allocate input supply\n");
+			return -ENOMEM;
+		}
+	}
+
 	if (!drvdata->gpiods)
 		return -ENOMEM;
 	for (i = 0; i < config->ngpios; i++) {
diff --git a/include/linux/regulator/gpio-regulator.h b/include/linux/regulator/gpio-regulator.h
index fdeb312cdabdf..c223e50ff9f78 100644
--- a/include/linux/regulator/gpio-regulator.h
+++ b/include/linux/regulator/gpio-regulator.h
@@ -42,6 +42,7 @@ struct gpio_regulator_state {
 /**
  * struct gpio_regulator_config - config structure
  * @supply_name:	Name of the regulator supply
+ * @input_supply:	Name of the input regulator supply
  * @enabled_at_boot:	Whether regulator has been enabled at
  *			boot or not. 1 = Yes, 0 = No
  *			This is used to keep the regulator at
@@ -62,6 +63,7 @@ struct gpio_regulator_state {
  */
 struct gpio_regulator_config {
 	const char *supply_name;
+	const char *input_supply;
 
 	unsigned enabled_at_boot:1;
 	unsigned startup_delay;
-- 
2.39.5



