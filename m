Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C75A7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E72C433C1;
	Wed,  2 Nov 2022 03:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358555;
	bh=3LfuRZnO5st56UjJdIRw14GTJF33z6WYY9eGr5+07RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbC7nom4gkY8sbj/gfTKJG+hFDvURAxacOhhRvsc8F5Z5AGOPQqVz9vQqzT7fJDaw
	 QLj29fze+IWPaVFwNdY0B3/ncphVZSqnUCRx9wMqGMXA6NggvBl+fdEML22sMy+gzb
	 w3d2A+x53MoeIaU06+C/TJl/2/mhnXtkLerYz0So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aya Levin <ayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/132] net/mlx5e: Extend SKB room check to include PTP-SQ
Date: Wed,  2 Nov 2022 03:33:44 +0100
Message-Id: <20221102022102.769314293@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 19b43a432e3e47db656a8269a74b50aef826950c ]

When tx_port_ts is set, the driver diverts all UPD traffic over PTP port
to a dedicated PTP-SQ. The SKBs are cached until the wire-CQE arrives.
When the packet size is greater then MTU, the firmware might drop it and
the packet won't be transmitted to the wire, hence the wire-CQE won't
reach the driver. In this case the SKBs are accumulated in the SKB fifo.
Add room check to consider the PTP-SQ SKB fifo, when the SKB fifo is
full, driver stops the queue resulting in a TX timeout. Devlink
TX-reporter can recover from it.

Fixes: 1880bc4e4a96 ("net/mlx5e: Add TX port timestamp support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-5-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h  | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 6 ++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index a71a32e00ebb..dc7c57e6de77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -6,6 +6,7 @@
 
 #include "en.h"
 #include "en_stats.h"
+#include "en/txrx.h"
 #include <linux/ptp_classify.h>
 
 #define MLX5E_PTP_CHANNEL_IX 0
@@ -67,6 +68,14 @@ static inline bool mlx5e_use_ptpsq(struct sk_buff *skb)
 		fk.ports.dst == htons(PTP_EV_PORT));
 }
 
+static inline bool mlx5e_ptpsq_fifo_has_room(struct mlx5e_txqsq *sq)
+{
+	if (!sq->ptpsq)
+		return true;
+
+	return mlx5e_skb_fifo_has_room(&sq->ptpsq->skb_fifo);
+}
+
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp);
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 055c3bc23733..f5c872043bcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -73,6 +73,12 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 
+static inline bool
+mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
+{
+	return (*fifo->pc - *fifo->cc) < fifo->mask;
+}
+
 static inline bool
 mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 1544d4c2c636..e18fa5ae0fd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -479,6 +479,11 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	if (unlikely(sq->ptpsq)) {
 		mlx5e_skb_cb_hwtstamp_init(skb);
 		mlx5e_skb_fifo_push(&sq->ptpsq->skb_fifo, skb);
+		if (!netif_tx_queue_stopped(sq->txq) &&
+		    !mlx5e_skb_fifo_has_room(&sq->ptpsq->skb_fifo)) {
+			netif_tx_stop_queue(sq->txq);
+			sq->stats->stopped++;
+		}
 		skb_get(skb);
 	}
 
@@ -906,6 +911,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 
 	if (netif_tx_queue_stopped(sq->txq) &&
 	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
+	    mlx5e_ptpsq_fifo_has_room(sq) &&
 	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
 		netif_tx_wake_queue(sq->txq);
 		stats->wake++;
-- 
2.35.1



