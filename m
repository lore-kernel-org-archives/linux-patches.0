Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988103168E8;
	Tue,  6 Jan 2026 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721407; cv=none; b=c7eET0lXB9AuEaI+UkjHLIxNONXg1JP+esOX0EaJshHC6s66NHIMP+PbTh0hZ6rjXgfbw92/b5Ap9rXvyoYPtKs8N22eDMUK3paYsRClhJb5drWxobZaRPh5CgSdPUuUq8PnEjIUvnLTuB15QR96W9KDrT2oN2937y4+IpedR/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721407; c=relaxed/simple;
	bh=tzNbwE6ui/nrtFkXVY+tX2nD9d6YgLY43KdAD5331/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djI4oPGQYazmqnLe7vSp+YgHlvlYkbzZOz8Ge84Po04HxqhvmunzqzgdDeE5O7T7qqS0qIh9SyHuoGOvrvrtqGXNd1ndhrlpXS+Sr2UfZ3I25YfzLjdJ9PVLPtSUU+t7Q+7WxerBud8U6A97nUQVHUcVLedIUWHmoxFgqEHJM8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4YZTcks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4YZTcks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDFFC16AAE;
	Tue,  6 Jan 2026 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721407;
	bh=tzNbwE6ui/nrtFkXVY+tX2nD9d6YgLY43KdAD5331/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4YZTckstjDUGhDN3fGZfZ75Z5gMxSnHyc14JlEvf0EJfJKe/zmpsKBlTfD/PaHu4
	 yVhfXy1wEMjgIsJ+IA/48bU0EhjA4fkR3vZF4h96m2ymVSfvn1g73RP8BqFfVCYHiz
	 1AOMvLozSacSImHxnKoJ5+8eMGFjddUfrjuiU0b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hong Yun <yhong@link.cuhk.edu.hk>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 495/567] f2fs: use global inline_xattr_slab instead of per-sb slab cache
Date: Tue,  6 Jan 2026 18:04:37 +0100
Message-ID: <20260106170509.674399876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1f27ef42bb0b7c0740c5616ec577ec188b8a1d05 ]

As Hong Yun reported in mailing list:

loop7: detected capacity change from 0 to 131072
------------[ cut here ]------------
kmem_cache of name 'f2fs_xattr_entry-7:7' already exists
WARNING: CPU: 0 PID: 24426 at mm/slab_common.c:110 kmem_cache_sanity_check mm/slab_common.c:109 [inline]
WARNING: CPU: 0 PID: 24426 at mm/slab_common.c:110 __kmem_cache_create_args+0xa6/0x320 mm/slab_common.c:307
CPU: 0 UID: 0 PID: 24426 Comm: syz.7.1370 Not tainted 6.17.0-rc4 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:kmem_cache_sanity_check mm/slab_common.c:109 [inline]
RIP: 0010:__kmem_cache_create_args+0xa6/0x320 mm/slab_common.c:307
Call Trace:
 __kmem_cache_create include/linux/slab.h:353 [inline]
 f2fs_kmem_cache_create fs/f2fs/f2fs.h:2943 [inline]
 f2fs_init_xattr_caches+0xa5/0xe0 fs/f2fs/xattr.c:843
 f2fs_fill_super+0x1645/0x2620 fs/f2fs/super.c:4918
 get_tree_bdev_flags+0x1fb/0x260 fs/super.c:1692
 vfs_get_tree+0x43/0x140 fs/super.c:1815
 do_new_mount+0x201/0x550 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x298/0x2f0 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x8e/0x3a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The bug can be reproduced w/ below scripts:
- mount /dev/vdb /mnt1
- mount /dev/vdc /mnt2
- umount /mnt1
- mounnt /dev/vdb /mnt1

The reason is if we created two slab caches, named f2fs_xattr_entry-7:3
and f2fs_xattr_entry-7:7, and they have the same slab size. Actually,
slab system will only create one slab cache core structure which has
slab name of "f2fs_xattr_entry-7:3", and two slab caches share the same
structure and cache address.

So, if we destroy f2fs_xattr_entry-7:3 cache w/ cache address, it will
decrease reference count of slab cache, rather than release slab cache
entirely, since there is one more user has referenced the cache.

Then, if we try to create slab cache w/ name "f2fs_xattr_entry-7:3" again,
slab system will find that there is existed cache which has the same name
and trigger the warning.

Let's changes to use global inline_xattr_slab instead of per-sb slab cache
for fixing.

Fixes: a999150f4fe3 ("f2fs: use kmem_cache pool during inline xattr lookups")
Cc: stable@kernel.org
Reported-by: Hong Yun <yhong@link.cuhk.edu.hk>
Tested-by: Hong Yun <yhong@link.cuhk.edu.hk>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ folio => page ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |    3 ---
 fs/f2fs/super.c |   17 ++++++++---------
 fs/f2fs/xattr.c |   30 ++++++++++--------------------
 fs/f2fs/xattr.h |   10 ++++++----
 4 files changed, 24 insertions(+), 36 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1804,9 +1804,6 @@ struct f2fs_sb_info {
 	spinlock_t error_lock;			/* protect errors/stop_reason array */
 	bool error_dirty;			/* errors of sb is dirty */
 
-	struct kmem_cache *inline_xattr_slab;	/* inline xattr entry */
-	unsigned int inline_xattr_slab_size;	/* default inline xattr slab size */
-
 	/* For reclaimed segs statistics per each GC mode */
 	unsigned int gc_segment_mode;		/* GC state for reclaimed segments */
 	unsigned int gc_reclaimed_segs[MAX_GC_MODE];	/* Reclaimed segs for each mode */
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1695,7 +1695,6 @@ static void f2fs_put_super(struct super_
 	kfree(sbi->raw_super);
 
 	f2fs_destroy_page_array_cache(sbi);
-	f2fs_destroy_xattr_caches(sbi);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < MAXQUOTAS; i++)
 		kfree(F2FS_OPTION(sbi).s_qf_names[i]);
@@ -4568,13 +4567,9 @@ try_onemore:
 	if (err)
 		goto free_iostat;
 
-	/* init per sbi slab cache */
-	err = f2fs_init_xattr_caches(sbi);
-	if (err)
-		goto free_percpu;
 	err = f2fs_init_page_array_cache(sbi);
 	if (err)
-		goto free_xattr_cache;
+		goto free_percpu;
 
 	/* get an inode for meta space */
 	sbi->meta_inode = f2fs_iget(sb, F2FS_META_INO(sbi));
@@ -4906,8 +4901,6 @@ free_meta_inode:
 	sbi->meta_inode = NULL;
 free_page_array_cache:
 	f2fs_destroy_page_array_cache(sbi);
-free_xattr_cache:
-	f2fs_destroy_xattr_caches(sbi);
 free_percpu:
 	destroy_percpu_info(sbi);
 free_iostat:
@@ -5069,10 +5062,15 @@ static int __init init_f2fs_fs(void)
 	err = f2fs_create_casefold_cache();
 	if (err)
 		goto free_compress_cache;
-	err = register_filesystem(&f2fs_fs_type);
+	err = f2fs_init_xattr_cache();
 	if (err)
 		goto free_casefold_cache;
+	err = register_filesystem(&f2fs_fs_type);
+	if (err)
+		goto free_xattr_cache;
 	return 0;
+free_xattr_cache:
+	f2fs_destroy_xattr_cache();
 free_casefold_cache:
 	f2fs_destroy_casefold_cache();
 free_compress_cache:
@@ -5113,6 +5111,7 @@ fail:
 static void __exit exit_f2fs_fs(void)
 {
 	unregister_filesystem(&f2fs_fs_type);
+	f2fs_destroy_xattr_cache();
 	f2fs_destroy_casefold_cache();
 	f2fs_destroy_compress_cache();
 	f2fs_destroy_compress_mempool();
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -23,11 +23,12 @@
 #include "xattr.h"
 #include "segment.h"
 
+static struct kmem_cache *inline_xattr_slab;
 static void *xattr_alloc(struct f2fs_sb_info *sbi, int size, bool *is_inline)
 {
-	if (likely(size == sbi->inline_xattr_slab_size)) {
+	if (likely(size == DEFAULT_XATTR_SLAB_SIZE)) {
 		*is_inline = true;
-		return f2fs_kmem_cache_alloc(sbi->inline_xattr_slab,
+		return f2fs_kmem_cache_alloc(inline_xattr_slab,
 					GFP_F2FS_ZERO, false, sbi);
 	}
 	*is_inline = false;
@@ -38,7 +39,7 @@ static void xattr_free(struct f2fs_sb_in
 							bool is_inline)
 {
 	if (is_inline)
-		kmem_cache_free(sbi->inline_xattr_slab, xattr_addr);
+		kmem_cache_free(inline_xattr_slab, xattr_addr);
 	else
 		kfree(xattr_addr);
 }
@@ -830,25 +831,14 @@ int f2fs_setxattr(struct inode *inode, i
 	return err;
 }
 
-int f2fs_init_xattr_caches(struct f2fs_sb_info *sbi)
+int __init f2fs_init_xattr_cache(void)
 {
-	dev_t dev = sbi->sb->s_bdev->bd_dev;
-	char slab_name[32];
-
-	sprintf(slab_name, "f2fs_xattr_entry-%u:%u", MAJOR(dev), MINOR(dev));
-
-	sbi->inline_xattr_slab_size = F2FS_OPTION(sbi).inline_xattr_size *
-					sizeof(__le32) + XATTR_PADDING_SIZE;
-
-	sbi->inline_xattr_slab = f2fs_kmem_cache_create(slab_name,
-					sbi->inline_xattr_slab_size);
-	if (!sbi->inline_xattr_slab)
-		return -ENOMEM;
-
-	return 0;
+	inline_xattr_slab = f2fs_kmem_cache_create("f2fs_xattr_entry",
+					DEFAULT_XATTR_SLAB_SIZE);
+	return inline_xattr_slab ? 0 : -ENOMEM;
 }
 
-void f2fs_destroy_xattr_caches(struct f2fs_sb_info *sbi)
+void f2fs_destroy_xattr_cache(void)
 {
-	kmem_cache_destroy(sbi->inline_xattr_slab);
+	kmem_cache_destroy(inline_xattr_slab);
 }
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -89,6 +89,8 @@ struct f2fs_xattr_entry {
 			F2FS_TOTAL_EXTRA_ATTR_SIZE / sizeof(__le32) -	\
 			DEF_INLINE_RESERVED_SIZE -			\
 			MIN_INLINE_DENTRY_SIZE / sizeof(__le32))
+#define DEFAULT_XATTR_SLAB_SIZE	(DEFAULT_INLINE_XATTR_ADDRS *		\
+				sizeof(__le32) + XATTR_PADDING_SIZE)
 
 /*
  * On-disk structure of f2fs_xattr
@@ -132,8 +134,8 @@ extern int f2fs_setxattr(struct inode *,
 extern int f2fs_getxattr(struct inode *, int, const char *, void *,
 						size_t, struct page *);
 extern ssize_t f2fs_listxattr(struct dentry *, char *, size_t);
-extern int f2fs_init_xattr_caches(struct f2fs_sb_info *);
-extern void f2fs_destroy_xattr_caches(struct f2fs_sb_info *);
+extern int __init f2fs_init_xattr_cache(void);
+extern void f2fs_destroy_xattr_cache(void);
 #else
 
 #define f2fs_xattr_handlers	NULL
@@ -150,8 +152,8 @@ static inline int f2fs_getxattr(struct i
 {
 	return -EOPNOTSUPP;
 }
-static inline int f2fs_init_xattr_caches(struct f2fs_sb_info *sbi) { return 0; }
-static inline void f2fs_destroy_xattr_caches(struct f2fs_sb_info *sbi) { }
+static inline int __init f2fs_init_xattr_cache(void) { return 0; }
+static inline void f2fs_destroy_xattr_cache(void) { }
 #endif
 
 #ifdef CONFIG_F2FS_FS_SECURITY


