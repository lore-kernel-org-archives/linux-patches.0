Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1728B7474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCF5C433A4;
	Tue, 10 Jan 2023 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375752;
	bh=tQnOX4YBycmO/vWmW4ebwETI2Fa9+wrjKm1liCTas4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwOXXLdDe3kZkl4RElVYnUpiIGEWIfyB/VlbqDglFwvE0ui9aMgezSZlNIFRh5wCK
	 QnNScnBhgnmQv5jwWVOO/p8LXhcmbt1S0eIAP3Fw1PeOSnyv1d/HVlyYjsrDwZkx5m
	 S8IlSZswMRo+PkpSakQKsfUuhqEk2vSay0S1KJ/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 270/290] io_uring: fix CQ waiting timeout handling
Date: Tue, 10 Jan 2023 19:06:02 +0100
Message-Id: <20230110180041.277074748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
@@ -7598,7 +7598,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 
@@ -7610,7 +7610,7 @@ static inline int io_cqring_wait_schedul
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
 }
@@ -7673,7 +7673,7 @@ static int io_cqring_wait(struct io_ring
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);


