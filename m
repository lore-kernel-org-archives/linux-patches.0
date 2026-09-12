Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0087C2EEE60;
	Sat, 12 Sep 2026 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224780; cv=none; b=G4spzb1DHm7nd6sAZ1WV54CrWoHwYHcr4mU/H+ueb5d3GCLYdZ2QSWodmISVEYFqrkr1zXryvFMORT235xxWV4EwdHOXjZIV59y+YcULYwlpO0qdVGMDAnueNX3Ex3yFJdx28dPrNA4FF5m3xUtpwuTEjDZp0lEzaSXJgts5Id4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224780; c=relaxed/simple;
	bh=xhQiNs6vwn0/rQZn/XOOwC/KeKBaGmTYhre0uHAbd4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcCAOc0NwDJjKpVz627vNVEv54Y3S6GDM2ZnsqdsbZ3oPCon3bMx6WJM9PzuSdb3KbQvKySJ/P8VzdPD2tLHO/KRitJvLd8ej99TLGPDddqyN7Inul2fQ+Uvudtq/I1FzjeUIy9VM7exq7xSX7OmMBMmAmxUrKhIN7sDch8FwRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcAKm2YL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcAKm2YL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AE51F000FF;
	Sat, 12 Sep 2026 14:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224778;
	bh=Jw2i4BU6xD932B3GxcqwEChgj4I31ADLRWdLUmGhRIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcAKm2YL+09ZENK1OW2uXI/Nv3xvjBNmVMNrtKBk9BJfAmdGvhzk+bXPTuBC2WAop
	 dTTtsg2CDtbr7RJ9IB4Dk4LgeThY3o8WkVzYpdXOpPijcERNUkqMMFbe8zphtZ555R
	 pVJA44NmKJONOi/RYf4tLgzX5f5sz83UuvK9vgio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1063/1424] RDMA/erdma: Hold CQ references when processing EQ events
Date: Sat, 12 Sep 2026 08:58:15 +0200
Message-ID: <20260912065631.109550026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 98df2aee1459ee1c62c70cbe9b370d2a532aea36 ]

EQ handlers look up CQs from dev->cq_xa and invoke CQ completion or
error callbacks outside the xarray lock. erdma_destroy_cq() can erase the
CQ from the xarray and free its queue buffer and doorbell record while a
previously scheduled EQ handler is still using the CQ.

Add a CQ refcount and take a reference under the xarray lock with
refcount_inc_not_zero(). Remove the CQ from the xarray before dropping
the destroy-path reference, then wait for in-flight EQ users before
releasing CQ resources.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://patch.msgid.link/20260730124357.12976-1-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_eq.c    |  6 ++++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 12 +++++++++--
 drivers/infiniband/hw/erdma/erdma_verbs.h | 25 +++++++++++++++++++++--
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index 364bddbadd37a..3fec9cd18afaf 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -52,7 +52,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 		if (FIELD_GET(ERDMA_AEQE_HDR_TYPE_MASK,
 			      le32_to_cpu(aeqe->hdr)) == ERDMA_AE_TYPE_CQ_ERR) {
 			cqn = le32_to_cpu(aeqe->event_data0);
-			cq = find_cq_by_cqn(dev, cqn);
+			cq = erdma_cq_get_by_cqn(dev, cqn);
 			if (!cq)
 				continue;
 
@@ -62,6 +62,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 			if (cq->ibcq.event_handler)
 				cq->ibcq.event_handler(&event,
 						       cq->ibcq.cq_context);
+			erdma_cq_put(cq);
 		} else {
 			qpn = le32_to_cpu(aeqe->event_data0);
 			qp = find_qp_by_qpn(dev, qpn);
@@ -142,7 +143,7 @@ void erdma_ceq_completion_handler(struct erdma_eq_cb *ceq_cb)
 		poll_cnt++;
 		cqn = FIELD_GET(ERDMA_CEQE_HDR_CQN_MASK, READ_ONCE(*ceqe));
 
-		cq = find_cq_by_cqn(dev, cqn);
+		cq = erdma_cq_get_by_cqn(dev, cqn);
 		if (!cq)
 			continue;
 
@@ -151,6 +152,7 @@ void erdma_ceq_completion_handler(struct erdma_eq_cb *ceq_cb)
 
 		if (cq->ibcq.comp_handler)
 			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+		erdma_cq_put(cq);
 	}
 
 	notify_eq(&ceq_cb->eq);
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 64faac3c99b1b..066144ae3b248 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1228,6 +1228,7 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	struct erdma_dev *dev = to_edev(ibcq->device);
 	struct erdma_ucontext *ctx = rdma_udata_to_drv_context(
 		udata, struct erdma_ucontext, ibucontext);
+	unsigned long flags;
 	int err;
 	struct erdma_cmdq_destroy_cq_req req;
 
@@ -1239,6 +1240,13 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	if (err)
 		return err;
 
+	xa_lock_irqsave(&dev->cq_xa, flags);
+	__xa_erase(&dev->cq_xa, cq->cqn);
+	xa_unlock_irqrestore(&dev->cq_xa, flags);
+
+	erdma_cq_put(cq);
+	wait_for_completion(&cq->free);
+
 	if (rdma_is_kernel_res(&cq->ibcq.res)) {
 		dma_free_coherent(&dev->pdev->dev,
 				  WARPPED_BUFSIZE(cq->depth << CQE_SHIFT),
@@ -1248,8 +1256,6 @@ int erdma_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 		put_mtt_entries(dev, &cq->user_cq.qbuf_mem);
 	}
 
-	xa_erase(&dev->cq_xa, cq->cqn);
-
 	return 0;
 }
 
@@ -1658,6 +1664,8 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	cq->ibcq.cqe = depth;
 	cq->depth = depth;
 	cq->assoc_eqn = attr->comp_vector + 1;
+	refcount_set(&cq->refcount, 1);
+	init_completion(&cq->free);
 
 	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
 			      XA_LIMIT(1, dev->attrs.max_cq - 1),
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index eb9c0f92fb6f0..10b9b8a5f6a8b 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -7,6 +7,9 @@
 #ifndef __ERDMA_VERBS_H__
 #define __ERDMA_VERBS_H__
 
+#include <linux/completion.h>
+#include <linux/refcount.h>
+
 #include "erdma.h"
 
 /* RDMA Capability. */
@@ -261,6 +264,8 @@ struct erdma_cq {
 
 	u32 depth;
 	u32 assoc_eqn;
+	refcount_t refcount;
+	struct completion free;
 
 	union {
 		struct erdma_kcq_info kern_cq;
@@ -275,9 +280,25 @@ static inline struct erdma_qp *find_qp_by_qpn(struct erdma_dev *dev, int id)
 	return (struct erdma_qp *)xa_load(&dev->qp_xa, id);
 }
 
-static inline struct erdma_cq *find_cq_by_cqn(struct erdma_dev *dev, int id)
+static inline struct erdma_cq *erdma_cq_get_by_cqn(struct erdma_dev *dev,
+						   int id)
+{
+	struct erdma_cq *cq;
+	unsigned long flags;
+
+	xa_lock_irqsave(&dev->cq_xa, flags);
+	cq = xa_load(&dev->cq_xa, id);
+	if (cq && !refcount_inc_not_zero(&cq->refcount))
+		cq = NULL;
+	xa_unlock_irqrestore(&dev->cq_xa, flags);
+
+	return cq;
+}
+
+static inline void erdma_cq_put(struct erdma_cq *cq)
 {
-	return (struct erdma_cq *)xa_load(&dev->cq_xa, id);
+	if (refcount_dec_and_test(&cq->refcount))
+		complete(&cq->free);
 }
 
 void erdma_qp_get(struct erdma_qp *qp);
-- 
2.53.0



