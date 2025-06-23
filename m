Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25633FB1B;
	Mon, 23 Jun 2025 21:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713109; cv=none; b=dsAhJeBbLi1rhu02WORfLnJS4gaZs0LeHad1OEsrT0zCtlxq96x0bTsHuvtwrPRJqiE0aTRebt9W3KcpmVwgMYmD/cJ/buPkXl3UVUQhzfTyp026bjYfuVl3zSuZo2xy1TgraHQzI3uOAAxbO74KGDC+Qqk7V+l/CFMbLm0tWd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713109; c=relaxed/simple;
	bh=qQZNQ/+ikXMf2l+8U34P7RhIN2D5I3EL/y9ogB6+AQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAhnkqGz02k16fgP4unLAKaiq8rKa83J0eIXbvjFzNembcOEf/rAVHHxRStIC1bEdkBSP1fh/gg13DLqTFMT+uF71bKghrHgu+o4uf/h7Qgar4zhjehuSjvmMDAEzYekeevvVu7DZurqJ0sUvMtT5EaRT1aNIEbYf9ktNOwnCEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq55m00w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq55m00w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32035C4CEEA;
	Mon, 23 Jun 2025 21:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713108;
	bh=qQZNQ/+ikXMf2l+8U34P7RhIN2D5I3EL/y9ogB6+AQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq55m00wMGf1Iz3HUh/mktOwhtwhmUdKjS5AL4dCC3+pvgWN6kz25FyG20L1G4zvP
	 RzoM+NLwKtP6n/LDASRNy0JfdlAeW9432xtF2eaFDfUem0Y/ExJ5t8nA/grm9pkiub
	 4qzOuKvPtJQzsa9EHzBZbsFB544OOjmoQggs/ZQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/508] pinctrl: at91: Fix possible out-of-boundary access
Date: Mon, 23 Jun 2025 15:02:06 +0200
Message-ID: <20250623130647.233121635@linuxfoundation.org>
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
index 333f9d70c7f48..b82368ec59f4c 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1812,12 +1812,16 @@ static int at91_gpio_probe(struct platform_device *pdev)
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



