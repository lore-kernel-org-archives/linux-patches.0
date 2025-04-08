Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7078214205;
	Tue,  8 Apr 2025 11:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110703; cv=none; b=olH/f3XPYmhtIEXw0quNgnJidor0feW9SjpzOjmgX3b1OZtbwCLArf6sQsEpEsDjnGwp63Xt+OHx32VYm2ZwZWNUsVP6AOx6nJwEsbM0fNtVtwxnmod5O3LmI2ILKkwn3prVpjZDrol3IwgE0x7YaHHc4LBsM7JaXAAzSa7V9Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110703; c=relaxed/simple;
	bh=8Y8EsNDG4XKtAO9h6oFcM8gjIeeoes2Ha4dtH2MjcEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGpFiFaduEYn+OB0sXEHrXt/iv/YHav49GsMqQMsBeB/R0mFrkRRtRO0i69TueSWKtMNjVnSp0jWYWTAfrT2YdMDxbLXJqzvW0pfon2kmVW30nGTN8a9ORbKa8JwVQkAoyprGioAyi7D82soPzPMeCgG0tPSxnkIb8u8U+h0d84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmW+OHCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmW+OHCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59253C4CEE5;
	Tue,  8 Apr 2025 11:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110700;
	bh=8Y8EsNDG4XKtAO9h6oFcM8gjIeeoes2Ha4dtH2MjcEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmW+OHCrGwTBW3xLLT5kO/A4MvGPq4vgKY3mPWnyzaCPGtin4lBsygsrjtoiJBRbW
	 bcxgsEfJDA/ew3fS3nWw5EsYMnQ6vi979QJJBfjPwFLdVFlDJOYstQO00kuuudG50B
	 PFrP3HbCjMf2CQgql5fPLwVXtPe7DLcKxMZXawvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 160/731] null_blk: do partial IO for bad blocks
Date: Tue,  8 Apr 2025 12:40:57 +0200
Message-ID: <20250408104917.997513793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 567abc989e3c74c7f4e245492707208c37d27693 ]

The current null_blk implementation checks if any bad blocks exist in
the target blocks of each IO. If so, the IO fails and data is not
transferred for all of the IO target blocks. However, when real storage
devices have bad blocks, the devices may transfer data partially up to
the first bad blocks (e.g., SAS drives). Especially, when the IO is a
write operation, such partial IO leaves partially written data on the
device.

To simulate such partial IO using null_blk, introduce the new parameter
'badblocks_partial_io'. When this parameter is set,
null_handle_badblocks() returns the number of the sectors for the
partial IO as its third pointer argument. Pass the returned number of
sectors to the following calls to null_handle_memory_backend() in
null_process_cmd() and null_zone_write().

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20250226100613.1622564-6-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d301f164c3fb ("badblocks: use sector_t instead of int to avoid truncation of badblocks length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c     | 40 ++++++++++++++++++++++++-------
 drivers/block/null_blk/null_blk.h |  4 ++--
 drivers/block/null_blk/zoned.c    |  9 ++++---
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index b0b009b1136d5..cca278f1d2ce7 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -474,6 +474,7 @@ NULLB_DEVICE_ATTR(shared_tag_bitmap, bool, NULL);
 NULLB_DEVICE_ATTR(fua, bool, NULL);
 NULLB_DEVICE_ATTR(rotational, bool, NULL);
 NULLB_DEVICE_ATTR(badblocks_once, bool, NULL);
+NULLB_DEVICE_ATTR(badblocks_partial_io, bool, NULL);
 
 static ssize_t nullb_device_power_show(struct config_item *item, char *page)
 {
@@ -595,6 +596,7 @@ CONFIGFS_ATTR_WO(nullb_device_, zone_offline);
 static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_badblocks,
 	&nullb_device_attr_badblocks_once,
+	&nullb_device_attr_badblocks_partial_io,
 	&nullb_device_attr_blocking,
 	&nullb_device_attr_blocksize,
 	&nullb_device_attr_cache_size,
@@ -1309,19 +1311,40 @@ static inline blk_status_t null_handle_throttled(struct nullb_cmd *cmd)
 	return sts;
 }
 
+/*
+ * Check if the command should fail for the badblocks. If so, return
+ * BLK_STS_IOERR and return number of partial I/O sectors to be written or read,
+ * which may be less than the requested number of sectors.
+ *
+ * @cmd:        The command to handle.
+ * @sector:     The start sector for I/O.
+ * @nr_sectors: Specifies number of sectors to write or read, and returns the
+ *              number of sectors to be written or read.
+ */
 blk_status_t null_handle_badblocks(struct nullb_cmd *cmd, sector_t sector,
-				   sector_t nr_sectors)
+				   unsigned int *nr_sectors)
 {
 	struct badblocks *bb = &cmd->nq->dev->badblocks;
+	struct nullb_device *dev = cmd->nq->dev;
+	unsigned int block_sectors = dev->blocksize >> SECTOR_SHIFT;
 	sector_t first_bad;
 	int bad_sectors;
+	unsigned int partial_io_sectors = 0;
 
-	if (!badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
+	if (!badblocks_check(bb, sector, *nr_sectors, &first_bad, &bad_sectors))
 		return BLK_STS_OK;
 
 	if (cmd->nq->dev->badblocks_once)
 		badblocks_clear(bb, first_bad, bad_sectors);
 
+	if (cmd->nq->dev->badblocks_partial_io) {
+		if (!IS_ALIGNED(first_bad, block_sectors))
+			first_bad = ALIGN_DOWN(first_bad, block_sectors);
+		if (sector < first_bad)
+			partial_io_sectors = first_bad - sector;
+	}
+	*nr_sectors = partial_io_sectors;
+
 	return BLK_STS_IOERR;
 }
 
@@ -1380,18 +1403,19 @@ blk_status_t null_process_cmd(struct nullb_cmd *cmd, enum req_op op,
 			      sector_t sector, unsigned int nr_sectors)
 {
 	struct nullb_device *dev = cmd->nq->dev;
+	blk_status_t badblocks_ret = BLK_STS_OK;
 	blk_status_t ret;
 
-	if (dev->badblocks.shift != -1) {
-		ret = null_handle_badblocks(cmd, sector, nr_sectors);
+	if (dev->badblocks.shift != -1)
+		badblocks_ret = null_handle_badblocks(cmd, sector, &nr_sectors);
+
+	if (dev->memory_backed && nr_sectors) {
+		ret = null_handle_memory_backed(cmd, op, sector, nr_sectors);
 		if (ret != BLK_STS_OK)
 			return ret;
 	}
 
-	if (dev->memory_backed)
-		return null_handle_memory_backed(cmd, op, sector, nr_sectors);
-
-	return BLK_STS_OK;
+	return badblocks_ret;
 }
 
 static void null_handle_cmd(struct nullb_cmd *cmd, sector_t sector,
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index ee60f3a887967..7bb6128dbaafb 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -64,6 +64,7 @@ struct nullb_device {
 	unsigned int curr_cache;
 	struct badblocks badblocks;
 	bool badblocks_once;
+	bool badblocks_partial_io;
 
 	unsigned int nr_zones;
 	unsigned int nr_zones_imp_open;
@@ -133,11 +134,10 @@ blk_status_t null_handle_discard(struct nullb_device *dev, sector_t sector,
 blk_status_t null_process_cmd(struct nullb_cmd *cmd, enum req_op op,
 			      sector_t sector, unsigned int nr_sectors);
 blk_status_t null_handle_badblocks(struct nullb_cmd *cmd, sector_t sector,
-				   sector_t nr_sectors);
+				   unsigned int *nr_sectors);
 blk_status_t null_handle_memory_backed(struct nullb_cmd *cmd, enum req_op op,
 				       sector_t sector, sector_t nr_sectors);
 
-
 #ifdef CONFIG_BLK_DEV_ZONED
 int null_init_zoned_dev(struct nullb_device *dev, struct queue_limits *lim);
 int null_register_zoned_dev(struct nullb *nullb);
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 7677f6cf23f46..4e5728f459899 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -353,6 +353,7 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	struct nullb_device *dev = cmd->nq->dev;
 	unsigned int zno = null_zone_no(dev, sector);
 	struct nullb_zone *zone = &dev->zones[zno];
+	blk_status_t badblocks_ret = BLK_STS_OK;
 	blk_status_t ret;
 
 	trace_nullb_zone_op(cmd, zno, zone->cond);
@@ -413,9 +414,11 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	}
 
 	if (dev->badblocks.shift != -1) {
-		ret = null_handle_badblocks(cmd, sector, nr_sectors);
-		if (ret != BLK_STS_OK)
+		badblocks_ret = null_handle_badblocks(cmd, sector, &nr_sectors);
+		if (badblocks_ret != BLK_STS_OK && !nr_sectors) {
+			ret = badblocks_ret;
 			goto unlock_zone;
+		}
 	}
 
 	if (dev->memory_backed) {
@@ -438,7 +441,7 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 		zone->cond = BLK_ZONE_COND_FULL;
 	}
 
-	ret = BLK_STS_OK;
+	ret = badblocks_ret;
 
 unlock_zone:
 	null_unlock_zone(dev, zone);
-- 
2.39.5



