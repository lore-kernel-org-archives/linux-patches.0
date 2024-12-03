Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084431E25E3;
	Tue,  3 Dec 2024 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242734; cv=none; b=R1P7DlsbiEm+qm+mze4HlRH3c26zGB30rFjj43TVt5SECH1XDvImIt+4XmmgwdewfONb0kpUuhzJxUv4YoEJ7CpiYExhAOhIUVcJXm9TpMALb27ImfNwPs0/TU4ogVf5HaHhWjgyVRXyOXlwfQVIyPRt2Tl5wZGM+1Q0zrIAflk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242734; c=relaxed/simple;
	bh=8Z+tFyBizad2/2n9Nv40LkYLtHsUhkJchwpn5IzUBPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WieE+OV+gL0/dH+VpAKKRHaGrQCqnXvDZ9WcpWlnu/vMQIjVbLvR2RjOhgtOROQzlbFqzJAP/oBN40ej0k2joc3+XkRy/eF6Ygp7offDDPsO/75qYgJTkHaRmFtyt6T0b79WfAPgTVpJDeB8JtXc+qtRmcXqDlhMAsjDFh2AaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T95/DX7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T95/DX7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C53C4CECF;
	Tue,  3 Dec 2024 16:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242733;
	bh=8Z+tFyBizad2/2n9Nv40LkYLtHsUhkJchwpn5IzUBPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T95/DX7Y2YOIyzQz2Im1j2nneryh4sSEasJZK6INSs+W59XIcx+x/s+IiWlUdzkny
	 pVV/f8P1UklKgTvX6lbQHs94SrYfm9muk6C1BA38jwwaw1PJqzkFOlnZCBDLUOBE+G
	 71jtqBITmFN46Vn5Yql/E2GQkelB69bM3tWL95Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 794/826] block: fix uaf for flush rq while iterating tags
Date: Tue,  3 Dec 2024 15:48:41 +0100
Message-ID: <20241203144814.732041620@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 3802f73bd80766d70f319658f334754164075bc3 ]

blk_mq_clear_flush_rq_mapping() is not called during scsi probe, by
checking blk_queue_init_done(). However, QUEUE_FLAG_INIT_DONE is cleared
in del_gendisk by commit aec89dc5d421 ("block: keep q_usage_counter in
atomic mode after del_gendisk"), hence for disk like scsi, following
blk_mq_destroy_queue() will not clear flush rq from tags->rqs[] as well,
cause following uaf that is found by our syzkaller for v6.6:

==================================================================
BUG: KASAN: slab-use-after-free in blk_mq_find_and_get_req+0x16e/0x1a0 block/blk-mq-tag.c:261
Read of size 4 at addr ffff88811c969c20 by task kworker/1:2H/224909

CPU: 1 PID: 224909 Comm: kworker/1:2H Not tainted 6.6.0-ga836a5060850 #32
Workqueue: kblockd blk_mq_timeout_work
Call Trace:

__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0x91/0xf0 lib/dump_stack.c:106
print_address_description.constprop.0+0x66/0x300 mm/kasan/report.c:364
print_report+0x3e/0x70 mm/kasan/report.c:475
kasan_report+0xb8/0xf0 mm/kasan/report.c:588
blk_mq_find_and_get_req+0x16e/0x1a0 block/blk-mq-tag.c:261
bt_iter block/blk-mq-tag.c:288 [inline]
__sbitmap_for_each_set include/linux/sbitmap.h:295 [inline]
sbitmap_for_each_set include/linux/sbitmap.h:316 [inline]
bt_for_each+0x455/0x790 block/blk-mq-tag.c:325
blk_mq_queue_tag_busy_iter+0x320/0x740 block/blk-mq-tag.c:534
blk_mq_timeout_work+0x1a3/0x7b0 block/blk-mq.c:1673
process_one_work+0x7c4/0x1450 kernel/workqueue.c:2631
process_scheduled_works kernel/workqueue.c:2704 [inline]
worker_thread+0x804/0xe40 kernel/workqueue.c:2785
kthread+0x346/0x450 kernel/kthread.c:388
ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
ret_from_fork_asm+0x1b/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 942:
kasan_save_stack+0x22/0x50 mm/kasan/common.c:45
kasan_set_track+0x25/0x30 mm/kasan/common.c:52
____kasan_kmalloc mm/kasan/common.c:374 [inline]
__kasan_kmalloc mm/kasan/common.c:383 [inline]
__kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:380
kasan_kmalloc include/linux/kasan.h:198 [inline]
__do_kmalloc_node mm/slab_common.c:1007 [inline]
__kmalloc_node+0x69/0x170 mm/slab_common.c:1014
kmalloc_node include/linux/slab.h:620 [inline]
kzalloc_node include/linux/slab.h:732 [inline]
blk_alloc_flush_queue+0x144/0x2f0 block/blk-flush.c:499
blk_mq_alloc_hctx+0x601/0x940 block/blk-mq.c:3788
blk_mq_alloc_and_init_hctx+0x27f/0x330 block/blk-mq.c:4261
blk_mq_realloc_hw_ctxs+0x488/0x5e0 block/blk-mq.c:4294
blk_mq_init_allocated_queue+0x188/0x860 block/blk-mq.c:4350
blk_mq_init_queue_data block/blk-mq.c:4166 [inline]
blk_mq_init_queue+0x8d/0x100 block/blk-mq.c:4176
scsi_alloc_sdev+0x843/0xd50 drivers/scsi/scsi_scan.c:335
scsi_probe_and_add_lun+0x77c/0xde0 drivers/scsi/scsi_scan.c:1189
__scsi_scan_target+0x1fc/0x5a0 drivers/scsi/scsi_scan.c:1727
scsi_scan_channel drivers/scsi/scsi_scan.c:1815 [inline]
scsi_scan_channel+0x14b/0x1e0 drivers/scsi/scsi_scan.c:1791
scsi_scan_host_selected+0x2fe/0x400 drivers/scsi/scsi_scan.c:1844
scsi_scan+0x3a0/0x3f0 drivers/scsi/scsi_sysfs.c:151
store_scan+0x2a/0x60 drivers/scsi/scsi_sysfs.c:191
dev_attr_store+0x5c/0x90 drivers/base/core.c:2388
sysfs_kf_write+0x11c/0x170 fs/sysfs/file.c:136
kernfs_fop_write_iter+0x3fc/0x610 fs/kernfs/file.c:338
call_write_iter include/linux/fs.h:2083 [inline]
new_sync_write+0x1b4/0x2d0 fs/read_write.c:493
vfs_write+0x76c/0xb00 fs/read_write.c:586
ksys_write+0x127/0x250 fs/read_write.c:639
do_syscall_x64 arch/x86/entry/common.c:51 [inline]
do_syscall_64+0x70/0x120 arch/x86/entry/common.c:81
entry_SYSCALL_64_after_hwframe+0x78/0xe2

Freed by task 244687:
kasan_save_stack+0x22/0x50 mm/kasan/common.c:45
kasan_set_track+0x25/0x30 mm/kasan/common.c:52
kasan_save_free_info+0x2b/0x50 mm/kasan/generic.c:522
____kasan_slab_free mm/kasan/common.c:236 [inline]
__kasan_slab_free+0x12a/0x1b0 mm/kasan/common.c:244
kasan_slab_free include/linux/kasan.h:164 [inline]
slab_free_hook mm/slub.c:1815 [inline]
slab_free_freelist_hook mm/slub.c:1841 [inline]
slab_free mm/slub.c:3807 [inline]
__kmem_cache_free+0xe4/0x520 mm/slub.c:3820
blk_free_flush_queue+0x40/0x60 block/blk-flush.c:520
blk_mq_hw_sysfs_release+0x4a/0x170 block/blk-mq-sysfs.c:37
kobject_cleanup+0x136/0x410 lib/kobject.c:689
kobject_release lib/kobject.c:720 [inline]
kref_put include/linux/kref.h:65 [inline]
kobject_put+0x119/0x140 lib/kobject.c:737
blk_mq_release+0x24f/0x3f0 block/blk-mq.c:4144
blk_free_queue block/blk-core.c:298 [inline]
blk_put_queue+0xe2/0x180 block/blk-core.c:314
blkg_free_workfn+0x376/0x6e0 block/blk-cgroup.c:144
process_one_work+0x7c4/0x1450 kernel/workqueue.c:2631
process_scheduled_works kernel/workqueue.c:2704 [inline]
worker_thread+0x804/0xe40 kernel/workqueue.c:2785
kthread+0x346/0x450 kernel/kthread.c:388
ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
ret_from_fork_asm+0x1b/0x30 arch/x86/entry/entry_64.S:293

Other than blk_mq_clear_flush_rq_mapping(), the flag is only used in
blk_register_queue() from initialization path, hence it's safe not to
clear the flag in del_gendisk. And since QUEUE_FLAG_REGISTERED already
make sure that queue should only be registered once, there is no need
to test the flag as well.

Fixes: 6cfeadbff3f8 ("blk-mq: don't clear flush_rq from tags->rqs[]")
Depends-on: commit aec89dc5d421 ("block: keep q_usage_counter in atomic mode after del_gendisk")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241104110005.1412161-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 6 ++----
 block/genhd.c     | 9 +++------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e85941bec857b..207577145c54f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -794,10 +794,8 @@ int blk_register_queue(struct gendisk *disk)
 	 * faster to shut down and is made fully functional here as
 	 * request_queues for non-existent devices never get registered.
 	 */
-	if (!blk_queue_init_done(q)) {
-		blk_queue_flag_set(QUEUE_FLAG_INIT_DONE, q);
-		percpu_ref_switch_to_percpu(&q->q_usage_counter);
-	}
+	blk_queue_flag_set(QUEUE_FLAG_INIT_DONE, q);
+	percpu_ref_switch_to_percpu(&q->q_usage_counter);
 
 	return ret;
 
diff --git a/block/genhd.c b/block/genhd.c
index 6ad3fcde01105..8645cf3b0816e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -722,13 +722,10 @@ void del_gendisk(struct gendisk *disk)
 	 * If the disk does not own the queue, allow using passthrough requests
 	 * again.  Else leave the queue frozen to fail all I/O.
 	 */
-	if (!test_bit(GD_OWNS_QUEUE, &disk->state)) {
-		blk_queue_flag_clear(QUEUE_FLAG_INIT_DONE, q);
+	if (!test_bit(GD_OWNS_QUEUE, &disk->state))
 		__blk_mq_unfreeze_queue(q, true);
-	} else {
-		if (queue_is_mq(q))
-			blk_mq_exit_queue(q);
-	}
+	else if (queue_is_mq(q))
+		blk_mq_exit_queue(q);
 
 	if (start_drain)
 		blk_unfreeze_release_lock(q, true, queue_dying);
-- 
2.43.0



