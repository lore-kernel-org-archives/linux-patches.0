Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475A175BF;
	Wed, 23 Apr 2025 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420139; cv=none; b=OEzpsO2xRVlbPIsV4iYmuuREmQ9vMh3clc3WKzGsp0X4OndTNzBCXfKfPmXpKmz8xQfo1+pB+mZ9NWK0eBPgyNSc5q6h3uTMO6e8RrBvef/CrzHU/0PQZ0hpx3AkTO7cLI9ID1cN2f0+Ynff6dUpy66+ltf6ZcuSJDJt1VkxbCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420139; c=relaxed/simple;
	bh=RpL8mooEoxNIs4qvwjTD2Z9v++ie9mIlQ2mie0j2C6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZV5DOCb5zZ18jWWh+4NqPwyxnW2WFgp9nrB2DzTU1Z1VGjiuulQgbBSITGn/gInHvOMf+rhytKutBCK9k6pjycNCOGI6Rj+UAudxiNoVAG9Fk9FPiew2T3QvgJNnXIyOcNMRAubW89nTwNX2vjxuRafpTgUDbqFPji5e4thVzuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eM+NsZih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eM+NsZih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072B0C4CEE2;
	Wed, 23 Apr 2025 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420139;
	bh=RpL8mooEoxNIs4qvwjTD2Z9v++ie9mIlQ2mie0j2C6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eM+NsZihq4d5gEsMbNoI0jxfk3tVr2lTA1l8sy/yEQPjJp9Bxk0MOKlFawU4EG69h
	 YqHBtmNpbcsp+vpZ+/jix+TCxdgcNyj2ZIqKiaF3T32lMfDf/SRjy4k6GP0t8oOnrF
	 FMjFopx3VTGSkzKFccH9qaTcR5m/PB0mI1/DeEII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/223] fs: move the bdex_statx call to vfs_getattr_nosec
Date: Wed, 23 Apr 2025 16:42:55 +0200
Message-ID: <20250423142621.311212609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 738e3c8457e7f..1f1282a0dc653 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1269,8 +1269,7 @@ void sync_bdevs(bool wait)
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
index b399b881bbbf9..8ce0fc9cad5d0 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -162,12 +162,25 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
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
@@ -260,15 +273,6 @@ static int vfs_statx_path(struct path *path, int flags, struct kstat *stat,
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
index 8f37c5dd52b21..2aa9cb446c6c8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1624,7 +1624,7 @@ int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
-void bdev_statx(struct path *, struct kstat *, u32);
+void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
 #else
@@ -1642,8 +1642,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
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



