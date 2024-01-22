Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E316610F1;
	Tue, 23 Jan 2024 02:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975758; cv=none; b=mBEC/EIGqYTy76aC54YzoBbbY9Eq+1V9q1h6toeknZYh7sLdgRgQuKeCiAM8CSThyiolBB3kO0Agbh4VXBkv1loqOl/rDADsqSovA0szxf1D1ucXAMivzmR5v+cGV5w6cZUxRAFbltXflONeX2lNbV21jEhtyywJRjBPRmnABn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975758; c=relaxed/simple;
	bh=AGr4Ezhm66EDrZhhC+wUG9TjY/H4I399BkRZme46Des=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2Cb9wxzFuYAeKkRl/TBSvRWgT4IYjuv8nrx+55UQibIwbn91sH7a0G2chj6roWs5C0DVqxHCuW7mXI/D0idhIbmgiTOwFW9rpDPh+M984NOH5oNzIxjTo4LI+5ZhfcBmI9Eu8+XvEwmlpHqFH3aGoITYGKtPEaPfTiLDdC/fLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqcUyErD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqcUyErD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BB6C433F1;
	Tue, 23 Jan 2024 02:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975757;
	bh=AGr4Ezhm66EDrZhhC+wUG9TjY/H4I399BkRZme46Des=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqcUyErDIbfrmX7JD7OA0ofix0o5D8Kq/Js4S+2DQunm1fGCdP2Z+siUKfNS47v2f
	 XduVfLxE5G8G32Q0fxG9Ad+Ra69iI4CPBcTtgD8yZSzzp5M0NCQnTRcPUotxN1Zy/m
	 w6/geAdCQRy4M95c0z5SAkJW8Xuoo9k0OCKV1AGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 540/583] erofs: simplify compression configuration parser
Date: Mon, 22 Jan 2024 15:59:51 -0800
Message-ID: <20240122235828.647241452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit efb4fb02cef3ab410b603c8f0e1c67f61d55f542 ]

Move erofs_load_compr_cfgs() into decompressor.c as well as introduce
a callback instead of a hard-coded switch for each algorithm for
simplicity.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231022130957.11398-1-xiang@kernel.org
Stable-dep-of: 118a8cf504d7 ("erofs: fix inconsistent per-file compression format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/compress.h             |  6 +++
 fs/erofs/decompressor.c         | 62 ++++++++++++++++++++++++++--
 fs/erofs/decompressor_deflate.c |  5 ++-
 fs/erofs/decompressor_lzma.c    |  4 +-
 fs/erofs/internal.h             | 38 +----------------
 fs/erofs/super.c                | 72 ++++-----------------------------
 6 files changed, 79 insertions(+), 108 deletions(-)

diff --git a/fs/erofs/compress.h b/fs/erofs/compress.h
index 349c3316ae6b..279933e007d2 100644
--- a/fs/erofs/compress.h
+++ b/fs/erofs/compress.h
@@ -21,6 +21,8 @@ struct z_erofs_decompress_req {
 };
 
 struct z_erofs_decompressor {
+	int (*config)(struct super_block *sb, struct erofs_super_block *dsb,
+		      void *data, int size);
 	int (*decompress)(struct z_erofs_decompress_req *rq,
 			  struct page **pagepool);
 	char *name;
@@ -92,6 +94,10 @@ int z_erofs_fixup_insize(struct z_erofs_decompress_req *rq, const char *padbuf,
 extern const struct z_erofs_decompressor erofs_decompressors[];
 
 /* prototypes for specific algorithms */
+int z_erofs_load_lzma_config(struct super_block *sb,
+			struct erofs_super_block *dsb, void *data, int size);
+int z_erofs_load_deflate_config(struct super_block *sb,
+			struct erofs_super_block *dsb, void *data, int size);
 int z_erofs_lzma_decompress(struct z_erofs_decompress_req *rq,
 			    struct page **pagepool);
 int z_erofs_deflate_decompress(struct z_erofs_decompress_req *rq,
diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 332ec5f74002..e75edc8f1753 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -24,11 +24,11 @@ struct z_erofs_lz4_decompress_ctx {
 	unsigned int oend;
 };
 
-int z_erofs_load_lz4_config(struct super_block *sb,
-			    struct erofs_super_block *dsb,
-			    struct z_erofs_lz4_cfgs *lz4, int size)
+static int z_erofs_load_lz4_config(struct super_block *sb,
+			    struct erofs_super_block *dsb, void *data, int size)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	struct z_erofs_lz4_cfgs *lz4 = data;
 	u16 distance;
 
 	if (lz4) {
@@ -370,19 +370,75 @@ const struct z_erofs_decompressor erofs_decompressors[] = {
 		.name = "interlaced"
 	},
 	[Z_EROFS_COMPRESSION_LZ4] = {
+		.config = z_erofs_load_lz4_config,
 		.decompress = z_erofs_lz4_decompress,
 		.name = "lz4"
 	},
 #ifdef CONFIG_EROFS_FS_ZIP_LZMA
 	[Z_EROFS_COMPRESSION_LZMA] = {
+		.config = z_erofs_load_lzma_config,
 		.decompress = z_erofs_lzma_decompress,
 		.name = "lzma"
 	},
 #endif
 #ifdef CONFIG_EROFS_FS_ZIP_DEFLATE
 	[Z_EROFS_COMPRESSION_DEFLATE] = {
+		.config = z_erofs_load_deflate_config,
 		.decompress = z_erofs_deflate_decompress,
 		.name = "deflate"
 	},
 #endif
 };
+
+int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb)
+{
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
+	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
+	unsigned int algs, alg;
+	erofs_off_t offset;
+	int size, ret = 0;
+
+	if (!erofs_sb_has_compr_cfgs(sbi)) {
+		sbi->available_compr_algs = Z_EROFS_COMPRESSION_LZ4;
+		return z_erofs_load_lz4_config(sb, dsb, NULL, 0);
+	}
+
+	sbi->available_compr_algs = le16_to_cpu(dsb->u1.available_compr_algs);
+	if (sbi->available_compr_algs & ~Z_EROFS_ALL_COMPR_ALGS) {
+		erofs_err(sb, "unidentified algorithms %x, please upgrade kernel",
+			  sbi->available_compr_algs & ~Z_EROFS_ALL_COMPR_ALGS);
+		return -EOPNOTSUPP;
+	}
+
+	erofs_init_metabuf(&buf, sb);
+	offset = EROFS_SUPER_OFFSET + sbi->sb_size;
+	alg = 0;
+	for (algs = sbi->available_compr_algs; algs; algs >>= 1, ++alg) {
+		void *data;
+
+		if (!(algs & 1))
+			continue;
+
+		data = erofs_read_metadata(sb, &buf, &offset, &size);
+		if (IS_ERR(data)) {
+			ret = PTR_ERR(data);
+			break;
+		}
+
+		if (alg >= ARRAY_SIZE(erofs_decompressors) ||
+		    !erofs_decompressors[alg].config) {
+			erofs_err(sb, "algorithm %d isn't enabled on this kernel",
+				  alg);
+			ret = -EOPNOTSUPP;
+		} else {
+			ret = erofs_decompressors[alg].config(sb,
+					dsb, data, size);
+		}
+
+		kfree(data);
+		if (ret)
+			break;
+	}
+	erofs_put_metabuf(&buf);
+	return ret;
+}
diff --git a/fs/erofs/decompressor_deflate.c b/fs/erofs/decompressor_deflate.c
index 19e5bdeb30b6..0e1946a6bda5 100644
--- a/fs/erofs/decompressor_deflate.c
+++ b/fs/erofs/decompressor_deflate.c
@@ -77,9 +77,10 @@ int __init z_erofs_deflate_init(void)
 }
 
 int z_erofs_load_deflate_config(struct super_block *sb,
-				struct erofs_super_block *dsb,
-				struct z_erofs_deflate_cfgs *dfl, int size)
+			struct erofs_super_block *dsb, void *data, int size)
 {
+	struct z_erofs_deflate_cfgs *dfl = data;
+
 	if (!dfl || size < sizeof(struct z_erofs_deflate_cfgs)) {
 		erofs_err(sb, "invalid deflate cfgs, size=%u", size);
 		return -EINVAL;
diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index dee10d22ada9..ba4ec73f4aae 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -72,10 +72,10 @@ int __init z_erofs_lzma_init(void)
 }
 
 int z_erofs_load_lzma_config(struct super_block *sb,
-			     struct erofs_super_block *dsb,
-			     struct z_erofs_lzma_cfgs *lzma, int size)
+			struct erofs_super_block *dsb, void *data, int size)
 {
 	static DEFINE_MUTEX(lzma_resize_mutex);
+	struct z_erofs_lzma_cfgs *lzma = data;
 	unsigned int dict_size, i;
 	struct z_erofs_lzma *strm, *head = NULL;
 	int err;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 4ff88d0dd980..d8de61350dc0 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -469,9 +469,6 @@ int __init z_erofs_init_zip_subsystem(void);
 void z_erofs_exit_zip_subsystem(void);
 int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 				       struct erofs_workgroup *egrp);
-int z_erofs_load_lz4_config(struct super_block *sb,
-			    struct erofs_super_block *dsb,
-			    struct z_erofs_lz4_cfgs *lz4, int len);
 int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
 			    int flags);
 void *erofs_get_pcpubuf(unsigned int requiredpages);
@@ -480,6 +477,7 @@ int erofs_pcpubuf_growsize(unsigned int nrpages);
 void __init erofs_pcpubuf_init(void);
 void erofs_pcpubuf_exit(void);
 int erofs_init_managed_cache(struct super_block *sb);
+int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb);
 #else
 static inline void erofs_shrinker_register(struct super_block *sb) {}
 static inline void erofs_shrinker_unregister(struct super_block *sb) {}
@@ -487,16 +485,6 @@ static inline int erofs_init_shrinker(void) { return 0; }
 static inline void erofs_exit_shrinker(void) {}
 static inline int z_erofs_init_zip_subsystem(void) { return 0; }
 static inline void z_erofs_exit_zip_subsystem(void) {}
-static inline int z_erofs_load_lz4_config(struct super_block *sb,
-				  struct erofs_super_block *dsb,
-				  struct z_erofs_lz4_cfgs *lz4, int len)
-{
-	if (lz4 || dsb->u1.lz4_max_distance) {
-		erofs_err(sb, "lz4 algorithm isn't enabled");
-		return -EINVAL;
-	}
-	return 0;
-}
 static inline void erofs_pcpubuf_init(void) {}
 static inline void erofs_pcpubuf_exit(void) {}
 static inline int erofs_init_managed_cache(struct super_block *sb) { return 0; }
@@ -505,41 +493,17 @@ static inline int erofs_init_managed_cache(struct super_block *sb) { return 0; }
 #ifdef CONFIG_EROFS_FS_ZIP_LZMA
 int __init z_erofs_lzma_init(void);
 void z_erofs_lzma_exit(void);
-int z_erofs_load_lzma_config(struct super_block *sb,
-			     struct erofs_super_block *dsb,
-			     struct z_erofs_lzma_cfgs *lzma, int size);
 #else
 static inline int z_erofs_lzma_init(void) { return 0; }
 static inline int z_erofs_lzma_exit(void) { return 0; }
-static inline int z_erofs_load_lzma_config(struct super_block *sb,
-			     struct erofs_super_block *dsb,
-			     struct z_erofs_lzma_cfgs *lzma, int size) {
-	if (lzma) {
-		erofs_err(sb, "lzma algorithm isn't enabled");
-		return -EINVAL;
-	}
-	return 0;
-}
 #endif	/* !CONFIG_EROFS_FS_ZIP_LZMA */
 
 #ifdef CONFIG_EROFS_FS_ZIP_DEFLATE
 int __init z_erofs_deflate_init(void);
 void z_erofs_deflate_exit(void);
-int z_erofs_load_deflate_config(struct super_block *sb,
-				struct erofs_super_block *dsb,
-				struct z_erofs_deflate_cfgs *dfl, int size);
 #else
 static inline int z_erofs_deflate_init(void) { return 0; }
 static inline int z_erofs_deflate_exit(void) { return 0; }
-static inline int z_erofs_load_deflate_config(struct super_block *sb,
-			struct erofs_super_block *dsb,
-			struct z_erofs_deflate_cfgs *dfl, int size) {
-	if (dfl) {
-		erofs_err(sb, "deflate algorithm isn't enabled");
-		return -EINVAL;
-	}
-	return 0;
-}
 #endif	/* !CONFIG_EROFS_FS_ZIP_DEFLATE */
 
 #ifdef CONFIG_EROFS_FS_ONDEMAND
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 3700af9ee173..cc44fb2e001e 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -156,68 +156,15 @@ void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 	return buffer;
 }
 
-#ifdef CONFIG_EROFS_FS_ZIP
-static int erofs_load_compr_cfgs(struct super_block *sb,
-				 struct erofs_super_block *dsb)
+#ifndef CONFIG_EROFS_FS_ZIP
+static int z_erofs_parse_cfgs(struct super_block *sb,
+			      struct erofs_super_block *dsb)
 {
-	struct erofs_sb_info *sbi = EROFS_SB(sb);
-	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
-	unsigned int algs, alg;
-	erofs_off_t offset;
-	int size, ret = 0;
-
-	sbi->available_compr_algs = le16_to_cpu(dsb->u1.available_compr_algs);
-	if (sbi->available_compr_algs & ~Z_EROFS_ALL_COMPR_ALGS) {
-		erofs_err(sb, "try to load compressed fs with unsupported algorithms %x",
-			  sbi->available_compr_algs & ~Z_EROFS_ALL_COMPR_ALGS);
-		return -EINVAL;
-	}
-
-	erofs_init_metabuf(&buf, sb);
-	offset = EROFS_SUPER_OFFSET + sbi->sb_size;
-	alg = 0;
-	for (algs = sbi->available_compr_algs; algs; algs >>= 1, ++alg) {
-		void *data;
-
-		if (!(algs & 1))
-			continue;
-
-		data = erofs_read_metadata(sb, &buf, &offset, &size);
-		if (IS_ERR(data)) {
-			ret = PTR_ERR(data);
-			break;
-		}
+	if (!dsb->u1.available_compr_algs)
+		return 0;
 
-		switch (alg) {
-		case Z_EROFS_COMPRESSION_LZ4:
-			ret = z_erofs_load_lz4_config(sb, dsb, data, size);
-			break;
-		case Z_EROFS_COMPRESSION_LZMA:
-			ret = z_erofs_load_lzma_config(sb, dsb, data, size);
-			break;
-		case Z_EROFS_COMPRESSION_DEFLATE:
-			ret = z_erofs_load_deflate_config(sb, dsb, data, size);
-			break;
-		default:
-			DBG_BUGON(1);
-			ret = -EFAULT;
-		}
-		kfree(data);
-		if (ret)
-			break;
-	}
-	erofs_put_metabuf(&buf);
-	return ret;
-}
-#else
-static int erofs_load_compr_cfgs(struct super_block *sb,
-				 struct erofs_super_block *dsb)
-{
-	if (dsb->u1.available_compr_algs) {
-		erofs_err(sb, "try to load compressed fs when compression is disabled");
-		return -EINVAL;
-	}
-	return 0;
+	erofs_err(sb, "compression disabled, unable to mount compressed EROFS");
+	return -EOPNOTSUPP;
 }
 #endif
 
@@ -406,10 +353,7 @@ static int erofs_read_superblock(struct super_block *sb)
 	}
 
 	/* parse on-disk compression configurations */
-	if (erofs_sb_has_compr_cfgs(sbi))
-		ret = erofs_load_compr_cfgs(sb, dsb);
-	else
-		ret = z_erofs_load_lz4_config(sb, dsb, NULL, 0);
+	ret = z_erofs_parse_cfgs(sb, dsb);
 	if (ret < 0)
 		goto out;
 
-- 
2.43.0



