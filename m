Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89313AE713;
	Sat, 17 Oct 2026 16:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255492; cv=none; b=B/Ucz8rKuwzF3WcF1wOEfI3TxNScrit/9YSVR/ko3On/GSS7jmFKyXI71V7z30QzTyfK3wjyec2Hzn5Q/iTcYl+/jQB0aEOiSaQ531vnAi+cEMk4VCeF7/HscSwbrXz05S8/DGW6kx66NyYZ2heyUqR81e/qU1kcmQ8+Tc7hQtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255492; c=relaxed/simple;
	bh=twa/D8Nl8MLM/jtzUPDNty7zFF7t0EK8a19rgajaREc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btaeRAIF3bvjOZoInK6VOl8zH2Yacsj2uKzrSwc2zYkGvNe/aoQ2cBmNEQK1UuItiCZxAdm+9CWyR4+lRsNLVNjYoT9m5gI8ULIn1rKuqff1aqXA1ZOMhZVDfmyrHmKqt777a67sm/by6WvisBNNZhDzEhyU0EK+1g0JCR9UbKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2Olzm9U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2Olzm9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2E51F000C4;
	Sat, 17 Oct 2026 16:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255491;
	bh=BuU0qdUM4YIVNP5DAgrLPLF5TaKj2nHMvoIyEKcksy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2Olzm9UhAMtXdyghPRfAZICH9QOjTeJGYi4NKgaDixQX5Y78i054HeOX87pg1iFa
	 V9IHNUOjL8AiPqAku6RmfKZIUoZLWQwJMwsWXI+QXirM3ulXwij7RWVEF69DhChhn4
	 LmnFwqonhGiVyFaMrAKSYIeY97iHfzXpWxAhgUV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 752/869] pinctrl: mediatek: paris: dont double-check the GPIO number
Date: Sat, 17 Oct 2026 17:59:53 +0200
Message-ID: <20261017160056.214868550@linuxfoundation.org>
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

[ Upstream commit 9c791cbaf3cf2671404dc4f7679548071b38e104 ]

GPIO core already makes sure we don't pass invalid GPIO numbers down to
the driver callbacks. Remove needless checks from the driver.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/20250425-gpiochip-set-rv-pinctrl-mediatek-v1-2-93e6a01855e7@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c87c9046c4e0 ("pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 363a02106d401..dcb2e420f5e71 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -840,9 +840,6 @@ static int mtk_gpio_get_direction(struct gpio_chip *chip, unsigned int gpio)
 	const struct mtk_pin_desc *desc;
 	int value, err;
 
-	if (gpio >= hw->soc->npins)
-		return -EINVAL;
-
 	/*
 	 * "Virtual" GPIOs are always and only used for interrupts
 	 * Since they are only used for interrupts, they are always inputs
@@ -868,9 +865,6 @@ static int mtk_gpio_get(struct gpio_chip *chip, unsigned int gpio)
 	const struct mtk_pin_desc *desc;
 	int value, err;
 
-	if (gpio >= hw->soc->npins)
-		return -EINVAL;
-
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
 
 	err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DI, &value);
@@ -885,9 +879,6 @@ static void mtk_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
 	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
 	const struct mtk_pin_desc *desc;
 
-	if (gpio >= hw->soc->npins)
-		return;
-
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
 
 	mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DO, !!value);
@@ -895,22 +886,12 @@ static void mtk_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
 
 static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned int gpio)
 {
-	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
-
-	if (gpio >= hw->soc->npins)
-		return -EINVAL;
-
 	return pinctrl_gpio_direction_input(chip, gpio);
 }
 
 static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 				     int value)
 {
-	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
-
-	if (gpio >= hw->soc->npins)
-		return -EINVAL;
-
 	mtk_gpio_set(chip, gpio, value);
 
 	return pinctrl_gpio_direction_output(chip, gpio);
-- 
2.53.0



