Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BCE30C61F;
	Mon, 13 Oct 2025 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369033; cv=none; b=OV24iWSVr+0VdTFK4VaRkHGfZreqLTY5AVoLyU/WN1khe8gAvL2/lF3OokLGQ7c3e/mDgbRpz0fJ5krLUi/GNkSS1+xRGK22OFtruLmHb9441t74uQbPPh3uzLVi3SH+3FzO1cwuHQu68qWJ5cxjIxwxCgAOrLcySH2S2BT0CsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369033; c=relaxed/simple;
	bh=z7RvuLM56BzEmz+omjeAHZj/wrKd2TlCVb14q+J4iQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZndUbcwDk5gUPtFuUlsZcIYTSAzYqxFL0Ei52Lx3w3FLVcZog7X1DFLUnykVQpn6YTWevaIMIgU85C5/8LQe0ZlDDMOTACGP3/ibZ+YXiIz2Rvp0NE/Ox85lEjoGkWEiaQJjAvZRId/lhFwvCdwHdXvskZ6VHrcwYL6R0dBtHVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NahAF5el; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NahAF5el"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B83EC4CEE7;
	Mon, 13 Oct 2025 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369032;
	bh=z7RvuLM56BzEmz+omjeAHZj/wrKd2TlCVb14q+J4iQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NahAF5elMcB5j3f2Hy9e6S1OwLVx8nQOHO96YDOyQopFpKrSjTe3r4qS68rAmEvfL
	 kharm/t3ku++V83H2rNTHg8YT+YFb7Fvzb5nLK2diBgYBrg9ITSJhWjnMO1IeKP+am
	 JaPW8TryjNcsTQyf8BK5bH+92pWOS7GiCn0c284o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Jie <liangjie@lixiang.com>,
	Han Guangjiang <hanguangjiang@lixiang.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 105/563] blk-throttle: fix access race during throttle policy activation
Date: Mon, 13 Oct 2025 16:39:26 +0200
Message-ID: <20251013144415.098626448@linuxfoundation.org>
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

From: Han Guangjiang <hanguangjiang@lixiang.com>

[ Upstream commit bd9fd5be6bc0836820500f68fff144609fbd85a9 ]

On repeated cold boots we occasionally hit a NULL pointer crash in
blk_should_throtl() when throttling is consulted before the throttle
policy is fully enabled for the queue. Checking only q->td != NULL is
insufficient during early initialization, so blkg_to_pd() for the
throttle policy can still return NULL and blkg_to_tg() becomes NULL,
which later gets dereferenced.

 Unable to handle kernel NULL pointer dereference
 at virtual address 0000000000000156
 ...
 pc : submit_bio_noacct+0x14c/0x4c8
 lr : submit_bio_noacct+0x48/0x4c8
 sp : ffff800087f0b690
 x29: ffff800087f0b690 x28: 0000000000005f90 x27: ffff00068af393c0
 x26: 0000000000080000 x25: 000000000002fbc0 x24: ffff000684ddcc70
 x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
 x20: 0000000000080000 x19: ffff000684ddcd08 x18: ffffffffffffffff
 x17: 0000000000000000 x16: ffff80008132a550 x15: 0000ffff98020fff
 x14: 0000000000000000 x13: 1fffe000d11d7021 x12: ffff000688eb810c
 x11: ffff00077ec4bb80 x10: ffff000688dcb720 x9 : ffff80008068ef60
 x8 : 00000a6fb8a86e85 x7 : 000000000000111e x6 : 0000000000000002
 x5 : 0000000000000246 x4 : 0000000000015cff x3 : 0000000000394500
 x2 : ffff000682e35e40 x1 : 0000000000364940 x0 : 000000000000001a
 Call trace:
  submit_bio_noacct+0x14c/0x4c8
  verity_map+0x178/0x2c8
  __map_bio+0x228/0x250
  dm_submit_bio+0x1c4/0x678
  __submit_bio+0x170/0x230
  submit_bio_noacct_nocheck+0x16c/0x388
  submit_bio_noacct+0x16c/0x4c8
  submit_bio+0xb4/0x210
  f2fs_submit_read_bio+0x4c/0xf0
  f2fs_mpage_readpages+0x3b0/0x5f0
  f2fs_readahead+0x90/0xe8

Tighten blk_throtl_activated() to also require that the throttle policy
bit is set on the queue:

  return q->td != NULL &&
         test_bit(blkcg_policy_throtl.plid, q->blkcg_pols);

This prevents blk_should_throtl() from accessing throttle group state
until policy data has been attached to blkgs.

Fixes: a3166c51702b ("blk-throttle: delay initialization until configuration")
Co-developed-by: Liang Jie <liangjie@lixiang.com>
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Signed-off-by: Han Guangjiang <hanguangjiang@lixiang.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c   |  6 ------
 block/blk-cgroup.h   |  6 ++++++
 block/blk-throttle.c |  6 +-----
 block/blk-throttle.h | 18 +++++++++++-------
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fe9ebd6a2e14d..7246fc2563152 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -110,12 +110,6 @@ static struct cgroup_subsys_state *blkcg_css(void)
 	return task_css(current, io_cgrp_id);
 }
 
-static bool blkcg_policy_enabled(struct request_queue *q,
-				 const struct blkcg_policy *pol)
-{
-	return pol && test_bit(pol->plid, q->blkcg_pols);
-}
-
 static void blkg_free_workfn(struct work_struct *work)
 {
 	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 81868ad86330c..83367086cb6ae 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -459,6 +459,12 @@ static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio)
 		bio_issue_as_root_blkg(rq->bio) == bio_issue_as_root_blkg(bio);
 }
 
+static inline bool blkcg_policy_enabled(struct request_queue *q,
+				const struct blkcg_policy *pol)
+{
+	return pol && test_bit(pol->plid, q->blkcg_pols);
+}
+
 void blk_cgroup_bio_start(struct bio *bio);
 void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta);
 #else	/* CONFIG_BLK_CGROUP */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 397b6a410f9e5..cfa1cd60d2c5f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1327,17 +1327,13 @@ static int blk_throtl_init(struct gendisk *disk)
 	INIT_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
 	throtl_service_queue_init(&td->service_queue);
 
-	/*
-	 * Freeze queue before activating policy, to synchronize with IO path,
-	 * which is protected by 'q_usage_counter'.
-	 */
 	memflags = blk_mq_freeze_queue(disk->queue);
 	blk_mq_quiesce_queue(disk->queue);
 
 	q->td = td;
 	td->queue = q;
 
-	/* activate policy */
+	/* activate policy, blk_throtl_activated() will return true */
 	ret = blkcg_activate_policy(disk, &blkcg_policy_throtl);
 	if (ret) {
 		q->td = NULL;
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 3b27755bfbff1..9d7a42c039a15 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -156,7 +156,13 @@ void blk_throtl_cancel_bios(struct gendisk *disk);
 
 static inline bool blk_throtl_activated(struct request_queue *q)
 {
-	return q->td != NULL;
+	/*
+	 * q->td guarantees that the blk-throttle module is already loaded,
+	 * and the plid of blk-throttle is assigned.
+	 * blkcg_policy_enabled() guarantees that the policy is activated
+	 * in the request_queue.
+	 */
+	return q->td != NULL && blkcg_policy_enabled(q, &blkcg_policy_throtl);
 }
 
 static inline bool blk_should_throtl(struct bio *bio)
@@ -164,11 +170,6 @@ static inline bool blk_should_throtl(struct bio *bio)
 	struct throtl_grp *tg;
 	int rw = bio_data_dir(bio);
 
-	/*
-	 * This is called under bio_queue_enter(), and it's synchronized with
-	 * the activation of blk-throtl, which is protected by
-	 * blk_mq_freeze_queue().
-	 */
 	if (!blk_throtl_activated(bio->bi_bdev->bd_queue))
 		return false;
 
@@ -194,7 +195,10 @@ static inline bool blk_should_throtl(struct bio *bio)
 
 static inline bool blk_throtl_bio(struct bio *bio)
 {
-
+	/*
+	 * block throttling takes effect if the policy is activated
+	 * in the bio's request_queue.
+	 */
 	if (!blk_should_throtl(bio))
 		return false;
 
-- 
2.51.0



