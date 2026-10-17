Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C793939E16B;
	Sat, 17 Oct 2026 16:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255495; cv=none; b=d26Q5sOsQHQSH1PN0jXd9VT4xACTPcilykhew0sHIOzHWIhsLMzHv4104e2zjvjRMh+Pl/R/l5u5eJfKui2LeG8QR0FAMFKIx2fujfIfkUCU4j79BB0p+piJ/GbB+5Ov077647+GFnaSJj0FWBGpZqT9Y6wBJFu4TURZjZZkMMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255495; c=relaxed/simple;
	bh=9X+oxwbp4SVjCWdMSRtJEba55yU7NR7wseHHOgeLAls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs4H2CvzckiehiMYU/fqw+jAslxUieYteg0UVjdm+e7Byy1yLMri7XEwgqwwrVrs9MSaEWFA8jiMULTlWwSsTYd2UWehjTY+hwWi8c07NDq10V4wzTXEC0I1lHs8RTitlTU+Lah7NdsFix8E26b2mgbidiy4vAim8b5QdKis3V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/EwCWQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/EwCWQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB2F1F000C4;
	Sat, 17 Oct 2026 16:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255494;
	bh=KrLiTbWF1kEyEfobuvANpPDCAsGUWPEKsQw41nKq+I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/EwCWQ8YSEjWQjMc7I9WrwpYj12MHcwJr2zF6+ZNvsLurSt2jeEC08I891fgEGv2
	 wGr2aFHMTy5dsOrOWnD467e7YBJIxvT63OEGuO6mmWY0qiN31c2Am+Xcs9ABJwFse3
	 up1Rfz8M4SqetPmNXZQgu2RDQSjANtGaERA4J3Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 753/869] pinctrl: mediatek: paris: use new GPIO line value setter callbacks
Date: Sat, 17 Oct 2026 17:59:54 +0200
Message-ID: <20261017160056.238195262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 1849d1a3d388caf898b18791c40edac464c809d1 ]

struct gpio_chip now has callbacks for setting line values that return
an integer, allowing to indicate failures. Convert the driver to using
them.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/20250425-gpiochip-set-rv-pinctrl-mediatek-v1-3-93e6a01855e7@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c87c9046c4e0 ("pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index dcb2e420f5e71..58243ddc1142f 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -874,14 +874,14 @@ static int mtk_gpio_get(struct gpio_chip *chip, unsigned int gpio)
 	return !!value;
 }
 
-static void mtk_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
+static int mtk_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
 {
 	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
 	const struct mtk_pin_desc *desc;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
 
-	mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DO, !!value);
+	return mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DO, !!value);
 }
 
 static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned int gpio)
@@ -892,7 +892,11 @@ static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned int gpio)
 static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 				     int value)
 {
-	mtk_gpio_set(chip, gpio, value);
+	int ret;
+
+	ret = mtk_gpio_set(chip, gpio, value);
+	if (ret)
+		return ret;
 
 	return pinctrl_gpio_direction_output(chip, gpio);
 }
@@ -945,7 +949,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->direction_input	= mtk_gpio_direction_input;
 	chip->direction_output	= mtk_gpio_direction_output;
 	chip->get		= mtk_gpio_get;
-	chip->set		= mtk_gpio_set;
+	chip->set_rv		= mtk_gpio_set;
 	chip->to_irq		= mtk_gpio_to_irq;
 	chip->set_config	= mtk_gpio_set_config;
 	chip->base		= -1;
-- 
2.53.0



