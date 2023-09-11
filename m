Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A28311706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903E2C433C7;
	Mon, 11 Sep 2023 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443500;
	bh=kH/C6999H2hsAHUGnzi67d9y0I3pE4zIUIGCvy3MK2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzS5O13bTkj7kZrs8ovAfmI9HcbdaAPYCGB3J+SmTDbQiQ8y15l7wzXKzH+MR9IbN
	 Vzu0LtVvIx5noX4lkfhX8oYj0QMK9INAYCdS3kPWBW019/f6eI/vNuL4BngPEQahij
	 h9HevXHllZSGW/sx5DKxtDnWHJkE8zlbUl7lQmWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 400/737] md/raid0: Factor out helper for mapping and submitting a bio
Date: Mon, 11 Sep 2023 15:44:19 +0200
Message-ID: <20230911134701.780677970@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit af50e20afb401cc203bd2a9ff62ece0ae4976103 ]

Factor out helper function for mapping and submitting a bio out of
raid0_make_request(). We will use it later for submitting both parts of
a split bio.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20230814092720.3931-1-jack@suse.cz
Signed-off-by: Song Liu <song@kernel.org>
Stable-dep-of: 319ff40a5427 ("md/raid0: Fix performance regression for large sequential writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c | 79 +++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d1ac73fcd8529..d3c55f2e9b185 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -557,54 +557,21 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 	bio_endio(bio);
 }
 
-static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
+static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
 {
 	struct r0conf *conf = mddev->private;
 	struct strip_zone *zone;
 	struct md_rdev *tmp_dev;
-	sector_t bio_sector;
-	sector_t sector;
-	sector_t orig_sector;
-	unsigned chunk_sects;
-	unsigned sectors;
-
-	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
-	    && md_flush_request(mddev, bio))
-		return true;
-
-	if (unlikely((bio_op(bio) == REQ_OP_DISCARD))) {
-		raid0_handle_discard(mddev, bio);
-		return true;
-	}
-
-	bio_sector = bio->bi_iter.bi_sector;
-	sector = bio_sector;
-	chunk_sects = mddev->chunk_sectors;
-
-	sectors = chunk_sects -
-		(likely(is_power_of_2(chunk_sects))
-		 ? (sector & (chunk_sects-1))
-		 : sector_div(sector, chunk_sects));
-
-	/* Restore due to sector_div */
-	sector = bio_sector;
-
-	if (sectors < bio_sectors(bio)) {
-		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
-					      &mddev->bio_set);
-		bio_chain(split, bio);
-		submit_bio_noacct(bio);
-		bio = split;
-	}
+	sector_t bio_sector = bio->bi_iter.bi_sector;
+	sector_t sector = bio_sector;
 
 	if (bio->bi_pool != &mddev->bio_set)
 		md_account_bio(mddev, &bio);
 
-	orig_sector = sector;
 	zone = find_zone(mddev->private, &sector);
 	switch (conf->layout) {
 	case RAID0_ORIG_LAYOUT:
-		tmp_dev = map_sector(mddev, zone, orig_sector, &sector);
+		tmp_dev = map_sector(mddev, zone, bio_sector, &sector);
 		break;
 	case RAID0_ALT_MULTIZONE_LAYOUT:
 		tmp_dev = map_sector(mddev, zone, sector, &sector);
@@ -612,13 +579,13 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	default:
 		WARN(1, "md/raid0:%s: Invalid layout\n", mdname(mddev));
 		bio_io_error(bio);
-		return true;
+		return;
 	}
 
 	if (unlikely(is_rdev_broken(tmp_dev))) {
 		bio_io_error(bio);
 		md_error(mddev, tmp_dev);
-		return true;
+		return;
 	}
 
 	bio_set_dev(bio, tmp_dev->bdev);
@@ -630,6 +597,40 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 				      bio_sector);
 	mddev_check_write_zeroes(mddev, bio);
 	submit_bio_noacct(bio);
+}
+
+static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
+{
+	sector_t sector;
+	unsigned chunk_sects;
+	unsigned sectors;
+
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
+	    && md_flush_request(mddev, bio))
+		return true;
+
+	if (unlikely((bio_op(bio) == REQ_OP_DISCARD))) {
+		raid0_handle_discard(mddev, bio);
+		return true;
+	}
+
+	sector = bio->bi_iter.bi_sector;
+	chunk_sects = mddev->chunk_sectors;
+
+	sectors = chunk_sects -
+		(likely(is_power_of_2(chunk_sects))
+		 ? (sector & (chunk_sects-1))
+		 : sector_div(sector, chunk_sects));
+
+	if (sectors < bio_sectors(bio)) {
+		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
+					      &mddev->bio_set);
+		bio_chain(split, bio);
+		submit_bio_noacct(bio);
+		bio = split;
+	}
+
+	raid0_map_submit_bio(mddev, bio);
 	return true;
 }
 
-- 
2.40.1



