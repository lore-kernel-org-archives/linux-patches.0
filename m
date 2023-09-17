Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95046FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134BDC433C8;
	Sun, 17 Sep 2023 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983257;
	bh=en6TzRpPOJgviRR/OxWo2/ErMuiiG6N0Oxq/fXCZqxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFjrYdqgSsRH0lEQNoNqyHJAVlOiztbY833bmkjz5dm8+EJpjHn56A4CVB3igN348
	 2wyFRE26RlEQH1z8iPRuiPI/JJHxSNKUYk7UAsFy7oqCUeq5nQbCCSLUrdVEAu0TvK
	 v56Ak+DKpRWU90pOlhKykuSIsIdtd3wphBujDfrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 489/511] block: rename GENHD_FL_NO_PART_SCAN to GENHD_FL_NO_PART
Date: Sun, 17 Sep 2023 21:15:16 +0200
Message-ID: <20230917191125.541560659@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 46e7eac647b34ed4106a8262f8bedbb90801fadd ]

The GENHD_FL_NO_PART_SCAN controls more than just partitions canning,
so rename it to GENHD_FL_NO_PART.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20211122130625.1136848-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 1a721de8489f ("block: don't add or resize partition on the disk with GENHD_FL_NO_PART")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c            |  2 +-
 drivers/block/loop.c     |  8 ++++----
 drivers/block/n64cart.c  |  2 +-
 drivers/mmc/core/block.c |  4 ++--
 include/linux/genhd.h    | 13 ++++++-------
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a1d9e785dcf70..6123f13e148e0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -495,7 +495,7 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 		 * and don't bother scanning for partitions either.
 		 */
 		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
-		disk->flags |= GENHD_FL_NO_PART_SCAN;
+		disk->flags |= GENHD_FL_NO_PART;
 	} else {
 		ret = bdi_register(disk->bdi, "%u:%u",
 				   disk->major, disk->first_minor);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c96bdb3e7ac52..1d60d5ac0db80 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1314,7 +1314,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
 	if (partscan)
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
+		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
 
 	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
@@ -1463,7 +1463,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	mutex_lock(&lo->lo_mutex);
 	lo->lo_flags = 0;
 	if (!part_shift)
-		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
+		lo->lo_disk->flags |= GENHD_FL_NO_PART;
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
 
@@ -1580,7 +1580,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (!err && (lo->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(prev_lo_flags & LO_FLAGS_PARTSCAN)) {
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
+		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
 		partscan = true;
 	}
 out_unlock:
@@ -2410,7 +2410,7 @@ static int loop_add(int i)
 	 * userspace tools. Parameters like this in general should be avoided.
 	 */
 	if (!part_shift)
-		disk->flags |= GENHD_FL_NO_PART_SCAN;
+		disk->flags |= GENHD_FL_NO_PART;
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	atomic_set(&lo->lo_refcnt, 0);
 	mutex_init(&lo->lo_mutex);
diff --git a/drivers/block/n64cart.c b/drivers/block/n64cart.c
index bcaabf038947c..0bda4a468c660 100644
--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -137,7 +137,7 @@ static int __init n64cart_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	disk->first_minor = 0;
-	disk->flags = GENHD_FL_NO_PART_SCAN;
+	disk->flags = GENHD_FL_NO_PART;
 	disk->fops = &n64cart_fops;
 	disk->private_data = &pdev->dev;
 	strcpy(disk->disk_name, "n64cart");
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 965b44a095077..25077a1a3d821 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2447,8 +2447,8 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	set_disk_ro(md->disk, md->read_only || default_ro);
 	md->disk->flags = GENHD_FL_EXT_DEVT;
 	if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
-		md->disk->flags |= GENHD_FL_NO_PART_SCAN
-				   | GENHD_FL_SUPPRESS_PARTITION_INFO;
+		md->disk->flags |= GENHD_FL_NO_PART |
+				   GENHD_FL_SUPPRESS_PARTITION_INFO;
 
 	/*
 	 * As discussed on lkml, GENHD_FL_REMOVABLE should:
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 300f796b8773d..690b7f7996d15 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -60,15 +60,15 @@ struct partition_meta_info {
  * (``BLOCK_EXT_MAJOR``).
  * This affects the maximum number of partitions.
  *
- * ``GENHD_FL_NO_PART_SCAN`` (0x0200): partition scanning is disabled.
- * Used for loop devices in their default settings and some MMC
- * devices.
+ * ``GENHD_FL_NO_PART`` (0x0200): partition support is disabled.
+ * The kernel will not scan for partitions from add_disk, and users
+ * can't add partitions manually.
  *
  * ``GENHD_FL_HIDDEN`` (0x0400): the block device is hidden; it
  * doesn't produce events, doesn't appear in sysfs, and doesn't have
  * an associated ``bdev``.
  * Implies ``GENHD_FL_SUPPRESS_PARTITION_INFO`` and
- * ``GENHD_FL_NO_PART_SCAN``.
+ * ``GENHD_FL_NO_PART``.
  * Used for multipath devices.
  */
 #define GENHD_FL_REMOVABLE			0x0001
@@ -77,7 +77,7 @@ struct partition_meta_info {
 #define GENHD_FL_CD				0x0008
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	0x0020
 #define GENHD_FL_EXT_DEVT			0x0040
-#define GENHD_FL_NO_PART_SCAN			0x0200
+#define GENHD_FL_NO_PART			0x0200
 #define GENHD_FL_HIDDEN				0x0400
 
 enum {
@@ -185,8 +185,7 @@ static inline int disk_max_parts(struct gendisk *disk)
 
 static inline bool disk_part_scan_enabled(struct gendisk *disk)
 {
-	return disk_max_parts(disk) > 1 &&
-		!(disk->flags & GENHD_FL_NO_PART_SCAN);
+	return disk_max_parts(disk) > 1 && !(disk->flags & GENHD_FL_NO_PART);
 }
 
 static inline dev_t disk_devt(struct gendisk *disk)
-- 
2.40.1



