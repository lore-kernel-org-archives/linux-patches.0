Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDA12500DA;
	Tue,  3 Dec 2024 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239835; cv=none; b=fG2rSXu17zI6MOQUr5wuKUr6rqRihV8h1D7oPBX/Llw2w1FhhD/RwFnKQ/+428YVLYdpqTvZTAy30X7zV9AI4J9fMoCbCVIxSOJQM1CZsB/cpSVy9muJn+GA30mhNbDxsRRs7ChYqy+VsMJwXXBi5pfIgE5dRI78SrKEkGzt1gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239835; c=relaxed/simple;
	bh=DSJh1sHIvb1LyJ5rJg/JbQLxyeki1kbTiW5h5Vt4ua8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk0UehaA9O7ShqO01Fl6RaTyizCRzeNMX/so50z+enlS9iPr7+eSchvckrPPlKvqPcp8Io9MzVjZXq2yMV9J6366YxYRHPqzlAu9d7w9skJG3v4u5okFOR1fKKJAlH6FniBK7clYk5hjOscRPwbBKJXdbeU4jGybAycz4EGOpQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O92doRNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O92doRNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA381C4CECF;
	Tue,  3 Dec 2024 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239835;
	bh=DSJh1sHIvb1LyJ5rJg/JbQLxyeki1kbTiW5h5Vt4ua8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O92doRNBxUvv4d+iogA/ivsb1PFlYSnsRpJ4J0MWq0hMuYxjSVlP+Gvp/fdOzrTr0
	 RGEs7kaWEc5p/sbLCZ9x0DgDZWi8jCfBrRXYEel7SZLhW339dAYyyRmtEbQVP0rRuE
	 O6VuanZWlLIXVqWrEnqwsy4Q/njT80SZzQ7UNldU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 719/817] block: Prevent potential deadlock in blk_revalidate_disk_zones()
Date: Tue,  3 Dec 2024 15:44:51 +0100
Message-ID: <20241203144024.058487735@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 0b83c86b444ab467134b0e618f45ad2216a4973c upstream.

The function blk_revalidate_disk_zones() calls the function
disk_update_zone_resources() after freezing the device queue. In turn,
disk_update_zone_resources() calls queue_limits_start_update() which
takes a queue limits mutex lock, resulting in the ordering:
q->q_usage_counter check -> q->limits_lock. However, the usual ordering
is to always take a queue limit lock before freezing the queue to commit
the limits updates, e.g., the code pattern:

lim = queue_limits_start_update(q);
...
blk_mq_freeze_queue(q);
ret = queue_limits_commit_update(q, &lim);
blk_mq_unfreeze_queue(q);

Thus, blk_revalidate_disk_zones() introduces a potential circular
locking dependency deadlock that lockdep sometimes catches with the
splat:

[   51.934109] ======================================================
[   51.935916] WARNING: possible circular locking dependency detected
[   51.937561] 6.12.0+ #2107 Not tainted
[   51.938648] ------------------------------------------------------
[   51.940351] kworker/u16:4/157 is trying to acquire lock:
[   51.941805] ffff9fff0aa0bea8 (&q->limits_lock){+.+.}-{4:4}, at: disk_update_zone_resources+0x86/0x170
[   51.944314]
               but task is already holding lock:
[   51.945688] ffff9fff0aa0b890 (&q->q_usage_counter(queue)#3){++++}-{0:0}, at: blk_revalidate_disk_zones+0x15f/0x340
[   51.948527]
               which lock already depends on the new lock.

[   51.951296]
               the existing dependency chain (in reverse order) is:
[   51.953708]
               -> #1 (&q->q_usage_counter(queue)#3){++++}-{0:0}:
[   51.956131]        blk_queue_enter+0x1c9/0x1e0
[   51.957290]        blk_mq_alloc_request+0x187/0x2a0
[   51.958365]        scsi_execute_cmd+0x78/0x490 [scsi_mod]
[   51.959514]        read_capacity_16+0x111/0x410 [sd_mod]
[   51.960693]        sd_revalidate_disk.isra.0+0x872/0x3240 [sd_mod]
[   51.962004]        sd_probe+0x2d7/0x520 [sd_mod]
[   51.962993]        really_probe+0xd5/0x330
[   51.963898]        __driver_probe_device+0x78/0x110
[   51.964925]        driver_probe_device+0x1f/0xa0
[   51.965916]        __driver_attach_async_helper+0x60/0xe0
[   51.967017]        async_run_entry_fn+0x2e/0x140
[   51.968004]        process_one_work+0x21f/0x5a0
[   51.968987]        worker_thread+0x1dc/0x3c0
[   51.969868]        kthread+0xe0/0x110
[   51.970377]        ret_from_fork+0x31/0x50
[   51.970983]        ret_from_fork_asm+0x11/0x20
[   51.971587]
               -> #0 (&q->limits_lock){+.+.}-{4:4}:
[   51.972479]        __lock_acquire+0x1337/0x2130
[   51.973133]        lock_acquire+0xc5/0x2d0
[   51.973691]        __mutex_lock+0xda/0xcf0
[   51.974300]        disk_update_zone_resources+0x86/0x170
[   51.975032]        blk_revalidate_disk_zones+0x16c/0x340
[   51.975740]        sd_zbc_revalidate_zones+0x73/0x160 [sd_mod]
[   51.976524]        sd_revalidate_disk.isra.0+0x465/0x3240 [sd_mod]
[   51.977824]        sd_probe+0x2d7/0x520 [sd_mod]
[   51.978917]        really_probe+0xd5/0x330
[   51.979915]        __driver_probe_device+0x78/0x110
[   51.981047]        driver_probe_device+0x1f/0xa0
[   51.982143]        __driver_attach_async_helper+0x60/0xe0
[   51.983282]        async_run_entry_fn+0x2e/0x140
[   51.984319]        process_one_work+0x21f/0x5a0
[   51.985873]        worker_thread+0x1dc/0x3c0
[   51.987289]        kthread+0xe0/0x110
[   51.988546]        ret_from_fork+0x31/0x50
[   51.989926]        ret_from_fork_asm+0x11/0x20
[   51.991376]
               other info that might help us debug this:

[   51.994127]  Possible unsafe locking scenario:

[   51.995651]        CPU0                    CPU1
[   51.996694]        ----                    ----
[   51.997716]   lock(&q->q_usage_counter(queue)#3);
[   51.998817]                                lock(&q->limits_lock);
[   52.000043]                                lock(&q->q_usage_counter(queue)#3);
[   52.001638]   lock(&q->limits_lock);
[   52.002485]
                *** DEADLOCK ***

Prevent this issue by moving the calls to blk_mq_freeze_queue() and
blk_mq_unfreeze_queue() around the call to queue_limits_commit_update()
in disk_update_zone_resources(). In case of revalidation failure, the
call to disk_free_zone_resources() in blk_revalidate_disk_zones()
is still done with the queue frozen as before.

Fixes: 843283e96e5a ("block: Fake max open zones limit when there is no limit")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241126104705.183996-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1541,6 +1541,7 @@ static int disk_update_zone_resources(st
 	unsigned int nr_seq_zones, nr_conv_zones = 0;
 	unsigned int pool_size;
 	struct queue_limits lim;
+	int ret;
 
 	disk->nr_zones = args->nr_zones;
 	disk->zone_capacity = args->zone_capacity;
@@ -1593,7 +1594,11 @@ static int disk_update_zone_resources(st
 	}
 
 commit:
-	return queue_limits_commit_update(q, &lim);
+	blk_mq_freeze_queue(q);
+	ret = queue_limits_commit_update(q, &lim);
+	blk_mq_unfreeze_queue(q);
+
+	return ret;
 }
 
 static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
@@ -1814,14 +1819,15 @@ int blk_revalidate_disk_zones(struct gen
 	 * Set the new disk zone parameters only once the queue is frozen and
 	 * all I/Os are completed.
 	 */
-	blk_mq_freeze_queue(q);
 	if (ret > 0)
 		ret = disk_update_zone_resources(disk, &args);
 	else
 		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-	if (ret)
+	if (ret) {
+		blk_mq_freeze_queue(q);
 		disk_free_zone_resources(disk);
-	blk_mq_unfreeze_queue(q);
+		blk_mq_unfreeze_queue(q);
+	}
 
 	kfree(args.conv_zones_bitmap);
 


