Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC9C46F4B3;
	Tue, 21 Jul 2026 19:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660869; cv=none; b=fLQadiZ3/zpKZ4V12fVRfXiN+thQ2ylnwD6ikpTXvuub+Qsa3xnmtTFC1iRKB3gA66g6wijOY2qT/AuFwt1rU2UfyDNkwFF/JOQGrxlPz0j+taiP9TKLqiEsDbE84Qa2KQ06gjb0eTWTVUoXpRL7MC/eCzhT8wT/8Ia+0hdifqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660869; c=relaxed/simple;
	bh=/juyQ6Rvwt1hEL6LY3N/djC0BsiNwTMEv1FqoBhS+Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA8oaaagt/sVt8pj6dD3BDLwpk6JKwOFNHK3FZgAtSG0LHnkxJFmYi+VcS8MEGk32GNubAARCYMlSXWAWRlCewan1aqPRGG8ovQKe7efJqI/DujAUDsDO8shjjCXuiwfQEjZCS2OBSIvY1Bek/PONgqx2tacSVkEFy0ghXJ7/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=td/4ny+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="td/4ny+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730DC1F00A3A;
	Tue, 21 Jul 2026 19:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660866;
	bh=pow1SmPvtfEHPYUXf23rpZPOdL+RZZfV0yZQcmqaNus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=td/4ny+0fhw3gEFI+nz+b25wwCQSMwlZax3iXt4M/FX7LPz9xcQCMUyGuW5gPi0I3
	 Q3s8YRLhCkKrHdY1yAF2+MCwCKLpX6hf44BZINc/4cdLQcujBxgKFuqj4VDxJbNU1v
	 V52VLEYrWWCjazXbBfbeUgfIzoFLvxnl/GM2lFBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1141/2077] md/raid1: fix writes_pending and barrier reference leaks on write failures
Date: Tue, 21 Jul 2026 17:13:34 +0200
Message-ID: <20260721152619.734647216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 8e065a1602511282fc0da2dc89445e0eb71a681c ]

raid1_make_request() acquires a writes_pending reference with
md_write_start() before calling raid1_write_request(). Several failure
paths in raid1_write_request() complete the bio and return without
reaching the normal write completion path, causing the corresponding
md_write_end() to be skipped.

Make raid1_write_request() return a status indicating whether the write
request was successfully queued. This allows raid1_make_request() to
call md_write_end() when raid1_write_request() fails.

Additionally, if wait_blocked_rdev() fails after wait_barrier()
succeeds, the associated barrier reference is not released.

Call allow_barrier() before returning from that path to keep the barrier
accounting balanced.

Fixes: b1a7ad8b5c4f ("md/raid1: Handle bio_split() errors")
Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Fixes: 5aa705039c4f ("md: raid1 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalkhi@gmail.com?part=1
Closes: https://sashiko.dev/#/patchset/20260611132500.763528-1-abd.masalkhi@gmail.com?part=1
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260613182810.1317258-2-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1f22250334bca4..eb72dd31380ab3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1501,7 +1501,7 @@ static void raid1_start_write_behind(struct mddev *mddev, struct r1bio *r1_bio,
 
 }
 
-static void raid1_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
 	struct r1conf *conf = mddev->private;
@@ -1512,6 +1512,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	bool write_behind = false;
 	bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);
+	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
 	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1519,7 +1520,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		wait_event_idle(conf->wait_barrier,
 				!mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1535,12 +1536,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (!wait_barrier(conf, bio->bi_iter.bi_sector,
 				bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
-		return;
+		return false;
 	}
 
 	if (!wait_blocked_rdev(mddev, bio)) {
 		bio_wouldblock_error(bio);
-		return;
+		allow_barrier(conf, sector);
+		return false;
 	}
 
 	r1_bio = alloc_r1bio(mddev, bio);
@@ -1699,7 +1701,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0; k < i; k++) {
 		if (r1_bio->bios[k]) {
@@ -1709,6 +1712,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	raid_end_bio_io(r1_bio);
+	return false;
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
@@ -1732,8 +1736,9 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
 	else {
-		md_write_start(mddev,bio);
-		raid1_write_request(mddev, bio, sectors);
+		md_write_start(mddev, bio);
+		if (!raid1_write_request(mddev, bio, sectors))
+			md_write_end(mddev);
 	}
 	return true;
 }
-- 
2.53.0



