Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBB238736C;
	Sat, 12 Sep 2026 09:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204236; cv=none; b=NBY6LfyZq2ZxxRJn/ZYbkjAbhz1xLZlSBSiDXFAsuAA8aNzef6U9T/BfxsX97jnORK3RhDQ7e87dkCJiZeAHCtS+kMXd3xffz8Fb4ReWbh98ysx1YqMTYKn/UnrSRiKe0DxGjOfAEa0CXteM3EWs83gXujcffVS/jnHKOZYpoec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204236; c=relaxed/simple;
	bh=102TbtrPrBOq26sXeEhHEOojlWocNeCAQdtgjoDWPco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLj0Fmz2eZ3GYnndTasVdkCwlc847hYyR7HBlnTSGMuOX1EHHw4K5pQsNDUU/KcMb06gjnk/PmpCqVbfdYB3kJw1h1NaD/0I9iH87Nh/GoHjC4XZv/Nm8TPFF/2aYvmSNcNPM3I7dgabI7OgQ9tJcLpH/xe5fk6cBhpEqbO8lvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmEEfxIN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmEEfxIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE841F000FF;
	Sat, 12 Sep 2026 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204235;
	bh=I7tJ7kLGa4tcThW2WxFS1BOJTr3JWVdzur0X0mu4IqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmEEfxINBiMCOM0bq/oFTg59U9bqWQ24uNgX5c5iyv/Mz3SVhJIijTuhHKwEX0biE
	 z8aFNaVYcPJmfR+qaBz+uhiso41y2gyIi0NxcSb2I5dPnlHONO1BkiqhtGGz+qUGI0
	 RWR+0oniR6At1h9WQNSbkZxCsFPiXTIvKJOsabDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1572/1815] f2fs: fix to avoid pinfile fragment on fragment:{block, segment} mode
Date: Sat, 12 Sep 2026 08:55:22 +0200
Message-ID: <20260912065725.896926869@linuxfoundation.org>
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

[ Upstream commit 0a1703eba23707e3b2edfa2a2329352e7abc0ffa ]

pinfile fallocate() conflicts w/ mode=fragment:{block,segment} mount option,
result in fragment blocks in pinfile, it violate semantics of pinfile
introduced in commit f5a53edcf01e ("f2fs: support aligned pinned file").

mkfs.f2fs -f /dev/vdb
mount -t f2fs -o mode=fragment:block /dev/vdb /mnt/f2fs/
dd if=/dev/zero of=/mnt/f2fs/file bs=1M count=3900
sync
touch /mnt/f2fs/pinfile
f2fs_io pinfile set /mnt/f2fs/pinfile
f2fs_io fallocate 0 0 $((1024*1024*16)) /mnt/f2fs/pinfile
sync
f2fs_io fiemap 0 $((1024*1024*16)) /mnt/f2fs/pinfile

[Before]
fallocate failed: No space left on device
Fiemap: offset = 0 len = 16777216
        logical addr.    physical addr.   length           flags
0       0000000000000000 00000000d7200000 0000000000004000 00001000
1       0000000000004000 00000000d7207000 0000000000001000 00001000
2       0000000000005000 00000000d720c000 0000000000002000 00001000
3       0000000000007000 00000000d7211000 0000000000001000 00001000
4       0000000000008000 00000000d7214000 0000000000001000 00001000
5       0000000000009000 00000000d7218000 0000000000001000 00001000
6       000000000000a000 00000000d721d000 0000000000001000 00001000
7       000000000000b000 00000000d721f000 0000000000004000 00001000
...
96      00000000000f1000 00000000d73e9000 0000000000004000 00001000
97      00000000000f5000 00000000d73f1000 0000000000003000 00001000
98      00000000000f8000 00000000d73f5000 0000000000004000 00001000
99      00000000000fc000 00000000d73fa000 0000000000001000 00001000
100     00000000000fd000 00000000d73ff000 0000000000001000 00001001

[After]
fallocated a file: i_size=16777216, i_blocks=32808
Fiemap: offset = 0 len = 16777216
        logical addr.    physical addr.   length           flags
0       0000000000000000 0000000018a00000 0000000000400000 00001000
1       0000000000400000 0000000019000000 0000000000400000 00001000
2       0000000000800000 0000000032400000 0000000000200000 00001000
3       0000000000a00000 0000000038000000 0000000000200000 00001000
4       0000000000c00000 0000000039c00000 0000000000200000 00001000
5       0000000000e00000 0000000044c00000 0000000000200000 00001001

Let's ignore mode=fragment:{block,segment} mount option while fallocate()
on pinfile.

Fixes: 6691d940b0e0 ("f2fs: introduce fragment allocation mode mount option")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    | 15 +++++++++++----
 fs/f2fs/gc.c      |  2 +-
 fs/f2fs/segment.c |  8 ++++----
 fs/f2fs/super.c   |  4 ++--
 4 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e3ff6979bae0b..bc2246abd421b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4123,19 +4123,26 @@ static inline struct inode *fio_inode(struct f2fs_io_info *fio)
 #define MIN_FRAGMENT_SIZE	1
 #define MAX_FRAGMENT_SIZE	512
 
-static inline bool f2fs_need_rand_blk(struct f2fs_sb_info *sbi)
+static inline bool f2fs_need_rand_blk(struct f2fs_sb_info *sbi,
+					enum log_type type)
 {
+	if (type == CURSEG_COLD_DATA_PINNED)
+		return false;
 	return F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK;
 }
 
-static inline bool f2fs_need_rand_seg(struct f2fs_sb_info *sbi)
+static inline bool f2fs_need_rand_seg(struct f2fs_sb_info *sbi,
+					enum log_type type)
 {
+	if (type == CURSEG_COLD_DATA_PINNED)
+		return false;
 	return F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_SEG;
 }
 
-static inline bool f2fs_need_rand_seg_blk(struct f2fs_sb_info *sbi)
+static inline bool f2fs_need_rand_seg_blk(struct f2fs_sb_info *sbi,
+					enum log_type type)
 {
-	return f2fs_need_rand_blk(sbi) || f2fs_need_rand_seg(sbi);
+	return f2fs_need_rand_blk(sbi, type) || f2fs_need_rand_seg(sbi, type);
 }
 
 /*
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e243b25f683d3..c771adedff39c 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -310,7 +310,7 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 		p->max_search = sbi->max_victim_search;
 
 	/* let's select beginning hot/small space first. */
-	if (f2fs_need_rand_seg_blk(sbi)) {
+	if (f2fs_need_rand_seg_blk(sbi, type)) {
 		p->offset = get_random_u32_below(MAIN_SECS(sbi) *
 						SEGS_PER_SEC(sbi));
 		SIT_I(sbi)->last_victim[p->gc_mode] = p->offset;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a124deba1dcc9..8830e1892b435 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2936,7 +2936,7 @@ static unsigned int __get_next_segno(struct f2fs_sb_info *sbi, int type)
 
 	sanity_check_seg_type(sbi, seg_type);
 	if (__is_large_section(sbi)) {
-		if (f2fs_need_rand_seg_blk(sbi)) {
+		if (f2fs_need_rand_seg_blk(sbi, type)) {
 			unsigned int hint = GET_SEC_FROM_SEG(sbi, curseg->segno);
 
 			if (GET_SEC_FROM_SEG(sbi, curseg->segno + 1) != hint)
@@ -2945,7 +2945,7 @@ static unsigned int __get_next_segno(struct f2fs_sb_info *sbi, int type)
 					GET_SEG_FROM_SEC(sbi, hint + 1) - 1);
 		}
 		return curseg->segno;
-	} else if (f2fs_need_rand_seg_blk(sbi)) {
+	} else if (f2fs_need_rand_seg_blk(sbi, type)) {
 		return get_random_u32_below(MAIN_SECS(sbi) * SEGS_PER_SEC(sbi));
 	}
 
@@ -3001,7 +3001,7 @@ static int new_curseg(struct f2fs_sb_info *sbi, int type, bool new_sec)
 	curseg->next_segno = segno;
 	reset_curseg(sbi, type, 1);
 	curseg->alloc_type = LFS;
-	if (f2fs_need_rand_blk(sbi))
+	if (f2fs_need_rand_blk(sbi, type))
 		curseg->fragment_remained_chunk =
 				get_random_u32_inclusive(1, sbi->max_fragment_chunk);
 	return 0;
@@ -3822,7 +3822,7 @@ int f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct folio *folio,
 		curseg->next_blkoff = f2fs_find_next_ssr_block(sbi, curseg);
 	} else {
 		curseg->next_blkoff++;
-		if (f2fs_need_rand_blk(sbi))
+		if (f2fs_need_rand_blk(sbi, type))
 			f2fs_randomize_chunk(sbi, curseg);
 	}
 	if (curseg->next_blkoff >= f2fs_usable_blks_in_seg(sbi, curseg->segno))
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f47cd71a85278..7f6c4e9d3735a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2456,9 +2456,9 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, "adaptive");
 	else if (F2FS_OPTION(sbi).fs_mode == FS_MODE_LFS)
 		seq_puts(seq, "lfs");
-	else if (f2fs_need_rand_seg(sbi))
+	else if (f2fs_need_rand_seg(sbi, NO_CHECK_TYPE))
 		seq_puts(seq, "fragment:segment");
-	else if (f2fs_need_rand_blk(sbi))
+	else if (f2fs_need_rand_blk(sbi, NO_CHECK_TYPE))
 		seq_puts(seq, "fragment:block");
 	seq_printf(seq, ",active_logs=%u", F2FS_OPTION(sbi).active_logs);
 	if (test_opt(sbi, RESERVE_ROOT) || test_opt(sbi, RESERVE_NODE))
-- 
2.53.0



