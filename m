Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68123D6CB9;
	Wed,  8 Apr 2026 18:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673006; cv=none; b=mrf5G+HWhJyQFAWRawk8iL+4fp6u6hTqIciCiV9XG91+ZUUW9cfqQQOTokf20XqcMbwZorjX5Z8Gj9yiUAqRTOHgnNBH9Q07HejsflsCWq5bZ5SHWYQtjeuPzTOz6NC9zky71t1H4DdcsJsAQJPnNS8MyZ6/6zj/Vq0r5IBk2Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673006; c=relaxed/simple;
	bh=kvq+gltYEhVSlkYfAh+eQ7QII4aIlLyTHp/nUKBwy2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgDjSHWb/WpPX2+xofCs2WCE9TP3GsQxcsyeHtdWCAU5xQBlZl90HXL+woFcHOOabvK9lADvrn8r0kko9a4H3H4D8QPaZ1hBKhELHzwrd4MLywtq/vHd3ZY9CdRo08viLaVUDRUSof/2JIoUM9XSPgBmWntv+F/R8DW81MuO568=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrz980oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrz980oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB24C19421;
	Wed,  8 Apr 2026 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673005;
	bh=kvq+gltYEhVSlkYfAh+eQ7QII4aIlLyTHp/nUKBwy2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrz980oz+k0jkZNFhA2CclOw4Wq27Bysvg6p67qiHCvIufuor/xYCHkZ8xnrG66I1
	 j9Q61xHOXAuO0gj6S6GtIJGb22Lw5+8GlQ+662B0LHKlRdJKZJdiAZgCTAJgbXku0I
	 +u3ivOeTTTATjX6fEXbmjXWfnOcBnXArFdGvcD6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Piekos <michal.piekos@mmpsystems.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/277] net: stmmac: skip VLAN restore when VLAN hash ops are missing
Date: Wed,  8 Apr 2026 20:00:49 +0200
Message-ID: <20260408175936.249951745@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Michal Piekos <michal.piekos@mmpsystems.pl>

[ Upstream commit 48b3cd69265f346f64b93064723492da46206e9b ]

stmmac_vlan_restore() unconditionally calls stmmac_vlan_update() when
NETIF_F_VLAN_FEATURES is set. On platforms where priv->hw->vlan (or
->update_vlan_hash) is not provided, stmmac_update_vlan_hash() returns
-EINVAL via stmmac_do_void_callback(), resulting in a spurious
"Failed to restore VLANs" error even when no VLAN filtering is in use.

Remove not needed comment.
Remove not used return value from stmmac_vlan_restore().

Tested on Orange Pi Zero 3.

Fixes: bd7ad51253a7 ("net: stmmac: Fix VLAN HW state restore")
Signed-off-by: Michal Piekos <michal.piekos@mmpsystems.pl>
Link: https://patch.msgid.link/20260328-vlan-restore-error-v4-1-f88624c530dc@mmpsystems.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index eeeb9f50c265c..f8df0609e0e69 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -139,7 +139,7 @@ static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue);
 static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue);
 static void stmmac_set_dma_operation_mode(struct stmmac_priv *priv, u32 txmode,
 					  u32 rxmode, u32 chan);
-static int stmmac_vlan_restore(struct stmmac_priv *priv);
+static void stmmac_vlan_restore(struct stmmac_priv *priv);
 
 #ifdef CONFIG_DEBUG_FS
 static const struct net_device_ops stmmac_netdev_ops;
@@ -6668,21 +6668,15 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	return ret;
 }
 
-static int stmmac_vlan_restore(struct stmmac_priv *priv)
+static void stmmac_vlan_restore(struct stmmac_priv *priv)
 {
-	int ret;
-
 	if (!(priv->dev->features & NETIF_F_VLAN_FEATURES))
-		return 0;
+		return;
 
 	if (priv->hw->num_vlan)
 		stmmac_restore_hw_vlan_rx_fltr(priv, priv->dev, priv->hw);
 
-	ret = stmmac_vlan_update(priv, priv->num_double_vlans);
-	if (ret)
-		netdev_err(priv->dev, "Failed to restore VLANs\n");
-
-	return ret;
+	stmmac_vlan_update(priv, priv->num_double_vlans);
 }
 
 static int stmmac_bpf(struct net_device *dev, struct netdev_bpf *bpf)
-- 
2.53.0



