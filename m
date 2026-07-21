Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB2F46EC78;
	Tue, 21 Jul 2026 18:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659792; cv=none; b=UQ3dVoqxywBzhcebVtXa+5x5u4XEOb0EXl4l/zW+9Higo4Omw9il1QRpu7q4fCQ5oj4OoVtqdcIn/YPfvV9Oa4faQeb5r9YtiMbIgXVwKyDf87F3DTO407DpgfSkj7XglMzFIqDnICZiCRFZ3fj2UvMp3H+fL869c5uNbtl7+fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659792; c=relaxed/simple;
	bh=d/R2UgKz9jBY0nkKfbujYGB1Za5AN42MlvrMxiwTEX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCGbfH35K5VHK6HNDpmIHoqCznL1ZA32hJ1XLpu2ecHu5ppNPdZYZE/i1uDjkD9MwMhXeU1bWDMmAhSfjHcQXpZUkUC0GQi3QkdiCYmV4v+Qz51Uln5MY8C5G6DLudieMUDs6KQw/ch9Zz31zGF83KFTnQLYAxcvYmyh5BTgIsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbTpFdUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbTpFdUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11051F000E9;
	Tue, 21 Jul 2026 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659791;
	bh=9Im/Fl2W7SOPOupQnUQbraF0TDSj6GICSbrUNxdYC0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbTpFdUnLUEqKN/7PuaIhGk7mV1zTaareR6pVvISLk5nnEdqWTrD9jPf3VyjE9HwT
	 8m5tgp/cv5cMaeXEpGF3yPAyabKHbUN509k65msFZhNSzCPyL0OlC/XNi47B8//BFY
	 mupPOI+cp/ZtneT3hZVtm8//DkCrljcXlxdUTFQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0692/2077] RDMA/core: Fix FRMR handle leak on push failure
Date: Tue, 21 Jul 2026 17:06:05 +0200
Message-ID: <20260721152609.115884673@linuxfoundation.org>
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

[ Upstream commit 8c76126b866649d8e8acc09a06f2b03b6ff88900 ]

Failure to push a handle to the pool, caused by ENOMEM on queue page
allocation, will trigger missing in_use counter update, skewing pool
state indefinitely.
Fix that by moving the handling of handle destruction in such case
into the FRMR code, ensuring the handle is either pushed to the pool
or destroyed inside the same function.

Adjust mlx5_ib call site accordingly.

Fixes: ce5df0b891ed ("IB/core: Introduce FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-8-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/frmr_pools.c | 19 +++++++++++--------
 drivers/infiniband/hw/mlx5/mr.c      |  5 +++--
 include/rdma/frmr_pools.h            |  2 +-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/frmr_pools.c b/drivers/infiniband/core/frmr_pools.c
index 892aedfe03bed4..e214a8273df844 100644
--- a/drivers/infiniband/core/frmr_pools.c
+++ b/drivers/infiniband/core/frmr_pools.c
@@ -549,9 +549,8 @@ EXPORT_SYMBOL(ib_frmr_pool_pop);
  * @device: The device to push the FRMR handle to.
  * @mr: The MR containing the FRMR handle to push back to the pool.
  *
- * Returns 0 on success, negative error code on failure.
  */
-int ib_frmr_pool_push(struct ib_device *device, struct ib_mr *mr)
+void ib_frmr_pool_push(struct ib_device *device, struct ib_mr *mr)
 {
 	struct ib_frmr_pool *pool = mr->frmr.pool;
 	struct ib_frmr_pools *pools = device->frmr_pools;
@@ -559,19 +558,23 @@ int ib_frmr_pool_push(struct ib_device *device, struct ib_mr *mr)
 	int ret;
 
 	spin_lock(&pool->lock);
+	pool->in_use--;
+	ret = push_handle_to_queue_locked(&pool->queue, mr->frmr.handle);
+
 	/* Schedule aging every time an empty pool becomes non-empty */
-	if (pool->queue.ci == 0)
+	if (!ret && pool->queue.ci == 1)
 		schedule_aging = true;
-	ret = push_handle_to_queue_locked(&pool->queue, mr->frmr.handle);
-	if (ret == 0)
-		pool->in_use--;
 
 	spin_unlock(&pool->lock);
 
-	if (ret == 0 && schedule_aging)
+	if (ret) {
+		pools->pool_ops->destroy_frmrs(device, &mr->frmr.handle, 1);
+		return;
+	}
+
+	if (schedule_aging)
 		queue_delayed_work(pools->aging_wq, &pool->aging_work,
 			secs_to_jiffies(READ_ONCE(pools->aging_period_sec)));
 
-	return ret;
 }
 EXPORT_SYMBOL(ib_frmr_pool_push);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7fbb01371f1f77..723594efa094e6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1398,9 +1398,10 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 	bool is_odp = is_odp_mr(mr);
 	int ret;
 
-	if (mr->ibmr.frmr.pool && !mlx5_umr_revoke_mr_with_lock(mr) &&
-	    !ib_frmr_pool_push(mr->ibmr.device, &mr->ibmr))
+	if (mr->ibmr.frmr.pool && !mlx5_umr_revoke_mr_with_lock(mr)) {
+		ib_frmr_pool_push(mr->ibmr.device, &mr->ibmr);
 		return 0;
+	}
 
 	if (is_odp)
 		mutex_lock(&to_ib_umem_odp(mr->umem)->umem_mutex);
diff --git a/include/rdma/frmr_pools.h b/include/rdma/frmr_pools.h
index af1b88801fa469..5b57bafa363669 100644
--- a/include/rdma/frmr_pools.h
+++ b/include/rdma/frmr_pools.h
@@ -34,6 +34,6 @@ int ib_frmr_pools_init(struct ib_device *device,
 		       const struct ib_frmr_pool_ops *pool_ops);
 void ib_frmr_pools_cleanup(struct ib_device *device);
 int ib_frmr_pool_pop(struct ib_device *device, struct ib_mr *mr);
-int ib_frmr_pool_push(struct ib_device *device, struct ib_mr *mr);
+void ib_frmr_pool_push(struct ib_device *device, struct ib_mr *mr);
 
 #endif /* FRMR_POOLS_H */
-- 
2.53.0



