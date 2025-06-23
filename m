Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480001E51FA;
	Mon, 23 Jun 2025 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714045; cv=none; b=JZuB9o+MLQXut726wVGKCWqg1pjNVZfdG7+cehelpmlAz7ITmppKdT8/KQi1z4iwJHnNfdr/UBeGdpFuaD0qBAo3FXYM6hbVjMmsLlPp42X13TQAqujl+K653wf7wHJiV3n+JV0sGd8X7fDDdLbfQJ0W/ePz0TOEVSBJoTemU4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714045; c=relaxed/simple;
	bh=qn3+BK3nZltS7kwqLeED0W0H0mn2NcjBED8KAXJcubg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHQmgo/1MNYrKSXLlCEE4u3KhF7glhxzMfyoLdMFKcff7sxsOh3FxH4MI/43x8CFO0cgl3inIFH9W6wFlaUsxvkJgTUnjK5/f7MT4nuZbyiJkMayE3ircEJK+JC07F8y9wy5+3FcmXEcnSQcupVl8/Em9FwmMhlXQB9n5wopV6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdZvtln4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdZvtln4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4746C4CEEA;
	Mon, 23 Jun 2025 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714045;
	bh=qn3+BK3nZltS7kwqLeED0W0H0mn2NcjBED8KAXJcubg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdZvtln4rAw4jpkElwj+BmQXc+Bydpj2wkHcSXZnUyRkRkrTfYSsuXS61Bybxc2MI
	 SPAbWKMuRD2IZy4RY+hBBN6mbIVsXu4RgbexS3cEKxr+w2zMSl5/+AtIGJCikpRq+n
	 dLQY74/TqgfN2iWNrdwijyQb84QzlCgQclvUpzmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 360/592] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get()
Date: Mon, 23 Jun 2025 15:05:18 +0200
Message-ID: <20250623130709.005457785@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 15f257a856098..5c0177b4e4a37 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -443,11 +443,14 @@ static int armada_37xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
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



