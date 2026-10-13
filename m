Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4D5389104;
	Tue, 13 Oct 2026 12:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893634; cv=none; b=Ibv6VaVWUu66Q/F+KhrU8rx97dgkfK/B+RPayQAYOixFgKYv+kLLrEbB5OCy377SKxBPuTKofl9gAkINMZkQtYDzHQqEBBXIPWD6TPKMTiZ/u3JWIlqh1TiHKRAydQCkiSYqKsB/MHHi8DRqoMR4RbEQVaZJxCyOLPFQBYuHQ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893634; c=relaxed/simple;
	bh=Qs9QbBszsSH2iQ9qmV5YSFsUHzI728uiSNH0BRNgXfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To0U4EEU86R9xFILMeQFUX0+6qpz2RcGHdhlzicdVmIouu+y/lXs/G5ujh65nivMPJgjaEmKlBEOu5AhOp5XTOCCJ4gZXPLn/Ea44G63NiqDG53JJhlDyfMrEkGgG+uPHbVq7OS/kGEZTWU77q4W/XKahIJSN5S7s7aeyWNYdn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPP+iiBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPP+iiBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BFF1F000FF;
	Tue, 13 Oct 2026 12:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893633;
	bh=jn8P9aLPHO2u6NRo7XHLdTXLI+aZRKTeWpZMNuP/Arw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPP+iiBXl4beTygj2Aqjxo4XcHuAjP+2kwZdFDETtCF/ghRcRmVwWFQyXjS/LTJ+B
	 MBC43pjDuzwFFTTuETuAlpHX5yic93gMeB+6TbfZD2IXlBNF4bzOmE/dj+jjW732EL
	 fiIogda6U3ZSzYdXa0mGGXqDLfNtmoNsr78/d6EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/621] md/raid10: fix writes_pending leak on write request failures
Date: Tue, 13 Oct 2026 13:34:44 +0200
Message-ID: <20261013112927.718232168@linuxfoundation.org>
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
index a60e4ba919a76..425ea36da24f2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1341,7 +1341,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 	}
 }
 
-static void raid10_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
@@ -1358,7 +1358,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
@@ -1374,7 +1374,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
 		free_r10bio(r10_bio);
-		return;
+		return false;
 	}
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1391,7 +1391,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		mddev_add_trace_msg(conf->mddev,
 			"raid10 wait reshape metadata");
@@ -1500,7 +1500,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0;  k < i; k++) {
 		int d = r10_bio->devs[k].devnum;
@@ -1518,10 +1519,12 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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
 
@@ -1537,10 +1540,13 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
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
@@ -1891,7 +1897,8 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
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



