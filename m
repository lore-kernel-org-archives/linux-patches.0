Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B60C1946D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cny6Dejd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A917BC433C8;
	Mon,  9 Oct 2023 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857308;
	bh=5t/fqh5+sFSLtrlcB0p6J82kDGH6I6SxgstmyYfMUJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cny6DejdGFqKh5dPNhQ2W0s45Otz28IrQ/YoY3SV8tOD5lVyCHzNhbceE4d+5DA2W
	 O/05HwhOWtvBHvf8Z0etVLau3kPufnFGIWUTJZB7AXQnNnbEwRqZnDaPiTtqpxuiWW
	 DpS1WONFuXdJFoTxNamm+LpI5BCSdd3H+cFlbOso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 6.5 152/163] RDMA/mlx5: Fix mkey cache possible deadlock on cleanup
Date: Mon,  9 Oct 2023 15:01:56 +0200
Message-ID: <20231009130128.221149659@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

commit 374012b0045780b7ad498be62e85153009bb7fe9 upstream.

Fix the deadlock by refactoring the MR cache cleanup flow to flush the
workqueue without holding the rb_lock.
This adds a race between cache cleanup and creation of new entries which
we solve by denied creation of new entries after cache cleanup started.

Lockdep:
WARNING: possible circular locking dependency detected
 [ 2785.326074 ] 6.2.0-rc6_for_upstream_debug_2023_01_31_14_02 #1 Not tainted
 [ 2785.339778 ] ------------------------------------------------------
 [ 2785.340848 ] devlink/53872 is trying to acquire lock:
 [ 2785.341701 ] ffff888124f8c0c8 ((work_completion)(&(&ent->dwork)->work)){+.+.}-{0:0}, at: __flush_work+0xc8/0x900
 [ 2785.343403 ]
 [ 2785.343403 ] but task is already holding lock:
 [ 2785.344464 ] ffff88817e8f1260 (&dev->cache.rb_lock){+.+.}-{3:3}, at: mlx5_mkey_cache_cleanup+0x77/0x250 [mlx5_ib]
 [ 2785.346273 ]
 [ 2785.346273 ] which lock already depends on the new lock.
 [ 2785.346273 ]
 [ 2785.347720 ]
 [ 2785.347720 ] the existing dependency chain (in reverse order) is:
 [ 2785.349003 ]
 [ 2785.349003 ] -> #1 (&dev->cache.rb_lock){+.+.}-{3:3}:
 [ 2785.350160 ]        __mutex_lock+0x14c/0x15c0
 [ 2785.350962 ]        delayed_cache_work_func+0x2d1/0x610 [mlx5_ib]
 [ 2785.352044 ]        process_one_work+0x7c2/0x1310
 [ 2785.352879 ]        worker_thread+0x59d/0xec0
 [ 2785.353636 ]        kthread+0x28f/0x330
 [ 2785.354370 ]        ret_from_fork+0x1f/0x30
 [ 2785.355135 ]
 [ 2785.355135 ] -> #0 ((work_completion)(&(&ent->dwork)->work)){+.+.}-{0:0}:
 [ 2785.356515 ]        __lock_acquire+0x2d8a/0x5fe0
 [ 2785.357349 ]        lock_acquire+0x1c1/0x540
 [ 2785.358121 ]        __flush_work+0xe8/0x900
 [ 2785.358852 ]        __cancel_work_timer+0x2c7/0x3f0
 [ 2785.359711 ]        mlx5_mkey_cache_cleanup+0xfb/0x250 [mlx5_ib]
 [ 2785.360781 ]        mlx5_ib_stage_pre_ib_reg_umr_cleanup+0x16/0x30 [mlx5_ib]
 [ 2785.361969 ]        __mlx5_ib_remove+0x68/0x120 [mlx5_ib]
 [ 2785.362960 ]        mlx5r_remove+0x63/0x80 [mlx5_ib]
 [ 2785.363870 ]        auxiliary_bus_remove+0x52/0x70
 [ 2785.364715 ]        device_release_driver_internal+0x3c1/0x600
 [ 2785.365695 ]        bus_remove_device+0x2a5/0x560
 [ 2785.366525 ]        device_del+0x492/0xb80
 [ 2785.367276 ]        mlx5_detach_device+0x1a9/0x360 [mlx5_core]
 [ 2785.368615 ]        mlx5_unload_one_devl_locked+0x5a/0x110 [mlx5_core]
 [ 2785.369934 ]        mlx5_devlink_reload_down+0x292/0x580 [mlx5_core]
 [ 2785.371292 ]        devlink_reload+0x439/0x590
 [ 2785.372075 ]        devlink_nl_cmd_reload+0xaef/0xff0
 [ 2785.372973 ]        genl_family_rcv_msg_doit.isra.0+0x1bd/0x290
 [ 2785.374011 ]        genl_rcv_msg+0x3ca/0x6c0
 [ 2785.374798 ]        netlink_rcv_skb+0x12c/0x360
 [ 2785.375612 ]        genl_rcv+0x24/0x40
 [ 2785.376295 ]        netlink_unicast+0x438/0x710
 [ 2785.377121 ]        netlink_sendmsg+0x7a1/0xca0
 [ 2785.377926 ]        sock_sendmsg+0xc5/0x190
 [ 2785.378668 ]        __sys_sendto+0x1bc/0x290
 [ 2785.379440 ]        __x64_sys_sendto+0xdc/0x1b0
 [ 2785.380255 ]        do_syscall_64+0x3d/0x90
 [ 2785.381031 ]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
 [ 2785.381967 ]
 [ 2785.381967 ] other info that might help us debug this:
 [ 2785.381967 ]
 [ 2785.383448 ]  Possible unsafe locking scenario:
 [ 2785.383448 ]
 [ 2785.384544 ]        CPU0                    CPU1
 [ 2785.385383 ]        ----                    ----
 [ 2785.386193 ]   lock(&dev->cache.rb_lock);
 [ 2785.386940 ]				lock((work_completion)(&(&ent->dwork)->work));
 [ 2785.388327 ]				lock(&dev->cache.rb_lock);
 [ 2785.389425 ]   lock((work_completion)(&(&ent->dwork)->work));
 [ 2785.390414 ]
 [ 2785.390414 ]  *** DEADLOCK ***
 [ 2785.390414 ]
 [ 2785.391579 ] 6 locks held by devlink/53872:
 [ 2785.392341 ]  #0: ffffffff84c17a50 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40
 [ 2785.393630 ]  #1: ffff888142280218 (&devlink->lock_key){+.+.}-{3:3}, at: devlink_get_from_attrs_lock+0x12d/0x2d0
 [ 2785.395324 ]  #2: ffff8881422d3c38 (&dev->lock_key){+.+.}-{3:3}, at: mlx5_unload_one_devl_locked+0x4a/0x110 [mlx5_core]
 [ 2785.397322 ]  #3: ffffffffa0e59068 (mlx5_intf_mutex){+.+.}-{3:3}, at: mlx5_detach_device+0x60/0x360 [mlx5_core]
 [ 2785.399231 ]  #4: ffff88810e3cb0e8 (&dev->mutex){....}-{3:3}, at: device_release_driver_internal+0x8d/0x600
 [ 2785.400864 ]  #5: ffff88817e8f1260 (&dev->cache.rb_lock){+.+.}-{3:3}, at: mlx5_mkey_cache_cleanup+0x77/0x250 [mlx5_ib]

Fixes: b95845178328 ("RDMA/mlx5: Change the cache structure to an RB-tree")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    1 +
 drivers/infiniband/hw/mlx5/mr.c      |   16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -797,6 +797,7 @@ struct mlx5_mkey_cache {
 	struct dentry		*fs_root;
 	unsigned long		last_add;
 	struct delayed_work	remove_ent_dwork;
+	u8			disable: 1;
 };
 
 struct mlx5_ib_port_resources {
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1024,19 +1024,27 @@ void mlx5_mkey_cache_cleanup(struct mlx5
 	if (!dev->cache.wq)
 		return;
 
-	cancel_delayed_work_sync(&dev->cache.remove_ent_dwork);
 	mutex_lock(&dev->cache.rb_lock);
+	dev->cache.disable = true;
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		ent = rb_entry(node, struct mlx5_cache_ent, node);
 		xa_lock_irq(&ent->mkeys);
 		ent->disabled = true;
 		xa_unlock_irq(&ent->mkeys);
-		cancel_delayed_work_sync(&ent->dwork);
 	}
+	mutex_unlock(&dev->cache.rb_lock);
+
+	/*
+	 * After all entries are disabled and will not reschedule on WQ,
+	 * flush it and all async commands.
+	 */
+	flush_workqueue(dev->cache.wq);
 
 	mlx5_mkey_cache_debugfs_cleanup(dev);
 	mlx5_cmd_cleanup_async_ctx(&dev->async_ctx);
 
+	/* At this point all entries are disabled and have no concurrent work. */
+	mutex_lock(&dev->cache.rb_lock);
 	node = rb_first(root);
 	while (node) {
 		ent = rb_entry(node, struct mlx5_cache_ent, node);
@@ -1815,6 +1823,10 @@ static int cache_ent_find_and_store(stru
 	}
 
 	mutex_lock(&cache->rb_lock);
+	if (cache->disable) {
+		mutex_unlock(&cache->rb_lock);
+		return 0;
+	}
 	ent = mkey_cache_ent_from_rb_key(dev, mr->mmkey.rb_key);
 	if (ent) {
 		if (ent->rb_key.ndescs == mr->mmkey.rb_key.ndescs) {


