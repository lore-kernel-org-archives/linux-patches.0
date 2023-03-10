Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B382847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CF8C4339C;
	Fri, 10 Mar 2023 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456683;
	bh=lVIYVInF/4g3d/DflonBHznBjXiViExa+vlP/a+90e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2sa0W3OD84vNV2FKfxguAYjcZbb6FyL7zVW3N23ehsuJI30eKxykDYxybZl3ABdN
	 1J0vOlgtBk8dyRGDd4irLKiBq2fu7+VdjtsCq8l0D4S+93HNfgbztibd7q3oXaqyAD
	 rIEEb7E5OA5Ux4wCQsGoD0xZMewz+VudR+SlZrc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadfed@meta.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 088/211] mlx5: fix possible ptp queue fifo use-after-free
Date: Fri, 10 Mar 2023 14:37:48 +0100
Message-Id: <20230310133721.462854855@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 3a50cf1e8e5157b82268eee7e330dbe5736a0948 ]

Fifo indexes are not checked during pop operations and it leads to
potential use-after-free when poping from empty queue. Such case was
possible during re-sync action. WARN_ON_ONCE covers future cases.

There were out-of-order cqe spotted which lead to drain of the queue and
use-after-free because of lack of fifo pointers check. Special check and
counter are added to avoid resync operation if SKB could not exist in the
fifo because of OOO cqe (skb_id must be between consumer and producer
index).

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 19 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  1 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index b72de2b520ecb..ae75e230170b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,6 +86,17 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
+static bool mlx5e_ptp_ts_cqe_ooo(struct mlx5e_ptpsq *ptpsq, u16 skb_id)
+{
+	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+	u16 skb_pc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc);
+
+	if (PTP_WQE_CTR2IDX(skb_id - skb_cc) >= PTP_WQE_CTR2IDX(skb_pc - skb_cc))
+		return true;
+
+	return false;
+}
+
 static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
 					     u16 skb_id, int budget)
 {
@@ -120,8 +131,14 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
+		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
+			/* already handled by a previous resync */
+			ptpsq->cq_stats->ooo_cqe_drop++;
+			return;
+		}
 		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
+	}
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 15a5a57b47b85..1b3a65325ece1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -297,6 +297,8 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 static inline
 struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
 {
+	WARN_ON_ONCE(*fifo->pc == *fifo->cc);
+
 	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 6687b8136e441..4478223c17209 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2138,6 +2138,7 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, ooo_cqe_drop) },
 };
 
 static const struct counter_desc ptp_rq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 375752d6546d5..b77100b60b505 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -461,6 +461,7 @@ struct mlx5e_ptp_cq_stats {
 	u64 abort_abs_diff_ns;
 	u64 resync_cqe;
 	u64 resync_event;
+	u64 ooo_cqe_drop;
 };
 
 struct mlx5e_rep_stats {
-- 
2.39.2



