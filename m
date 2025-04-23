Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2362A285405;
	Wed, 23 Apr 2025 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420788; cv=none; b=mu/bC+HSvgXkTLT8TqlU+sN+3RJ5oPfqu6xEusq/BfXkclAbyVY8ZTG4sFYKdDy0lwe1dx+DMaopsgrCp141LuL2Tk0SxQFRqM/nb6nzsVOqDhJmqBEzYjdXtaUj6JAJkerpiowbomXzO8mfienQYaNuv1K57mAnUOARGLgtoq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420788; c=relaxed/simple;
	bh=HI1O8EA1Q8ZV9bVG2qfxhTxtwvBpa7nmbhk1fgEqeyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1cI/c34rNQR4I7h6mWyRXA0bxzUyt8Y+cn5n/7BCPoCJUgpy95j4zBFqQHg2NuPQ2NzwSEb6N+kkhhYWSDw+VOXi8tNsz3ndI1XmfYLOXstvRcTMkx/chthxmuvpqIJBetMasEmVlX9PrzyTZ0dfite+eTb9GAifbGUe1Y0dP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2wZUagL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2wZUagL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE029C4CEE2;
	Wed, 23 Apr 2025 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420788;
	bh=HI1O8EA1Q8ZV9bVG2qfxhTxtwvBpa7nmbhk1fgEqeyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2wZUagLMXqa1v+LxllCuQbIHVFNbLNRt+XA14J2HrlSoxRPjV8weII8I4pgBtjZq
	 DmwjZJ+jdxGvDIKWR95PVTlN0MfeQAjQinCBzOnr1bv8pwxkVGSZoLtRVidOIWYrIN
	 7QjIlfh/DIqwzwEasDspdCvm48qVZKzBsJP+Lm+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 122/241] fs: move the bdex_statx call to vfs_getattr_nosec
Date: Wed, 23 Apr 2025 16:43:06 +0200
Message-ID: <20250423142625.563593359@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 777d0961ff95b26d5887fdae69900374364976f3 ]

Currently bdex_statx is only called from the very high-level
vfs_statx_path function, and thus bypassing it for in-kernel calls
to vfs_getattr or vfs_getattr_nosec.

This breaks querying the block ѕize of the underlying device in the
loop driver and also is a pitfall for any other new kernel caller.

Move the call into the lowest level helper to ensure all callers get
the right results.

Fixes: 2d985f8c6b91 ("vfs: support STATX_DIOALIGN on block devices")
Fixes: f4774e92aab8 ("loop: take the file system minimum dio alignment into account")
Reported-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/20250417064042.712140-1-hch@lst.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c           |  3 +--
 fs/stat.c              | 32 ++++++++++++++++++--------------
 include/linux/blkdev.h |  6 +++---
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 9d73a8fbf7f99..e5147cab21b21 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1268,8 +1268,7 @@ void sync_bdevs(bool wait)
 /*
  * Handle STATX_{DIOALIGN, WRITE_ATOMIC} for block devices.
  */
-void bdev_statx(struct path *path, struct kstat *stat,
-		u32 request_mask)
+void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask)
 {
 	struct inode *backing_inode;
 	struct block_device *bdev;
diff --git a/fs/stat.c b/fs/stat.c
index f13308bfdc983..3d9222807214a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -204,12 +204,25 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 				  STATX_ATTR_DAX);
 
 	idmap = mnt_idmap(path->mnt);
-	if (inode->i_op->getattr)
-		return inode->i_op->getattr(idmap, path, stat,
-					    request_mask,
-					    query_flags);
+	if (inode->i_op->getattr) {
+		int ret;
+
+		ret = inode->i_op->getattr(idmap, path, stat, request_mask,
+				query_flags);
+		if (ret)
+			return ret;
+	} else {
+		generic_fillattr(idmap, request_mask, inode, stat);
+	}
+
+	/*
+	 * If this is a block device inode, override the filesystem attributes
+	 * with the block device specific parameters that need to be obtained
+	 * from the bdev backing inode.
+	 */
+	if (S_ISBLK(stat->mode))
+		bdev_statx(path, stat, request_mask);
 
-	generic_fillattr(idmap, request_mask, inode, stat);
 	return 0;
 }
 EXPORT_SYMBOL(vfs_getattr_nosec);
@@ -295,15 +308,6 @@ static int vfs_statx_path(struct path *path, int flags, struct kstat *stat,
 	if (path_mounted(path))
 		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
 	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
-
-	/*
-	 * If this is a block device inode, override the filesystem
-	 * attributes with the block device specific parameters that need to be
-	 * obtained from the bdev backing inode.
-	 */
-	if (S_ISBLK(stat->mode))
-		bdev_statx(path, stat, request_mask);
-
 	return 0;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d37751789bf58..38fc78501ef2d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1664,7 +1664,7 @@ int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
-void bdev_statx(struct path *, struct kstat *, u32);
+void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
 #else
@@ -1682,8 +1682,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
 static inline void sync_bdevs(bool wait)
 {
 }
-static inline void bdev_statx(struct path *path, struct kstat *stat,
-				u32 request_mask)
+static inline void bdev_statx(const struct path *path, struct kstat *stat,
+		u32 request_mask)
 {
 }
 static inline void printk_all_partitions(void)
-- 
2.39.5



