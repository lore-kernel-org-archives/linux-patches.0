Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C43E1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61CCC433C7;
	Mon, 11 Sep 2023 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441183;
	bh=mx6wC7BpBDDcFtQSn0S+OyEHLJTBU1q/E4Q/FEOJJPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZhZKQkqWr+emCXO4h9mtSmG8wqb3uslxX7FiX071wCQ5Ytida1XL7ZTwb0ubMci4
	 VQ9F+p0BYTM8buTLbp4VximYV7JzuUXUQHrKEwdUvima3V7rZiWYS13zyqutz4MnlH
	 gCA9nwsTC9EX1Bl4h9rxgzgqVxsQHzt5M8OV514U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 324/739] block/mq-deadline: use correct way to throttling write requests
Date: Mon, 11 Sep 2023 15:42:03 +0200
Message-ID: <20230911134700.152468033@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit d47f9717e5cfd0dd8c0ba2ecfa47c38d140f1bb6 ]

The original formula was inaccurate:
dd->async_depth = max(1UL, 3 * q->nr_requests / 4);

For write requests, when we assign a tags from sched_tags,
data->shallow_depth will be passed to sbitmap_find_bit,
see the following code:

nr = sbitmap_find_bit_in_word(&sb->map[index],
			min_t (unsigned int,
			__map_depth(sb, index),
			depth),
			alloc_hint, wrap);

The smaller of data->shallow_depth and __map_depth(sb, index)
will be used as the maximum range when allocating bits.

For a mmc device (one hw queue, deadline I/O scheduler):
q->nr_requests = sched_tags = 128, so according to the previous
calculation method, dd->async_depth = data->shallow_depth = 96,
and the platform is 64bits with 8 cpus, sched_tags.bitmap_tags.sb.shift=5,
sb.maps[]=32/32/32/32, 32 is smaller than 96, whether it is a read or
a write I/O, tags can be allocated to the maximum range each time,
which has not throttling effect.

In addition, refer to the methods of bfg/kyber I/O scheduler,
limit ratiois are calculated base on sched_tags.bitmap_tags.sb.shift.

This patch can throttle write requests really.

Fixes: 07757588e507 ("block/mq-deadline: Reserve 25% of scheduler tags for synchronous requests")

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/1691061162-22898-1-git-send-email-zhiguo.niu@unisoc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 02a916ba62ee7..f958e79277b8b 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -646,8 +646,9 @@ static void dd_depth_updated(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct deadline_data *dd = q->elevator->elevator_data;
 	struct blk_mq_tags *tags = hctx->sched_tags;
+	unsigned int shift = tags->bitmap_tags.sb.shift;
 
-	dd->async_depth = max(1UL, 3 * q->nr_requests / 4);
+	dd->async_depth = max(1U, 3 * (1U << shift)  / 4);
 
 	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, dd->async_depth);
 }
-- 
2.40.1



