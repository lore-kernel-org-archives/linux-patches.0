Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCD58F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E98C433C7;
	Sun, 16 Jul 2023 20:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539291;
	bh=2ToeI4h8HJSyPcpKchTff4xkYB9cZXaSoxGZQ4BbGO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDJr6t90+Hsc/An+7ZasQ0gjkaTcf1vcvRVxZJMl7Fq7HwMX5CFe6wjTed83xOAKf
	 yGZL5WMYblK5v23dDyumbnw+/xDG7om3mh0Sb3f6kRh2wAbUic+uQveyC74bNo8BDC
	 l+LmSigws/q/m6/wdqgIC01mkz7xe40afcmuJ3V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 724/800] io_uring: wait interruptibly for request completions on exit
Date: Sun, 16 Jul 2023 21:49:37 +0200
Message-ID: <20230716195005.935347253@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 4826c59453b3b4677d6bf72814e7ababdea86949 upstream.

WHen the ring exits, cleanup is done and the final cancelation and
waiting on completions is done by io_ring_exit_work. That function is
invoked by kworker, which doesn't take any signals. Because of that, it
doesn't really matter if we wait for completions in TASK_INTERRUPTIBLE
or TASK_UNINTERRUPTIBLE state. However, it does matter to the hung task
detection checker!

Normally we expect cancelations and completions to happen rather
quickly. Some test cases, however, will exit the ring and park the
owning task stopped (eg via SIGSTOP). If the owning task needs to run
task_work to complete requests, then io_ring_exit_work won't make any
progress until the task is runnable again. Hence io_ring_exit_work can
trigger the hung task detection, which is particularly problematic if
panic-on-hung-task is enabled.

As the ring exit doesn't take signals to begin with, have it wait
interruptibly rather than uninterruptibly. io_uring has a separate
stuck-exit warning that triggers independently anyway, so we're not
really missing anything by making this switch.

Cc: stable@vger.kernel.org # 5.10+
Link: https://lore.kernel.org/r/b0e4aaef-7088-56ce-244c-976edeac0e66@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3050,7 +3050,18 @@ static __cold void io_ring_exit_work(str
 			/* there is little hope left, don't run it too often */
 			interval = HZ * 60;
 		}
-	} while (!wait_for_completion_timeout(&ctx->ref_comp, interval));
+		/*
+		 * This is really an uninterruptible wait, as it has to be
+		 * complete. But it's also run from a kworker, which doesn't
+		 * take signals, so it's fine to make it interruptible. This
+		 * avoids scenarios where we knowingly can wait much longer
+		 * on completions, for example if someone does a SIGSTOP on
+		 * a task that needs to finish task_work to make this loop
+		 * complete. That's a synthetic situation that should not
+		 * cause a stuck task backtrace, and hence a potential panic
+		 * on stuck tasks if that is enabled.
+		 */
+	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
 
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
@@ -3074,7 +3085,12 @@ static __cold void io_ring_exit_work(str
 			continue;
 
 		mutex_unlock(&ctx->uring_lock);
-		wait_for_completion(&exit.completion);
+		/*
+		 * See comment above for
+		 * wait_for_completion_interruptible_timeout() on why this
+		 * wait is marked as interruptible.
+		 */
+		wait_for_completion_interruptible(&exit.completion);
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);


