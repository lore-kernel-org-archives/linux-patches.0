Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6537C2F0673;
	Sat, 12 Sep 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230028; cv=none; b=lzC0Oie6wYBvurbgoz4qyFgLlN1kJXXIwQD8j6NqU7qQCep0vXAyU8gzBuC/hEiaaZiWXZ8YLOO6lnrbrjs+jsCtY5I+y5Z6nNqB0m7EMQQkZehoEGVwOUhmiz8mvVG8gz0heMiMlDO/LRs7Cciu5YgRbGL3tVJsQB9u27WKYgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230028; c=relaxed/simple;
	bh=owhD6b0mMG5CgDcAh2hexlgZFqglM+owo11nFdg/apo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2Q/vtJkKqhlhYfbVhd0RVwGG027b20iKjMdDiN2ztah1G3eywrtilnmpegND4avqQkYPT/mJ7ZHjGc+8eOdVFniSxrOP3P9j4qDTbS609M3SJ+v6LZxD6Ou7tkqBriTOGSTziQXv1Dq2YNmfSbI/cZGygLt4Jw5gUnVpMcTV+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJR5eJtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJR5eJtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C011F1F000FF;
	Sat, 12 Sep 2026 16:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230023;
	bh=5lm0NduEmdCylPndF8abkK+VL6WMM+gQZ6fU92FXEwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJR5eJtNpXLkHvOeCTCZdk0HVwXEmvXBZv+5WyAjHFoA0LOHOcoxnBB0dTlObZDU0
	 LkuoQ1H7ugSZU2D2v7kkg/sgFVRJpp5aT2oY8OEAJkPbHSg2IQxXHSIsqpu13n0u8C
	 qSzRD0c3Y3omEP08366gvUD3tZuEJ9cJyBZp7+xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0692/1191] RDMA/core: Add driver APIs pre_destroy_cq() and post_destroy_cq()
Date: Sat, 12 Sep 2026 08:57:00 +0200
Message-ID: <20260912065603.803726240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a70876a0a2312..584537c71545c 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -317,13 +317,18 @@ EXPORT_SYMBOL(__ib_alloc_cq_any);
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
@@ -340,7 +345,10 @@ void ib_free_cq(struct ib_cq *cq)
 
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
index ec391287d61d4..d7fc76659ee2c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2735,8 +2735,10 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
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
index 6f3a2aaccd445..8cf5ee31b8772 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2476,6 +2476,15 @@ struct ib_device_ops {
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



