Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D771C3AFCEC;
	Sat, 12 Sep 2026 18:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239008; cv=none; b=rMet1OCA1g0b/7hmqgNOAHwTOH6NN7Px9THKaTNC7QFHsnAzyB5YYPwgyth0KjM6OeAKMKY5Swmpeamsg9DVWvY6ctT9x0Kh3lxuqDpocuHHaRT/bxQoLo0uH1Fp+3UEYorFZh+i7xvSrjuVoclY0SxRVS4ye3d51QuTiC7V12w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239008; c=relaxed/simple;
	bh=4AdaMXWoUyXO8Yo4rBB9CvLtpdexEDY0kJS1KikYBAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujlyr5b5tMyd7gXH4qiQh5ceGD9XstEAPVfdhyYFHUwZCsDzyhnRne+Ov2ep9ttZwaInLpxEXCB+naVbiutnbMVn0U35kZ1wDM2MEwKl8Xh7C2MuyLebTHClasKDLkQI8WuCd4VVTczDT1BpoxUeEqxPQrmvyWupgRpxN1AjKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMZ7FCvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMZ7FCvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDACD1F000FF;
	Sat, 12 Sep 2026 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239006;
	bh=M+teyustctr3kdMf2aHjvEgCjBUsGPwaRU2GkhXGmfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMZ7FCvdAuXKvsYec1D0tF28KN5O0/648iaUPZMabLn7rSWeZ6bGegZheB0ooxS+n
	 QlFbzQC3qPKDPwpWDodLnDo3dbjuI7sGG2u9WANyysr4CRUQMd5HekmUgL2g3gjNfa
	 eya39SdfbvsG9pVARIrUNYTSflDF8vx4FKDzAM1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 575/935] RDMA/core: Add driver APIs pre_destroy_cq() and post_destroy_cq()
Date: Sat, 12 Sep 2026 09:00:05 +0200
Message-ID: <20260912065540.028418862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 5a2a5b65d5d67279be9e1f0e4b9baf39ee594cb1 ]

Currently in ib_free_cq, it disables IRQ or cancel the CQ work before
driver destroy_cq. This isn't good as a new IRQ or a CQ work can be
submitted immediately after disabling IRQ or canceling CQ work, which
may run concurrently with destroy_cq and cause crashes.
The right flow should be:
 1. Driver disables CQ to make sure no new CQ event will be submitted;
 2. Disables IRQ or Cancels CQ work in core layer, to make sure no CQ
    polling work is running;
 3. Free all resources to destroy the CQ.

This patch adds 2 driver APIs:
- pre_destroy_cq(): Disable a CQ to prevent it from generating any new
  work completions, but not free any kernel resources;
- post_destroy_cq(): Free all kernel resources.

In ib_free_cq, the IRQ is disabled or CQ work is canceled after
pre_destroy_cq, and before post_destroy_cq.

Fixes: 14d3a3b2498e ("IB: add a proper completion queue abstraction")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://patch.msgid.link/b5f7ae3d75f44a3e15ff3f4eb2bbdea13e06b97f.1750062328.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 29dc2f8e1c97 ("RDMA/core: Fix potential use after free in ib_free_cq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cq.c     | 12 ++++++++++--
 drivers/infiniband/core/device.c |  2 ++
 include/rdma/ib_verbs.h          |  9 +++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 433b426729d4c..aa499d722ae26 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -318,13 +318,18 @@ EXPORT_SYMBOL(__ib_alloc_cq_any);
  */
 void ib_free_cq(struct ib_cq *cq)
 {
-	int ret;
+	int ret = 0;
 
 	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
 		return;
 	if (WARN_ON_ONCE(cq->cqe_used))
 		return;
 
+	if (cq->device->ops.pre_destroy_cq) {
+		ret = cq->device->ops.pre_destroy_cq(cq);
+		WARN_ONCE(ret, "Disable of kernel CQ shouldn't fail");
+	}
+
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
 		break;
@@ -341,7 +346,10 @@ void ib_free_cq(struct ib_cq *cq)
 
 	rdma_dim_destroy(cq);
 	trace_cq_free(cq);
-	ret = cq->device->ops.destroy_cq(cq, NULL);
+	if (cq->device->ops.post_destroy_cq)
+		cq->device->ops.post_destroy_cq(cq);
+	else
+		ret = cq->device->ops.destroy_cq(cq, NULL);
 	WARN_ONCE(ret, "Destroy of kernel CQ shouldn't fail");
 	rdma_restrack_del(&cq->res);
 	kfree(cq->wc);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a3339b710f461..6eb1930e0ca6b 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2736,8 +2736,10 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, modify_srq);
 	SET_DEVICE_OP(dev_ops, modify_wq);
 	SET_DEVICE_OP(dev_ops, peek_cq);
+	SET_DEVICE_OP(dev_ops, pre_destroy_cq);
 	SET_DEVICE_OP(dev_ops, poll_cq);
 	SET_DEVICE_OP(dev_ops, port_groups);
+	SET_DEVICE_OP(dev_ops, post_destroy_cq);
 	SET_DEVICE_OP(dev_ops, post_recv);
 	SET_DEVICE_OP(dev_ops, post_send);
 	SET_DEVICE_OP(dev_ops, post_srq_recv);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e7f1e7a87bd1f..e101838aa6778 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2452,6 +2452,15 @@ struct ib_device_ops {
 	int (*modify_cq)(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 	int (*destroy_cq)(struct ib_cq *cq, struct ib_udata *udata);
 	int (*resize_cq)(struct ib_cq *cq, int cqe, struct ib_udata *udata);
+	/**
+	 * pre_destroy_cq - Prevent a cq from generating any new work
+	 * completions, but not free any kernel resources
+	 */
+	int (*pre_destroy_cq)(struct ib_cq *cq);
+	/**
+	 * post_destroy_cq - Free all kernel resources
+	 */
+	void (*post_destroy_cq)(struct ib_cq *cq);
 	struct ib_mr *(*get_dma_mr)(struct ib_pd *pd, int mr_access_flags);
 	struct ib_mr *(*reg_user_mr)(struct ib_pd *pd, u64 start, u64 length,
 				     u64 virt_addr, int mr_access_flags,
-- 
2.53.0



