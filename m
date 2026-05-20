Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906DC1C3BFC;
	Wed, 20 May 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299102; cv=none; b=I4Yzi3gSfau2J3bdU85CZch57+o//kLlQNxrhzFs9fp7L5Ckm1hPhskZbDclkrTqxc9jSf2/kVH1awAoeltYR+J/9kyJwfw54JbZ1cfDPpZuVTShroCz6pfh3+vq8FuhCuf9XDwpWPkgEK93nvq2RQfU5YjIRXJfZVjgKVAHuq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299102; c=relaxed/simple;
	bh=UoEbtJY+ASF/fSzKWD6Ee4SxS/QcUQYP9wduuX935Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWUJlEQCIpf/Y+TU3++RVxt8BsHW8qxT1DywMDp+a+4BOBKeog2bIEW/qcvaRG4TbYiYDFnCzz3KtJ96+YuLkswhLlzZRZWSyiw6nHRFD9lkBJd+M2kiAVXS8MrtjcmWUW+gCRTmcq2fPodlc13EK999CM7Hvga1NoH/4RDv1qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8Dp09iD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8Dp09iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F0B1F000E9;
	Wed, 20 May 2026 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299101;
	bh=CF9rOuNJ//AdLNgC9yB6fLHTxU1doBvMg6U7+dCzxXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8Dp09iD1lR/NFQhG4t6HzvAkzTJPFny3w6uRPIcUesMWWEfo3Q3PPbKVMU1Gje/4
	 B4xleP/rZhgA/KmyZlUdoqVSyHL9XbgenWzkIPjZCti5d3cAb+oYiW//VGJph/Ydql
	 8m+YSot9QRhWJ5aRSfhl+hG6NPmUdmBpNzeCa9bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 621/957] net: dsa: cpu_dp->orig_ethtool_ops might be NULL
Date: Wed, 20 May 2026 18:18:24 +0200
Message-ID: <20260520162147.999590383@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit eba81b0a6de39e2466d37e410003642282b4e546 ]

In theory this would have been seen by now, but it seems that all
drivers used as DSA conduit interfaces thus far have had ethtool_ops
set, and it's hard to even find modern Ethernet drivers (and not VF
ones) which don't use ethtool.

Here is the unfiltered list of drivers which register any sort of
net_device but don't set its ethtool_ops pointer. I don't think any of
them 'risks' being used as a DSA conduit, maybe except for moxart,
rnpbge and icssm, I'm not sure.

- drivers/net/can/dev/dev.c
- drivers/net/wwan/qcom_bam_dmux.c
- drivers/net/wwan/t7xx/t7xx_netdev.c
- drivers/net/arcnet/arcnet.c
- drivers/net/hamradio/
- drivers/net/slip/slip.c
- drivers/net/ethernet/ezchip/nps_enet.c
- drivers/net/ethernet/moxa/moxart_ether.c
- drivers/net/ethernet/wangxun/txgbevf/txgbevf_main.c
- drivers/net/ethernet/wangxun/ngbevf/ngbevf_main.c
- drivers/net/ethernet/huawei/hinic3/hinic3_main.c
- drivers/net/ethernet/i825xx/
- drivers/net/ethernet/ti/icssm/icssm_prueth.c
- drivers/net/ethernet/seeq/
- drivers/net/ethernet/litex/litex_liteeth.c
- drivers/net/ethernet/sunplus/spl2sw_driver.c
- drivers/net/ethernet/mucse/rnpgbe/rnpgbe_main.c
- drivers/net/ipa/
- drivers/net/wireless/microchip/wilc1000/
- drivers/net/wireless/mediatek/mt76/dma.c
- drivers/net/wireless/ath/ath12k/
- drivers/net/wireless/ath/ath11k/
- drivers/net/wireless/ath/ath6kl/
- drivers/net/wireless/ath/ath10k/
- drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
- drivers/net/wireless/virtual/mac80211_hwsim.c
- drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
- drivers/net/wireless/realtek/rtw89/core.c
- drivers/net/wireless/realtek/rtw88/pci.c
- drivers/net/caif/
- drivers/net/plip/
- drivers/net/wan/
- drivers/net/mctp/
- drivers/net/ppp/
- drivers/net/thunderbolt/

Nonetheless, it's good for the framework not to make such assumptions,
and not panic when coming across such kind of host device in the future.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251122112311.138784-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0f99e0c3e19b ("net: dsa: remove redundant netdev_lock_ops() from conduit ethtool ops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/conduit.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/conduit.c b/net/dsa/conduit.c
index 4ae255cfb23f8..f80795b3d0460 100644
--- a/net/dsa/conduit.c
+++ b/net/dsa/conduit.c
@@ -26,7 +26,7 @@ static int dsa_conduit_get_regs_len(struct net_device *dev)
 	int ret = 0;
 	int len;
 
-	if (ops->get_regs_len) {
+	if (ops && ops->get_regs_len) {
 		netdev_lock_ops(dev);
 		len = ops->get_regs_len(dev);
 		netdev_unlock_ops(dev);
@@ -59,7 +59,7 @@ static void dsa_conduit_get_regs(struct net_device *dev,
 	int port = cpu_dp->index;
 	int len;
 
-	if (ops->get_regs_len && ops->get_regs) {
+	if (ops && ops->get_regs_len && ops->get_regs) {
 		netdev_lock_ops(dev);
 		len = ops->get_regs_len(dev);
 		if (len < 0) {
@@ -97,7 +97,7 @@ static void dsa_conduit_get_ethtool_stats(struct net_device *dev,
 	int port = cpu_dp->index;
 	int count = 0;
 
-	if (ops->get_sset_count && ops->get_ethtool_stats) {
+	if (ops && ops->get_sset_count && ops->get_ethtool_stats) {
 		netdev_lock_ops(dev);
 		count = ops->get_sset_count(dev, ETH_SS_STATS);
 		ops->get_ethtool_stats(dev, stats, data);
@@ -118,11 +118,11 @@ static void dsa_conduit_get_ethtool_phy_stats(struct net_device *dev,
 	int port = cpu_dp->index;
 	int count = 0;
 
-	if (dev->phydev && !ops->get_ethtool_phy_stats) {
+	if (dev->phydev && (!ops || !ops->get_ethtool_phy_stats)) {
 		count = phy_ethtool_get_sset_count(dev->phydev);
 		if (count >= 0)
 			phy_ethtool_get_stats(dev->phydev, stats, data);
-	} else if (ops->get_sset_count && ops->get_ethtool_phy_stats) {
+	} else if (ops && ops->get_sset_count && ops->get_ethtool_phy_stats) {
 		netdev_lock_ops(dev);
 		count = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
 		ops->get_ethtool_phy_stats(dev, stats, data);
@@ -145,9 +145,9 @@ static int dsa_conduit_get_sset_count(struct net_device *dev, int sset)
 
 	netdev_lock_ops(dev);
 	if (sset == ETH_SS_PHY_STATS && dev->phydev &&
-	    !ops->get_ethtool_phy_stats)
+	    (!ops || !ops->get_ethtool_phy_stats))
 		count = phy_ethtool_get_sset_count(dev->phydev);
-	else if (ops->get_sset_count)
+	else if (ops && ops->get_sset_count)
 		count = ops->get_sset_count(dev, sset);
 	netdev_unlock_ops(dev);
 
-- 
2.53.0



