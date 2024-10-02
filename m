Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E17B1D1312;
	Wed,  2 Oct 2024 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879338; cv=none; b=k5CBeWdR8ihXdbyWqjcrHdhKIS0GwFgiodRdaoPms9G8gfcoalQDz0/afDZ2KW1UKkzR98voI+ukwj/YvXRlQ+rYJj937IVJzC0jhWYqoLOQvVO8fGaP4C8kqG3/ZlInEN8pI7hzvPcl/47htjfAYSSBBuGc38Xx00jm9h/NKW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879338; c=relaxed/simple;
	bh=G14WpiAUEgLIW7r16TkynPFntKfUw0UQp9btvpb5UQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tmfxia3yArvz43bBmNKpe7Xq4miFMLzBCmPv22f+bNpqouUEW+PQYdnO2OWkbSbZtI1ZeZDg7uoDROPA3naywlr3YEXTiM3/Uhf9kZti4VkPleUViws2SCcibcMt1jzM3LI9g5f9CW/GpKot4VtbJbQOjL2tHT/2FLhGvWFP8VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCl9J2u+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCl9J2u+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DD5C4CECD;
	Wed,  2 Oct 2024 14:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879338;
	bh=G14WpiAUEgLIW7r16TkynPFntKfUw0UQp9btvpb5UQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCl9J2u+UKQPit4/gXUs2WebC0FYC7LLvDbLswHJbzkK4OAVyOr1uIUQM63VAdXKc
	 5CHZKygI1ZPrarynWo3qil5/TwUjk04d3A8eBJgp7IAHsaqMBmfMi/4n48Kt3suTO4
	 Ex5+ssZ3GPX9drC46DFJN5cu+Ue9V/wvJRU52h4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/538] block, bfq: fix procress reference leakage for bfqq in merge chain
Date: Wed,  2 Oct 2024 14:55:23 +0200
Message-ID: <20241002125755.537292416@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 73aeab373557fa6ee4ae0b742c6211ccd9859280 ]

Original state:

        Process 1       Process 2       Process 3       Process 4
         (BIC1)          (BIC2)          (BIC3)          (BIC4)
          Λ                |               |               |
           \--------------\ \-------------\ \-------------\|
                           V               V               V
          bfqq1--------->bfqq2---------->bfqq3----------->bfqq4
    ref    0               1               2               4

After commit 0e456dba86c7 ("block, bfq: choose the last bfqq from merge
chain in bfq_setup_cooperator()"), if P1 issues a new IO:

Without the patch:

        Process 1       Process 2       Process 3       Process 4
         (BIC1)          (BIC2)          (BIC3)          (BIC4)
          Λ                |               |               |
           \------------------------------\ \-------------\|
                                           V               V
          bfqq1--------->bfqq2---------->bfqq3----------->bfqq4
    ref    0               0               2               4

bfqq3 will be used to handle IO from P1, this is not expected, IO
should be redirected to bfqq4;

With the patch:

          -------------------------------------------
          |                                         |
        Process 1       Process 2       Process 3   |   Process 4
         (BIC1)          (BIC2)          (BIC3)     |    (BIC4)
                           |               |        |      |
                            \-------------\ \-------------\|
                                           V               V
          bfqq1--------->bfqq2---------->bfqq3----------->bfqq4
    ref    0               0               2               4

IO is redirected to bfqq4, however, procress reference of bfqq3 is still
2, while there is only P2 using it.

Fix the problem by calling bfq_merge_bfqqs() for each bfqq in the merge
chain. Also change bfqq_merge_bfqqs() to return new_bfqq to simplify
code.

Fixes: 0e456dba86c7 ("block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240909134154.954924-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 055ba1f98009d..7e0dcded5713a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3129,10 +3129,12 @@ void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfq_put_queue(bfqq);
 }
 
-static void
-bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
-		struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
+static struct bfq_queue *bfq_merge_bfqqs(struct bfq_data *bfqd,
+					 struct bfq_io_cq *bic,
+					 struct bfq_queue *bfqq)
 {
+	struct bfq_queue *new_bfqq = bfqq->new_bfqq;
+
 	bfq_log_bfqq(bfqd, bfqq, "merging with queue %lu",
 		(unsigned long)new_bfqq->pid);
 	/* Save weight raising and idle window of the merged queues */
@@ -3226,6 +3228,8 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 	bfq_reassign_last_bfqq(bfqq, new_bfqq);
 
 	bfq_release_process_ref(bfqd, bfqq);
+
+	return new_bfqq;
 }
 
 static bool bfq_allow_bio_merge(struct request_queue *q, struct request *rq,
@@ -3261,14 +3265,8 @@ static bool bfq_allow_bio_merge(struct request_queue *q, struct request *rq,
 		 * fulfilled, i.e., bic can be redirected to new_bfqq
 		 * and bfqq can be put.
 		 */
-		bfq_merge_bfqqs(bfqd, bfqd->bio_bic, bfqq,
-				new_bfqq);
-		/*
-		 * If we get here, bio will be queued into new_queue,
-		 * so use new_bfqq to decide whether bio and rq can be
-		 * merged.
-		 */
-		bfqq = new_bfqq;
+		while (bfqq != new_bfqq)
+			bfqq = bfq_merge_bfqqs(bfqd, bfqd->bio_bic, bfqq);
 
 		/*
 		 * Change also bqfd->bio_bfqq, as
@@ -5703,9 +5701,7 @@ bfq_do_early_stable_merge(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	 * state before killing it.
 	 */
 	bfqq->bic = bic;
-	bfq_merge_bfqqs(bfqd, bic, bfqq, new_bfqq);
-
-	return new_bfqq;
+	return bfq_merge_bfqqs(bfqd, bic, bfqq);
 }
 
 /*
@@ -6160,6 +6156,7 @@ static bool __bfq_insert_request(struct bfq_data *bfqd, struct request *rq)
 	bool waiting, idle_timer_disabled = false;
 
 	if (new_bfqq) {
+		struct bfq_queue *old_bfqq = bfqq;
 		/*
 		 * Release the request's reference to the old bfqq
 		 * and make sure one is taken to the shared queue.
@@ -6176,18 +6173,18 @@ static bool __bfq_insert_request(struct bfq_data *bfqd, struct request *rq)
 		 * new_bfqq.
 		 */
 		if (bic_to_bfqq(RQ_BIC(rq), true,
-				bfq_actuator_index(bfqd, rq->bio)) == bfqq)
-			bfq_merge_bfqqs(bfqd, RQ_BIC(rq),
-					bfqq, new_bfqq);
+				bfq_actuator_index(bfqd, rq->bio)) == bfqq) {
+			while (bfqq != new_bfqq)
+				bfqq = bfq_merge_bfqqs(bfqd, RQ_BIC(rq), bfqq);
+		}
 
-		bfq_clear_bfqq_just_created(bfqq);
+		bfq_clear_bfqq_just_created(old_bfqq);
 		/*
 		 * rq is about to be enqueued into new_bfqq,
 		 * release rq reference on bfqq
 		 */
-		bfq_put_queue(bfqq);
+		bfq_put_queue(old_bfqq);
 		rq->elv.priv[1] = new_bfqq;
-		bfqq = new_bfqq;
 	}
 
 	bfq_update_io_thinktime(bfqd, bfqq);
-- 
2.43.0



