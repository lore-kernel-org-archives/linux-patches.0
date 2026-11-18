Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021063;
	b=QBS5JwqcsWd2Vj4ThVnRYVxilBlZUFnd6h0QsVgumnmAsBFejnjV0TXAy5AfxzmcbCfe
	 KcgHIOw2jrnxkNyvftcRs7eVX1qZ+u4SIi3nwKFRIAbL22MlARUyBMnRQhFu58YgrC+/T
	 H8x9U4Sli5m2F7atgtwqYe9Tu+wPib6pWRPb534B9hCFnQNeovRgYdvooGO1DxX0u+PvB
	 gC9NwSocfVMPBAK0vBtwajbsBkfdSn9wDKQMiaaK6oXudeXcpUp+jZqlZWuSKxXj3xnu3
	 AFFruWt57jojyu20d5UmwtTj++67QuFcYvLAIxGfb/xAlq4I/SGWcZ12t3z9Wy3bI1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lfEVc6+YqEUrVF1iNpWcGhIH7f3kdYRl4K7miXemTKU=;
	b=rdtH6MXphdFRPdt/pSqoAD9ChnKB+3eBJZFZhWRbq5U5G8i9eF5XhVLgnddPdpCfzjhY
	 RVyx3fP5nheS//pMscK05ecECmH/ubz4bgcGFPuBHd8M5B0qnqLDYceabB/TX7UIa81jO
	 QiIyJihGrT5Cdcv8rsJUn4pyCA0IlJJM2qkdbcelMVuXJrrVCx4VfHWrpRHeaR8eSl3Zr
	 Gq1VZzWHds3GhDhU0aROLAVG8ltlO9NkFY81YVgZ6AfDY7EOX1Gzp79FUOPZS214yJUB3
	 d8pwnN92feQ1cRKRzpYmaUva35+K7rhAopVyYFlb4WKDnnI300X5DbQPF2TXhiwLPHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4zEmZk5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F69606A331;
	Wed, 18 Nov 2026 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4zEmZk5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966251F000C4;
	Wed, 18 Nov 2026 16:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021063;
	bh=lfEVc6+YqEUrVF1iNpWcGhIH7f3kdYRl4K7miXemTKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4zEmZk5G3J5rGxKMo3LWwXNneBaszmN7XyV5ZfqfXFxguEGIRTsZJT5FHQ3gKXGe
	 19z/88vuxR89jFZB5/hygjrCiEEihbC8noO/fWjcE/uOZhwooPNgmj/9liY4dcaiB2
	 6+orJGREcSZtUYX/X3xkVWT9SiKmLWe8y3f+uvuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2173/2651] f2fs: refresh pinned allocation boundary after resize
Date: Wed, 18 Nov 2026 15:56:53 +0100
Message-ID: <20261118150404.032071262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit e4df12e37300d4e181ae76746ae0fd7f7b92aa36 ]

Online shrink updates MAIN_SECS() but leaves resizable_tail_secno and
pinned_area_max_secno unchanged. The pinned allocation limit can exceed
the new main area when shrinking beyond the reserved tail.

Consume the reserved tail by the number of removed sections, clamping
it to zero, before refreshing the shared pinned allocation boundary.
This preserves the boundary while shrinking within the reservation and
limits it to the new main area otherwise, retaining the zoned limit.

Save the old tail count and restore it before rolling back the geometry
if the final checkpoint fails.

Also bound pinned section allocation by the current MAIN_SECS(). Range
evacuation temporarily reduces it before moving cursegs, while the
cached pinned boundary still describes the old geometry. Otherwise, a
pinned curseg can be reallocated into the range being removed.

Fixes: c966d29e01bb ("f2fs: support resizable tail section and unify pinned allocation")
Suggested-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst |  3 ++-
 fs/f2fs/gc.c                       |  6 +++++-
 fs/f2fs/segment.c                  |  2 +-
 fs/f2fs/segment.h                  | 11 +++++++++++
 fs/f2fs/super.c                    | 15 ++-------------
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 771216f45207a..55798421f2c45 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -421,7 +421,8 @@ resizable_tail_secno=%u  Control the number of sections at the tail of the
 			 (MAIN_SECS - resizable_tail_secno) - 1. If set to 0
 			 (default), there is no tail restriction unless running
 			 on a zoned block device where conventional zones are
-			 used.
+			 used. Online shrink consumes this reservation, reducing
+			 the value by the number of removed sections, down to zero.
 ======================== ============================================================
 
 Debugfs Entries
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 6220d55709e9c..8d620799df121 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2323,6 +2323,7 @@ static void update_fs_metadata(struct f2fs_sb_info *sbi, int secs)
 	SM_I(sbi)->segment_count = (int)SM_I(sbi)->segment_count + segs;
 	MAIN_SEGS(sbi) = (int)MAIN_SEGS(sbi) + segs;
 	MAIN_SECS(sbi) += secs;
+	f2fs_adjust_pinned_area_boundary(sbi);
 	if (sbi->allocate_section_hint > MAIN_SECS(sbi))
 		sbi->allocate_section_hint = MAIN_SECS(sbi);
 	FREE_I(sbi)->free_sections = (int)FREE_I(sbi)->free_sections + secs;
@@ -2354,7 +2355,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	struct f2fs_lock_context lc;
 	struct f2fs_lock_context glc;
 	struct f2fs_lock_context clc;
-	unsigned int secs;
+	unsigned int secs, old_tail;
 	int err = 0;
 	__u32 rem;
 
@@ -2463,6 +2464,8 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 		goto recover_out;
 	}
 
+	old_tail = F2FS_OPTION(sbi).resizable_tail_secno;
+	F2FS_OPTION(sbi).resizable_tail_secno -= min(old_tail, secs);
 	update_fs_metadata(sbi, -secs);
 	clear_sbi_flag(sbi, SBI_IS_RESIZEFS);
 	set_sbi_flag(sbi, SBI_IS_DIRTY);
@@ -2470,6 +2473,7 @@ int f2fs_resize_fs(struct file *filp, __u64 block_count)
 	stat_inc_cp_call_count(sbi, TOTAL_CALL);
 	err = f2fs_write_checkpoint(sbi, &cpc);
 	if (err) {
+		F2FS_OPTION(sbi).resizable_tail_secno = old_tail;
 		update_fs_metadata(sbi, secs);
 		update_sb_metadata(sbi, secs);
 		f2fs_commit_super(sbi, false);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 75f78ed7eb909..c1d78939ce845 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2980,7 +2980,7 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 		alloc_hint = MAIN_SECS(sbi);
 
 	if (pinning) {
-		max_secno = sbi->pinned_area_max_secno;
+		max_secno = min(sbi->pinned_area_max_secno, MAIN_SECS(sbi));
 		hint = 0;
 	} else if (alloc_policy == ALLOCATE_FORWARD_FROM_HINT &&
 		hint < alloc_hint) {
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 5949aa5200ac1..6c3af51f352c4 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -91,6 +91,17 @@ static inline void sanity_check_seg_type(struct f2fs_sb_info *sbi,
 #define GET_ZONE_FROM_SEG(sbi, segno)				\
 	GET_ZONE_FROM_SEC(sbi, GET_SEC_FROM_SEG(sbi, segno))
 
+static inline void f2fs_adjust_pinned_area_boundary(struct f2fs_sb_info *sbi)
+{
+	sbi->pinned_area_max_secno = MAIN_SECS(sbi);
+	if (f2fs_sb_has_blkzoned(sbi) && sbi->first_seq_zone_segno != NULL_SEGNO)
+		sbi->pinned_area_max_secno = min(sbi->pinned_area_max_secno,
+				GET_SEC_FROM_SEG(sbi, sbi->first_seq_zone_segno));
+	if (F2FS_OPTION(sbi).resizable_tail_secno)
+		sbi->pinned_area_max_secno = min(sbi->pinned_area_max_secno,
+				MAIN_SECS(sbi) - F2FS_OPTION(sbi).resizable_tail_secno);
+}
+
 #define GET_SUM_BLOCK(sbi, segno)	\
 	(SM_I(sbi)->ssa_blkaddr + (segno / (sbi)->sums_per_block))
 #define GET_SUM_BLKOFF(sbi, segno) (segno % (sbi)->sums_per_block)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 09bc78f2d0b58..c422a0d15260c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -554,17 +554,6 @@ static inline void adjust_unusable_cap_perc(struct f2fs_sb_info *sbi)
 			F2FS_OPTION(sbi).unusable_cap_perc);
 }
 
-static inline void adjust_pinned_area_boundary(struct f2fs_sb_info *sbi)
-{
-	sbi->pinned_area_max_secno = MAIN_SECS(sbi);
-	if (f2fs_sb_has_blkzoned(sbi) && sbi->first_seq_zone_segno != NULL_SEGNO)
-		sbi->pinned_area_max_secno = min(sbi->pinned_area_max_secno,
-				GET_SEC_FROM_SEG(sbi, sbi->first_seq_zone_segno));
-	if (F2FS_OPTION(sbi).resizable_tail_secno)
-		sbi->pinned_area_max_secno = min(sbi->pinned_area_max_secno,
-				MAIN_SECS(sbi) - F2FS_OPTION(sbi).resizable_tail_secno);
-}
-
 static void init_once(void *foo)
 {
 	struct f2fs_inode_info *fi = (struct f2fs_inode_info *) foo;
@@ -3098,7 +3087,7 @@ static int __f2fs_remount(struct fs_context *fc, struct super_block *sb)
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sbi, POSIX_ACL) ? SB_POSIXACL : 0);
 
-	adjust_pinned_area_boundary(sbi);
+	f2fs_adjust_pinned_area_boundary(sbi);
 	limit_reserve_root(sbi);
 	fc->sb_flags = (flags & ~SB_LAZYTIME) | (sb->s_flags & SB_LAZYTIME);
 
@@ -5414,7 +5403,7 @@ static int f2fs_fill_super(struct super_block *sb, struct fs_context *fc)
 	/* get segno of first zoned block device */
 	sbi->first_seq_zone_segno = get_first_seq_zone_segno(sbi);
 
-	adjust_pinned_area_boundary(sbi);
+	f2fs_adjust_pinned_area_boundary(sbi);
 
 	sbi->reserved_pin_section = f2fs_sb_has_blkzoned(sbi) ?
 			ZONED_PIN_SEC_REQUIRED_COUNT :
-- 
2.53.0



