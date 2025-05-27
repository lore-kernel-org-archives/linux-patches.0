Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FA9280335;
	Tue, 27 May 2025 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364986; cv=none; b=pYbTkuORV/svrm+6QmCZ4lOUhjJ/aQjOAqnAfnfWLCaeGM8VWFojiZFH9vwaJQhK/ZGhV7KJFNlrXsDyUqHDp3f+T1FbydwvNP+Je6xEDdI7Vrvf2K7gWJ9qQwgYK/qo0BVS8toIlAHQJEiMOXLEljHfi0++VXFF04E9QyDN3HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364986; c=relaxed/simple;
	bh=HdRNG2/vpTUqdKXJqF6Qf7nrY7hNaT7e5cwPb1c9rmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsYjpWnerGpdnYo0VoUK9LKccayUBFOY3omSj1aFr5Sxc3RGXM05oOlu9kSD0T/Jo55FN5pAGWtQ44x+vTE8BmAdRXxtHcsB2dXPim+uDyYb6h7EZMolwh4LV/cG2DXdP4C51G5b5mzoPhR6xpWYj6el77w0Dcoxal8OSWLL3eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7yXkK6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7yXkK6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E350C4CEE9;
	Tue, 27 May 2025 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364985;
	bh=HdRNG2/vpTUqdKXJqF6Qf7nrY7hNaT7e5cwPb1c9rmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7yXkK6Q7CTwyjPHXWMdqlZ86n1Hghq8CMwhj3gNb/ckvbdHmmK1I6b0DjjTkQ5t7
	 YmtEJPxoswNwyD7a+FHueJzSEaCHObOZv8MSpeFqGBkbumcUuLTyb0IZObV3PcaLtg
	 qxLcfDuxib+16DUEOTq2befrC+sXR7lmO5BAzMNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/626] blk-throttle: dont take carryover for prioritized processing of metadata
Date: Tue, 27 May 2025 18:22:03 +0200
Message-ID: <20250527162454.364334790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit a9fc8868b350cbf4ff730a4ea9651319cc669516 ]

Commit 29390bb5661d ("blk-throttle: support prioritized processing of metadata")
takes bytes/ios carryover for prioritized processing of metadata. Turns out
we can support it by charging it directly without trimming slice, and the
result is same with carryover.

Cc: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250305043123.3938491-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 2c4192e12efab..6b82fcbd7e774 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1593,13 +1593,6 @@ static bool tg_within_limit(struct throtl_grp *tg, struct bio *bio, bool rw)
 	return tg_may_dispatch(tg, bio, NULL);
 }
 
-static void tg_dispatch_in_debt(struct throtl_grp *tg, struct bio *bio, bool rw)
-{
-	if (!bio_flagged(bio, BIO_BPS_THROTTLED))
-		tg->carryover_bytes[rw] -= throtl_bio_data_size(bio);
-	tg->carryover_ios[rw]--;
-}
-
 bool __blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
@@ -1636,10 +1629,12 @@ bool __blk_throtl_bio(struct bio *bio)
 			/*
 			 * IOs which may cause priority inversions are
 			 * dispatched directly, even if they're over limit.
-			 * Debts are handled by carryover_bytes/ios while
-			 * calculating wait time.
+			 *
+			 * Charge and dispatch directly, and our throttle
+			 * control algorithm is adaptive, and extra IO bytes
+			 * will be throttled for paying the debt
 			 */
-			tg_dispatch_in_debt(tg, bio, rw);
+			throtl_charge_bio(tg, bio);
 		} else {
 			/* if above limits, break to queue */
 			break;
-- 
2.39.5



