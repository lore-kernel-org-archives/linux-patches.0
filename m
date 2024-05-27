Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0815FCF0;
	Mon, 27 May 2024 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838588; cv=none; b=EDoZHSYb2moIpwFdyYE0VITivHxygolBPosEaLJnL/tMtLCE5L2+fhSyeyYP41IPpKpAa9IigxJKy402kl5DmAZvKEbpgyKOcL/EuV0lv+6DuZB6DEWcN4KlHfYtITTYWjpigU0eOSSJkHLUm3ZSeCMlSwWL6/bNWK0+xmQ7E8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838588; c=relaxed/simple;
	bh=K7tkI6yf3X/jaUkUjpHtCN9fuL7+CTtxFsMDuIU/YYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J18R39GNpR5i8+kNpXLm93ZN0bMH67D0bVEpsiQx4cE8iAEfs7otUIMshVebK55afdWRYDEXsa5RCbkjXZt+ay0haH0OdDZ359cD3Z5QAqsUtOTmaGUR0J1t4CJ020UmUmkkV9KHD6Gxamq4JO+rbBK46tY4ANILbOzLFbFkia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrdMOJrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrdMOJrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA46C2BBFC;
	Mon, 27 May 2024 19:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838588;
	bh=K7tkI6yf3X/jaUkUjpHtCN9fuL7+CTtxFsMDuIU/YYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrdMOJrlETSAIa2IlWjDFucspilmXzDj6neuJj9k6yHUCxmGraiLbN19nS342FZ1h
	 O3+rHiYoAi7g2t1XBcWEO74z8rrBv0Xd2+FiBCnqQuPsEWnmEMEKKhxSLnbVPpg7CU
	 mksz425G8lsGPnskpVfbcpWXGF+A6z6RxoTnitGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 452/493] RDMA/mana_ib: Use struct mana_ib_queue for CQs
Date: Mon, 27 May 2024 20:57:34 +0200
Message-ID: <20240527185645.009061999@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 60a7ac0b8bec5df9764b7460ffee91fc981e8a31 ]

Use struct mana_ib_queue and its helpers for CQs

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://lore.kernel.org/r/1711483688-24358-3-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f79edef79b6a ("RDMA/mana_ib: boundary check before installing cq callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/cq.c      | 52 ++++++----------------------
 drivers/infiniband/hw/mana/mana_ib.h |  4 +--
 drivers/infiniband/hw/mana/qp.c      | 26 +++++++-------
 3 files changed, 24 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 4a71e678d09c1..c9129218f1be1 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -39,37 +39,13 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	}
 
 	cq->cqe = attr->cqe;
-	cq->umem = ib_umem_get(ibdev, ucmd.buf_addr, cq->cqe * COMP_ENTRY_SIZE,
-			       IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(cq->umem)) {
-		err = PTR_ERR(cq->umem);
-		ibdev_dbg(ibdev, "Failed to get umem for create cq, err %d\n",
-			  err);
-		return err;
-	}
-
-	err = mana_ib_create_zero_offset_dma_region(mdev, cq->umem, &cq->gdma_region);
+	err = mana_ib_create_queue(mdev, ucmd.buf_addr, cq->cqe * COMP_ENTRY_SIZE, &cq->queue);
 	if (err) {
-		ibdev_dbg(ibdev,
-			  "Failed to create dma region for create cq, %d\n",
-			  err);
-		goto err_release_umem;
+		ibdev_dbg(ibdev, "Failed to create queue for create cq, %d\n", err);
+		return err;
 	}
 
-	ibdev_dbg(ibdev,
-		  "create_dma_region ret %d gdma_region 0x%llx\n",
-		  err, cq->gdma_region);
-
-	/*
-	 * The CQ ID is not known at this time. The ID is generated at create_qp
-	 */
-	cq->id = INVALID_QUEUE_ID;
-
 	return 0;
-
-err_release_umem:
-	ib_umem_release(cq->umem);
-	return err;
 }
 
 int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
@@ -78,24 +54,16 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	struct ib_device *ibdev = ibcq->device;
 	struct mana_ib_dev *mdev;
 	struct gdma_context *gc;
-	int err;
 
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
 	gc = mdev_to_gc(mdev);
 
-	err = mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
-	if (err) {
-		ibdev_dbg(ibdev,
-			  "Failed to destroy dma region, %d\n", err);
-		return err;
-	}
-
-	if (cq->id != INVALID_QUEUE_ID) {
-		kfree(gc->cq_table[cq->id]);
-		gc->cq_table[cq->id] = NULL;
+	if (cq->queue.id != INVALID_QUEUE_ID) {
+		kfree(gc->cq_table[cq->queue.id]);
+		gc->cq_table[cq->queue.id] = NULL;
 	}
 
-	ib_umem_release(cq->umem);
+	mana_ib_destroy_queue(mdev, &cq->queue);
 
 	return 0;
 }
@@ -114,7 +82,7 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	struct gdma_queue *gdma_cq;
 
 	/* Create CQ table entry */
-	WARN_ON(gc->cq_table[cq->id]);
+	WARN_ON(gc->cq_table[cq->queue.id]);
 	gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
 	if (!gdma_cq)
 		return -ENOMEM;
@@ -122,7 +90,7 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	gdma_cq->cq.context = cq;
 	gdma_cq->type = GDMA_CQ;
 	gdma_cq->cq.callback = mana_ib_cq_handler;
-	gdma_cq->id = cq->id;
-	gc->cq_table[cq->id] = gdma_cq;
+	gdma_cq->id = cq->queue.id;
+	gc->cq_table[cq->queue.id] = gdma_cq;
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 859fd3bfc764f..6acb5c281c368 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -88,10 +88,8 @@ struct mana_ib_mr {
 
 struct mana_ib_cq {
 	struct ib_cq ibcq;
-	struct ib_umem *umem;
+	struct mana_ib_queue queue;
 	int cqe;
-	u64 gdma_region;
-	u64 id;
 	u32 comp_vector;
 };
 
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 6e7627745c957..d7485ee6a6854 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -197,7 +197,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		wq_spec.gdma_region = wq->gdma_region;
 		wq_spec.queue_size = wq->wq_buf_size;
 
-		cq_spec.gdma_region = cq->gdma_region;
+		cq_spec.gdma_region = cq->queue.gdma_region;
 		cq_spec.queue_size = cq->cqe * COMP_ENTRY_SIZE;
 		cq_spec.modr_ctx_id = 0;
 		eq = &mpc->ac->eqs[cq->comp_vector % gc->max_num_queues];
@@ -213,16 +213,16 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 
 		/* The GDMA regions are now owned by the WQ object */
 		wq->gdma_region = GDMA_INVALID_DMA_REGION;
-		cq->gdma_region = GDMA_INVALID_DMA_REGION;
+		cq->queue.gdma_region = GDMA_INVALID_DMA_REGION;
 
 		wq->id = wq_spec.queue_index;
-		cq->id = cq_spec.queue_index;
+		cq->queue.id = cq_spec.queue_index;
 
 		ibdev_dbg(&mdev->ib_dev,
 			  "ret %d rx_object 0x%llx wq id %llu cq id %llu\n",
-			  ret, wq->rx_object, wq->id, cq->id);
+			  ret, wq->rx_object, wq->id, cq->queue.id);
 
-		resp.entries[i].cqid = cq->id;
+		resp.entries[i].cqid = cq->queue.id;
 		resp.entries[i].wqid = wq->id;
 
 		mana_ind_table[i] = wq->rx_object;
@@ -232,7 +232,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		if (ret)
 			goto fail;
 
-		gdma_cq_allocated[i] = gc->cq_table[cq->id];
+		gdma_cq_allocated[i] = gc->cq_table[cq->queue.id];
 	}
 	resp.num_entries = i;
 
@@ -264,7 +264,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		wq = container_of(ibwq, struct mana_ib_wq, ibwq);
 		cq = container_of(ibcq, struct mana_ib_cq, ibcq);
 
-		gc->cq_table[cq->id] = NULL;
+		gc->cq_table[cq->queue.id] = NULL;
 		kfree(gdma_cq_allocated[i]);
 
 		mana_destroy_wq_obj(mpc, GDMA_RQ, wq->rx_object);
@@ -374,7 +374,7 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	wq_spec.gdma_region = qp->sq_gdma_region;
 	wq_spec.queue_size = ucmd.sq_buf_size;
 
-	cq_spec.gdma_region = send_cq->gdma_region;
+	cq_spec.gdma_region = send_cq->queue.gdma_region;
 	cq_spec.queue_size = send_cq->cqe * COMP_ENTRY_SIZE;
 	cq_spec.modr_ctx_id = 0;
 	eq_vec = send_cq->comp_vector % gc->max_num_queues;
@@ -392,10 +392,10 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 	/* The GDMA regions are now owned by the WQ object */
 	qp->sq_gdma_region = GDMA_INVALID_DMA_REGION;
-	send_cq->gdma_region = GDMA_INVALID_DMA_REGION;
+	send_cq->queue.gdma_region = GDMA_INVALID_DMA_REGION;
 
 	qp->sq_id = wq_spec.queue_index;
-	send_cq->id = cq_spec.queue_index;
+	send_cq->queue.id = cq_spec.queue_index;
 
 	/* Create CQ table entry */
 	err = mana_ib_install_cq_cb(mdev, send_cq);
@@ -404,10 +404,10 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 	ibdev_dbg(&mdev->ib_dev,
 		  "ret %d qp->tx_object 0x%llx sq id %llu cq id %llu\n", err,
-		  qp->tx_object, qp->sq_id, send_cq->id);
+		  qp->tx_object, qp->sq_id, send_cq->queue.id);
 
 	resp.sqid = qp->sq_id;
-	resp.cqid = send_cq->id;
+	resp.cqid = send_cq->queue.id;
 	resp.tx_vp_offset = pd->tx_vp_offset;
 
 	err = ib_copy_to_udata(udata, &resp, sizeof(resp));
@@ -422,7 +422,7 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 
 err_release_gdma_cq:
 	kfree(gdma_cq);
-	gc->cq_table[send_cq->id] = NULL;
+	gc->cq_table[send_cq->queue.id] = NULL;
 
 err_destroy_wq_obj:
 	mana_destroy_wq_obj(mpc, GDMA_SQ, qp->tx_object);
-- 
2.43.0



