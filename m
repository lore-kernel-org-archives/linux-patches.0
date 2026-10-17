Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9731F36CE19;
	Sat, 17 Oct 2026 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253669; cv=none; b=VCgJkzXibhSF9buIJVU1uIqsb2i5VyMwpbs2ImGZEnXw3Wyr4AMctoVzVe5ZnHgS65O9Rvy/BmJXNcKmh2Vt8dmEG/iBrg6RWh0hFaHz3MxsgzgewexepPp6N3Ur77K23Wx7wQd21fepB0zaibXV1PWr747OHRTDwZ4mbarAJlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253669; c=relaxed/simple;
	bh=OUj381G5NS8PQmeepoB0MiN+brKusZyMwmOZLXZ+85Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lo9iOV1JkgUjPSzqcwnlN9BxV7FVHnXguQpmgHXqy7a7IlGr1wBWMags0x7a8fZ1pxgZ5dH0hGiokrrXhis3sAiC3K4c0ea+ClkTNYon7UfjpD3Pv2E0oZAZakTwgfJsryr9pwg5TjwVv5hTlwowCPrKG2tAjSdc0ZZ/ay8R3nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkuGWOpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkuGWOpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FCB1F000C4;
	Sat, 17 Oct 2026 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253668;
	bh=+WU8ndcfoNat6z15nJEyVsMIvfxmLTyc0g5dKkSI0bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkuGWOpTy2mnAEfoeYXBSaKT6k7wj1GRR3vPb1yeFkfmTvqFTdMs02wyJo+s6/ISY
	 Vs8gEZypxiIVBD7aG+YZPep813sDVG2nVVhLuFKbIjwdB6jTQVSkO2p3uFTuXZNcU5
	 /zJ5xhMoBn7jsG+ftuBTPgA0+hnTIOliGwaMPaSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/869] dm: limit swapping tables for devices with zone write plugs
Date: Sat, 17 Oct 2026 17:50:34 +0200
Message-ID: <20261017160042.003632230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 121218bef4c1df165181f5cd8fc3a2246bac817e ]

dm_revalidate_zones() only allowed new or previously unzoned devices to
call blk_revalidate_disk_zones(). If the device was already zoned,
disk->nr_zones would always equal md->nr_zones, so dm_revalidate_zones()
returned without doing any work. This would make the zoned settings for
the device not match the new table. If the device had zone write plug
resources, it could run into errors like bdev_zone_is_seq() reading
invalid memory because disk->conv_zones_bitmap was the wrong size.

If the device doesn't have any zone write plug resources, calling
blk_revalidate_disk_zones() will always correctly update device.  If
blk_revalidate_disk_zones() fails, it can still overwrite or clear the
current disk->nr_zones value. In this case, DM must restore the previous
value of disk->nr_zones, so that the zoned settings will continue to
match the previous value that it fell back to.

If the device already has zone write plug resources,
blk_revalidate_disk_zones() will not correctly update them, if it is
called for arbitrary zoned device changes.  Since there is not much need
for this ability, the easiest solution is to disallow any table reloads
that change the zoned settings, for devices that already have zone plug
resources.  Specifically, if a device already has zone plug resources
allocated, it can only switch to another zoned table that also emulates
zone append.  Also, it cannot change the device size or the zone size. A
device can switch to an error target.

Fixes: bb37d77239af2 ("dm: introduce zone append emulation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 41 ++++++++++++++++++++++++++++++++++++-----
 drivers/md/dm-zone.c  | 34 +++++++++++++++++++++++++---------
 drivers/md/dm.c       |  6 ++++++
 drivers/md/dm.h       |  5 +++++
 4 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 20b8f560a2da5..505f8a900ec9e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1505,6 +1505,18 @@ bool dm_table_has_no_data_devices(struct dm_table *t)
 	return true;
 }
 
+bool dm_table_is_wildcard(struct dm_table *t)
+{
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (!dm_target_is_wildcard(ti->type))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_zoned(struct dm_target *ti, struct dm_dev *dev,
 			    sector_t start, sector_t len, void *data)
 {
@@ -1823,6 +1835,19 @@ static bool dm_table_supports_secure_erase(struct dm_table *t)
 	return true;
 }
 
+bool dm_table_supports_size_change(struct dm_table *t, sector_t old_size,
+				   sector_t new_size)
+{
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && dm_has_zone_plugs(t->md) &&
+	    old_size != new_size) {
+		DMWARN("%s: device has zone write plug resources. "
+		       "Cannot change size",
+		       dm_device_name(t->md));
+		return false;
+	}
+	return true;
+}
+
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
@@ -1864,11 +1889,17 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		dax_write_cache(t->md->dax_dev, true);
 
 	/* For a zoned table, setup the zone related queue attributes. */
-	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
-	    (limits->features & BLK_FEAT_ZONED)) {
-		r = dm_set_zones_restrictions(t, q, limits);
-		if (r)
-			return r;
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED)) {
+		if (limits->features & BLK_FEAT_ZONED) {
+			r = dm_set_zones_restrictions(t, q, limits);
+			if (r)
+				return r;
+		} else if (dm_has_zone_plugs(t->md)) {
+			DMWARN("%s: device has zone write plug resources. "
+			       "Cannot switch to non-zoned table.",
+			       dm_device_name(t->md));
+			return -EINVAL;
+		}
 	}
 
 	r = queue_limits_set(q, limits);
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 912b9fe1f5648..85777d875cc00 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -163,22 +163,22 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 {
 	struct mapped_device *md = t->md;
 	struct gendisk *disk = md->disk;
+	unsigned int nr_zones = disk->nr_zones;
 	int ret;
 
 	if (!get_capacity(disk))
 		return 0;
 
-	/* Revalidate only if something changed. */
-	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
-		DMINFO("%s using %s zone append",
-		       disk->disk_name,
-		       queue_emulates_zone_append(q) ? "emulated" : "native");
-		md->nr_zones = 0;
-	}
-
-	if (md->nr_zones)
+	/*
+	 * Do not revalidate if zone write plug resources have already
+	 * been allocated.
+	 */
+	if (dm_has_zone_plugs(md))
 		return 0;
 
+	DMINFO("%s using %s zone append", disk->disk_name,
+	       queue_emulates_zone_append(q) ? "emulated" : "native");
+
 	/*
 	 * Our table is not live yet. So the call to dm_get_live_table()
 	 * in dm_blk_report_zones() will fail. Set a temporary pointer to
@@ -192,6 +192,7 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 
 	if (ret) {
 		DMERR("Revalidate zones failed %d", ret);
+		disk->nr_zones = nr_zones;
 		return ret;
 	}
 
@@ -401,6 +402,21 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		return 0;
 	}
 
+	if (get_capacity(disk) && dm_has_zone_plugs(t->md)) {
+		if (q->limits.chunk_sectors != lim->chunk_sectors) {
+			DMWARN("%s: device has zone write plug resources. "
+			       "Cannot change zone size",
+			       disk->disk_name);
+			return -EINVAL;
+		}
+		if (lim->max_zone_append_sectors != 0 &&
+		    !dm_table_is_wildcard(t)) {
+			DMWARN("%s: device has zone write plug resources. "
+			       "New table must emulate zone append",
+			       disk->disk_name);
+			return -EINVAL;
+		}
+	}
 	/*
 	 * Warn once (when the capacity is not yet set) if the mapped device is
 	 * partially using zone resources of the target devices as that leads to
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 20f6c6ebace0e..e23d4c63484b3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2451,6 +2451,12 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	size = dm_table_get_size(t);
 
 	old_size = dm_get_size(md);
+
+	if (!dm_table_supports_size_change(t, old_size, size)) {
+		old_map = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	set_capacity(md->disk, size);
 
 	ret = dm_table_set_restrictions(t, md->queue, limits);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 8ad782249af88..8887c1f65639d 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -58,6 +58,7 @@ void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
 bool dm_table_has_no_data_devices(struct dm_table *table);
+bool dm_table_is_wildcard(struct dm_table *t);
 int dm_calculate_queue_limits(struct dm_table *table,
 			      struct queue_limits *limits);
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
@@ -73,6 +74,8 @@ struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
 bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
+bool dm_table_supports_size_change(struct dm_table *t, sector_t old_size,
+				   sector_t new_size);
 
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
@@ -112,12 +115,14 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
 int dm_zone_get_reset_bitmap(struct mapped_device *md, struct dm_table *t,
 			     sector_t sector, unsigned int nr_zones,
 			     unsigned long *need_reset);
+#define dm_has_zone_plugs(md) ((md)->disk->zone_wplugs_hash != NULL)
 #else
 #define dm_blk_report_zones	NULL
 static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
 {
 	return false;
 }
+#define dm_has_zone_plugs(md) false
 #endif
 
 /*
-- 
2.53.0



