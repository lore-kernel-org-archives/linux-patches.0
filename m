Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B87248F45;
	Tue, 27 May 2025 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366353; cv=none; b=jFNdzYpAMLJ+eZWXo79pDUDMb4amHBBjDh9GOjDlkB5HRAsylTrPcqYReOiDDum58HrMcTczzeTbgZhkaQDuL0kzTTbLmK9ouI7atyW6Pfi4jd+o5AWw509MHXoLewd+fEkTG0j3OD8wtyKZ9A/VojrNmVtu+wqCIhxXy1HFj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366353; c=relaxed/simple;
	bh=kHmGcnLCLE7U3X0M5ryIiESpsaIYT8d2QrK/8PcclOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnDDgioLwhX8Vse9D7gLz2EDzE+VWLoM5/+PW892hBYnsyTAuS2JlxOn9Yt7+n8dc+3EpnkBJVPhrImcnvCBoa2mtvTdgb1hQZeByHsAete1EdfFcdFysGiyPcux7HT+Gb8J7NPzIMrBeblIDeGSrvQ4pjWuAl1+HRi+apCelWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlGmY2yP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlGmY2yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE82C4CEE9;
	Tue, 27 May 2025 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366353;
	bh=kHmGcnLCLE7U3X0M5ryIiESpsaIYT8d2QrK/8PcclOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlGmY2yPMFYv8U70h5qweiVxV22RcozCFgTGHsQYtjPIqc1+E3OPLNX5+lDGzOg+J
	 pjkKKUj/t8qpSle5M21Xd1GBbX++98AT8qMYqqTff1Ib/W8Bg1IN0yxG32iPPORo4P
	 lCbDn7YRxQ7HsfwSSoAz6PgFILUI/EIosedztRPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 040/783] block: hoist block size validation code to a separate function
Date: Tue, 27 May 2025 18:17:17 +0200
Message-ID: <20250527162514.760518631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit e03463d247ddac66e71143468373df3d74a3a6bd ]

Hoist the block size validation code to bdev_validate_blocksize so that
we can call it from filesystems that don't care about the bdev pagecache
manipulations of set_blocksize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/174543795720.4139148.840349813093799165.stgit@frogsfrogsfrogs
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c           | 33 +++++++++++++++++++++++++++------
 include/linux/blkdev.h |  1 +
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 74f2fe8aa1604..9bb7e041bd9ce 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -150,18 +150,39 @@ static void set_init_blocksize(struct block_device *bdev)
 	BD_INODE(bdev)->i_blkbits = blksize_bits(bsize);
 }
 
-int set_blocksize(struct file *file, int size)
+/**
+ * bdev_validate_blocksize - check that this block size is acceptable
+ * @bdev:	blockdevice to check
+ * @block_size:	block size to check
+ *
+ * For block device users that do not use buffer heads or the block device
+ * page cache, make sure that this block size can be used with the device.
+ *
+ * Return: On success zero is returned, negative error code on failure.
+ */
+int bdev_validate_blocksize(struct block_device *bdev, int block_size)
 {
-	struct inode *inode = file->f_mapping->host;
-	struct block_device *bdev = I_BDEV(inode);
-
-	if (blk_validate_block_size(size))
+	if (blk_validate_block_size(block_size))
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */
-	if (size < bdev_logical_block_size(bdev))
+	if (block_size < bdev_logical_block_size(bdev))
 		return -EINVAL;
 
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bdev_validate_blocksize);
+
+int set_blocksize(struct file *file, int size)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct block_device *bdev = I_BDEV(inode);
+	int ret;
+
+	ret = bdev_validate_blocksize(bdev, size);
+	if (ret)
+		return ret;
+
 	if (!file->private_data)
 		return -EINVAL;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0fec27d6b986c..844af92bea1e4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1616,6 +1616,7 @@ static inline void bio_end_io_acct(struct bio *bio, unsigned long start_time)
 	return bio_end_io_acct_remapped(bio, start_time, bio->bi_bdev);
 }
 
+int bdev_validate_blocksize(struct block_device *bdev, int block_size);
 int set_blocksize(struct file *file, int size);
 
 int lookup_bdev(const char *pathname, dev_t *dev);
-- 
2.39.5



