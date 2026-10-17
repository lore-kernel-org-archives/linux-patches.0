Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607563B19BA;
	Sat, 17 Oct 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259254; cv=none; b=uMK9CnkL/eQHvUAia39QlIWsMc3f+6r1z/tZ3Ny1IYwP/5F8mVQMQYoxLH2OUMoEmGSuDa5kchbWe0HjQMEqQr0cJWIjML6YfmZn6UlaKmC0TwiLwQUKOl2Yf6cEfpjQBAOZ8Kw/X3wZdGP9sW2OfulU2J+p2oxPGL5r5BNyMCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259254; c=relaxed/simple;
	bh=Ox6JnWkumi+FHCiPXeKBvfA6i8ZTZ/Gq8tPwIpJYjBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBuFv0KgE0dRwSfAkPfwYpSeKMJdhqCAkEemm3pzCUNiBOkvt6FVUJgRWbtnoobdvCZXVHxPWS4bxqjYY3vQRtf0jABANAgUOSMvys+MfA8qaQC89TtkHKmri5GzaTYOpstVvQSNO3xOD3WS72pScXb5CmFtFvkHzQD63zecD10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXEURwOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXEURwOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEDC1F000C4;
	Sat, 17 Oct 2026 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259253;
	bh=Sp8e4Px7xRK8YIFeQrfhhZNRv8k6HlLMQKgeETfIPTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXEURwOmIG2xOfFwGujYMVkbfDgqJM1Grr6yDgkIQMnhQxelS3Rf0eRx++w02OJQ3
	 0A6k7eEKpg0t9XHl13veyCtQSAKALNR4dzNJxmlwrrYd5zO+Y3jlX6H7vNtT+NnPFG
	 /zKzX7xcerHKMIHqFcWR37EaSOvl4o75P4NL49pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1145/1674] md/raid10: fix writes_pending leak on write request failures
Date: Sat, 17 Oct 2026 17:56:57 +0200
Message-ID: <20261017160500.544453587@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit e045d6ed33f8faa3e3dd6dc33c62ec01e3ad275d ]

raid10_make_request() acquires a writes_pending reference with
md_write_start() before dispatching write requests. Several failure
paths in raid10_write_request() complete the bio and return without
reaching the normal write completion path, causing the corresponding
md_write_end() to be skipped.

Make raid10_write_request() return a status indicating whether the write
request was successfully queued. This allows raid10_make_request() to
release the writes_pending reference with md_write_end() when a write
request fails.

Fixes: 4cf58d952909 ("md/raid10: Handle bio_split() errors")
Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260613182810.1317258-3-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b47b55c2f5bfe..89a6165ef81de 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1404,7 +1404,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 	}
 }
 
-static void raid10_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1421,7 +1421,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
@@ -1437,7 +1437,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
 		free_r10bio(r10_bio);
-		return;
+		return false;
 	}
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1454,7 +1454,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		raid10_log(conf->mddev, "wait reshape metadata");
 		wait_event(mddev->sb_wait,
@@ -1560,7 +1560,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0;  k < i; k++) {
 		int d = r10_bio->devs[k].devnum;
@@ -1580,10 +1581,12 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	bio->bi_status = errno_to_blk_status(error);
 	set_bit(R10BIO_Uptodate, &r10_bio->state);
 	raid_end_bio_io(r10_bio);
+	return false;
 }
 
-static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
+static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
+	bool ret;
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
@@ -1599,10 +1602,13 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
+	ret = true;
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio, true);
 	else
-		raid10_write_request(mddev, bio, r10_bio);
+		ret = raid10_write_request(mddev, bio, r10_bio);
+
+	return ret;
 }
 
 static void raid_end_discard_bio(struct r10bio *r10bio)
@@ -1956,7 +1962,8 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
-	__make_request(mddev, bio, sectors);
+	if (!__make_request(mddev, bio, sectors))
+		md_write_end(mddev);
 
 	/* In case raid10d snuck in to freeze_array */
 	wake_up_barrier(conf);
-- 
2.53.0



