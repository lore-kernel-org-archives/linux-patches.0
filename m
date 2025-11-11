Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8A0DDAB;
	Tue, 11 Nov 2025 01:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824482; cv=none; b=BJkCCqv443Pk6tSXGkrjpFsOJW5clJk3EjE7MsQlmEAt3BocUR3ADOZHy7T91suevLhtJGNVZPTAY6RvdVzMVXRGzNqwymnoXVobyEJdLBAB5CLzus27hLB9A7VNBrHrC4R5CK+SrNZtlE+rUC56mBGTS+2tOCaiyVQiYptszhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824482; c=relaxed/simple;
	bh=433IKdbzIa3k4oVrZCXlFV23fcojGTwvYrVnxao/lQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=coZBtBlGAzQ0G8FAoBpAUZaYM0jcfKmZi/7PCZhCxggdXHXoc87LR3XCZlm2nTLcTQbPSI+qabRTeUtdrEHIsf7pxaob7ZgDSa9LETDbti0rupfCvRz2JWjH3Bt/QuMq/XZrDVrhYxOYzQE1oUv2El2P6X3Lv1xPL1jeGNEDocw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zu0Jf4m+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zu0Jf4m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93847C4CEFB;
	Tue, 11 Nov 2025 01:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824481;
	bh=433IKdbzIa3k4oVrZCXlFV23fcojGTwvYrVnxao/lQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zu0Jf4m+EF8lplnWtA6PKy5/1pLmbXp5FQmOsd/Poi+zkpU1jHNnz5KRbk6ZvPFkI
	 EXkz6JKeyZwWlZC+32Vrw0YZJzvRvPgAwD5DJV+7Gs1J9nmbJXYO57Z/Sa/cVFz+Nq
	 j9QxuGlRqrFKtgBEMa2KpkScMMZoupG2WwhCFNuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Andrew Lunn <andrew@lunn.ch>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 509/849] net: sh_eth: Disable WoL if system can not suspend
Date: Tue, 11 Nov 2025 09:41:19 +0900
Message-ID: <20251111004548.733288069@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 5fc8027c92c7c..695fa3592c9a2 100644
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



