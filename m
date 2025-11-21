Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FC3272801;
	Fri, 21 Nov 2025 13:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731092; cv=none; b=W1HfMaSnMMEh7xJJCIFnSeBLKhXPjuQylvTEMmBxrb6kZjaUSH5UUBZlx6EcKkMNd1ZaIe7FJuzORD3oRJqWwXqZ62qrPizTFFL2BsogTCyidxCuU5PoNIhBXZcCd8nIs6QP7nTp+SIH4QKxZqVv68ZKKzqdIEGX6x1dpnqck9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731092; c=relaxed/simple;
	bh=GRCrrreeSoiBCiLLAbkEye9KrZINitIcOhA0O/kmhcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF5upyb+iYciyRa8GznUsKRFL9N+kN9Ki1g6Cc3IcSw4+TX2Y7THpNlJZEHdbRr0sQv9CzQIiesCPziDWPWZVEHez83AsbkXfFohLHQq9bkiIvaZnW9xRNCq42GagJnKu8w4T3oSVxyykMBEUuphOfhkIFwJbhmgYF85Iz3zk1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIWEe7gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIWEe7gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC71C4CEF1;
	Fri, 21 Nov 2025 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731092;
	bh=GRCrrreeSoiBCiLLAbkEye9KrZINitIcOhA0O/kmhcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIWEe7gkzrshB8c3g6ylbvByYP7KRm+jXFtlF1tJ0N4CnRFgi1u277kEg8N6cNNu0
	 RHnavlvhBBMPoSvui+kYem8/IhClVxN1LeR4g0Q8ixoDK+OI/NerUDfZDu66SfhfIG
	 C5WuxsGp3MoYnbCGk80a8zlIbnXwSxNcUzoN4vYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 080/247] net/mlx5e: Prepare for using different CQ doorbells
Date: Fri, 21 Nov 2025 14:10:27 +0100
Message-ID: <20251121130157.466813715@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit a315b723e87ba4e4573e1e5c759d512f38bdc0b3 ]

Completion queues (CQs) in mlx5 use the same global doorbell, which may
become contended when accessed concurrently from many cores.

This patch prepares the CQ management code for supporting different
doorbells per CQ. This will be used in downstream patches to allow
separate doorbells to be used by channels CQs.

The main change is moving the 'uar' pointer from struct mlx5_core_cq to
struct mlx5e_cq, as the uar page to be used is better off stored
directly there. Other users of mlx5_core_cq also store the UAR to be
used separately and therefore the pointer being removed is dead weight
for them. As evidence, in this patch there are two users which set the
mcq.uar pointer but didn't use it, Software Steering and old Innova CQ
creation code. Instead, they rang the doorbell directly from another
pointer.

The 'uar' pointer added to struct mlx5e_cq remains in a hot cacheline
(as before), because it may get accessed for each packet.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e5eba42f0134 ("mlx5: Fix default values in create CQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c           |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h           |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h      |  5 +----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c      | 10 +++++++---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c    |  1 -
 .../ethernet/mellanox/mlx5/core/steering/sws/dr_send.c |  1 -
 include/linux/mlx5/cq.h                                |  1 -
 7 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 35039a95dcfd4..e9f319a9bdd6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -145,7 +145,6 @@ int mlx5_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 		mlx5_core_dbg(dev, "failed adding CP 0x%x to debug file system\n",
 			      cq->cqn);
 
-	cq->uar = dev->priv.bfreg.up;
 	cq->irqn = eq->core.irqn;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ff4a68648e604..4fc102d18354f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -344,6 +344,7 @@ struct mlx5e_cq {
 	/* data path - accessed per napi poll */
 	u16                        event_ctr;
 	struct napi_struct        *napi;
+	struct mlx5_uars_page     *uar;
 	struct mlx5_core_cq        mcq;
 	struct mlx5e_ch_stats     *ch_stats;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 5dc04bbfc71bb..6760bb0336df9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -309,10 +309,7 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
 {
-	struct mlx5_core_cq *mcq;
-
-	mcq = &cq->mcq;
-	mlx5_cq_arm(mcq, MLX5_CQ_DB_REQ_NOT, mcq->uar->map, cq->wq.cc);
+	mlx5_cq_arm(&cq->mcq, MLX5_CQ_DB_REQ_NOT, cq->uar->map, cq->wq.cc);
 }
 
 static inline struct mlx5e_sq_dma *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1a90fd1d44edb..110d654796de9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2201,6 +2201,7 @@ static void mlx5e_close_xdpredirect_sq(struct mlx5e_xdpsq *xdpsq)
 static int mlx5e_alloc_cq_common(struct mlx5_core_dev *mdev,
 				 struct net_device *netdev,
 				 struct workqueue_struct *workqueue,
+				 struct mlx5_uars_page *uar,
 				 struct mlx5e_cq_param *param,
 				 struct mlx5e_cq *cq)
 {
@@ -2232,6 +2233,7 @@ static int mlx5e_alloc_cq_common(struct mlx5_core_dev *mdev,
 	cq->mdev = mdev;
 	cq->netdev = netdev;
 	cq->workqueue = workqueue;
+	cq->uar = uar;
 
 	return 0;
 }
@@ -2247,7 +2249,8 @@ static int mlx5e_alloc_cq(struct mlx5_core_dev *mdev,
 	param->wq.db_numa_node  = ccp->node;
 	param->eq_ix            = ccp->ix;
 
-	err = mlx5e_alloc_cq_common(mdev, ccp->netdev, ccp->wq, param, cq);
+	err = mlx5e_alloc_cq_common(mdev, ccp->netdev, ccp->wq,
+				    mdev->priv.bfreg.up, param, cq);
 
 	cq->napi     = ccp->napi;
 	cq->ch_stats = ccp->ch_stats;
@@ -2292,7 +2295,7 @@ static int mlx5e_create_cq(struct mlx5e_cq *cq, struct mlx5e_cq_param *param)
 	MLX5_SET(cqc, cqc, cq_period_mode, mlx5e_cq_period_mode(param->cq_period_mode));
 
 	MLX5_SET(cqc,   cqc, c_eqn_or_apu_element, eqn);
-	MLX5_SET(cqc,   cqc, uar_page,      mdev->priv.bfreg.up->index);
+	MLX5_SET(cqc,   cqc, uar_page,      cq->uar->index);
 	MLX5_SET(cqc,   cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
 					    MLX5_ADAPTER_PAGE_SHIFT);
 	MLX5_SET64(cqc, cqc, dbr_addr,      cq->wq_ctrl.db.dma);
@@ -3584,7 +3587,8 @@ static int mlx5e_alloc_drop_cq(struct mlx5e_priv *priv,
 	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
 	param->wq.db_numa_node  = dev_to_node(mlx5_core_dma_dev(mdev));
 
-	return mlx5e_alloc_cq_common(priv->mdev, priv->netdev, priv->wq, param, cq);
+	return mlx5e_alloc_cq_common(priv->mdev, priv->netdev, priv->wq,
+				     mdev->priv.bfreg.up, param, cq);
 }
 
 int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index c4de6bf8d1b65..cb1319974f83f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -475,7 +475,6 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	*conn->cq.mcq.arm_db    = 0;
 	conn->cq.mcq.vector     = 0;
 	conn->cq.mcq.comp       = mlx5_fpga_conn_cq_complete;
-	conn->cq.mcq.uar        = fdev->conn_res.uar;
 	tasklet_setup(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet);
 
 	mlx5_fpga_dbg(fdev, "Created CQ #0x%x\n", conn->cq.mcq.cqn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c
index 4fd4e8483382c..077a77fde670e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c
@@ -1131,7 +1131,6 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	*cq->mcq.arm_db = cpu_to_be32(2 << 28);
 
 	cq->mcq.vector = 0;
-	cq->mcq.uar = uar;
 	cq->mdev = mdev;
 
 	return cq;
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 991526039ccbd..7ef2c7c7d803d 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -41,7 +41,6 @@ struct mlx5_core_cq {
 	int			cqe_sz;
 	__be32		       *set_ci_db;
 	__be32		       *arm_db;
-	struct mlx5_uars_page  *uar;
 	refcount_t		refcount;
 	struct completion	free;
 	unsigned		vector;
-- 
2.51.0



