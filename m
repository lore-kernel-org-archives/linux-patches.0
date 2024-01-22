Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DCF13EFEC;
	Tue, 23 Jan 2024 01:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972013; cv=none; b=Mn7Oy9Qfr2HiihlawzpLCa+16YvIfdAMXbLnCbn/BvXKPzbItV4/Gg8SoyDMARyRth1FNx/7jMYShLYcsuxx7MP5ldAOQL5ghH48U7PLvz0zu2TTFl2/+mV2R56aZh20C620nDbP/Sd0cITwAcLo6Nj5QBYXDqi7qMwiLtG6zEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972013; c=relaxed/simple;
	bh=UZZ515LyYoZo/rxLA8UN9VLyWYCEgCFYvGAMXDYKNXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJPb4oHmsQ75hqSldQY/9y7ehOGpvKduoPor/R25HG+/y0jUR2H1Y1QySD01NQUfEPA6XXs8KGbv7nDVlT8gc2l18RoZ+SRg+md17ro2a9ej3Ir3W/Ij4tj/koLbNn7mHZlg71ZrVeae3HnVcXWfiRt7szmmyq1e2s2Iwp1Wo1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OY0Y4tq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OY0Y4tq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87354C433F1;
	Tue, 23 Jan 2024 01:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972013;
	bh=UZZ515LyYoZo/rxLA8UN9VLyWYCEgCFYvGAMXDYKNXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OY0Y4tq02MNBwOuTQTkoyrtwrav2cNfyqMfDeBkKvjR8gLxVu+uEthJNSGdSzrwHg
	 yuN4IaziIMgavHtNNt7dQbVfQ4BzT8sG46ZNtbnA18c5JRINm+GFVJUq9Ji3FEgPmQ
	 uMrwYC3BdCW6v+FxzLw9QZLBXA+b69/OlmB9e2r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 387/417] block: ensure we hold a queue reference when using queue limits
Date: Mon, 22 Jan 2024 15:59:15 -0800
Message-ID: <20240122235805.172884438@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 368f1947c895..b3f99dda4530 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2946,12 +2946,6 @@ void blk_mq_submit_bio(struct bio *bio)
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
@@ -2960,6 +2954,11 @@ void blk_mq_submit_bio(struct bio *bio)
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
@@ -2970,6 +2969,11 @@ void blk_mq_submit_bio(struct bio *bio)
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



