Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275237E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20E9C433EF;
	Sun, 22 Jan 2023 15:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400317;
	bh=1J6zcKmkvTqzOEAutl5JAnQEd63U87REeovC5W2BIjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux+7kbEuwOEFDetc2YIjjDhUtAz+7CKWzARRuTKJdokN2vhNEMAMgNMHfnEma5pAy
	 d4BSIrlNI4HwQIY6tEOuPEsKuPRESgKOOhrfqDEVKpuLtN6LiE0z6nAUKHYVrXkPII
	 TNyijakE5ur+BSt/3d80KpQsJqU6k9WElTFnaV6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/98] io_uring: fix CQ waiting timeout handling
Date: Sun, 22 Jan 2023 16:03:45 +0100
Message-Id: <20230122150230.711294235@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 12521a5d5cb7ff0ad43eadfc9c135d86e1131fa8 upstream.

Jiffy to ktime CQ waiting conversion broke how we treat timeouts, in
particular we rearm it anew every time we get into
io_cqring_wait_schedule() without adjusting the timeout. Waiting for 2
CQEs and getting a task_work in the middle may double the timeout value,
or even worse in some cases task may wait indefinitely.

Cc: stable@vger.kernel.org
Fixes: 228339662b398 ("io_uring: don't convert to jiffies for waiting on timeouts")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f7bffddd71b08f28a877d44d37ac953ddb01590d.1672915663.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b7bd5138bdaf..e8852d56b1ec 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7518,7 +7518,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 
@@ -7530,7 +7530,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
 }
@@ -7593,7 +7593,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);
-- 
2.39.0



