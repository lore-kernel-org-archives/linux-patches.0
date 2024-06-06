Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E1F1C0DD2;
	Thu,  6 Jun 2024 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683559; cv=none; b=ct3dAbzlEU9qAziYOEjXWBZIsPFyOVNrL46oFyh+XgHxJDEPcg1T0Nz0/I/TG2aZW0QvSizwqYDGbsXT+XIJ7swgkID3SR1m4jTD+tbybu5hDm/UVqMCgrBTpasCYGKzWDcUO9T+jefAvmTKWy+c/ct32iAC3a1C6VeM6x4nk+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683559; c=relaxed/simple;
	bh=iPSPUlhtX9rR0EHlP01vy7qvACxutL/yMkHVa57pXuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFm1J0UDBHumlhjghZG3TsBHCvZCYmR4d0iHHqsS5l6IrX7ONwnpAg9m1WjzXQyCfHLqXiT80pBZYQvQwt61ogrbXH2Ay/n5RmrFLn34J2HyJxuKUUn4Uf2Mj4YHvXYJDf8xS+kvIsnszA2UA+UsdPvOD2+T2e0t+StiqZ2pihs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaiYO2Tt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaiYO2Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E05C4AF08;
	Thu,  6 Jun 2024 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683559;
	bh=iPSPUlhtX9rR0EHlP01vy7qvACxutL/yMkHVa57pXuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaiYO2TtXkiQsrDeZCW8b3k9kxah/sKGMJzWLkBaDAbaF8Ccwy27Rg7DbDFer7CaE
	 fwG7nFHE2mXaOeA9ZApBIdO28ZAfYqasZRn6pdh0RHEg0y/BPP2IIS66vcAKEzMDT7
	 D2c4SP1icgMzcZyUteGU2w1u89lMuJC26UTRw5fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 501/744] f2fs: support printk_ratelimited() in f2fs_printk()
Date: Thu,  6 Jun 2024 16:02:53 +0200
Message-ID: <20240606131748.508156729@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit b1c9d3f833ba60a288db111d7fe38edfeb9b8fbb ]

This patch supports using printk_ratelimited() in f2fs_printk(), and
wrap ratelimited f2fs_printk() into f2fs_{err,warn,info}_ratelimited(),
then, use these new helps to clean up codes.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aa4074e8fec4 ("f2fs: fix block migration when section is not aligned to pow2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 10 +++++-----
 fs/f2fs/dir.c      |  5 ++---
 fs/f2fs/f2fs.h     | 40 +++++++++++++++++++++++-----------------
 fs/f2fs/super.c    | 11 ++++++++---
 4 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index a7037644b9324..814b570cdf2e7 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -512,8 +512,8 @@ static int lzorle_compress_pages(struct compress_ctx *cc)
 	ret = lzorle1x_1_compress(cc->rbuf, cc->rlen, cc->cbuf->cdata,
 					&cc->clen, cc->private);
 	if (ret != LZO_E_OK) {
-		printk_ratelimited("%sF2FS-fs (%s): lzo-rle compress failed, ret:%d\n",
-				KERN_ERR, F2FS_I_SB(cc->inode)->sb->s_id, ret);
+		f2fs_err_ratelimited(F2FS_I_SB(cc->inode),
+				"lzo-rle compress failed, ret:%d", ret);
 		return -EIO;
 	}
 	return 0;
@@ -780,9 +780,9 @@ void f2fs_decompress_cluster(struct decompress_io_ctx *dic, bool in_task)
 		if (provided != calculated) {
 			if (!is_inode_flag_set(dic->inode, FI_COMPRESS_CORRUPT)) {
 				set_inode_flag(dic->inode, FI_COMPRESS_CORRUPT);
-				printk_ratelimited(
-					"%sF2FS-fs (%s): checksum invalid, nid = %lu, %x vs %x",
-					KERN_INFO, sbi->sb->s_id, dic->inode->i_ino,
+				f2fs_info_ratelimited(sbi,
+					"checksum invalid, nid = %lu, %x vs %x",
+					dic->inode->i_ino,
 					provided, calculated);
 			}
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index e792d35304796..c624ffff6f19a 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -996,9 +996,8 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 		de = &d->dentry[bit_pos];
 		if (de->name_len == 0) {
 			if (found_valid_dirent || !bit_pos) {
-				printk_ratelimited(
-					"%sF2FS-fs (%s): invalid namelen(0), ino:%u, run fsck to fix.",
-					KERN_WARNING, sbi->sb->s_id,
+				f2fs_warn_ratelimited(sbi,
+					"invalid namelen(0), ino:%u, run fsck to fix.",
 					le32_to_cpu(de->ino));
 				set_sbi_flag(sbi, SBI_NEED_FSCK);
 			}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f37907f015873..9e8a3d0db11db 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1808,6 +1808,27 @@ struct f2fs_sb_info {
 #endif
 };
 
+__printf(3, 4)
+void f2fs_printk(struct f2fs_sb_info *sbi, bool limit_rate, const char *fmt, ...);
+
+#define f2fs_err(sbi, fmt, ...)						\
+	f2fs_printk(sbi, false, KERN_ERR fmt, ##__VA_ARGS__)
+#define f2fs_warn(sbi, fmt, ...)					\
+	f2fs_printk(sbi, false, KERN_WARNING fmt, ##__VA_ARGS__)
+#define f2fs_notice(sbi, fmt, ...)					\
+	f2fs_printk(sbi, false, KERN_NOTICE fmt, ##__VA_ARGS__)
+#define f2fs_info(sbi, fmt, ...)					\
+	f2fs_printk(sbi, false, KERN_INFO fmt, ##__VA_ARGS__)
+#define f2fs_debug(sbi, fmt, ...)					\
+	f2fs_printk(sbi, false, KERN_DEBUG fmt, ##__VA_ARGS__)
+
+#define f2fs_err_ratelimited(sbi, fmt, ...)				\
+	f2fs_printk(sbi, true, KERN_ERR fmt, ##__VA_ARGS__)
+#define f2fs_warn_ratelimited(sbi, fmt, ...)				\
+	f2fs_printk(sbi, true, KERN_WARNING fmt, ##__VA_ARGS__)
+#define f2fs_info_ratelimited(sbi, fmt, ...)				\
+	f2fs_printk(sbi, true, KERN_INFO fmt, ##__VA_ARGS__)
+
 #ifdef CONFIG_F2FS_FAULT_INJECTION
 #define time_to_inject(sbi, type) __time_to_inject(sbi, type, __func__,	\
 									__builtin_return_address(0))
@@ -1825,9 +1846,8 @@ static inline bool __time_to_inject(struct f2fs_sb_info *sbi, int type,
 	atomic_inc(&ffi->inject_ops);
 	if (atomic_read(&ffi->inject_ops) >= ffi->inject_rate) {
 		atomic_set(&ffi->inject_ops, 0);
-		printk_ratelimited("%sF2FS-fs (%s) : inject %s in %s of %pS\n",
-			KERN_INFO, sbi->sb->s_id, f2fs_fault_name[type],
-			func, parent_func);
+		f2fs_info_ratelimited(sbi, "inject %s in %s of %pS",
+				f2fs_fault_name[type], func, parent_func);
 		return true;
 	}
 	return false;
@@ -2321,20 +2341,6 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 	return -ENOSPC;
 }
 
-__printf(2, 3)
-void f2fs_printk(struct f2fs_sb_info *sbi, const char *fmt, ...);
-
-#define f2fs_err(sbi, fmt, ...)						\
-	f2fs_printk(sbi, KERN_ERR fmt, ##__VA_ARGS__)
-#define f2fs_warn(sbi, fmt, ...)					\
-	f2fs_printk(sbi, KERN_WARNING fmt, ##__VA_ARGS__)
-#define f2fs_notice(sbi, fmt, ...)					\
-	f2fs_printk(sbi, KERN_NOTICE fmt, ##__VA_ARGS__)
-#define f2fs_info(sbi, fmt, ...)					\
-	f2fs_printk(sbi, KERN_INFO fmt, ##__VA_ARGS__)
-#define f2fs_debug(sbi, fmt, ...)					\
-	f2fs_printk(sbi, KERN_DEBUG fmt, ##__VA_ARGS__)
-
 #define PAGE_PRIVATE_GET_FUNC(name, flagname) \
 static inline bool page_private_##name(struct page *page) \
 { \
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ab437022ea56f..5fdb75b74cf80 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -248,7 +248,8 @@ static match_table_t f2fs_tokens = {
 	{Opt_err, NULL},
 };
 
-void f2fs_printk(struct f2fs_sb_info *sbi, const char *fmt, ...)
+void f2fs_printk(struct f2fs_sb_info *sbi, bool limit_rate,
+						const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -259,8 +260,12 @@ void f2fs_printk(struct f2fs_sb_info *sbi, const char *fmt, ...)
 	level = printk_get_level(fmt);
 	vaf.fmt = printk_skip_level(fmt);
 	vaf.va = &args;
-	printk("%c%cF2FS-fs (%s): %pV\n",
-	       KERN_SOH_ASCII, level, sbi->sb->s_id, &vaf);
+	if (limit_rate)
+		printk_ratelimited("%c%cF2FS-fs (%s): %pV\n",
+			KERN_SOH_ASCII, level, sbi->sb->s_id, &vaf);
+	else
+		printk("%c%cF2FS-fs (%s): %pV\n",
+			KERN_SOH_ASCII, level, sbi->sb->s_id, &vaf);
 
 	va_end(args);
 }
-- 
2.43.0



