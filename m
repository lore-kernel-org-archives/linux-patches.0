Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6AD2417D9;
	Tue, 21 Jul 2026 18:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659742; cv=none; b=jXeDzF8olQ3Dl0HS1sXR/q+IffUH+JX8njS4xTftr2Nw4VUva/3Zk/xWGqP4qiPsDmcXTc001PFbB47WanIAOFdvJSHbyWcb8p9M80M1oTS2GmykBefazuQAHehy/m7ZYJrwCZkvpLXHDX1dTWbdGFEadg0HuwgluPvp37mBCVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659742; c=relaxed/simple;
	bh=D9FBclbJIxPnXH2uGrg7Pn5aWS02Y+PS2zfdIacHuuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/fJuSZLB6MPv8jjdXB9UhfSnvZQSLOuZZr0oOpsLdynlruybpWUTdQXfeyHSiQdk84HGzYPtgVQHkmPEUs7KnM3mtVDzRI8/meEuPE0/TpA7LJ/I3CyaX9zLc7xmEfN+YRMZJyxGoM1vadsigMeQlVpnCOWzJLFQEOX/MqDwOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvpGD+ER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvpGD+ER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98731F000E9;
	Tue, 21 Jul 2026 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659741;
	bh=IIsKhlx9iX8YtjyM7LKSeD814YtvZh1tgjfuJJUnFDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvpGD+ER6MoGNtYXObO01hdsfvyerCMTSv2oOe6kzFuSqByLQ8EKYikKgsrbXdFTV
	 8Exixsbo/yrRZboR8oEUAmY3ADDrPmfHBpwlGgjgEk2PXto8ntTEZqD1jhz704xWz8
	 rrbatp1+zU8n5Frkllx8B6yRmYa5/MPFeK4UA2HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0689/2077] RDMA/core: Fix FRMR aging push to queue error flow
Date: Tue, 21 Jul 2026 17:06:02 +0200
Message-ID: <20260721152609.043580318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit c6936506ed556ce3ccad36ab999baf2764dd7d25 ]

Aging pools with pinned handles requires moving handles from the
active queue to a non-empty inactive queue that might fail on new page
allocation, we are currently not handling the fault and leaking any mkey
that fails the push.

Fix by Introducing push_queue_to_queue_locked() that fills the
destination's partial tail page from the source and then splices the
remaining source pages onto the destination, performing no allocation.

Replace the per-handle move loop in age_pinned_pool() and the
open-coded splice in pool_aging_work() with calls to the helper.
As the helper cannot fail under memory pressure, removing a class of
GFP_ATOMIC allocations under the pool lock and simplifying the error
flow.

Fixes: 020d189d16a6 ("RDMA/core: Add pinned handles to FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-5-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/frmr_pools.c | 53 ++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/frmr_pools.c b/drivers/infiniband/core/frmr_pools.c
index 6170466ea9581a..927642c06f3a4c 100644
--- a/drivers/infiniband/core/frmr_pools.c
+++ b/drivers/infiniband/core/frmr_pools.c
@@ -97,13 +97,44 @@ static void destroy_all_handles_in_queue(struct ib_device *device,
 	}
 }
 
+/*
+ * Bulk-move all handles from @src into @dst without allocating new pages.
+ * If @dst has a partial tail page, fill it handle-by-handle from @src first
+ * to preserve the invariant that only the tail page is partial, then splice
+ * the remaining @src pages onto @dst. On return @src is empty.
+ *
+ * Caller must hold the lock protecting both queues.
+ */
+static void splice_frmr_queue_locked(struct frmr_queue *dst,
+				     struct frmr_queue *src)
+{
+	u32 free_in_tail = dst->ci % NUM_HANDLES_PER_PAGE;
+	u32 handle;
+
+	if (free_in_tail) {
+		free_in_tail = NUM_HANDLES_PER_PAGE - free_in_tail;
+		while (free_in_tail && src->ci) {
+			handle = pop_handle_from_queue_locked(src);
+			push_handle_to_queue_locked(dst, handle);
+			free_in_tail--;
+		}
+	}
+
+	if (src->ci > 0) {
+		list_splice_tail_init(&src->pages_list, &dst->pages_list);
+		dst->num_pages += src->num_pages;
+		dst->ci += src->ci;
+		src->num_pages = 0;
+		src->ci = 0;
+	}
+}
+
 static bool age_pinned_pool(struct ib_device *device, struct ib_frmr_pool *pool)
 {
 	struct ib_frmr_pools *pools = device->frmr_pools;
 	u32 total, to_destroy, destroyed = 0;
 	bool has_work = false;
 	u32 *handles;
-	u32 handle;
 
 	spin_lock(&pool->lock);
 	total = pool->queue.ci + pool->inactive_queue.ci + pool->in_use;
@@ -112,7 +143,7 @@ static bool age_pinned_pool(struct ib_device *device, struct ib_frmr_pool *pool)
 		return false;
 	}
 
-	to_destroy = total - pool->pinned_handles;
+	to_destroy = min(total - pool->pinned_handles, pool->inactive_queue.ci);
 
 	handles = kcalloc(to_destroy, sizeof(*handles), GFP_ATOMIC);
 	if (!handles) {
@@ -121,15 +152,13 @@ static bool age_pinned_pool(struct ib_device *device, struct ib_frmr_pool *pool)
 	}
 
 	/* Destroy all excess handles in the inactive queue */
-	while (pool->inactive_queue.ci && destroyed < to_destroy) {
-		handles[destroyed++] = pop_handle_from_queue_locked(
+	for (; destroyed < to_destroy; destroyed++)
+		handles[destroyed] = pop_handle_from_queue_locked(
 			&pool->inactive_queue);
-	}
 
 	/* Move all handles from regular queue to inactive queue */
-	while (pool->queue.ci) {
-		handle = pop_handle_from_queue_locked(&pool->queue);
-		push_handle_to_queue_locked(&pool->inactive_queue, handle);
+	if (pool->queue.ci > 0) {
+		splice_frmr_queue_locked(&pool->inactive_queue, &pool->queue);
 		has_work = true;
 	}
 
@@ -158,13 +187,7 @@ static void pool_aging_work(struct work_struct *work)
 	/* Move all pages from regular queue to inactive queue */
 	spin_lock(&pool->lock);
 	if (pool->queue.ci > 0) {
-		list_splice_tail_init(&pool->queue.pages_list,
-				      &pool->inactive_queue.pages_list);
-		pool->inactive_queue.num_pages = pool->queue.num_pages;
-		pool->inactive_queue.ci = pool->queue.ci;
-
-		pool->queue.num_pages = 0;
-		pool->queue.ci = 0;
+		splice_frmr_queue_locked(&pool->inactive_queue, &pool->queue);
 		has_work = true;
 	}
 	spin_unlock(&pool->lock);
-- 
2.53.0



