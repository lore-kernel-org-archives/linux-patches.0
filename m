Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EDE1AAC4;
	Mon, 14 Oct 2024 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920107; cv=none; b=IejbhuW/G6ch/cLhdYca4bfgW33EH9kTKkKrZT+tkRwdj6KRwvHQEHdLjK83Q9xj0NHA9mLvnsBGKcYn3xr2MoDbrP8xhHIjCJwEqyfYzQMSu7slfEwwgbSg/rqy6pzmNG2XI7diyCrDbU+Ols/l5/UV6j/0U2sV4seSx7XBspI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920107; c=relaxed/simple;
	bh=sAbxYtgzjWF2/vmPy/8leQG0aDUjMk4ZuBzKjeBHonY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6KRl9YEOspJbcTAF1hsCQFz28rPZADaVSTyg2eEQP9A4a5xt17mz4KDXy2DZF+HHQaXBdNjW/ekc1VVQRneiKXhYh/s7zZe651X3jm6zqJ/ArxEecFMXpjPp4M1tSSPyoJwABgFLbO52fqFsQfDgliefKUVn7UWo5kYOEm7PDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u07uqxSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u07uqxSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B50C4CED1;
	Mon, 14 Oct 2024 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920106;
	bh=sAbxYtgzjWF2/vmPy/8leQG0aDUjMk4ZuBzKjeBHonY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u07uqxSGJlQ0jbWoXG3u3QgoebFyl6f4lVotF2j1Ecgm1do6H2yArkzhAUXzqBZeC
	 quV1CmGGI9DvQRu6nbLOK2BsiWjGsu3EwjEWovWeQU0P90+R3hJG2hhr0Fqj/cv/1F
	 HAYmb/u3hCZORbHUICuMsFbloHqSqqkhn0rojf/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 797/798] block, bfq: fix uaf for accessing waker_bfqq after splitting
Date: Mon, 14 Oct 2024 16:22:31 +0200
Message-ID: <20241014141249.382979387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

commit 1ba0403ac6447f2d63914fb760c44a3b19c44eaf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6724,6 +6724,31 @@ static void bfq_prepare_request(struct r
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
@@ -6784,7 +6809,7 @@ static struct bfq_queue *bfq_init_rq(str
 		/* If the queue was seeky for too long, break it apart. */
 		if (bfq_bfqq_coop(bfqq) && bfq_bfqq_split_coop(bfqq) &&
 			!bic->stably_merged) {
-			struct bfq_queue *old_bfqq = bfqq;
+			struct bfq_queue *waker_bfqq = bfq_waker_bfqq(bfqq);
 
 			/* Update bic before losing reference to bfqq */
 			if (bfq_bfqq_in_large_burst(bfqq))
@@ -6803,7 +6828,7 @@ static struct bfq_queue *bfq_init_rq(str
 				bfqq_already_existing = true;
 
 			if (!bfqq_already_existing) {
-				bfqq->waker_bfqq = old_bfqq->waker_bfqq;
+				bfqq->waker_bfqq = waker_bfqq;
 				bfqq->tentative_waker_bfqq = NULL;
 
 				/*
@@ -6813,7 +6838,7 @@ static struct bfq_queue *bfq_init_rq(str
 				 * woken_list of the waker. See
 				 * bfq_check_waker for details.
 				 */
-				if (bfqq->waker_bfqq)
+				if (waker_bfqq)
 					hlist_add_head(&bfqq->woken_list_node,
 						       &bfqq->waker_bfqq->woken_list);
 			}


