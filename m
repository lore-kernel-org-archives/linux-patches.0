Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE927482;
	Mon, 23 Jun 2025 21:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713370; cv=none; b=sqwPddlzA3w0NPVU3AfQXAuchdabI2dX+axMY7pM+JUXVBRS5MoI1LezvhXLxaDuLCUZxsxY1hGS49wcP4O8+bs1soukcYCRIsIkSZUEJ6HsGKfwv4hmarqkPSvCqzKu/2QdqWq69T7tysNYXDoOG8ZUcjXctmdHRj1rYRD0HcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713370; c=relaxed/simple;
	bh=UaIUNznorEkse28JALflmvsFp2JJFkHHrfgWpVpeIds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bl1hVAAJ+WRBMAf9OS2S4HFIrxNesfinUDvYBuVLJrUWKRu/MV4qyDl+cUfWcw4mj44z7KSBxhrtQlWliZtNk/LuKVK5DHYtQ7CY8ytEAkPHlhIRQG859nLRhMDQwwZIUnOsRl4trUACF0dAs98jlfN6zRvJaHur74SRbhnkTS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRGxz5eK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRGxz5eK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425A2C4CEEA;
	Mon, 23 Jun 2025 21:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713370;
	bh=UaIUNznorEkse28JALflmvsFp2JJFkHHrfgWpVpeIds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRGxz5eK2MxMkU/rtrVb7g4VF6LLTPJRZoSqty3aNFQQKaP7YNhMfdqL5/lexd7Ce
	 QMBy6f13EA66semjfqrD8tRPVFH2t7iq4g3i1ZasE7onpxzhwgnEsu7AaBMasINcGi
	 HVLYKTGcJFooC4jOW3Dld0ejaesHMZkNFmnexcNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 140/355] posix-cpu-timers: fix race between handle_posix_cpu_timers() and posix_cpu_timer_del()
Date: Mon, 23 Jun 2025 15:05:41 +0200
Message-ID: <20250623130630.928893871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit f90fff1e152dedf52b932240ebbd670d83330eca upstream.

If an exiting non-autoreaping task has already passed exit_notify() and
calls handle_posix_cpu_timers() from IRQ, it can be reaped by its parent
or debugger right after unlock_task_sighand().

If a concurrent posix_cpu_timer_del() runs at that moment, it won't be
able to detect timer->it.cpu.firing != 0: cpu_timer_task_rcu() and/or
lock_task_sighand() will fail.

Add the tsk->exit_state check into run_posix_cpu_timers() to fix this.

This fix is not needed if CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y, because
exit_task_work() is called before exit_notify(). But the check still
makes sense, task_work_add(&tsk->posix_cputimers_work.work) will fail
anyway in this case.

Cc: stable@vger.kernel.org
Reported-by: Benoît Sevens <bsevens@google.com>
Fixes: 0bdd2ed4138e ("sched: run_posix_cpu_timers: Don't check ->exit_state, use lock_task_sighand()")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-cpu-timers.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1374,6 +1374,15 @@ void run_posix_cpu_timers(void)
 	lockdep_assert_irqs_disabled();
 
 	/*
+	 * Ensure that release_task(tsk) can't happen while
+	 * handle_posix_cpu_timers() is running. Otherwise, a concurrent
+	 * posix_cpu_timer_del() may fail to lock_task_sighand(tsk) and
+	 * miss timer->it.cpu.firing != 0.
+	 */
+	if (tsk->exit_state)
+		return;
+
+	/*
 	 * If the actual expiry is deferred to task work context and the
 	 * work is already scheduled there is no point to do anything here.
 	 */


