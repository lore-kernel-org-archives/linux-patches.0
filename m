Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E5E4E3230;
	Thu, 17 Sep 2026 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659587; cv=none; b=iCiI2rCK9So7u0e9SIBZDkD8K7+J9qm4GdcCi6zNYy6Zw38tbdBJRQuHhzv3NvjjTUIggAbFxnH4EQ/rOEX+gRI+guL7JxCwcsQN8ZgYGWlQd29lJZwfsJVZX7KHopsiH3EBDjfhd6Z8eQCiONNQditLmZil2qCSY/UFhRQGFR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659587; c=relaxed/simple;
	bh=w1jRA6fXTUcW8vssFrLdOf812VsTTMrjygBpNhk5GOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4QxxaN21u6A2N4z/DqrACV+kcH8b3yLyoJU0dLsi1bMi6tubnRdx9HRMj5YOU7G/NPxv23pAAuP+utsnE0zrcWCkgBafZ3XjCQnubpZzmLbavh3BGPi/duCvKNx5njMci2zZM4p8yxKWKTGA58S+quEwS69LPCFhyuRTAJ9fZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsORu6dI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsORu6dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAC71F00899;
	Thu, 17 Sep 2026 15:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659577;
	bh=5bg2+ogBRd3RrihzCShmNsxACkNYTsxVOvtJ9hRKpCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsORu6dI0yv2HG1iPJNNgfCPQrr1fZvH31cdkj6LGa+dceVzn+7EXpxeCQxCGhjTw
	 WS+YWgtO83VJBCtpwIu4S12lx1GtPr1pMccYktUAUVtsqL89RW3D1Cm9XfegmX0NSk
	 Xr0U6T+GnM/E83kfIVvLa3ZoeKYPFdjU91DJ2nj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 304/733] net/mlx5e: Keep HW timestamp stats monotonic across reconfiguration
Date: Thu, 17 Sep 2026 16:10:12 +0100
Message-ID: <20260917151359.022818671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit df99553f840e4c529c1ba4c29bd39396466ca11a ]

`mlx5e_stats_ts_get()` currently selects either DMA or port timestamp
counters based on `tx_ptp_opened`. This flag is intentionally kept set
once the PTP TX queues have been opened so their statistics remain
available after queue teardown. As a result, DMA timestamps are no
longer reported after switching from port timestamping back to DMA
timestamping.

The function also reads statistics only from the currently active
channels and TCs. Reducing the number of channels or TCs can therefore
drop previously accumulated timestamp counters from the reported value.

Read the persistent channel statistics instead and always include DMA
timestamp counters. Once the PTP TX queues have been opened, also
include the port timestamp counters.

This also drops state_lock. It previously protected live channel/PTP
pointers, the new code only reads persistent channel_stats and
ptp_stats via mlx5e_stats_nch_read(), which is already safe for
lockless stats access.

Fixes: 3579032c08c1 ("net/mlx5e: Implement ethtool hardware timestamping statistics")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260902193731.3668958-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 51 ++++++++-----------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e7e6db7f6bf17..cd94bb44f6ab0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1199,50 +1199,39 @@ void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
 void mlx5e_stats_ts_get(struct mlx5e_priv *priv,
 			struct ethtool_ts_stats *ts_stats)
 {
-	int i, j;
+	u16 nch = mlx5e_stats_nch_read(priv);
+	int i, tc;
 
-	mutex_lock(&priv->state_lock);
+	ts_stats->pkts = 0;
 
-	if (priv->tx_ptp_opened) {
-		struct mlx5e_ptp *ptp = priv->channels.ptp;
+	for (i = 0; i < nch; i++) {
+		struct mlx5e_channel_stats *channel_stats =
+			priv->channel_stats[i];
 
-		ts_stats->pkts = 0;
+		for (tc = 0; tc < priv->max_opened_tc; tc++)
+			ts_stats->pkts += channel_stats->sq[tc].timestamps;
+	}
+
+	/* Accumulate DMA and port timestamp counters so values stay monotonic
+	 * across channel teardown and mode switches.
+	 */
+	if (priv->tx_ptp_opened) {
+		/* Err and Lost stats are only relevant for port timestamping,
+		 * as the DMA layer will always successfully timestamp packets.
+		 */
 		ts_stats->err = 0;
 		ts_stats->lost = 0;
 
-		if (!ptp)
-			goto out;
-
-		/* Aggregate stats across all TCs */
-		for (i = 0; i < ptp->num_tc; i++) {
+		for (tc = 0; tc < priv->max_opened_tc; tc++) {
 			struct mlx5e_ptp_cq_stats *stats =
-				ptp->ptpsq[i].cq_stats;
+				&priv->ptp_stats.cq[tc];
 
 			ts_stats->pkts += stats->cqe;
 			ts_stats->err += stats->abort + stats->err_cqe +
-				stats->late_cqe;
+					stats->late_cqe;
 			ts_stats->lost += stats->lost_cqe;
 		}
-	} else {
-		/* DMA layer will always successfully timestamp packets. Other
-		 * counters do not make sense for this layer.
-		 */
-		ts_stats->pkts = 0;
-
-		/* Aggregate stats across all SQs */
-		for (j = 0; j < priv->channels.num; j++) {
-			struct mlx5e_channel *c = priv->channels.c[j];
-
-			for (i = 0; i < c->num_tc; i++) {
-				struct mlx5e_sq_stats *stats = c->sq[i].stats;
-
-				ts_stats->pkts += stats->timestamps;
-			}
-		}
 	}
-
-out:
-	mutex_unlock(&priv->state_lock);
 }
 
 #define PPORT_PHY_LAYER_OFF(c) \
-- 
2.53.0



