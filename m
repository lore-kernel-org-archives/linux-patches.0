Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495CB3FD4;
	Mon, 23 Jun 2025 21:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715245; cv=none; b=oeFDWhGHnz4dGkS0zWMHCnKDzH6m4znHwBg40HSRhhsbPEw0bLaqwh9McAodJdbQOwqW6RIpyNYixBU90bCOW+nnmHNVAY5ozSLkyZDPRjsftW0tXvg+9T8b9MguYSshZvLYAaxDEOdks/askn9jJK2ltPV3kWaVBgxAGlecy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715245; c=relaxed/simple;
	bh=whAjewjC93nTo5LEIN6tQwxuuW/fERu55YU9Af7iKYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8e4qzCdSf4qmcp3CAwismjZsEBgZ0MXsLqB+acVqSmzoB3cwFPGNj6L6EDdpH3wsRKdOE3a20RIpq1KTysEZawOyr1D0Z+Cl6XmhJM74SEIuzujpbpUz0CA7Pc+Fc6/m7KG4/68KPt6G+LFuCFnkewpa18CqeA6Ki3/IcEItSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ieabmg9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ieabmg9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D526DC4CEEA;
	Mon, 23 Jun 2025 21:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715245;
	bh=whAjewjC93nTo5LEIN6tQwxuuW/fERu55YU9Af7iKYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ieabmg9qDz1iQFhmZpTboP9UZ90HWAIBwHqpGkwnsf+6eGJ/vMo7hobKDK0V3fGaK
	 Sk8y5sT3cNnDubK9/4Lk5QKawxlaaQjUmpe+SlI7hLJcUj4Z0C+G9V38aF1sBVp2K9
	 9CjSRWt8UrRuFY8z/gcBeWHd0V9dhQtAwLRHBZZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/355] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get()
Date: Mon, 23 Jun 2025 15:07:44 +0200
Message-ID: <20250623130634.659924635@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 57273ff8bb16f3842c2597b5bbcd49e7fa12edf7 ]

The regmap_read() function can fail, so propagate its error up to
the stack instead of silently ignoring that.

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-4-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index bd3eebf564236..ee4457832ccd3 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -439,11 +439,14 @@ static int armada_37xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
 	struct armada_37xx_pinctrl *info = gpiochip_get_data(chip);
 	unsigned int reg = INPUT_VAL;
 	unsigned int val, mask;
+	int ret;
 
 	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
 
-	regmap_read(info->regmap, reg, &val);
+	ret = regmap_read(info->regmap, reg, &val);
+	if (ret)
+		return ret;
 
 	return (val & mask) != 0;
 }
-- 
2.39.5



