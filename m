Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16423DB980;
	Tue, 12 May 2026 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607767; cv=none; b=AFwHW1UrQf8Qc7BCkdGccu854tO7X5S6cICgKy64aYlfoP8wMvqGD57dLZwc3Aa/ZNet3OsFiIgO9TEkWez+zlG7fo2f6GOgVmjA54uVbHklUo7wbXmSpClcqSwWzC+CdKJ0e7JCRgNVwV1grf2aZMimp/WOKIl2Urt/Qd2Hkk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607767; c=relaxed/simple;
	bh=HJaBFEES+mRzquYlPqHKGp7gtUfbmasX1MhgVCfM3JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9R0Mrqp16eCIdQGhpSw+iYqrM/ZdeVKTgJg/ypJmi4RAGEdrVAac94vBsKFvTA+Wi4jl6e/dGyrwCxVytC5mjKMQ7o78klWqs8OhDihfobFp8EOlNEEicKaGbeil46Qmyk86qqKsNduQ89gLEuPI7m+gfKcithU/bDdjtcgxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRmjJhs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRmjJhs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54659C2BCB0;
	Tue, 12 May 2026 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607766;
	bh=HJaBFEES+mRzquYlPqHKGp7gtUfbmasX1MhgVCfM3JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRmjJhs19qlXKvRkqf+1SB9VmpP2YP0J3CG7SIzSL0YqFAfT/JYaCWUccskT98NEz
	 kVm4zTn0oHcXVG6VaZpHMhB5D41aWx6wG8yMFiME4+XHFcm3NOGXjjYjl65eGkv31Q
	 /jh+z5kfFgT3oTwpM8fIUPlH6zSeoLfFobwc47Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 028/206] exit: prevent preemption of oopsing TASK_DEAD task
Date: Tue, 12 May 2026 19:38:00 +0200
Message-ID: <20260512173933.425539152@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1045,6 +1045,7 @@ void __noreturn make_task_dead(int signr
 		futex_exit_recursive(tsk);
 		tsk->exit_state = EXIT_DEAD;
 		refcount_inc(&tsk->rcu_users);
+		preempt_disable();
 		do_task_dead();
 	}
 


