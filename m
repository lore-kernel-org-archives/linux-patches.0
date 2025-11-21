Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D0034D90B;
	Fri, 21 Nov 2025 13:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732473; cv=none; b=nRCBoYBh279cAzdkJm7t88Q9m6WqogO3QHrQ6PytJQKtkNHD7ytpZI0rCqq6o2LsoXGaDIUtH2SH8npww3Hs0a/j3kQ2P0+9nsZ2aMylMa0J+v/GwAbiIBs4oUra0bW9iA5WawUby69J6a58Ab2YVvIOtj1GLgPWA3dHHhWmvPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732473; c=relaxed/simple;
	bh=ILEHAFyvPEmPtH6SSpzk+QOnd242suaYLG73OQdTw38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaUY47q1w/iL11HWOlpjbj2d92hT2HwowoOAe54J0k1rt03tu3yH+mLGsUfz6zTI5fs2qBb4HCuAKisrUqfiTtx2Dl8VkIiSDVxj8t/kkA8WwGtKUFODjQ4Z3MhVW9ta1fb01akMklOR1HderguGeACE3d3ZYJPV88j8whOkZ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBJoJSVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBJoJSVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96C4C4CEF1;
	Fri, 21 Nov 2025 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732473;
	bh=ILEHAFyvPEmPtH6SSpzk+QOnd242suaYLG73OQdTw38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBJoJSVdt8157/n/Zoi2Iw2bT3GJrTrBVVUUZS1f1JKH6xIWb+PLpB7voGKCEugf6
	 aBmGkegVdVg1i8bEzvQHCm0L7DsglUnfVbh+no/71nmuMtruK1PJGONyRRnkhQPL+/
	 AX3nHeN+sgLuba7d72TuwsvNi17rBlEGyF58hbQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/529] blk-cgroup: fix possible deadlock while configuring policy
Date: Fri, 21 Nov 2025 14:06:39 +0100
Message-ID: <20251121130234.583618151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 5d726c4dbeeddef612e6bed27edd29733f4d13af ]

Following deadlock can be triggered easily by lockdep:

WARNING: possible circular locking dependency detected
6.17.0-rc3-00124-ga12c2658ced0 #1665 Not tainted
------------------------------------------------------
check/1334 is trying to acquire lock:
ff1100011d9d0678 (&q->sysfs_lock){+.+.}-{4:4}, at: blk_unregister_queue+0x53/0x180

but task is already holding lock:
ff1100011d9d00e0 (&q->q_usage_counter(queue)#3){++++}-{0:0}, at: del_gendisk+0xba/0x110

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&q->q_usage_counter(queue)#3){++++}-{0:0}:
       blk_queue_enter+0x40b/0x470
       blkg_conf_prep+0x7b/0x3c0
       tg_set_limit+0x10a/0x3e0
       cgroup_file_write+0xc6/0x420
       kernfs_fop_write_iter+0x189/0x280
       vfs_write+0x256/0x490
       ksys_write+0x83/0x190
       __x64_sys_write+0x21/0x30
       x64_sys_call+0x4608/0x4630
       do_syscall_64+0xdb/0x6b0
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #1 (&q->rq_qos_mutex){+.+.}-{4:4}:
       __mutex_lock+0xd8/0xf50
       mutex_lock_nested+0x2b/0x40
       wbt_init+0x17e/0x280
       wbt_enable_default+0xe9/0x140
       blk_register_queue+0x1da/0x2e0
       __add_disk+0x38c/0x5d0
       add_disk_fwnode+0x89/0x250
       device_add_disk+0x18/0x30
       virtblk_probe+0x13a3/0x1800
       virtio_dev_probe+0x389/0x610
       really_probe+0x136/0x620
       __driver_probe_device+0xb3/0x230
       driver_probe_device+0x2f/0xe0
       __driver_attach+0x158/0x250
       bus_for_each_dev+0xa9/0x130
       driver_attach+0x26/0x40
       bus_add_driver+0x178/0x3d0
       driver_register+0x7d/0x1c0
       __register_virtio_driver+0x2c/0x60
       virtio_blk_init+0x6f/0xe0
       do_one_initcall+0x94/0x540
       kernel_init_freeable+0x56a/0x7b0
       kernel_init+0x2b/0x270
       ret_from_fork+0x268/0x4c0
       ret_from_fork_asm+0x1a/0x30

-> #0 (&q->sysfs_lock){+.+.}-{4:4}:
       __lock_acquire+0x1835/0x2940
       lock_acquire+0xf9/0x450
       __mutex_lock+0xd8/0xf50
       mutex_lock_nested+0x2b/0x40
       blk_unregister_queue+0x53/0x180
       __del_gendisk+0x226/0x690
       del_gendisk+0xba/0x110
       sd_remove+0x49/0xb0 [sd_mod]
       device_remove+0x87/0xb0
       device_release_driver_internal+0x11e/0x230
       device_release_driver+0x1a/0x30
       bus_remove_device+0x14d/0x220
       device_del+0x1e1/0x5a0
       __scsi_remove_device+0x1ff/0x2f0
       scsi_remove_device+0x37/0x60
       sdev_store_delete+0x77/0x100
       dev_attr_store+0x1f/0x40
       sysfs_kf_write+0x65/0x90
       kernfs_fop_write_iter+0x189/0x280
       vfs_write+0x256/0x490
       ksys_write+0x83/0x190
       __x64_sys_write+0x21/0x30
       x64_sys_call+0x4608/0x4630
       do_syscall_64+0xdb/0x6b0
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

other info that might help us debug this:

Chain exists of:
  &q->sysfs_lock --> &q->rq_qos_mutex --> &q->q_usage_counter(queue)#3

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&q->q_usage_counter(queue)#3);
                               lock(&q->rq_qos_mutex);
                               lock(&q->q_usage_counter(queue)#3);
  lock(&q->sysfs_lock);

Root cause is that queue_usage_counter is grabbed with rq_qos_mutex
held in blkg_conf_prep(), while queue should be freezed before
rq_qos_mutex from other context.

The blk_queue_enter() from blkg_conf_prep() is used to protect against
policy deactivation, which is already protected with blkcg_mutex, hence
convert blk_queue_enter() to blkcg_mutex to fix this problem. Meanwhile,
consider that blkcg_mutex is held after queue is freezed from policy
deactivation, also convert blkg_alloc() to use GFP_NOIO.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 64551b0aa51e6..75e9d5a9d707c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -848,14 +848,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	disk = ctx->bdev->bd_disk;
 	q = disk->queue;
 
-	/*
-	 * blkcg_deactivate_policy() requires queue to be frozen, we can grab
-	 * q_usage_counter to prevent concurrent with blkcg_deactivate_policy().
-	 */
-	ret = blk_queue_enter(q, 0);
-	if (ret)
-		goto fail;
-
+	/* Prevent concurrent with blkcg_deactivate_policy() */
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 
 	if (!blkcg_policy_enabled(q, pol)) {
@@ -885,16 +879,16 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		/* Drop locks to do new blkg allocation with GFP_KERNEL. */
 		spin_unlock_irq(&q->queue_lock);
 
-		new_blkg = blkg_alloc(pos, disk, GFP_KERNEL);
+		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
-			goto fail_exit_queue;
+			goto fail_exit;
 		}
 
 		if (radix_tree_preload(GFP_KERNEL)) {
 			blkg_free(new_blkg);
 			ret = -ENOMEM;
-			goto fail_exit_queue;
+			goto fail_exit;
 		}
 
 		spin_lock_irq(&q->queue_lock);
@@ -922,7 +916,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto success;
 	}
 success:
-	blk_queue_exit(q);
+	mutex_unlock(&q->blkcg_mutex);
 	ctx->blkg = blkg;
 	return 0;
 
@@ -930,9 +924,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	radix_tree_preload_end();
 fail_unlock:
 	spin_unlock_irq(&q->queue_lock);
-fail_exit_queue:
-	blk_queue_exit(q);
-fail:
+fail_exit:
+	mutex_unlock(&q->blkcg_mutex);
 	/*
 	 * If queue was bypassing, we should retry.  Do so after a
 	 * short msleep().  It isn't strictly necessary but queue
-- 
2.51.0



