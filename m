Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3C1EB5FD;
	Sat, 12 Sep 2026 07:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197548; cv=none; b=BfK8th+LEjQY7XOfjG9LOpLHzTmkEupejpcWtHTCgftv00nI/I2ein5QM8JriKzFtkGRC2x6hKz5hPYAIct66urNRiJKdkrcCsqnWnhirpkGk6gLi4rVDNxXWqlKbt7ox+jV/fyNr0pMF5xdd54ywZ4D0e3Y8HyWhmmyLNbyCk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197548; c=relaxed/simple;
	bh=q/jY7KfOQte/URBBXJufsldEnZUPLv8K3/uw8fEe4HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdXDtOaRZYm8i8sk6K5Ss/ZGMDPtzeukcrNN19RSPfJm8bMDpQ86yZxSrRiqJRSj4WqFnzp6h+ujuQNd5ygDOpXx/ZnBqU+0DPG+2PaGaqR0w8TVbyVaZ7z+FCDIhBRLWno7J6knNaZM+KhmXAz1shsuIoDY4O64oy7rDz8yQa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjSqUodR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjSqUodR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5294D1F000FF;
	Sat, 12 Sep 2026 07:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197546;
	bh=e2Z+GPMJexkb9DIDUgwmc49IAqUHul9zNeS8KlTLngc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjSqUodR4oSRSmqPAUs1p5ZCzC3ssvP0NMcW+UQTg76s2HoTfdUT8RGLsO/s6P6fX
	 xhrgx2hvuj5UrNH2uIQaZ6bYiLLCGFscrn30sBWLm6AgMCkpv/9DBay+uMF6a0Y8Tw
	 X9eWJe+q9PS7MNF7j4j7iGIcv/DNtpFfqA2PBnf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0198/1815] RDMA/irdma: Add a refcount to track user ring MR associations
Date: Sat, 12 Sep 2026 08:32:28 +0200
Message-ID: <20260912065653.653451074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit a7d0a6b58256a77566e9088a99e1594bf35821ec ]

User QP/CQ/SRQ rings are registered with the normal reg_mr
mechanism prior to creating the actual QP/CQ/SRQ object. In
order to prevent userspace from deregistering these special MRs
while the child object still exists, a refcount will be used.

This commit adds the refcount and logic to reject a dereg_mr
with active references. Subsequent commits will add logic to
bump this refcount when the user QP/CQ/SRQ objects are created.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260618201458.875740-3-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f67d8a08f60c ("RDMA/irdma: Add refcounting to user ring MRs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 21 +++++++++++++++++----
 drivers/infiniband/hw/irdma/verbs.h |  1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index e81a7502a457c..b4c91349bcd87 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3362,6 +3362,7 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
 	if (!iwmr)
 		return ERR_PTR(-ENOMEM);
 
+	refcount_set(&iwmr->user_ring_refs, 1);
 	iwpbl = &iwmr->iwpbl;
 	iwpbl->iwmr = iwmr;
 	iwmr->region = region;
@@ -3929,13 +3930,16 @@ static struct ib_mr *irdma_get_dma_mr(struct ib_pd *pd, int acc)
  * irdma_del_memlist - Deleting pbl list entries for CQ/QP
  * @iwmr: iwmr for IB's user page addresses
  * @ucontext: ptr to user context
+ *
+ * Return: True if the MR is currently in-use by a QP/CQ/SRQ ring.
  */
-static void irdma_del_memlist(struct irdma_mr *iwmr,
+static bool irdma_del_memlist(struct irdma_mr *iwmr,
 			      struct irdma_ucontext *ucontext)
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	unsigned long flags;
 	spinlock_t *lock;
+	bool in_use = false;
 
 	switch (iwmr->type) {
 	case IRDMA_MEMREG_TYPE_CQ:
@@ -3948,15 +3952,19 @@ static void irdma_del_memlist(struct irdma_mr *iwmr,
 		lock = &ucontext->srq_reg_mem_list_lock;
 		break;
 	default:
-		return;
+		return false;
 	}
 
 	spin_lock_irqsave(lock, flags);
-	if (iwpbl->on_list) {
+	if (!refcount_dec_if_one(&iwmr->user_ring_refs)) {
+		in_use = true;
+	} else if (iwpbl->on_list) {
 		iwpbl->on_list = false;
 		list_del(&iwpbl->list);
 	}
 	spin_unlock_irqrestore(lock, flags);
+
+	return in_use;
 }
 
 /**
@@ -3979,7 +3987,12 @@ static int irdma_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 			ucontext = rdma_udata_to_drv_context(udata,
 						struct irdma_ucontext,
 						ibucontext);
-			irdma_del_memlist(iwmr, ucontext);
+
+			/* Do not allow the MR to be unpinned if it is still
+			 * backing a user ring.
+			 */
+			if (irdma_del_memlist(iwmr, ucontext))
+				return -EBUSY;
 		}
 		goto done;
 	}
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index 289ebc9b23ca7..fbd487dbebfb9 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -120,6 +120,7 @@ struct irdma_mr {
 	u64 len;
 	u64 pgaddrmem[IRDMA_MAX_SAVED_PHY_PGADDR];
 	struct irdma_pbl iwpbl;
+	refcount_t user_ring_refs;
 };
 
 struct irdma_srq {
-- 
2.53.0



