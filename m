Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EF3186E52;
	Mon, 12 Aug 2024 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479133; cv=none; b=IaMjNZp0zNUCmnFzvyk3Bv4+FtwesStOBOGPGIisk4s4FMXTDJMh1omdtbU//9jOq/d55f7v1X5V1FtZayN6H2M80XYOxphqNF786EemXpPJ2xN8nUPpPZz/jCLy/7/JeodQAZObEwUZohiiiPCJNkbpQpuegq59rzOS7MH+ycw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479133; c=relaxed/simple;
	bh=+6VkzSI3LMtUJ0k3jqUe4TUg9YrUAXp1Ym1AlAcJRi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly9UsQhzmr8TeGvpeEhdFN/di17Xu+G9aGqw0fvw3+QfNjuNE0gQn0V3Pznc1XIM9iUB9aEFvdPHrQGVGcPYWJYldMMWu3ltm9O8aH7NbGZ7Y2txxc+sgK3blEhjosSmqZm4lNKw/cvGAlYoyRGfYMyqOXDHqP4gonUVCmDxRXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqCwrwV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqCwrwV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A32C32782;
	Mon, 12 Aug 2024 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479133;
	bh=+6VkzSI3LMtUJ0k3jqUe4TUg9YrUAXp1Ym1AlAcJRi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqCwrwV8S3MV+y8FSXmlO9ziOQIKZwQbA+EhCsoPy3q6dNLk1aNjhr6hIc8y6rpy4
	 EV9EkferIqyOY0hmeN+6wFeYkPxDDAEo/+MYkMTxVUd1VDVl/2Vh+myDLOGeDav3gV
	 31GNDC4CR4nV2tw0nAeb6tCSzu06PeqiSWxa/4XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 143/150] block/mq-deadline: Fix the tag reservation code
Date: Mon, 12 Aug 2024 18:03:44 +0200
Message-ID: <20240812160130.689648366@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

commit 39823b47bbd40502632ffba90ebb34fff7c8b5e8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -598,6 +598,20 @@ unlock:
 }
 
 /*
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
+/*
  * Called by __blk_mq_alloc_request(). The shallow_depth value set by this
  * function is used by __blk_mq_get_tag().
  */
@@ -613,7 +627,7 @@ static void dd_limit_depth(blk_opf_t opf
 	 * Throttle asynchronous requests and writes such that these requests
 	 * do not block the allocation of synchronous requests.
 	 */
-	data->shallow_depth = dd->async_depth;
+	data->shallow_depth = dd_to_word_depth(data->hctx, dd->async_depth);
 }
 
 /* Called by blk_mq_update_nr_requests(). */
@@ -623,9 +637,9 @@ static void dd_depth_updated(struct blk_
 	struct deadline_data *dd = q->elevator->elevator_data;
 	struct blk_mq_tags *tags = hctx->sched_tags;
 
-	dd->async_depth = max(1UL, 3 * q->nr_requests / 4);
+	dd->async_depth = q->nr_requests;
 
-	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, dd->async_depth);
+	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, 1);
 }
 
 /* Called by blk_mq_init_hctx() and blk_mq_init_sched(). */


