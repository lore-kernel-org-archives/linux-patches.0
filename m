Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A69611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923B7C433EF;
	Sun, 28 May 2023 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302728;
	bh=OXAeKMjNpncyGE6G9rpaunZQW80MRg9WFqPtyUVTfO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6TuGq4sEV8w1gj+23IlWuPoWPsjMiFBrP6DstBL47SBGEnefnSZyRWnaKfVq5nb+
	 Zq66ju0+VU0ErQjpu7gRS1Oh/FpRgRjtK5GJDSxFH60JTiKOXfqo7Sko0C75NtWK/V
	 tF4jsSyvwVRKuKBy9sbdbAzeaqXCQLcdyME1kY8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 103/119] net/mlx5e: Fix SQ wake logic in ptp napi_poll context
Date: Sun, 28 May 2023 20:11:43 +0100
Message-Id: <20230528190838.921202007@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

commit 7aa50380191635e5897a773f272829cc961a2be5 upstream.

Check in the mlx5e_ptp_poll_ts_cq context if the ptp tx sq should be woken
up. Before change, the ptp tx sq may never wake up if the ptp tx ts skb
fifo is full when mlx5e_poll_tx_cq checks if the queue should be woken up.

Fixes: 1880bc4e4a96 ("net/mlx5e: Add TX port timestamp support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  |    2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h |    2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   |   19 ++++++++++++-------
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -175,6 +175,8 @@ static bool mlx5e_ptp_poll_ts_cq(struct
 	/* ensure cq space is freed before enabling more cqes */
 	wmb();
 
+	mlx5e_txqsq_wake(&ptpsq->txqsq);
+
 	return work_done == budget;
 }
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -177,6 +177,8 @@ static inline u16 mlx5e_txqsq_get_next_p
 	return pi;
 }
 
+void mlx5e_txqsq_wake(struct mlx5e_txqsq *sq);
+
 static inline u16 mlx5e_shampo_get_cqe_header_index(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	return be16_to_cpu(cqe->shampo.header_entry_index) & (rq->mpwqe.shampo->hd_per_wq - 1);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -777,6 +777,17 @@ static void mlx5e_tx_wi_consume_fifo_skb
 	}
 }
 
+void mlx5e_txqsq_wake(struct mlx5e_txqsq *sq)
+{
+	if (netif_tx_queue_stopped(sq->txq) &&
+	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
+	    mlx5e_ptpsq_fifo_has_room(sq) &&
+	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
+		netif_tx_wake_queue(sq->txq);
+		sq->stats->wake++;
+	}
+}
+
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 {
 	struct mlx5e_sq_stats *stats;
@@ -876,13 +887,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *c
 
 	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 
-	if (netif_tx_queue_stopped(sq->txq) &&
-	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
-	    mlx5e_ptpsq_fifo_has_room(sq) &&
-	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
-		netif_tx_wake_queue(sq->txq);
-		stats->wake++;
-	}
+	mlx5e_txqsq_wake(sq);
 
 	return (i == MLX5E_TX_CQ_POLL_BUDGET);
 }


