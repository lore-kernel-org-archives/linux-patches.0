Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4691C0DF1;
	Tue, 30 Jul 2024 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355229; cv=none; b=JPgJwrt+Wi1zFeApjtoi2/c6tYSv59V/jjhfGizqodaqDggRdQ8mNqfQ3Reoq2AusW/F2b/IwuKLQgiLlGEftOJpNsKTjWrgIIbmgljtFihFvhvvQFgPpjfhpFkxxvKZ7E6zKK9Dn2cwPLDUclL+dFWGwVfX1//FC0XpWFH4mkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355229; c=relaxed/simple;
	bh=VycRwp4Sp6uV3CVsFhUQ06NrfVDBIuYr8PZkc1kzWUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLkUKDQgywaM6yY8Esw9cwStfJNueHUksAO8wleaEa6LYP+l6JqxoTpvMpUt+tsF9X/BlrdZVilNSZ+kQWqpfIKVbXE/NZMXdlBe6NnlM6whsHS0Ks/m/1G+9xVTEGyMNmU4fbMA/YAMPBMhMTiG4T7/hM3G8fi290OtmgyksJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xICogF45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xICogF45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B72C4AF0E;
	Tue, 30 Jul 2024 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355228;
	bh=VycRwp4Sp6uV3CVsFhUQ06NrfVDBIuYr8PZkc1kzWUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xICogF45PyeJmAen6lFFW/JmuhdQXLm8Imq3KGciPzVAldL4Opmm+2hZBdor6+jJ3
	 3zhr4Lfu7eiO91CQW9ChlLNHH5SLwu0qk8UbuZ4X8jfJvFYBeAe5Tmd/T5Ql9BTWUA
	 D8ptWPJPNjK+OtrWf41drCBE02K2+B0GrDkd1oPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 012/809] dm: Call dm_revalidate_zones() after setting the queue limits
Date: Tue, 30 Jul 2024 17:38:08 +0200
Message-ID: <20240730151725.144063073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 7f91ccd8a608dbe39b97a6e43d635378d493f77e ]

dm_revalidate_zones() is called from dm_set_zone_restrictions() when the
mapped device queue limits are not yet set. However,
dm_revalidate_zones() calls blk_revalidate_disk_zones() and this
function consults and modifies the mapped device queue limits. Thus,
currently, blk_revalidate_disk_zones() operates on limits that are not
yet initialized.

Fix this by moving the call to dm_revalidate_zones() out of
dm_set_zone_restrictions() and into dm_table_set_restrictions() after
executing queue_limits_set().

To further cleanup dm_set_zones_restrictions(), the message about the
type of zone append (native or emulated) is also moved inside
dm_revalidate_zones().

Fixes: 1c0e720228ad ("dm: use queue_limits_set")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20240611023639.89277-3-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 15 +++++++++++----
 drivers/md/dm-zone.c  | 25 ++++++++++---------------
 drivers/md/dm.h       |  1 +
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b2d5246cff210..2fc847af254de 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2028,10 +2028,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 
-	/*
-	 * For a zoned target, setup the zones related queue attributes
-	 * and resources necessary for zone append emulation if necessary.
-	 */
+	/* For a zoned table, setup the zone related queue attributes. */
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && limits->zoned) {
 		r = dm_set_zones_restrictions(t, q, limits);
 		if (r)
@@ -2042,6 +2039,16 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (r)
 		return r;
 
+	/*
+	 * Now that the limits are set, check the zones mapped by the table
+	 * and setup the resources for zone append emulation if necessary.
+	 */
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && limits->zoned) {
+		r = dm_revalidate_zones(t, q);
+		if (r)
+			return r;
+	}
+
 	dm_update_crypto_profile(q, t);
 
 	/*
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 5d66d916730ef..75d0019a0649d 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -166,14 +166,22 @@ static int dm_check_zoned_cb(struct blk_zone *zone, unsigned int idx,
  * blk_revalidate_disk_zones() function here as the mapped device is suspended
  * (this is called from __bind() context).
  */
-static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
+int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 {
+	struct mapped_device *md = t->md;
 	struct gendisk *disk = md->disk;
 	int ret;
 
+	if (!get_capacity(disk))
+		return 0;
+
 	/* Revalidate only if something changed. */
-	if (!disk->nr_zones || disk->nr_zones != md->nr_zones)
+	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
+		DMINFO("%s using %s zone append",
+		       disk->disk_name,
+		       queue_emulates_zone_append(q) ? "emulated" : "native");
 		md->nr_zones = 0;
+	}
 
 	if (md->nr_zones)
 		return 0;
@@ -240,9 +248,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		lim->max_zone_append_sectors = 0;
 	}
 
-	if (!get_capacity(md->disk))
-		return 0;
-
 	/*
 	 * Count conventional zones to check that the mapped device will indeed 
 	 * have sequential write required zones.
@@ -269,16 +274,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		return 0;
 	}
 
-	if (!md->disk->nr_zones) {
-		DMINFO("%s using %s zone append",
-		       md->disk->disk_name,
-		       queue_emulates_zone_append(q) ? "emulated" : "native");
-	}
-
-	ret = dm_revalidate_zones(md, t);
-	if (ret < 0)
-		return ret;
-
 	if (!static_key_enabled(&zoned_enabled.key))
 		static_branch_enable(&zoned_enabled);
 	return 0;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 53ef8207fe2c1..c984ecb64b1e8 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -103,6 +103,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
  */
 int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		struct queue_limits *lim);
+int dm_revalidate_zones(struct dm_table *t, struct request_queue *q);
 void dm_zone_endio(struct dm_io *io, struct bio *clone);
 #ifdef CONFIG_BLK_DEV_ZONED
 int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
-- 
2.43.0



