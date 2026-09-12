Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F112C15A9;
	Sat, 12 Sep 2026 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219328; cv=none; b=aky6ExIYXQ6CMpcrA3eAI30Ogv7TGk6wE/oRkAPfKjtomxyM6vtHymIVoCQO5y92rRZxzeLm8ivi/OK3E/xTHPgBtSK1Xe4qz5wPI7du5DWctblFijcvb4jIJ3GhbQIaTw0GcSlH+qL7JBbeyEi2NgDq3zlBIMruiUBP4qPpU54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219328; c=relaxed/simple;
	bh=3QCePi5vLeDVr4ZJ1ByTchnRVZk/75Cvgja6S0pb25E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzMjoPtjdAfPe0ZtS2Ivkm7VI2aYI0dHQQg0A0V8J20jEA94XkDG4OWoi95Sbl9tBJlRvetv6CasnfBADyMMK/nTOzLT63+P5V9img+o8vnFalc8pH1aV0xomXZhEepfbl0jSe9VOyB6TSnOFmx/TABDImCxtClvZJPqhq7vbbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKzu9jJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKzu9jJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAE11F000FF;
	Sat, 12 Sep 2026 13:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219327;
	bh=srExRMlZnHdPdL3DWgiVybUPkVhl8Agl3tyFFu016bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKzu9jJTpNFawbgCEmOO9994SnA6nIz7LR66lcE2rTwipbAHYk+0cwWbsKFlqBwYg
	 kYAGLG7X88xm+a0jrDdulIYqVyh21jNGKxN4TM9+yzVBP+L4nzKB+2ZBYCv48+MNJr
	 Zc0OaWPMghUU+qiCUGqs7bqXNYF/lIEdx1PjwOQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1327/1376] net: stmmac: selftests: Check multiple MMC counters
Date: Sat, 12 Sep 2026 09:02:33 +0200
Message-ID: <20260912065637.107316925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63aaafc9f48ca..1ff8d67e86e18 100644
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



