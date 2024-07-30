Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75EA1A76B4;
	Tue, 30 Jul 2024 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359913; cv=none; b=dyWVRv5PQQWmuCG0ZRNj/smuBO4UZQaUkvHcUHzLMu5mqticwyYp1BYdJhTAoR9E182Yu9O5Rht/uBaji5KSEvZ3nsYOinxjtPRE1FDysH1gLqUScCZ4MEx+jYFoo7hQsf/Hh4YD0Ouy55bP1ugaBayyiJhtbPNWoZJre3kSC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359913; c=relaxed/simple;
	bh=YhKxCORgQ8IWfbE2IWXqdoK59ruktKgk2+t2ALqt8qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBQSqjJmOQ4PeCJjZWbsZxx1A3adpOUoO4mKBh7RhTeLD9ArYodVMnIcWyODPYVo/Y7bP8wWcYAJowcNucQFc/g8iffXeS+ywUKMZtu+mjHMmJ1jU1vpJ4EBPWDiGqX4PmTt65YIykW7GykXNZ17OJ+DKtmKeUX8QTbKM7jZVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuc/03iH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuc/03iH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1C3C4AF0A;
	Tue, 30 Jul 2024 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359913;
	bh=YhKxCORgQ8IWfbE2IWXqdoK59ruktKgk2+t2ALqt8qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuc/03iHb3wc7AJVe5VSZbjcyr+Y1M7GOTwJx/bZl6+UfSd8PHgGoohPSWAogM6j7
	 pIhESMnxY+xadpqcZe4hlBxtCBO8g8Kt4RbvvSx8EqAWdHnoKXyh+zvCFwf0YVwMnb
	 4F6rgItCVq/DvMW6+jYkQbrea7w0G9Iv22aIREH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 553/809] kernel: rerun task_work while freezing in get_signal()
Date: Tue, 30 Jul 2024 17:47:09 +0200
Message-ID: <20240730151746.600516925@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 943ad0b62e3c21f324c4884caa6cb4a871bca05c upstream.

io_uring can asynchronously add a task_work while the task is getting
freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
do_freezer_trap(), and since the get_signal()'s relock loop doesn't
retry task_work, the task will spin there not being able to sleep
until the freezing is cancelled / the task is killed / etc.

Run task_works in the freezer path. Keep the patch small and simple
so it can be easily back ported, but we might need to do some cleaning
after and look if there are other places with similar problems.

Cc: stable@vger.kernel.org
Link: https://github.com/systemd/systemd/issues/33626
Fixes: 12db8b690010c ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reported-by: Julian Orth <ju.orth@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/89ed3a52933370deaaf61a0a620a6ac91f1e754d.1720634146.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2600,6 +2600,14 @@ static void do_freezer_trap(void)
 	spin_unlock_irq(&current->sighand->siglock);
 	cgroup_enter_frozen();
 	schedule();
+
+	/*
+	 * We could've been woken by task_work, run it to clear
+	 * TIF_NOTIFY_SIGNAL. The caller will retry if necessary.
+	 */
+	clear_notify_signal();
+	if (unlikely(task_work_pending(current)))
+		task_work_run();
 }
 
 static int ptrace_signal(int signr, kernel_siginfo_t *info, enum pid_type type)


