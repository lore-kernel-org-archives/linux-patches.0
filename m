Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503AD5FB90;
	Tue, 13 Feb 2024 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845174; cv=none; b=tzkwvQtNYKe2HDAWeZOuZiFy1Up2WR6X+x0Ivm4L1Jw8UIBCwdOB1nJl9ogsmf04OeY/08+eJeIJUONYNlacuZNx/Vb4HrCx+RpqUAB+JJQ92g+rlkNWy1VhMhoRGknZdiPDPoXxGB9eVuFcKa65mNEV/zOUBo/zBbmbs/csbTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845174; c=relaxed/simple;
	bh=gW+yIj16YQ5xtmJhdirfRSSTcX8r7QLbwldz35qDcMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7Fx/ns6FJXJA58eeBOi3rWq4xnOwc3D3VYdogoMKs8+0LqtRLsFrURZZLAW8EMgiNl/9K1QxFAnqCKh2bD91NW2tmhEcZSLvGYCBDHgFbES2cD7dL61IlXna8pboLREEshhBsymmENnP1Msf2MXOrIrcY1A/CnE8yJKTFmGLSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrRNg3C3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrRNg3C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C91C433C7;
	Tue, 13 Feb 2024 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845174;
	bh=gW+yIj16YQ5xtmJhdirfRSSTcX8r7QLbwldz35qDcMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrRNg3C33MBxA4+FAKrbfdIWkCzLiaVqS3oG0cP01/V7MQ4MGhD9OCi8lqv/pk02q
	 rhHxsZoQ8ExGAV+/U04k3pv/nW4Iox1bvshQE00+bd5DKIgA3jHW+X6dMfZrLYgCnG
	 KUNtnzV8Gd7VxS/UfTbrAiNyxcGpVgeqkaW9GgN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 62/64] f2fs: add helper to check compression level
Date: Tue, 13 Feb 2024 18:21:48 +0100
Message-ID: <20240213171846.687877423@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng Yong <shengyong@oppo.com>

commit c571fbb5b59a3741e48014faa92c2f14bc59fe50 upstream.

This patch adds a helper function to check if compression level is
valid.

Meanwhile, this patch fixes a reported issue [1]:

The issue is easily reproducible by:

1. dd if=/dev/zero of=test.img count=100 bs=1M
2. mkfs.f2fs -f -O compression,extra_attr ./test.img
3. mount -t f2fs -o compress_algorithm=zstd:6,compress_chksum,atgc,gc_merge,lazytime ./test.img /mnt

resulting in

[   60.789982] F2FS-fs (loop0): invalid zstd compress level: 6

A bugzilla report has been submitted in
https://bugzilla.kernel.org/show_bug.cgi?id=218471

[1] https://lore.kernel.org/lkml/ZcWDOjKEnPDxZ0Or@google.com/T/

The root cause is commit 00e120b5e4b5 ("f2fs: assign default compression
level") tries to check low boundary of compress level w/ zstd_min_clevel(),
however, since commit e0c1b49f5b67 ("lib: zstd: Upgrade to latest upstream
zstd version 1.4.10"), zstd supports negative compress level, it cast type
for negative value returned from zstd_min_clevel() to unsigned int in below
check condition, result in repored issue.

	if (level < zstd_min_clevel() || ...

This patch fixes this issue by casting type for level to int before
comparison.

Fixes: 00e120b5e4b5 ("f2fs: assign default compression level")
Signed-off-by: Sheng Yong <shengyong@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |   27 +++++++++++++++++++++++++++
 fs/f2fs/f2fs.h     |    2 ++
 fs/f2fs/super.c    |    4 ++--
 3 files changed, 31 insertions(+), 2 deletions(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -55,6 +55,7 @@ struct f2fs_compress_ops {
 	int (*init_decompress_ctx)(struct decompress_io_ctx *dic);
 	void (*destroy_decompress_ctx)(struct decompress_io_ctx *dic);
 	int (*decompress_pages)(struct decompress_io_ctx *dic);
+	bool (*is_level_valid)(int level);
 };
 
 static unsigned int offset_in_cluster(struct compress_ctx *cc, pgoff_t index)
@@ -322,11 +323,21 @@ static int lz4_decompress_pages(struct d
 	return 0;
 }
 
+static bool lz4_is_level_valid(int lvl)
+{
+#ifdef CONFIG_F2FS_FS_LZ4HC
+	return !lvl || (lvl >= LZ4HC_MIN_CLEVEL && lvl <= LZ4HC_MAX_CLEVEL);
+#else
+	return lvl == 0;
+#endif
+}
+
 static const struct f2fs_compress_ops f2fs_lz4_ops = {
 	.init_compress_ctx	= lz4_init_compress_ctx,
 	.destroy_compress_ctx	= lz4_destroy_compress_ctx,
 	.compress_pages		= lz4_compress_pages,
 	.decompress_pages	= lz4_decompress_pages,
+	.is_level_valid		= lz4_is_level_valid,
 };
 #endif
 
@@ -490,6 +501,11 @@ static int zstd_decompress_pages(struct
 	return 0;
 }
 
+static bool zstd_is_level_valid(int lvl)
+{
+	return lvl >= zstd_min_clevel() && lvl <= zstd_max_clevel();
+}
+
 static const struct f2fs_compress_ops f2fs_zstd_ops = {
 	.init_compress_ctx	= zstd_init_compress_ctx,
 	.destroy_compress_ctx	= zstd_destroy_compress_ctx,
@@ -497,6 +513,7 @@ static const struct f2fs_compress_ops f2
 	.init_decompress_ctx	= zstd_init_decompress_ctx,
 	.destroy_decompress_ctx	= zstd_destroy_decompress_ctx,
 	.decompress_pages	= zstd_decompress_pages,
+	.is_level_valid		= zstd_is_level_valid,
 };
 #endif
 
@@ -555,6 +572,16 @@ bool f2fs_is_compress_backend_ready(stru
 	return f2fs_cops[F2FS_I(inode)->i_compress_algorithm];
 }
 
+bool f2fs_is_compress_level_valid(int alg, int lvl)
+{
+	const struct f2fs_compress_ops *cops = f2fs_cops[alg];
+
+	if (cops->is_level_valid)
+		return cops->is_level_valid(lvl);
+
+	return lvl == 0;
+}
+
 static mempool_t *compress_page_pool;
 static int num_compress_pages = 512;
 module_param(num_compress_pages, uint, 0444);
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4219,6 +4219,7 @@ bool f2fs_compress_write_end(struct inod
 int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock);
 void f2fs_compress_write_end_io(struct bio *bio, struct page *page);
 bool f2fs_is_compress_backend_ready(struct inode *inode);
+bool f2fs_is_compress_level_valid(int alg, int lvl);
 int f2fs_init_compress_mempool(void);
 void f2fs_destroy_compress_mempool(void);
 void f2fs_decompress_cluster(struct decompress_io_ctx *dic, bool in_task);
@@ -4283,6 +4284,7 @@ static inline bool f2fs_is_compress_back
 	/* not support compression */
 	return false;
 }
+static inline bool f2fs_is_compress_level_valid(int alg, int lvl) { return false; }
 static inline struct page *f2fs_compress_control_page(struct page *page)
 {
 	WARN_ON_ONCE(1);
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -628,7 +628,7 @@ static int f2fs_set_lz4hc_level(struct f
 	if (kstrtouint(str + 1, 10, &level))
 		return -EINVAL;
 
-	if (level < LZ4HC_MIN_CLEVEL || level > LZ4HC_MAX_CLEVEL) {
+	if (!f2fs_is_compress_level_valid(COMPRESS_LZ4, level)) {
 		f2fs_info(sbi, "invalid lz4hc compress level: %d", level);
 		return -EINVAL;
 	}
@@ -666,7 +666,7 @@ static int f2fs_set_zstd_level(struct f2
 	if (kstrtouint(str + 1, 10, &level))
 		return -EINVAL;
 
-	if (level < zstd_min_clevel() || level > zstd_max_clevel()) {
+	if (!f2fs_is_compress_level_valid(COMPRESS_ZSTD, level)) {
 		f2fs_info(sbi, "invalid zstd compress level: %d", level);
 		return -EINVAL;
 	}


