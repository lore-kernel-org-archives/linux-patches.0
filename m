Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDABF3B813A;
	Sat, 17 Oct 2026 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258162; cv=none; b=l8p8462kPpYPNyLY8g7qDsSH6lhdAlirxnEpdxT5CuzLXJL9Z9g5l3GdPrRUn8IPZlEgmzqq9YH+AlT54/GKF/ZSQt53gPoyQoEARWZrPRuKRh0mjAxxEwhTGWNPHj93fAyNy/63h5tvZ+iojQUTY+onT7hgH6WWtOs5cH1sezI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258162; c=relaxed/simple;
	bh=+Fecf/3ohGo6SuIHyskvQLNg6YgI10vw0jMi59WV+yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpWKC9AmkY9ChMJxr7ewd93Ja8yLKw/Ix3iRwXQmCUTiOWMYQDDKGmFDDiM5A+Oa+pmR/5/SOKSd2YAIBcIFfFyWvY9/lCFlG7HVOG+wBtve0uu16p+WyP9sIFIruFtZsLscypRKjT3gOB7D8WKTp7WVIKBaFlDeh+4XPbtH2zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoxH4SvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoxH4SvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3565E1F000C5;
	Sat, 17 Oct 2026 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258159;
	bh=RtJhtnRFpIkQ7fqdf5PX13guVeNHW774P1qzTlWzHPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoxH4SvWApe1hrhJ9x5gUdBLlOCGBiOpG6S59TDLT9uKDmUFvSvq9wsbq3bEdSvFa
	 l3P6c83JLP+syAU0XcYcEIdDhQcUGN/qhup/3Ao3a1CXaMdHoP0/i6t9oTTate8yRi
	 LeecLwZ0eXrT9R1iakBWhAE/oxxNuIs11J2TsNM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0790/1674] dm: stop using blk_limits_io_{min,opt}
Date: Sat, 17 Oct 2026 17:51:02 +0200
Message-ID: <20261017160451.380517640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0a94a469a4f02bdcc223517fd578810ffc21c548 ]

Remove use of the blk_limits_io_{min,opt} and assign the values directly
to the queue_limits structure.  For the io_opt this is a completely
mechanical change, for io_min it removes flooring the limit to the
physical and logical block size in the particular caller.  But as
blk_validate_limits will do the same later when actually applying the
limits, there still is no change in overall behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Stable-dep-of: 1071d560afb4 ("dm-stripe: fix a possible integer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c  | 4 ++--
 drivers/md/dm-clone-target.c  | 4 ++--
 drivers/md/dm-ebs-target.c    | 2 +-
 drivers/md/dm-era-target.c    | 4 ++--
 drivers/md/dm-integrity.c     | 2 +-
 drivers/md/dm-raid.c          | 4 ++--
 drivers/md/dm-stripe.c        | 4 ++--
 drivers/md/dm-thin.c          | 6 +++---
 drivers/md/dm-verity-target.c | 2 +-
 drivers/md/dm-zoned-target.c  | 4 ++--
 10 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5522f8e9443f2..bbc5c8bb2b856 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3539,8 +3539,8 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (io_opt_sectors < cache->sectors_per_block ||
 	    do_div(io_opt_sectors, cache->sectors_per_block)) {
-		blk_limits_io_min(limits, cache->sectors_per_block << SECTOR_SHIFT);
-		blk_limits_io_opt(limits, cache->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min = cache->sectors_per_block << SECTOR_SHIFT;
+		limits->io_opt = cache->sectors_per_block << SECTOR_SHIFT;
 	}
 
 	disable_passdown_if_not_supported(cache);
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 94b2fc33f64be..56e9a4911d968 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2078,8 +2078,8 @@ static void clone_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (io_opt_sectors < clone->region_size ||
 	    do_div(io_opt_sectors, clone->region_size)) {
-		blk_limits_io_min(limits, clone->region_size << SECTOR_SHIFT);
-		blk_limits_io_opt(limits, clone->region_size << SECTOR_SHIFT);
+		limits->io_min = clone->region_size << SECTOR_SHIFT;
+		limits->io_opt = clone->region_size << SECTOR_SHIFT;
 	}
 
 	disable_passdown_if_not_supported(clone);
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 45b8d314ef0d7..3a609ef221688 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -434,7 +434,7 @@ static void ebs_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->logical_block_size = to_bytes(ec->e_bs);
 	limits->physical_block_size = to_bytes(ec->u_bs);
 	limits->alignment_offset = limits->physical_block_size;
-	blk_limits_io_min(limits, limits->logical_block_size);
+	limits->io_min = limits->logical_block_size;
 }
 
 static int ebs_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 2fe173a9880b2..c8508a0891232 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1743,8 +1743,8 @@ static void era_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (io_opt_sectors < era->sectors_per_block ||
 	    do_div(io_opt_sectors, era->sectors_per_block)) {
-		blk_limits_io_min(limits, 0);
-		blk_limits_io_opt(limits, era->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min = 0;
+		limits->io_opt = era->sectors_per_block << SECTOR_SHIFT;
 	}
 }
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1b562d2189c54..aa6f3e71c4fa2 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3512,7 +3512,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 	if (ic->sectors_per_block > 1) {
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
-		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->dma_alignment = limits->logical_block_size - 1;
 	}
 }
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0c4ab6865182b..2d6a35803c1e8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3782,8 +3782,8 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	struct raid_set *rs = ti->private;
 	unsigned int chunk_size_bytes = to_bytes(rs->md.chunk_sectors);
 
-	blk_limits_io_min(limits, chunk_size_bytes);
-	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
+	limits->io_min = chunk_size_bytes;
+	limits->io_opt = chunk_size_bytes * mddev_data_stripes(rs);
 }
 
 static void raid_postsuspend(struct dm_target *ti)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index e2854a3cbd282..67026e1cbc857 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,8 +458,8 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
-	blk_limits_io_min(limits, chunk_size);
-	blk_limits_io_opt(limits, chunk_size * sc->stripes);
+	limits->io_min = chunk_size;
+	limits->io_opt = chunk_size * sc->stripes;
 }
 
 static struct target_type stripe_target = {
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 7935363d13b1d..1e860940293ab 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4081,10 +4081,10 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	if (io_opt_sectors < pool->sectors_per_block ||
 	    !is_factor(io_opt_sectors, pool->sectors_per_block)) {
 		if (is_factor(pool->sectors_per_block, limits->max_sectors))
-			blk_limits_io_min(limits, limits->max_sectors << SECTOR_SHIFT);
+			limits->io_min = limits->max_sectors << SECTOR_SHIFT;
 		else
-			blk_limits_io_min(limits, pool->sectors_per_block << SECTOR_SHIFT);
-		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+			limits->io_min = pool->sectors_per_block << SECTOR_SHIFT;
+		limits->io_opt = pool->sectors_per_block << SECTOR_SHIFT;
 	}
 
 	/*
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bfd0e80bb9f3a..27ef5c0167cb6 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -996,7 +996,7 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
 		limits->physical_block_size = 1 << v->data_dev_block_bits;
 
-	blk_limits_io_min(limits, limits->logical_block_size);
+	limits->io_min = limits->logical_block_size;
 
 	/*
 	 * Similar to what dm-crypt does, opt dm-verity out of support for
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 36e55a5bcb0de..b57f7259f999d 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -996,8 +996,8 @@ static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->logical_block_size = DMZ_BLOCK_SIZE;
 	limits->physical_block_size = DMZ_BLOCK_SIZE;
 
-	blk_limits_io_min(limits, DMZ_BLOCK_SIZE);
-	blk_limits_io_opt(limits, DMZ_BLOCK_SIZE);
+	limits->io_min = DMZ_BLOCK_SIZE;
+	limits->io_opt = DMZ_BLOCK_SIZE;
 
 	limits->discard_alignment = 0;
 	limits->discard_granularity = DMZ_BLOCK_SIZE;
-- 
2.53.0



