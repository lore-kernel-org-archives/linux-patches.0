Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7488E481DD;
	Wed,  5 Mar 2025 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197332; cv=none; b=Rr2dhnazbusNM5ByYYH2tnZewd6jeiH7vfq9IEOYpsYHY9Cp3Vcj5C99DYLlyBLCtSaOrArpFvewbIEx//6p4Ibsfk643ZXJjKzZSKg4PSsrTq5p0XQYyrt8znmy9uWcvyPi2wgBUQT7o96+a7XpSmafEvYDKnkx3tdez58rjz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197332; c=relaxed/simple;
	bh=WSXlIedrcj0W75CDxoxJXS08f0zsBJ/vBSnI6VcRtVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cN4UQCEIL1+55kvwQ8rGmHy7Y/jW88VMXLLtbtWXB07bEIctHO6XT7sb9qn18LBYLetBYm2C2wORVAk8dzqwhzSNi9WN6F1IrH7Qe72W6KC4ICzF9LvQ7KIAysxM3mfn63KWQvhdDwY+4+YkyhHhtbxzUnPuaVrlt7pZcoJEKzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut6ZYLiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut6ZYLiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C21C4CED1;
	Wed,  5 Mar 2025 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197332;
	bh=WSXlIedrcj0W75CDxoxJXS08f0zsBJ/vBSnI6VcRtVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ut6ZYLiA5n4GR73JbSMIlVghK6t4AYbS1FtQRq25jnXZbZ0+st05VmQwjpGCgMu6k
	 nbu1kglENmMW+eVdx2JGBGBPPOATHAm/2LUi+zzVBlbHys80Q72TqL0atH+rlW0x5w
	 bX5nW7qIuDmYEsYrrPu6nC3xQ3bXIhEOTV2GGDd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/176] RDMA/mlx5: Add work to remove temporary entries from the cache
Date: Wed,  5 Mar 2025 18:47:51 +0100
Message-ID: <20250305174509.559609622@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 627122280c878cf5d3cda2d2c5a0a8f6a7e35cb7 ]

The non-cache mkeys are stored in the cache only to shorten restarting
application time. Don't store them longer than needed.

Configure cache entries that store non-cache MRs as temporary entries.  If
30 seconds have passed and no user reclaimed the temporarily cached mkeys,
an asynchronous work will destroy the mkeys entries.

Link: https://lore.kernel.org/r/20230125222807.6921-7-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d97505baea64 ("RDMA/mlx5: Fix the recovery flow of the UMR QP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 ++-
 drivers/infiniband/hw/mlx5/mr.c      | 94 ++++++++++++++++++++++------
 drivers/infiniband/hw/mlx5/odp.c     |  2 +-
 3 files changed, 82 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f345e2ae394d2..7c72e0e9db54a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -770,6 +770,7 @@ struct mlx5_cache_ent {
 	struct rb_node		node;
 	struct mlx5r_cache_rb_key rb_key;
 
+	u8 is_tmp:1;
 	u8 disabled:1;
 	u8 fill_to_high_water:1;
 
@@ -803,6 +804,7 @@ struct mlx5_mkey_cache {
 	struct mutex		rb_lock;
 	struct dentry		*fs_root;
 	unsigned long		last_add;
+	struct delayed_work	remove_ent_dwork;
 };
 
 struct mlx5_ib_port_resources {
@@ -1346,9 +1348,10 @@ void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
 int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
 int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev);
 int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev);
-struct mlx5_cache_ent *mlx5r_cache_create_ent(struct mlx5_ib_dev *dev,
-					      struct mlx5r_cache_rb_key rb_key,
-					      bool persistent_entry);
+struct mlx5_cache_ent *
+mlx5r_cache_create_ent_locked(struct mlx5_ib_dev *dev,
+			      struct mlx5r_cache_rb_key rb_key,
+			      bool persistent_entry);
 
 struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 				       int access_flags, int access_mode,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bf1ca7565be67..2c1a935734273 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -140,19 +140,16 @@ static void create_mkey_warn(struct mlx5_ib_dev *dev, int status, void *out)
 	mlx5_cmd_out_err(dev->mdev, MLX5_CMD_OP_CREATE_MKEY, 0, out);
 }
 
-
-static int push_mkey(struct mlx5_cache_ent *ent, bool limit_pendings,
-		     void *to_store)
+static int push_mkey_locked(struct mlx5_cache_ent *ent, bool limit_pendings,
+			    void *to_store)
 {
 	XA_STATE(xas, &ent->mkeys, 0);
 	void *curr;
 
-	xa_lock_irq(&ent->mkeys);
 	if (limit_pendings &&
-	    (ent->reserved - ent->stored) > MAX_PENDING_REG_MR) {
-		xa_unlock_irq(&ent->mkeys);
+	    (ent->reserved - ent->stored) > MAX_PENDING_REG_MR)
 		return -EAGAIN;
-	}
+
 	while (1) {
 		/*
 		 * This is cmpxchg (NULL, XA_ZERO_ENTRY) however this version
@@ -191,6 +188,7 @@ static int push_mkey(struct mlx5_cache_ent *ent, bool limit_pendings,
 			break;
 		xa_lock_irq(&ent->mkeys);
 	}
+	xa_lock_irq(&ent->mkeys);
 	if (xas_error(&xas))
 		return xas_error(&xas);
 	if (WARN_ON(curr))
@@ -198,6 +196,17 @@ static int push_mkey(struct mlx5_cache_ent *ent, bool limit_pendings,
 	return 0;
 }
 
+static int push_mkey(struct mlx5_cache_ent *ent, bool limit_pendings,
+		     void *to_store)
+{
+	int ret;
+
+	xa_lock_irq(&ent->mkeys);
+	ret = push_mkey_locked(ent, limit_pendings, to_store);
+	xa_unlock_irq(&ent->mkeys);
+	return ret;
+}
+
 static void undo_push_reserve_mkey(struct mlx5_cache_ent *ent)
 {
 	void *old;
@@ -545,7 +554,7 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 {
 	lockdep_assert_held(&ent->mkeys.xa_lock);
 
-	if (ent->disabled || READ_ONCE(ent->dev->fill_delay))
+	if (ent->disabled || READ_ONCE(ent->dev->fill_delay) || ent->is_tmp)
 		return;
 	if (ent->stored < ent->limit) {
 		ent->fill_to_high_water = true;
@@ -675,7 +684,6 @@ static int mlx5_cache_ent_insert(struct mlx5_mkey_cache *cache,
 	struct mlx5_cache_ent *cur;
 	int cmp;
 
-	mutex_lock(&cache->rb_lock);
 	/* Figure out where to put new node */
 	while (*new) {
 		cur = rb_entry(*new, struct mlx5_cache_ent, node);
@@ -695,7 +703,6 @@ static int mlx5_cache_ent_insert(struct mlx5_mkey_cache *cache,
 	rb_link_node(&ent->node, parent, new);
 	rb_insert_color(&ent->node, &cache->rb_root);
 
-	mutex_unlock(&cache->rb_lock);
 	return 0;
 }
 
@@ -867,9 +874,10 @@ static void delay_time_func(struct timer_list *t)
 	WRITE_ONCE(dev->fill_delay, 0);
 }
 
-struct mlx5_cache_ent *mlx5r_cache_create_ent(struct mlx5_ib_dev *dev,
-					      struct mlx5r_cache_rb_key rb_key,
-					      bool persistent_entry)
+struct mlx5_cache_ent *
+mlx5r_cache_create_ent_locked(struct mlx5_ib_dev *dev,
+			      struct mlx5r_cache_rb_key rb_key,
+			      bool persistent_entry)
 {
 	struct mlx5_cache_ent *ent;
 	int order;
@@ -882,6 +890,7 @@ struct mlx5_cache_ent *mlx5r_cache_create_ent(struct mlx5_ib_dev *dev,
 	xa_init_flags(&ent->mkeys, XA_FLAGS_LOCK_IRQ);
 	ent->rb_key = rb_key;
 	ent->dev = dev;
+	ent->is_tmp = !persistent_entry;
 
 	INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
 
@@ -905,11 +914,44 @@ struct mlx5_cache_ent *mlx5r_cache_create_ent(struct mlx5_ib_dev *dev,
 			ent->limit = 0;
 
 		mlx5_mkey_cache_debugfs_add_ent(dev, ent);
+	} else {
+		mod_delayed_work(ent->dev->cache.wq,
+				 &ent->dev->cache.remove_ent_dwork,
+				 msecs_to_jiffies(30 * 1000));
 	}
 
 	return ent;
 }
 
+static void remove_ent_work_func(struct work_struct *work)
+{
+	struct mlx5_mkey_cache *cache;
+	struct mlx5_cache_ent *ent;
+	struct rb_node *cur;
+
+	cache = container_of(work, struct mlx5_mkey_cache,
+			     remove_ent_dwork.work);
+	mutex_lock(&cache->rb_lock);
+	cur = rb_last(&cache->rb_root);
+	while (cur) {
+		ent = rb_entry(cur, struct mlx5_cache_ent, node);
+		cur = rb_prev(cur);
+		mutex_unlock(&cache->rb_lock);
+
+		xa_lock_irq(&ent->mkeys);
+		if (!ent->is_tmp) {
+			xa_unlock_irq(&ent->mkeys);
+			mutex_lock(&cache->rb_lock);
+			continue;
+		}
+		xa_unlock_irq(&ent->mkeys);
+
+		clean_keys(ent->dev, ent);
+		mutex_lock(&cache->rb_lock);
+	}
+	mutex_unlock(&cache->rb_lock);
+}
+
 int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_mkey_cache *cache = &dev->cache;
@@ -925,6 +967,7 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 	mutex_init(&dev->slow_path_mutex);
 	mutex_init(&dev->cache.rb_lock);
 	dev->cache.rb_root = RB_ROOT;
+	INIT_DELAYED_WORK(&dev->cache.remove_ent_dwork, remove_ent_work_func);
 	cache->wq = alloc_ordered_workqueue("mkey_cache", WQ_MEM_RECLAIM);
 	if (!cache->wq) {
 		mlx5_ib_warn(dev, "failed to create work queue\n");
@@ -934,9 +977,10 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 	mlx5_cmd_init_async_ctx(dev->mdev, &dev->async_ctx);
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
 	mlx5_mkey_cache_debugfs_init(dev);
+	mutex_lock(&cache->rb_lock);
 	for (i = 0; i <= mkey_cache_max_order(dev); i++) {
 		rb_key.ndescs = 1 << (i + 2);
-		ent = mlx5r_cache_create_ent(dev, rb_key, true);
+		ent = mlx5r_cache_create_ent_locked(dev, rb_key, true);
 		if (IS_ERR(ent)) {
 			ret = PTR_ERR(ent);
 			goto err;
@@ -947,6 +991,7 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		goto err;
 
+	mutex_unlock(&cache->rb_lock);
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		ent = rb_entry(node, struct mlx5_cache_ent, node);
 		xa_lock_irq(&ent->mkeys);
@@ -957,6 +1002,7 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 	return 0;
 
 err:
+	mutex_unlock(&cache->rb_lock);
 	mlx5_ib_warn(dev, "failed to create mkey cache entry\n");
 	return ret;
 }
@@ -970,6 +1016,7 @@ int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
 	if (!dev->cache.wq)
 		return 0;
 
+	cancel_delayed_work_sync(&dev->cache.remove_ent_dwork);
 	mutex_lock(&dev->cache.rb_lock);
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		ent = rb_entry(node, struct mlx5_cache_ent, node);
@@ -1752,33 +1799,42 @@ static int cache_ent_find_and_store(struct mlx5_ib_dev *dev,
 {
 	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
+	int ret;
 
 	if (mr->mmkey.cache_ent) {
 		xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
 		mr->mmkey.cache_ent->in_use--;
-		xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
 		goto end;
 	}
 
 	mutex_lock(&cache->rb_lock);
 	ent = mkey_cache_ent_from_rb_key(dev, mr->mmkey.rb_key);
-	mutex_unlock(&cache->rb_lock);
 	if (ent) {
 		if (ent->rb_key.ndescs == mr->mmkey.rb_key.ndescs) {
+			if (ent->disabled) {
+				mutex_unlock(&cache->rb_lock);
+				return -EOPNOTSUPP;
+			}
 			mr->mmkey.cache_ent = ent;
+			xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
+			mutex_unlock(&cache->rb_lock);
 			goto end;
 		}
 	}
 
-	ent = mlx5r_cache_create_ent(dev, mr->mmkey.rb_key, false);
+	ent = mlx5r_cache_create_ent_locked(dev, mr->mmkey.rb_key, false);
+	mutex_unlock(&cache->rb_lock);
 	if (IS_ERR(ent))
 		return PTR_ERR(ent);
 
 	mr->mmkey.cache_ent = ent;
+	xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
 
 end:
-	return push_mkey(mr->mmkey.cache_ent, false,
-			 xa_mk_value(mr->mmkey.key));
+	ret = push_mkey_locked(mr->mmkey.cache_ent, false,
+			       xa_mk_value(mr->mmkey.key));
+	xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
+	return ret;
 }
 
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 96d4faabbff8a..6ba4aa1afdc2d 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1602,7 +1602,7 @@ int mlx5_odp_init_mkey_cache(struct mlx5_ib_dev *dev)
 	if (!(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 		return 0;
 
-	ent = mlx5r_cache_create_ent(dev, rb_key, true);
+	ent = mlx5r_cache_create_ent_locked(dev, rb_key, true);
 	if (IS_ERR(ent))
 		return PTR_ERR(ent);
 
-- 
2.39.5



