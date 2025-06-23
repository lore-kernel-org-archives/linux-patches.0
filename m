Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C23218580;
	Mon, 23 Jun 2025 22:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716287; cv=none; b=rb50jYPE607fFcRvk1shS63i/CoF8QA33h3KPXbdQhtRuuwfXk66Lwt6C4wwYY2HpNbRPnawuZM2IAuceTNbKV6iWJQKYZ1YCrr65MGmaFJAmPQPfy5QauwBa+lwUiiMGE6J5f/83xVCwWAu6jEIV5zO/ha6omA51IgtVcihVeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716287; c=relaxed/simple;
	bh=HWzGtFxdmTOiYY3Ha7nAdLTpEwj5JUXd1KHbcuwOdOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNJFS6isSTm/Vd10u0mgC51gIoYnV7VRmciTcU/Y2cz3GpPyiDTtj0co0O4Fwij9SkkGDqAsTT0xw12H64p4WhPixiBnluLDF0ejLEk5awr/lScBc73Q1LRuI/DEemdAn3RQI22X+JWX8F2aUJ2N19DMaOMl2izJHumAXrEnQN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0yX86+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0yX86+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61F6C4CEEA;
	Mon, 23 Jun 2025 22:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716287;
	bh=HWzGtFxdmTOiYY3Ha7nAdLTpEwj5JUXd1KHbcuwOdOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0yX86+LsjISeKMu23h9mkg4qlNWkgTGpJ/XkvdyA3vrJTtJWm9X0ItkYFX2NLJ/t
	 jogfQJdmQ13t9i790/BTilRDwWtrf+pBy1vgpq9ox26YQOE05AbLQ66OrrPEF9uShA
	 HvNnTIKzJp/wbk18hatmv7cMJpprmARh7S3CXTHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/411] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get_direction()
Date: Mon, 23 Jun 2025 15:07:43 +0200
Message-ID: <20250623130641.665513567@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 6481c0a83367b0672951ccc876fbae7ee37b594b ]

The regmap_read() function can fail, so propagate its error up to
the stack instead of silently ignoring that.

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-6-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index e95d30ef5711b..3a9a3a1d5d4be 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -396,10 +396,13 @@ static int armada_37xx_gpio_get_direction(struct gpio_chip *chip,
 	struct armada_37xx_pinctrl *info = gpiochip_get_data(chip);
 	unsigned int reg = OUTPUT_EN;
 	unsigned int val, mask;
+	int ret;
 
 	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
-	regmap_read(info->regmap, reg, &val);
+	ret = regmap_read(info->regmap, reg, &val);
+	if (ret)
+		return ret;
 
 	if (val & mask)
 		return GPIO_LINE_DIRECTION_OUT;
-- 
2.39.5



