Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06804EEC8;
	Tue,  8 Oct 2024 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390423; cv=none; b=dQXKDgq2v44lEcj1sn0kgyxO0TZCP/BILbq8QAc7hwM6tF6rgCmi+aje+ITpwccTlEzHXolTBTga568n14unLfxXfddMV8y6xhyTbSl71NCOz044kkIklq9kr1V92TKAC91QnqvAkST0qmIi8pBxLm3zJrJ3Dl2YMxb++zJXVwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390423; c=relaxed/simple;
	bh=wT/svnprnyrp0SCU30vgz+3RdNLFeqlfXh6BqMP6MwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSD1SaORWZ6ZDmc0ijHUNqeTAQx5EX1UkEFV2/vSDQdQt72mBMegtmgum1pGGaf8bKpXYETvXWjW8V+mCdyIgkQ6KuPLGTiflESDhTQyKd7/ohU0XY5+dvyi0imBzGYHW3nSnvZh8w8BYjMgSCODzijkM4kM+uj6mClYB0cHoNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfe6f4q6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfe6f4q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF0AC4CECF;
	Tue,  8 Oct 2024 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390422;
	bh=wT/svnprnyrp0SCU30vgz+3RdNLFeqlfXh6BqMP6MwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfe6f4q64gfGZaSyRb6+C3alvyhoo9ZFXHKxyhInPRVi0nqsqNByxzAr8ir//XXBR
	 4L7gYy79DVeUx2cdPeftSug9DPyyBfIXrW6mQPvqTpoIIrapuTtNGRuDFDlE92p5wu
	 y2QLTavLr/P873OiwiO9rsSNYvtuCSlaFcrO9muw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 284/482] f2fs: introduce migration_window_granularity
Date: Tue,  8 Oct 2024 14:05:47 +0200
Message-ID: <20241008115659.455897142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 8c890c4c60342719526520133fb1b6f69f196ab8 ]

We can control the scanning window granularity for GC migration. For
more frequent scanning and GC on zoned devices, we need a fine grained
control knob for it.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5cc69a27abfa ("f2fs: forcibly migrate to secure space for zoned device file pinning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |  8 +++++++
 fs/f2fs/f2fs.h                          |  2 ++
 fs/f2fs/gc.c                            | 31 +++++++++++++++++--------
 fs/f2fs/gc.h                            |  1 +
 fs/f2fs/super.c                         |  2 ++
 fs/f2fs/sysfs.c                         |  7 ++++++
 6 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 3500920ab7ce0..d0c1acfcad405 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -777,3 +777,11 @@ Description:	The zone UFS we are currently using consists of two parts:
 		blkzone_alloc_policy = 1  Only allow writing to sequential zones
 		blkzone_alloc_policy = 2  Prioritize writing to conventional zones
 		========================  =========================================
+
+What:		/sys/fs/f2fs/<disk>/migration_window_granularity
+Date:		September 2024
+Contact:	"Daeho Jeong" <daehojeong@google.com>
+Description:	Controls migration window granularity of garbage collection on large
+		section. it can control the scanning window granularity for GC migration
+		in a unit of segment, while migration_granularity controls the number
+		of segments which can be migrated at the same turn.
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6fd5fc486a703..9796ad64727a6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1697,6 +1697,8 @@ struct f2fs_sb_info {
 	unsigned int max_victim_search;
 	/* migration granularity of garbage collection, unit: segment */
 	unsigned int migration_granularity;
+	/* migration window granularity of garbage collection, unit: segment */
+	unsigned int migration_window_granularity;
 
 	/*
 	 * for stat information.
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 7f61d6915e767..0605f87d1aca4 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1708,24 +1708,34 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 	struct blk_plug plug;
 	unsigned int segno = start_segno;
 	unsigned int end_segno = start_segno + SEGS_PER_SEC(sbi);
+	unsigned int sec_end_segno;
 	int seg_freed = 0, migrated = 0;
 	unsigned char type = IS_DATASEG(get_seg_entry(sbi, segno)->type) ?
 						SUM_TYPE_DATA : SUM_TYPE_NODE;
 	unsigned char data_type = (type == SUM_TYPE_DATA) ? DATA : NODE;
 	int submitted = 0;
 
-	if (__is_large_section(sbi))
-		end_segno = rounddown(end_segno, SEGS_PER_SEC(sbi));
+	if (__is_large_section(sbi)) {
+		sec_end_segno = rounddown(end_segno, SEGS_PER_SEC(sbi));
 
-	/*
-	 * zone-capacity can be less than zone-size in zoned devices,
-	 * resulting in less than expected usable segments in the zone,
-	 * calculate the end segno in the zone which can be garbage collected
-	 */
-	if (f2fs_sb_has_blkzoned(sbi))
-		end_segno -= SEGS_PER_SEC(sbi) -
+		/*
+		 * zone-capacity can be less than zone-size in zoned devices,
+		 * resulting in less than expected usable segments in the zone,
+		 * calculate the end segno in the zone which can be garbage
+		 * collected
+		 */
+		if (f2fs_sb_has_blkzoned(sbi))
+			sec_end_segno -= SEGS_PER_SEC(sbi) -
 					f2fs_usable_segs_in_sec(sbi, segno);
 
+		if (gc_type == BG_GC)
+			end_segno = start_segno +
+				sbi->migration_window_granularity;
+
+		if (end_segno > sec_end_segno)
+			end_segno = sec_end_segno;
+	}
+
 	sanity_check_seg_type(sbi, get_seg_entry(sbi, segno)->type);
 
 	/* readahead multi ssa blocks those have contiguous address */
@@ -1804,7 +1814,8 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 
 		if (__is_large_section(sbi))
 			sbi->next_victim_seg[gc_type] =
-				(segno + 1 < end_segno) ? segno + 1 : NULL_SEGNO;
+				(segno + 1 < sec_end_segno) ?
+					segno + 1 : NULL_SEGNO;
 skip:
 		f2fs_put_page(sum_page, 0);
 	}
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 55c4ba73362ef..245f93663745a 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -32,6 +32,7 @@
 
 #define LIMIT_NO_ZONED_GC	60 /* percentage over total user space of no gc for zoned devices */
 #define LIMIT_BOOST_ZONED_GC	25 /* percentage over total user space of boosted gc for zoned devices */
+#define DEF_MIGRATION_WINDOW_GRANULARITY_ZONED	3
 
 #define DEF_GC_FAILED_PINNED_FILES	2048
 #define MAX_GC_FAILED_PINNED_FILES	USHRT_MAX
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1a1b87c4c803f..b0932a4a8e047 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3801,6 +3801,8 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 	sbi->next_victim_seg[FG_GC] = NULL_SEGNO;
 	sbi->max_victim_search = DEF_MAX_VICTIM_SEARCH;
 	sbi->migration_granularity = SEGS_PER_SEC(sbi);
+	sbi->migration_window_granularity = f2fs_sb_has_blkzoned(sbi) ?
+		DEF_MIGRATION_WINDOW_GRANULARITY_ZONED : SEGS_PER_SEC(sbi);
 	sbi->seq_file_ra_mul = MIN_RA_MUL;
 	sbi->max_fragment_chunk = DEF_FRAGMENT_SIZE;
 	sbi->max_fragment_hole = DEF_FRAGMENT_SIZE;
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 15c8678581afc..bb0dbe7665f9c 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -561,6 +561,11 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 			return -EINVAL;
 	}
 
+	if (!strcmp(a->attr.name, "migration_window_granularity")) {
+		if (t == 0 || t > SEGS_PER_SEC(sbi))
+			return -EINVAL;
+	}
+
 	if (!strcmp(a->attr.name, "gc_urgent")) {
 		if (t == 0) {
 			sbi->gc_mode = GC_NORMAL;
@@ -1010,6 +1015,7 @@ F2FS_SBI_RW_ATTR(gc_pin_file_thresh, gc_pin_file_threshold);
 F2FS_SBI_RW_ATTR(gc_reclaimed_segments, gc_reclaimed_segs);
 F2FS_SBI_GENERAL_RW_ATTR(max_victim_search);
 F2FS_SBI_GENERAL_RW_ATTR(migration_granularity);
+F2FS_SBI_GENERAL_RW_ATTR(migration_window_granularity);
 F2FS_SBI_GENERAL_RW_ATTR(dir_level);
 #ifdef CONFIG_F2FS_IOSTAT
 F2FS_SBI_GENERAL_RW_ATTR(iostat_enable);
@@ -1150,6 +1156,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(min_ssr_sections),
 	ATTR_LIST(max_victim_search),
 	ATTR_LIST(migration_granularity),
+	ATTR_LIST(migration_window_granularity),
 	ATTR_LIST(dir_level),
 	ATTR_LIST(ram_thresh),
 	ATTR_LIST(ra_nid_pages),
-- 
2.43.0



