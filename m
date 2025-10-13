Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BDF253954;
	Mon, 13 Oct 2025 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369084; cv=none; b=ogfLZNdd0CDx264UEkwCXxIrswDg2m2eV/WjfebvCAewbj9Siy/Ia54zmYDeuTXuybqdlUQThblkHOFAQtTD0LfLabyc1taR4sfwrW9jIokkN1GSIa/nlRwWcPMgfjLxzUI3kCfr23V8UJiHLUvaITCCVX9xb23hMCrbGRaqz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369084; c=relaxed/simple;
	bh=INgivSK8bHOmnCzuqhDq9dchKR5xZYqn/9698tc8ClE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRPZ69sVFBewcO1Z3RSK7NO3/FE9iqOuwKYouMimquEOtDflCxXnISktBBE/IdoAqbJoyG+DOCqjo23g/+5e9M6LZEYMoFWL3WwsmXJdJpamhgZevb5eg8L0n5d3+1hYkcBRVQTjjY4FIB34EDYqEE8J7EN4Akh6hpwizxzxADs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bnU+ga8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bnU+ga8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0741C4CEE7;
	Mon, 13 Oct 2025 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369084;
	bh=INgivSK8bHOmnCzuqhDq9dchKR5xZYqn/9698tc8ClE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bnU+ga8O6++cS2QaHp/mVVXMeQ7Nvs5eEEEXhyMLpdYZqTu6NVD4P31Dp/DZR2Vz
	 fCa8+6vleS7AoCdoy1jlix2uXltfw4YcK/W/LaT6N5W9vuzB0rccbXWOPtrWOx5Pbe
	 nIFVaHpXTp1/usiLPHgbxedJ1a55+4UZ4lXdKwME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 121/563] block: initialize bio issue time in blk_mq_submit_bio()
Date: Mon, 13 Oct 2025 16:39:42 +0200
Message-ID: <20251013144415.677130850@linuxfoundation.org>
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

[ Upstream commit 1f963bdd6420b6080bcfd0ee84a75c96f35545a6 ]

bio->issue_time_ns is only used by blk-iolatency, which can only be
enabled for rq-based disk, hence it's not necessary to initialize
the time for bio-based disk.

Meanwhile, if bio is split by blk_crypto_fallback_split_bio_if_needed(),
the issue time is not initialized for new split bio, this can be fixed
as well.

Noted the next patch will optimize better that bio issue time will
only be used when blk-iolatency is really enabled by the disk.

Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.h | 6 ------
 block/blk-core.c   | 1 -
 block/blk-merge.c  | 1 -
 block/blk-mq.c     | 8 ++++++++
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 8328427e31657..1cce3294634d1 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -370,11 +370,6 @@ static inline void blkg_put(struct blkcg_gq *blkg)
 		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
 					    (p_blkg)->q)))
 
-static inline void blkcg_bio_issue_init(struct bio *bio)
-{
-	bio->issue_time_ns = blk_time_get_ns();
-}
-
 static inline void blkcg_use_delay(struct blkcg_gq *blkg)
 {
 	if (WARN_ON_ONCE(atomic_read(&blkg->use_delay) < 0))
@@ -497,7 +492,6 @@ static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
 static inline struct blkcg_gq *pd_to_blkg(struct blkg_policy_data *pd) { return NULL; }
 static inline void blkg_get(struct blkcg_gq *blkg) { }
 static inline void blkg_put(struct blkcg_gq *blkg) { }
-static inline void blkcg_bio_issue_init(struct bio *bio) { }
 static inline void blk_cgroup_bio_start(struct bio *bio) { }
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
 
diff --git a/block/blk-core.c b/block/blk-core.c
index a27185cd8edea..e5af6eda5a459 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -730,7 +730,6 @@ static void __submit_bio_noacct_mq(struct bio *bio)
 void submit_bio_noacct_nocheck(struct bio *bio)
 {
 	blk_cgroup_bio_start(bio);
-	blkcg_bio_issue_init(bio);
 
 	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
 		trace_block_bio_queue(bio);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 70d704615be52..5538356770a47 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -119,7 +119,6 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 			goto error;
 		}
 		split->bi_opf |= REQ_NOMERGE;
-		blkcg_bio_issue_init(split);
 		bio_chain(split, bio);
 		trace_block_split(split, bio->bi_iter.bi_sector);
 		WARN_ON_ONCE(bio_zone_write_plugging(bio));
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9055cd6247004..19b50110376c6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -396,6 +396,13 @@ static inline void blk_mq_rq_time_init(struct request *rq, u64 alloc_time_ns)
 #endif
 }
 
+static inline void blk_mq_bio_issue_init(struct bio *bio)
+{
+#ifdef CONFIG_BLK_CGROUP
+	bio->issue_time_ns = blk_time_get_ns();
+#endif
+}
+
 static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 		struct blk_mq_tags *tags, unsigned int tag)
 {
@@ -3168,6 +3175,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (!bio_integrity_prep(bio))
 		goto queue_exit;
 
+	blk_mq_bio_issue_init(bio);
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
 
-- 
2.51.0



