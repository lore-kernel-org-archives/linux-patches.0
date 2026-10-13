Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD574F68BC;
	Tue, 13 Oct 2026 12:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893637; cv=none; b=A/63gtzpkk0oFGNd0+91+2SHkZISyw9K89OKhkZalyTR3RSqRnCX4otRVv4k9aKzXbR7yfqw8UrQSpcUbQ4olxSp5ZYPBTzL1hc65shdHzlWTiryGX0cbGADO1vphx1E9+DUb23qO7X9wk8+xp+P2HmcIddskWgT4hY2WQMxXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893637; c=relaxed/simple;
	bh=LPcJrDrElzA7ik3/KBdiydZGB0/2S1fKL+VbpYDkMso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7RtgGDl5jKf35qpdgBdije8BhKICxoK50K/DwtywcWBc1KrE5FvViKrYGNXRjZV/tvV/2JYXT1IuPjY91eMz0eb07RnSrWw5vp9F1iznFgOe+m/fs+/RZYeM5cqWKiVF0TSc6UQkzt928kaLFpEMZ8c0WRgAf+x/qj2qT+7kmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X646tCay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X646tCay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D471F000FF;
	Tue, 13 Oct 2026 12:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893636;
	bh=snrnzl72eofBeJbZ+bl7IICXMnuGx+WzWoRpJ24QlaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X646tCaynhKNn2xVJkfGGrLLPpmsBhWjzUjkEtxspz4Z3u9jjZDWpK05giyttPlzi
	 vmnZCLUq0mYSzyDswM4AH1sD6gshE0Sv9g3LYsUQW6dsIWFj0ZsySf0lADgNuqKovC
	 RWmmC79GzL0Tqv2Kqmv/N7QV5KwcE616k/2I2YIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 290/621] md/raid1: fix writes_pending and barrier reference leaks on write failures
Date: Tue, 13 Oct 2026 13:34:45 +0200
Message-ID: <20261013112927.741452549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 1370be1e5cc7b..333ac4fbe59bc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1482,7 +1482,7 @@ static void raid1_start_write_behind(struct mddev *mddev, struct r1bio *r1_bio,
 
 }
 
-static void raid1_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
 	struct r1conf *conf = mddev->private;
@@ -1493,6 +1493,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	bool write_behind = false;
 	bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);
+	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
 	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1501,7 +1502,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		DEFINE_WAIT(w);
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
@@ -1523,12 +1524,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1687,7 +1689,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0; k < i; k++) {
 		if (r1_bio->bios[k]) {
@@ -1697,6 +1700,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	raid_end_bio_io(r1_bio);
+	return false;
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
@@ -1720,8 +1724,9 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
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



