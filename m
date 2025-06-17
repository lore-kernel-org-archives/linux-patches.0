Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08D3285060;
	Tue, 17 Jun 2025 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178403; cv=none; b=KPAY/lQ4pnemG8whGXmg3/rg86O0FTfSza0pcJ/qd3iZqjYtltWPbVYfTSbc2ZHaypIeSeke3G78L7yzpimBXID/Vl/ZBk14vtC2r3HgC78Mv7hYwwoHhasEI/dwfbxOaFEfhNq6ALn4StnOQoC3TopWNw1/ekHftQrgwCu9Y0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178403; c=relaxed/simple;
	bh=w1ycjzKTwm926wMAKUue6HaJSL0KR7Er+J9l7tpF1Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0Yf+ORfA4r5BdCewtFgVzQM+SgykNflzSk0j1cltZhaFzvBIQqEoiVi9hMeBMXpEswK1ebcIYA5zwW4VAmrDMRNNLfhZ2EfCzGGSfKZ8awnCBDHleBri01xoyGqSgsDZn+61J3H0dEytO4bNYkQGwiOg7kcc8LEOOqq6geS+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vlk7uYZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vlk7uYZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195D7C4CEE3;
	Tue, 17 Jun 2025 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178403;
	bh=w1ycjzKTwm926wMAKUue6HaJSL0KR7Er+J9l7tpF1Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vlk7uYZB8K4BVAGMCqGEtVS3U0qhEWJ8a5Rod2r7qN91OKt+R08gcNqZXXZea3UIy
	 C2of324lCSM3SARa+d3VedgRxriABzNTEtA0N3tVnzUAI+NmOTtxbu0MqonTHNTTVV
	 4lRSmYfS535c6vLXvC8dXlOTa5CfDXbxBlBjVgls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 427/780] dm: handle failures in dm_table_set_restrictions
Date: Tue, 17 Jun 2025 17:22:15 +0200
Message-ID: <20250617152508.857203602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 4ea30ec6fb3bb598bd1df04cdfab13b1140074d2 ]

If dm_table_set_restrictions() fails while swapping tables,
device-mapper will continue using the previous table. It must be sure to
leave the mapped_device in it's previous state on failure.  Otherwise
device-mapper could end up using the old table with settings from the
unused table.

Do not update the mapped device in dm_set_zones_restrictions(). Wait
till after dm_table_set_restrictions() is sure to succeed to update the
md zoned settings. Do the same with the dax settings, and if
dm_revalidate_zones() fails, restore the original queue limits.

Fixes: 7f91ccd8a608d ("dm: Call dm_revalidate_zones() after setting the queue limits")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 26 +++++++++++++++++---------
 drivers/md/dm-zone.c  | 26 ++++++++++++++++++--------
 drivers/md/dm.h       |  1 +
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6b23e777e10e7..9cf82e0513c16 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1834,6 +1834,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
 	int r;
+	struct queue_limits old_limits;
 
 	if (!dm_table_supports_nowait(t))
 		limits->features &= ~BLK_FEAT_NOWAIT;
@@ -1860,16 +1861,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (dm_table_supports_flush(t))
 		limits->features |= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA;
 
-	if (dm_table_supports_dax(t, device_not_dax_capable)) {
+	if (dm_table_supports_dax(t, device_not_dax_capable))
 		limits->features |= BLK_FEAT_DAX;
-		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
-			set_dax_synchronous(t->md->dax_dev);
-	} else
+	else
 		limits->features &= ~BLK_FEAT_DAX;
 
-	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
-		dax_write_cache(t->md->dax_dev, true);
-
 	/* For a zoned table, setup the zone related queue attributes. */
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    (limits->features & BLK_FEAT_ZONED)) {
@@ -1881,7 +1877,8 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (dm_table_supports_atomic_writes(t))
 		limits->features |= BLK_FEAT_ATOMIC_WRITES;
 
-	r = queue_limits_set(q, limits);
+	old_limits = queue_limits_start_update(q);
+	r = queue_limits_commit_update(q, limits);
 	if (r)
 		return r;
 
@@ -1892,10 +1889,21 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    (limits->features & BLK_FEAT_ZONED)) {
 		r = dm_revalidate_zones(t, q);
-		if (r)
+		if (r) {
+			queue_limits_set(q, &old_limits);
 			return r;
+		}
 	}
 
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED))
+		dm_finalize_zone_settings(t, limits);
+
+	if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
+		set_dax_synchronous(t->md->dax_dev);
+
+	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
+		dax_write_cache(t->md->dax_dev, true);
+
 	dm_update_crypto_profile(q, t);
 	return 0;
 }
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 20edd3fabbabf..681058feb63b5 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -340,12 +340,8 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 	 * mapped device queue as needing zone append emulation.
 	 */
 	WARN_ON_ONCE(queue_is_mq(q));
-	if (dm_table_supports_zone_append(t)) {
-		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-	} else {
-		set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+	if (!dm_table_supports_zone_append(t))
 		lim->max_hw_zone_append_sectors = 0;
-	}
 
 	/*
 	 * Determine the max open and max active zone limits for the mapped
@@ -383,9 +379,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		lim->zone_write_granularity = 0;
 		lim->chunk_sectors = 0;
 		lim->features &= ~BLK_FEAT_ZONED;
-		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-		md->nr_zones = 0;
-		disk->nr_zones = 0;
 		return 0;
 	}
 
@@ -408,6 +401,23 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 	return 0;
 }
 
+void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim)
+{
+	struct mapped_device *md = t->md;
+
+	if (lim->features & BLK_FEAT_ZONED) {
+		if (dm_table_supports_zone_append(t))
+			clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		else
+			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+	} else {
+		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		md->nr_zones = 0;
+		md->disk->nr_zones = 0;
+	}
+}
+
+
 /*
  * IO completion callback called from clone_endio().
  */
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index a0a8ff1198158..e5d3a9f46a912 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -102,6 +102,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		struct queue_limits *lim);
 int dm_revalidate_zones(struct dm_table *t, struct request_queue *q);
+void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim);
 void dm_zone_endio(struct dm_io *io, struct bio *clone);
 #ifdef CONFIG_BLK_DEV_ZONED
 int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
-- 
2.39.5



