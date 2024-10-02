Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9020E1D0434;
	Wed,  2 Oct 2024 13:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875515; cv=none; b=ohI03U0BSIXxy+CEo6JoeGSW3foLI+edZbAmeHHO/z8aGtepaYSVrNiFsx2WjYsWlacgTNHOydsBMxs/wyShbVXyebsEacZTtpBvLTMLJ8yXx52ueFPbJgicbEzIfx6KHAZlpLlSlyVJ7Bvy2DU/RzqmopEiAl8LwO5ehZoF97U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875515; c=relaxed/simple;
	bh=r0BAaIYT2zCvb/bKvlDpv/vNPGAXUOwiJ35Nl+CiKEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzeBMM+adbioz72Dqhn0FPOoC4ajZSUFfLrXud4JjHMt1XgBPsJB85khqkLKG5oJ7SY1dRN8ZJIGLXoWWEt+Ss6UlgntFzCHbyLph+xLiqSMzt6711b5FFRn1zwFSSBjayn56OOmnPbWH0BkO4/AnIPFh67H0glQG1npZhQ+ni8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIK0gkYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIK0gkYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3212C4CEC5;
	Wed,  2 Oct 2024 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875515;
	bh=r0BAaIYT2zCvb/bKvlDpv/vNPGAXUOwiJ35Nl+CiKEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIK0gkYZ1ac1t2TRr2LojfI5qTHrrEPMmt3BnANnkKhCGCUoi5rUqYD5k/k1pU74M
	 4YMPZRvG00dpMwDlmoBMpcmxzsuSttbNoFoIDX0GFaEMxXj0+dgxs0I1ySPq0Ik985
	 t4ssi4nf/74xR0FlnxbfLDtrE6TSmD9+m7vKGS2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 128/695] block, bfq: fix uaf for accessing waker_bfqq after splitting
Date: Wed,  2 Oct 2024 14:52:06 +0200
Message-ID: <20241002125827.588275967@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 1ba0403ac6447f2d63914fb760c44a3b19c44eaf ]

After commit 42c306ed7233 ("block, bfq: don't break merge chain in
bfq_split_bfqq()"), if the current procress is the last holder of bfqq,
the bfqq can be freed after bfq_split_bfqq(). Hence recored the bfqq and
then access bfqq->waker_bfqq may trigger UAF. What's more, the waker_bfqq
may in the merge chain of bfqq, hence just recored waker_bfqq is still
not safe.

Fix the problem by adding a helper bfq_waker_bfqq() to check if
bfqq->waker_bfqq is in the merge chain, and current procress is the only
holder.

Fixes: 42c306ed7233 ("block, bfq: don't break merge chain in bfq_split_bfqq()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240909134154.954924-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index ca766b7d5560e..8533e92c5d9ef 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6825,6 +6825,31 @@ static void bfq_prepare_request(struct request *rq)
 	rq->elv.priv[0] = rq->elv.priv[1] = NULL;
 }
 
+static struct bfq_queue *bfq_waker_bfqq(struct bfq_queue *bfqq)
+{
+	struct bfq_queue *new_bfqq = bfqq->new_bfqq;
+	struct bfq_queue *waker_bfqq = bfqq->waker_bfqq;
+
+	if (!waker_bfqq)
+		return NULL;
+
+	while (new_bfqq) {
+		if (new_bfqq == waker_bfqq) {
+			/*
+			 * If waker_bfqq is in the merge chain, and current
+			 * is the only procress.
+			 */
+			if (bfqq_process_refs(waker_bfqq) == 1)
+				return NULL;
+			break;
+		}
+
+		new_bfqq = new_bfqq->new_bfqq;
+	}
+
+	return waker_bfqq;
+}
+
 /*
  * If needed, init rq, allocate bfq data structures associated with
  * rq, and increment reference counters in the destination bfq_queue
@@ -6886,7 +6911,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 		/* If the queue was seeky for too long, break it apart. */
 		if (bfq_bfqq_coop(bfqq) && bfq_bfqq_split_coop(bfqq) &&
 			!bic->bfqq_data[a_idx].stably_merged) {
-			struct bfq_queue *old_bfqq = bfqq;
+			struct bfq_queue *waker_bfqq = bfq_waker_bfqq(bfqq);
 
 			/* Update bic before losing reference to bfqq */
 			if (bfq_bfqq_in_large_burst(bfqq))
@@ -6906,7 +6931,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 				bfqq_already_existing = true;
 
 			if (!bfqq_already_existing) {
-				bfqq->waker_bfqq = old_bfqq->waker_bfqq;
+				bfqq->waker_bfqq = waker_bfqq;
 				bfqq->tentative_waker_bfqq = NULL;
 
 				/*
@@ -6916,7 +6941,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 				 * woken_list of the waker. See
 				 * bfq_check_waker for details.
 				 */
-				if (bfqq->waker_bfqq)
+				if (waker_bfqq)
 					hlist_add_head(&bfqq->woken_list_node,
 						       &bfqq->waker_bfqq->woken_list);
 			}
-- 
2.43.0



