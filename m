Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569503AE6E6;
	Wed, 20 May 2026 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296379; cv=none; b=cFHRsyHDd2FJmmW/NTh7q6Ukx5SnpqL+SFw/4Rfmz2Q0cpuonFZTEhTAA1Aq8shH/6bbVBwy/lo0n0BCYWKxdeLGo6zL2zUM1nJGyZaPUmExz4kNmiGwNA/WHCWDpNNAyPQLUm+d+cl5Pj57vBFqpgoZ23JcwP+jGt4I9sRKM7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296379; c=relaxed/simple;
	bh=Lt4wVlloakOAjWAuzM4Yw+9d/f29QngZ+nzQ+w+ulzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1+5w+RvKNteaVXw0MP0Ly3ctMfOtvW595y08GY/7lzL0jKnQWSFauISviuXMJ+PXnkQBtt2nRLMO2PLszfzLKd1BoIaKUE7259YWs08FNMBFuFz1WDRgsxpWyFjzfXoDcuoJbt9bXy6FnTAG/NK4/hjfpovWuMlvHpcWb+kHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulCbSytt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulCbSytt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6681F000E9;
	Wed, 20 May 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296376;
	bh=schnMygN1FyymYTy2KbcIG0dUJTiN3HhiyXbpF6yw8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulCbSyttmIth1uH1dX1Lqw04woQgkdt7qiToW/rpBUmKQ2U6h8CzDSDNP+8zT8ApB
	 6erTNfBNluSukRINpGjkFXG4igqGQ7rWo2sBcmbENnauKsPDORLaYjqhDQllBqVr6Q
	 K2DyvPt1eP3KcOdHhbSD/ekvTKJndE1B7eR1qymI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@fomichev.me>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0774/1146] net: dsa: remove redundant netdev_lock_ops() from conduit ethtool ops
Date: Wed, 20 May 2026 18:17:04 +0200
Message-ID: <20260520162205.733770778@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit 0f99e0c3e19badaf3fdced0d3feba623e59eed41 ]

DSA replaces the conduit (master) device's ethtool_ops with its own
wrappers that aggregate stats from both the conduit and DSA switch
ports. Taking the lock again inside the DSA wrappers causes a deadlock.

Stumbled upon this when booting qemu with fbnic and CONFIG_NET_DSA_LOOP=y
(which looks like some kind of testing device that auto-populates the ports
of eth0). `ethtool -i` is enough to deadlock. This means we have basically zero
coverage for DSA stuff with real ops locked devs.

Remove the redundant netdev_lock_ops()/netdev_unlock_ops() calls from
the DSA conduit ethtool wrappers.

Fixes: 2bcf4772e45a ("net: ethtool: try to protect all callback with netdev instance lock")
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260414231035.1917035-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/conduit.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/net/dsa/conduit.c b/net/dsa/conduit.c
index a1b044467bd6f..8398d72d7e4d3 100644
--- a/net/dsa/conduit.c
+++ b/net/dsa/conduit.c
@@ -27,9 +27,7 @@ static int dsa_conduit_get_regs_len(struct net_device *dev)
 	int len;
 
 	if (ops && ops->get_regs_len) {
-		netdev_lock_ops(dev);
 		len = ops->get_regs_len(dev);
-		netdev_unlock_ops(dev);
 		if (len < 0)
 			return len;
 		ret += len;
@@ -60,15 +58,11 @@ static void dsa_conduit_get_regs(struct net_device *dev,
 	int len;
 
 	if (ops && ops->get_regs_len && ops->get_regs) {
-		netdev_lock_ops(dev);
 		len = ops->get_regs_len(dev);
-		if (len < 0) {
-			netdev_unlock_ops(dev);
+		if (len < 0)
 			return;
-		}
 		regs->len = len;
 		ops->get_regs(dev, regs, data);
-		netdev_unlock_ops(dev);
 		data += regs->len;
 	}
 
@@ -115,10 +109,8 @@ static void dsa_conduit_get_ethtool_stats(struct net_device *dev,
 	int count, mcount = 0;
 
 	if (ops && ops->get_sset_count && ops->get_ethtool_stats) {
-		netdev_lock_ops(dev);
 		mcount = ops->get_sset_count(dev, ETH_SS_STATS);
 		ops->get_ethtool_stats(dev, stats, data);
-		netdev_unlock_ops(dev);
 	}
 
 	list_for_each_entry(dp, &dst->ports, list) {
@@ -149,10 +141,8 @@ static void dsa_conduit_get_ethtool_phy_stats(struct net_device *dev,
 		if (count >= 0)
 			phy_ethtool_get_stats(dev->phydev, stats, data);
 	} else if (ops && ops->get_sset_count && ops->get_ethtool_phy_stats) {
-		netdev_lock_ops(dev);
 		count = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
 		ops->get_ethtool_phy_stats(dev, stats, data);
-		netdev_unlock_ops(dev);
 	}
 
 	if (count < 0)
@@ -176,13 +166,11 @@ static int dsa_conduit_get_sset_count(struct net_device *dev, int sset)
 	struct dsa_switch_tree *dst = cpu_dp->dst;
 	int count = 0;
 
-	netdev_lock_ops(dev);
 	if (sset == ETH_SS_PHY_STATS && dev->phydev &&
 	    (!ops || !ops->get_ethtool_phy_stats))
 		count = phy_ethtool_get_sset_count(dev->phydev);
 	else if (ops && ops->get_sset_count)
 		count = ops->get_sset_count(dev, sset);
-	netdev_unlock_ops(dev);
 
 	if (count < 0)
 		count = 0;
@@ -239,7 +227,6 @@ static void dsa_conduit_get_strings(struct net_device *dev, u32 stringset,
 	struct dsa_switch_tree *dst = cpu_dp->dst;
 	int count, mcount = 0;
 
-	netdev_lock_ops(dev);
 	if (stringset == ETH_SS_PHY_STATS && dev->phydev &&
 	    !ops->get_ethtool_phy_stats) {
 		mcount = phy_ethtool_get_sset_count(dev->phydev);
@@ -253,7 +240,6 @@ static void dsa_conduit_get_strings(struct net_device *dev, u32 stringset,
 			mcount = 0;
 		ops->get_strings(dev, stringset, data);
 	}
-	netdev_unlock_ops(dev);
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (!dsa_port_is_dsa(dp) && !dsa_port_is_cpu(dp))
-- 
2.53.0



