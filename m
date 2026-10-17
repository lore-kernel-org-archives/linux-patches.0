Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E938654F;
	Sat, 17 Oct 2026 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254455; cv=none; b=r2pqeBC0ZSV94sJECM1DBs48LvDltyOexa17jGNd1pHFanYI62yoEb6CIyTw5cH5jJAwAI9ncEe9cFqcco6/Qb1S8AiDEZ3a/fRFyEB36XYqeo215ZgWFho1+lSlBZJUZCR1YrOx3qcL7J5s79i9TWYKdm7ZSedbS5/rqHd//lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254455; c=relaxed/simple;
	bh=OOXm9p6sfG4qUWU4gO5P8/ipX/QDZqKJx+CspKvZRuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxs6OqolVV1OwiVRvibiAaeqcCuzHHh/QI/RDO7VsM3A+6h6jL+phcgSZtQ0LdVL9FfC+/hUFEmPYoTVL7vaefT7fIeobJR+e2IkO67C5xSH3XMV63pVNmzJgC8HqIKbK6HkeqZ96bJCZisvlIiZ/FJpRPxnXNmZ0YFIo7bi9CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LEVt5t8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LEVt5t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E1A1F000C4;
	Sat, 17 Oct 2026 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254454;
	bh=gW4ce4NyxxrNzmDDEqYLML1VdSZI9SQBP1SOEhqTvpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LEVt5t81858VVyZTVAf6Dob977N/Zl+plg7Ty92yR78UUndILhicAzRMr0F1GNRg
	 eC2DNarg5inA42ylPw8Yyy8e5bSMJ4Jl/3q1SJ+Jqx+gAjrKq7JBW/dZ6t/M4GNLib
	 z4HGTfSuEzvONcDjQbPiwb4IedPRIku2sek0zfSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/869] md/raid1: fix writes_pending and barrier reference leaks on write failures
Date: Sat, 17 Oct 2026 17:54:53 +0200
Message-ID: <20261017160048.728512102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 drivers/md/raid1.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 32b2eb2a169c3..91ecf50eba402 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1427,7 +1427,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	raid_end_bio_io(r1_bio);
 }
 
-static void raid1_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
 	struct r1conf *conf = mddev->private;
@@ -1447,7 +1447,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		DEFINE_WAIT(w);
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
@@ -1469,7 +1469,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (!wait_barrier(conf, bio->bi_iter.bi_sector,
 				bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
-		return;
+		return false;
 	}
 
  retry_write:
@@ -1557,7 +1557,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		mddev_add_trace_msg(mddev, "raid1 wait rdev %d blocked",
 				blocked_rdev->raid_disk);
@@ -1668,7 +1668,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
-	return;
+	return true;
+
 err_handle:
 	for (k = 0; k < i; k++) {
 		if (r1_bio->bios[k]) {
@@ -1680,6 +1681,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	bio->bi_status = errno_to_blk_status(error);
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
 	raid_end_bio_io(r1_bio);
+	return false;
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
@@ -1703,8 +1705,9 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
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



