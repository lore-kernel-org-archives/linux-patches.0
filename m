Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529D63B71B6;
	Wed, 30 Sep 2026 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793233; cv=none; b=OsXGJv3062mkMMO9h2B2CsGmfJxG5d9VnQxg8BMzkWVKReGeRuOlN0Of+mfIpPNQIYU+OGTaxTXjHPk+JyaqHG3A4+Zung96nIqaIyYKRND35pIpp0PG4pdz1f0e8+bvD0JpueXV0VyZStiXF0K0wchywD6vMXwKx2QOMma5+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793233; c=relaxed/simple;
	bh=ynefTMMdRdcs9HMBYEXHRrPrmMGRCo6yTDtFqBZS2f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEZP3+FlxQ0TjFe0ATmruvW+FzztQwkA+Kegcgkq8x72fgRd/27pxq/stejef2bb1GOtqnKXP4TaBoOk/TKmubjxohwJ72d4GZdIw0fNEKECZa5NeP69gbWnkg3B8KmrdgHmjA4GGpQv16rRXJU10Eooi6fiIXWyELxxh+9iQo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qgrbd+dy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qgrbd+dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF291F000FF;
	Wed, 30 Sep 2026 18:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793232;
	bh=I5Jsc9C8pnhAHnyTGGogsSRED2y2Q1UxfEGPaB3prHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qgrbd+dyOHLo5ifobv7/XwvG5lNlaMJVtd8vjr8L2Z1fJfHyLRX1RM13Qjlt6sunf
	 3mrA+E65WCAIT7rgGxj9XeyQo5Ojz5i7hQRXvxL5/JirCak3fEf8tF3Wbl+M3YWocS
	 nHRPxhPolqGMSFGkrwuwh/VAwEv0M10qeZ4NmmUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/395] gve: Consolidate and persist ethtool ring changes
Date: Wed, 30 Sep 2026 17:27:25 +0200
Message-ID: <20260930152344.622606830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit c30fd916c4d7760ccf654e52370b0a31be885789 ]

Refactor the ethtool ring parameter configuration logic to address two
issues: unnecessary queue resets and lost configuration changes when
the interface is down.

Previously, `gve_set_ringparam` could trigger multiple queue
destructions and recreations for a single command, as different settings
(e.g., header split, ring sizes) were applied one by one. Furthermore,
if the interface was down, any changes made via ethtool were discarded
instead of being saved for the next time the interface was brought up.

This patch centralizes the configuration logic. Individual functions
like `gve_set_hsplit_config` are modified to only validate and stage
changes in a temporary config struct.

The main `gve_set_ringparam` function now gathers all staged changes
and applies them as a single, combined configuration:
1.  If the interface is up, it calls `gve_adjust_config` once.
2.  If the interface is down, it saves the settings directly to the
    driver's private struct, ensuring they persist and are used when
    the interface is brought back up.

Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20251017012614.3631351-1-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3b430ea62340 ("gve: fix TX drop when GSO MSS is too small for hw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve.h         |  3 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 86 +++++++++----------
 drivers/net/ethernet/google/gve/gve_main.c    | 17 ++--
 3 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 9e7d6860b83fa..64075bdc6789b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -1254,7 +1254,8 @@ void gve_rx_start_ring_gqi(struct gve_priv *priv, int idx);
 void gve_rx_stop_ring_gqi(struct gve_priv *priv, int idx);
 u16 gve_get_pkt_buf_size(const struct gve_priv *priv, bool enable_hplit);
 bool gve_header_split_supported(const struct gve_priv *priv);
-int gve_set_hsplit_config(struct gve_priv *priv, u8 tcp_data_split);
+int gve_set_hsplit_config(struct gve_priv *priv, u8 tcp_data_split,
+			  struct gve_rx_alloc_rings_cfg *rx_alloc_cfg);
 /* rx buffer handling */
 int gve_buf_ref_cnt(struct gve_rx_buf_state_dqo *bs);
 void gve_free_page_dqo(struct gve_priv *priv, struct gve_rx_buf_state_dqo *bs,
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index edc0c718f71e9..c34319bfd32b4 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -562,34 +562,6 @@ static void gve_get_ringparam(struct net_device *netdev,
 		kernel_cmd->tcp_data_split = ETHTOOL_TCP_DATA_SPLIT_DISABLED;
 }
 
-static int gve_adjust_ring_sizes(struct gve_priv *priv,
-				 u16 new_tx_desc_cnt,
-				 u16 new_rx_desc_cnt)
-{
-	struct gve_tx_alloc_rings_cfg tx_alloc_cfg = {0};
-	struct gve_rx_alloc_rings_cfg rx_alloc_cfg = {0};
-	int err;
-
-	/* get current queue configuration */
-	gve_get_curr_alloc_cfgs(priv, &tx_alloc_cfg, &rx_alloc_cfg);
-
-	/* copy over the new ring_size from ethtool */
-	tx_alloc_cfg.ring_size = new_tx_desc_cnt;
-	rx_alloc_cfg.ring_size = new_rx_desc_cnt;
-
-	if (netif_running(priv->dev)) {
-		err = gve_adjust_config(priv, &tx_alloc_cfg, &rx_alloc_cfg);
-		if (err)
-			return err;
-	}
-
-	/* Set new ring_size for the next up */
-	priv->tx_desc_cnt = new_tx_desc_cnt;
-	priv->rx_desc_cnt = new_rx_desc_cnt;
-
-	return 0;
-}
-
 static int gve_validate_req_ring_size(struct gve_priv *priv, u16 new_tx_desc_cnt,
 				      u16 new_rx_desc_cnt)
 {
@@ -609,34 +581,62 @@ static int gve_validate_req_ring_size(struct gve_priv *priv, u16 new_tx_desc_cnt
 	return 0;
 }
 
+static int gve_set_ring_sizes_config(struct gve_priv *priv, u16 new_tx_desc_cnt,
+				     u16 new_rx_desc_cnt,
+				     struct gve_tx_alloc_rings_cfg *tx_alloc_cfg,
+				     struct gve_rx_alloc_rings_cfg *rx_alloc_cfg)
+{
+	if (new_tx_desc_cnt == priv->tx_desc_cnt &&
+	    new_rx_desc_cnt == priv->rx_desc_cnt)
+		return 0;
+
+	if (!priv->modify_ring_size_enabled) {
+		dev_err(&priv->pdev->dev, "Modify ring size is not supported.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (gve_validate_req_ring_size(priv, new_tx_desc_cnt, new_rx_desc_cnt))
+		return -EINVAL;
+
+	tx_alloc_cfg->ring_size = new_tx_desc_cnt;
+	rx_alloc_cfg->ring_size = new_rx_desc_cnt;
+	return 0;
+}
+
 static int gve_set_ringparam(struct net_device *netdev,
 			     struct ethtool_ringparam *cmd,
 			     struct kernel_ethtool_ringparam *kernel_cmd,
 			     struct netlink_ext_ack *extack)
 {
+	struct gve_tx_alloc_rings_cfg tx_alloc_cfg = {0};
+	struct gve_rx_alloc_rings_cfg rx_alloc_cfg = {0};
 	struct gve_priv *priv = netdev_priv(netdev);
-	u16 new_tx_cnt, new_rx_cnt;
 	int err;
 
-	err = gve_set_hsplit_config(priv, kernel_cmd->tcp_data_split);
+	gve_get_curr_alloc_cfgs(priv, &tx_alloc_cfg, &rx_alloc_cfg);
+	err = gve_set_hsplit_config(priv, kernel_cmd->tcp_data_split,
+				    &rx_alloc_cfg);
 	if (err)
 		return err;
 
-	if (cmd->tx_pending == priv->tx_desc_cnt && cmd->rx_pending == priv->rx_desc_cnt)
-		return 0;
+	err = gve_set_ring_sizes_config(priv, cmd->tx_pending, cmd->rx_pending,
+					&tx_alloc_cfg, &rx_alloc_cfg);
+	if (err)
+		return err;
 
-	if (!priv->modify_ring_size_enabled) {
-		dev_err(&priv->pdev->dev, "Modify ring size is not supported.\n");
-		return -EOPNOTSUPP;
+	if (netif_running(priv->dev)) {
+		err = gve_adjust_config(priv, &tx_alloc_cfg, &rx_alloc_cfg);
+		if (err)
+			return err;
+	} else {
+		/* Set ring params for the next up */
+		priv->header_split_enabled = rx_alloc_cfg.enable_header_split;
+		priv->rx_cfg.packet_buffer_size =
+			rx_alloc_cfg.packet_buffer_size;
+		priv->tx_desc_cnt = tx_alloc_cfg.ring_size;
+		priv->rx_desc_cnt = rx_alloc_cfg.ring_size;
 	}
-
-	new_tx_cnt = cmd->tx_pending;
-	new_rx_cnt = cmd->rx_pending;
-
-	if (gve_validate_req_ring_size(priv, new_tx_cnt, new_rx_cnt))
-		return -EINVAL;
-
-	return gve_adjust_ring_sizes(priv, new_tx_cnt, new_rx_cnt);
+	return 0;
 }
 
 static int gve_user_reset(struct net_device *netdev, u32 *flags)
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 9751049849432..78e72a1e71824 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2058,12 +2058,10 @@ bool gve_header_split_supported(const struct gve_priv *priv)
 		priv->queue_format == GVE_DQO_RDA_FORMAT && !priv->xdp_prog;
 }
 
-int gve_set_hsplit_config(struct gve_priv *priv, u8 tcp_data_split)
+int gve_set_hsplit_config(struct gve_priv *priv, u8 tcp_data_split,
+			  struct gve_rx_alloc_rings_cfg *rx_alloc_cfg)
 {
-	struct gve_tx_alloc_rings_cfg tx_alloc_cfg = {0};
-	struct gve_rx_alloc_rings_cfg rx_alloc_cfg = {0};
 	bool enable_hdr_split;
-	int err = 0;
 
 	if (tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_UNKNOWN)
 		return 0;
@@ -2081,14 +2079,11 @@ int gve_set_hsplit_config(struct gve_priv *priv, u8 tcp_data_split)
 	if (enable_hdr_split == priv->header_split_enabled)
 		return 0;
 
-	gve_get_curr_alloc_cfgs(priv, &tx_alloc_cfg, &rx_alloc_cfg);
-
-	rx_alloc_cfg.enable_header_split = enable_hdr_split;
-	rx_alloc_cfg.packet_buffer_size = gve_get_pkt_buf_size(priv, enable_hdr_split);
+	rx_alloc_cfg->enable_header_split = enable_hdr_split;
+	rx_alloc_cfg->packet_buffer_size =
+		gve_get_pkt_buf_size(priv, enable_hdr_split);
 
-	if (netif_running(priv->dev))
-		err = gve_adjust_config(priv, &tx_alloc_cfg, &rx_alloc_cfg);
-	return err;
+	return 0;
 }
 
 static int gve_set_features(struct net_device *netdev,
-- 
2.53.0



