Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16843EDE6A;
	Tue, 12 May 2026 17:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608299; cv=none; b=ctPNWWee3OVsLAGthg/0RAWiPHVx64IbVSvUSkA/OKq1P5kyZaW1u+glvQnriKsxwmPgxwu9VASviV7mo/j71nKZsUjOmHlIiOZfk1aWkvHm+3wNgrcYoT/id1ALXRxam3i+oO+vibROBSf3kw0tsfp6qMtvWWxAXHGoKSoI7Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608299; c=relaxed/simple;
	bh=+b6hWQpns8iED2oaaETTwAhVrTKDkjIM6OzDK4qR7Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvud0/CdE2FSPyIvvQXI/bq8MR/ODs9oEPP9jOvN6oHGwLCcPeu/zWyM7NhJgUDUrScTcyDm16iXmtXuOG4iXKJdqgnr/9kq18CiC5IaMd6RxectNWVaKIqJisuNnnBX0tATQxEz7wO4dByIKt3joNsgLFiHUxSuU9LlmV/9Fh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbvI7W91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbvI7W91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B136C2BCB0;
	Tue, 12 May 2026 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608298;
	bh=+b6hWQpns8iED2oaaETTwAhVrTKDkjIM6OzDK4qR7Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbvI7W91+iq6zTLZdrrOZBGFkRRqzb3+R0l9Xw5VnMQ+CBMmYDkrcWv4IEcHQlcfG
	 0yjOOTaeQf41T9u2Egz2AnSUazpP5GutnqtkABWTm+Nr/IT73OIXJTfTM8PhdBXZCU
	 arLR0b/WmfWFG9h8R6jPlWybV7H285XxMfDOTnQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.18 025/270] exit: prevent preemption of oopsing TASK_DEAD task
Date: Tue, 12 May 2026 19:37:06 +0200
Message-ID: <20260512173938.986043564@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1069,6 +1069,7 @@ void __noreturn make_task_dead(int signr
 		futex_exit_recursive(tsk);
 		tsk->exit_state = EXIT_DEAD;
 		refcount_inc(&tsk->rcu_users);
+		preempt_disable();
 		do_task_dead();
 	}
 


