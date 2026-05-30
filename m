Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B2C2E92B3;
	Sat, 30 May 2026 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160301; cv=none; b=liKRjfJ6pXrKr716mD2WnTOQUKiM9y30dDR6+svcpqcTnOv5I0f+t1qoQDjdTy0KSFOj7VpCaFL9COa2peZ3G+rgeErg4qneXKKK6PKJ2LaaohwU/eNzKSEZChNSSleTx3h655OsemSa+kuZlEHPorjM1RnTVqBKgsUGqfHRlNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160301; c=relaxed/simple;
	bh=t/8P4OZR2Tmgry3chVCOeuTASRLHYf5uFKAEufYeyR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nX+5MhHUkYV2zeVKzMANfe0o50EJ3dSWQlR2QGnbWlYhrf0vPvqBVPQpeG2IbpQ0sfFm+ZKDDqQS+EzUVGsPf+mSs3Gf0DSyXux5EDF96kyfDxlKQweUTLVyCW5AWR72bueRURvskUEWXJ5UwMymqe8egkATbGB35X7vtatWZOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gydzsjBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gydzsjBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647FD1F00893;
	Sat, 30 May 2026 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160300;
	bh=x0E0xoJEVUy40I4tbeD5RrdGvfpYcKx4gNZkYINwTqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gydzsjBrW+Dz27g61B3f6ZOXqKU/ZsZB7U7q8HIch/Doum+WD8V7sMvtSqMrbmqBw
	 5RktmVnwztIpS+b1ogBst0Wg8+ujIA63Ff1fMI3xV797AfhP0/s5aomE0+QdKM+UqN
	 OS98yxt4113Lc0RrdiE0/wFPk9/7TS2z+y7gkgv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 299/969] exit: prevent preemption of oopsing TASK_DEAD task
Date: Sat, 30 May 2026 17:57:03 +0200
Message-ID: <20260530160308.694821501@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -979,6 +979,7 @@ void __noreturn make_task_dead(int signr
 		futex_exit_recursive(tsk);
 		tsk->exit_state = EXIT_DEAD;
 		refcount_inc(&tsk->rcu_users);
+		preempt_disable();
 		do_task_dead();
 	}
 


