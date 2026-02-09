Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF6637BE75;
	Mon,  9 Feb 2026 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647747; cv=none; b=IaPicqi9dErhEQEJgFQfUvO4AiWgFoXDv66PdxO2orZcynE3LQtFNxOKApws23TeFL/woVx0TrKQ4l5Dog9+AzbxqbgxqWzEJCnNHjj6FPAfpyQhX3b4IH3vW8gfyetkGIZV+qzKXzgucl8TITG1SFl1NLxI73LYRb7CX08R3VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647747; c=relaxed/simple;
	bh=UR2nm0vEZXE7iQmQA6sSI9tS/llx9SS5kYdyJwShAEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2KwyfiC383xN6bNxS82uXO8ToJ7IO1Evr+ARZ1rp5ay1rsduy4FGYHIb4ot56d7cCR3FKz4lDxnqUutLyeY8Ek4mVv79gInfbRmszXMQ8XSBXNBewDRpb4NGdlV2IAWeGTgTKGTB82QLHGzD8jGPdD7v9g9jTIPNLBmFPpZbm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR4G/n3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR4G/n3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63636C116C6;
	Mon,  9 Feb 2026 14:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647746;
	bh=UR2nm0vEZXE7iQmQA6sSI9tS/llx9SS5kYdyJwShAEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR4G/n3ekX4etQ54QeCkVPNHe9H/ipbPQKLi4/BUw4QDXxuQf/9rkO42tAAup1N9B
	 y4U4R4D9WQRW878Fu0mr+grWu4kc8pCjsqXTdzf77pTWJfDXEPDUou0I+ChdLhsOE+
	 k/FZSu63Hh3j/IiNfb0JgvEB6m0NDQgI6iwNhUU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Yuan <maxyuan@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Joshua Washington <joshwash@google.com>,
	Matt Olson <maolson@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 017/113] gve: Correct ethtool rx_dropped calculation
Date: Mon,  9 Feb 2026 15:22:46 +0100
Message-ID: <20260209142310.830329838@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Max Yuan <maxyuan@google.com>

commit c7db85d579a1dccb624235534508c75fbf2dfe46 upstream.

The gve driver's "rx_dropped" statistic, exposed via `ethtool -S`,
incorrectly includes `rx_buf_alloc_fail` counts. These failures
represent an inability to allocate receive buffers, not true packet
drops where a received packet is discarded. This misrepresentation can
lead to inaccurate diagnostics.

This patch rectifies the ethtool "rx_dropped" calculation. It removes
`rx_buf_alloc_fail` from the total and adds `xdp_tx_errors` and
`xdp_redirect_errors`, which represent legitimate packet drops within
the XDP path.

Cc: stable@vger.kernel.org
Fixes: 433e274b8f7b ("gve: Add stats for gve.")
Signed-off-by: Max Yuan <maxyuan@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Joshua Washington <joshwash@google.com>
Reviewed-by: Matt Olson <maolson@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260202193925.3106272-3-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -152,10 +152,11 @@ gve_get_ethtool_stats(struct net_device
 	u64 tmp_rx_pkts, tmp_rx_hsplit_pkt, tmp_rx_bytes, tmp_rx_hsplit_bytes,
 		tmp_rx_skb_alloc_fail, tmp_rx_buf_alloc_fail,
 		tmp_rx_desc_err_dropped_pkt, tmp_rx_hsplit_unsplit_pkt,
-		tmp_tx_pkts, tmp_tx_bytes;
+		tmp_tx_pkts, tmp_tx_bytes,
+		tmp_xdp_tx_errors, tmp_xdp_redirect_errors;
 	u64 rx_buf_alloc_fail, rx_desc_err_dropped_pkt, rx_hsplit_unsplit_pkt,
 		rx_pkts, rx_hsplit_pkt, rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes,
-		tx_dropped;
+		tx_dropped, xdp_tx_errors, xdp_redirect_errors;
 	int rx_base_stats_idx, max_rx_stats_idx, max_tx_stats_idx;
 	int stats_idx, stats_region_len, nic_stats_len;
 	struct stats *report_stats;
@@ -199,6 +200,7 @@ gve_get_ethtool_stats(struct net_device
 	for (rx_pkts = 0, rx_bytes = 0, rx_hsplit_pkt = 0,
 	     rx_skb_alloc_fail = 0, rx_buf_alloc_fail = 0,
 	     rx_desc_err_dropped_pkt = 0, rx_hsplit_unsplit_pkt = 0,
+	     xdp_tx_errors = 0, xdp_redirect_errors = 0,
 	     ring = 0;
 	     ring < priv->rx_cfg.num_queues; ring++) {
 		if (priv->rx) {
@@ -216,6 +218,9 @@ gve_get_ethtool_stats(struct net_device
 					rx->rx_desc_err_dropped_pkt;
 				tmp_rx_hsplit_unsplit_pkt =
 					rx->rx_hsplit_unsplit_pkt;
+				tmp_xdp_tx_errors = rx->xdp_tx_errors;
+				tmp_xdp_redirect_errors =
+					rx->xdp_redirect_errors;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
 			rx_pkts += tmp_rx_pkts;
@@ -225,6 +230,8 @@ gve_get_ethtool_stats(struct net_device
 			rx_buf_alloc_fail += tmp_rx_buf_alloc_fail;
 			rx_desc_err_dropped_pkt += tmp_rx_desc_err_dropped_pkt;
 			rx_hsplit_unsplit_pkt += tmp_rx_hsplit_unsplit_pkt;
+			xdp_tx_errors += tmp_xdp_tx_errors;
+			xdp_redirect_errors += tmp_xdp_redirect_errors;
 		}
 	}
 	for (tx_pkts = 0, tx_bytes = 0, tx_dropped = 0, ring = 0;
@@ -250,8 +257,8 @@ gve_get_ethtool_stats(struct net_device
 	data[i++] = rx_bytes;
 	data[i++] = tx_bytes;
 	/* total rx dropped packets */
-	data[i++] = rx_skb_alloc_fail + rx_buf_alloc_fail +
-		    rx_desc_err_dropped_pkt;
+	data[i++] = rx_skb_alloc_fail + rx_desc_err_dropped_pkt +
+		    xdp_tx_errors + xdp_redirect_errors;
 	data[i++] = tx_dropped;
 	data[i++] = priv->tx_timeo_cnt;
 	data[i++] = rx_skb_alloc_fail;
@@ -330,6 +337,9 @@ gve_get_ethtool_stats(struct net_device
 				tmp_rx_buf_alloc_fail = rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =
 					rx->rx_desc_err_dropped_pkt;
+				tmp_xdp_tx_errors = rx->xdp_tx_errors;
+				tmp_xdp_redirect_errors =
+					rx->xdp_redirect_errors;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
 			data[i++] = tmp_rx_bytes;
@@ -340,8 +350,9 @@ gve_get_ethtool_stats(struct net_device
 			data[i++] = rx->rx_frag_alloc_cnt;
 			/* rx dropped packets */
 			data[i++] = tmp_rx_skb_alloc_fail +
-				tmp_rx_buf_alloc_fail +
-				tmp_rx_desc_err_dropped_pkt;
+				    tmp_rx_desc_err_dropped_pkt +
+				    tmp_xdp_tx_errors +
+				    tmp_xdp_redirect_errors;
 			data[i++] = rx->rx_copybreak_pkt;
 			data[i++] = rx->rx_copied_pkt;
 			/* stats from NIC */


