Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76928376BE9;
	Tue, 16 Dec 2025 12:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888085; cv=none; b=bVbRyysaHQTQxgDI3MjyfeLScuuxT5D75VyIvnXGUd+44CSqtq8mDF5/guy1raoPJlu0cqmxePYiioE7/ZoJJKbvxzxeRSgMhbiPSWiD0HIhs6qkdglp9pilowvOdp+9ZVCuNPqpPx+/wlcVHzYHnMaNtuvlGjQenzWj0Rho9qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888085; c=relaxed/simple;
	bh=uK2/gvRRL0b4c2WMGGsIoEdHm9yUn3Q5FZDSBHx24KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJzilQM+rHpSbqZhod9se0lBeZd7XCm4HgKRqoMIHR/Kd7wxUI833aohyCiYwX3sT42wA1oEINpEL3svj+1M1e1ZWzay4ktIUZfI1Qws7askx+C4qCSYdOtD5GCQIgSSFEIBr4+tq67VSmEGDjJ9ANHn+Zu4LF8f0nHRZpgqmI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raLvK3ZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raLvK3ZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9590C4CEF1;
	Tue, 16 Dec 2025 12:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888085;
	bh=uK2/gvRRL0b4c2WMGGsIoEdHm9yUn3Q5FZDSBHx24KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raLvK3ZPgGpnNCZSAVf8o29aIBFDvse09I+MCxPH0HqemCyTugVumxTryq0EofbB1
	 2NZQenuT/CV6p4fm2IqOXBoZK6CQ9liu9U6VWZklSQH84mQ3VZpAzCqVoubKJhTaVx
	 rMLa1C+atgCGu2ndIiEDypC7rW/TRfQxBi4weWXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/614] RDMA/irdma: Remove doorbell elision logic
Date: Tue, 16 Dec 2025 12:13:15 +0100
Message-ID: <20251216111416.880944925@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

[ Upstream commit 62356fccb195f83d2ceafc787c5ba87ebbe5edfe ]

In some cases, this logic can result in doorbell writes being
skipped when they should not have been (at least on GEN3 HW),
so remove it. This also means that the mb() can be safely
downgraded to dma_wmb().

Fixes: 551c46edc769 ("RDMA/irdma: Add user/kernel shared libraries")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-9-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/puda.c |  1 -
 drivers/infiniband/hw/irdma/uk.c   | 31 ++----------------------------
 drivers/infiniband/hw/irdma/user.h |  1 -
 3 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/puda.c b/drivers/infiniband/hw/irdma/puda.c
index 694e5a9ed15d0..9cd14a50f1a93 100644
--- a/drivers/infiniband/hw/irdma/puda.c
+++ b/drivers/infiniband/hw/irdma/puda.c
@@ -685,7 +685,6 @@ static int irdma_puda_qp_create(struct irdma_puda_rsrc *rsrc)
 	ukqp->rq_size = rsrc->rq_size;
 
 	IRDMA_RING_INIT(ukqp->sq_ring, ukqp->sq_size);
-	IRDMA_RING_INIT(ukqp->initial_ring, ukqp->sq_size);
 	IRDMA_RING_INIT(ukqp->rq_ring, ukqp->rq_size);
 	ukqp->wqe_alloc_db = qp->pd->dev->wqe_alloc_db;
 
diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index ce1ae10c30fca..d5568584ad5e3 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -114,33 +114,8 @@ void irdma_clr_wqes(struct irdma_qp_uk *qp, u32 qp_wqe_idx)
  */
 void irdma_uk_qp_post_wr(struct irdma_qp_uk *qp)
 {
-	u64 temp;
-	u32 hw_sq_tail;
-	u32 sw_sq_head;
-
-	/* valid bit is written and loads completed before reading shadow */
-	mb();
-
-	/* read the doorbell shadow area */
-	get_64bit_val(qp->shadow_area, 0, &temp);
-
-	hw_sq_tail = (u32)FIELD_GET(IRDMA_QP_DBSA_HW_SQ_TAIL, temp);
-	sw_sq_head = IRDMA_RING_CURRENT_HEAD(qp->sq_ring);
-	if (sw_sq_head != qp->initial_ring.head) {
-		if (sw_sq_head != hw_sq_tail) {
-			if (sw_sq_head > qp->initial_ring.head) {
-				if (hw_sq_tail >= qp->initial_ring.head &&
-				    hw_sq_tail < sw_sq_head)
-					writel(qp->qp_id, qp->wqe_alloc_db);
-			} else {
-				if (hw_sq_tail >= qp->initial_ring.head ||
-				    hw_sq_tail < sw_sq_head)
-					writel(qp->qp_id, qp->wqe_alloc_db);
-			}
-		}
-	}
-
-	qp->initial_ring.head = qp->sq_ring.head;
+	dma_wmb();
+	writel(qp->qp_id, qp->wqe_alloc_db);
 }
 
 /**
@@ -1574,7 +1549,6 @@ static void irdma_setup_connection_wqes(struct irdma_qp_uk *qp,
 	qp->conn_wqes = move_cnt;
 	IRDMA_RING_MOVE_HEAD_BY_COUNT_NOCHECK(qp->sq_ring, move_cnt);
 	IRDMA_RING_MOVE_TAIL_BY_COUNT(qp->sq_ring, move_cnt);
-	IRDMA_RING_MOVE_HEAD_BY_COUNT_NOCHECK(qp->initial_ring, move_cnt);
 }
 
 /**
@@ -1719,7 +1693,6 @@ int irdma_uk_qp_init(struct irdma_qp_uk *qp, struct irdma_qp_uk_init_info *info)
 	qp->max_sq_frag_cnt = info->max_sq_frag_cnt;
 	sq_ring_size = qp->sq_size << info->sq_shift;
 	IRDMA_RING_INIT(qp->sq_ring, sq_ring_size);
-	IRDMA_RING_INIT(qp->initial_ring, sq_ring_size);
 	if (info->first_sq_wq) {
 		irdma_setup_connection_wqes(qp, info);
 		qp->swqe_polarity = 1;
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
index ab57f689827a0..aeebf768174ab 100644
--- a/drivers/infiniband/hw/irdma/user.h
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -456,7 +456,6 @@ struct irdma_srq_uk {
 	struct irdma_uk_attrs *uk_attrs;
 	__le64 *shadow_area;
 	struct irdma_ring srq_ring;
-	struct irdma_ring initial_ring;
 	u32 srq_id;
 	u32 srq_size;
 	u32 max_srq_frag_cnt;
-- 
2.51.0



