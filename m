Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC553364038;
	Sat, 12 Sep 2026 09:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206451; cv=none; b=rhninkSM5RNxDOLALTs+soiHGsxLwWkWXKEYJn6FMXN1oTM3CyrKkxCckQ2P6jPgxKkb+Dt6yirpiB94L+Y4M135vGucuj8VCsRPWfKQ955nJbz0552WJsg9tJ272o5sjWKdw6BNn7ygy8hnvwXU6UmO1Hezx2nSjqbcL9K0ROE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206451; c=relaxed/simple;
	bh=zq+O6Op8HJDB/f6ETvSaVwgh3V/ya+kUxF5gGpZKuXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOteZLq3y6OtGAUD0EDi1nMPaAa/g7YEMUoqxxX0PxvgJgnwm5PE4IZnXhKBNYKid4UUsVx0oRTn9UpC9abBIdYCHqSo1gkms83dLmlI0bjJwPpucX3TL6ffcZkl88X0ULVuqdVw4oMmxnalYHX6VqcFn0AmbEni+yfF9ye26Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pP/jZL8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP/jZL8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D05A1F00898;
	Sat, 12 Sep 2026 09:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206450;
	bh=TYtYkMGvEhBngTkX27VrylVueKYYRvs3vMuRsximAfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pP/jZL8SjL7mmkYz/VE3BGGz3ssBQzvqmssykBgb+C2zLlhK6Uaf6+uU5b88D99wg
	 PdbB/W5AjpZhmgQnknBBZ3JRszTjax9aCk2LNcMu5iVmp83Obe/M5Igi3b2wN5ZpTf
	 v1Z8Xv7hMBaMCSigfip6zMT7gfc7fjuKw125bdUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0210/1518] RDMA/irdma: Add refcounting to user ring MRs
Date: Sat, 12 Sep 2026 08:39:39 +0200
Message-ID: <20260912065628.239011474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit f67d8a08f60c9217df6d40da56422d2049f5e334 ]

Prevent userspace from deregistering the MRs that back QP/CQ/SRQ rings
by bumping the MR's refcount upon association.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260618201458.875740-5-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c |  6 ++++
 drivers/infiniband/hw/irdma/verbs.c | 45 +++++++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index e5e226b346211..835c11d6cc85c 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -1169,6 +1169,12 @@ void irdma_free_qp_rsrc(struct irdma_qp *iwqp)
 	iwqp->kqp.dma_mem.va = NULL;
 	kfree(iwqp->kqp.sq_wrid_mem);
 	kfree(iwqp->kqp.rq_wrid_mem);
+
+	if (iwqp->user_mode && iwqp->iwpbl) {
+		struct irdma_mr *iwmr = iwqp->iwpbl->iwmr;
+
+		refcount_dec(&iwmr->user_ring_refs);
+	}
 }
 
 /**
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b06e99c8c7b23..9ada0bc00bd07 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -462,6 +462,9 @@ static struct irdma_pbl *irdma_get_pbl(unsigned long va,
 
 	list_for_each_entry (iwpbl, pbl_list, list) {
 		if (iwpbl->user_base == va) {
+			struct irdma_mr *iwmr = iwpbl->iwmr;
+
+			refcount_inc(&iwmr->user_ring_refs);
 			list_del(&iwpbl->list);
 			iwpbl->on_list = false;
 			return iwpbl;
@@ -1887,6 +1890,11 @@ static void irdma_srq_free_rsrc(struct irdma_pci_f *rf, struct irdma_srq *iwsrq)
 		dma_free_coherent(rf->sc_dev.hw->device, iwsrq->kmem.size,
 				  iwsrq->kmem.va, iwsrq->kmem.pa);
 		iwsrq->kmem.va = NULL;
+	} else {
+		/* Not called in any failure path, so iwpbl is valid. */
+		struct irdma_mr *iwmr = iwsrq->iwpbl->iwmr;
+
+		refcount_dec(&iwmr->user_ring_refs);
 	}
 
 	irdma_free_rsrc(rf, rf->allocated_srqs, srq->srq_uk.srq_id);
@@ -1909,6 +1917,21 @@ static void irdma_cq_free_rsrc(struct irdma_pci_f *rf, struct irdma_cq *iwcq)
 				  iwcq->kmem_shadow.size,
 				  iwcq->kmem_shadow.va, iwcq->kmem_shadow.pa);
 		iwcq->kmem_shadow.va = NULL;
+	} else {
+		struct irdma_mr *iwmr;
+
+		/* May be called in a failure path before iwpbl is valid. */
+		if (iwcq->iwpbl) {
+			iwmr = iwcq->iwpbl->iwmr;
+
+			refcount_dec(&iwmr->user_ring_refs);
+		}
+
+		if (iwcq->iwpbl_shadow) {
+			iwmr = iwcq->iwpbl_shadow->iwmr;
+
+			refcount_dec(&iwmr->user_ring_refs);
+		}
 	}
 
 	irdma_free_rsrc(rf, rf->allocated_cqs, cq->cq_uk.cq_id);
@@ -2024,7 +2047,7 @@ static int irdma_resize_cq(struct ib_cq *ibcq, int entries,
 	struct irdma_modify_cq_info info = {};
 	struct irdma_dma_mem kmem_buf;
 	struct irdma_cq_mr *cqmr_buf;
-	struct irdma_pbl *iwpbl_buf;
+	struct irdma_pbl *iwpbl_buf = NULL;
 	struct irdma_device *iwdev;
 	struct irdma_pci_f *rf;
 	struct irdma_cq_buf *cq_buf = NULL;
@@ -2130,11 +2153,19 @@ static int irdma_resize_cq(struct ib_cq *ibcq, int entries,
 		goto error;
 
 	spin_lock_irqsave(&iwcq->lock, flags);
-	if (udata)
+	if (udata) {
+		struct irdma_pbl *old_iwpbl = iwcq->iwpbl;
+
 		/* Only update if the resize was successful. Otherwise, HW is
 		 * still pointing to the old PBL.
 		 */
 		iwcq->iwpbl = iwpbl_buf;
+		if (old_iwpbl) {
+			struct irdma_mr *old_iwmr = old_iwpbl->iwmr;
+
+			refcount_dec(&old_iwmr->user_ring_refs);
+		}
+	}
 	if (cq_buf) {
 		cq_buf->kmem_buf = iwcq->kmem;
 		cq_buf->hw = dev->hw;
@@ -2150,6 +2181,11 @@ static int irdma_resize_cq(struct ib_cq *ibcq, int entries,
 
 	return 0;
 error:
+	if (iwpbl_buf) {
+		struct irdma_mr *iwmr = iwpbl_buf->iwmr;
+
+		refcount_dec(&iwmr->user_ring_refs);
+	}
 	if (!udata) {
 		dma_free_coherent(dev->hw->device, kmem_buf.size, kmem_buf.va,
 				  kmem_buf.pa);
@@ -2427,6 +2463,11 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 		dma_free_coherent(rf->hw.device, iwsrq->kmem.size,
 				  iwsrq->kmem.va, iwsrq->kmem.pa);
 free_rsrc:
+	if (iwsrq->user_mode && iwsrq->iwpbl) {
+		struct irdma_mr *iwmr = iwsrq->iwpbl->iwmr;
+
+		refcount_dec(&iwmr->user_ring_refs);
+	}
 	irdma_free_rsrc(rf, rf->allocated_srqs, iwsrq->srq_num);
 	return err_code;
 }
-- 
2.53.0



