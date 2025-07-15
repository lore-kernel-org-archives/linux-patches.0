Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250A72E54B7;
	Tue, 15 Jul 2025 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586473; cv=none; b=cg1WNXlUPb2bIr2bIzMumKaTX63NmLM1BhkeTbg4XaLiryfD0HLyZ2qRE7/QYvB32yoMaMLzg7uvg1p7G2OzrPwY6Or4a26lWfXsz+5gfSjo6+rUPIDJEy53tHIQUJQ/UNQJ8VGxPmc99qH8My8F3iI9/BD4DWkR+F7C0zoCmFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586473; c=relaxed/simple;
	bh=isEq5VTLqcxoU39yH5rWWejHgS5Q1DVG3F26F5Dhjbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HW+73soh2pGxz3VZuAV/cnPABu3WwZZ+brsA5B4rNi5Wn89flggcowpQaaC6TXfd02EttbYT3ypTPw8O2LAQysrpEOYDYuLK6+9Z/8SxNXZyTKN7ug8Oq17cBwdkD9+7jvQvbgfZ8bSStyhT/T8a059tThq1klrCS1icHril0Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Kgl8on2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Kgl8on2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF91C4CEE3;
	Tue, 15 Jul 2025 13:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586473;
	bh=isEq5VTLqcxoU39yH5rWWejHgS5Q1DVG3F26F5Dhjbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Kgl8on2F3kMl2VOlMqNHYA7QFQCA8YCmr+CY7rB6J9GEhIjrr41b+H9HdK4aExVX
	 BASC45GmSA8gPJKtHcdsGd/2GEFaUVabP6uluEQ0+3/rqz5aj3DHM+ur6QOG9Irj7f
	 QfQ9G+SQ5EujXg3QtbAifqV7esGOzhvKD8H9p9sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Neanne <jneanne@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/148] regulator: gpio: Add input_supply support in gpio_regulator_config
Date: Tue, 15 Jul 2025 15:13:21 +0200
Message-ID: <20250715130803.485367760@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 110ee6fe76c4c..e84fc9d724486 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -213,6 +213,9 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np,
 				 regtype);
 	}
 
+	if (of_find_property(np, "vin-supply", NULL))
+		config->input_supply = "vin";
+
 	return config;
 }
 
@@ -252,6 +255,18 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 
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



