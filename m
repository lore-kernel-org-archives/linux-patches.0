Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998134431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BFFC433EF;
	Wed, 15 Mar 2023 12:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883661;
	bh=3l0FY09G+o5H/iSW/jJtHjlOehmmP5XZ6QjZUro1di8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsTFL9+fYjtEx8yX6E+W6aEsZBRSCV8w9jiNp7qA3hdQyFZn6SQ3yAnMVhJStr7MU
	 Y6Ebnd8Cv1inVMnXSAkDNH1DRh7X7q791aU2enS58XJdxJ1lEGmzSiXY0yPg3IoLCi
	 CnCPwqtfjX+iuD0RNs8fH1rCk5QvJDMdy2XTd2M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/143] block: Revert "block: Do not reread partition table on exclusively open device"
Date: Wed, 15 Mar 2023 13:12:18 +0100
Message-Id: <20230315115742.105965109@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0f77b29ad14e34a89961f32edc87b92db623bb37 ]

This reverts commit 36369f46e91785688a5f39d7a5590e3f07981316.

This patch can't fix the problem in a corner case that device can be
opened exclusively after the checking and before blkdev_get_by_dev().
We'll use a new solution to fix the problem in the next patch, and
the new solution doesn't need to change apis.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230217022200.3092987-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk.h   |  2 +-
 block/genhd.c |  7 ++-----
 block/ioctl.c | 13 ++++++-------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 8b75a95b28d60..a186ea20f39d8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -436,7 +436,7 @@ static inline struct kmem_cache *blk_get_queue_kmem_cache(bool srcu)
 }
 struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner);
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
 
 int disk_alloc_events(struct gendisk *disk);
 void disk_add_events(struct gendisk *disk);
diff --git a/block/genhd.c b/block/genhd.c
index c4765681a8b4b..647f7d8d88312 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -356,7 +356,7 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action)
 }
 EXPORT_SYMBOL_GPL(disk_uevent);
 
-int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
+int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device *bdev;
 
@@ -366,9 +366,6 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode, void *owner)
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
-	/* Someone else has bdev exclusively open? */
-	if (disk->part0->bd_holder && disk->part0->bd_holder != owner)
-		return -EBUSY;
 
 	set_bit(GD_NEED_PART_SCAN, &disk->state);
 	bdev = blkdev_get_by_dev(disk_devt(disk), mode, NULL);
@@ -503,7 +500,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
-			disk_scan_partitions(disk, FMODE_READ, NULL);
+			disk_scan_partitions(disk, FMODE_READ);
 
 		/*
 		 * Announce the disk and partitions after all partitions are
diff --git a/block/ioctl.c b/block/ioctl.c
index 96617512982e5..6dd49d877584a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -467,10 +467,10 @@ static int blkdev_bszset(struct block_device *bdev, fmode_t mode,
  * user space. Note the separate arg/argp parameters that are needed
  * to deal with the compat_ptr() conversion.
  */
-static int blkdev_common_ioctl(struct file *file, fmode_t mode, unsigned cmd,
-			       unsigned long arg, void __user *argp)
+static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
+			       unsigned int cmd, unsigned long arg,
+			       void __user *argp)
 {
-	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	unsigned int max_sectors;
 
 	switch (cmd) {
@@ -528,8 +528,7 @@ static int blkdev_common_ioctl(struct file *file, fmode_t mode, unsigned cmd,
 			return -EACCES;
 		if (bdev_is_partition(bdev))
 			return -EINVAL;
-		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL,
-					    file);
+		return disk_scan_partitions(bdev->bd_disk, mode & ~FMODE_EXCL);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
@@ -607,7 +606,7 @@ long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
@@ -676,7 +675,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
-	ret = blkdev_common_ioctl(file, mode, cmd, arg, argp);
+	ret = blkdev_common_ioctl(bdev, mode, cmd, arg, argp);
 	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
 		ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);
 
-- 
2.39.2



