Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE88380FF6;
	Thu, 20 Aug 2026 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239321; cv=none; b=FbKaXhd+TZ89sRKLO3XjwtBKbpwgWv3q+LUhLc+e8cQy3b0R4FIqdQCxMhA/h3VzqGGU2SkJON6MiZp30P1w9AFkmYzlSWuB+J6ZKLYV6uollca3ZkYLAH1xw9IF8UcwbUNMsuWvYZvdpdiltcvUP+EXwoUeR7XIl5Kw/+eSc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239321; c=relaxed/simple;
	bh=OvE+7/AC/R+ZGMBgcBbZm4dqZnYiSvbLO/nQL5b0EBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRd0k8cO9s+OzIbPaouRCyh0LHlyeHbGapEYJ5Cb/jOaSEScDhnD9AW8BEC64UWIiqJSZg3p7JHbNqAUtamKrKpcCaRoPsk04B8/6agarXlc25TR3ekiTXTiLugt1rwhA+SE4ClbZ1q7uMxOIp1HBK3/ysJxoN/zgALfXR7KGEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Nr3BKng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Nr3BKng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD3C1F000E9;
	Thu, 20 Aug 2026 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239319;
	bh=mhYKs56Wb20V+JoxQEduOdrmf3pMV4o3NbqwmlvjKPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Nr3BKng66oqAgtcm4ugej9Gy5JueZyLv3+sJe/+hwTaaxSDal5TpeGkl8/bIC0ar
	 Hvah5Vyfm86D/8/zniS0VIrzzbXVTcaCrqKYHFqdmi0oMXqaVky7Fx4UUQHoWggMlK
	 zSAY4XCvAXE2Vr/XrkARPXLWYauILevLC4Blmkb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weidong Zhu <weizhu@fiu.edu>,
	Chao Shi <coshi036@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/220] block: stop the timeout timer when releasing a never added disk
Date: Thu, 20 Aug 2026 16:53:11 +0200
Message-ID: <20260820145223.533603968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Shi <coshi036@gmail.com>

[ Upstream commit 26cb8ebbfaf713c82e142d08828d4d765057633b ]

disk_release() undoes blk_mq_init_allocated_queue() for a disk whose
probe failed before add_disk(), but it only calls blk_mq_exit_queue().
Nothing there stops q->timeout, and that timer rolls forward: it stays
pending until it next expires, not until the last request completes.
So if the driver issued any I/O before adding the disk, the
request_queue is freed while still linked into a timer wheel bucket.

Commit 6f8191fdf41d ("block: simplify disk shutdown") dropped the
blk_cleanup_queue() call that used to stop it.  __del_gendisk() and
blk_mq_destroy_queue() still do; only the probe failure path lost it.

nvme gets there because nvme_update_ns_info() submits Report Zones or
FDP io-mgmt-recv on ns->queue before the disk is added, so a later
failure - a concurrent reset setting NVME_CTRL_FROZEN, or
device_add_disk() failing - lands in put_disk() with the timer armed:

  BUG: KASAN: slab-use-after-free in detach_if_pending+0x30c/0x340
  Write of size 8 at addr ffff888004d71310 by task kworker/u8:2/37
   __timer_delete_sync+0x156/0x240 kernel/time/timer.c:1621
   blk_sync_queue+0x22/0x40 block/blk-core.c:222
   nvme_sync_queues+0x100/0x150 drivers/nvme/host/core.c:5362
   nvme_reset_work+0x138/0x930 drivers/nvme/host/pci.c:3264

  Allocated by task 34:
   __blk_mq_alloc_disk+0x33/0x100 block/blk-mq.c:4462
   nvme_alloc_ns+0x290/0x3870 drivers/nvme/host/core.c:4146

  Freed by task 0:
   blk_free_queue_rcu+0x3a/0x50 block/blk-core.c:254
   rcu_core+0xc10/0x1730 kernel/rcu/tree.c:2857

The queue being synced there is ctrl->admin_q, only a victim sharing a
timer wheel bucket with the freed queue's dangling entry; other runs
tripped in enqueue_timer(), __run_timers() or blk_mq_timeout_work().
Failing nvme_alloc_ns() with a debug patch makes it deterministic: one
leaked timer trips KASAN within seconds, while 1987 patched releases
produced no splat.

Stop the timer and the queue work items before blk_mq_exit_queue(), like
blk_mq_destroy_queue() does.

Found by FuzzNvme.

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260727201257.211635-1-coshi036@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 31e1539e6e6a..a909817bf1c8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1192,14 +1192,18 @@ static void disk_release(struct device *dev)
 	/*
 	 * To undo the all initialization from blk_mq_init_allocated_queue in
 	 * case of a probe failure where add_disk is never called we have to
-	 * call blk_mq_exit_queue here. We can't do this for the more common
-	 * teardown case (yet) as the tagset can be gone by the time the disk
-	 * is released once it was added.
+	 * call blk_mq_exit_queue here, after stopping the timer and work items
+	 * that I/O issued before add_disk may have left pending.  We can't do
+	 * this for the more common teardown case (yet) as the tagset can be
+	 * gone by the time the disk is released once it was added.
 	 */
 	if (queue_is_mq(disk->queue) &&
 	    test_bit(GD_OWNS_QUEUE, &disk->state) &&
-	    !test_bit(GD_ADDED, &disk->state))
+	    !test_bit(GD_ADDED, &disk->state)) {
+		blk_sync_queue(disk->queue);
+		blk_mq_cancel_work_sync(disk->queue);
 		blk_mq_exit_queue(disk->queue);
+	}
 
 	blkcg_exit_disk(disk);
 
-- 
2.53.0



