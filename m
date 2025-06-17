Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EBF2EA171;
	Tue, 17 Jun 2025 16:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177113; cv=none; b=stUi1L63s3XVhtG2deKRXAnxpuheWREEDrOaeiN4MjP8pzPWwXYuwpi6R491mdXxA0zmxr3VInvy8C9sp0wemI5EnvAQkry556nUkuX2Mvlx/qqpYedbkhGVY4OtZfyT/As/RtNLf1DkzONrdko4hQgELcX+SyOuC56nX6EAI4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177113; c=relaxed/simple;
	bh=W7GsFWZ55GfreyyIwnVD6FU7lQjvEJSR4TFTRzFA+Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxz+spooSXY33a1p6kCB79PnE9E+avcj1LPipYEVJGt37BiH6e5eDd8USXEC5PZdRZwXNzTUp9wv6eF3i8nPgAIgtoO46CEE4pawEIxkfDHRgvJHE7IP8h7W3ovXp69CVeEATgV6a+ITT/w61WduNEur9utz1jKovMOedYxWwXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd6jl5OL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd6jl5OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C689C4CEE3;
	Tue, 17 Jun 2025 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177113;
	bh=W7GsFWZ55GfreyyIwnVD6FU7lQjvEJSR4TFTRzFA+Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bd6jl5OLDsHRkRdMGZgU+bAgaXcG63um1kQbVxCJj81IiF1Ce8UP7J2ugeoMhkdou
	 Lb+yS1Nvq2Un+TmzdidS9K7ucKl2oaR0fFFUtgsZvTwSEheZv8ASKpTf/FJV5PUSRq
	 8v1v9KaRzJaS2c7OwZm9k8HBUdMeJlnFI57Cdd8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 262/780] pinctrl: at91: Fix possible out-of-boundary access
Date: Tue, 17 Jun 2025 17:19:30 +0200
Message-ID: <20250617152502.122458726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 762ef7d1e6eefad9896560bfcb9bcf7f1b6df9c1 ]

at91_gpio_probe() doesn't check that given OF alias is not available or
something went wrong when trying to get it. This might have consequences
when accessing gpio_chips array with that value as an index. Note, that
BUG() can be compiled out and hence won't actually perform the required
checks.

Fixes: 6732ae5cb47c ("ARM: at91: add pinctrl support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/r/202505052343.UHF1Zo93-lkp@intel.com/
Link: https://lore.kernel.org/20250508200807.1384558-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 93ab277d9943c..fbe74e4ef320c 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1819,12 +1819,16 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	struct at91_gpio_chip *at91_chip = NULL;
 	struct gpio_chip *chip;
 	struct pinctrl_gpio_range *range;
+	int alias_idx;
 	int ret = 0;
 	int irq, i;
-	int alias_idx = of_alias_get_id(np, "gpio");
 	uint32_t ngpio;
 	char **names;
 
+	alias_idx = of_alias_get_id(np, "gpio");
+	if (alias_idx < 0)
+		return alias_idx;
+
 	BUG_ON(alias_idx >= ARRAY_SIZE(gpio_chips));
 	if (gpio_chips[alias_idx])
 		return dev_err_probe(dev, -EBUSY, "%d slot is occupied.\n", alias_idx);
-- 
2.39.5



