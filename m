Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6CC184549;
	Tue, 30 Jul 2024 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358628; cv=none; b=GIPSdFUhZgANVI82qHadVPIlXqEdTM6wL4MZLLMrTMAagASCvwez1wvfuvfSOcabUp3CFRJTk6BQoY5+mtvpXynICHQyfLJEV+rtYw6kjI1V5kCxRQBc0fRDi5zQ7xt5GkBZQDpr6i1kQFAQSKQsr/LStLYzhA4KecjjDZLxNGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358628; c=relaxed/simple;
	bh=i5Jp+Y1frKVQrvSJLCZKnKptTN+PSHIwiU5N//fextk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0kM28buaYXcjedUprvGsy0uBSsF2W2TcHrmSlfPk2yf7mM0eLaPJp2jipqRTt8e6SPPFcJWCU/x9ymGrXazGNqxfj4nKvWyMgQSZwwmmmm+RC8aJS99q0mfS/BGCGWMW2cvaeP/7+MRuStcKugEvgtewlvfRX4IE78g+1INQlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYQSngld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYQSngld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A2EC32782;
	Tue, 30 Jul 2024 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358627;
	bh=i5Jp+Y1frKVQrvSJLCZKnKptTN+PSHIwiU5N//fextk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYQSngldUZClOjm4mQXgcpXJIgTGBFIF87R2Glzlpr6lghT3tIvRXYfYSkaOGpRkw
	 q5M74jMkjZyiHT0UQPd5pCq6nYQwzBppvrZM7d7JYp9qzzt3AIVpltJO97H3PfcxT8
	 bZNTHNKjxhwEiRTipGTccLRcgSIwFNJnHkXU7jHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 371/568] kernel: rerun task_work while freezing in get_signal()
Date: Tue, 30 Jul 2024 17:47:58 +0200
Message-ID: <20240730151654.365055674@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
@@ -2587,6 +2587,14 @@ static void do_freezer_trap(void)
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


