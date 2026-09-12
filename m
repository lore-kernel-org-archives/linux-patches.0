Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B3D356742;
	Sat, 12 Sep 2026 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205368; cv=none; b=FjJ4CdyeK1vXwiVtjNNahi+YKXRful2jPQWRjjjS9r8BIHtogwlMoV3F4jyAGO7Qgp3S//Vi5iJHOhmJm2mjc3iEOzn26pWfEDWsxTU+IQw5jnJXkRpMnYEa3zLM60pWJplmWOPcrQB00aQmeTBerdWJvqLjAknhWRlz6aLYoT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205368; c=relaxed/simple;
	bh=XMa4tT/oSTLC2h6keRsrMJKd2pabdpzjsqj0yMMjgw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nihYAR1zLabihkjKgfU7HZgpOQ6TW6aDO26vyDhb333c4XpQ5yGvzo5vkkO/EOmHoujVrEyxc1dGwaZRTEU4JpKyGiu7lHYxly0N+aAcVqVWyFyppMYn6RvHlvDvo/jxU/fUBbdr7CvswvCJILPnigYSjL40jZtsawsTawgimu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVJUO9h+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVJUO9h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9D21F000FF;
	Sat, 12 Sep 2026 09:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205367;
	bh=HDmhKBQegRjmlqSjjpJ2XufhUEjHUddRJT2JEa4AwzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVJUO9h+dEYkZTiK8xk0N7yo7IN+psENaxsO7t8ScEounuDfR7JETLJVO6W9wsy/x
	 QVxxQucWLlOsurpGN5cLLVDy5A6DYUk1juXeUXau25HrQvw7L0pxXl1j4TnHyq5Veu
	 edIWo/CMPX2bHgE0R5c3uSXJH+cDYrelyAeflwqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1803/1815] net: stmmac: drop gso_enabled_types and rely on netdev features
Date: Sat, 12 Sep 2026 08:59:13 +0200
Message-ID: <20260912065731.363018225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 9c24a504a3af1acb96da8d6a45a373fda8a9c687 ]

The gso_enabled_types field is used by stmmac_xmit() to decide whether a
GSO skb should be passed to stmmac_tso_xmit(). It is updated in
stmmac_set_features() based solely on NETIF_F_TSO, so disabling IPv4
TSO while keeping IPv6 TSO (NETIF_F_TSO6) enabled zeroes the mask. As a
result IPv6 GSO frames, which the networking stack still generates since
NETIF_F_TSO6 is enabled, fall through to the non-TSO xmit path where
they are not handled.

The networking stack already manages the GSO logic: a GSO skb is only
delivered to the driver when the matching offload feature (NETIF_F_TSO,
NETIF_F_TSO6 or NETIF_F_GSO_UDP_L4) is enabled, otherwise the frame is
segmented in software before reaching ndo_start_xmit().
stmmac_features_check() also validates each GSO frame against the TSO
hardware constraints and falls back to software GSO when they are not met.

Drop the gso_enabled_types field and rely on skb_is_gso() in
stmmac_xmit() instead, which correctly routes IPv6 GSO frames to the TSO
path when NETIF_F_TSO is disabled. This also removes the data race
between stmmac_set_gso_types(), called from the feature-set path, and
the lockless read of gso_enabled_types in stmmac_xmit().

Fixes: 2e4082e4b739 ("net: stmmac: simplify GSO/TSO test in stmmac_xmit()")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260824-stmmac-fix-tso6-features-v3-1-c73a7a4a0ec7@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 --
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 +------------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 8ba8f03e1ce03..7582fca637419 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -265,8 +265,6 @@ struct stmmac_priv {
 	u32 rx_coal_frames[MTL_MAX_RX_QUEUES];
 
 	int hwts_tx_en;
-	/* skb_shinfo(skb)->gso_type types that we handle */
-	unsigned int gso_enabled_types;
 	bool tx_path_in_lpi_mode;
 	bool sph_active;
 	bool sph_capable;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a8c1bfeab813c..33cb2067be0aa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4376,18 +4376,6 @@ static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue)
 	stmmac_set_queue_tx_tail_ptr(priv, tx_q, queue, tx_q->cur_tx);
 }
 
-static void stmmac_set_gso_types(struct stmmac_priv *priv, bool tso)
-{
-	if (!tso) {
-		priv->gso_enabled_types = 0;
-	} else {
-		/* Manage oversized TCP frames for GMAC4 device */
-		priv->gso_enabled_types = SKB_GSO_TCPV4 | SKB_GSO_TCPV6;
-		if (priv->plat->core_type == DWMAC_CORE_GMAC4)
-			priv->gso_enabled_types |= SKB_GSO_UDP_L4;
-	}
-}
-
 static void stmmac_set_gso_features(struct net_device *ndev)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -4421,8 +4409,6 @@ static void stmmac_set_gso_features(struct net_device *ndev)
 	if (priv->plat->core_type == DWMAC_CORE_GMAC4)
 		ndev->hw_features |= NETIF_F_GSO_UDP_L4;
 
-	stmmac_set_gso_types(priv, true);
-
 	dev_info(priv->device, "TSO feature enabled\n");
 }
 
@@ -4770,8 +4756,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->tx_path_in_lpi_mode && priv->eee_sw_timer_en)
 		stmmac_stop_sw_lpi(priv);
 
-	if (skb_is_gso(skb) &&
-	    skb_shinfo(skb)->gso_type & priv->gso_enabled_types)
+	if (skb_is_gso(skb))
 		return stmmac_tso_xmit(skb, dev);
 
 	if (priv->est && priv->est->enable &&
@@ -6203,8 +6188,6 @@ static int stmmac_set_features(struct net_device *netdev,
 			stmmac_enable_sph(priv, priv->ioaddr, sph_en, chan);
 	}
 
-	stmmac_set_gso_types(priv, features & NETIF_F_TSO);
-
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		priv->hw->hw_vlan_en = true;
 	else
-- 
2.53.0



