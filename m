Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4495358D0A;
	Wed,  3 Dec 2025 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778855; cv=none; b=d9SsVDnsxVn6t4t+9J/xUvtsxNBqtaiRInV0OHBFtpo0fi/feZmDq0EFdpiWyBWya2QSO8MFQbxMJoccA+zxg+mnhmvJVuhOW9jp8YKi9Ns5N7m56+eHglEoHiwQscnOQQDCCZkemcIOF1JGaV8FiK0PSieChCCsZRVC8eEsPAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778855; c=relaxed/simple;
	bh=MoV+pQX/ZKFRTd8oXlUtZ5/yZXYc+1l8MdNh9qEHQnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGA6av0fX5QK5z678GqSJ4IH4lOJgWpsGTzzd1c+1jdwdb//aVP2SG+hPuHhkDDF8UPDZpOMBLIJb8kWV3b6ISbWWanhJpe98nEiQM15Uy3fr2woFPvz9eT3N7gmSave9DzgcbmHocfWTmfsvbLW1GOexU7/U2jK3UI70FGjWbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWxl+Pi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWxl+Pi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB6EC4CEF5;
	Wed,  3 Dec 2025 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778855;
	bh=MoV+pQX/ZKFRTd8oXlUtZ5/yZXYc+1l8MdNh9qEHQnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWxl+Pi0HcrmFzvyB3yolWC8RXI1U2FojnNKSvepGx/8AyhnYwXPt/Hst55R6AZcz
	 etTliewtGlUxnXWXFAquskG1jaDEKU8b+SF8lea+XMZaADP3eUQfGH0P9WToGtnzZp
	 Qm4DpUEN0S+Lgum3ffpJxyGLThd8M2zS76MZbasc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Mahmoud Adam <mngyadam@amazon.de>
Subject: [PATCH 6.1 081/568] block: fix race between set_blocksize and read paths
Date: Wed,  3 Dec 2025 16:21:23 +0100
Message-ID: <20251203152443.687366299@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0e473a0d226479e8e925d5ba93f751d8df628e9 upstream.

With the new large sector size support, it's now the case that
set_blocksize can change i_blksize and the folio order in a manner that
conflicts with a concurrent reader and causes a kernel crash.

Specifically, let's say that udev-worker calls libblkid to detect the
labels on a block device.  The read call can create an order-0 folio to
read the first 4096 bytes from the disk.  But then udev is preempted.

Next, someone tries to mount an 8k-sectorsize filesystem from the same
block device.  The filesystem calls set_blksize, which sets i_blksize to
8192 and the minimum folio order to 1.

Now udev resumes, still holding the order-0 folio it allocated.  It then
tries to schedule a read bio and do_mpage_readahead tries to create
bufferheads for the folio.  Unfortunately, blocks_per_folio == 0 because
the page size is 4096 but the blocksize is 8192 so no bufferheads are
attached and the bh walk never sets bdev.  We then submit the bio with a
NULL block device and crash.

Therefore, truncate the page cache after flushing but before updating
i_blksize.  However, that's not enough -- we also need to lock out file
IO and page faults during the update.  Take both the i_rwsem and the
invalidate_lock in exclusive mode for invalidations, and in shared mode
for read/write operations.

I don't know if this is the correct fix, but xfs/259 found it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/174543795699.4139148.2086129139322431423.stgit@frogsfrogsfrogs
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[use bdev->bd_inode instead & fix small contextual changes]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bdev.c      |   17 +++++++++++++++++
 block/blk-zoned.c |    5 ++++-
 block/fops.c      |   16 ++++++++++++++++
 block/ioctl.c     |    6 ++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

--- a/block/bdev.c
+++ b/block/bdev.c
@@ -147,9 +147,26 @@ int set_blocksize(struct block_device *b
 
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_inode->i_blkbits != blksize_bits(size)) {
+		/*
+		 * Flush and truncate the pagecache before we reconfigure the
+		 * mapping geometry because folio sizes are variable now.  If a
+		 * reader has already allocated a folio whose size is smaller
+		 * than the new min_order but invokes readahead after the new
+		 * min_order becomes visible, readahead will think there are
+		 * "zero" blocks per folio and crash.  Take the inode and
+		 * invalidation locks to avoid racing with
+		 * read/write/fallocate.
+		 */
+		inode_lock(bdev->bd_inode);
+		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
+
 		sync_blockdev(bdev);
+		kill_bdev(bdev);
+
 		bdev->bd_inode->i_blkbits = blksize_bits(size);
 		kill_bdev(bdev);
+		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+		inode_unlock(bdev->bd_inode);
 	}
 	return 0;
 }
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -417,6 +417,7 @@ int blkdev_zone_mgmt_ioctl(struct block_
 		op = REQ_OP_ZONE_RESET;
 
 		/* Invalidate the page cache, including dirty pages. */
+		inode_lock(bdev->bd_inode);
 		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
 		if (ret)
@@ -439,8 +440,10 @@ int blkdev_zone_mgmt_ioctl(struct block_
 			       GFP_KERNEL);
 
 fail:
-	if (cmd == BLKRESETZONE)
+	if (cmd == BLKRESETZONE) {
 		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+		inode_unlock(bdev->bd_inode);
+	}
 
 	return ret;
 }
--- a/block/fops.c
+++ b/block/fops.c
@@ -592,7 +592,14 @@ static ssize_t blkdev_write_iter(struct
 			ret = direct_write_fallback(iocb, from, ret,
 					generic_perform_write(iocb, from));
 	} else {
+		/*
+		 * Take i_rwsem and invalidate_lock to avoid racing with
+		 * set_blocksize changing i_blkbits/folio order and punching
+		 * out the pagecache.
+		 */
+		inode_lock_shared(bd_inode);
 		ret = generic_perform_write(iocb, from);
+		inode_unlock_shared(bd_inode);
 	}
 
 	if (ret > 0)
@@ -605,6 +612,7 @@ static ssize_t blkdev_write_iter(struct
 static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	loff_t pos = iocb->ki_pos;
 	size_t shorted = 0;
@@ -652,7 +660,13 @@ static ssize_t blkdev_read_iter(struct k
 			goto reexpand;
 	}
 
+	/*
+	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
+	 * changing i_blkbits/folio order and punching out the pagecache.
+	 */
+	inode_lock_shared(bd_inode);
 	ret = filemap_read(iocb, to, ret);
+	inode_unlock_shared(bd_inode);
 
 reexpand:
 	if (unlikely(shorted))
@@ -695,6 +709,7 @@ static long blkdev_fallocate(struct file
 	if ((start | len) & (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 
 	/*
@@ -735,6 +750,7 @@ static long blkdev_fallocate(struct file
 
  fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return error;
 }
 
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -114,6 +114,7 @@ static int blk_ioctl_discard(struct bloc
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (err)
@@ -121,6 +122,7 @@ static int blk_ioctl_discard(struct bloc
 	err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 
@@ -146,12 +148,14 @@ static int blk_ioctl_secure_erase(struct
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	inode_lock(bdev->bd_inode);
 	filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (!err)
 		err = blkdev_issue_secure_erase(bdev, start >> 9, len >> 9,
 						GFP_KERNEL);
 	filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+	inode_unlock(bdev->bd_inode);
 	return err;
 }
 
@@ -184,6 +188,7 @@ static int blk_ioctl_zeroout(struct bloc
 		return -EINVAL;
 
 	/* Invalidate the page cache, including dirty pages */
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end);
 	if (err)
@@ -194,6 +199,7 @@ static int blk_ioctl_zeroout(struct bloc
 
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 


