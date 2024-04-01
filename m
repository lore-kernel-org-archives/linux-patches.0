Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82119482E4;
	Mon,  1 Apr 2024 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991059; cv=none; b=SJCZqwmLT1a3tpKcejz1jEiDql7sN6nnk3XPfN4jrJE2xxL+Y2J1WvFnLFIozYLMITQLJVBauW+Ag8v233eelsa7+EiSTOBs4ULUIC4CG8a+KE3hLtT2WvJ3aLaIfi58UQ7Mx7P78xi8Vm/wNwKgY0OEYxvU85U81jT77bbQ9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991059; c=relaxed/simple;
	bh=/lTJK/KFtQBdJG+xRN2rGCDPTwr/H08LHnkCs76omdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTKzNKQDH5sjiRbnNW/MCUKQkX2WJ6kxCoFV23k+X84EoE2t+iRAyLcyWnFlZkXJzO5CutzyWg+hjAuPVSJQUVu6OxkkuzEIR+GhehYG2d4XupIN5ugy3hcJCl+ZhGeWMGCG9zx6q8rIuaDI7nY/2SqfqeYHHhdXxh6jKtQsBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5sXDJHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5sXDJHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89D0C433F1;
	Mon,  1 Apr 2024 17:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991059;
	bh=/lTJK/KFtQBdJG+xRN2rGCDPTwr/H08LHnkCs76omdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5sXDJHFld4kIiCcB+7l9QffrzyOqkd8goH6vYm8GFbZkpewMAkhpW93CQnA0ly/C
	 1nY2jL0Oh6Tfl8ieyZVB812LJ0iMTY+MS4bO6bDrftFG1oOUlsiHh9yt3RR7wD19bn
	 w+5xBMrq+g+J0qFr8QLqwFpedw51NsrllWxBce40=
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
Subject: [PATCH 6.1 121/272] Revert "block/mq-deadline: use correct way to throttling write requests"
Date: Mon,  1 Apr 2024 17:45:11 +0200
Message-ID: <20240401152534.445769486@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index 55e26065c2e27..f10c2a0d18d41 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -622,9 +622,8 @@ static void dd_depth_updated(struct blk_mq_hw_ctx *hctx)
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



