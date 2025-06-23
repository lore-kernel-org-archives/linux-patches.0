Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B4024E4C3;
	Mon, 23 Jun 2025 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685070; cv=none; b=tmF6s65nL7kLXt/+1CQOF2UrriT34wD3yBtr4GvBzuWCRxsgRdIhMYc94ugFU7mR55BCDP9A3YUYmLqC7cen0CTWV2kzwe/s7QbdFKh4Y/He+Ux+hkkFbKPi9xkzzaFiT/5adhpcaJHXs6jrDUcCtnttUT1AACJaWfJRCHN5Iu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685070; c=relaxed/simple;
	bh=ksdcIksyoFK/9kWDKVSq8W48Y5Sx+BgfC6SsI03op54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EG1U/Z0RcQE9AeVkAJdWrvVJXxBY5YUjDfDQKzXLeMPhQpIYwKbvkeCBuloBlQ/oeauX1sIONWYNO3VuxDdZ4+Z0mZwBL5iIgX3bTZMWX2InCTfb42Mhky1u+pM/T4Tyl+EgMzlx0tkVAOTXwywvtN1xBC9Hn6tM49EmNBp+09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyDroQlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyDroQlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F47CC4CEEA;
	Mon, 23 Jun 2025 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685069;
	bh=ksdcIksyoFK/9kWDKVSq8W48Y5Sx+BgfC6SsI03op54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyDroQlz3b6KiKCtzD+hvscLH4QyKDMTiaHS9O7sY/NlixtAguma2FN9vCxAsE4Ex
	 lUfMF8aBTaOUoOvg+71ia4wTPrOU/FXvLUWz81MLkg2f8h2uYopcyWvwtUXvV77FcU
	 tS4kj2A3dI+LehW8r/1+dzIgf6xnFxrm1eb/WSug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 230/592] gpiolib: of: Add polarity quirk for s5m8767
Date: Mon, 23 Jun 2025 15:03:08 +0200
Message-ID: <20250623130705.762381138@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 4e310626eb4df52a31a142c1360fead0fcbd3793 ]

This is prepare patch for switching s5m8767 regulator driver to
use GPIO descriptor. DTS for exynos5250 spring incorrectly specifies
"active low" polarity for the DVS and DS line. But per datasheet,
they are actually active high. So add polarity quirk for it.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250327004945.563765-1-peng.fan@oss.nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 65f6a7177b78e..17802d97492fa 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -224,6 +224,15 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
 		 */
 		{ "lantiq,pci-xway",	"gpio-reset",	false },
 #endif
+#if IS_ENABLED(CONFIG_REGULATOR_S5M8767)
+		/*
+		 * According to S5M8767, the DVS and DS pin are
+		 * active-high signals. However, exynos5250-spring.dts use
+		 * active-low setting.
+		 */
+		{ "samsung,s5m8767-pmic", "s5m8767,pmic-buck-dvs-gpios", true },
+		{ "samsung,s5m8767-pmic", "s5m8767,pmic-buck-ds-gpios", true },
+#endif
 #if IS_ENABLED(CONFIG_TOUCHSCREEN_TSC2005)
 		/*
 		 * DTS for Nokia N900 incorrectly specified "active high"
-- 
2.39.5



