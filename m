Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B691ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078F8C433C7;
	Tue, 25 Jul 2023 11:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284375;
	bh=iO9QVdD47x8v4TjKLcrILY8ClzTFgslHn+QJsF9+AQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePRn+xDKpZ9LIOTspr3nd60dPfWx5T/qUVUge2AbTzUGguUtAtx7O6Un5oIx94TdK
	 TpvOMwQ4THMVm9fXCEBD+U6RLPo1R6lLyzfzWtyqcmP//ts8EjwDgdOnPG1fdjDRbJ
	 gpW0LfOmq0MwMgGXdcoewYK8ZL73itWbjPfEwA0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andres Freund <andres@anarazel.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 333/509] io_uring: Use io_schedule* in cqring wait
Date: Tue, 25 Jul 2023 12:44:32 +0200
Message-ID: <20230725104608.950442148@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

Commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.

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
 io_uring/io_uring.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7625,7 +7625,7 @@ static inline int io_cqring_wait_schedul
 					  struct io_wait_queue *iowq,
 					  ktime_t *timeout)
 {
-	int ret;
+	int token, ret;
 
 	/* make sure we run task_work before checking for signals */
 	ret = io_run_task_work_sig();
@@ -7635,9 +7635,17 @@ static inline int io_cqring_wait_schedul
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
+	/*
+	 * Use io_schedule_prepare/finish, so cpufreq can take into account
+	 * that the task is waiting for IO - turns out to be important for low
+	 * QD IO.
+	 */
+	token = io_schedule_prepare();
+	ret = 1;
 	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
-		return -ETIME;
-	return 1;
+		ret = -ETIME;
+	io_schedule_finish(token);
+	return ret;
 }
 
 /*


