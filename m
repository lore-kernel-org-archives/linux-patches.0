Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36562F24;
	Mon, 23 Jun 2025 13:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684810; cv=none; b=i1zgu7AnGyz7AOb/DfiAp303UsbsNXp1yai3G8TxYLBGADYM5qBqqDhotPPw++3PTvI9Qo5aP6tO3s9h1k7SXLdDAUEZEiUryuy+p/ywmwyc3nBLZOKOAF90wkmwS1DYfOnU7d2ckbWRKeVOS+5wg2R8Q11xhZhUc7LNqNXSIwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684810; c=relaxed/simple;
	bh=eh86hXMZRy8VP2znYHUmFdW4Y1h2j++XMgefIsC5iSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSLvjDM4ujIeyj+UXcUpyORUsvrvZIAd3wkhD6Fu/mffv+C+heQjwscxJrF9wljzBnuHvpAkM5V0ErblVKXarzKkTeqItNq6Iqf74ufnZ3CEAmfpaBBGjqiwivhsjhPZmwe4ppI+k0PdT59DsXTEoiRhVTo8sWrgrsoQ00JPT6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sahDWfOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sahDWfOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868A5C4CEEA;
	Mon, 23 Jun 2025 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684809;
	bh=eh86hXMZRy8VP2znYHUmFdW4Y1h2j++XMgefIsC5iSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sahDWfOxyOXx2VH0tFFG219cNuUfG3gkvHWUkJdQJH+zQNhgj0IG8KbsXmV3t8ruY
	 bHErPvpDpn7Kd+c+HWJuG83QwLWyG/S+twCoJPV6wc5c2eSrAwd7n6+mCUYUWhRP/h
	 9e7QGrcDmg4lezItoVJ90JpTLKDwA+a1uOSXzs8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/222] pinctrl: at91: Fix possible out-of-boundary access
Date: Mon, 23 Jun 2025 15:06:08 +0200
Message-ID: <20250623130612.896235812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4e6e151db11f2..4265a4055a382 100644
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
 	if (gpio_chips[alias_idx]) {
 		ret = -EBUSY;
-- 
2.39.5



