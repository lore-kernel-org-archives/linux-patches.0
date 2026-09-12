Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC17F4F1;
	Sat, 12 Sep 2026 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232090; cv=none; b=R7qe4NkhondtKHBniUcFftOTizUnE7Dwx63X2gB40fOUtaxw/V2K7Iq8+88BgxJPiim1/RvPL+PECi1ptdD2aDAuZo1V+xefSuo/QvK6ydQztwyoIGheuSWep1ZGbUAO7CToYmZ7u2TSqRrjh98U9L3Jwhmh6wgdIrVQ6aHuo7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232090; c=relaxed/simple;
	bh=dgLEQFvXhttvYliEslP0lkqQ+K9fFlTfwQ5TpQRN7nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACcc6lqnqupwodcdzSgqUFyef5iQwewtT6pAcFgKs2n3T9VG53z7bnRFNzoZ1eSi+ujRKC8OxqBbRRIgR8l06QhaH3lTEZPMp/buC+3qqAse7SFKj5eA/6hVbEP2Ieu6guExAPrbmryi9JXQosCIs8TCraICAphh1Pcq/A5q4tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFuyNNDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFuyNNDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A121F000FF;
	Sat, 12 Sep 2026 16:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232089;
	bh=TTAJzDQZdeE57lMv4wIfysx5OWsXlYxlE6OZORkseyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFuyNNDqARta/QxtKLqX8nmrY55qDvhxjw9T1AZPbJLkgl5VJyEvzPHR2dPKYkJQJ
	 hJrAVX8fPmkHOHoUa5DpRZV8pM5WRcrJVVpYV3VCNFDoSTysSVZXW2hOFX2X4fnnrQ
	 Dh7+eJD4rCEyJQ+fc2OfQ2n5cIhccs3lxRQ97Hu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1131/1191] net: stmmac: selftests: Check multiple MMC counters
Date: Sat, 12 Sep 2026 09:04:19 +0200
Message-ID: <20260912065613.555700576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index abad2dac40cfa..124e5a78abc26 100644
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



