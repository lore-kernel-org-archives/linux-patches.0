Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC148487
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A1BC433D6;
	Thu, 27 Oct 2022 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890061;
	bh=K8ctrGC/2rnvPC2wI5eQVwd2ftM7YFb4dG0rdLFr49I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMOpH3eaAyMPiXZtBuLDkRyXaBjl37QA9LFpDfQa5jLI0QvQqakbYvkdXnJ9IzIuV
	 j8g+afVCxx/tAX7czOeA/6FioCYx5IFF59em3iXmR3vj34bMrPrngP03ESM7S3SI2J
	 yBbJCj7/YTY04++A7M/Dj6uokXPsDzIk62Ml5MPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christiano Haesbaert <haesbaert@haesbaert.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 89/94] io_uring: dont gate task_work run on TIF_NOTIFY_SIGNAL
Date: Thu, 27 Oct 2022 18:55:31 +0200
Message-Id: <20221027165100.778267077@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 46a525e199e4037516f7e498c18f065b09df32ac ]

This isn't a reliable mechanism to tell if we have task_work pending, we
really should be looking at whether we have any items queued. This is
problematic if forward progress is gated on running said task_work. One
such example is reading from a pipe, where the write side has been closed
right before the read is started. The fput() of the file queues TWA_RESUME
task_work, and we need that task_work to be run before ->release() is
called for the pipe. If ->release() isn't called, then the read will sit
forever waiting on data that will never arise.

Fix this by io_run_task_work() so it checks if we have task_work pending
rather than rely on TIF_NOTIFY_SIGNAL for that. The latter obviously
doesn't work for task_work that is queued without TWA_SIGNAL.

Reported-by: Christiano Haesbaert <haesbaert@haesbaert.org>
Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/665
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 45809ae6f64e..5121b20a9193 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -229,12 +229,12 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline bool io_run_task_work(void)
 {
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL)) {
+	if (task_work_pending(current)) {
+		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+			clear_notify_signal();
 		__set_current_state(TASK_RUNNING);
-		clear_notify_signal();
-		if (task_work_pending(current))
-			task_work_run();
-		return true;
+		task_work_run();
+		return 1;
 	}
 
 	return false;
-- 
2.35.1



