Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833C21772B;
	Tue, 29 Apr 2025 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945942; cv=none; b=N+5zsKurY0vSeBQ5L38ufjREq19jdrpH7AYwGkT85co2swl9AhxES+JhO7u3ZrYDEiHc8KJ4TGC1zWgNGeQzjqiRvWcMFLPMFBPPiU7qt8eotJODBHQ+3tK5e97DyPF97hiC96OcF0FES/cAMFLjY/D9OV5+jLSvrjYgclWFayY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945942; c=relaxed/simple;
	bh=i8CbdBT6LSG9l1ncl6iqw/tRES+Jp7w0T80AeIjZvP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpojWj/ot1pCS+RWWxnNNQTh5t0xd1Vv5z8m+WtjDvn3XOcdaBv7cfR82OUeaXFDUPDdwElHUfg6vYjFbYDGbUwiv9JFww0rJSZNAX4l2Xn4WetPYbUHRJ39zpvKhVC8ZipaCKd/3Q1j+XVdwSWUOG3iDpkkMEfNZ3eXGQ43A+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZGbMAxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZGbMAxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE57C4CEE3;
	Tue, 29 Apr 2025 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945942;
	bh=i8CbdBT6LSG9l1ncl6iqw/tRES+Jp7w0T80AeIjZvP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZGbMAxnl3nCyOqi5svgAdL3auH6ZXYYPX+kkXJvKOO+MN8Cbi3UFVpzXdmszokLR
	 i9pRVcYn3BKKhILR6FZzT5RAaE9gf+Xv7XZ2KqBsm2nFvEHDoTle5uLcyipKp9TFRP
	 LOAzDWolS6yHEdb6y6nMYHYCxC+rjz7+Xy+idb64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 084/311] block: dont autoload drivers on stat
Date: Tue, 29 Apr 2025 18:38:41 +0200
Message-ID: <20250429161124.493922058@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5f33b5226c9d92359e58e91ad0bf0c1791da36a1 ]

blkdev_get_no_open can trigger the legacy autoload of block drivers.  A
simple stat of a block device has not historically done that, so disable
this behavior again.

Fixes: 9abcfbd235f5 ("block: Add atomic write support for statx")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250423053810.1683309-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c       | 8 ++++----
 block/blk-cgroup.c | 2 +-
 block/blk.h        | 2 +-
 block/fops.c       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 89235796e51a5..5aebcf437f17c 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -773,13 +773,13 @@ static void blkdev_put_part(struct block_device *part)
 	blkdev_put_whole(whole);
 }
 
-struct block_device *blkdev_get_no_open(dev_t dev)
+struct block_device *blkdev_get_no_open(dev_t dev, bool autoload)
 {
 	struct block_device *bdev;
 	struct inode *inode;
 
 	inode = ilookup(blockdev_superblock, dev);
-	if (!inode && IS_ENABLED(CONFIG_BLOCK_LEGACY_AUTOLOAD)) {
+	if (!inode && autoload && IS_ENABLED(CONFIG_BLOCK_LEGACY_AUTOLOAD)) {
 		blk_request_module(dev);
 		inode = ilookup(blockdev_superblock, dev);
 		if (inode)
@@ -1001,7 +1001,7 @@ struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 	if (ret)
 		return ERR_PTR(ret);
 
-	bdev = blkdev_get_no_open(dev);
+	bdev = blkdev_get_no_open(dev, true);
 	if (!bdev)
 		return ERR_PTR(-ENXIO);
 
@@ -1279,7 +1279,7 @@ void bdev_statx(struct path *path, struct kstat *stat,
 	 * use I_BDEV() here; the block device has to be looked up by i_rdev
 	 * instead.
 	 */
-	bdev = blkdev_get_no_open(d_backing_inode(path->dentry)->i_rdev);
+	bdev = blkdev_get_no_open(d_backing_inode(path->dentry)->i_rdev, false);
 	if (!bdev)
 		return;
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9ed93d91d754a..c94efae5bcfaf 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -796,7 +796,7 @@ int blkg_conf_open_bdev(struct blkg_conf_ctx *ctx)
 		return -EINVAL;
 	input = skip_spaces(input);
 
-	bdev = blkdev_get_no_open(MKDEV(major, minor));
+	bdev = blkdev_get_no_open(MKDEV(major, minor), true);
 	if (!bdev)
 		return -ENODEV;
 	if (bdev_is_partition(bdev)) {
diff --git a/block/blk.h b/block/blk.h
index c0120a3d9dc57..9dcc92c7f2b50 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -94,7 +94,7 @@ static inline void blk_wait_io(struct completion *done)
 		wait_for_completion_io(done);
 }
 
-struct block_device *blkdev_get_no_open(dev_t dev);
+struct block_device *blkdev_get_no_open(dev_t dev, bool autoload);
 void blkdev_put_no_open(struct block_device *bdev);
 
 #define BIO_INLINE_VECS 4
diff --git a/block/fops.c b/block/fops.c
index be9f1dbea9ce0..d23ddb2dc1138 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -642,7 +642,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (ret)
 		return ret;
 
-	bdev = blkdev_get_no_open(inode->i_rdev);
+	bdev = blkdev_get_no_open(inode->i_rdev, true);
 	if (!bdev)
 		return -ENXIO;
 
-- 
2.39.5



