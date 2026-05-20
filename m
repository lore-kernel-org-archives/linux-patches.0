Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7629D3F2117;
	Wed, 20 May 2026 17:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298894; cv=none; b=hXrPkKnVmzR1ldKidHttU4cu0EoEwMPVuYoKiz8WzNxJDomYypqBtZyy/IQtLzdHLKNN3+16j2bZgTicHnwif8/FSWbuCLbDzTXXuKdMSf9WKPmPiQ1SGp6EVooo4wUlYVtrk+NGmmrKhOvqTm39r9JY4zFJdvxyLSVbbdAG7c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298894; c=relaxed/simple;
	bh=SI2gTgXVv2joeoL4ZuRiPZzjl8kjNgaSJULqPFoB1Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyontEnOCuHnREZPVFrL8dBNoslXHO5bCGatrzW/YWFiubRXWNdVnzcVdoz5JtNnkuSrEr9Qbz13No27TDq3zBYg9FoN4mAT1nCi9wLcaFyI/bDHtczKBvteFSyDW8Lk/vwkSWX8Dny611Xh1hktt7NjANbu+4tmkfBANwSZyyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggwmfHn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggwmfHn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB10F1F000E9;
	Wed, 20 May 2026 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298893;
	bh=WymQB7MelOeMHKJwYpGC5hpeiZQt0VTj1nvmQtPL69s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggwmfHn3KxNgmjGFMpwNlQBVBC2jJyV3lXzdCN4yH5t4X/RV6acDCBM5wIT9T8e1j
	 9RBalk2SflUvPeOdG6/noUvA9vr1+oKxOIL8F6btuWdmlpJJkiVjF7XhkmslXlUbX2
	 fGgJT5NPV2VdL3SZ6OjDL/ZgFJszsBpdHKqUifiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 585/957] f2fs: expand scalability of f2fs mount option
Date: Wed, 20 May 2026 18:17:48 +0200
Message-ID: <20260520162147.217197864@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

[ Upstream commit 1627a303bca692edc6552630aa2f878c8a726a01 ]

opt field in structure f2fs_mount_info and opt_mask field in structure
f2fs_fs_context is 32-bits variable, now we're running out of available
bits in them, let's expand them to 64-bits for better scalability.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 01968164d947 ("f2fs: fix to preserve previous reserve_{blocks,node} value when remount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  | 85 ++++++++++++++++++++++++++-----------------------
 fs/f2fs/super.c | 36 ++++++++++-----------
 2 files changed, 63 insertions(+), 58 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c0747dd2ce511..b3731ba46f571 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -96,47 +96,52 @@ extern const char *f2fs_fault_name[FAULT_MAX];
 /*
  * For mount options
  */
-#define F2FS_MOUNT_DISABLE_ROLL_FORWARD	0x00000001
-#define F2FS_MOUNT_DISCARD		0x00000002
-#define F2FS_MOUNT_NOHEAP		0x00000004
-#define F2FS_MOUNT_XATTR_USER		0x00000008
-#define F2FS_MOUNT_POSIX_ACL		0x00000010
-#define F2FS_MOUNT_DISABLE_EXT_IDENTIFY	0x00000020
-#define F2FS_MOUNT_INLINE_XATTR		0x00000040
-#define F2FS_MOUNT_INLINE_DATA		0x00000080
-#define F2FS_MOUNT_INLINE_DENTRY	0x00000100
-#define F2FS_MOUNT_FLUSH_MERGE		0x00000200
-#define F2FS_MOUNT_NOBARRIER		0x00000400
-#define F2FS_MOUNT_FASTBOOT		0x00000800
-#define F2FS_MOUNT_READ_EXTENT_CACHE	0x00001000
-#define F2FS_MOUNT_DATA_FLUSH		0x00002000
-#define F2FS_MOUNT_FAULT_INJECTION	0x00004000
-#define F2FS_MOUNT_USRQUOTA		0x00008000
-#define F2FS_MOUNT_GRPQUOTA		0x00010000
-#define F2FS_MOUNT_PRJQUOTA		0x00020000
-#define F2FS_MOUNT_QUOTA		0x00040000
-#define F2FS_MOUNT_INLINE_XATTR_SIZE	0x00080000
-#define F2FS_MOUNT_RESERVE_ROOT		0x00100000
-#define F2FS_MOUNT_DISABLE_CHECKPOINT	0x00200000
-#define F2FS_MOUNT_NORECOVERY		0x00400000
-#define F2FS_MOUNT_ATGC			0x00800000
-#define F2FS_MOUNT_MERGE_CHECKPOINT	0x01000000
-#define	F2FS_MOUNT_GC_MERGE		0x02000000
-#define F2FS_MOUNT_COMPRESS_CACHE	0x04000000
-#define F2FS_MOUNT_AGE_EXTENT_CACHE	0x08000000
-#define F2FS_MOUNT_NAT_BITS		0x10000000
-#define F2FS_MOUNT_INLINECRYPT		0x20000000
-/*
- * Some f2fs environments expect to be able to pass the "lazytime" option
- * string rather than using the MS_LAZYTIME flag, so this must remain.
- */
-#define F2FS_MOUNT_LAZYTIME		0x40000000
-#define F2FS_MOUNT_RESERVE_NODE		0x80000000
+enum f2fs_mount_opt {
+	F2FS_MOUNT_DISABLE_ROLL_FORWARD,
+	F2FS_MOUNT_DISCARD,
+	F2FS_MOUNT_NOHEAP,
+	F2FS_MOUNT_XATTR_USER,
+	F2FS_MOUNT_POSIX_ACL,
+	F2FS_MOUNT_DISABLE_EXT_IDENTIFY,
+	F2FS_MOUNT_INLINE_XATTR,
+	F2FS_MOUNT_INLINE_DATA,
+	F2FS_MOUNT_INLINE_DENTRY,
+	F2FS_MOUNT_FLUSH_MERGE,
+	F2FS_MOUNT_NOBARRIER,
+	F2FS_MOUNT_FASTBOOT,
+	F2FS_MOUNT_READ_EXTENT_CACHE,
+	F2FS_MOUNT_DATA_FLUSH,
+	F2FS_MOUNT_FAULT_INJECTION,
+	F2FS_MOUNT_USRQUOTA,
+	F2FS_MOUNT_GRPQUOTA,
+	F2FS_MOUNT_PRJQUOTA,
+	F2FS_MOUNT_QUOTA,
+	F2FS_MOUNT_INLINE_XATTR_SIZE,
+	F2FS_MOUNT_RESERVE_ROOT,
+	F2FS_MOUNT_DISABLE_CHECKPOINT,
+	F2FS_MOUNT_NORECOVERY,
+	F2FS_MOUNT_ATGC,
+	F2FS_MOUNT_MERGE_CHECKPOINT,
+	F2FS_MOUNT_GC_MERGE,
+	F2FS_MOUNT_COMPRESS_CACHE,
+	F2FS_MOUNT_AGE_EXTENT_CACHE,
+	F2FS_MOUNT_NAT_BITS,
+	F2FS_MOUNT_INLINECRYPT,
+	/*
+	 * Some f2fs environments expect to be able to pass the "lazytime" option
+	 * string rather than using the MS_LAZYTIME flag, so this must remain.
+	 */
+	F2FS_MOUNT_LAZYTIME,
+	F2FS_MOUNT_RESERVE_NODE,
+};
 
 #define F2FS_OPTION(sbi)	((sbi)->mount_opt)
-#define clear_opt(sbi, option)	(F2FS_OPTION(sbi).opt &= ~F2FS_MOUNT_##option)
-#define set_opt(sbi, option)	(F2FS_OPTION(sbi).opt |= F2FS_MOUNT_##option)
-#define test_opt(sbi, option)	(F2FS_OPTION(sbi).opt & F2FS_MOUNT_##option)
+#define clear_opt(sbi, option)		\
+	(F2FS_OPTION(sbi).opt &= ~BIT(F2FS_MOUNT_##option))
+#define set_opt(sbi, option)		\
+	(F2FS_OPTION(sbi).opt |= BIT(F2FS_MOUNT_##option))
+#define test_opt(sbi, option)		\
+	(F2FS_OPTION(sbi).opt & BIT(F2FS_MOUNT_##option))
 
 #define ver_after(a, b)	(typecheck(unsigned long long, a) &&		\
 		typecheck(unsigned long long, b) &&			\
@@ -183,7 +188,7 @@ struct f2fs_rwsem {
 };
 
 struct f2fs_mount_info {
-	unsigned int opt;
+	unsigned long long opt;
 	block_t root_reserved_blocks;	/* root reserved blocks */
 	block_t root_reserved_nodes;	/* root reserved nodes */
 	kuid_t s_resuid;		/* reserved blocks for uid */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 96325bbc70386..8790d9d4348a1 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -352,7 +352,7 @@ static match_table_t f2fs_checkpoint_tokens = {
 
 struct f2fs_fs_context {
 	struct f2fs_mount_info info;
-	unsigned int	opt_mask;	/* Bits changed */
+	unsigned long long opt_mask;	/* Bits changed */
 	unsigned int	spec_mask;
 	unsigned short	qname_mask;
 };
@@ -360,23 +360,23 @@ struct f2fs_fs_context {
 #define F2FS_CTX_INFO(ctx)	((ctx)->info)
 
 static inline void ctx_set_opt(struct f2fs_fs_context *ctx,
-			       unsigned int flag)
+			       enum f2fs_mount_opt flag)
 {
-	ctx->info.opt |= flag;
-	ctx->opt_mask |= flag;
+	ctx->info.opt |= BIT(flag);
+	ctx->opt_mask |= BIT(flag);
 }
 
 static inline void ctx_clear_opt(struct f2fs_fs_context *ctx,
-				 unsigned int flag)
+				 enum f2fs_mount_opt flag)
 {
-	ctx->info.opt &= ~flag;
-	ctx->opt_mask |= flag;
+	ctx->info.opt &= ~BIT(flag);
+	ctx->opt_mask |= BIT(flag);
 }
 
 static inline bool ctx_test_opt(struct f2fs_fs_context *ctx,
-				unsigned int flag)
+				enum f2fs_mount_opt flag)
 {
-	return ctx->info.opt & flag;
+	return ctx->info.opt & BIT(flag);
 }
 
 void f2fs_printk(struct f2fs_sb_info *sbi, bool limit_rate,
@@ -1371,7 +1371,7 @@ static int f2fs_check_compression(struct fs_context *fc,
 			ctx_test_opt(ctx, F2FS_MOUNT_COMPRESS_CACHE))
 			f2fs_info(sbi, "Image doesn't support compression");
 		clear_compression_spec(ctx);
-		ctx->opt_mask &= ~F2FS_MOUNT_COMPRESS_CACHE;
+		ctx->opt_mask &= ~BIT(F2FS_MOUNT_COMPRESS_CACHE);
 		return 0;
 	}
 	if (ctx->spec_mask & F2FS_SPEC_compress_extension) {
@@ -1439,42 +1439,42 @@ static int f2fs_check_opt_consistency(struct fs_context *fc,
 		return -EINVAL;
 
 	if (f2fs_hw_should_discard(sbi) &&
-			(ctx->opt_mask & F2FS_MOUNT_DISCARD) &&
+			(ctx->opt_mask & BIT(F2FS_MOUNT_DISCARD)) &&
 			!ctx_test_opt(ctx, F2FS_MOUNT_DISCARD)) {
 		f2fs_warn(sbi, "discard is required for zoned block devices");
 		return -EINVAL;
 	}
 
 	if (!f2fs_hw_support_discard(sbi) &&
-			(ctx->opt_mask & F2FS_MOUNT_DISCARD) &&
+			(ctx->opt_mask & BIT(F2FS_MOUNT_DISCARD)) &&
 			ctx_test_opt(ctx, F2FS_MOUNT_DISCARD)) {
 		f2fs_warn(sbi, "device does not support discard");
 		ctx_clear_opt(ctx, F2FS_MOUNT_DISCARD);
-		ctx->opt_mask &= ~F2FS_MOUNT_DISCARD;
+		ctx->opt_mask &= ~BIT(F2FS_MOUNT_DISCARD);
 	}
 
 	if (f2fs_sb_has_device_alias(sbi) &&
-			(ctx->opt_mask & F2FS_MOUNT_READ_EXTENT_CACHE) &&
+			(ctx->opt_mask & BIT(F2FS_MOUNT_READ_EXTENT_CACHE)) &&
 			!ctx_test_opt(ctx, F2FS_MOUNT_READ_EXTENT_CACHE)) {
 		f2fs_err(sbi, "device aliasing requires extent cache");
 		return -EINVAL;
 	}
 
 	if (test_opt(sbi, RESERVE_ROOT) &&
-			(ctx->opt_mask & F2FS_MOUNT_RESERVE_ROOT) &&
+			(ctx->opt_mask & BIT(F2FS_MOUNT_RESERVE_ROOT)) &&
 			ctx_test_opt(ctx, F2FS_MOUNT_RESERVE_ROOT)) {
 		f2fs_info(sbi, "Preserve previous reserve_root=%u",
 			F2FS_OPTION(sbi).root_reserved_blocks);
 		ctx_clear_opt(ctx, F2FS_MOUNT_RESERVE_ROOT);
-		ctx->opt_mask &= ~F2FS_MOUNT_RESERVE_ROOT;
+		ctx->opt_mask &= ~BIT(F2FS_MOUNT_RESERVE_ROOT);
 	}
 	if (test_opt(sbi, RESERVE_NODE) &&
-			(ctx->opt_mask & F2FS_MOUNT_RESERVE_NODE) &&
+			(ctx->opt_mask & BIT(F2FS_MOUNT_RESERVE_NODE)) &&
 			ctx_test_opt(ctx, F2FS_MOUNT_RESERVE_NODE)) {
 		f2fs_info(sbi, "Preserve previous reserve_node=%u",
 			F2FS_OPTION(sbi).root_reserved_nodes);
 		ctx_clear_opt(ctx, F2FS_MOUNT_RESERVE_NODE);
-		ctx->opt_mask &= ~F2FS_MOUNT_RESERVE_NODE;
+		ctx->opt_mask &= ~BIT(F2FS_MOUNT_RESERVE_NODE);
 	}
 
 	err = f2fs_check_test_dummy_encryption(fc, sb);
-- 
2.53.0



