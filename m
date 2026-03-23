Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0BF23504B;
	Mon, 23 Mar 2026 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277115; cv=none; b=YR1twj4VgLQZD3H7tkB66+nXECfQehJvO5pJrrG0TlfEDFCkfOqzo2AHaxnJBCVA0WRbJznAHStcz4ry+RwysjIm2/H8FG/JYvA6IA+pqwHkHCp2KBopGZ0PGqQR2x4VwBZNEhI1zlxxDV0PAKl53GpZCCXBOpUOMbtPEqDgQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277115; c=relaxed/simple;
	bh=WOYx71cXq1W3OhHT8sSQYCrsyu7sXB+tDANUKHS7gg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EehS1TbawpZrSLLXFHd4yhKpW1ypUhSTM9Tu9d+h8w2nVqWrlo/BwLjYStCzcDs0l1kUo/gGcu0TemZvqSmrIttw1+wCDbVvaxXNYIRG0z2HjtKW7ZiPFW0/OtouVywxzl9sSjE9OCTCWhaD+HoTiBb3A7712/zStIfT41qIqxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2R92afr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2R92afr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457EEC4CEF7;
	Mon, 23 Mar 2026 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277115;
	bh=WOYx71cXq1W3OhHT8sSQYCrsyu7sXB+tDANUKHS7gg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2R92afrhIWKAqj7cvZQps6wlIf67ne2Fbd3eGC75rhEKrNi7u8H3p7dGevFcRYNn
	 LEjqC/rJ88xYz+agy4qP5rWuG/vXk5OrfQUDtG1Wp7BxI4fwfEFPqdJ5sjFTi5UUY1
	 UvjpindpP0uZ6R1K0F8lyg2l1fW0gRayUC6HYRZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Han Guangjiang" <hanguangjiang@lixiang.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Jie <liangjie@lixiang.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.12 289/460] blk-throttle: fix access race during throttle policy activation
Date: Mon, 23 Mar 2026 14:44:45 +0100
Message-ID: <20260323134533.583706685@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c   |    6 ------
 block/blk-cgroup.h   |    6 ++++++
 block/blk-throttle.c |    6 +-----
 block/blk-throttle.h |   18 +++++++++++-------
 4 files changed, 18 insertions(+), 18 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -110,12 +110,6 @@ static struct cgroup_subsys_state *blkcg
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
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -455,6 +455,12 @@ static inline bool blk_cgroup_mergeable(
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
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1209,17 +1209,13 @@ static int blk_throtl_init(struct gendis
 	INIT_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
 	throtl_service_queue_init(&td->service_queue);
 
-	/*
-	 * Freeze queue before activating policy, to synchronize with IO path,
-	 * which is protected by 'q_usage_counter'.
-	 */
 	blk_mq_freeze_queue(disk->queue);
 	blk_mq_quiesce_queue(disk->queue);
 
 	q->td = td;
 	td->queue = q;
 
-	/* activate policy */
+	/* activate policy, blk_throtl_activated() will return true */
 	ret = blkcg_activate_policy(disk, &blkcg_policy_throtl);
 	if (ret) {
 		q->td = NULL;
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -154,7 +154,13 @@ void blk_throtl_cancel_bios(struct gendi
 
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
@@ -162,11 +168,6 @@ static inline bool blk_should_throtl(str
 	struct throtl_grp *tg;
 	int rw = bio_data_dir(bio);
 
-	/*
-	 * This is called under bio_queue_enter(), and it's synchronized with
-	 * the activation of blk-throtl, which is protected by
-	 * blk_mq_freeze_queue().
-	 */
 	if (!blk_throtl_activated(bio->bi_bdev->bd_queue))
 		return false;
 
@@ -192,7 +193,10 @@ static inline bool blk_should_throtl(str
 
 static inline bool blk_throtl_bio(struct bio *bio)
 {
-
+	/*
+	 * block throttling takes effect if the policy is activated
+	 * in the bio's request_queue.
+	 */
 	if (!blk_should_throtl(bio))
 		return false;
 


