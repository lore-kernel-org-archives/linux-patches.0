Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707B13AAF58;
	Sat, 12 Sep 2026 20:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243517; cv=none; b=nLktOYKsC39jjZEOnZTLVdRA+yG+hIry8kjYg8oPGogwyO7lDec+6ZLb1Jcz/1/sBCILO1aHFPadQId2k4cfmdaDLLkMd4xMhWABiHVs+Eo6sESKSddE8Z2abQBm1+ggIMoNSdQiWqYPGIioEyPg0S5MZyAHChXILNamTt8x3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243517; c=relaxed/simple;
	bh=mcT61cxMAW8yHXAJOUYQNT/ArKgAdFVentLeFOOWJ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G67DF9HBUKmN/cC6FBs7nq6ORvo6o2yjNJXKeGCn760IKyBtxYn8iwuyl9Te6JZDGraG+kK/9efeUumQN4Dcg7Yi9XabwAYtIDkNKl7UrMazVmjrCU9MZz/0jI4g4WsSfWg1dW/2AW7kR9+HU0IAb6nar5Z71QxLHxuGjUfXAhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKUZg4Hq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKUZg4Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CDA1F000FF;
	Sat, 12 Sep 2026 20:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243510;
	bh=98fBjJJIkrDj9D947w1bk3XykO3noX+HlZRP95Uw4dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKUZg4HqO8I9M5beQdTAx1+ZyR8MnEUPwqKoVlS/P8QEBdymblBbUySdhiA1FV2kL
	 4zEErf28Wh/9HO1y1yC+NAuINdZ3gYhGnwl15rcaEKUQC25Q2/ZQhLwqvM7yoCsb2/
	 lZ4mh3nicvx8cnQnBAV7fLJvY3jKpD7eJ4QYm1dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 779/798] net: stmmac: dwmac1000: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:06:47 +0200
Message-ID: <20260912065534.922159100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 9698b6da3714fd2ef47846cb63098d2b2d252e25 ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-3-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index fc8759f146c7c..62b72e3d8b50b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -194,7 +194,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 	dwmac1000_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses (perfect filtering) */
-	if (netdev_uc_count(dev) > perfect_addr_number)
+	if (netdev_uc_count(dev) + 1 > perfect_addr_number)
 		/* Switch to promiscuous mode if more than unicast
 		 * addresses are requested than supported by hardware.
 		 */
-- 
2.53.0



