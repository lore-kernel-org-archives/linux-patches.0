Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215367;
	b=xHWaBSoTTYi7rxkmFPfraW+M76Ayu/6MrPS/c6k9XXXIOBvFUnJhJZAOeUzIW+9uEEuG
	 bsUmbrUVkXgHXbZq4DK2wEdmRygw43bCK7dfyor6XHbZhUXJimbfxNQfeKRdKFW9PcQZB
	 4MnjbudQsoz9Q/ikRoWG8fR2dA0rCiJqQToVoqxzjCTlTrIhcSn6CgNoUGKqRaTYWdS+a
	 uFCPhh7BF0yamTq+lpfAcl/5NBoINR0rmAM8w2ET9gnuufVcDaXpHo5lq0B0thZCDz43e
	 72hz7tLhF1E3BplfT+VnRx6Ntn6S7IhKgseISbLb1TR8pYwGNQkQaC2X/ghkhPR2Omg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gEW9Ah8g7bn8t2Cl8p5Qtv2RHmtr5vY9dcCeejbeDeA=;
	b=EqRTE2bn+ThVh99tlg9ULoJRuHwbuuHnh58SS/2fNlGl1GIEAYWQGXHol56f1aBy3O36
	 p9nl5IbULaQOb7ZyFo21PBV4BebP6OLtnuLWh98hYhAJHrS9wZr9e1XGsgM3RiXxmWCtq
	 pDpPtQmPI2HrO/inipeaoKvpmrhwgBkYKZCwiPP2ZZ+CIidlK2KBSdS7wDPX7jyFUpZEG
	 AmADaqaD+cxyJOyQBGX9sc7KfRDDv5UPedsCqOTJcvW3jOYm82X/j572ZP32qgNregYis
	 W1SU5OA8jhKUi05Ijd/CV1tEt/xygGLgD+LptO9Y/r2hp9uEWXcef61c2GxK6YSTIbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRtPA34v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6399606A31A;
	Wed, 28 Oct 2026 19:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRtPA34v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207251F01825;
	Wed, 28 Oct 2026 19:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215366;
	bh=gEW9Ah8g7bn8t2Cl8p5Qtv2RHmtr5vY9dcCeejbeDeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRtPA34v12WEX0H4wSXeKj4JZL+lRDcCOA4VcfMqBQShDP6vBm3TSXxa20JT1umeI
	 JRkXUoOJmZzn8429NqF3kzCuffP3nnjhCvlQXztIlibxf/9ZpItpT2e/VePdnhLDeA
	 XvJ9oqz0mbjinzDYJDC/3dMiZkB83TXvGfTzkyWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1133/1887] blk-mq: pop cached request if it is usable
Date: Wed, 28 Oct 2026 17:53:49 +0100
Message-ID: <20261028170525.188140852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit dc278e9bf2b9513a763353e6b9cc21e0f532954e ]

When submitting a bio to blk-mq, if the task should sleep after peeking
a cached request, but before it pops it, the plug flushes and calls
blk_mq_free_plug_rqs, freeing the cached_rqs. This creates a
use-after-free bug. Fix this by popping the cached request before any
possible blocking calls if it is suitable for use.

Popping this request first holds a queue reference, so avoid any
serialization races with queue freezes and can safely proceed with
dispatching that request to the driver. This potentially increases a
timing window from when a driver wants to freeze its queue to when
requests stop being dispatched. That scenario is off the fast path
though, and drivers need to appropriately handle requests during a
freeze request anyway.

The downside is the popped element needs to be individually freed when
we performed a bio plug merge. The cached request would have had to be
freed later anyway, but this patch does it inline with building the plug
list instead of after flushing it.

Fixes: b0077e269f6c1 ("blk-mq: make sure active queue usage is held for bio_integrity_prep()")
Fixes: 7b4f36cd22a65 ("block: ensure we hold a queue reference when using queue limits")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://patch.msgid.link/20260521190253.242065-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index bf69079f6bd51..bc619519dd665 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2953,16 +2953,7 @@ static bool blk_mq_can_use_cached_rq(struct request *rq, struct blk_plug *plug,
 	if (op_is_flush(rq->cmd_flags) != op_is_flush(bio->bi_opf))
 		return false;
 
-	/*
-	 * If any qos ->throttle() end up blocking, we will have flushed the
-	 * plug and hence killed the cached_rq list as well. Pop this entry
-	 * before we throttle.
-	 */
 	plug->cached_rq = rq_list_next(rq);
-	rq_qos_throttle(rq->q, bio);
-
-	rq->cmd_flags = bio->bi_opf;
-	INIT_LIST_HEAD(&rq->queuelist);
 	return true;
 }
 
@@ -2994,20 +2985,23 @@ void blk_mq_submit_bio(struct bio *bio)
 		rq = rq_list_peek(&plug->cached_rq);
 		if (rq && rq->q != q)
 			rq = NULL;
+		if (rq && !blk_mq_can_use_cached_rq(rq, plug, bio))
+			rq = NULL;
 	}
 	if (rq) {
 		if (unlikely(bio_may_exceed_limits(bio, &q->limits))) {
 			bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
 			if (!bio)
-				return;
+				goto free_rq;
 		}
 		if (!bio_integrity_prep(bio))
-			return;
+			goto free_rq;
 		if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
-			return;
-		if (blk_mq_can_use_cached_rq(rq, plug, bio))
-			goto done;
-		percpu_ref_get(&q->q_usage_counter);
+			goto free_rq;
+		rq_qos_throttle(q, bio);
+		rq->cmd_flags = bio->bi_opf;
+		INIT_LIST_HEAD(&rq->queuelist);
+		goto done;
 	} else {
 		if (unlikely(bio_queue_enter(bio)))
 			return;
@@ -3056,6 +3050,10 @@ void blk_mq_submit_bio(struct bio *bio)
 	else
 		blk_mq_run_dispatch_ops(rq->q,
 				blk_mq_try_issue_directly(rq->mq_hctx, rq));
+	return;
+
+free_rq:
+	blk_mq_free_request(rq);
 }
 
 #ifdef CONFIG_BLK_MQ_STACKING
-- 
2.53.0



