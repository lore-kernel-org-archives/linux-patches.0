Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246EC3BD649;
	Thu, 28 May 2026 20:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998441; cv=none; b=qjsQn8W+baqDAZ77pDdlNlFuChPh/Xy/PfNxDpxb5eb2fXp2p2611tqUfShQjf6WlhLXQELf+HrsuW70fOXqc0hHP+z/iRR8xNntLjSn+WilIGGpst5FEpHCq6eolup6o7niSl8i6Y51frjywkm3JqsrdkgRbpZr4ozs66Mppzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998441; c=relaxed/simple;
	bh=/SajcqbNve5NDe4Cs9o5MoQSh2HLAJdDD2wxJRoo7lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSw/GtmJtCXxZ/ETDBQBY1E0KH8W9GvwD0+RxkwOgbhJExzBtAmbjuk0kG8UQ+Kb8Ey1BggdIG2q7V60eWhjE32lW3kPSpxk/57q0a1Ek3n40kOye2eEtsBtuFinjPE6Onl7CwxDvA7CAJk1Q3Xy9sZ9IK1DeEgaKsxe/vENW1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnq+/+HY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnq+/+HY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832F01F000E9;
	Thu, 28 May 2026 20:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998440;
	bh=kqV0QQ3rKHmdh0KZwnWELpei+q5sOxcz1eW5obyZsDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnq+/+HYqDSoM+HyRNqF09FgJImDJFn9GRaTjtMj+shCuZFVzoOOJHVEGb2qslW+L
	 oqFojxOgdRc0hPxB5grx9Jaxhx1DYr92j2giSw2ET5YYnzpIGz48oHMJr18lzbqA4Z
	 QU51hyKw5+KLqS17qonPa4Mz28MRlGKVgWjdRdkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 174/461] pinctrl: mediatek: moore: implement gpio_chip::get_direction()
Date: Thu, 28 May 2026 21:45:03 +0200
Message-ID: <20260528194652.107376713@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit b560d414239232c6ed7205d3795d3f588034d69b ]

If the gpio_chip::get_direction() callback is not implemented by the GPIO
controller driver, GPIOLIB emits a warning.

Implement get_direction() for the GPIO part of pinctrl-moore.

Fixes: 471e998c0e31 ("gpiolib: remove redundant callback check")
Fixes: e623c4303ed1 ("gpiolib: sanitize the return value of gpio_chip::get_direction()")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Closes: https://lore.kernel.org/all/20260409132724.126258-1-linux@fw-web.de/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Tested-By: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 70f608347a5f6..071ba849e5322 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -520,6 +520,23 @@ static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 	return pinctrl_gpio_direction_output(chip, gpio);
 }
 
+static int mtk_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
+{
+	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
+	const struct mtk_pin_desc *desc;
+	int ret, dir;
+
+	desc = (const struct mtk_pin_desc *)&hw->soc->pins[offset];
+	if (!desc->name)
+		return -ENOTSUPP;
+
+	ret = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DIR, &dir);
+	if (ret)
+		return ret;
+
+	return dir ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
+}
+
 static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned int offset)
 {
 	struct mtk_pinctrl *hw = gpiochip_get_data(chip);
@@ -566,6 +583,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->parent		= hw->dev;
 	chip->request		= gpiochip_generic_request;
 	chip->free		= gpiochip_generic_free;
+	chip->get_direction	= mtk_gpio_get_direction;
 	chip->direction_input	= pinctrl_gpio_direction_input;
 	chip->direction_output	= mtk_gpio_direction_output;
 	chip->get		= mtk_gpio_get;
-- 
2.53.0



