Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091926FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822D4C433EF;
	Tue, 10 Jan 2023 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374329;
	bh=FK5vYvcolesBqPpiMrp3z75kxJ38f8dAIolBbaWHHFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USrNeVmS80KdsLlvPIiiXi62/VH9Wg05OrbjS6xdMIWSOZsQGXtu2lJ6iJICuYfYv
	 /IzNewgdhHj4G7v+Kuz9gSAiNBf6o0c2X7vBgs4py1NImC6457h9iJMSJp1fFIT6Cj
	 0QLV7mqiSTFFvkmum82hsKf1Ise9mTEzCw0M4yMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 131/148] io_uring: fix CQ waiting timeout handling
Date: Tue, 10 Jan 2023 19:03:55 +0100
Message-Id: <20230110180021.338129364@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
---
 io_uring/io_uring.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2206,7 +2206,7 @@ int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 	unsigned long check_cq;
@@ -2224,7 +2224,7 @@ static inline int io_cqring_wait_schedul
 		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
 			return -EBADR;
 	}
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
 }
@@ -2289,7 +2289,7 @@ static int io_cqring_wait(struct io_ring
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		cond_resched();
 	} while (ret > 0);
 


