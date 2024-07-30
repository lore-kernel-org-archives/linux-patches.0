Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856BF1A6192;
	Tue, 30 Jul 2024 16:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357408; cv=none; b=drFNRvFoq2L4yAHhhmUiYlgHQvWBZmRA6Sg2PJHK0Jq7AoKxC7jYx7O4mY3B5vc7p9WL87W4r7hHdmN2/IziCrZDA49qlUNaF1wEwSXjHPGVhq3663iGJEsjgENywxfeEk8suHNnHhEKj9voUcfnE5d6mPNKCkqEtv2wYH5MreE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357408; c=relaxed/simple;
	bh=hNZP02e7uo7whl4Hzfktj1HOKHnOb+EeRnizwHlt7uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIN4Lo+axJaPyHuvJ+3JrtB+M5V4xoqxsr0A+/66x/+wTKUkjIngGc5/If2zRoyS0eV/35Z0fdMBFJGfI0dS6/9r/7aAcr6ndP+z+J6ULY1NtJJdBCLaivZkvtrdryn8oKdB63IuD2/mBVG4nbmontoFuUAOPF6sZ9p5zNboLFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4D1obkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4D1obkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC923C4AF0A;
	Tue, 30 Jul 2024 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357408;
	bh=hNZP02e7uo7whl4Hzfktj1HOKHnOb+EeRnizwHlt7uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4D1obkN36CvZU7p6nrAGBSAgm4uwZl7F6PgVa/pBvKTBONNTqD9WxtFOHLtksqZ6
	 68oh9YSstywdh8+DMreW/Awv8SExR6hfBN9yrvm6ERPDXMpsZamKewomXgX7+pEUrL
	 J+ab+q5tz/lFUxjj9s8IN6NUj6Bg+i3V41KznTpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 280/440] kernel: rerun task_work while freezing in get_signal()
Date: Tue, 30 Jul 2024 17:48:33 +0200
Message-ID: <20240730151626.767694336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2558,6 +2558,14 @@ static void do_freezer_trap(void)
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


