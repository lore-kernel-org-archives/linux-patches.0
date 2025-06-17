Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546252ECEA7;
	Tue, 17 Jun 2025 16:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178380; cv=none; b=Yxg+5GUiteRV/87hsPMdnq+Sm3pYdnNd7gCM7/Avh5+01FAYjKcBMASWa2GNwBHuWJRlyi1RymZy/KAVDICXqcKO0lbVD6xdr6lqDVB9yOut71SNH6HR9A8/RRc5vEIcJgnmsDDhda9oeGwAiaurFqMfRTX131vm3p1EzOEoGTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178380; c=relaxed/simple;
	bh=748FPP2pIXfT6ntjgRySuMjw8Fy3jeyNSg+B9E+jFls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XkKaNsJcNXXGkrYA1HcaJdmBJBaCclsDm0qb+7cWxD1tOkXDp0OzxpiVrVqgzXOgUmnZtSZL2zj4imbxt4mdMw8aanzRsMDnsybj+TnIsilJ38bqN918ZpgQ4oqpqY0UlpwP1uJC88optzOiuFWhesKUwrn5vQKOt7CwXq6pQak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I63+gMKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I63+gMKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E83C4CEE7;
	Tue, 17 Jun 2025 16:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178380;
	bh=748FPP2pIXfT6ntjgRySuMjw8Fy3jeyNSg+B9E+jFls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I63+gMKWOvN5rC5kSXLPyZlVdi5EylH9r4wbA1xH7ZlAtYMBCDhBQ+8gBr3Gaq5OH
	 txKeMiV6yKe6x08o6pMCTv8UXCrG94JFX+9VH3w/AXlVxX7Gc1mkEvLM3uWyaIiMLw
	 wPYH6z7+1EacQtNrSCSWqtUIMoeF1A4fRmYfJCb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 487/512] posix-cpu-timers: fix race between handle_posix_cpu_timers() and posix_cpu_timer_del()
Date: Tue, 17 Jun 2025 17:27:33 +0200
Message-ID: <20250617152439.360439060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1401,6 +1401,15 @@ void run_posix_cpu_timers(void)
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


