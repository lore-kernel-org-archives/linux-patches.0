Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00A835C69C;
	Sat, 12 Sep 2026 19:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240668; cv=none; b=YowBffadaZSZOVPw2olIPgVhH9mEa62Svdzn0BwRzmt8inNW3EzC62m/6s3m5eZqYo/jTeplWFvIN2eNK0/VhIv7TBXDZ9u3dBmwwZXYbJUseNERu7Mrr7cL75EznCMXmmMAGbtMCDjYi2lxIw0DVGJDyWzWXiVdaghrp7GVTZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240668; c=relaxed/simple;
	bh=VmcAuDXZCLgJiWejEKveBP+0nC3mZpJZncV05XiJ4CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiCCC/0MrMERwaBTTeV/4AElkU3/5F6h1BiYOBOhheMSPhU5YthVocpwH13iBlU708YOgAizq6XOhvbLps11FglrqCSWD98KoL8ef9wE0AX4wYvk3z5HQDI9MbVI5BNcUB1Tm+1zmQYhyWVl0/MnwOf4Hf8p/rg9zI9qTS0IZEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2bTfOoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2bTfOoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5043F1F000FF;
	Sat, 12 Sep 2026 19:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240667;
	bh=yBB849bFDXDXNy1LAERgeHvzQj4ETn8tNvfsLB9jdUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2bTfOook+feh1Znq3ROJ8CHrVFRBpF1/+0lG6J4QOvBQPd1WCuIv35JMEXu2R88H
	 N9WDYkx7UtZwZf35PknTgyz8gOExRQsJGsjh6UxfJ7NdroyplrwITAU5IwbKLj+5ga
	 ljgYKJh8wWCRwGJFVyXjBL4xMrKDzNkpqCEp1jlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 916/935] net: stmmac: selftests: Check multiple MMC counters
Date: Sat, 12 Sep 2026 09:05:46 +0200
Message-ID: <20260912065547.829072744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit d29b399150b07796dfa81d8778d4804c08c2a41d ]

The MMC counters report MAC statistics. Multiple counters can be
enabled when the IP is integrated, however there's no way to know
exactly which ones. Un-implemented counters seem to report 0.

It was found that on StarFive JH7110 and Amlogic SM1, the counter that's
used by the selftest (mmc_tx_framecount_g) isn't implemented, triggering
an MMC selftest failure.

Both the above SoCs seem to implement mmc_rx_framecount_gb, let's use
this counter as well for MMC counter validation.

Note that this doesn't guarantee that we won't encounter the same issue
again if another IP implements yet another set of counters that don't
include that new one.

If the game of whack-a-mole with implemented counters becomes too hard to
maintain, we may simply consider removing the MMC selftest entirely.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-2-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index c338c7b8658e9..0cf3bbfd10589 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -415,11 +415,17 @@ static int stmmac_test_mmc(struct stmmac_priv *priv)
 	stmmac_mmc_read(priv, priv->mmcaddr, &final);
 
 	/*
-	 * The number of MMC counters available depends on HW configuration
-	 * so we just use this one to validate the feature. I hope there is
-	 * not a version without this counter.
+	 * The number of MMC counters available depends on HW configuration,
+	 * and there doesn't seem to be a way to enumerate the implemented
+	 * counters.
+	 *
+	 * Let's check a hand-picked set of counters, knowing that :
+	 *  - Starfive JH7110 doesn't implement mmc_tx_framecount_g
+	 *  - Amlogic SM1 doesn't implement any mmc_tx_*
+	 *
 	 */
-	if (final.mmc_tx_framecount_g <= initial.mmc_tx_framecount_g)
+	if (final.mmc_tx_framecount_g <= initial.mmc_tx_framecount_g &&
+	    final.mmc_rx_framecount_gb <= initial.mmc_rx_framecount_gb)
 		return -EINVAL;
 
 	return 0;
-- 
2.53.0



