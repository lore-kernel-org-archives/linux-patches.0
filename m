Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F91472091;
	Sat, 12 Sep 2026 11:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211611; cv=none; b=l1zcDW8US+WW+W87dnNgf3nzHABLdVaCD2IZXLGV/e6QowFGmjtp6JdYt9V8ZQgWZgbWG8MCiKoujaqbGgl3gkMJOlFjNzMErIcMtKkBdtw798BUJe6C4a+Gp+pn82HMKiRXk35qkB8Z7XxEMt95cyiffUPOgxRdDUQZjepFKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211611; c=relaxed/simple;
	bh=7MmMkgcGiUYZLJFUNuLic05bjrhMkehEmUTTcPHT+YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7ve5MUoLx78k6BLa/cpFBvq9JBftp8EIUiJSvOFhsx6R8izz29ih9scqBrivnCENOqV0Il19lX163qwoyq0jBQyxvgekUI/1B67znPW5kU1E5T3botM1J2jm94UZ9RHqa2j+xxvgo0cBzxRnHSMyMvwyp0rBt+o0XC61P8B8aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkRRD9D/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkRRD9D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30E61F000FF;
	Sat, 12 Sep 2026 11:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211610;
	bh=LJcNefxGhNGOHVy5nHbj57goJKnrn9T62zH1EkdNLNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkRRD9D/P0GDGE7UifyvB1sRKQafIucHmongUlDVKPzRmoO1vsUohrwGilOHic9Ir
	 O+bIin5lfrHob1uNM8MvVihnlDHns6MxjocXCV12LGv0oRuk6jcbbCnh21nuGWbZdm
	 j1loTa+V+TAyUofhS+LIE2kqpYyY+SXfFjLTp79E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1266/1518] f2fs: cleanup w/ f2fs_need_rand_{blk, seg, seg_blk}
Date: Sat, 12 Sep 2026 08:57:15 +0200
Message-ID: <20260912065652.148107077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 6da62bbde487d4678702ef004a911cd1c7a5c746 ]

No logic changes.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 0a1703eba237 ("f2fs: fix to avoid pinfile fragment on fragment:{block, segment} mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    | 13 +++++++++++--
 fs/f2fs/gc.c      |  2 +-
 fs/f2fs/segment.c |  8 ++++----
 fs/f2fs/super.c   |  4 ++--
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f1d7a22293b37..25e5285e2e032 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4019,10 +4019,19 @@ static inline struct inode *fio_inode(struct f2fs_io_info *fio)
 #define MIN_FRAGMENT_SIZE	1
 #define MAX_FRAGMENT_SIZE	512
 
+static inline bool f2fs_need_rand_blk(struct f2fs_sb_info *sbi)
+{
+	return F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK;
+}
+
 static inline bool f2fs_need_rand_seg(struct f2fs_sb_info *sbi)
 {
-	return F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_SEG ||
-		F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK;
+	return F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_SEG;
+}
+
+static inline bool f2fs_need_rand_seg_blk(struct f2fs_sb_info *sbi)
+{
+	return f2fs_need_rand_blk(sbi) || f2fs_need_rand_seg(sbi);
 }
 
 /*
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 16e656681a1d8..9951255b86846 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -312,7 +312,7 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 		p->max_search = sbi->max_victim_search;
 
 	/* let's select beginning hot/small space first. */
-	if (f2fs_need_rand_seg(sbi)) {
+	if (f2fs_need_rand_seg_blk(sbi)) {
 		p->offset = get_random_u32_below(MAIN_SECS(sbi) *
 						SEGS_PER_SEC(sbi));
 		SIT_I(sbi)->last_victim[p->gc_mode] = p->offset;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 5e2789cd96b5e..d6814f7093496 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2964,7 +2964,7 @@ static unsigned int __get_next_segno(struct f2fs_sb_info *sbi, int type)
 
 	sanity_check_seg_type(sbi, seg_type);
 	if (__is_large_section(sbi)) {
-		if (f2fs_need_rand_seg(sbi)) {
+		if (f2fs_need_rand_seg_blk(sbi)) {
 			unsigned int hint = GET_SEC_FROM_SEG(sbi, curseg->segno);
 
 			if (GET_SEC_FROM_SEG(sbi, curseg->segno + 1) != hint)
@@ -2973,7 +2973,7 @@ static unsigned int __get_next_segno(struct f2fs_sb_info *sbi, int type)
 					GET_SEG_FROM_SEC(sbi, hint + 1) - 1);
 		}
 		return curseg->segno;
-	} else if (f2fs_need_rand_seg(sbi)) {
+	} else if (f2fs_need_rand_seg_blk(sbi)) {
 		return get_random_u32_below(MAIN_SECS(sbi) * SEGS_PER_SEC(sbi));
 	}
 
@@ -3029,7 +3029,7 @@ static int new_curseg(struct f2fs_sb_info *sbi, int type, bool new_sec)
 	curseg->next_segno = segno;
 	reset_curseg(sbi, type, 1);
 	curseg->alloc_type = LFS;
-	if (F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK)
+	if (f2fs_need_rand_blk(sbi))
 		curseg->fragment_remained_chunk =
 				get_random_u32_inclusive(1, sbi->max_fragment_chunk);
 	return 0;
@@ -3832,7 +3832,7 @@ int f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct folio *folio,
 		curseg->next_blkoff = f2fs_find_next_ssr_block(sbi, curseg);
 	} else {
 		curseg->next_blkoff++;
-		if (F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK)
+		if (f2fs_need_rand_blk(sbi))
 			f2fs_randomize_chunk(sbi, curseg);
 	}
 	if (curseg->next_blkoff >= f2fs_usable_blks_in_seg(sbi, curseg->segno))
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6f787cbeefd09..c1cd66c1897a1 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2401,9 +2401,9 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, "adaptive");
 	else if (F2FS_OPTION(sbi).fs_mode == FS_MODE_LFS)
 		seq_puts(seq, "lfs");
-	else if (F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_SEG)
+	else if (f2fs_need_rand_seg(sbi))
 		seq_puts(seq, "fragment:segment");
-	else if (F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK)
+	else if (f2fs_need_rand_blk(sbi))
 		seq_puts(seq, "fragment:block");
 	seq_printf(seq, ",active_logs=%u", F2FS_OPTION(sbi).active_logs);
 	if (test_opt(sbi, RESERVE_ROOT) || test_opt(sbi, RESERVE_NODE))
-- 
2.53.0



