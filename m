Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB12134AC;
	Tue, 21 Oct 2025 20:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077028; cv=none; b=eRalKsLO/fAm/Tncwxwg8XmEME7lKqwE402Phz85t/ipE+mQKvIy680UwQTKIA1c+Qr4xHUegHf7F0YzHiSU+mdNHhjeuw9rOxbvNgiebxdGXwP+igBCwiVgl7BRNBQaFZkCMpW/WDTkcRrLS3UDCmWrQSqg/7SpqzMi3q6tAJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077028; c=relaxed/simple;
	bh=7uPi5S9P4G6TPDpqRO0Pwo0nwFvHY2rNVFdeRo/436s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rioousETMXzD1QN5A7jnH9OdafO4fMEpPOo8VHu9EEI20a0Nzn4uWDKmRJWjts31b1Q2aSYX8jtavog9R8U9Nh96PKM71VFqR3nyGc1s9d/MLBqqly/rCCCldseOhVHB+ihUabYL+RLXevz8v1OV67ntj9ca/eTPzikRICHKidw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QO/sGYRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QO/sGYRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7969C116B1;
	Tue, 21 Oct 2025 20:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077028;
	bh=7uPi5S9P4G6TPDpqRO0Pwo0nwFvHY2rNVFdeRo/436s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO/sGYRHUKv9Ysfmn79LQsr+tKqbekGBLLmvr6CPh9gh4vvdu4uKYhqT6+QBFYT0l
	 RyaMtZ2qFJGVCPsC3MzWCzibaeUAMq7fXNNc8SBujzdhZ66ZSenTTyjJ8sIo7xJ1JE
	 7veMJqfiD2GkIxdNf8oTePszNGf5DK+D/jMhEFm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/136] md/raid10: Handle bio_split() errors
Date: Tue, 21 Oct 2025 21:51:41 +0200
Message-ID: <20251021195038.685859223@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
Stable-dep-of: 22f166218f73 ("md: fix mssing blktrace bio split events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1153,6 +1153,7 @@ static void raid10_read_request(struct m
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
+	int error;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1203,6 +1204,10 @@ static void raid10_read_request(struct m
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
@@ -1233,6 +1238,11 @@ static void raid10_read_request(struct m
 	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
+err_handle:
+	atomic_dec(&rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1341,9 +1351,10 @@ static void raid10_write_request(struct
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
@@ -1469,6 +1480,10 @@ static void raid10_write_request(struct
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
@@ -1488,6 +1503,26 @@ static void raid10_write_request(struct
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
@@ -1629,6 +1664,11 @@ static int raid10_handle_discard(struct
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
@@ -1639,6 +1679,11 @@ static int raid10_handle_discard(struct
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


