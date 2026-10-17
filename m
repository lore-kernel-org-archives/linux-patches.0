Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52063563E1;
	Sat, 17 Oct 2026 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252554; cv=none; b=pHMSXY9Lan/dNb2SkLJxWyZ+KWb8oUiSWrqhfkFT8OvdCnVQdzXZ7kKGKSSqR8wsiVnzHdbwMqjoWsK/WT+cASmpHI7I+94QpC5Gd+dyS8ew6E4HOIgQy268IL9J0RtFNJOJ1N2DRELJikzH/dlTRb59a/ESVg9aCqZMK7LAfco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252554; c=relaxed/simple;
	bh=j6goRb/EsaemX+m1lW3DgDHRjQzBetko9yx/PPdtPJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGt9QVievEI9jw8LOW9m6oJb6+Eyb2x6ZZRE01S6BQzwxSrSAepZHWDmblXCeJJkIMm/xtU+ni3W8MCGtI9QbkbgH+QnKSfQao/0tYTUBuWgKrpJHONrmur4brJd1PmbrHiyl5IcEW5qwn9RkJsDAIpzur9eBWBGPz995pLZh14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/rQ35fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/rQ35fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BAD1F000C6;
	Sat, 17 Oct 2026 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252553;
	bh=voM1JAPGgbUsOxSPoyINJlBw6Raba+I7O7yLJBGDJeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/rQ35fmeDdFB1BqhQMFeazGwCruVsP8/huwEbg/5s1ZpJCl1qcoGafhU80eYwXat
	 O/OGm6935vZsjypRnDep4h490WTK9p6OWjeDd+AEu5gXdbukg+NHPxjxuuNoMlJREP
	 n6FEfRJGJtsHSinD3JcAlRCzdOYrq6KC/jMz+A/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 03/52] RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
Date: Sat, 17 Oct 2026 17:54:04 +0200
Message-ID: <20261017155104.951570962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 00baeade709fb66da647e8327e8398bb532e30f7 ]

Locked QP and CQ lookups from EQ interrupts can deadlock with
create-path XArray updates. If an interrupt arrives while the create
path holds the plain xa_lock, the lookup spins forever trying to
acquire the same lock.

Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
including the GSI QP store and error paths. Initialize both arrays with
XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.

Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ events")
Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM processing")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://patch.msgid.link/20260828030344.88021-1-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_main.c  |  4 ++--
 drivers/infiniband/hw/erdma/erdma_verbs.c | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_main.c b/drivers/infiniband/hw/erdma/erdma_main.c
index f35b30235018b..f76da01a1d1fe 100644
--- a/drivers/infiniband/hw/erdma/erdma_main.c
+++ b/drivers/infiniband/hw/erdma/erdma_main.c
@@ -573,8 +573,8 @@ static int erdma_ib_device_add(struct pci_dev *pdev)
 	INIT_LIST_HEAD(&dev->cep_list);
 
 	spin_lock_init(&dev->lock);
-	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1);
-	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1);
+	xa_init_flags(&dev->qp_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
+	xa_init_flags(&dev->cq_xa, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
 	dev->next_alloc_cqn = 1;
 	dev->next_alloc_qpn = 1;
 
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index fdd67756f3bc3..6feac67d84721 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1019,15 +1019,15 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	init_completion(&qp->safe_free);
 
 	if (qp->ibqp.qp_type == IB_QPT_GSI) {
-		old_entry = xa_store(&dev->qp_xa, 1, qp, GFP_KERNEL);
+		old_entry = xa_store_irq(&dev->qp_xa, 1, qp, GFP_KERNEL);
 		if (xa_is_err(old_entry))
 			ret = xa_err(old_entry);
 		else
 			qp->ibqp.qp_num = 1;
 	} else {
-		ret = xa_alloc_cyclic(&dev->qp_xa, &qp->ibqp.qp_num, qp,
-				      XA_LIMIT(1, dev->attrs.max_qp - 1),
-				      &dev->next_alloc_qpn, GFP_KERNEL);
+		ret = xa_alloc_cyclic_irq(&dev->qp_xa, &qp->ibqp.qp_num, qp,
+					  XA_LIMIT(1, dev->attrs.max_qp - 1),
+					  &dev->next_alloc_qpn, GFP_KERNEL);
 	}
 
 	if (ret < 0) {
@@ -1090,7 +1090,7 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	else
 		free_kernel_qp(qp);
 err_out_xa:
-	xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_erase_irq(&dev->qp_xa, QP_ID(qp));
 err_out:
 	return ret;
 }
@@ -1994,9 +1994,9 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 
-	ret = xa_alloc_cyclic(&dev->cq_xa, &cq->cqn, cq,
-			      XA_LIMIT(1, dev->attrs.max_cq - 1),
-			      &dev->next_alloc_cqn, GFP_KERNEL);
+	ret = xa_alloc_cyclic_irq(&dev->cq_xa, &cq->cqn, cq,
+				  XA_LIMIT(1, dev->attrs.max_cq - 1),
+				  &dev->next_alloc_cqn, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 
@@ -2044,7 +2044,7 @@ int erdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	}
 
 err_out_xa:
-	xa_erase(&dev->cq_xa, cq->cqn);
+	xa_erase_irq(&dev->cq_xa, cq->cqn);
 
 	return ret;
 }
-- 
2.53.0



