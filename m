Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B114143C74;
	Tue, 23 Apr 2024 21:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908522; cv=none; b=TLBfdKaFRNQfm2k0fys652uCWomNh4XoKeV1eHDS4Q3aZ35UU2pdd+TM066HTwyohnRJEo9lPPo9KAMesvYWXlGAKwzhY6FXVFOJf4uVGcNn1XBfYm74tuXc+pD/hM5KM9fpdK1Ny+2ZFwxs5suka9tLRHUGzeYHVPpSGc3ayNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908522; c=relaxed/simple;
	bh=pYDMjtPiTnEuMhs4xwA/RoA041LOmMbgzadS/QBUFuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fra1M0pOV9XGhffqp3hmg4fqeJzibU4DO+ETWGVhKfkjJ4HUB+FMOYJUKBSFXk7fC6mKqjkMsv7OtvQNYCd9Vo7h8kg4DWVQ9SR3kuNK/YZWxnfWZQYnwuDy/FCloMmml0+FCme9h1gZojHKR4AymquM3S/17lJ5dOjhZ76HqlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR5dtowu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR5dtowu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F553C32781;
	Tue, 23 Apr 2024 21:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908522;
	bh=pYDMjtPiTnEuMhs4xwA/RoA041LOmMbgzadS/QBUFuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR5dtowu7+7Z1/Civuj9y6jPlRdGPhcRDR+FYvuhURvkOeWglxwHD6D7pp/dWxqHW
	 BCQ5Ai0YQybmpEs9V8u8k/g0L8XYCMOkWz4SFQHfOkYxmZG5n2YjvP6joSGEZCsiCP
	 g+XgKV98T02QkIxtYB62m6WEj3duqs8e8t3HHrHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saranya Muruganandam <saranyamohan@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 087/158] block: propagate partition scanning errors to the BLKRRPART ioctl
Date: Tue, 23 Apr 2024 14:38:29 -0700
Message-ID: <20240423213858.765982038@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 752863bddacab6b5c5164b1df8c8b2e3a175ee28 ]

Commit 4601b4b130de ("block: reopen the device in blkdev_reread_part")
lost the propagation of I/O errors from the low-level read of the
partition table to the user space caller of the BLKRRPART.

Apparently some user space relies on, so restore the propagation.  This
isn't exactly pretty as other block device open calls explicitly do not
are about these errors, so add a new BLK_OPEN_STRICT_SCAN to opt into
the error propagation.

Fixes: 4601b4b130de ("block: reopen the device in blkdev_reread_part")
Reported-by: Saranya Muruganandam <saranyamohan@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20240417144743.2277601-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c           | 29 +++++++++++++++++++----------
 block/ioctl.c          |  3 ++-
 include/linux/blkdev.h |  2 ++
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 678807bcd0034..2b0f97651a0a7 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -639,6 +639,14 @@ static void blkdev_flush_mapping(struct block_device *bdev)
 	bdev_write_inode(bdev);
 }
 
+static void blkdev_put_whole(struct block_device *bdev)
+{
+	if (atomic_dec_and_test(&bdev->bd_openers))
+		blkdev_flush_mapping(bdev);
+	if (bdev->bd_disk->fops->release)
+		bdev->bd_disk->fops->release(bdev->bd_disk);
+}
+
 static int blkdev_get_whole(struct block_device *bdev, blk_mode_t mode)
 {
 	struct gendisk *disk = bdev->bd_disk;
@@ -657,20 +665,21 @@ static int blkdev_get_whole(struct block_device *bdev, blk_mode_t mode)
 
 	if (!atomic_read(&bdev->bd_openers))
 		set_init_blocksize(bdev);
-	if (test_bit(GD_NEED_PART_SCAN, &disk->state))
-		bdev_disk_changed(disk, false);
 	atomic_inc(&bdev->bd_openers);
+	if (test_bit(GD_NEED_PART_SCAN, &disk->state)) {
+		/*
+		 * Only return scanning errors if we are called from contexts
+		 * that explicitly want them, e.g. the BLKRRPART ioctl.
+		 */
+		ret = bdev_disk_changed(disk, false);
+		if (ret && (mode & BLK_OPEN_STRICT_SCAN)) {
+			blkdev_put_whole(bdev);
+			return ret;
+		}
+	}
 	return 0;
 }
 
-static void blkdev_put_whole(struct block_device *bdev)
-{
-	if (atomic_dec_and_test(&bdev->bd_openers))
-		blkdev_flush_mapping(bdev);
-	if (bdev->bd_disk->fops->release)
-		bdev->bd_disk->fops->release(bdev->bd_disk);
-}
-
 static int blkdev_get_part(struct block_device *part, blk_mode_t mode)
 {
 	struct gendisk *disk = part->bd_disk;
diff --git a/block/ioctl.c b/block/ioctl.c
index 438f79c564cfc..5f8c988239c68 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -556,7 +556,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode);
+		return disk_scan_partitions(bdev->bd_disk,
+				mode | BLK_OPEN_STRICT_SCAN);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 99e4f5e722132..b43ca3b9d2a26 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -126,6 +126,8 @@ typedef unsigned int __bitwise blk_mode_t;
 #define BLK_OPEN_WRITE_IOCTL	((__force blk_mode_t)(1 << 4))
 /* open is exclusive wrt all other BLK_OPEN_WRITE opens to the device */
 #define BLK_OPEN_RESTRICT_WRITES	((__force blk_mode_t)(1 << 5))
+/* return partition scanning errors */
+#define BLK_OPEN_STRICT_SCAN	((__force blk_mode_t)(1 << 6))
 
 struct gendisk {
 	/*
-- 
2.43.0



