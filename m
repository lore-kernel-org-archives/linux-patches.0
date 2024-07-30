Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEAB29A2;
	Tue, 30 Jul 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354998; cv=none; b=HtLgSma1oKrG3xKZmaQqup4SBF7Idnbo5wlq7B+56JYQwCRDWvC1VeqKoe11weV+F/7Y4lg011jsxYO5qikILyE1JTNqQ9ysVAQUZD01i4Dev4REpswqFFUmbST3lv0a3zm3GGtz1cdUZDtJDGLKB/JHrBVP0pTemxHBx8YAmUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354998; c=relaxed/simple;
	bh=W7OcL6UpgiX7WEq9uuv3xGcOBxc/nkb0HmVr39aznQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVxtA0nlRnNFehRzUOWS9qhdUwK/27MLYc6aLQS/btLBIw4F4V5txSOjfOD6VwnjzYGARRD7x7+VCipwGoelVvSKDw1P6QT4IJcbYbLM33C2op28QR3Qg3+fXk2IVfuNUcH5KpdJRESUqCVCS2Ti7v3t7iQ5nwKnApBsG0kzXZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bx93eETE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bx93eETE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85160C4AF0A;
	Tue, 30 Jul 2024 15:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354998;
	bh=W7OcL6UpgiX7WEq9uuv3xGcOBxc/nkb0HmVr39aznQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bx93eETER7zo7k1QrkjKYgXEAjWsFhJVFBPDSmuTEU+quhWrVnX4lcHG+HZVNfBW9
	 GDKFnTk6aiLHbmh8RY3nR11slSmcPsg7COM5bfG037PTLgNHlNF54SvmI4pM9x6mS7
	 mtRv0UN6T93EBJrFzzaN6elRL/jVxlUOXcgEZHOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/440] block/mq-deadline: Fix the tag reservation code
Date: Tue, 30 Jul 2024 17:44:14 +0200
Message-ID: <20240730151616.594006759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 39823b47bbd40502632ffba90ebb34fff7c8b5e8 ]

The current tag reservation code is based on a misunderstanding of the
meaning of data->shallow_depth. Fix the tag reservation code as follows:
* By default, do not reserve any tags for synchronous requests because
  for certain use cases reserving tags reduces performance. See also
  Harshit Mogalapalli, [bug-report] Performance regression with fio
  sequential-write on a multipath setup, 2024-03-07
  (https://lore.kernel.org/linux-block/5ce2ae5d-61e2-4ede-ad55-551112602401@oracle.com/)
* Reduce min_shallow_depth to one because min_shallow_depth must be less
  than or equal any shallow_depth value.
* Scale dd->async_depth from the range [1, nr_requests] to [1,
  bits_per_sbitmap_word].

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Zhiguo Niu <zhiguo.niu@unisoc.com>
Fixes: 07757588e507 ("block/mq-deadline: Reserve 25% of scheduler tags for synchronous requests")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240509170149.7639-3-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f10c2a0d18d41..ff029e1acc4d5 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -597,6 +597,20 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	return rq;
 }
 
+/*
+ * 'depth' is a number in the range 1..INT_MAX representing a number of
+ * requests. Scale it with a factor (1 << bt->sb.shift) / q->nr_requests since
+ * 1..(1 << bt->sb.shift) is the range expected by sbitmap_get_shallow().
+ * Values larger than q->nr_requests have the same effect as q->nr_requests.
+ */
+static int dd_to_word_depth(struct blk_mq_hw_ctx *hctx, unsigned int qdepth)
+{
+	struct sbitmap_queue *bt = &hctx->sched_tags->bitmap_tags;
+	const unsigned int nrr = hctx->queue->nr_requests;
+
+	return ((qdepth << bt->sb.shift) + nrr - 1) / nrr;
+}
+
 /*
  * Called by __blk_mq_alloc_request(). The shallow_depth value set by this
  * function is used by __blk_mq_get_tag().
@@ -613,7 +627,7 @@ static void dd_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 	 * Throttle asynchronous requests and writes such that these requests
 	 * do not block the allocation of synchronous requests.
 	 */
-	data->shallow_depth = dd->async_depth;
+	data->shallow_depth = dd_to_word_depth(data->hctx, dd->async_depth);
 }
 
 /* Called by blk_mq_update_nr_requests(). */
@@ -623,9 +637,9 @@ static void dd_depth_updated(struct blk_mq_hw_ctx *hctx)
 	struct deadline_data *dd = q->elevator->elevator_data;
 	struct blk_mq_tags *tags = hctx->sched_tags;
 
-	dd->async_depth = max(1UL, 3 * q->nr_requests / 4);
+	dd->async_depth = q->nr_requests;
 
-	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, dd->async_depth);
+	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, 1);
 }
 
 /* Called by blk_mq_init_hctx() and blk_mq_init_sched(). */
-- 
2.43.0



