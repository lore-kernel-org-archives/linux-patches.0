Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDC521A444;
	Mon,  2 Jun 2025 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877531; cv=none; b=ZbztihcBtF5vMKTHNS/q5KoHHfgcQSM6v7JPdQ4Fz3/CTTiiY04S33DOE0VaNP6unOtyqKhAVLX0EjFZL9QytKbr44FoJSRfyTgbfyt5hQ7vV3g0AdDufKLgE2TrDzo2CyoKSosT4MbB0rTiVNWXtgWjT9hLn3wKEzWhe5NoOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877531; c=relaxed/simple;
	bh=i6bq0IK/dBhJwfTIS2GwzShaQyQ3r5CLAmiOPXKgn88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXrDHRAuX++doasKn3KYxOIfAHlLwD3YxYLUwHcb9V/1V26P8JnSxQx5DiJHKqXbcU25oNmbu+S/4zpPzra8AZ/LXmRmtqAnp6qKM19qWk1LbkVUScH4zfbB25Tw3YxoXVSCZhdzb+YChyLbnUuLqFoyd4nv8rJjozRb/cd/Ep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s40ww+hT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s40ww+hT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EE1C4CEEB;
	Mon,  2 Jun 2025 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877530;
	bh=i6bq0IK/dBhJwfTIS2GwzShaQyQ3r5CLAmiOPXKgn88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s40ww+hT/DeSxjPObX4SGGBztsYroA0TPG5AunFvTBFJEooB2ysi+fRsrUVBGCv6M
	 jdRqx5jVeaQYbsX0nf2npH+44vgVfTvGeEoqMpkqEPz/NoFV8o1WoLQE7FnU9x1fTE
	 zoDUhlFbbnJKYSt4Uqq9PGHRuV1vh/8ti5exhxNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 277/325] octeontx2-pf: Fix page pool cache index corruption.
Date: Mon,  2 Jun 2025 15:49:13 +0200
Message-ID: <20250602134331.019405883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

commit 88e69af061f2e061a68751ef9cad47a674527a1b upstream.

The access to page pool `cache' array and the `count' variable
is not locked. Page pool cache access is fine as long as there
is only one consumer per pool.

octeontx2 driver fills in rx buffers from page pool in NAPI context.
If system is stressed and could not allocate buffers, refiiling work
will be delegated to a delayed workqueue. This means that there are
two cosumers to the page pool cache.

Either workqueue or IRQ/NAPI can be run on other CPU. This will lead
to lock less access, hence corruption of cache pool indexes.

To fix this issue, NAPI is rescheduled from workqueue context to refill
rx buffers.

Fixes: b2e3406a38f0 ("octeontx2-pf: Add support for page pool")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c       |    6 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h       |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |   43 ++-------------
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h |    3 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c     |    7 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c   |   30 ++++++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h   |    4 -
 7 files changed, 44 insertions(+), 51 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -107,12 +107,13 @@ int cn10k_sq_aq_init(void *dev, u16 qidx
 }
 
 #define NPA_MAX_BURST 16
-void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq)
+int cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq)
 {
 	struct otx2_nic *pfvf = dev;
+	int cnt = cq->pool_ptrs;
 	u64 ptrs[NPA_MAX_BURST];
-	int num_ptrs = 1;
 	dma_addr_t bufptr;
+	int num_ptrs = 1;
 
 	/* Refill pool with new buffers */
 	while (cq->pool_ptrs) {
@@ -131,6 +132,7 @@ void cn10k_refill_pool_ptrs(void *dev, s
 			num_ptrs = 1;
 		}
 	}
+	return cnt - cq->pool_ptrs;
 }
 
 void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx)
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
@@ -24,7 +24,7 @@ static inline int mtu_to_dwrr_weight(str
 	return weight;
 }
 
-void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
+int cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
 void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx);
 int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
 int cn10k_lmtst_init(struct otx2_nic *pfvf);
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -567,20 +567,8 @@ int otx2_alloc_rbuf(struct otx2_nic *pfv
 int otx2_alloc_buffer(struct otx2_nic *pfvf, struct otx2_cq_queue *cq,
 		      dma_addr_t *dma)
 {
-	if (unlikely(__otx2_alloc_rbuf(pfvf, cq->rbpool, dma))) {
-		struct refill_work *work;
-		struct delayed_work *dwork;
-
-		work = &pfvf->refill_wrk[cq->cq_idx];
-		dwork = &work->pool_refill_work;
-		/* Schedule a task if no other task is running */
-		if (!cq->refill_task_sched) {
-			cq->refill_task_sched = true;
-			schedule_delayed_work(dwork,
-					      msecs_to_jiffies(100));
-		}
+	if (unlikely(__otx2_alloc_rbuf(pfvf, cq->rbpool, dma)))
 		return -ENOMEM;
-	}
 	return 0;
 }
 
@@ -1081,39 +1069,20 @@ static int otx2_cq_init(struct otx2_nic
 static void otx2_pool_refill_task(struct work_struct *work)
 {
 	struct otx2_cq_queue *cq;
-	struct otx2_pool *rbpool;
 	struct refill_work *wrk;
-	int qidx, free_ptrs = 0;
 	struct otx2_nic *pfvf;
-	dma_addr_t bufptr;
+	int qidx;
 
 	wrk = container_of(work, struct refill_work, pool_refill_work.work);
 	pfvf = wrk->pf;
 	qidx = wrk - pfvf->refill_wrk;
 	cq = &pfvf->qset.cq[qidx];
-	rbpool = cq->rbpool;
-	free_ptrs = cq->pool_ptrs;
-
-	while (cq->pool_ptrs) {
-		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
-			/* Schedule a WQ if we fails to free atleast half of the
-			 * pointers else enable napi for this RQ.
-			 */
-			if (!((free_ptrs - cq->pool_ptrs) > free_ptrs / 2)) {
-				struct delayed_work *dwork;
 
-				dwork = &wrk->pool_refill_work;
-				schedule_delayed_work(dwork,
-						      msecs_to_jiffies(100));
-			} else {
-				cq->refill_task_sched = false;
-			}
-			return;
-		}
-		pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
-		cq->pool_ptrs--;
-	}
 	cq->refill_task_sched = false;
+
+	local_bh_disable();
+	napi_schedule(wrk->napi);
+	local_bh_enable();
 }
 
 int otx2_config_nix_queues(struct otx2_nic *pfvf)
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -280,6 +280,7 @@ struct flr_work {
 struct refill_work {
 	struct delayed_work pool_refill_work;
 	struct otx2_nic *pf;
+	struct napi_struct *napi;
 };
 
 /* PTPv2 originTimestamp structure */
@@ -347,7 +348,7 @@ struct dev_hw_ops {
 	int	(*sq_aq_init)(void *dev, u16 qidx, u16 sqb_aura);
 	void	(*sqe_flush)(void *dev, struct otx2_snd_queue *sq,
 			     int size, int qidx);
-	void	(*refill_pool_ptrs)(void *dev, struct otx2_cq_queue *cq);
+	int	(*refill_pool_ptrs)(void *dev, struct otx2_cq_queue *cq);
 	void	(*aura_freeptr)(void *dev, int aura, u64 buf);
 };
 
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2005,6 +2005,10 @@ int otx2_stop(struct net_device *netdev)
 
 	netif_tx_disable(netdev);
 
+	for (wrk = 0; wrk < pf->qset.cq_cnt; wrk++)
+		cancel_delayed_work_sync(&pf->refill_wrk[wrk].pool_refill_work);
+	devm_kfree(pf->dev, pf->refill_wrk);
+
 	otx2_free_hw_resources(pf);
 	otx2_free_cints(pf, pf->hw.cint_cnt);
 	otx2_disable_napi(pf);
@@ -2012,9 +2016,6 @@ int otx2_stop(struct net_device *netdev)
 	for (qidx = 0; qidx < netdev->num_tx_queues; qidx++)
 		netdev_tx_reset_queue(netdev_get_tx_queue(netdev, qidx));
 
-	for (wrk = 0; wrk < pf->qset.cq_cnt; wrk++)
-		cancel_delayed_work_sync(&pf->refill_wrk[wrk].pool_refill_work);
-	devm_kfree(pf->dev, pf->refill_wrk);
 
 	kfree(qset->sq);
 	kfree(qset->cq);
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -428,9 +428,10 @@ process_cqe:
 	return processed_cqe;
 }
 
-void otx2_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq)
+int otx2_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq)
 {
 	struct otx2_nic *pfvf = dev;
+	int cnt = cq->pool_ptrs;
 	dma_addr_t bufptr;
 
 	while (cq->pool_ptrs) {
@@ -439,6 +440,8 @@ void otx2_refill_pool_ptrs(void *dev, st
 		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
+
+	return cnt - cq->pool_ptrs;
 }
 
 static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
@@ -532,6 +535,7 @@ int otx2_napi_handler(struct napi_struct
 	struct otx2_cq_queue *cq;
 	struct otx2_qset *qset;
 	struct otx2_nic *pfvf;
+	int filled_cnt = -1;
 
 	cq_poll = container_of(napi, struct otx2_cq_poll, napi);
 	pfvf = (struct otx2_nic *)cq_poll->dev;
@@ -552,7 +556,7 @@ int otx2_napi_handler(struct napi_struct
 	}
 
 	if (rx_cq && rx_cq->pool_ptrs)
-		pfvf->hw_ops->refill_pool_ptrs(pfvf, rx_cq);
+		filled_cnt = pfvf->hw_ops->refill_pool_ptrs(pfvf, rx_cq);
 	/* Clear the IRQ */
 	otx2_write64(pfvf, NIX_LF_CINTX_INT(cq_poll->cint_idx), BIT_ULL(0));
 
@@ -565,9 +569,25 @@ int otx2_napi_handler(struct napi_struct
 		if (pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED)
 			otx2_adjust_adaptive_coalese(pfvf, cq_poll);
 
-		/* Re-enable interrupts */
-		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
-			     BIT_ULL(0));
+		if (unlikely(!filled_cnt)) {
+			struct refill_work *work;
+			struct delayed_work *dwork;
+
+			work = &pfvf->refill_wrk[cq->cq_idx];
+			dwork = &work->pool_refill_work;
+			/* Schedule a task if no other task is running */
+			if (!cq->refill_task_sched) {
+				work->napi = napi;
+				cq->refill_task_sched = true;
+				schedule_delayed_work(dwork,
+						      msecs_to_jiffies(100));
+			}
+		} else {
+			/* Re-enable interrupts */
+			otx2_write64(pfvf,
+				     NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
+				     BIT_ULL(0));
+		}
 	}
 	return workdone;
 }
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -170,6 +170,6 @@ void cn10k_sqe_flush(void *dev, struct o
 		     int size, int qidx);
 void otx2_sqe_flush(void *dev, struct otx2_snd_queue *sq,
 		    int size, int qidx);
-void otx2_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
-void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
+int otx2_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
+int cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
 #endif /* OTX2_TXRX_H */


