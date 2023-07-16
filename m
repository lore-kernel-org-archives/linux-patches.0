Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE7BE7B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF745C433C7;
	Sun, 16 Jul 2023 20:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539414;
	bh=ExzEbA/RIzTxjKUcd5Ih5Si564HbUIS8oZ/FuVczb5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UANksxT4i2gk58mCdpEjB/JIRdD+KqDeUfEMyEsliBgk+GGhzyYYrPRTuBannQ6VV
	 +bqW/b8oWQ8nh2Mbs0ue0SJTtyX+z1Rl/i6ucvIU2woSmCL4FGmLNgQBIcbkl+X+4r
	 vepNY1w8q8m0LkFIZDFiLWtx2ACnkIuOVVRgdOS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andres Freund <andres@anarazel.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Date: Sun, 16 Jul 2023 21:50:53 +0200
Message-ID: <20230716195007.731909670@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andres Freund <andres@anarazel.de>

commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.

I observed poor performance of io_uring compared to synchronous IO. That
turns out to be caused by deeper CPU idle states entered with io_uring,
due to io_uring using plain schedule(), whereas synchronous IO uses
io_schedule().

The losses due to this are substantial. On my cascade lake workstation,
t/io_uring from the fio repository e.g. yields regressions between 20%
and 40% with the following command:
./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/write.0.0

This is repeatable with different filesystems, using raw block devices
and using different block devices.

Use io_schedule_prepare() / io_schedule_finish() in
io_cqring_wait_schedule() to address the difference.

After that using io_uring is on par or surpassing synchronous IO (using
registered files etc makes it reliably win, but arguably is a less fair
comparison).

There are other calls to schedule() in io_uring/, but none immediately
jump out to be similarly situated, so I did not touch them. Similarly,
it's possible that mutex_lock_io() should be used, but it's not clear if
there are cases where that matters.

Cc: stable@vger.kernel.org # 5.10+
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Andres Freund <andres@anarazel.de>
Link: https://lore.kernel.org/r/20230707162007.194068-1-andres@anarazel.de
[axboe: minor style fixup]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2575,6 +2575,8 @@ int io_run_task_work_sig(struct io_ring_
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
+	int token, ret;
+
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
 	if (unlikely(!llist_empty(&ctx->work_llist)))
@@ -2585,11 +2587,20 @@ static inline int io_cqring_wait_schedul
 		return -EINTR;
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
+
+	/*
+	 * Use io_schedule_prepare/finish, so cpufreq can take into account
+	 * that the task is waiting for IO - turns out to be important for low
+	 * QD IO.
+	 */
+	token = io_schedule_prepare();
+	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
-		return -ETIME;
-	return 0;
+		ret = -ETIME;
+	io_schedule_finish(token);
+	return ret;
 }
 
 /*


