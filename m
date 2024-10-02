Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3C71D0956;
	Wed,  2 Oct 2024 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878394; cv=none; b=rD7kaalhcAnnZxZxGj7HqsxXNNQJW3Jj2nyesRMoFBvjoAEiHQRq/VdyklUvvW+eecyHJQlF4ccs0aRY6m22SX2WYxmARpRFzG6PXm5Myrk3+BXSvfCU6tESLovDkMt7tBzvS5SRc0kRKG5ZQGCHY6ofY82YjBVf+bDz2zJHs14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878394; c=relaxed/simple;
	bh=4LlQdoBT8g9Q25YSg24t32G0Cec5DVVRFR5rlmQ+new=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osQ3lcvwtG1LhIZr27Fm+YTyzrPUFKcQffUCG9FVdXRL67VJgl07L5jmuYwHhvppCvQitWoSgGF3jEH6BYFQbbc7reVZGG78ApmRWswCQb3j3yD8XGcmO9BvNMpMIB2uBKtyLHt97V0tva6ZaWs9HvRaAScIuVOZUespjGp9+AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fZv1Eex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fZv1Eex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DBDC4CEC2;
	Wed,  2 Oct 2024 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878394;
	bh=4LlQdoBT8g9Q25YSg24t32G0Cec5DVVRFR5rlmQ+new=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fZv1EexknXzLkyH8CqwS+z78mPcZUlphl0gfPRizImXZuElGzPjzdAR27Ako+fyL
	 VOnbGGdOcpLo+3fugevJBcJo6EJXqai2CjfJB7hwQd/II9gT+q6ADrxYousfGl60nQ
	 HmhU8xw5EjDCHhXb0FR8d6hD46KZwsWXwAFc62fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 371/634] RDMA/mlx5: Fix MR cache temp entries cleanup
Date: Wed,  2 Oct 2024 14:57:51 +0200
Message-ID: <20241002125825.742237020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 7ebb00cea49db641b458edef0ede389f7004821d ]

Fix the cleanup of the temp cache entries that are dynamically created
in the MR cache.

The cleanup of the temp cache entries is currently scheduled only when a
new entry is created. Since in the cleanup of the entries only the mkeys
are destroyed and the cache entry stays in the cache, subsequent
registrations might reuse the entry and it will eventually be filled with
new mkeys without cleanup ever getting scheduled again.

On workloads that register and deregister MRs with a wide range of
properties we see the cache ends up holding many cache entries, each
holding the max number of mkeys that were ever used through it.

Additionally, as the cleanup work is scheduled to run over the whole
cache, any mkey that is returned to the cache after the cleanup was
scheduled will be held for less than the intended 30 seconds timeout.

Solve both issues by dropping the existing remove_ent_work and reusing
the existing per-entry work to also handle the temp entries cleanup.

Schedule the work to run with a 30 seconds delay every time we push an
mkey to a clean temp entry.
This ensures the cleanup runs on each entry only 30 seconds after the
first mkey was pushed to an empty entry.

As we have already been distinguishing between persistent and temp entries
when scheduling the cache_work_func, it is not being scheduled in any
other flows for the temp entries.

Another benefit from moving to a per-entry cleanup is we now not
required to hold the rb_tree mutex, thus enabling other flow to run
concurrently.

Fixes: dd1b913fb0d0 ("RDMA/mlx5: Cache all user cacheable mkeys on dereg MR flow")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/e4fa4bb03bebf20dceae320f26816cd2dde23a26.1725362530.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 82 +++++++++++-----------------
 2 files changed, 32 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f9abdca3493aa..0b2f18c34ee5e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -795,6 +795,7 @@ struct mlx5_cache_ent {
 	u8 is_tmp:1;
 	u8 disabled:1;
 	u8 fill_to_high_water:1;
+	u8 tmp_cleanup_scheduled:1;
 
 	/*
 	 * - limit is the low water mark for stored mkeys, 2* limit is the
@@ -826,7 +827,6 @@ struct mlx5_mkey_cache {
 	struct mutex		rb_lock;
 	struct dentry		*fs_root;
 	unsigned long		last_add;
-	struct delayed_work	remove_ent_dwork;
 };
 
 struct mlx5_ib_port_resources {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 842e218cd0b5e..59bde614f061f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -528,6 +528,21 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 	}
 }
 
+static void clean_keys(struct mlx5_ib_dev *dev, struct mlx5_cache_ent *ent)
+{
+	u32 mkey;
+
+	spin_lock_irq(&ent->mkeys_queue.lock);
+	while (ent->mkeys_queue.ci) {
+		mkey = pop_mkey_locked(ent);
+		spin_unlock_irq(&ent->mkeys_queue.lock);
+		mlx5_core_destroy_mkey(dev->mdev, mkey);
+		spin_lock_irq(&ent->mkeys_queue.lock);
+	}
+	ent->tmp_cleanup_scheduled = false;
+	spin_unlock_irq(&ent->mkeys_queue.lock);
+}
+
 static void __cache_work_func(struct mlx5_cache_ent *ent)
 {
 	struct mlx5_ib_dev *dev = ent->dev;
@@ -599,7 +614,11 @@ static void delayed_cache_work_func(struct work_struct *work)
 	struct mlx5_cache_ent *ent;
 
 	ent = container_of(work, struct mlx5_cache_ent, dwork.work);
-	__cache_work_func(ent);
+	/* temp entries are never filled, only cleaned */
+	if (ent->is_tmp)
+		clean_keys(ent->dev, ent);
+	else
+		__cache_work_func(ent);
 }
 
 static int cache_ent_key_cmp(struct mlx5r_cache_rb_key key1,
@@ -775,20 +794,6 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	return _mlx5_mr_cache_alloc(dev, ent, access_flags);
 }
 
-static void clean_keys(struct mlx5_ib_dev *dev, struct mlx5_cache_ent *ent)
-{
-	u32 mkey;
-
-	spin_lock_irq(&ent->mkeys_queue.lock);
-	while (ent->mkeys_queue.ci) {
-		mkey = pop_mkey_locked(ent);
-		spin_unlock_irq(&ent->mkeys_queue.lock);
-		mlx5_core_destroy_mkey(dev->mdev, mkey);
-		spin_lock_irq(&ent->mkeys_queue.lock);
-	}
-	spin_unlock_irq(&ent->mkeys_queue.lock);
-}
-
 static void mlx5_mkey_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (!mlx5_debugfs_root || dev->is_rep)
@@ -901,10 +906,6 @@ mlx5r_cache_create_ent_locked(struct mlx5_ib_dev *dev,
 			ent->limit = 0;
 
 		mlx5_mkey_cache_debugfs_add_ent(dev, ent);
-	} else {
-		mod_delayed_work(ent->dev->cache.wq,
-				 &ent->dev->cache.remove_ent_dwork,
-				 msecs_to_jiffies(30 * 1000));
 	}
 
 	return ent;
@@ -915,35 +916,6 @@ mlx5r_cache_create_ent_locked(struct mlx5_ib_dev *dev,
 	return ERR_PTR(ret);
 }
 
-static void remove_ent_work_func(struct work_struct *work)
-{
-	struct mlx5_mkey_cache *cache;
-	struct mlx5_cache_ent *ent;
-	struct rb_node *cur;
-
-	cache = container_of(work, struct mlx5_mkey_cache,
-			     remove_ent_dwork.work);
-	mutex_lock(&cache->rb_lock);
-	cur = rb_last(&cache->rb_root);
-	while (cur) {
-		ent = rb_entry(cur, struct mlx5_cache_ent, node);
-		cur = rb_prev(cur);
-		mutex_unlock(&cache->rb_lock);
-
-		spin_lock_irq(&ent->mkeys_queue.lock);
-		if (!ent->is_tmp) {
-			spin_unlock_irq(&ent->mkeys_queue.lock);
-			mutex_lock(&cache->rb_lock);
-			continue;
-		}
-		spin_unlock_irq(&ent->mkeys_queue.lock);
-
-		clean_keys(ent->dev, ent);
-		mutex_lock(&cache->rb_lock);
-	}
-	mutex_unlock(&cache->rb_lock);
-}
-
 int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_mkey_cache *cache = &dev->cache;
@@ -959,7 +931,6 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 	mutex_init(&dev->slow_path_mutex);
 	mutex_init(&dev->cache.rb_lock);
 	dev->cache.rb_root = RB_ROOT;
-	INIT_DELAYED_WORK(&dev->cache.remove_ent_dwork, remove_ent_work_func);
 	cache->wq = alloc_ordered_workqueue("mkey_cache", WQ_MEM_RECLAIM);
 	if (!cache->wq) {
 		mlx5_ib_warn(dev, "failed to create work queue\n");
@@ -1010,7 +981,6 @@ void mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
 		return;
 
 	mutex_lock(&dev->cache.rb_lock);
-	cancel_delayed_work(&dev->cache.remove_ent_dwork);
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		ent = rb_entry(node, struct mlx5_cache_ent, node);
 		spin_lock_irq(&ent->mkeys_queue.lock);
@@ -1852,8 +1822,18 @@ static int mlx5_revoke_mr(struct mlx5_ib_mr *mr)
 	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
 	struct mlx5_cache_ent *ent = mr->mmkey.cache_ent;
 
-	if (mr->mmkey.cacheable && !mlx5r_umr_revoke_mr(mr) && !cache_ent_find_and_store(dev, mr))
+	if (mr->mmkey.cacheable && !mlx5r_umr_revoke_mr(mr) && !cache_ent_find_and_store(dev, mr)) {
+		ent = mr->mmkey.cache_ent;
+		/* upon storing to a clean temp entry - schedule its cleanup */
+		spin_lock_irq(&ent->mkeys_queue.lock);
+		if (ent->is_tmp && !ent->tmp_cleanup_scheduled) {
+			mod_delayed_work(ent->dev->cache.wq, &ent->dwork,
+					 msecs_to_jiffies(30 * 1000));
+			ent->tmp_cleanup_scheduled = true;
+		}
+		spin_unlock_irq(&ent->mkeys_queue.lock);
 		return 0;
+	}
 
 	if (ent) {
 		spin_lock_irq(&ent->mkeys_queue.lock);
-- 
2.43.0



