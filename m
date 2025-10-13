Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE63081AE;
	Mon, 13 Oct 2025 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369176; cv=none; b=oXGfm12/ra+voSb/H6U1qSnqiqm8+jthHnxEOJC4PRlCEcmApzCfAZe1YZW4FjhgJ/fPwYj+0iBgQyS0a/Waq+oKUFnT5fQWE+A5C16BJ7t97BMC85E5QMxT4IYnigTDcUrF5OLrrpayawqvCjnAG1PPcJVA+45/C9f7StoOhGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369176; c=relaxed/simple;
	bh=QNGBqiiBpBF48jgpmpOSvGS17AlNE+B5S9PYX4JxRho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYCmzsj5mP1uuX8DRtETQThqGEu60Y7dogKSrftrM4Fm4ofY5UNaqvojSa1UAoOtDimnrDQc5OFVVjNI2df/b0NAXIEEGjzf6GFZ9ahLxo/MnhIDW/41FPybSsUoyMVOSnMhx8dYLXUS0zksJSz3rHIBSZLFH2VytvkbFtgByVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyKUw0t+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyKUw0t+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9469AC4CEE7;
	Mon, 13 Oct 2025 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369176;
	bh=QNGBqiiBpBF48jgpmpOSvGS17AlNE+B5S9PYX4JxRho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyKUw0t+8UM9U00y6awoANBefer0a7tiDrQm5H2Qc/7A4uBm2U8gBg0/XuKtv7sBt
	 KdMHk241WaFN8VeIIiPvvJROEnhTVAOa6Gi3+srWvpzGTLyp9sVL6C/7Ri5mtTCk8d
	 V0+JXYVJITQwZ8rFie7y9RLvKN/T2CuvkwsSXCY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 127/563] blk-mq: convert to serialize updating nr_requests with update_nr_hwq_lock
Date: Mon, 13 Oct 2025 16:39:48 +0200
Message-ID: <20251013144415.895473568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 626ff4f8ebcb7207f01e7810acb85812ccf06bd8 ]

request_queue->nr_requests can be changed by:

a) switch elevator by updating nr_hw_queues
b) switch elevator by elevator sysfs attribute
c) configue queue sysfs attribute nr_requests

Current lock order is:

1) update_nr_hwq_lock, case a,b
2) freeze_queue
3) elevator_lock, case a,b,c

And update nr_requests is seriablized by elevator_lock() already,
however, in the case c, we'll have to allocate new sched_tags if
nr_requests grow, and do this with elevator_lock held and queue
freezed has the risk of deadlock.

Hence use update_nr_hwq_lock instead, make it possible to allocate
memory if tags grow, meanwhile also prevent nr_requests to be changed
concurrently.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b86433721f46 ("blk-mq: fix potential deadlock while nr_requests grown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b61e956a868e7..163264e4ec629 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -68,6 +68,7 @@ queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 	int ret, err;
 	unsigned int memflags;
 	struct request_queue *q = disk->queue;
+	struct blk_mq_tag_set *set = q->tag_set;
 
 	if (!queue_is_mq(q))
 		return -EINVAL;
@@ -76,8 +77,11 @@ queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 	if (ret < 0)
 		return ret;
 
-	memflags = blk_mq_freeze_queue(q);
-	mutex_lock(&q->elevator_lock);
+	/*
+	 * Serialize updating nr_requests with concurrent queue_requests_store()
+	 * and switching elevator.
+	 */
+	down_write(&set->update_nr_hwq_lock);
 
 	if (nr == q->nr_requests)
 		goto unlock;
@@ -85,20 +89,31 @@ queue_requests_store(struct gendisk *disk, const char *page, size_t count)
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
-	if (nr <= q->tag_set->reserved_tags ||
+	/*
+	 * Switching elevator is protected by update_nr_hwq_lock:
+	 *  - read lock is held from elevator sysfs attribute;
+	 *  - write lock is held from updating nr_hw_queues;
+	 * Hence it's safe to access q->elevator here with write lock held.
+	 */
+	if (nr <= set->reserved_tags ||
 	    (q->elevator && nr > MAX_SCHED_RQ) ||
-	    (!q->elevator && nr > q->tag_set->queue_depth)) {
+	    (!q->elevator && nr > set->queue_depth)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
 
+	memflags = blk_mq_freeze_queue(q);
+	mutex_lock(&q->elevator_lock);
+
 	err = blk_mq_update_nr_requests(disk->queue, nr);
 	if (err)
 		ret = err;
 
-unlock:
 	mutex_unlock(&q->elevator_lock);
 	blk_mq_unfreeze_queue(q, memflags);
+
+unlock:
+	up_write(&set->update_nr_hwq_lock);
 	return ret;
 }
 
-- 
2.51.0



