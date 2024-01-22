Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E1C380;
	Tue, 23 Jan 2024 02:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975753; cv=none; b=YduouGdEHszYpKMCBBfl+TzxzDLowxyq2ZUqS9hja0Yi821NtqyCgQHJa3YkfgH7T5ljkjXY15cOSx21PbTwoV/TQ5/W5LLmBQ2vLl94+7Lq7TGXUYO3EMUYDY2JOsWWUUyq7wkY3Km+uCKwDGV4tkaoDcShoh3VFgtBpyD2OCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975753; c=relaxed/simple;
	bh=DeGh+WZ7xBPjxA54FREHGAUi4xDW/UQ4RTZBRcJZv1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDKRpOvzkE9zF5Pm2/OFoLKklqSwqk7yLyu4ynlE/rmaXJHbKlzcfoU4STV0vSiAoQ9q7z4Z9Eq1P7EGJRkYzZw3BEgWbX85ICPXFmyH/U+JVA9uq92zi+xMB7w0uPAavNZokAwGSnG04mSCMKFoDgu75b0XXNFyjtmbd2cU0XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYeSHqOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYeSHqOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB907C433C7;
	Tue, 23 Jan 2024 02:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975753;
	bh=DeGh+WZ7xBPjxA54FREHGAUi4xDW/UQ4RTZBRcJZv1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYeSHqOzx8AI1Rp+NFw7DpsuoSeMdQHOlNN8X98EdEHnyvG6ECxe97iYGSTnM+lVA
	 70sTE2IP9NVQmTgjayBGpubyJZ9b6NeNF+m52MWCe9Zr+Ruet+rPbB4wz3gSKOroqK
	 wB/h+0V2pISskbf1niKcnSNPboranLC0VrsojQtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 537/583] block: ensure we hold a queue reference when using queue limits
Date: Mon, 22 Jan 2024 15:59:48 -0800
Message-ID: <20240122235828.552852326@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20ecd0ab616f..6041e17492ec 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2968,12 +2968,6 @@ void blk_mq_submit_bio(struct bio *bio)
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
@@ -2982,6 +2976,11 @@ void blk_mq_submit_bio(struct bio *bio)
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
@@ -2992,6 +2991,11 @@ void blk_mq_submit_bio(struct bio *bio)
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



