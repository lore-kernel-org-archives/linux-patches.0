Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A605530BF6B;
	Mon, 13 Oct 2025 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369081; cv=none; b=JaApyyXLk2NJZ5X7quxXA2r7+8MIMyhvs7xlU+hCBrLsmfSrzlTUoultO4WiXkgF5OW41QpG1kZfRVvdDVOCHmKz1MJzEOgjC9zu3uo5lxzEVzw6TJi/LhveQ6mzkcdKN13iqAOiKn54MeV0XwL/hpcLhQrHTlFJblX1fEv/XtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369081; c=relaxed/simple;
	bh=Borexb4ossLqvtP7GQ6JqbAWuxd/qa7iZZPI9klEEAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTtOFEy0uY4ee57qil7wZEK6LqmO/RMRY6jnIYVIqXS0ZYGId3UCvJGzhWhbUKfK0mPnOMeDybv2QrQzlv+hlUURSk4R1fHtzVHn1cdyQEmkLo25Z3L15L1G0inupTCEWysDS80cImdwHors2Ja65gQXTNAqHA27qdAr6QbCfJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5wt3xCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5wt3xCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351F2C4CEE7;
	Mon, 13 Oct 2025 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369081;
	bh=Borexb4ossLqvtP7GQ6JqbAWuxd/qa7iZZPI9klEEAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5wt3xCQlrOGpylclc34FBvpoQhSIGuWvBPJ2E+CgnkF+cLVjHwfcqm7P1jmsW11u
	 zGthwvWuM+q79OwOxcEu40AlSaMtWUf188pZIDkHayfHBh+MMM6WBtd8kRUbrGrJ/E
	 iiUbkuGHqZK8sOjbArv/cKYZNLKeE4IZJz3bLxj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 120/563] block: cleanup bio_issue
Date: Mon, 13 Oct 2025 16:39:41 +0200
Message-ID: <20251013144415.641133209@linuxfoundation.org>
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

[ Upstream commit 1733e88874838ddebf7774440c285700865e6b08 ]

Now that bio->bi_issue is only used by blk-iolatency to get bio issue
time, replace bio_issue with u64 time directly and remove bio_issue to
make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 1f963bdd6420 ("block: initialize bio issue time in blk_mq_submit_bio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c               |  2 +-
 block/blk-cgroup.h        |  2 +-
 block/blk-iolatency.c     | 14 +++----------
 block/blk.h               | 42 ---------------------------------------
 include/linux/blk_types.h |  7 ++-----
 5 files changed, 7 insertions(+), 60 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3b371a5da159e..1904683f7ab05 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -261,7 +261,7 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_private = NULL;
 #ifdef CONFIG_BLK_CGROUP
 	bio->bi_blkg = NULL;
-	bio->bi_issue.value = 0;
+	bio->issue_time_ns = 0;
 	if (bdev)
 		bio_associate_blkg(bio);
 #ifdef CONFIG_BLK_CGROUP_IOCOST
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 83367086cb6ae..8328427e31657 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -372,7 +372,7 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 
 static inline void blkcg_bio_issue_init(struct bio *bio)
 {
-	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
+	bio->issue_time_ns = blk_time_get_ns();
 }
 
 static inline void blkcg_use_delay(struct blkcg_gq *blkg)
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 2f8fdecdd7a9b..554b191a68921 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -485,19 +485,11 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio)
 		mod_timer(&blkiolat->timer, jiffies + HZ);
 }
 
-static void iolatency_record_time(struct iolatency_grp *iolat,
-				  struct bio_issue *issue, u64 now,
-				  bool issue_as_root)
+static void iolatency_record_time(struct iolatency_grp *iolat, u64 start,
+				  u64 now, bool issue_as_root)
 {
-	u64 start = bio_issue_time(issue);
 	u64 req_time;
 
-	/*
-	 * Have to do this so we are truncated to the correct time that our
-	 * issue is truncated to.
-	 */
-	now = __bio_issue_time(now);
-
 	if (now <= start)
 		return;
 
@@ -625,7 +617,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 		 * submitted, so do not account for it.
 		 */
 		if (iolat->min_lat_nsec && bio->bi_status != BLK_STS_AGAIN) {
-			iolatency_record_time(iolat, &bio->bi_issue, now,
+			iolatency_record_time(iolat, bio->issue_time_ns, now,
 					      issue_as_root);
 			window_start = atomic64_read(&iolat->window_start);
 			if (now > window_start &&
diff --git a/block/blk.h b/block/blk.h
index 46f566f9b1266..0268deb222688 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -680,48 +680,6 @@ static inline ktime_t blk_time_get(void)
 	return ns_to_ktime(blk_time_get_ns());
 }
 
-/*
- * From most significant bit:
- * 1 bit: reserved for other usage, see below
- * 12 bits: original size of bio
- * 51 bits: issue time of bio
- */
-#define BIO_ISSUE_RES_BITS      1
-#define BIO_ISSUE_SIZE_BITS     12
-#define BIO_ISSUE_RES_SHIFT     (64 - BIO_ISSUE_RES_BITS)
-#define BIO_ISSUE_SIZE_SHIFT    (BIO_ISSUE_RES_SHIFT - BIO_ISSUE_SIZE_BITS)
-#define BIO_ISSUE_TIME_MASK     ((1ULL << BIO_ISSUE_SIZE_SHIFT) - 1)
-#define BIO_ISSUE_SIZE_MASK     \
-	(((1ULL << BIO_ISSUE_SIZE_BITS) - 1) << BIO_ISSUE_SIZE_SHIFT)
-#define BIO_ISSUE_RES_MASK      (~((1ULL << BIO_ISSUE_RES_SHIFT) - 1))
-
-/* Reserved bit for blk-throtl */
-#define BIO_ISSUE_THROTL_SKIP_LATENCY (1ULL << 63)
-
-static inline u64 __bio_issue_time(u64 time)
-{
-	return time & BIO_ISSUE_TIME_MASK;
-}
-
-static inline u64 bio_issue_time(struct bio_issue *issue)
-{
-	return __bio_issue_time(issue->value);
-}
-
-static inline sector_t bio_issue_size(struct bio_issue *issue)
-{
-	return ((issue->value & BIO_ISSUE_SIZE_MASK) >> BIO_ISSUE_SIZE_SHIFT);
-}
-
-static inline void bio_issue_init(struct bio_issue *issue,
-				       sector_t size)
-{
-	size &= (1ULL << BIO_ISSUE_SIZE_BITS) - 1;
-	issue->value = ((issue->value & BIO_ISSUE_RES_MASK) |
-			(blk_time_get_ns() & BIO_ISSUE_TIME_MASK) |
-			((u64)size << BIO_ISSUE_SIZE_SHIFT));
-}
-
 void bdev_release(struct file *bdev_file);
 int bdev_open(struct block_device *bdev, blk_mode_t mode, void *holder,
 	      const struct blk_holder_ops *hops, struct file *bdev_file);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 09b99d52fd365..f78145be77df5 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -198,10 +198,6 @@ static inline bool blk_path_error(blk_status_t error)
 	return true;
 }
 
-struct bio_issue {
-	u64 value;
-};
-
 typedef __u32 __bitwise blk_opf_t;
 
 typedef unsigned int blk_qc_t;
@@ -242,7 +238,8 @@ struct bio {
 	 * on release of the bio.
 	 */
 	struct blkcg_gq		*bi_blkg;
-	struct bio_issue	bi_issue;
+	/* Time that this bio was issued. */
+	u64			issue_time_ns;
 #ifdef CONFIG_BLK_CGROUP_IOCOST
 	u64			bi_iocost_cost;
 #endif
-- 
2.51.0



