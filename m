Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE9E4E73C7;
	Thu, 17 Sep 2026 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660881; cv=none; b=VwHz7N7JzxnygCq7nCeMOv7w0uUoGrAnCD1srQ17KEkQwW5LYedeCbcoOVjUQjWtksZK7y5/EqIHrj8xjJ/0TMViPD4LGlvZ7prIRIs011CiwrQodBB0cdR6Akl/iFzlxrH4ERj/64g3dG8I8Ep3JPUO3d42BLErwW+GUIwZyF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660881; c=relaxed/simple;
	bh=oSisFCyrymJxvijwagtkBuo9b0JjVm0qmSk01mZzL9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ps8lRxPN7vVrg2hIYYP5yzF9iC8WMXP2yoWqEgO4dceYkmzJ+cvjT9Coror9spEerM0w4Ty4wNGWTxPMWo22GstmVgOWpuy1vqePCYEvOFOzEfry3Z5eZgFxJQqMox7EoOVDnejm5pum86XT/4k0oDUCoV2RJ5iSG1V57pZTVSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvgbxLSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvgbxLSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC0C1F000FF;
	Thu, 17 Sep 2026 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660879;
	bh=t/qHGEZDLFNtV0DsT3w2yajaDGK9JfeIPgf3zcsc/2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvgbxLSsa/jemLFkCBe9FQMzzEw/JUT7Hicarl9+kKCfXWbXlh2tm/W8nhf9YGTGp
	 UMcJTOn3Dcn/YjrUILm5OiR8Si5W/pBQ1k27aWYv4ZqS76gNgnHVSWmkKk+fpfVHxd
	 vsNqzPNU3yySpfWndCkK6Giq5t6tenlZrev+J8cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 707/733] f2fs: fix to shrink gc_lock coverage in f2fs_gc_range()
Date: Thu, 17 Sep 2026 16:16:55 +0100
Message-ID: <20260917151410.493467763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5d49025a4e596c4c9ac0c519ef9f9a2c91396856 ]

In f2fs_allocate_pinning_section(), we will hold gc_lock before calling
f2fs_gc_range() to migrate section in conventional zone, we may suffer
worse case because we may need to traverse and migrate multiple sections
if we failed to move blocks in section due to lot of reasons: ENOMEM,
fail to migrate block of pinfile, racing on i_gc_rwsem.

To avoid hold gc_lock for long time to block checkpoint, let's hold
the lock and only try to migrate one section.

Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Backport notes for Linux 7.2:
The stable tree lacks eae3faf210bdc ("f2fs: support dynamic
reserve/release for device aliasing"). Drop the file.c hunk for the absent
f2fs_ioc_reserve_dev_alias() caller and omit the unrelated
f2fs_reset_gc_victim_resource() declaration from the header resolution.
Keep the per-section gc_lock handling, updated f2fs_gc_range() prototype,
and both callers present in this tree. No functions are added.

This preserves the context needed for 2b8704b6a8b2 ("f2fs: fix to reset
all pinned status during fggc"); its patch applies without conflicts.

[ sashal: Reduced backport -- upstream 5d49025a4e596 touches 4 file(s), this
  backport carries 3. Not backported here:
  fs/f2fs/file.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 2b8704b6a8b2 ("f2fs: fix to reset all pinned status during fggc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h    |    2 +-
 fs/f2fs/gc.c      |   34 +++++++++++++++++++++++++---------
 fs/f2fs/segment.c |    4 +---
 3 files changed, 27 insertions(+), 13 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4271,7 +4271,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, st
 void f2fs_build_gc_manager(struct f2fs_sb_info *sbi);
 int f2fs_gc_range(struct f2fs_sb_info *sbi,
 		unsigned int start_seg, unsigned int end_seg,
-		bool dry_run, unsigned int dry_run_sections);
+		bool dry_run, unsigned int dry_run_sections, bool lock);
 int f2fs_resize_fs(struct file *filp, __u64 block_count);
 int __init f2fs_create_garbage_collection_cache(void);
 void f2fs_destroy_garbage_collection_cache(void);
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2150,8 +2150,9 @@ void f2fs_build_gc_manager(struct f2fs_s
 
 int f2fs_gc_range(struct f2fs_sb_info *sbi,
 		unsigned int start_seg, unsigned int end_seg,
-		bool dry_run, unsigned int dry_run_sections)
+		bool dry_run, unsigned int dry_run_sections, bool lock)
 {
+	struct f2fs_lock_context lc;
 	unsigned int segno;
 	unsigned int gc_secs = dry_run_sections;
 
@@ -2164,28 +2165,43 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 			.ilist = LIST_HEAD_INIT(gc_list.ilist),
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
+		int err = 0;
+
+		if (lock)
+			f2fs_down_write_trace(&sbi->gc_lock, &lc);
 
 		/*
 		 * avoid migrating empty section, as it can be allocated by
 		 * log in parallel.
 		 */
 		if (!get_valid_blocks(sbi, segno, true))
-			continue;
+			goto next;
 
 		if (is_cursec(sbi, GET_SEC_FROM_SEG(sbi, segno)))
-			continue;
+			goto next;
 
 		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true, false);
 		put_gc_inode(&gc_list);
 
-		if (!dry_run && get_valid_blocks(sbi, segno, true))
-			return -EAGAIN;
+		if (!dry_run && get_valid_blocks(sbi, segno, true)) {
+			err = -EAGAIN;
+			goto next;
+		}
 		if (dry_run && dry_run_sections &&
-		    !get_valid_blocks(sbi, segno, true) && --gc_secs == 0)
-			break;
+			!get_valid_blocks(sbi, segno, true)) {
+			--gc_secs;
+			goto next;
+		}
 
 		if (fatal_signal_pending(current))
-			return -ERESTARTSYS;
+			err = -ERESTARTSYS;
+next:
+		if (lock)
+			f2fs_up_write_trace(&sbi->gc_lock, &lc);
+		if (err)
+			return err;
+		if (dry_run && dry_run_sections && !gc_secs)
+			return 0;
 	}
 
 	return 0;
@@ -2233,7 +2249,7 @@ static int free_segment_range(struct f2f
 	}
 
 	/* do GC to move out valid blocks in the range */
-	err = f2fs_gc_range(sbi, start, end, dry_run, 0);
+	err = f2fs_gc_range(sbi, start, end, dry_run, 0, false);
 	if (err || dry_run)
 		goto out;
 
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3357,10 +3357,8 @@ retry:
 	f2fs_unlock_op(sbi, &lc);
 
 	if (f2fs_sb_has_blkzoned(sbi) && err == -EAGAIN && gc_required) {
-		f2fs_down_write_trace(&sbi->gc_lock, &lc);
 		err = f2fs_gc_range(sbi, 0, sbi->first_seq_zone_segno - 1,
-				true, ZONED_PIN_SEC_REQUIRED_COUNT);
-		f2fs_up_write_trace(&sbi->gc_lock, &lc);
+				true, ZONED_PIN_SEC_REQUIRED_COUNT, true);
 		if (err)
 			return err;
 		err = f2fs_sync_fs(sbi->sb, 1);


