Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B752192EC;
	Mon, 23 Jun 2025 22:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717338; cv=none; b=rxLxmrTROh6i1CLmuLT2i9ADebuH4C+jJHRS6HcngjPD1ZKG9pYchsqZnHqI0vIsYeTKlmdH5c2HP25Mpo/pmvwI2bbIlZGBBl2lyOgjsyE33BD31CW3tR7uitofBI1erQeZRmeCb0A/Mr59LLM5hjD+/Vt7qAXwpL+1ppI53oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717338; c=relaxed/simple;
	bh=S8jXtAmEn7M6j3nq8KHtuVQ0/lFhdj9oA9oFr0MLDlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gxtw7AOmNIURCG5pj2d5/UByL+unwfKsgjSorlZ3faCTa3LMbMgG7IoVpDZ7HdjNsK3a74+D+Mvip86glAM/kuI/wj6G7iu2ymh3wHgIgTS1oFwpIJub8VomPvP0ycM4PSZawRIKuKShsVAZZtpOCbev3OJdnLLwALUFYLJnA0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwC5xUsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwC5xUsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134C6C4CEEA;
	Mon, 23 Jun 2025 22:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717338;
	bh=S8jXtAmEn7M6j3nq8KHtuVQ0/lFhdj9oA9oFr0MLDlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwC5xUsH8/pojBtsqOc4Arxdi8G1prvUXVBbc6dj2bPiuRX/NYnm4dMh2qlGQ4yBk
	 s01u2GOPnYsZZpmQo+pUl82OBNnXrnocKqBxLAv6VUhR4sUEekkrL/9HwpRNR806Zm
	 K8gOqGG02G6hzMPyydbTWBnts22JeAVFc6nRZ55U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/508] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get_direction()
Date: Mon, 23 Jun 2025 15:07:32 +0200
Message-ID: <20250623130655.244781637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7483ffa2a409c..e9032359a68a5 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -402,10 +402,13 @@ static int armada_37xx_gpio_get_direction(struct gpio_chip *chip,
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



