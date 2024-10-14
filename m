Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126F61ABEB1;
	Mon, 14 Oct 2024 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919094; cv=none; b=H4OJMC2HRnR640JC/SUd+/nAtNidmoO7n/5tpagcMua1NJXtaez/c+lZWdesTgOHcxy8kKi4beWtHlbMhwhgfw1PrzPt0ktdYG3/vCRqGJ081xGz80MSw15vkOV2IPBKXirqdNf/VNfjZVjH+1yCYL4HgcLQsMMIKfFy9jbKEpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919094; c=relaxed/simple;
	bh=8qv4XeD8Ch2Qz+Iqaus1+d473lUMku7M6VKPtY1/NOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hwCf+Cn40t0hY8JTqPNdX3Wt6fa3vmEI4lta+C12ALhS5PUuN7W9oaBMBifGGOyJ3dalO9Gnd0ZffgSkKgvJ2gfQ0RgfFeqkl0YnwJGK1DlHT9VjOx+IGDaFmegFRS5ObFtZyzVSWo4S/iDHrBWN/qUxGZY+qVvEvC/SYkBhL1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hhjdp26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hhjdp26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E850C4CEC3;
	Mon, 14 Oct 2024 15:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919093;
	bh=8qv4XeD8Ch2Qz+Iqaus1+d473lUMku7M6VKPtY1/NOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hhjdp26oUq+l/BN1DoWGw+CsXR6wLc3sfMPW+5P1dlNEH60+W3wuQx2G3DpIM/WC
	 T7cPIx/CYKWYsUcyTlJAU1XEiRLHoQIxfM2RC4wksW3lEHbaFLK6BFIvaGWT5Qgc0z
	 Mbl3DDfFF9RIzjk7A1E4zPEXLNu/0j2IYEEF6dkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 512/798] blk-integrity: register sysfs attributes on struct device
Date: Mon, 14 Oct 2024 16:17:46 +0200
Message-ID: <20241014141238.094776495@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

Upstream commit ff53cd52d9bdbf4074d2bbe9b591729997780bd3.

The "integrity" kobject only acted as a holder for static sysfs entries.
It also was embedded into struct gendisk without managing it, violating
assumptions of the driver core.

Instead register the sysfs entries directly onto the struct device.

Also drop the now unused member integrity_kobj from struct gendisk.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230309-kobj_release-gendisk_integrity-v3-3-ceccb4493c46@weissschuh.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[cascardo: conflict because of constification of integrity_ktype]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c  | 55 +++---------------------------------------
 block/blk.h            | 10 +-------
 block/genhd.c          | 12 +++------
 include/linux/blkdev.h |  3 ---
 4 files changed, 8 insertions(+), 72 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 91a502b01fc72..5276c556a9df9 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -212,31 +212,6 @@ bool blk_integrity_merge_bio(struct request_queue *q, struct request *req,
 	return true;
 }
 
-static ssize_t integrity_attr_show(struct kobject *kobj, struct attribute *attr,
-				   char *page)
-{
-	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
-	struct device *dev = disk_to_dev(disk);
-	struct device_attribute *dev_attr =
-		container_of(attr, struct device_attribute, attr);
-
-	return dev_attr->show(dev, dev_attr, page);
-}
-
-static ssize_t integrity_attr_store(struct kobject *kobj,
-				    struct attribute *attr, const char *page,
-				    size_t count)
-{
-	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
-	struct device *dev = disk_to_dev(disk);
-	struct device_attribute *dev_attr =
-		container_of(attr, struct device_attribute, attr);
-
-	if (!dev_attr->store)
-		return 0;
-	return dev_attr->store(dev, dev_attr, page, count);
-}
-
 static inline struct blk_integrity *dev_to_bi(struct device *dev)
 {
 	return &dev_to_disk(dev)->queue->integrity;
@@ -345,16 +320,10 @@ static struct attribute *integrity_attrs[] = {
 	&dev_attr_device_is_integrity_capable.attr,
 	NULL
 };
-ATTRIBUTE_GROUPS(integrity);
 
-static const struct sysfs_ops integrity_ops = {
-	.show	= &integrity_attr_show,
-	.store	= &integrity_attr_store,
-};
-
-static struct kobj_type integrity_ktype = {
-	.default_groups = integrity_groups,
-	.sysfs_ops	= &integrity_ops,
+const struct attribute_group blk_integrity_attr_group = {
+	.name = "integrity",
+	.attrs = integrity_attrs,
 };
 
 static blk_status_t blk_integrity_nop_fn(struct blk_integrity_iter *iter)
@@ -431,21 +400,3 @@ void blk_integrity_unregister(struct gendisk *disk)
 	memset(bi, 0, sizeof(*bi));
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
-
-int blk_integrity_add(struct gendisk *disk)
-{
-	int ret;
-
-	ret = kobject_init_and_add(&disk->integrity_kobj, &integrity_ktype,
-				   &disk_to_dev(disk)->kobj, "%s", "integrity");
-	if (!ret)
-		kobject_uevent(&disk->integrity_kobj, KOBJ_ADD);
-	return ret;
-}
-
-void blk_integrity_del(struct gendisk *disk)
-{
-	kobject_uevent(&disk->integrity_kobj, KOBJ_REMOVE);
-	kobject_del(&disk->integrity_kobj);
-	kobject_put(&disk->integrity_kobj);
-}
diff --git a/block/blk.h b/block/blk.h
index 9b2f53ff4c37f..75316eab02470 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -212,8 +212,7 @@ static inline bool integrity_req_gap_front_merge(struct request *req,
 				bip_next->bip_vec[0].bv_offset);
 }
 
-int blk_integrity_add(struct gendisk *disk);
-void blk_integrity_del(struct gendisk *);
+extern const struct attribute_group blk_integrity_attr_group;
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 static inline bool blk_integrity_merge_rq(struct request_queue *rq,
 		struct request *r1, struct request *r2)
@@ -246,13 +245,6 @@ static inline bool bio_integrity_endio(struct bio *bio)
 static inline void bio_integrity_free(struct bio *bio)
 {
 }
-static inline int blk_integrity_add(struct gendisk *disk)
-{
-	return 0;
-}
-static inline void blk_integrity_del(struct gendisk *disk)
-{
-}
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 unsigned long blk_rq_timeout(unsigned long timeout);
diff --git a/block/genhd.c b/block/genhd.c
index f9e3ecd5ba2fa..146ce13b192bb 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -489,15 +489,11 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	 */
 	pm_runtime_set_memalloc_noio(ddev, true);
 
-	ret = blk_integrity_add(disk);
-	if (ret)
-		goto out_del_block_link;
-
 	disk->part0->bd_holder_dir =
 		kobject_create_and_add("holders", &ddev->kobj);
 	if (!disk->part0->bd_holder_dir) {
 		ret = -ENOMEM;
-		goto out_del_integrity;
+		goto out_del_block_link;
 	}
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 	if (!disk->slave_dir) {
@@ -564,8 +560,6 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	disk->slave_dir = NULL;
 out_put_holder_dir:
 	kobject_put(disk->part0->bd_holder_dir);
-out_del_integrity:
-	blk_integrity_del(disk);
 out_del_block_link:
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(ddev));
@@ -624,7 +618,6 @@ void del_gendisk(struct gendisk *disk)
 	if (WARN_ON_ONCE(!disk_live(disk) && !(disk->flags & GENHD_FL_HIDDEN)))
 		return;
 
-	blk_integrity_del(disk);
 	disk_del_events(disk);
 
 	mutex_lock(&disk->open_mutex);
@@ -1160,6 +1153,9 @@ static const struct attribute_group *disk_attr_groups[] = {
 	&disk_attr_group,
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	&blk_trace_attr_group,
+#endif
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	&blk_integrity_attr_group,
 #endif
 	NULL
 };
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e255674a9ee72..f77e8785802e2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -163,9 +163,6 @@ struct gendisk {
 	struct timer_rand_state *random;
 	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
-#ifdef  CONFIG_BLK_DEV_INTEGRITY
-	struct kobject integrity_kobj;
-#endif	/* CONFIG_BLK_DEV_INTEGRITY */
 
 #ifdef CONFIG_BLK_DEV_ZONED
 	/*
-- 
2.43.0



