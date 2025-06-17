Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0FA2F949A;
	Tue, 17 Jun 2025 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176810; cv=none; b=dDG/SIleooy0X/X4Z6BuGC+gmifzL3J9xvcAqv4q+vwuy8+B10kAhZJ2NO6XO8D3GV/9t/VDH1oE79EeRVn27Vr5qO3u7KBKRgzpmNbprYTWcwbZ+Eb+UZ5M+5uDKUrEIehrC0HUjkJ1LM0wzxCe8ngRNH0V8RfkQKtbtQ+ru9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176810; c=relaxed/simple;
	bh=Rusr4OSSCoKlbujJDlXqICgBUTsNtQbs6ZVNr3p/hzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kth4jwX1mZ5ImeDwIm0jlsnxxVKdh9hudIOP1YeyPnUAvq0AGMU1sLXj012zEvZdTeHnYK0n698auz5j9phX7aC+2HGskYCgOKorBGQIsJXmfZkzxz0bK9i1EY2UqUhUQsH5v7hCkudLj1spWuuHfOTufCMpjPoBjAMSrKqz42o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTI8RFsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTI8RFsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B00CC4CEE3;
	Tue, 17 Jun 2025 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176810;
	bh=Rusr4OSSCoKlbujJDlXqICgBUTsNtQbs6ZVNr3p/hzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTI8RFsigH673NcKpD7IMP/qugB9UKItN0/r33Gyu/N74FQKxdjA63+esXZ77hId7
	 w31NRHPxSYOQu2tBeGOmBmDFhdhvdcLPDHr3Vl8dcifcKPItlShfMprK5c9vURSV1a
	 XyYxQGt94zzgT8JrWJczcKfCNYsWWj3+FhWIX+3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 228/780] f2fs: zone: fix to calculate first_zoned_segno correctly
Date: Tue, 17 Jun 2025 17:18:56 +0200
Message-ID: <20250617152500.740636586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit dc6d9ef57fcf42fac1b3be4bff5ac5b3f1e8f9f3 ]

A zoned device can has both conventional zones and sequential zones,
so we should not treat first segment of zoned device as first_zoned_segno,
instead, we need to check zone type for each zone during traversing zoned
device to find first_zoned_segno.

Otherwise, for below case, first_zoned_segno will be 0, which could be
wrong.

create_null_blk 512 2 1024 1024
mkfs.f2fs -m /dev/nullb0

Testcase:

export SCRIPTS_PATH=/share/git/scripts

test multiple devices w/ zoned device
for ((i=0;i<8;i++)) do {
	zonesize=$((2<<$i))
	conzone=$((4096/$zonesize))
	seqzone=$((4096/$zonesize))
	$SCRIPTS_PATH/nullblk_create.sh 512 $zonesize $conzone $seqzone
	mkfs.f2fs -f -m /dev/vdb -c /dev/nullb0
	mount /dev/vdb /mnt/f2fs
	touch /mnt/f2fs/file
	f2fs_io pinfile set /mnt/f2fs/file $((8589934592*2))
	stat /mnt/f2fs/file
	df
	cat /proc/fs/f2fs/vdb/segment_info
	umount /mnt/f2fs
	$SCRIPTS_PATH/nullblk_remove.sh 0
} done

test single zoned device
for ((i=0;i<8;i++)) do {
	zonesize=$((2<<$i))
	conzone=$((4096/$zonesize))
	seqzone=$((4096/$zonesize))
	$SCRIPTS_PATH/nullblk_create.sh 512 $zonesize $conzone $seqzone
	mkfs.f2fs -f -m /dev/nullb0
	mount /dev/nullb0 /mnt/f2fs
	touch /mnt/f2fs/file
	f2fs_io pinfile set /mnt/f2fs/file $((8589934592*2))
	stat /mnt/f2fs/file
	df
	cat /proc/fs/f2fs/nullb0/segment_info
	umount /mnt/f2fs
	$SCRIPTS_PATH/nullblk_remove.sh 0
} done

Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c    |  2 +-
 fs/f2fs/f2fs.h    | 36 ++++++++++++++++++++++++++++--------
 fs/f2fs/segment.c | 10 +++++-----
 fs/f2fs/super.c   | 41 +++++++++++++++++++++++++++++++++++------
 4 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 81b25dd15a0b9..b0b8748ae287f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3966,7 +3966,7 @@ static int check_swap_activate(struct swap_info_struct *sis,
 
 		if ((pblock - SM_I(sbi)->main_blkaddr) % blks_per_sec ||
 				nr_pblocks % blks_per_sec ||
-				!f2fs_valid_pinned_area(sbi, pblock)) {
+				f2fs_is_sequential_zone_area(sbi, pblock)) {
 			bool last_extent = false;
 
 			not_aligned++;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6dcac5ab041c8..4f34a7d9760a1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1780,7 +1780,7 @@ struct f2fs_sb_info {
 	unsigned int dirty_device;		/* for checkpoint data flush */
 	spinlock_t dev_lock;			/* protect dirty_device */
 	bool aligned_blksize;			/* all devices has the same logical blksize */
-	unsigned int first_zoned_segno;		/* first zoned segno */
+	unsigned int first_seq_zone_segno;	/* first segno in sequential zone */
 
 	/* For write statistics */
 	u64 sectors_written_start;
@@ -4628,12 +4628,16 @@ F2FS_FEATURE_FUNCS(readonly, RO);
 F2FS_FEATURE_FUNCS(device_alias, DEVICE_ALIAS);
 
 #ifdef CONFIG_BLK_DEV_ZONED
-static inline bool f2fs_blkz_is_seq(struct f2fs_sb_info *sbi, int devi,
-				    block_t blkaddr)
+static inline bool f2fs_zone_is_seq(struct f2fs_sb_info *sbi, int devi,
+							unsigned int zone)
 {
-	unsigned int zno = blkaddr / sbi->blocks_per_blkz;
+	return test_bit(zone, FDEV(devi).blkz_seq);
+}
 
-	return test_bit(zno, FDEV(devi).blkz_seq);
+static inline bool f2fs_blkz_is_seq(struct f2fs_sb_info *sbi, int devi,
+								block_t blkaddr)
+{
+	return f2fs_zone_is_seq(sbi, devi, blkaddr / sbi->blocks_per_blkz);
 }
 #endif
 
@@ -4705,15 +4709,31 @@ static inline bool f2fs_lfs_mode(struct f2fs_sb_info *sbi)
 	return F2FS_OPTION(sbi).fs_mode == FS_MODE_LFS;
 }
 
-static inline bool f2fs_valid_pinned_area(struct f2fs_sb_info *sbi,
+static inline bool f2fs_is_sequential_zone_area(struct f2fs_sb_info *sbi,
 					  block_t blkaddr)
 {
 	if (f2fs_sb_has_blkzoned(sbi)) {
+#ifdef CONFIG_BLK_DEV_ZONED
 		int devi = f2fs_target_device_index(sbi, blkaddr);
 
-		return !bdev_is_zoned(FDEV(devi).bdev);
+		if (!bdev_is_zoned(FDEV(devi).bdev))
+			return false;
+
+		if (f2fs_is_multi_device(sbi)) {
+			if (blkaddr < FDEV(devi).start_blk ||
+				blkaddr > FDEV(devi).end_blk) {
+				f2fs_err(sbi, "Invalid block %x", blkaddr);
+				return false;
+			}
+			blkaddr -= FDEV(devi).start_blk;
+		}
+
+		return f2fs_blkz_is_seq(sbi, devi, blkaddr);
+#else
+		return false;
+#endif
 	}
-	return true;
+	return false;
 }
 
 static inline bool f2fs_low_mem_mode(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 396ef71f41e35..2a71e70c9ac97 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2777,7 +2777,7 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 		if (sbi->blkzone_alloc_policy == BLKZONE_ALLOC_PRIOR_CONV || pinning)
 			segno = 0;
 		else
-			segno = max(sbi->first_zoned_segno, *newseg);
+			segno = max(sbi->first_seq_zone_segno, *newseg);
 		hint = GET_SEC_FROM_SEG(sbi, segno);
 	}
 #endif
@@ -2789,7 +2789,7 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 	if (secno >= MAIN_SECS(sbi) && f2fs_sb_has_blkzoned(sbi)) {
 		/* Write only to sequential zones */
 		if (sbi->blkzone_alloc_policy == BLKZONE_ALLOC_ONLY_SEQ) {
-			hint = GET_SEC_FROM_SEG(sbi, sbi->first_zoned_segno);
+			hint = GET_SEC_FROM_SEG(sbi, sbi->first_seq_zone_segno);
 			secno = find_next_zero_bit(free_i->free_secmap, MAIN_SECS(sbi), hint);
 		} else
 			secno = find_first_zero_bit(free_i->free_secmap,
@@ -2838,9 +2838,9 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 	/* set it as dirty segment in free segmap */
 	f2fs_bug_on(sbi, test_bit(segno, free_i->free_segmap));
 
-	/* no free section in conventional zone */
+	/* no free section in conventional device or conventional zone */
 	if (new_sec && pinning &&
-		!f2fs_valid_pinned_area(sbi, START_BLOCK(sbi, segno))) {
+		f2fs_is_sequential_zone_area(sbi, START_BLOCK(sbi, segno))) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -3311,7 +3311,7 @@ int f2fs_allocate_pinning_section(struct f2fs_sb_info *sbi)
 
 	if (f2fs_sb_has_blkzoned(sbi) && err == -EAGAIN && gc_required) {
 		f2fs_down_write(&sbi->gc_lock);
-		err = f2fs_gc_range(sbi, 0, GET_SEGNO(sbi, FDEV(0).end_blk),
+		err = f2fs_gc_range(sbi, 0, sbi->first_seq_zone_segno - 1,
 				true, ZONED_PIN_SEC_REQUIRED_COUNT);
 		f2fs_up_write(&sbi->gc_lock);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f087b2b71c898..7a3bc85df6a7a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4304,14 +4304,35 @@ static void f2fs_record_error_work(struct work_struct *work)
 	f2fs_record_stop_reason(sbi);
 }
 
-static inline unsigned int get_first_zoned_segno(struct f2fs_sb_info *sbi)
+static inline unsigned int get_first_seq_zone_segno(struct f2fs_sb_info *sbi)
 {
+#ifdef CONFIG_BLK_DEV_ZONED
+	unsigned int zoneno, total_zones;
 	int devi;
 
-	for (devi = 0; devi < sbi->s_ndevs; devi++)
-		if (bdev_is_zoned(FDEV(devi).bdev))
-			return GET_SEGNO(sbi, FDEV(devi).start_blk);
-	return 0;
+	if (!f2fs_sb_has_blkzoned(sbi))
+		return NULL_SEGNO;
+
+	for (devi = 0; devi < sbi->s_ndevs; devi++) {
+		if (!bdev_is_zoned(FDEV(devi).bdev))
+			continue;
+
+		total_zones = GET_ZONE_FROM_SEG(sbi, FDEV(devi).total_segments);
+
+		for (zoneno = 0; zoneno < total_zones; zoneno++) {
+			unsigned int segs, blks;
+
+			if (!f2fs_zone_is_seq(sbi, devi, zoneno))
+				continue;
+
+			segs = GET_SEG_FROM_SEC(sbi,
+					zoneno * sbi->secs_per_zone);
+			blks = SEGS_TO_BLKS(sbi, segs);
+			return GET_SEGNO(sbi, FDEV(devi).start_blk + blks);
+		}
+	}
+#endif
+	return NULL_SEGNO;
 }
 
 static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
@@ -4348,6 +4369,14 @@ static int f2fs_scan_devices(struct f2fs_sb_info *sbi)
 #endif
 
 	for (i = 0; i < max_devices; i++) {
+		if (max_devices == 1) {
+			FDEV(i).total_segments =
+				le32_to_cpu(raw_super->segment_count_main);
+			FDEV(i).start_blk = 0;
+			FDEV(i).end_blk = FDEV(i).total_segments *
+						BLKS_PER_SEG(sbi);
+		}
+
 		if (i == 0)
 			FDEV(0).bdev_file = sbi->sb->s_bdev_file;
 		else if (!RDEV(i).path[0])
@@ -4718,7 +4747,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->sectors_written_start = f2fs_get_sectors_written(sbi);
 
 	/* get segno of first zoned block device */
-	sbi->first_zoned_segno = get_first_zoned_segno(sbi);
+	sbi->first_seq_zone_segno = get_first_seq_zone_segno(sbi);
 
 	/* Read accumulated write IO statistics if exists */
 	seg_i = CURSEG_I(sbi, CURSEG_HOT_NODE);
-- 
2.39.5



