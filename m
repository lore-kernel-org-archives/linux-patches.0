Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F029148832;
	Fri,  6 Dec 2024 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498750; cv=none; b=kpi7qNizqAQ5GWPx/uK6AE9yMCstGEjq8EOmQz+sXb6D+0DWLsZJfXmUDhD2/REQhRupl/csEYxboJf7hMprj+xf0G0L4aew0naqzAwwInUluKUvBtjoIGlCurGsTi0C2RCp6Ao4bDT5tr1P0CgfU2wg8te3WOf9Fhf7QcxLhPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498750; c=relaxed/simple;
	bh=ErBnLBeJYW3M8t9/oAYb/LKivTL1KizRdgt9Fq6cwVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9kwhb2MCxIWVevW+ZpPpIVjGdV8jG58XeoELHeica/7AoZBlrCAkaVWPqYyen0nzxiT+zUbtMjX21AR74XIk88+91bLt61sImAVfaPIf6Kaw1PR0rT9c0gG3Pts+QkVLDV6NseqMl/1f1IK+EGWRdnx22UHHsHdFfZqlMNFjto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d49hgy0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d49hgy0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E61CC4CED1;
	Fri,  6 Dec 2024 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498750;
	bh=ErBnLBeJYW3M8t9/oAYb/LKivTL1KizRdgt9Fq6cwVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d49hgy0WJfUzt+7LjONqoLD59vI24pOmAmebsW0rqwLs4em7vUWbH7Xj1L1YmgarZ
	 KSAU4uHbu5E0wGqSCoJmlkz6TAAeVgEFMlrfOJsQPtwgRGklFNt2LUSMPjKI1xU9Ra
	 VoLI5W8YkL0RFIXp7aB5JIy9HrpzDKwOZThFHhSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Mallet <anthony.mallet@laas.fr>,
	Oleg Nesterov <oleg@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 676/676] posix-timers: Target group sigqueue to current task only if not exiting
Date: Fri,  6 Dec 2024 15:38:15 +0100
Message-ID: <20241206143719.776651196@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

commit 63dffecfba3eddcf67a8f76d80e0c141f93d44a5 upstream.

A sigqueue belonging to a posix timer, which target is not a specific
thread but a whole thread group, is preferrably targeted to the current
task if it is part of that thread group.

However nothing prevents a posix timer event from queueing such a
sigqueue from a reaped yet running task. The interruptible code space
between exit_notify() and the final call to schedule() is enough for
posix_timer_fn() hrtimer to fire.

If that happens while the current task is part of the thread group
target, it is proposed to handle it but since its sighand pointer may
have been cleared already, the sigqueue is dropped even if there are
other tasks running within the group that could handle it.

As a result posix timers with thread group wide target may miss signals
when some of their threads are exiting.

Fix this with verifying that the current task hasn't been through
exit_notify() before proposing it as a preferred target so as to ensure
that its sighand is still here and stable.

complete_signal() might still reconsider the choice and find a better
target within the group if current has passed retarget_shared_pending()
already.

Fixes: bcb7ee79029d ("posix-timers: Prefer delivery of signals to the current thread")
Reported-by: Anthony Mallet <anthony.mallet@laas.fr>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241122234811.60455-1-frederic@kernel.org
Closes: https://lore.kernel.org/all/26411.57288.238690.681680@gargle.gargle.HOWL
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1996,14 +1996,15 @@ int send_sigqueue(struct sigqueue *q, st
 	 * into t->pending).
 	 *
 	 * Where type is not PIDTYPE_PID, signals must be delivered to the
-	 * process. In this case, prefer to deliver to current if it is in
-	 * the same thread group as the target process, which avoids
-	 * unnecessarily waking up a potentially idle task.
+	 * process. In this case, prefer to deliver to current if it is in the
+	 * same thread group as the target process and its sighand is stable,
+	 * which avoids unnecessarily waking up a potentially idle task.
 	 */
 	t = pid_task(pid, type);
 	if (!t)
 		goto ret;
-	if (type != PIDTYPE_PID && same_thread_group(t, current))
+	if (type != PIDTYPE_PID &&
+	    same_thread_group(t, current) && !current->exit_state)
 		t = current;
 	if (!likely(lock_task_sighand(t, &flags)))
 		goto ret;


