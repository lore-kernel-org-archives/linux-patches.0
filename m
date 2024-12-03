Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6971F8907;
	Tue,  3 Dec 2024 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240067; cv=none; b=qPq1a8JKKVHyb/0PANo/YCLLXYgbSaHUCnqDbi8NiQuWse+lKHL80+OvaF5qVz7QQMzlYiT5RRVM8BhZl0E7ddpOHJ/g6Bt3D18MwdzZzm75/8fmMxTmvAHH0t1bfuaGVelJzV6+SxkzsyM+SjgLGBZcPP93xQPYwM8uXUUfHH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240067; c=relaxed/simple;
	bh=vajo7+Q0KfgWE+qV8JkWI6bEfGj1e2sSrZbbjf+3GQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/GfaaIKYVLB7WiTUQI8xQZvWsHwmw6BFIYAQqpadonSx3HxL+Ecl60u0UHi2D1wJja7+2SjPk8lugw3pIio5d7AXK2324pXHPrx3vXu0uj5YZ3AmMrUetX1KnP9prypbIlMmqtQ1wZUV35PpumaNibdwGAVxVtTB/r/My86i54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/yFjslH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/yFjslH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33358C4CECF;
	Tue,  3 Dec 2024 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240067;
	bh=vajo7+Q0KfgWE+qV8JkWI6bEfGj1e2sSrZbbjf+3GQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/yFjslHrTnm4HR7xfxKm2+hDNjteTMZFjHjx65w9DulmBu9HKergdbUI//TsJ+Dc
	 GPmoic5hO+VrHh6M/Erfk3GQeYrt+spKohMLf4O2uKCEkg7zJ6MkNccR0lzPdcewJ7
	 4uYvpvuSk8zaTaQBrJw5xsCE8cTfKgpPKh+MymeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/826] fs/block: Check for IOCB_DIRECT in generic_atomic_write_valid()
Date: Tue,  3 Dec 2024 15:35:39 +0100
Message-ID: <20241203144743.934074920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit c3be7ebbbce5201e151f17e28a6c807602f369c9 ]

Currently FMODE_CAN_ATOMIC_WRITE is set if the bdev can atomic write and
the file is open for direct IO. This does not work if the file is not
opened for direct IO, yet fcntl(O_DIRECT) is used on the fd later.

Change to check for direct IO on a per-IO basis in
generic_atomic_write_valid(). Since we want to report -EOPNOTSUPP for
non-direct IO for an atomic write, change to return an error code.

Relocate the block fops atomic write checks to the common write path, as to
catch non-direct IO.

Fixes: c34fc6f26ab8 ("fs: Initial atomic write support")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241019125113.369994-3-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c       | 18 ++++++++++--------
 fs/read_write.c    | 13 ++++++++-----
 include/linux/fs.h |  2 +-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 968b47b615c4b..2d01c90076813 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -36,11 +36,8 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 }
 
 static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
-				struct iov_iter *iter, bool is_atomic)
+				struct iov_iter *iter)
 {
-	if (is_atomic && !generic_atomic_write_valid(iocb, iter))
-		return true;
-
 	return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
 		!bdev_iter_is_aligned(bdev, iter);
 }
@@ -368,13 +365,12 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
-	bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_invalid(bdev, iocb, iter, is_atomic))
+	if (blkdev_dio_invalid(bdev, iocb, iter))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
@@ -383,7 +379,7 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			return __blkdev_direct_IO_simple(iocb, iter, bdev,
 							nr_pages);
 		return __blkdev_direct_IO_async(iocb, iter, bdev, nr_pages);
-	} else if (is_atomic) {
+	} else if (iocb->ki_flags & IOCB_ATOMIC) {
 		return -EINVAL;
 	}
 	return __blkdev_direct_IO(iocb, iter, bdev, bio_max_segs(nr_pages));
@@ -625,7 +621,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (!bdev)
 		return -ENXIO;
 
-	if (bdev_can_atomic_write(bdev) && filp->f_flags & O_DIRECT)
+	if (bdev_can_atomic_write(bdev))
 		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
 
 	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
@@ -700,6 +696,12 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
+	if (iocb->ki_flags & IOCB_ATOMIC) {
+		ret = generic_atomic_write_valid(iocb, from);
+		if (ret)
+			return ret;
+	}
+
 	size -= iocb->ki_pos;
 	if (iov_iter_count(from) > size) {
 		shorted = iov_iter_count(from) - size;
diff --git a/fs/read_write.c b/fs/read_write.c
index 2c32635308281..befec0b5c537a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1830,18 +1830,21 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 	return 0;
 }
 
-bool generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter)
+int generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter)
 {
 	size_t len = iov_iter_count(iter);
 
 	if (!iter_is_ubuf(iter))
-		return false;
+		return -EINVAL;
 
 	if (!is_power_of_2(len))
-		return false;
+		return -EINVAL;
 
 	if (!IS_ALIGNED(iocb->ki_pos, len))
-		return false;
+		return -EINVAL;
 
-	return true;
+	if (!(iocb->ki_flags & IOCB_DIRECT))
+		return -EOPNOTSUPP;
+
+	return 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index faf7596ace971..4b5cad44a1268 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3726,6 +3726,6 @@ static inline bool vfs_empty_path(int dfd, const char __user *path)
 	return !c;
 }
 
-bool generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter);
+int generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter);
 
 #endif /* _LINUX_FS_H */
-- 
2.43.0



