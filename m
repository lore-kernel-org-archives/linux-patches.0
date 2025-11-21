Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0579C34F278;
	Fri, 21 Nov 2025 13:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732702; cv=none; b=AplSU/YEUn5IqCgM1mgKGSTBtz/bYYCFAi/fgaB7PP5/BpWQlaz2cDOu4U2HyfylY5ew0oLQavw8GB+aUWqPxA0zRLs0kvbrdKMqDqMTAiHbZqwpV6zfMH82HI6EJM8J7yf8ewUHNuFyXVUoEMGqVLtUFd1M8WhgOkIdCLcGyfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732702; c=relaxed/simple;
	bh=gdSnIEbKxbbdzo3fja9Jh9g/EjUYepmu4acopXkbvos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxYnHyPqawmnujGw3z1H4Dr6+oSNLqXrmTK+5+7OQs9S+Nlpyg5Zmt18APIOwJ+Kf85qfgRMaDQCGUDiipozT8sJeANPRWUducDJitpVh0l+gXV/bDGl81K3rXUxHqw+MIdwU+kX13jA1ZSfrswvu/qnXWigi608ZaHeu2RaHjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJCgFPx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJCgFPx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E7DC4CEFB;
	Fri, 21 Nov 2025 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732701;
	bh=gdSnIEbKxbbdzo3fja9Jh9g/EjUYepmu4acopXkbvos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJCgFPx61i3soNVANVDQ3njpNNU82imra03EVC+WkF0fLsqRPbiWW+JO9WutmtqjK
	 GDYBniANvuoa0uE8dZ9/mtgaGc8Twj45VWmxBtrky1HKIJ8RR6xupbHWDDnDQ6OGIN
	 xh4/ToVQQ2PRGY9R7oaWzzwReNVcaZYbkmSPBkKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Andrew Lunn <andrew@lunn.ch>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/529] net: sh_eth: Disable WoL if system can not suspend
Date: Fri, 21 Nov 2025 14:08:33 +0100
Message-ID: <20251121130238.628548703@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 9c02ea544ac35a9def5827d30594406947ccd81a ]

The MAC can't facilitate WoL if the system can't go to sleep. Gate the
WoL support callbacks in ethtool at compile time using CONFIG_PM_SLEEP.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250909085849.3808169-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 0c0fd68ded423..4597c4e9b297b 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2360,6 +2360,7 @@ static int sh_eth_set_ringparam(struct net_device *ndev,
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static void sh_eth_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
@@ -2386,6 +2387,7 @@ static int sh_eth_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 
 	return 0;
 }
+#endif
 
 static const struct ethtool_ops sh_eth_ethtool_ops = {
 	.get_regs_len	= sh_eth_get_regs_len,
@@ -2401,8 +2403,10 @@ static const struct ethtool_ops sh_eth_ethtool_ops = {
 	.set_ringparam	= sh_eth_set_ringparam,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+#ifdef CONFIG_PM_SLEEP
 	.get_wol	= sh_eth_get_wol,
 	.set_wol	= sh_eth_set_wol,
+#endif
 };
 
 /* network device open function */
-- 
2.51.0



