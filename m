Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD1E1C6FF6;
	Wed,  5 Mar 2025 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198221; cv=none; b=uuwo9k1Mc0bO84zxTgvKG37kI30r28OwPNEoXnDXvnFLoSiMZRr75YtZY+Cdavl2Au78EW43BagIIfe9L243Og7JujPMwf3CbFvJ0O10OUySwD9lhT4CABqPIed/P7zkSfSnAZwBwzjCqDv+/oqZbWD2un4n/yCC6HajNJMqOsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198221; c=relaxed/simple;
	bh=a2DYHFD662QpdjkEd6pBXdk4wjblV1bf8oFwA74hn9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J39xvqEDw2nOo0ZDHNx2O+cKbiyWc1PV9moB49mpF3GDKubVW3AaW0oVl/wTJpJ0tFNPhRmxudxE73K0/DITV580EUjWG5Z0bzNkwWDeUcoU4kjIZDQPHU6rEZR28fbjz4XKCk0FPVARhqf/JRrs0MqUSeqjRz6de0GTYFpBux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXSlkzYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXSlkzYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE030C4CEE2;
	Wed,  5 Mar 2025 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198221;
	bh=a2DYHFD662QpdjkEd6pBXdk4wjblV1bf8oFwA74hn9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXSlkzYFwa2a67/VbKtvSJu2ju/ELYk8PBhz38K8Lequj08hF6ztPBhdz4OfNmRzt
	 qNbhl0uNAVGTcKyIBpiMFmOggDFbWF5waibFxpIvUzZ2V/fd7NIqu7ZlwsS88SMEoh
	 IDjCWYJBD5B1gbWbqQmiXPI1WVRmatNBAu1+w3o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorgen Hansen <Jorgen.Hansen@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 105/150] block: Remove zone write plugs when handling native zone append writes
Date: Wed,  5 Mar 2025 18:48:54 +0100
Message-ID: <20250305174508.028159205@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit a6aa36e957a1bfb5341986dec32d013d23228fe1 upstream.

For devices that natively support zone append operations,
REQ_OP_ZONE_APPEND BIOs are not processed through zone write plugging
and are immediately issued to the zoned device. This means that there is
no write pointer offset tracking done for these operations and that a
zone write plug is not necessary.

However, when receiving a zone append BIO, we may already have a zone
write plug for the target zone if that zone was previously partially
written using regular write operations. In such case, since the write
pointer offset of the zone write plug is not incremented by the amount
of sectors appended to the zone, 2 issues arise:
1) we risk leaving the plug in the disk hash table if the zone is fully
   written using zone append or regular write operations, because the
   write pointer offset will never reach the "zone full" state.
2) Regular write operations that are issued after zone append operations
   will always be failed by blk_zone_wplug_prepare_bio() as the write
   pointer alignment check will fail, even if the user correctly
   accounted for the zone append operations and issued the regular
   writes with a correct sector.

Avoid these issues by immediately removing the zone write plug of zones
that are the target of zone append operations when blk_zone_plug_bio()
is called. The new function blk_zone_wplug_handle_native_zone_append()
implements this for devices that natively support zone append. The
removal of the zone write plug using disk_remove_zone_wplug() requires
aborting all plugged regular write using disk_zone_wplug_abort() as
otherwise the plugged write BIOs would never be executed (with the plug
removed, the completion path will never see again the zone write plug as
disk_get_zone_wplug() will return NULL). Rate-limited warnings are added
to blk_zone_wplug_handle_native_zone_append() and to
disk_zone_wplug_abort() to signal this.

Since blk_zone_wplug_handle_native_zone_append() is called in the hot
path for operations that will not be plugged, disk_get_zone_wplug() is
optimized under the assumption that a user issuing zone append
operations is not at the same time issuing regular writes and that there
are no hashed zone write plugs. The struct gendisk atomic counter
nr_zone_wplugs is added to check this, with this counter incremented in
disk_insert_zone_wplug() and decremented in disk_remove_zone_wplug().

To be consistent with this fix, we do not need to fill the zone write
plug hash table with zone write plugs for zones that are partially
written for a device that supports native zone append operations.
So modify blk_revalidate_seq_zone() to return early to avoid allocating
and inserting a zone write plug for partially written sequential zones
if the device natively supports zone append.

Reported-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
Fixes: 9b1ce7f0c6f8 ("block: Implement zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
Link: https://lore.kernel.org/r/20250214041434.82564-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c      |   76 ++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/blkdev.h |    7 ++--
 2 files changed, 73 insertions(+), 10 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -427,13 +427,14 @@ static bool disk_insert_zone_wplug(struc
 		}
 	}
 	hlist_add_head_rcu(&zwplug->node, &disk->zone_wplugs_hash[idx]);
+	atomic_inc(&disk->nr_zone_wplugs);
 	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
 
 	return true;
 }
 
-static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
-						  sector_t sector)
+static struct blk_zone_wplug *disk_get_hashed_zone_wplug(struct gendisk *disk,
+							 sector_t sector)
 {
 	unsigned int zno = disk_zone_no(disk, sector);
 	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
@@ -454,6 +455,15 @@ static struct blk_zone_wplug *disk_get_z
 	return NULL;
 }
 
+static inline struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
+							 sector_t sector)
+{
+	if (!atomic_read(&disk->nr_zone_wplugs))
+		return NULL;
+
+	return disk_get_hashed_zone_wplug(disk, sector);
+}
+
 static void disk_free_zone_wplug_rcu(struct rcu_head *rcu_head)
 {
 	struct blk_zone_wplug *zwplug =
@@ -518,6 +528,7 @@ static void disk_remove_zone_wplug(struc
 	zwplug->flags |= BLK_ZONE_WPLUG_UNHASHED;
 	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
 	hlist_del_init_rcu(&zwplug->node);
+	atomic_dec(&disk->nr_zone_wplugs);
 	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
 	disk_put_zone_wplug(zwplug);
 }
@@ -607,6 +618,11 @@ static void disk_zone_wplug_abort(struct
 {
 	struct bio *bio;
 
+	if (bio_list_empty(&zwplug->bio_list))
+		return;
+
+	pr_warn_ratelimited("%s: zone %u: Aborting plugged BIOs\n",
+			    zwplug->disk->disk_name, zwplug->zone_no);
 	while ((bio = bio_list_pop(&zwplug->bio_list)))
 		blk_zone_wplug_bio_io_error(zwplug, bio);
 }
@@ -1055,6 +1071,47 @@ plug:
 	return true;
 }
 
+static void blk_zone_wplug_handle_native_zone_append(struct bio *bio)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	struct blk_zone_wplug *zwplug;
+	unsigned long flags;
+
+	/*
+	 * We have native support for zone append operations, so we are not
+	 * going to handle @bio through plugging. However, we may already have a
+	 * zone write plug for the target zone if that zone was previously
+	 * partially written using regular writes. In such case, we risk leaving
+	 * the plug in the disk hash table if the zone is fully written using
+	 * zone append operations. Avoid this by removing the zone write plug.
+	 */
+	zwplug = disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
+	if (likely(!zwplug))
+		return;
+
+	spin_lock_irqsave(&zwplug->lock, flags);
+
+	/*
+	 * We are about to remove the zone write plug. But if the user
+	 * (mistakenly) has issued regular writes together with native zone
+	 * append, we must aborts the writes as otherwise the plugged BIOs would
+	 * not be executed by the plug BIO work as disk_get_zone_wplug() will
+	 * return NULL after the plug is removed. Aborting the plugged write
+	 * BIOs is consistent with the fact that these writes will most likely
+	 * fail anyway as there is no ordering guarantees between zone append
+	 * operations and regular write operations.
+	 */
+	if (!bio_list_empty(&zwplug->bio_list)) {
+		pr_warn_ratelimited("%s: zone %u: Invalid mix of zone append and regular writes\n",
+				    disk->disk_name, zwplug->zone_no);
+		disk_zone_wplug_abort(zwplug);
+	}
+	disk_remove_zone_wplug(disk, zwplug);
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	disk_put_zone_wplug(zwplug);
+}
+
 /**
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
@@ -1111,8 +1168,10 @@ bool blk_zone_plug_bio(struct bio *bio,
 	 */
 	switch (bio_op(bio)) {
 	case REQ_OP_ZONE_APPEND:
-		if (!bdev_emulates_zone_append(bdev))
+		if (!bdev_emulates_zone_append(bdev)) {
+			blk_zone_wplug_handle_native_zone_append(bio);
 			return false;
+		}
 		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
@@ -1299,6 +1358,7 @@ static int disk_alloc_zone_resources(str
 {
 	unsigned int i;
 
+	atomic_set(&disk->nr_zone_wplugs, 0);
 	disk->zone_wplugs_hash_bits =
 		min(ilog2(pool_size) + 1, BLK_ZONE_WPLUG_MAX_HASH_BITS);
 
@@ -1353,6 +1413,7 @@ static void disk_destroy_zone_wplugs_has
 		}
 	}
 
+	WARN_ON_ONCE(atomic_read(&disk->nr_zone_wplugs));
 	kfree(disk->zone_wplugs_hash);
 	disk->zone_wplugs_hash = NULL;
 	disk->zone_wplugs_hash_bits = 0;
@@ -1570,11 +1631,12 @@ static int blk_revalidate_seq_zone(struc
 	}
 
 	/*
-	 * We need to track the write pointer of all zones that are not
-	 * empty nor full. So make sure we have a zone write plug for
-	 * such zone if the device has a zone write plug hash table.
+	 * If the device needs zone append emulation, we need to track the
+	 * write pointer of all zones that are not empty nor full. So make sure
+	 * we have a zone write plug for such zone if the device has a zone
+	 * write plug hash table.
 	 */
-	if (!disk->zone_wplugs_hash)
+	if (!queue_emulates_zone_append(disk->queue) || !disk->zone_wplugs_hash)
 		return 0;
 
 	disk_zone_wplug_sync_wp_offset(disk, zone);
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -196,10 +196,11 @@ struct gendisk {
 	unsigned int		zone_capacity;
 	unsigned int		last_zone_capacity;
 	unsigned long __rcu	*conv_zones_bitmap;
-	unsigned int            zone_wplugs_hash_bits;
-	spinlock_t              zone_wplugs_lock;
+	unsigned int		zone_wplugs_hash_bits;
+	atomic_t		nr_zone_wplugs;
+	spinlock_t		zone_wplugs_lock;
 	struct mempool_s	*zone_wplugs_pool;
-	struct hlist_head       *zone_wplugs_hash;
+	struct hlist_head	*zone_wplugs_hash;
 	struct workqueue_struct *zone_wplugs_wq;
 #endif /* CONFIG_BLK_DEV_ZONED */
 


