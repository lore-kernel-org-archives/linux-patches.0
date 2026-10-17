Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2B23C061D;
	Sat, 17 Oct 2026 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255499; cv=none; b=ZcvHMW/wAqrr7DOx6wwpvCQmDbEdvkhnoKe17rWwfEJZwWx+ecZvW94yCXtXXxQu6CkA7RNIyWGpba75LjXqY4oEqLdblYNNuTtQuLy/P7qpQW9Wwvcg99b5qlptqWtjZdGgYHOICiIEoHu2t3lOl5ZQUu8hrVa7CJSD5y3oX/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255499; c=relaxed/simple;
	bh=aOzLJWG+ZcFD1mOLiILPEvRrsgAsw80kCrkf1l2RAd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoIYN7N7Fx6Pd9+Qs3Ueyy6slKRE8zA7C2pLE5QhmTvg7W2H83hEJz8MYkJUTMP34BUuO2VGtA7pCfRswOIZc0aKHil1WgOvdcSc0arI8ZhyF/AOZijdW6dD0KIAktGCZUDXX48C7z9PZFAhM3v4HE4YjlWgXTQdt7vVUuPjhzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apOiwEeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apOiwEeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4761F000C4;
	Sat, 17 Oct 2026 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255497;
	bh=O0vA37wyS+RhFKOc/e4Q2P483TJoVaXIlltxq1WA6Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apOiwEeVmq1ImM5OflwWzUwPoNrusGYnHYWa0/4y8+XVVBO8PzwLTfMZ5cYQWj3Zh
	 8aQ0tLuR9Dyp+yUajT5GbyDU2AZmnwPhA+pfqiMCj6WXtEMeFpcEH/vRkHtCj4U9SD
	 m2rTj4yVx2G7wrO2bOV6jNWLDtFh9CAzDfji5sQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 754/869] pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction
Date: Sat, 17 Oct 2026 17:59:55 +0200
Message-ID: <20261017160056.263533697@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c87c9046c4e00d599454e033a477176c4d73ac2a ]

pinctrl_gpio_direction_input() / pinctrl_gpio_direction_output() take
the pinctrl mutex. This causes a gpiochip operations to need to sleep.
Worse yet, the .can_sleep field in the gpiochip is not set. This causes
the shared GPIO proxy to trip over, as it uses gpiod_cansleep() to check
whether it can use a spinlock or needs a mutex. In this case, it ends
up taking a spinlock, then calls pinctrl_gpio_direction_output(), which
takes a mutex. This causes a huge warning.

While this class of Mediatek hardware does not have separate clear/set
registers, the pinctrl context has a spinlock that is taken whenever
a register read-modify-write is done. Also, once the GPIO function is
selected / muxed in, further GPIO operations do not involve pinctrl
operations or state. The GPIO direction and level values do not require
toggling the pinmux or any other pin config options.

Switch to directly calling mtk_pinmux_gpio_set_direction() in the GPIO
set direction callbacks to avoid taking the pinctrl mutex. Drop the
.gpio_set_direction field in mtk_pmxops to signal we are no longer using
the pinctrl GPIO layer for setting the direction.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 58243ddc1142f..e07ffe1a38bcc 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -771,7 +771,6 @@ static const struct pinmux_ops mtk_pmxops = {
 	.get_function_name	= mtk_pmx_get_func_name,
 	.get_function_groups	= mtk_pmx_get_func_groups,
 	.set_mux		= mtk_pmx_set_mux,
-	.gpio_set_direction	= mtk_pinmux_gpio_set_direction,
 	.gpio_request_enable	= mtk_pinmux_gpio_request_enable,
 };
 
@@ -886,19 +885,22 @@ static int mtk_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
 
 static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned int gpio)
 {
-	return pinctrl_gpio_direction_input(chip, gpio);
+	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
+
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, true);
 }
 
 static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 				     int value)
 {
+	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
 	int ret;
 
 	ret = mtk_gpio_set(chip, gpio, value);
 	if (ret)
 		return ret;
 
-	return pinctrl_gpio_direction_output(chip, gpio);
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, false);
 }
 
 static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned int offset)
-- 
2.53.0



