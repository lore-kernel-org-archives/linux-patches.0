Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F8F171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2141C433D2;
	Mon, 22 May 2023 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784835;
	bh=sm5QAcd0taaclIH56EabPTS7FFL37JY5nKCmhFvm5pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBjGliVvmytZQ1Q4PCfo5oTFSe5ak5NAAtRsU64ZId+PEggUI85sHpsTY9JOxLLmh
	 t8IL6bZGD5p6SCfLEyO5Mb/nqQTLBMICZibgMrd/udQZeONMzP+io8SvMxIbyC/S1y
	 KkKuhhXq2ZyIu1dxJRHgv+N38/ttU+tT5i318hxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 189/364] pinctrl: at91: use devm_kasprintf() to avoid potential leaks (part 2)
Date: Mon, 22 May 2023 20:08:14 +0100
Message-Id: <20230522190417.460250968@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f494c1913cbb34b9e2078b7b045c87c1ca6df791 ]

Use devm_kasprintf() instead of kasprintf() to avoid any potential
leaks. At the moment drivers have no remove functionality hence
there is no need for fixes tag.

While at it, switch to use devm_kasprintf_strarray().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230215134242.37618-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 735c501e7a06c..9fa68ca4a412d 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -18,6 +18,7 @@
 #include <linux/pm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/string_helpers.h>
 
 /* Since we request GPIOs from ourself */
 #include <linux/pinctrl/consumer.h>
@@ -1371,6 +1372,7 @@ static int at91_pinctrl_probe_dt(struct platform_device *pdev,
 
 static int at91_pinctrl_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct at91_pinctrl *info;
 	struct pinctrl_pin_desc *pdesc;
 	int ret, i, j, k;
@@ -1394,9 +1396,19 @@ static int at91_pinctrl_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	for (i = 0, k = 0; i < gpio_banks; i++) {
+		char **names;
+
+		names = devm_kasprintf_strarray(dev, "pio", MAX_NB_GPIO_PER_BANK);
+		if (!names)
+			return -ENOMEM;
+
 		for (j = 0; j < MAX_NB_GPIO_PER_BANK; j++, k++) {
+			char *name = names[j];
+
+			strreplace(name, '-', i + 'A');
+
 			pdesc->number = k;
-			pdesc->name = kasprintf(GFP_KERNEL, "pio%c%d", i + 'A', j);
+			pdesc->name = name;
 			pdesc++;
 		}
 	}
@@ -1797,7 +1809,8 @@ static const struct of_device_id at91_gpio_of_match[] = {
 
 static int at91_gpio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct at91_gpio_chip *at91_chip = NULL;
 	struct gpio_chip *chip;
 	struct pinctrl_gpio_range *range;
@@ -1866,16 +1879,14 @@ static int at91_gpio_probe(struct platform_device *pdev)
 			chip->ngpio = ngpio;
 	}
 
-	names = devm_kcalloc(&pdev->dev, chip->ngpio, sizeof(char *),
-			     GFP_KERNEL);
-
+	names = devm_kasprintf_strarray(dev, "pio", chip->ngpio);
 	if (!names) {
 		ret = -ENOMEM;
 		goto clk_enable_err;
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		strreplace(names[i], '-', alias_idx + 'A');
 
 	chip->names = (const char *const *)names;
 
-- 
2.39.2



