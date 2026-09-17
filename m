Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAB8518132;
	Thu, 17 Sep 2026 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666956; cv=none; b=bH3HIFECK2UKCGOLjvDi/xBNGdbbqnJBsdMuF9rbE9SNCWT/UsnQGhG8ToYFuMySdwQVfroh4LjarIi1Wzjn0t7VoqBLDdJlYZxgeVOTTKaTHFC3xyiSBjk8CPPTUXzayfJ5TbX94fCXi984XkkImxCevDWLxRo969sHWi4SBnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666956; c=relaxed/simple;
	bh=7auqyqP3+tpKci4Gs26xQfmhS4JimAwPZIhJzyCGUII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1VYe9qQuPBXdYUkphHfCCcWiDi0Wd57lCju3bl0PODX6+Hluf9OPnwWSk6cxWNEBT/+Pg2sU6RMLmmG3RGYgc6yXksYuQFwOHMOekzBLWuzuYFiQEhOQqmUbo9GBYxlHIm2W1CQwtd1bj+PzA7VOgV59jWOgxRZ5vXCm+1fvbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iu9HTL5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu9HTL5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4211F00893;
	Thu, 17 Sep 2026 17:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666955;
	bh=EDZoJt3wN85g+XXsJ3iW0YUTfjTZD0+qXaE7QJd+qDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iu9HTL5AukTScvg5ixKg/WPKFtQAdw4f+hscT26KTyeFU4DNer7LIVN50HEQBbeHI
	 Tn3RQKV2IT3g+ErT76wxdo/2W3kjPA31SMSJ46BSfPHge1dGO6abIpny85YG7iHt0J
	 4ma3bQEh/VAfJYO1a6AnQt1mxkD+JVvjJTeYrjYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wallentx <william.allentx@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1179/1250] Revert: "f2fs: check in-memory block bitmap"
Date: Thu, 17 Sep 2026 16:16:14 +0100
Message-ID: <20260917151624.241016563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit a2b251259bf2bdf550893bac078e9ce0a10e76c9 ]

Commit 355e78913c0d ("f2fs: check in-memory block bitmap") added
a mirror for valid block bitmap, it expects to detect in-memory
corruption, however we never got any reports from the check points
for almost decade, let's remove the code, it can help to save
memories.

Cc: wallentx <william.allentx@gmail.com>
Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 2b8704b6a8b2 ("f2fs: fix to reset all pinned status during fggc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |   38 --------------------------------------
 fs/f2fs/segment.h |    6 ------
 2 files changed, 44 deletions(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2458,9 +2458,6 @@ static int update_sit_entry_for_release(
 				unsigned int segno, block_t blkaddr, unsigned int offset, int del)
 {
 	bool exist;
-#ifdef CONFIG_F2FS_CHECK_FS
-	bool mir_exist;
-#endif
 	int i;
 	int del_count = -del;
 
@@ -2468,15 +2465,6 @@ static int update_sit_entry_for_release(
 
 	for (i = 0; i < del_count; i++) {
 		exist = f2fs_test_and_clear_bit(offset + i, se->cur_valid_map);
-#ifdef CONFIG_F2FS_CHECK_FS
-		mir_exist = f2fs_test_and_clear_bit(offset + i,
-						se->cur_valid_map_mir);
-		if (unlikely(exist != mir_exist)) {
-			f2fs_err(sbi, "Inconsistent error when clearing bitmap, blk:%u, old bit:%d",
-				blkaddr + i, exist);
-			f2fs_bug_on(sbi, 1);
-		}
-#endif
 		if (unlikely(!exist)) {
 			f2fs_err(sbi, "Bitmap was wrongly cleared, blk:%u", blkaddr + i);
 			f2fs_bug_on(sbi, 1);
@@ -2517,20 +2505,8 @@ static int update_sit_entry_for_alloc(st
 				unsigned int segno, block_t blkaddr, unsigned int offset, int del)
 {
 	bool exist;
-#ifdef CONFIG_F2FS_CHECK_FS
-	bool mir_exist;
-#endif
 
 	exist = f2fs_test_and_set_bit(offset, se->cur_valid_map);
-#ifdef CONFIG_F2FS_CHECK_FS
-	mir_exist = f2fs_test_and_set_bit(offset,
-					se->cur_valid_map_mir);
-	if (unlikely(exist != mir_exist)) {
-		f2fs_err(sbi, "Inconsistent error when setting bitmap, blk:%u, old bit:%d",
-			blkaddr, exist);
-		f2fs_bug_on(sbi, 1);
-	}
-#endif
 	if (unlikely(exist)) {
 		f2fs_err(sbi, "Bitmap was wrongly set, blk:%u", blkaddr);
 		f2fs_bug_on(sbi, 1);
@@ -4761,11 +4737,6 @@ void f2fs_flush_sit_entries(struct f2fs_
 			int offset, sit_offset;
 
 			se = get_seg_entry(sbi, segno);
-#ifdef CONFIG_F2FS_CHECK_FS
-			if (memcmp(se->cur_valid_map, se->cur_valid_map_mir,
-						SIT_VBLOCK_MAP_SIZE))
-				f2fs_bug_on(sbi, 1);
-#endif
 
 			/* add discard candidates */
 			if (!(cpc->reason & CP_DISCARD)) {
@@ -4856,11 +4827,7 @@ static int build_sit_info(struct f2fs_sb
 	if (!sit_i->dirty_sentries_bitmap)
 		return -ENOMEM;
 
-#ifdef CONFIG_F2FS_CHECK_FS
-	bitmap_size = MAIN_SEGS(sbi) * SIT_VBLOCK_MAP_SIZE * (3 + discard_map);
-#else
 	bitmap_size = MAIN_SEGS(sbi) * SIT_VBLOCK_MAP_SIZE * (2 + discard_map);
-#endif
 	sit_i->bitmap = f2fs_kvzalloc(sbi, bitmap_size, GFP_KERNEL);
 	if (!sit_i->bitmap)
 		return -ENOMEM;
@@ -4874,11 +4841,6 @@ static int build_sit_info(struct f2fs_sb
 		sit_i->sentries[start].ckpt_valid_map = bitmap;
 		bitmap += SIT_VBLOCK_MAP_SIZE;
 
-#ifdef CONFIG_F2FS_CHECK_FS
-		sit_i->sentries[start].cur_valid_map_mir = bitmap;
-		bitmap += SIT_VBLOCK_MAP_SIZE;
-#endif
-
 		if (discard_map) {
 			sit_i->sentries[start].discard_map = bitmap;
 			bitmap += SIT_VBLOCK_MAP_SIZE;
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -172,9 +172,6 @@ struct seg_entry {
 	unsigned int ckpt_valid_blocks:10;	/* # of valid blocks last cp */
 	unsigned int padding:6;		/* padding */
 	unsigned char *cur_valid_map;	/* validity bitmap of blocks */
-#ifdef CONFIG_F2FS_CHECK_FS
-	unsigned char *cur_valid_map_mir;	/* mirror of current valid bitmap */
-#endif
 	/*
 	 * # of valid blocks and the validity bitmap stored in the last
 	 * checkpoint pack. This information is used by the SSR mode.
@@ -403,9 +400,6 @@ static inline void seg_info_from_raw_sit
 	se->ckpt_valid_blocks = GET_SIT_VBLOCKS(rs);
 	memcpy(se->cur_valid_map, rs->valid_map, SIT_VBLOCK_MAP_SIZE);
 	memcpy(se->ckpt_valid_map, rs->valid_map, SIT_VBLOCK_MAP_SIZE);
-#ifdef CONFIG_F2FS_CHECK_FS
-	memcpy(se->cur_valid_map_mir, rs->valid_map, SIT_VBLOCK_MAP_SIZE);
-#endif
 	se->type = GET_SIT_TYPE(rs);
 	se->mtime = le64_to_cpu(rs->mtime);
 }


