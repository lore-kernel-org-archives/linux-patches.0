Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7963624E4B4;
	Wed, 25 Feb 2026 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982834; cv=none; b=YwpZjFZf1EeRAL38JdUYW6qHHpOfanH7pSMaP120p0bJSWDGwekOVgwtHgFQpzLjq8XjM8DOLa/e9B7HTB81cF0ovTnM6hZs9FkisigSspTMTlyxrpn3tytnODiCBq/PFwkXix9ofefQz4l6d2Xr+f0oI271nrP8FpaOnHfoHw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982834; c=relaxed/simple;
	bh=8UNxsXFIb5Fvxsvc7k2wEEuCT7KarDnU63KMkRSoSRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3lJ4sjn0YD4YDRIs2xeJ4/Xp5/Kvqa+I7GED0J+c9lNuzzA/a4aJdSRBW3RAff7+7SWO81YY+HRqJB+1FTvRYgUBY/tg99qC1Ihz5J81LTwIobSSsD0Qw8Rexe11pO8R+rHv2CEI8McmI7pJyU2cWO8obxZoGpubwYAKzR8cIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5ZMbZpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5ZMbZpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A6FC2BC86;
	Wed, 25 Feb 2026 01:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982834;
	bh=8UNxsXFIb5Fvxsvc7k2wEEuCT7KarDnU63KMkRSoSRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5ZMbZpDW1Ph5t2wh2eWDZl+MeNnaapFuAN/pbshLr7jjt8FLZQ52s9O/Offopdtq
	 orCcWaSgAnq1x8QYSX84qBwEzLMMDEFVswLu6cOmcjZyHHdFkRjLoLQjLrYuRp/3x2
	 16L/oEUCk5IIcoJ/in2/XlTq1e4/93yGq+LFBhqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 027/781] btrfs: zoned: dont zone append to conventional zone
Date: Tue, 24 Feb 2026 17:12:16 -0800
Message-ID: <20260225012400.366377887@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index fa1d321a2fb83..e4d382d3a7aea 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -480,6 +480,8 @@ static void btrfs_clone_write_end_io(struct bio *bio)
 
 static void btrfs_submit_dev_bio(struct btrfs_device *dev, struct bio *bio)
 {
+	u64 physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+
 	if (!dev || !dev->bdev ||
 	    test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) ||
 	    (btrfs_op(bio) == BTRFS_MAP_WRITE &&
@@ -494,12 +496,13 @@ static void btrfs_submit_dev_bio(struct btrfs_device *dev, struct bio *bio)
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
@@ -747,7 +750,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	u64 logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	u64 length = bio->bi_iter.bi_size;
 	u64 map_length = length;
-	bool use_append = btrfs_use_zone_append(bbio);
 	struct btrfs_io_context *bioc = NULL;
 	struct btrfs_io_stripe smap;
 	blk_status_t status;
@@ -775,8 +777,10 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	if (bio_op(bio) == REQ_OP_WRITE && is_data_bbio(bbio))
 		bbio->orig_logical = logical;
 
+	bbio->can_use_append = btrfs_use_zone_append(bbio);
+
 	map_length = min(map_length, length);
-	if (use_append)
+	if (bbio->can_use_append)
 		map_length = btrfs_append_map_length(bbio, map_length);
 
 	if (map_length < length) {
@@ -805,11 +809,6 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
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
@@ -836,7 +835,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 			status = errno_to_blk_status(ret);
 			if (status)
 				goto fail;
-		} else if (use_append ||
+		} else if (bbio->can_use_append ||
 			   (btrfs_is_zoned(fs_info) && inode &&
 			    inode->flags & BTRFS_INODE_NODATASUM)) {
 			ret = btrfs_alloc_dummy_sum(bbio);
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 1be74209f0b8d..246c7519dff39 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -92,6 +92,9 @@ struct btrfs_bio {
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



