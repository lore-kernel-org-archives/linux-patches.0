Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC822ED17C;
	Tue, 17 Jun 2025 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175822; cv=none; b=TU9qnXLa9qa8J/XVzzztpDr9tppYeA+GT1Gvr/+oDNN0xHZjGwZbYRZwOfu/zADifZBLsWrHR/53ZIpJvcvKitLRcFeERw9dPQPLcpxBOp1FT1f1Nys5PTZr8LmVykYnsFBmEK8ez+t4eeE6aLrHAjeM1EgdAFqkc8JHb8Cn24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175822; c=relaxed/simple;
	bh=+ZTW2jqkmuH0ePxMQZbPruX/HNk9P/VkRuqFeQ7IGEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rq/NmMn8ORPyzDm24KOcwUMZEmVLEEC07nQXOVh+crpARyx+A29UVL4FDzXagJo/5izpO0dLE5dL3XotJSF761fGKAkNk6DsLDOwlt+DETrZrcIouZ99sjAKtXe7jYfD9vTl19BxjZxRaMO99g3JByuSGWT1gWMZJmVxNbvhXy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdiACq8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdiACq8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4AAC4CEE3;
	Tue, 17 Jun 2025 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175822;
	bh=+ZTW2jqkmuH0ePxMQZbPruX/HNk9P/VkRuqFeQ7IGEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdiACq8faAk0DWLiHltwsp/fCgPAN+DSb6VKa6eKPrbqbOBN8oEE1YcK77bKxMsWA
	 z6Bk0PIS6blKbSgmDjbg/HPAWzlzo6aqE3oDOZOIFs/A0QAMSW2gMZFOlbS3dPCn2k
	 ur0GmzvLm2EMc70+a4M8q83nsobIZ2g/Hm8vTi1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/512] pinctrl: at91: Fix possible out-of-boundary access
Date: Tue, 17 Jun 2025 17:22:12 +0200
Message-ID: <20250617152426.345963481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



