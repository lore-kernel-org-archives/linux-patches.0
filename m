Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781DC1494D9;
	Fri,  6 Dec 2024 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495962; cv=none; b=ns+mG9A2YoB/qVlt8gmzgWPokripnACqiimuQMA0pdlfZDyJo5uQPnUqa8cUiUPOL5DpFPrG1phvPhfr0/pqgk6NiEA4Utl465+GWX8UTOt5AXnmRl1MQ5U9SEklqu75WaLtw6hQUA4Q+okmo3QGh+o+nQBpBd9th0VGh8P4yRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495962; c=relaxed/simple;
	bh=2whFmGlT/Hd80KONYMapvlQanGzHjGV+ycBgJc+hry0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmzrX+3KVGMvRX3jKxEEqIFJ/W0AvyiPSTUX5UDJD+XP3kwd/ow8MbgxJwUvuFKdpu7Aar8DBL3Y7MdpZ/YPc5B4vjDTwbN5SzC3z5v8J5VNcpP/vll+HSsKfpLsVB588182uvdaCYguAMMhnP5HBkovZH4aGzF3DX5hBhc4MVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiihQQkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiihQQkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C551C4CED1;
	Fri,  6 Dec 2024 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495962;
	bh=2whFmGlT/Hd80KONYMapvlQanGzHjGV+ycBgJc+hry0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiihQQkUok4SJ6nLoLhFmnbpUc21jVBPFyh7EWccW5gbj/+wckF28mKez7LO19Tsx
	 +J4KbixlfiZphzEsEG8Ga1RzG2dWNYUFTlhbDMUWBsUl+EpZWZ9rdfR0jt9zu05d43
	 oRZ975wd5dc8tBFIPCA96HrFBqqr6QiR8J0p8Iu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Harmstone <maharmstone@fb.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/146] btrfs: change btrfs_encoded_read() so that reading of extent is done by caller
Date: Fri,  6 Dec 2024 15:35:35 +0100
Message-ID: <20241206143527.832013576@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <maharmstone@fb.com>

[ Upstream commit 26efd44796c6dd7a64f039a0dda6d558eac97a3e ]

Change the behaviour of btrfs_encoded_read() so that if it needs to read
an extent from disk, it leaves the extent and inode locked and returns
-EIOCBQUEUED. The caller is then responsible for doing the I/O via
btrfs_encoded_read_regular() and unlocking the extent and inode.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 05b36b04d74a ("btrfs: fix use-after-free in btrfs_encoded_read_endio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  9 ++++++-
 fs/btrfs/inode.c       | 57 ++++++++++++++++++++----------------------
 fs/btrfs/ioctl.c       | 32 +++++++++++++++++++++++-
 3 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 5e2d93c2dfb5a..db53a3263fbd0 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -616,7 +616,14 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 					  u64 disk_bytenr, u64 disk_io_size,
 					  struct page **pages);
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
-			   struct btrfs_ioctl_encoded_io_args *encoded);
+			   struct btrfs_ioctl_encoded_io_args *encoded,
+			   struct extent_state **cached_state,
+			   u64 *disk_bytenr, u64 *disk_io_size);
+ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *iter,
+				   u64 start, u64 lockend,
+				   struct extent_state **cached_state,
+				   u64 disk_bytenr, u64 disk_io_size,
+				   size_t count, bool compressed, bool *unlocked);
 ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 			       const struct btrfs_ioctl_encoded_io_args *encoded);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 753e9cb0c3717..9c4f1a3742f3f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9177,13 +9177,11 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 	return blk_status_to_errno(READ_ONCE(priv.status));
 }
 
-static ssize_t btrfs_encoded_read_regular(struct kiocb *iocb,
-					  struct iov_iter *iter,
-					  u64 start, u64 lockend,
-					  struct extent_state **cached_state,
-					  u64 disk_bytenr, u64 disk_io_size,
-					  size_t count, bool compressed,
-					  bool *unlocked)
+ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *iter,
+				   u64 start, u64 lockend,
+				   struct extent_state **cached_state,
+				   u64 disk_bytenr, u64 disk_io_size,
+				   size_t count, bool compressed, bool *unlocked)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
 	struct extent_io_tree *io_tree = &inode->io_tree;
@@ -9244,15 +9242,16 @@ static ssize_t btrfs_encoded_read_regular(struct kiocb *iocb,
 }
 
 ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
-			   struct btrfs_ioctl_encoded_io_args *encoded)
+			   struct btrfs_ioctl_encoded_io_args *encoded,
+			   struct extent_state **cached_state,
+			   u64 *disk_bytenr, u64 *disk_io_size)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct extent_io_tree *io_tree = &inode->io_tree;
 	ssize_t ret;
 	size_t count = iov_iter_count(iter);
-	u64 start, lockend, disk_bytenr, disk_io_size;
-	struct extent_state *cached_state = NULL;
+	u64 start, lockend;
 	struct extent_map *em;
 	bool unlocked = false;
 
@@ -9278,13 +9277,13 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 					       lockend - start + 1);
 		if (ret)
 			goto out_unlock_inode;
-		lock_extent(io_tree, start, lockend, &cached_state);
+		lock_extent(io_tree, start, lockend, cached_state);
 		ordered = btrfs_lookup_ordered_range(inode, start,
 						     lockend - start + 1);
 		if (!ordered)
 			break;
 		btrfs_put_ordered_extent(ordered);
-		unlock_extent(io_tree, start, lockend, &cached_state);
+		unlock_extent(io_tree, start, lockend, cached_state);
 		cond_resched();
 	}
 
@@ -9304,7 +9303,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 		free_extent_map(em);
 		em = NULL;
 		ret = btrfs_encoded_read_inline(iocb, iter, start, lockend,
-						&cached_state, extent_start,
+						cached_state, extent_start,
 						count, encoded, &unlocked);
 		goto out;
 	}
@@ -9317,12 +9316,12 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			     inode->vfs_inode.i_size) - iocb->ki_pos;
 	if (em->disk_bytenr == EXTENT_MAP_HOLE ||
 	    (em->flags & EXTENT_FLAG_PREALLOC)) {
-		disk_bytenr = EXTENT_MAP_HOLE;
+		*disk_bytenr = EXTENT_MAP_HOLE;
 		count = min_t(u64, count, encoded->len);
 		encoded->len = count;
 		encoded->unencoded_len = count;
 	} else if (extent_map_is_compressed(em)) {
-		disk_bytenr = em->disk_bytenr;
+		*disk_bytenr = em->disk_bytenr;
 		/*
 		 * Bail if the buffer isn't large enough to return the whole
 		 * compressed extent.
@@ -9331,7 +9330,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			ret = -ENOBUFS;
 			goto out_em;
 		}
-		disk_io_size = em->disk_num_bytes;
+		*disk_io_size = em->disk_num_bytes;
 		count = em->disk_num_bytes;
 		encoded->unencoded_len = em->ram_bytes;
 		encoded->unencoded_offset = iocb->ki_pos - (em->start - em->offset);
@@ -9341,35 +9340,32 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 			goto out_em;
 		encoded->compression = ret;
 	} else {
-		disk_bytenr = extent_map_block_start(em) + (start - em->start);
+		*disk_bytenr = extent_map_block_start(em) + (start - em->start);
 		if (encoded->len > count)
 			encoded->len = count;
 		/*
 		 * Don't read beyond what we locked. This also limits the page
 		 * allocations that we'll do.
 		 */
-		disk_io_size = min(lockend + 1, iocb->ki_pos + encoded->len) - start;
-		count = start + disk_io_size - iocb->ki_pos;
+		*disk_io_size = min(lockend + 1, iocb->ki_pos + encoded->len) - start;
+		count = start + *disk_io_size - iocb->ki_pos;
 		encoded->len = count;
 		encoded->unencoded_len = count;
-		disk_io_size = ALIGN(disk_io_size, fs_info->sectorsize);
+		*disk_io_size = ALIGN(*disk_io_size, fs_info->sectorsize);
 	}
 	free_extent_map(em);
 	em = NULL;
 
-	if (disk_bytenr == EXTENT_MAP_HOLE) {
-		unlock_extent(io_tree, start, lockend, &cached_state);
+	if (*disk_bytenr == EXTENT_MAP_HOLE) {
+		unlock_extent(io_tree, start, lockend, cached_state);
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 		unlocked = true;
 		ret = iov_iter_zero(count, iter);
 		if (ret != count)
 			ret = -EFAULT;
 	} else {
-		ret = btrfs_encoded_read_regular(iocb, iter, start, lockend,
-						 &cached_state, disk_bytenr,
-						 disk_io_size, count,
-						 encoded->compression,
-						 &unlocked);
+		ret = -EIOCBQUEUED;
+		goto out_em;
 	}
 
 out:
@@ -9378,10 +9374,11 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 out_em:
 	free_extent_map(em);
 out_unlock_extent:
-	if (!unlocked)
-		unlock_extent(io_tree, start, lockend, &cached_state);
+	/* Leave inode and extent locked if we need to do a read. */
+	if (!unlocked && ret != -EIOCBQUEUED)
+		unlock_extent(io_tree, start, lockend, cached_state);
 out_unlock_inode:
-	if (!unlocked)
+	if (!unlocked && ret != -EIOCBQUEUED)
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	return ret;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 226c91fe31a70..3e3722a732393 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4514,12 +4514,17 @@ static int btrfs_ioctl_encoded_read(struct file *file, void __user *argp,
 	size_t copy_end_kernel = offsetofend(struct btrfs_ioctl_encoded_io_args,
 					     flags);
 	size_t copy_end;
+	struct btrfs_inode *inode = BTRFS_I(file_inode(file));
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct extent_io_tree *io_tree = &inode->io_tree;
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
 	struct iov_iter iter;
 	loff_t pos;
 	struct kiocb kiocb;
 	ssize_t ret;
+	u64 disk_bytenr, disk_io_size;
+	struct extent_state *cached_state = NULL;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
@@ -4572,7 +4577,32 @@ static int btrfs_ioctl_encoded_read(struct file *file, void __user *argp,
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos = pos;
 
-	ret = btrfs_encoded_read(&kiocb, &iter, &args);
+	ret = btrfs_encoded_read(&kiocb, &iter, &args, &cached_state,
+				 &disk_bytenr, &disk_io_size);
+
+	if (ret == -EIOCBQUEUED) {
+		bool unlocked = false;
+		u64 start, lockend, count;
+
+		start = ALIGN_DOWN(kiocb.ki_pos, fs_info->sectorsize);
+		lockend = start + BTRFS_MAX_UNCOMPRESSED - 1;
+
+		if (args.compression)
+			count = disk_io_size;
+		else
+			count = args.len;
+
+		ret = btrfs_encoded_read_regular(&kiocb, &iter, start, lockend,
+						 &cached_state, disk_bytenr,
+						 disk_io_size, count,
+						 args.compression, &unlocked);
+
+		if (!unlocked) {
+			unlock_extent(io_tree, start, lockend, &cached_state);
+			btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
+		}
+	}
+
 	if (ret >= 0) {
 		fsnotify_access(file);
 		if (copy_to_user(argp + copy_end,
-- 
2.43.0



