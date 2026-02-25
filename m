Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0051D5141;
	Wed, 25 Feb 2026 01:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983732; cv=none; b=Fs1Rb9fVqoXF++0DS0KlIOLwMB5RFeTh2l/xnT3lgMrZhvA7aML/lQuXH2mQuZrwe24E0zP72b2GDEjQPVX+tpqa+02LDQPP8/jW3nhO+HMB8rN3bPuKFpDzO/MDpiJFn52x7L/RIj86N+dABfNTWexztzDexwq+wZNXs3gw7Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983732; c=relaxed/simple;
	bh=FXHdcgfSF4eyoJ6B2QDrGqjTSudwpmX0LQB/zwb6Tc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SByZrLBYYfIRdjRGku+gpp2S+wy7XrFElwc3dbzzkIT53MADoKa/sos0S8EjOeeuZLQJM97kgN8Ih5aOXpaob9CKgMhFT9/LTUnMlZz7mWnaTwVaV27K47/+AZDw4OYjR3gwjpyihKRRwq4ckpC4abIIZ+gaqiKZN/sqWUBQ3T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIoEUPyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIoEUPyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D60C116D0;
	Wed, 25 Feb 2026 01:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983732;
	bh=FXHdcgfSF4eyoJ6B2QDrGqjTSudwpmX0LQB/zwb6Tc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIoEUPyw1EmKD7CY1BDyh73I33LfphHPR5nN09eRvVIFcNkUzciCBOV1BKbOarR6T
	 2KA9lB20Z1MmQJ3AUyzkBhAFDm591mTmq32co6LGt3hnbEnWtb2wFn/PVdVRFibJND
	 M9uKIlkfZpOUIrzxONWMlUM8SSh7bespIh4aiQ4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/641] btrfs: zoned: dont zone append to conventional zone
Date: Tue, 24 Feb 2026 17:15:53 -0800
Message-ID: <20260225012349.643654392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit b39b26e017c7889181cb84032e22bef72e81cf29 ]

In case of a zoned RAID, it can happen that a data write is targeting a
sequential write required zone and a conventional zone. In this case the
bio will be marked as REQ_OP_ZONE_APPEND but for the conventional zone,
this needs to be REQ_OP_WRITE.

The setting of REQ_OP_ZONE_APPEND is deferred to the last possible time in
btrfs_submit_dev_bio(), but the decision if we can use zone append is
cached in btrfs_bio.

CC: Naohiro Aota <naohiro.aota@wdc.com>
Fixes: e9b9b911e03c ("btrfs: add raid stripe tree to features enabled with debug config")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 19 +++++++++----------
 fs/btrfs/bio.h |  3 +++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index c3d860a2bca42..9b71f3fde618b 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -441,6 +441,8 @@ static void btrfs_clone_write_end_io(struct bio *bio)
 
 static void btrfs_submit_dev_bio(struct btrfs_device *dev, struct bio *bio)
 {
+	u64 physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+
 	if (!dev || !dev->bdev ||
 	    test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) ||
 	    (btrfs_op(bio) == BTRFS_MAP_WRITE &&
@@ -455,12 +457,13 @@ static void btrfs_submit_dev_bio(struct btrfs_device *dev, struct bio *bio)
 	 * For zone append writing, bi_sector must point the beginning of the
 	 * zone
 	 */
-	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
-		u64 physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	if (btrfs_bio(bio)->can_use_append && btrfs_dev_is_sequential(dev, physical)) {
 		u64 zone_start = round_down(physical, dev->fs_info->zone_size);
 
 		ASSERT(btrfs_dev_is_sequential(dev, physical));
 		bio->bi_iter.bi_sector = zone_start >> SECTOR_SHIFT;
+		bio->bi_opf &= ~REQ_OP_WRITE;
+		bio->bi_opf |= REQ_OP_ZONE_APPEND;
 	}
 	btrfs_debug(dev->fs_info,
 	"%s: rw %d 0x%x, sector=%llu, dev=%lu (%s id %llu), size=%u",
@@ -708,7 +711,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	u64 logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	u64 length = bio->bi_iter.bi_size;
 	u64 map_length = length;
-	bool use_append = btrfs_use_zone_append(bbio);
 	struct btrfs_io_context *bioc = NULL;
 	struct btrfs_io_stripe smap;
 	blk_status_t status;
@@ -736,8 +738,10 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	if (bio_op(bio) == REQ_OP_WRITE && is_data_bbio(bbio))
 		bbio->orig_logical = logical;
 
+	bbio->can_use_append = btrfs_use_zone_append(bbio);
+
 	map_length = min(map_length, length);
-	if (use_append)
+	if (bbio->can_use_append)
 		map_length = btrfs_append_map_length(bbio, map_length);
 
 	if (map_length < length) {
@@ -766,11 +770,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	}
 
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE) {
-		if (use_append) {
-			bio->bi_opf &= ~REQ_OP_WRITE;
-			bio->bi_opf |= REQ_OP_ZONE_APPEND;
-		}
-
 		if (is_data_bbio(bbio) && bioc && bioc->use_rst) {
 			/*
 			 * No locking for the list update, as we only add to
@@ -797,7 +796,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 			status = errno_to_blk_status(ret);
 			if (status)
 				goto fail;
-		} else if (use_append ||
+		} else if (bbio->can_use_append ||
 			   (btrfs_is_zoned(fs_info) && inode &&
 			    inode->flags & BTRFS_INODE_NODATASUM)) {
 			ret = btrfs_alloc_dummy_sum(bbio);
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 488cdbdd9e2f8..126bc68c87605 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -99,6 +99,9 @@ struct btrfs_bio {
 	/* Whether the csum generation for data write is async. */
 	bool async_csum;
 
+	/* Whether the bio is written using zone append. */
+	bool can_use_append;
+
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
 	 * bytes for entire btrfs_bio but relies on bio being last.
-- 
2.51.0



