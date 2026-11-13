Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585997;
	b=rKph2ky/DocH2VmE84fvbqYlKa2puRtva7VAzUh694xUppJck0yt6yJcGGMjapttldjn
	 Zn51mWaUIsp8+6O4vW52n2h2jsn7wgh/HPacWN34KlA0dE0Z1ie2I40wJ7Qag8u1a7+xk
	 b2GfENQAw9B6IaVm+zOlczNgLzM3IHR6ssBD57YBILbdfqf0EcgYtLo8uDCLiZrxBKgfK
	 pehno29q7ldEXgVYCYVIMxy/Mcr6PeVDEfO5TOOY89GPdvUg+HefsxqxBw9ZJKgjCuqW7
	 t7A9j0eqCz0uX4z4LIiMq2ubULPlQFhSu0Ga/82qgpufGykrtfi6tawnkoIbUqdhmww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NZW4/rT3xepGtrMrmzVHFZWhKzCJbJvk7VO8G9kgmGw=;
	b=dZ2vlJfwV2PmQM/dG+r6IpICOxhwI93V1pzkKftyJsEtEdJUsjj8ZeBiaMJG4g5zBxek
	 nPFf36G3BoU3m1Q1Roglh/7A+QgzPM+xQVsPTDBGXaolA1JBbP+2l5j8Fy4BLHzYFexhk
	 tiJwn2r34CVwdsswhCg5EVWrc3VVNX7rfqi7wzASR7ORBlAEVe/p6/elAXBMLcxTd+dFy
	 jI5ApUWvIdQURUTFA9NtQVnCInSa4VQ5odEy7+1Wsh386D6daep8BD0F0FppS9pLQMR0+
	 f/b6CdlM8N861SNWFPsQeeJ49VV0f+LSIrkSJedIpmLb0BfMZyFibxA4ADCAHF8hD9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MF7/oT0L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34028606B2C3;
	Fri, 13 Nov 2026 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MF7/oT0L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36961F000CA;
	Fri, 13 Nov 2026 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585997;
	bh=NZW4/rT3xepGtrMrmzVHFZWhKzCJbJvk7VO8G9kgmGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MF7/oT0LwrkI2uKIfOy3mlZ/h3h96Wb4KnvTlUqT+0UUZsoUSPYxOe+jxN/BNR4lG
	 VvnkYrGd46ayLXitChKc4j7p9dxFYsQIiQcUaQSlSVhxark8D4xMqiRgxv4HiDG/5y
	 lZ2PUfOYUr8+ZFRTQ5jp2awMSJA9fCVLhsOiiCL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/686] exportfs: split out the ops for layout-based block device access
Date: Fri, 13 Nov 2026 10:42:51 -0500
Message-ID: <20261113153822.263148010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d5758c31a81bcd9d5ac8a7456549b05df3579068 ]

The support to grant layouts for direct block device access works
at a very different layer than the rest of exports.  Split the methods
for it into a separate struct, and move that into a separate header
to better split things out.  The pointer to the new operation vector
is kept in export_operations to avoid bloating the super_block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260423181854.743150-3-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5d28b2c920d9 ("nfsd: don't offer flexfiles layouts when NFSv3 isn't being served")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                    |  2 +-
 fs/nfsd/blocklayout.c          | 14 ++++++------
 fs/nfsd/nfs4layouts.c          |  9 ++++----
 fs/xfs/xfs_export.c            |  4 +---
 fs/xfs/xfs_pnfs.c              | 12 ++++++++---
 fs/xfs/xfs_pnfs.h              | 11 +++++-----
 include/linux/exportfs.h       | 25 +++++++---------------
 include/linux/exportfs_block.h | 39 ++++++++++++++++++++++++++++++++++
 8 files changed, 74 insertions(+), 42 deletions(-)
 create mode 100644 include/linux/exportfs_block.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f5ea8588244c9..5821d97ae3304 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9606,7 +9606,7 @@ S:	Supported
 F:	Documentation/filesystems/nfs/exporting.rst
 F:	fs/exportfs/
 F:	fs/fhandle.c
-F:	include/linux/exportfs.h
+F:	include/linux/exportfs*.h
 
 FILESYSTEMS [IDMAPPED MOUNTS]
 M:	Christian Brauner <brauner@kernel.org>
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 8f6478d88ea22..ac1312fd1c457 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2014-2016 Christoph Hellwig.
  */
-#include <linux/exportfs.h>
+#include <linux/exportfs_block.h>
 #include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/pr.h>
@@ -31,8 +31,8 @@ nfsd4_block_map_extent(struct inode *inode, const struct svc_fh *fhp,
 	u32 device_generation = 0;
 	int error;
 
-	error = sb->s_export_op->map_blocks(inode, offset, length, &iomap,
-			iomode != IOMODE_READ, &device_generation);
+	error = sb->s_export_op->block_ops->map_blocks(inode, offset, length,
+			&iomap, iomode != IOMODE_READ, &device_generation);
 	if (error) {
 		if (error == -ENXIO)
 			return nfserr_layoutunavailable;
@@ -154,8 +154,8 @@ nfsd4_block_commit_blocks(struct inode *inode, struct nfsd4_layoutcommit *lcp,
 		iattr.ia_size = lcp->lc_newsize;
 	}
 
-	error = inode->i_sb->s_export_op->commit_blocks(inode, iomaps,
-			nr_iomaps, &iattr);
+	error = inode->i_sb->s_export_op->block_ops->commit_blocks(inode,
+			iomaps, nr_iomaps, &iattr);
 	kfree(iomaps);
 	return nfserrno(error);
 }
@@ -178,8 +178,8 @@ nfsd4_block_get_device_info_simple(struct super_block *sb,
 
 	b->type = PNFS_BLOCK_VOLUME_SIMPLE;
 	b->simple.sig_len = PNFS_BLOCK_UUID_LEN;
-	return sb->s_export_op->get_uuid(sb, b->simple.sig, &b->simple.sig_len,
-			&b->simple.offset);
+	return sb->s_export_op->block_ops->get_uuid(sb, b->simple.sig,
+			&b->simple.sig_len, &b->simple.offset);
 }
 
 static __be32
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 2121ef26e7a98..6b6f55ae0472d 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2014 Christoph Hellwig.
  */
 #include <linux/blkdev.h>
+#include <linux/exportfs_block.h>
 #include <linux/kmod.h>
 #include <linux/file.h>
 #include <linux/jhash.h>
@@ -127,6 +128,7 @@ void nfsd4_setup_layout_type(struct svc_export *exp)
 {
 #if defined(CONFIG_NFSD_BLOCKLAYOUT) || defined(CONFIG_NFSD_SCSILAYOUT)
 	struct super_block *sb = exp->ex_path.mnt->mnt_sb;
+	const struct exportfs_block_ops *bops = sb->s_export_op->block_ops;
 #endif
 
 	if (!(exp->ex_flags & NFSEXP_PNFS))
@@ -136,14 +138,11 @@ void nfsd4_setup_layout_type(struct svc_export *exp)
 	exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
 #endif
 #ifdef CONFIG_NFSD_BLOCKLAYOUT
-	if (sb->s_export_op->get_uuid &&
-	    sb->s_export_op->map_blocks &&
-	    sb->s_export_op->commit_blocks)
+	if (bops && bops->get_uuid && bops->map_blocks && bops->commit_blocks)
 		exp->ex_layout_types |= 1 << LAYOUT_BLOCK_VOLUME;
 #endif
 #ifdef CONFIG_NFSD_SCSILAYOUT
-	if (sb->s_export_op->map_blocks &&
-	    sb->s_export_op->commit_blocks &&
+	if (bops && bops->map_blocks && bops->commit_blocks &&
 	    sb->s_bdev &&
 	    sb->s_bdev->bd_disk->fops->pr_ops &&
 	    sb->s_bdev->bd_disk->fops->get_unique_id)
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 201489d3de089..f64e035cacb55 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -244,8 +244,6 @@ const struct export_operations xfs_export_operations = {
 	.get_parent		= xfs_fs_get_parent,
 	.commit_metadata	= xfs_fs_nfs_commit_metadata,
 #ifdef CONFIG_EXPORTFS_BLOCK_OPS
-	.get_uuid		= xfs_fs_get_uuid,
-	.map_blocks		= xfs_fs_map_blocks,
-	.commit_blocks		= xfs_fs_commit_blocks,
+	.block_ops		= &xfs_export_block_ops,
 #endif
 };
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index afe7497012d4c..c685995b69d7e 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -49,7 +49,7 @@ xfs_break_leased_layouts(
  * Get a unique ID including its location so that the client can identify
  * the exported device.
  */
-int
+static int
 xfs_fs_get_uuid(
 	struct super_block	*sb,
 	u8			*buf,
@@ -104,7 +104,7 @@ xfs_fs_map_update_inode(
 /*
  * Get a layout for the pNFS client.
  */
-int
+static int
 xfs_fs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
@@ -252,7 +252,7 @@ xfs_pnfs_validate_isize(
  * to manually flush the cache here similar to what the fsync code path does
  * for datasyncs on files that have no dirty metadata.
  */
-int
+static int
 xfs_fs_commit_blocks(
 	struct inode		*inode,
 	struct iomap		*maps,
@@ -332,3 +332,9 @@ xfs_fs_commit_blocks(
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
 }
+
+const struct exportfs_block_ops xfs_export_block_ops = {
+	.get_uuid		= xfs_fs_get_uuid,
+	.map_blocks		= xfs_fs_map_blocks,
+	.commit_blocks		= xfs_fs_commit_blocks,
+};
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
index 940c6c2ad88c5..bf43b2009e4cc 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -2,13 +2,9 @@
 #ifndef _XFS_PNFS_H
 #define _XFS_PNFS_H 1
 
-#ifdef CONFIG_EXPORTFS_BLOCK_OPS
-int xfs_fs_get_uuid(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
-int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
-		struct iomap *iomap, bool write, u32 *device_generation);
-int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
-		struct iattr *iattr);
+#include <linux/exportfs_block.h>
 
+#ifdef CONFIG_EXPORTFS_BLOCK_OPS
 int xfs_break_leased_layouts(struct inode *inode, uint *iolock,
 		bool *did_unlock);
 #else
@@ -18,4 +14,7 @@ xfs_break_leased_layouts(struct inode *inode, uint *iolock, bool *did_unlock)
 	return 0;
 }
 #endif /* CONFIG_EXPORTFS_BLOCK_OPS */
+
+extern const struct exportfs_block_ops xfs_export_block_ops;
+
 #endif /* _XFS_PNFS_H */
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 0dc1bae9e1654..dfeadad435a60 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -6,9 +6,8 @@
 #include <linux/path.h>
 
 struct dentry;
-struct iattr;
+struct exportfs_block_ops;
 struct inode;
-struct iomap;
 struct super_block;
 struct vfsmount;
 
@@ -252,19 +251,13 @@ struct handle_to_path_ctx {
  * commit_metadata:
  *    @commit_metadata should commit metadata changes to stable storage.
  *
- * @get_uuid:
- *    Get a filesystem unique signature exposed to clients.
- *
- * @map_blocks:
- *    Map and, if necessary, allocate blocks for a layout.
- *
- * @commit_blocks:
- *    Commit blocks in a layout once the client is done with them.
- *
  * @flags:
  *    Allows the filesystem to communicate to nfsd that it may want to do things
  *    differently when dealing with it.
  *
+ * @block_ops:
+ *    Operations for layout grants to block on the underlying device.
+ *
  * Locking rules:
  *    get_parent is called with child->d_inode->i_rwsem down
  *    get_name is not (which is possibly inconsistent)
@@ -282,12 +275,6 @@ struct export_operations {
 	struct dentry * (*get_parent)(struct dentry *child);
 	int (*commit_metadata)(struct inode *inode);
 
-	int (*get_uuid)(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
-	int (*map_blocks)(struct inode *inode, loff_t offset,
-			  u64 len, struct iomap *iomap,
-			  bool write, u32 *device_generation);
-	int (*commit_blocks)(struct inode *inode, struct iomap *iomaps,
-			     int nr_iomaps, struct iattr *iattr);
 	int (*permission)(struct handle_to_path_ctx *ctx, unsigned int oflags);
 	struct file * (*open)(const struct path *path, unsigned int oflags);
 #define	EXPORT_OP_NOWCC			(0x1) /* don't collect v3 wcc data */
@@ -300,6 +287,10 @@ struct export_operations {
 #define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
 #define EXPORT_OP_NOLOCKS		(0x40) /* no file locking support */
 	unsigned long	flags;
+
+#ifdef CONFIG_EXPORTFS_BLOCK_OPS
+	const struct exportfs_block_ops *block_ops;
+#endif
 };
 
 /**
diff --git a/include/linux/exportfs_block.h b/include/linux/exportfs_block.h
new file mode 100644
index 0000000000000..1f52fea8e4dce
--- /dev/null
+++ b/include/linux/exportfs_block.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2014-2026 Christoph Hellwig.
+ *
+ * Support for exportfs-based layout grants for direct block device access.
+ */
+#ifndef LINUX_EXPORTFS_BLOCK_H
+#define LINUX_EXPORTFS_BLOCK_H 1
+
+#include <linux/types.h>
+
+struct iattr;
+struct inode;
+struct iomap;
+struct super_block;
+
+struct exportfs_block_ops {
+	/*
+	 * Get the in-band device unique signature exposed to clients.
+	 */
+	int (*get_uuid)(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
+
+	/*
+	 * Map blocks for direct block access.
+	 * If @write is %true, also allocate the blocks for the range if needed.
+	 */
+	int (*map_blocks)(struct inode *inode, loff_t offset, u64 len,
+			struct iomap *iomap, bool write,
+			u32 *device_generation);
+
+	/*
+	 * Commit blocks previously handed out by ->map_blocks and written to by
+	 * the client.
+	 */
+	int (*commit_blocks)(struct inode *inode, struct iomap *iomaps,
+			int nr_iomaps, struct iattr *iattr);
+};
+
+#endif /* LINUX_EXPORTFS_BLOCK_H */
-- 
2.53.0



