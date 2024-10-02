Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A66B1D1312;
	Wed,  2 Oct 2024 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879335; cv=none; b=g9gBKgC1LS1M1KjPTT3RhEcAnw2vL1J54j59zEEwkurGyUy2sJJykcKkLvn7A1lBp+jPyrm4Agq0i4WHHVkwqsOA3arPdNweJqpZNXYR6uSO5pDnFEKHIReg4Of6upmvhVW1NEEecE3cyCiVVo2g2GOjqDqPyCGvp4cXkaDJhhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879335; c=relaxed/simple;
	bh=+K/p6UnmWcZuTLRSY0eucDraE2WoQowu55EyAVkDiLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQqEcV/ECsJIa31/RN82DUrJg+o5H2wA+2Hizg+H6Ej9GNVckLzTWupprjUgoTx3Du9L3dtzsD/QiTVBsFVqZ3xRPECONLU0i9Ig+aaT6Oi6PbW7+dWli+jD4Q+kDfsvUTis6mHZ40hA2xIMD4IouU/DYcUXda/P5LrYEeYb0Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QV5Oh7TY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QV5Oh7TY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6193C4CECD;
	Wed,  2 Oct 2024 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879335;
	bh=+K/p6UnmWcZuTLRSY0eucDraE2WoQowu55EyAVkDiLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QV5Oh7TYxRZIdCehMfpwNyDcq/GY6jafd+7ON1q7H2TnPLZ8uJq1JP+f/zwGrZYrr
	 kT+QlMWsiZ39MdPJs/gyncNWXAfcVgTxeS9Tbm5U+CQKGht18NAPLQV8Y8nn8TpxCo
	 YtuY8KOmY6LEhJKBgpSo0g+C/TyO4pCDBfTvfw68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/538] block, bfq: fix uaf for accessing waker_bfqq after splitting
Date: Wed,  2 Oct 2024 14:55:22 +0200
Message-ID: <20241002125755.497215603@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c09c298d8940..055ba1f98009d 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6823,6 +6823,31 @@ static void bfq_prepare_request(struct request *rq)
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
@@ -6884,7 +6909,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 		/* If the queue was seeky for too long, break it apart. */
 		if (bfq_bfqq_coop(bfqq) && bfq_bfqq_split_coop(bfqq) &&
 			!bic->bfqq_data[a_idx].stably_merged) {
-			struct bfq_queue *old_bfqq = bfqq;
+			struct bfq_queue *waker_bfqq = bfq_waker_bfqq(bfqq);
 
 			/* Update bic before losing reference to bfqq */
 			if (bfq_bfqq_in_large_burst(bfqq))
@@ -6904,7 +6929,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 				bfqq_already_existing = true;
 
 			if (!bfqq_already_existing) {
-				bfqq->waker_bfqq = old_bfqq->waker_bfqq;
+				bfqq->waker_bfqq = waker_bfqq;
 				bfqq->tentative_waker_bfqq = NULL;
 
 				/*
@@ -6914,7 +6939,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
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



