Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE088F5B;
	Tue,  8 Jul 2025 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992950; cv=none; b=vFc6e5YBhSVF94iPjKC1vFKc59kfBXnKD30M5r9Jg2zAEbIndSyrfj3C43F5bcV8B51xJqY8AJO8sIshXxVPt3jo8xC+r5FQ87IjTjc7FQu62uMndXQjRXgTXKA0d8RoKPb9D0foJvyzJCH7yVe+ay0VeakCKmubGivy+vBTLOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992950; c=relaxed/simple;
	bh=N7StNm1qv7d2/w9Af7scDGUvKVzYouezUmoLlwDyzD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY8lUsEjy+av0YL+/YTf2JjUy+rr4GkXs++tHqaBXF6DRv0ylUcIMy8aQZsuuDzgzmwYK9SaDlKi5tR1ozwK0DyNFfbAASf4kmoqybi66tX3zBaMUtaBX2O1mVf4AR4U31fEvf6xBc6TnWarRb3+wzF864iEcG9fu7to5yuEXCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSFRiFyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSFRiFyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC74C4CEED;
	Tue,  8 Jul 2025 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992950;
	bh=N7StNm1qv7d2/w9Af7scDGUvKVzYouezUmoLlwDyzD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSFRiFyC6nFCjwBNNHXNeLTYG6TjFKeQysdnoKaJ8p9ge8QYCfIu2Ie1XFaAPBazU
	 bSdUB9EsEsU+eD7GXYLqJ7TDjgAmgWE6f5vUSAxxUIJS2s3I5OmkOwasHrcblNwiDe
	 I9G845iEjleckbtNGQzEcfmZjdraDJ5Uf9Iwm7XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/232] f2fs: zone: introduce first_zoned_segno in f2fs_sb_info
Date: Tue,  8 Jul 2025 18:22:05 +0200
Message-ID: <20250708162244.816756575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5bc5aae843128aefb1c55d769d057c92dd8a32c9 ]

first_zoned_segno() returns a fixed value, let's cache it in
structure f2fs_sb_info to avoid redundant calculation.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: dc6d9ef57fcf ("f2fs: zone: fix to calculate first_zoned_segno correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/segment.c |  4 ++--
 fs/f2fs/segment.h | 10 ----------
 fs/f2fs/super.c   | 13 +++++++++++++
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 61b715cc2e231..08b0f35be76bc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1762,6 +1762,7 @@ struct f2fs_sb_info {
 	unsigned int dirty_device;		/* for checkpoint data flush */
 	spinlock_t dev_lock;			/* protect dirty_device */
 	bool aligned_blksize;			/* all devices has the same logical blksize */
+	unsigned int first_zoned_segno;		/* first zoned segno */
 
 	/* For write statistics */
 	u64 sectors_written_start;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3db89becdbfcd..c7919b9cebcd0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2719,7 +2719,7 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 		if (sbi->blkzone_alloc_policy == BLKZONE_ALLOC_PRIOR_CONV || pinning)
 			segno = 0;
 		else
-			segno = max(first_zoned_segno(sbi), *newseg);
+			segno = max(sbi->first_zoned_segno, *newseg);
 		hint = GET_SEC_FROM_SEG(sbi, segno);
 	}
 #endif
@@ -2731,7 +2731,7 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 	if (secno >= MAIN_SECS(sbi) && f2fs_sb_has_blkzoned(sbi)) {
 		/* Write only to sequential zones */
 		if (sbi->blkzone_alloc_policy == BLKZONE_ALLOC_ONLY_SEQ) {
-			hint = GET_SEC_FROM_SEG(sbi, first_zoned_segno(sbi));
+			hint = GET_SEC_FROM_SEG(sbi, sbi->first_zoned_segno);
 			secno = find_next_zero_bit(free_i->free_secmap, MAIN_SECS(sbi), hint);
 		} else
 			secno = find_first_zero_bit(free_i->free_secmap,
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 05a342933f98f..52bb1a2819357 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -992,13 +992,3 @@ static inline void wake_up_discard_thread(struct f2fs_sb_info *sbi, bool force)
 	dcc->discard_wake = true;
 	wake_up_interruptible_all(&dcc->discard_wait_queue);
 }
-
-static inline unsigned int first_zoned_segno(struct f2fs_sb_info *sbi)
-{
-	int devi;
-
-	for (devi = 0; devi < sbi->s_ndevs; devi++)
-		if (bdev_is_zoned(FDEV(devi).bdev))
-			return GET_SEGNO(sbi, FDEV(devi).start_blk);
-	return 0;
-}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f0e83ea56e38c..0508527ebe115 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4260,6 +4260,16 @@ static void f2fs_record_error_work(struct work_struct *work)
 	f2fs_record_stop_reason(sbi);
 }
 
+static inline unsigned int get_first_zoned_segno(struct f2fs_sb_info *sbi)
+{
+	int devi;
+
+	for (devi = 0; devi < sbi->s_ndevs; devi++)
+		if (bdev_is_zoned(FDEV(devi).bdev))
+			return GET_SEGNO(sbi, FDEV(devi).start_blk);
+	return 0;
+}
+
 static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
@@ -4660,6 +4670,9 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	/* For write statistics */
 	sbi->sectors_written_start = f2fs_get_sectors_written(sbi);
 
+	/* get segno of first zoned block device */
+	sbi->first_zoned_segno = get_first_zoned_segno(sbi);
+
 	/* Read accumulated write IO statistics if exists */
 	seg_i = CURSEG_I(sbi, CURSEG_HOT_NODE);
 	if (__exist_node_summaries(sbi))
-- 
2.39.5



