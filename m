Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1A54EB34;
	Tue, 23 Jan 2024 00:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970135; cv=none; b=fYQ8BXKJCdnPb25FMRVahMeWXnEbA2WYjbiLpjHdFgXev9+2mJEee6n+jo71q/avonR5AHUNGT2PIkWzdbeHVcOFaI3ePBzxq2PvtSVNMIls0+aCdDa0CQQ+ZwwmVwe6l45NdaGDKJsPdp9MvMopBCcFHIl6vbAvD272Ep6fE+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970135; c=relaxed/simple;
	bh=kvSGtuKTBNBBqjHEYhr3LxWcyH7Etq/lRMmu/OiklC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6/IQg5LoDlD0ILsEmZXXHgtPxAzY2i+EJbWbBKASfq6kS+Ot6ai8CA9oDYfb9o2Cl9PaFRonS/FVUXhNQeO+6ZNfY3nhNvBC8PbZgONLhl8LmOchRbglqRb4YI0lbWWmE8Wamy08oKdcK9zzoEjP81YgN1w1gvf3bN4dzS/yqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxeY9Bzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxeY9Bzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694DFC433C7;
	Tue, 23 Jan 2024 00:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970134;
	bh=kvSGtuKTBNBBqjHEYhr3LxWcyH7Etq/lRMmu/OiklC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxeY9BzcTE67/HxtVDyowBwNlO6WB+cDeS08DfiCbXXNKrYOguzaF7lntRnFpbjlI
	 nUzykjjQ1A6tkkPVBd9Y8/0rJtIYlP1I4CM0lU/OBVQs4HR185N3APaYbZ8ppbm70v
	 ZJbvV4I6U+NrGBRgy/k9BrXbqgiXVuujGOj3Fo+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 596/641] block: ensure we hold a queue reference when using queue limits
Date: Mon, 22 Jan 2024 15:58:20 -0800
Message-ID: <20240122235836.859517585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7b4f36cd22a65b750b4cb6ac14804fb7d6e6c67d ]

q_usage_counter is the only thing preventing us from the limits changing
under us in __bio_split_to_limits, but blk_mq_submit_bio doesn't hold
it while calling into it.

Move the splitting inside the region where we know we've got a queue
reference. Ideally this could still remain a shared section of code, but
let's keep the fix simple and defer any refactoring here to later.

Reported-by: Christoph Hellwig <hch@lst.de>
Fixes: 900e08075202 ("block: move queue enter logic into blk_mq_submit_bio()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ac18f802c027..7e743ac58c31 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2951,12 +2951,6 @@ void blk_mq_submit_bio(struct bio *bio)
 	blk_status_t ret;
 
 	bio = blk_queue_bounce(bio, q);
-	if (bio_may_exceed_limits(bio, &q->limits)) {
-		bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
-		if (!bio)
-			return;
-	}
-
 	bio_set_ioprio(bio);
 
 	if (plug) {
@@ -2965,6 +2959,11 @@ void blk_mq_submit_bio(struct bio *bio)
 			rq = NULL;
 	}
 	if (rq) {
+		if (unlikely(bio_may_exceed_limits(bio, &q->limits))) {
+			bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
+			if (!bio)
+				return;
+		}
 		if (!bio_integrity_prep(bio))
 			return;
 		if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
@@ -2975,6 +2974,11 @@ void blk_mq_submit_bio(struct bio *bio)
 	} else {
 		if (unlikely(bio_queue_enter(bio)))
 			return;
+		if (unlikely(bio_may_exceed_limits(bio, &q->limits))) {
+			bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
+			if (!bio)
+				goto fail;
+		}
 		if (!bio_integrity_prep(bio))
 			goto fail;
 	}
-- 
2.43.0



