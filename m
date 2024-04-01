Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224B5481B8;
	Mon,  1 Apr 2024 16:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988394; cv=none; b=EIoMVtBeY04wb3nc+tRzBIqPMmOAF2GwgfL0pGxH3ntGFXVquVQLN0BLbub9hD0SNuvi6X/dL7o9cd/XQt+CP6sMtW7yVSlwfmT0zqBOfKuEW1m8yfMnkcWEgYriLPgQufJQMyuGhZLWxQ8A2YI8PrNLAPaskU3kRjcq0ITF3gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988394; c=relaxed/simple;
	bh=syDIcOGuQ5x3XaMRqb5VMy4beB0e7UlmOq95i7sZ0Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoNZ0Tsq4+UotnScrA8YsqYHQIkW4zvGV/GeiHKXRi+38qoF8cb/l6jIv9ykLglyOGtsBjPG/nVSn2ZxzEmSV3DGeKGBiMGSHLPeCHl5Rzs9DQ8biQrgRJb3oVwSakN1kKXNKfcEB4t626GOnwZsX47+Ne8oNJFGSyqMnnd07J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPH1/Lub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPH1/Lub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC2BC43141;
	Mon,  1 Apr 2024 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988393;
	bh=syDIcOGuQ5x3XaMRqb5VMy4beB0e7UlmOq95i7sZ0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPH1/LubmYNl6w2W8cwgLcz007xD5/ODYn0X+qe4jG1eO9OBIyjDq7vAZMCussgLe
	 xrq028/rRlkx1r+CFmvVOAsM+0bptigrp+Q9pJRtybfqYFxDLieEw0JoUmZR0X7Q8d
	 yWxM+IdkPOdSQVrQHYCUs08upA1xNk1v27htGgNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Zhiguo Niu <Zhiguo.Niu@unisoc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 172/432] Revert "block/mq-deadline: use correct way to throttling write requests"
Date: Mon,  1 Apr 2024 17:42:39 +0200
Message-ID: <20240401152558.278060829@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 256aab46e31683d76d45ccbedc287b4d3f3e322b ]

The code "max(1U, 3 * (1U << shift)  / 4)" comes from the Kyber I/O
scheduler. The Kyber I/O scheduler maintains one internal queue per hwq
and hence derives its async_depth from the number of hwq tags. Using
this approach for the mq-deadline scheduler is wrong since the
mq-deadline scheduler maintains one internal queue for all hwqs
combined. Hence this revert.

Cc: stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Zhiguo Niu <Zhiguo.Niu@unisoc.com>
Fixes: d47f9717e5cf ("block/mq-deadline: use correct way to throttling write requests")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240313214218.1736147-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8b..02a916ba62ee7 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -646,9 +646,8 @@ static void dd_depth_updated(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct deadline_data *dd = q->elevator->elevator_data;
 	struct blk_mq_tags *tags = hctx->sched_tags;
-	unsigned int shift = tags->bitmap_tags.sb.shift;
 
-	dd->async_depth = max(1U, 3 * (1U << shift)  / 4);
+	dd->async_depth = max(1UL, 3 * q->nr_requests / 4);
 
 	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, dd->async_depth);
 }
-- 
2.43.0



