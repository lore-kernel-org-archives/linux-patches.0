Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016EC2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B798C433D2;
	Sun, 22 Jan 2023 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400574;
	bh=cFzX04RxTb6QRGOAKulgwA+ApTRYhAo9lxPFayh2TjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOLry5ul2Ox31YXPdiDczp+DbEg8QSMIUjX2YfkGQf3gfJeqOi5eB9ncz3ZQ2xVQz
	 edCNFR1T+ISVa51pOpTMZi5P9aIRMhVzqxist1FaGcIMIjdvY5RM0nU7BQjfoMov2a
	 Y9xjVjkq0M6nqjUufNMXKmCD8G73iyQLlacZIzNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christiano Haesbaert <haesbaert@haesbaert.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/117] io_uring: dont gate task_work run on TIF_NOTIFY_SIGNAL
Date: Sun, 22 Jan 2023 16:03:37 +0100
Message-Id: <20230122150233.826521340@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

commit 46a525e199e4037516f7e498c18f065b09df32ac upstream.

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
 io_uring/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 87bc38b47103..81485c1a9879 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -513,7 +513,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 
 static bool io_flush_signals(void)
 {
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		tracehook_notify_signal();
 		return true;
-- 
2.39.0



