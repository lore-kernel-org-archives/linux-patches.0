Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3771033CDB;
	Fri, 24 Nov 2023 18:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/JyI4e0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF1C433C7;
	Fri, 24 Nov 2023 18:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850845;
	bh=SEU4uk1uw8M8hC0tYhAt5qrql/i4o2+JHop+o8QAArI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/JyI4e0+2i/RDRBORqYqLC1tOOhZU+3ZZoz2ahixqkKDOhJDfESyhj1KP/WgYG+G
	 DCdJUko7apAoQezrcFmsV1lYJAOpXJShp1Zkdu4PjIysOfP8oGVIknKTpA8aorcBZo
	 2xEcNuyxwQngGXR8nYb8JQ2LOklXURk4xvr86z8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 211/491] net/mlx5e: Update doorbell for port timestamping CQ before the software counter
Date: Fri, 24 Nov 2023 17:47:27 +0000
Message-ID: <20231124172030.865692678@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 92214be5979c0961a471b7eaaaeacab41bdf456c ]

Previously, mlx5e_ptp_poll_ts_cq would update the device doorbell with the
incremented consumer index after the relevant software counters in the
kernel were updated. In the mlx5e_sq_xmit_wqe context, this would lead to
either overrunning the device CQ or exceeding the expected software buffer
size in the device CQ if the device CQ size was greater than the software
buffer size. Update the relevant software counter only after updating the
device CQ consumer index in the port timestamping napi_poll context.

Log:
    mlx5_core 0000:08:00.0: cq_err_event_notifier:517:(pid 0): CQ error on CQN 0x487, syndrome 0x1
    mlx5_core 0000:08:00.0 eth2: mlx5e_cq_error_event: cqn=0x000487 event=0x04

Fixes: 1880bc4e4a96 ("net/mlx5e: Add TX port timestamp support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20231114215846.5902-12-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index bb11e644d24f7..af3928eddafd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -177,6 +177,8 @@ static void mlx5e_ptpsq_mark_ts_cqes_undelivered(struct mlx5e_ptpsq *ptpsq,
 
 static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 				    struct mlx5_cqe64 *cqe,
+				    u8 *md_buff,
+				    u8 *md_buff_sz,
 				    int budget)
 {
 	struct mlx5e_ptp_port_ts_cqe_list *pending_cqe_list = ptpsq->ts_cqe_pending_list;
@@ -211,19 +213,24 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	mlx5e_ptpsq_mark_ts_cqes_undelivered(ptpsq, hwtstamp);
 out:
 	napi_consume_skb(skb, budget);
-	mlx5e_ptp_metadata_fifo_push(&ptpsq->metadata_freelist, metadata_id);
+	md_buff[*md_buff_sz++] = metadata_id;
 	if (unlikely(mlx5e_ptp_metadata_map_unhealthy(&ptpsq->metadata_map)) &&
 	    !test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
 		queue_work(ptpsq->txqsq.priv->wq, &ptpsq->report_unhealthy_work);
 }
 
-static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
+static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int napi_budget)
 {
 	struct mlx5e_ptpsq *ptpsq = container_of(cq, struct mlx5e_ptpsq, ts_cq);
-	struct mlx5_cqwq *cqwq = &cq->wq;
+	int budget = min(napi_budget, MLX5E_TX_CQ_POLL_BUDGET);
+	u8 metadata_buff[MLX5E_TX_CQ_POLL_BUDGET];
+	u8 metadata_buff_sz = 0;
+	struct mlx5_cqwq *cqwq;
 	struct mlx5_cqe64 *cqe;
 	int work_done = 0;
 
+	cqwq = &cq->wq;
+
 	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &ptpsq->txqsq.state)))
 		return false;
 
@@ -234,7 +241,8 @@ static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
 	do {
 		mlx5_cqwq_pop(cqwq);
 
-		mlx5e_ptp_handle_ts_cqe(ptpsq, cqe, budget);
+		mlx5e_ptp_handle_ts_cqe(ptpsq, cqe,
+					metadata_buff, &metadata_buff_sz, napi_budget);
 	} while ((++work_done < budget) && (cqe = mlx5_cqwq_get_cqe(cqwq)));
 
 	mlx5_cqwq_update_db_record(cqwq);
@@ -242,6 +250,10 @@ static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
 	/* ensure cq space is freed before enabling more cqes */
 	wmb();
 
+	while (metadata_buff_sz > 0)
+		mlx5e_ptp_metadata_fifo_push(&ptpsq->metadata_freelist,
+					     metadata_buff[--metadata_buff_sz]);
+
 	mlx5e_txqsq_wake(&ptpsq->txqsq);
 
 	return work_done == budget;
-- 
2.42.0



