Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FF63B7767;
	Sat, 17 Oct 2026 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259287; cv=none; b=Vx84e2PVXTrROislLDTpBpfVVfMo6LUyJ1XVsLHB8z7po0aWRNtglVaQ3MVdiuDt6gJaiThF5YZFa7le9n7bTWwtE+mZGz+C0+xLRrqBdPsQHR5aRl+hmk/Oa/I/wgDONg5CmQg9vMsRloJUIgVe1Vqyq7VOyoDvNcFmouZgpAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259287; c=relaxed/simple;
	bh=uUZfLGit21T4RjbmDfGSKLTpiZt4d+s7SsFsgK6ytik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6Zx3oKu/v1KdxsHOxO0pv+wcEyXv6LTJo+2Zwvx/dFRG0n573OqMl4GPu3hT9wcH+z1KbGeAKhs1Y/H6rf7o2Ig0PLPSjWtjpIJ2Rjr72lSfQaBC0b5faFaWWxY0t9WbHMKrDkBY0F/YjqUnu/f0L1SKCb9+PiUehjynAzqjKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTMu0t4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTMu0t4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCE51F000C5;
	Sat, 17 Oct 2026 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259286;
	bh=XirKqT6HSuFOOm8BVV6TirHUxcigDPkOEuyNBS/VLFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTMu0t4aEQdcCJdXOUrm6qU7d6CR5xuAAELiGybptR4329Ky0ZM+zrdFvL4M4ZaqZ
	 fEbZqZ26W8am1dx6j/bsMu9Cg9igbGw8WnV4A9iDCZiGvyuQl47wTjL5Mvk64R6NgO
	 WTruEPZNcgN9YSJgW6MNTNm+EEJ4j9R8j2NQ9FgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1146/1674] md/raid1: fix writes_pending and barrier reference leaks on write failures
Date: Sat, 17 Oct 2026 17:56:58 +0200
Message-ID: <20261017160500.568124608@linuxfoundation.org>
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
 drivers/md/raid1.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bd57fc5ad5dd3..a07a5ed089e37 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1331,7 +1331,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	submit_bio_noacct(read_bio);
 }
 
-static void raid1_write_request(struct mddev *mddev, struct bio *bio,
+static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
 	struct r1conf *conf = mddev->private;
@@ -1351,7 +1351,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		DEFINE_WAIT(w);
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
@@ -1373,7 +1373,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (!wait_barrier(conf, bio->bi_iter.bi_sector,
 				bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
-		return;
+		return false;
 	}
 
  retry_write:
@@ -1463,7 +1463,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
@@ -1565,6 +1565,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
+	return true;
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
@@ -1590,7 +1591,8 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	else {
 		if (!md_write_start(mddev,bio))
 			return false;
-		raid1_write_request(mddev, bio, sectors);
+		if (!raid1_write_request(mddev, bio, sectors))
+			md_write_end(mddev);
 	}
 	return true;
 }
-- 
2.53.0



