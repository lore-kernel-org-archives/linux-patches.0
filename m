Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B57B3E0083;
	Fri, 15 May 2026 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861060; cv=none; b=KFdmkAqHyIZe9rv/6sPXmhPXbOh9+XDUbgV1vSsqqxvBy3ON3iYHV03PYsjoErzMW/KC4hp3VIKhwUTCO4ZZir6LXIdC0Je0ovSDL71aYN+ieyBv1B7NIpkl6uWac+8YURIMeHGfbIOCW1M6y5p/TBwl5S6x6fhK7AcjvLzHTFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861060; c=relaxed/simple;
	bh=OHPiEhaux/p9hQ0VBUWpwrobC2r7e7rEmGIgxCXDq6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvjWgwSanRyLsSJoM/ppnLTjYSoc5/WP4DQ4SFx5mRuca7yuTD2qJfpJm6f0gJ1W8y9UZK6xIjCVY96UqozYQcnHRvbLGtjpIUTXydkfAx7ewOmZJi0qhFjSVrhDpRmPCH8nPqEKrQek8DM3z5g/h4JQc6GvlQ9xONpVckU4OZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogg+9Hzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogg+9Hzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B5CC2BCB0;
	Fri, 15 May 2026 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861060;
	bh=OHPiEhaux/p9hQ0VBUWpwrobC2r7e7rEmGIgxCXDq6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogg+9HztZfRhx4fQA4SQSjev7P30IX/i2UPT+rUIy8k5FwidtGtAJkU3BbY4cx/SE
	 bT0b3oIp0s72W4pe0OgYb4w1iSvU+Z5ydaZP+mjGo9eEQu4j9+McZojTohEG7+sxCr
	 +bJ1I1XxTIuITRnOB1n06PlZcTQA4St8y0NUOXUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 183/474] exit: prevent preemption of oopsing TASK_DEAD task
Date: Fri, 15 May 2026 17:44:52 +0200
Message-ID: <20260515154718.982578633@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jann Horn <jannh@google.com>

commit c1fa0bb633e4a6b11e83ffc57fa5abe8ebb87891 upstream.

When an already-exiting task oopses, make_task_dead() currently calls
do_task_dead() with preemption enabled.  That is forbidden:
do_task_dead() calls __schedule(), which has a comment saying "WARNING:
must be called with preemption disabled!".

If an oopsing task is preempted in do_task_dead(), between becoming
TASK_DEAD and entering the scheduler explicitly, bad things happen:
finish_task_switch() assumes that once the scheduler has switched away
from a TASK_DEAD task, the task can never run again and its stack is no
longer needed; but that assumption apparently doesn't hold if the dead
task was preempted (the SM_PREEMPT case).

This means that the scheduler ends up repeatedly dropping references on
the dead task's stack, which can lead to use-after-free or double-free
of the entire task stack; in other words, two tasks can end up running
on the same stack, resulting in various kinds of memory corruption.

(This does not just affect "recursively oopsing" tasks; it is enough to
oops once during task exit, for example in a file_operations::release
handler)

Fixes: 7f80a2fd7db9 ("exit: Stop poorly open coding do_task_dead in make_task_dead")
Cc: stable@kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -981,6 +981,7 @@ void __noreturn make_task_dead(int signr
 		futex_exit_recursive(tsk);
 		tsk->exit_state = EXIT_DEAD;
 		refcount_inc(&tsk->rcu_users);
+		preempt_disable();
 		do_task_dead();
 	}
 


