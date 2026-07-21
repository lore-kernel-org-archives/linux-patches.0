Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2F746EC77;
	Tue, 21 Jul 2026 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660871; cv=none; b=fFMblxnN7vU6j+1QCHGuJdevl0v3OTCn2YekebI4bujr6oOs3Awjp0zzCumCPG6Qu/emDRArN6ZyYZSON6ZQUBJ+Su6DwtCenMH9uXydkMIm++hrRE+6V/MtTdfL5tlU7Kj03lxotJ6dmV4yYg5xBDeF7ogZENW3eEzqleM51xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660871; c=relaxed/simple;
	bh=3G1fdFX32tvRSekBUXDRYc9B2+KZ/y9XQaCPk0MBWI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVtx2XdT+Miefu84B99IAt699ScEdwMIMoD1FOBn+3O9tlpxQHvvWziOtnH8a4ugZjfsnvSN1nI2VyiimneumXVYtpLiljGACcU0801+LUrtEZdsuvYnT2cqutFO3HkTIbvo4bvRPmgkEUCU/qyWyltHGoeOut/N+Zz9SamTDk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecu4j9mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecu4j9mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B92B1F000E9;
	Tue, 21 Jul 2026 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660869;
	bh=newrk9FFePiOMRi/15aFt444/7ZxGhUSU2ezOA9uBOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecu4j9mLoILdbrethZ6brN7lNgIYn34I/DC0tHsMv28wdQJR0W3nlg2zoLI+t3oWv
	 zmZYUFZN2ckAYOrcITncB5m2yUhbYaqt0yo2Ab956iqlW56nCClgSbMZ5Q69Cjziri
	 AXUNI63Sk94MQQHjDum3GOKQpj3BOzOoF0A5V1qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1142/2077] md/raid10: fix writes_pending leak on write request failures
Date: Tue, 21 Jul 2026 17:13:35 +0200
Message-ID: <20260721152619.757707996@linuxfoundation.org>
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
index 5bd7698e0a1b54..5ad1b0c6207a72 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1349,7 +1349,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 	}
 }
 
-static void raid10_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1365,7 +1365,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
@@ -1381,7 +1381,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
 		free_r10bio(r10_bio);
-		return;
+		return false;
 	}
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1398,7 +1398,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		mddev_add_trace_msg(conf->mddev,
 			"raid10 wait reshape metadata");
@@ -1514,7 +1514,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0;  k < i; k++) {
 		int d = r10_bio->devs[k].devnum;
@@ -1532,10 +1533,12 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	raid_end_bio_io(r10_bio);
+	return false;
 }
 
-static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
+static bool __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
+	bool ret;
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
@@ -1551,10 +1554,13 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
+	ret = true;
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio);
 	else
-		raid10_write_request(mddev, bio, r10_bio);
+		ret = raid10_write_request(mddev, bio, r10_bio);
+
+	return ret;
 }
 
 static void raid_end_discard_bio(struct r10bio *r10bio)
@@ -1900,7 +1906,8 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
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



