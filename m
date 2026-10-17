Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3744C3C061D;
	Sat, 17 Oct 2026 17:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259382; cv=none; b=EmCXwAMXgiwbiCEKEkl1KN4JGSo7tnjLsydXut/4GyyrHafGR6+8FLw7OyHi8UR+I6klVL8/TMBRiYMqPlaOa7REms7I6X5m9vxi8qgIHL1pdILlmykknqMV4nwNVE0EztPsQbd/ywPGQQalj6VXz7N4j6hJMkzmEWXrWByj+iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259382; c=relaxed/simple;
	bh=lJUETxIDv5rfHIVAuJjmCPepN+kfPL0+1Vc8d5Hn1X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCAve5sLlpatLHfDXo0xfK+7uX4vEELKT9jgs+anKRk87NAVpwiw/LyHCqexthbKrvg/MI/EhWU5VKDN+s6aaSeXh+ci1JOu+3vSkpJvPqWg50DhuzKbcXD2Bx0OCNCAcFw9H3HcfT6i9O1+XWSIKdKdeg9tncEec6VETr7pQxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWKzlYa8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWKzlYa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854EA1F000C5;
	Sat, 17 Oct 2026 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259381;
	bh=GGuoFZfuI3lhrn38U75DazhgizF0bbXx9+6I/QO6pTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWKzlYa8FMJ+QXTLqyrlt/lLRNrVV5G/Z1/RjmpGHXY3PFX91gQ4mT/3EqEZyfFYe
	 tF9YMJW0/0eVP69BFrbAgVWwkAov9s3uktfATp14nztncQd59Yw+ETA3oHUCWLfe/y
	 yXcNTPst63keNi2LNAFRBSNGTcsAajaY74aIdYrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1144/1674] md/raid10: Handle bio_split() errors
Date: Sat, 17 Oct 2026 17:56:56 +0200
Message-ID: <20261017160500.519593442@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 4cf58d9529097328b669e3c8693ed21e3a041903 ]

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return. Except for discard, where we end the bio
directly.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241111112150.3756529-7-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e045d6ed33f8 ("md/raid10: fix writes_pending leak on write request failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d055365f91302..b47b55c2f5bfe 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1174,6 +1174,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
+	int error;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1226,6 +1227,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1258,6 +1263,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	                              r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
+err_handle:
+	atomic_dec(&rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1398,9 +1408,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
-	int i;
+	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	int error;
 
 	if ((mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1526,6 +1537,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
 					      GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1545,6 +1560,26 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
+	return;
+err_handle:
+	for (k = 0;  k < i; k++) {
+		int d = r10_bio->devs[k].devnum;
+		struct md_rdev *rdev = conf->mirrors[d].rdev;
+		struct md_rdev *rrdev = conf->mirrors[d].replacement;
+
+		if (r10_bio->devs[k].bio) {
+			rdev_dec_pending(rdev, mddev);
+			r10_bio->devs[k].bio = NULL;
+		}
+		if (r10_bio->devs[k].repl_bio) {
+			rdev_dec_pending(rrdev, mddev);
+			r10_bio->devs[k].repl_bio = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
@@ -1695,6 +1730,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = stripe_size - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the fist split part */
@@ -1705,6 +1745,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = bio_sectors(bio) - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the second split part */
-- 
2.53.0



