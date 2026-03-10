Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43CA38945D;
	Tue, 10 Mar 2026 11:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142200; cv=none; b=d1eGPnKPYFSrmx6KAY7qedZOYNwbTEFrz9jqlLmUUTQuOuKeFuQGGhjhiyFBED6Se5iinzeGx9IEVQemzqgVayNCDM9obM5GFLCntU0/JXVgkUt49EFc+VWERQVrLiP6SuBKz4Rh1LAhEM6dR4J7g2do4pn1vrnvOkMX4fxj9fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142200; c=relaxed/simple;
	bh=xH9dLtwln6aldD01opZPMEju1FGnIjG7jldas9lICt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRqvhRDDdtyfwDIFJQTVPNSqm96NgXVQsGy0Rt4vw+DE93Gt9iY9VQ5/rXVC3agwME40piCFQhnd5AfETgJBYFN+ZcIBMa1DfL+IKsWVP4nUIb3PqG7lPTrwpisdX1oy7MweeOqWgFaGL3TqqbzrAPPx3KANNPZs1b03JGzSNPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bU1Jaouk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bU1Jaouk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F6CC19423;
	Tue, 10 Mar 2026 11:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142200;
	bh=xH9dLtwln6aldD01opZPMEju1FGnIjG7jldas9lICt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bU1JaoukU7qb5/g2RYqGXtcNpcWX4adwYD5gLSImofyLfPbiN7FRMkoLgY9OG1Sfx
	 FbT0bUo7KPJk06gcsYddoirr8bbrZI6x9XAbA5Y7mRXm3WIKx4NuljnNQh8SGdVLsk
	 0TafMNiRnDbTt7rquLYT/Ye0knQMXqsLjVO5bLSzbk3pMSsQDpC2Gg+/fpkmKaLoO9
	 NztE/9ldt1Eck9VMzHZ1VvMBgHwzN4PDFbSC9dIdcUdIX6X1I1n9ngbBtIPa6wayHM
	 7XXZcXlwHK+t3jFqibKl1ben6zyM3m1wiDtPTYpVNWdGRL7H3ffk/PRquPe/T2fbv4
	 WZhTRK/+tG3eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 290/314] net: stmmac: Fix VLAN HW state restore
Date: Tue, 10 Mar 2026 07:19:09 -0400
Message-ID: <1b73a2c6222e1e2f0709224dd25a2b32a60c5dd1.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit bd7ad51253a76fb35886d01cfe9a37f0e4ed6709 ]

When the network interface is opened or resumed, a DMA reset is performed,
which resets all hardware state, including VLAN state. Currently, only
the resume path is restoring the VLAN state via
stmmac_restore_hw_vlan_rx_fltr(), but that is incomplete: the VLAN hash
table and the VLAN_TAG control bits are not restored.

Therefore, add stmmac_vlan_restore(), which restores the full VLAN
state by updating both the HW filter entries and the hash table, and
call it from both the open and resume paths.

The VLAN restore is moved outside of phylink_rx_clk_stop_block/unblock
in the resume path because receive clock stop is already disabled when
stmmac supports VLAN.

Also, remove the hash readback code in vlan_restore_hw_rx_fltr() that
attempts to restore VTHM by reading VLAN_HASH_TABLE, as it always reads
zero after DMA reset, making it dead code.

Fixes: 3cd1cfcba26e ("net: stmmac: Implement VLAN Hash Filtering in XGMAC")
Fixes: ed64639bc1e0 ("net: stmmac: Add support for VLAN Rx filtering")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Link: https://patch.msgid.link/20260303145828.7845-4-ovidiu.panait.rb@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2cd70e3968f5 ("net: stmmac: Defer VLAN HW configuration when interface is down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_vlan.c | 10 --------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f61d0f81a948..112d0cbdf6237 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -139,6 +139,7 @@ static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue);
 static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue);
 static void stmmac_set_dma_operation_mode(struct stmmac_priv *priv, u32 txmode,
 					  u32 rxmode, u32 chan);
+static int stmmac_vlan_restore(struct stmmac_priv *priv);
 
 #ifdef CONFIG_DEBUG_FS
 static const struct net_device_ops stmmac_netdev_ops;
@@ -3932,6 +3933,8 @@ static int __stmmac_open(struct net_device *dev,
 	/* We may have called phylink_speed_down before */
 	phylink_speed_up(priv->phylink);
 
+	stmmac_vlan_restore(priv);
+
 	ret = stmmac_request_irq(dev);
 	if (ret)
 		goto irq_error;
@@ -6662,6 +6665,23 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	return ret;
 }
 
+static int stmmac_vlan_restore(struct stmmac_priv *priv)
+{
+	int ret;
+
+	if (!(priv->dev->features & NETIF_F_VLAN_FEATURES))
+		return 0;
+
+	if (priv->hw->num_vlan)
+		stmmac_restore_hw_vlan_rx_fltr(priv, priv->dev, priv->hw);
+
+	ret = stmmac_vlan_update(priv, priv->num_double_vlans);
+	if (ret)
+		netdev_err(priv->dev, "Failed to restore VLANs\n");
+
+	return ret;
+}
+
 static int stmmac_bpf(struct net_device *dev, struct netdev_bpf *bpf)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
@@ -7895,10 +7915,10 @@ int stmmac_resume(struct device *dev)
 	stmmac_init_coalesce(priv);
 	phylink_rx_clk_stop_block(priv->phylink);
 	stmmac_set_rx_mode(ndev);
-
-	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 	phylink_rx_clk_stop_unblock(priv->phylink);
 
+	stmmac_vlan_restore(priv);
+
 	stmmac_enable_all_queues(priv);
 	stmmac_enable_all_dma_irq(priv);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
index de1a70e1c86ef..fcc34867405ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
@@ -139,9 +139,6 @@ static int vlan_del_hw_rx_fltr(struct net_device *dev,
 static void vlan_restore_hw_rx_fltr(struct net_device *dev,
 				    struct mac_device_info *hw)
 {
-	void __iomem *ioaddr = hw->pcsr;
-	u32 value;
-	u32 hash;
 	u32 val;
 	int i;
 
@@ -158,13 +155,6 @@ static void vlan_restore_hw_rx_fltr(struct net_device *dev,
 			vlan_write_filter(dev, hw, i, val);
 		}
 	}
-
-	hash = readl(ioaddr + VLAN_HASH_TABLE);
-	if (hash & VLAN_VLHT) {
-		value = readl(ioaddr + VLAN_TAG);
-		value |= VLAN_VTHM;
-		writel(value, ioaddr + VLAN_TAG);
-	}
 }
 
 static void vlan_update_hash(struct mac_device_info *hw, u32 hash,
-- 
2.51.0

