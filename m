Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DC71974F4;
	Wed,  2 Oct 2024 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880214; cv=none; b=k/391gDGR2rBnTak+s3Eraa0cVrulJt+c/hiMxCwJQ9FgI49sHsltRjB6sJXT+DbxhPCvDq/I2EzPXv4sg0CA+h9HAnD2wVOVRMnbBKcKbjm7p2BoUDThQb/6jBT4Bm5ABhE4qG2fKOnSxm/8jQ/PJULrDtrxwU9pvY49Tzv4b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880214; c=relaxed/simple;
	bh=kS5mLZ/Zv7cKL7Ky5OGIJss0rXoz8LbWhuRAs7DnyHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeQYVnWIJDL1XpAG/yBE6A8c5pa5Sv2SlB8G12MCEMddNLXw8HaRP5bwzCGqaBkgQbifRSEqTerBMaxVOtuISk95Mv6sCqw5OJtDxu7VEf0TOwBmWiO/LsuyPNuE/g3sj4ef7Xkoa9T7+eXluaUuoeBIWyZLuq8C/5Kbppdu/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1DnKo0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1DnKo0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C47DC4CEC2;
	Wed,  2 Oct 2024 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880213;
	bh=kS5mLZ/Zv7cKL7Ky5OGIJss0rXoz8LbWhuRAs7DnyHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1DnKo0dNUDGRCeT/+cpIKalMpWgnFuxyIkQKFPgo8uT1ZOPPMi9q6Osjz8VbMZAQ
	 1IPfCZ/x7gYUZo/JX+bNO1L/ev4CQAlYUJ+0zNOSQEWKd46vz6aODohlZ1/glBwiFW
	 +PKmLAst8cwtodkpjy7bps3ZMbhxY3G2UKjDX3Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 383/538] io_uring: check for presence of task_work rather than TIF_NOTIFY_SIGNAL
Date: Wed,  2 Oct 2024 15:00:22 +0200
Message-ID: <20241002125807.549575663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 04beb6e0e08c30c6f845f50afb7d7953603d7a6f upstream.

If some part of the kernel adds task_work that needs executing, in terms
of signaling it'll generally use TWA_SIGNAL or TWA_RESUME. Those two
directly translate to TIF_NOTIFY_SIGNAL or TIF_NOTIFY_RESUME, and can
be used for a variety of use case outside of task_work.

However, io_cqring_wait_schedule() only tests explicitly for
TIF_NOTIFY_SIGNAL. This means it can miss if task_work got added for
the task, but used a different kind of signaling mechanism (or none at
all). Normally this doesn't matter as any task_work will be run once
the task exits to userspace, except if:

1) The ring is setup with DEFER_TASKRUN
2) The local work item may generate normal task_work

For condition 2, this can happen when closing a file and it's the final
put of that file, for example. This can cause stalls where a task is
waiting to make progress inside io_cqring_wait(), but there's nothing else
that will wake it up. Hence change the "should we schedule or loop around"
check to check for the presence of task_work explicitly, rather than just
TIF_NOTIFY_SIGNAL as the mechanism. While in there, also change the
ordering of what type of task_work first in terms of ordering, to both
make it consistent with other task_work runs in io_uring, but also to
better handle the case of defer task_work generating normal task_work,
like in the above example.

Reported-by: Jan Hendrik Farr <kernel@jfarr.cc>
Link: https://github.com/axboe/liburing/issues/1235
Cc: stable@vger.kernel.org
Fixes: 846072f16eed ("io_uring: mimimise io_cqring_wait_schedule")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2514,7 +2514,7 @@ static inline int io_cqring_wait_schedul
 		return 1;
 	if (unlikely(!llist_empty(&ctx->work_llist)))
 		return 1;
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
+	if (unlikely(task_work_pending(current)))
 		return 1;
 	if (unlikely(task_sigpending(current)))
 		return -EINTR;
@@ -2610,9 +2610,9 @@ static int io_cqring_wait(struct io_ring
 		 * If we got woken because of task_work being processed, run it
 		 * now rather than let the caller do another wait loop.
 		 */
-		io_run_task_work();
 		if (!llist_empty(&ctx->work_llist))
 			io_run_local_work(ctx, nr_wait);
+		io_run_task_work();
 
 		/*
 		 * Non-local task_work will be run on exit to userspace, but


