Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE33338736C;
	Sat, 12 Sep 2026 09:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204233; cv=none; b=ZjqjDUHtM+nc61zzaRFQdtBK4CUxYYQnUfwIHifcK7JjJ9EWohn2gkVRkVy49uXZCdt9e5L0k13pvYPCeYwAYh5r75u8FrxVCCPTSfQF42UC2+J9yMmdmW25Ki1e8D8J7OjHkxr6+3/FR6/jnHGKWsGVNpWaONDMiDXYbEA+8gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204233; c=relaxed/simple;
	bh=VTRDENuU5qCwhlKRTz+pscOpOzWlA2v+sY962u+qCwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubHxOLCRCHaCgTZ6yTN4doyUw7wjiNbQTVJ9wjs19isbfn3esaBtpFAQJqHiC+zhXfj76nXhdF3qj/WAXsPYR0SPOaciQqVztk2tPbeWeSPLjJoZGRBWqVenWmwKfsBDezphaU+RW2Bm7ykoy/8UDvAxetl5IoOimSKmmSEYQFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2zJVodC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2zJVodC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1781F000FF;
	Sat, 12 Sep 2026 09:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204231;
	bh=Px3Gb1PijfYkDnbvnsUR9o/N8KwrJipX61riP6FX2BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2zJVodCCP1kUweucVvkwWTzfLXk9V7YG6GDOepyoQV/EFOnBG7uptRKANv2w64x0
	 WQLwYlEPViuvXXoVON7s1veoNPNpaKnIGUllOvgwaS3Mh1y0j4+s1WT9HeLt6S0wL7
	 KnE78BAp3hg1pw3nIoH9pr+f6Mn5WU8cXoNri+MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1571/1815] f2fs: cleanup w/ f2fs_need_rand_{blk, seg, seg_blk}
Date: Sat, 12 Sep 2026 08:55:21 +0200
Message-ID: <20260912065725.874677273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 8011bbdf2c688..e3ff6979bae0b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4123,10 +4123,19 @@ static inline struct inode *fio_inode(struct f2fs_io_info *fio)
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
index 1eda818619747..e243b25f683d3 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -310,7 +310,7 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 		p->max_search = sbi->max_victim_search;
 
 	/* let's select beginning hot/small space first. */
-	if (f2fs_need_rand_seg(sbi)) {
+	if (f2fs_need_rand_seg_blk(sbi)) {
 		p->offset = get_random_u32_below(MAIN_SECS(sbi) *
 						SEGS_PER_SEC(sbi));
 		SIT_I(sbi)->last_victim[p->gc_mode] = p->offset;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 091bfb170d615..a124deba1dcc9 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2936,7 +2936,7 @@ static unsigned int __get_next_segno(struct f2fs_sb_info *sbi, int type)
 
 	sanity_check_seg_type(sbi, seg_type);
 	if (__is_large_section(sbi)) {
-		if (f2fs_need_rand_seg(sbi)) {
+		if (f2fs_need_rand_seg_blk(sbi)) {
 			unsigned int hint = GET_SEC_FROM_SEG(sbi, curseg->segno);
 
 			if (GET_SEC_FROM_SEG(sbi, curseg->segno + 1) != hint)
@@ -2945,7 +2945,7 @@ static unsigned int __get_next_segno(struct f2fs_sb_info *sbi, int type)
 					GET_SEG_FROM_SEC(sbi, hint + 1) - 1);
 		}
 		return curseg->segno;
-	} else if (f2fs_need_rand_seg(sbi)) {
+	} else if (f2fs_need_rand_seg_blk(sbi)) {
 		return get_random_u32_below(MAIN_SECS(sbi) * SEGS_PER_SEC(sbi));
 	}
 
@@ -3001,7 +3001,7 @@ static int new_curseg(struct f2fs_sb_info *sbi, int type, bool new_sec)
 	curseg->next_segno = segno;
 	reset_curseg(sbi, type, 1);
 	curseg->alloc_type = LFS;
-	if (F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK)
+	if (f2fs_need_rand_blk(sbi))
 		curseg->fragment_remained_chunk =
 				get_random_u32_inclusive(1, sbi->max_fragment_chunk);
 	return 0;
@@ -3822,7 +3822,7 @@ int f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct folio *folio,
 		curseg->next_blkoff = f2fs_find_next_ssr_block(sbi, curseg);
 	} else {
 		curseg->next_blkoff++;
-		if (F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK)
+		if (f2fs_need_rand_blk(sbi))
 			f2fs_randomize_chunk(sbi, curseg);
 	}
 	if (curseg->next_blkoff >= f2fs_usable_blks_in_seg(sbi, curseg->segno))
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f7e2dcb58b4db..f47cd71a85278 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2456,9 +2456,9 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
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



