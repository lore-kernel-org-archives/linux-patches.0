Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215530;
	b=LtF1vsRdH1wWmAcsUVOsZfc7wZ/13geDMMjftj9Rzhr82dNPlcdQL0RDk9y7fn0POMG3
	 K+EXqQoOI7jFuVWaB8GOD8h4K2gKHHmaViraDrVf7KuOgM326VJWdbo4y1sW/DKWkkOjg
	 bKylplZTLOEnUq/dsJyJf1pYIDeGaWXl+aw2rZCE+Wavi6qkhbFq8+433128qXY8O7mm6
	 kgWOkSLxz7n8GLelyHrifnW/EGwT4MgqYy8M/n4lBTrXs1KzI2S7Ez1aFnqM5ZK+2Bcyr
	 WFTGBDAcWFO1dp00aU61JXgBEUVDG/mH1vG3Wem2Nt95/KJIcn5SdwsGIK6SFySjdxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/qWTnaQKFVUsM03WZ+V4hVzcvVjmlOHRYX1T5V5oPqY=;
	b=eipV2hP04DaX+oRm9Y/KSKIiei35XHtSBlQfM8JQP0gxYKe6Wm3iGsSgPyBZ5n826hJO
	 gWTM4BnmyVaxA1CjxYgFebqKAafo/Ogfra6zr2HTBqjkjnFeiTfBJFhx0OI7+SPpjab90
	 YyJtnRSigXEN/El+KQvqBvglLCA2xkgGWTQHedVIP6To2fjuwdRczGhrX5ff2XZx4l+10
	 fw0mEESL+8v5ivGME5XmQucSX5bvOTHKDzCQrjO202qVSaEsJthX1qFSrG8xUy0tKddHo
	 ovnaXl5lOA7Xarmcg7u47i9pikDiwddPweGflOVg7fdBEUazYe2UZi1WoTOD1foXBFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/ZCDi5r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B26606A31A;
	Wed, 28 Oct 2026 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/ZCDi5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C11F01825;
	Wed, 28 Oct 2026 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215529;
	bh=/qWTnaQKFVUsM03WZ+V4hVzcvVjmlOHRYX1T5V5oPqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/ZCDi5rzAKjU3C+HgySt2Ju25EyFZvR3136bEzcRTI3c3ClsCGR7ZLXzpcKH28Eh
	 mvpoyDmEDgNGgpZrE8afwsmZpoJSovQIaPKRWiAoFQrNKD2UM484wg23o5qvL6ljBA
	 4XwAIfYIyGCtJNooemoj2eaOBniTVUXjk81vuMiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1243/1887] md/raid1: fix writes_pending and barrier reference leaks on write failures
Date: Wed, 28 Oct 2026 17:55:39 +0100
Message-ID: <20261028170527.710726477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f6196a3c89455..8c496f72d4ff7 100644
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
 
 	r1_bio = alloc_r1bio(mddev, bio);
@@ -1476,7 +1476,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
-			return;
+			return false;
 		}
 		raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
@@ -1580,6 +1580,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
+	return true;
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
@@ -1605,7 +1606,8 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
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



