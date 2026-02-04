Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A719A284B37;
	Wed,  4 Feb 2026 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218169; cv=none; b=Uk9/hqL2/b5oR8FkL01Dxv+B31EkcXq7I4TEI6RFq67k2/6l0yJZ8GI9iFKocnhoEfUpYGlc3lsY0xYjJJRRFd35EUjIJDHj7O3Nrl7QYerVCvJxM3Ctez6u6DZ+z30FOwGcejchP/YxmmrzC+1/Z7jTLv+9mR7ylk6f85ATsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218169; c=relaxed/simple;
	bh=lv+nxLA2F0eWoTrDf7yUwTVS0x1XTuE5fkwyptJnkq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MggT9mGDhMtIIM4VzGya6LEhhDoaYMajQ1irGnEUPnAGkdwbb/qFqFBBlV2r/MOuLY2kMX7rteEtuyyC85/dITYX0rKB0t10HgYbT6ZpjyeHzIJfZ6qS6dwK7e2zN+iVOOH/s6XRhybrO6vNWZxn5JXtKgtAnRzuqX+/zNa6DZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=up3OTXOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="up3OTXOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154EBC4CEF7;
	Wed,  4 Feb 2026 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218169;
	bh=lv+nxLA2F0eWoTrDf7yUwTVS0x1XTuE5fkwyptJnkq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=up3OTXODerO9Ds32d9aPPleigI7VOeROYi6iFVXD6PFSksEBHuRgmVNgMH/RjErEy
	 nWK7OVVEUuoMINa8C2FNYRFrkXRMj4Jn1w3qZKxpFfdPzJ8Nf4JWRRU2oW1YGrJPeh
	 laBSmMQVesYV71N975JR1SDHgFZQmMuendeEbec4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/280] net/mlx5e: Account for netdev stats in ndo_get_stats64
Date: Wed,  4 Feb 2026 15:39:33 +0100
Message-ID: <20260204143916.766474678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 476681f10cc1e0e56e26856684e75d4678b072b2 ]

The driver's ndo_get_stats64 callback is only reporting mlx5 counters,
without accounting for the netdev stats, causing errors from the network
stack to be invisible in statistics.

Add netdev_stats_to_stats64() call to first populate the counters, then
add mlx5 counters on top, ensuring both are accounted for (where
appropriate).

Fixes: f62b8bb8f2d3 ("net/mlx5: Extend mlx5_core to support ConnectX-4 Ethernet functionality")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1769411695-18820-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1d7fe4ffdd734..2d0b57583ea35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3650,6 +3650,8 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		mlx5e_queue_update_stats(priv);
 	}
 
+	netdev_stats_to_stats64(stats, &dev->stats);
+
 	if (mlx5e_is_uplink_rep(priv)) {
 		struct mlx5e_vport_stats *vstats = &priv->stats.vport;
 
@@ -3666,21 +3668,21 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		mlx5e_fold_sw_stats64(priv, stats);
 	}
 
-	stats->rx_missed_errors = priv->stats.qcnt.rx_out_of_buffer;
-	stats->rx_dropped = PPORT_2863_GET(pstats, if_in_discards);
+	stats->rx_missed_errors += priv->stats.qcnt.rx_out_of_buffer;
+	stats->rx_dropped += PPORT_2863_GET(pstats, if_in_discards);
 
-	stats->rx_length_errors =
+	stats->rx_length_errors +=
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
 		PPORT_802_3_GET(pstats, a_out_of_range_length_field) +
 		PPORT_802_3_GET(pstats, a_frame_too_long_errors) +
 		VNIC_ENV_GET(&priv->stats.vnic, eth_wqe_too_small);
-	stats->rx_crc_errors =
+	stats->rx_crc_errors +=
 		PPORT_802_3_GET(pstats, a_frame_check_sequence_errors);
-	stats->rx_frame_errors = PPORT_802_3_GET(pstats, a_alignment_errors);
-	stats->tx_aborted_errors = PPORT_2863_GET(pstats, if_out_discards);
-	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
-			   stats->rx_frame_errors;
-	stats->tx_errors = stats->tx_aborted_errors + stats->tx_carrier_errors;
+	stats->rx_frame_errors += PPORT_802_3_GET(pstats, a_alignment_errors);
+	stats->tx_aborted_errors += PPORT_2863_GET(pstats, if_out_discards);
+	stats->rx_errors += stats->rx_length_errors + stats->rx_crc_errors +
+			    stats->rx_frame_errors;
+	stats->tx_errors += stats->tx_aborted_errors + stats->tx_carrier_errors;
 }
 
 static void mlx5e_nic_set_rx_mode(struct mlx5e_priv *priv)
-- 
2.51.0



