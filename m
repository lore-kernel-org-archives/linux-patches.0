Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBE344AB61;
	Tue, 21 Jul 2026 21:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668466; cv=none; b=HCuyU7loCQaotL2SUPEev/EWnT/C9ksu04anD3CSgQaRSrUE5njOJQPS1OGXzrcAakB272bY++35wx7r2XpN09drLUOj3UvVBp7RZ+LK1aJs1oZCdNx6CBw9lHIYntCrI119f2JvJTD5ovw6sRCb75WjSKLElm00NeHVJ6b+CZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668466; c=relaxed/simple;
	bh=oiIGa3iPXHN+ObJITpAh9JLe7dSdEMsnq6itvXope7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAoybvTZabtfOx7Xu96LZYvpz9WIRb8hKyzMyejvURnFP31nzgJFG+uyusichjPYE4PJRF7MPnDJvGs+WsaEbxczm9P4Z50oLHmYK0f92BaffUpFE+SIxiD+y2ttVJFn3JZnX7e3Cf65+Y63LwfsbYolHJi5Uj8B+C4OZrDFM6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSt7lf2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSt7lf2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B691F000E9;
	Tue, 21 Jul 2026 21:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668465;
	bh=jQdGutryMW1HnaipFWJnaY/mlF1RXepk5AcXkkbkdxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSt7lf2/pBpNUrU5lBS2b6G0YAc3Uyso08W0hLvkLmUgA7z7dHaqIs4TDUHUAtjVc
	 YgrfCjOYWrVdYvb54x3sMlx6HSvwCE+mfeoiiX3otXyJ+vHylg4lI15kDstF7fVL9C
	 36CFZAAGwhKdoQEJDhAqATMKBYKUIN2A3sXmptE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 0149/1067] sched/rt: Have RT_PUSH_IPI be default off for non PREEMPT_RT
Date: Tue, 21 Jul 2026 17:12:30 +0200
Message-ID: <20260721152427.928673358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit dd29c017aed628076e915fe4cdfb5392fd4c5cab upstream.

RT migration is done aggressively. When a CPU schedules out a high
priority RT task for a lower priority task, it will look to see if there's
any RT tasks that are waiting to run on another CPU that is of higher
priority than the task this CPU is about to run. If it finds one, it will
pull that task over to the CPU and allow it to run there instead.

Normally, this pulling is done by looking at the RT overloaded mask (rto)
which contains all the CPUs in the scheduler domain with RT tasks that are
waiting to run due to a higher priority RT task currently running on their
CPU. The CPU that is about to schedule a lower priority task will grab the
rq lock of the overloaded CPU and move the RT task from that CPU's runqueue
to the local one and schedule the higher priority RT task.

This caused issues when a lot of CPUs would schedule a lower priority task
at the same time. They would all try to grab the same runqueue lock of
the CPU with the overloaded RT tasks. Only the first CPU that got in will
get that task. All the others would wait until they got the runqueue lock
and see there's nothing to pull and do nothing. On systems with lots of
CPUs, this caused a large latency (up to 500us) which is beyond what
PREEMPT_RT is to allow.

The solution to that was to create an RT_PUSH_IPI logic. When any CPU
wanted to pull a task, instead of grabbing the runqueue lock of the
overloaded CPU, it would start by sending an IPI to the overloaded CPU,
and that IPI handler would have the CPU with the waiting RT task do a push
instead. Then that handler would send an IPI to the next CPU with
overloaded RT tasks, and so on. Note, after the first CPU starts this
process, if another CPU wanted to do a pull, it would see that the process
has already begun and would only increment a counter to have the IPIs
continue again.

The RT_PUSH_IPI solved the latency problem with PREEMPT_RT but could cause
a new issue with non PREEMPT_RT. Namely, softirqs run in a threaded
context on PREEMPT_RT but they can run in an interrupt context in non-RT.

If an IPI lands on a CPU that has just woken up multiple RT tasks and the
current CPU is running a non RT or a low priority RT task, instead of
doing a push, it would simply do a schedule on that CPU. But if a softirq
was also executing on this CPU, the schedule would need to wait until the
softirq finished. Until then, the CPU would still be considered overloaded
as there are RT tasks still waiting to run on it.

A live lock occurred on a workload that was doing heavy networking traffic
on a large machine where the softirqs would run 500us out of 750us. And it
would also be waking up RT tasks, causing the RT pull logic to be
constantly executed.

When a softirq triggered on a CPU with RT tasks queued but not running
yet, and the other CPUs would see this CPU as being overloaded, they would
send an IPI over to it. The CPU would notice that the waiting RT tasks are
of higher priority than the currently running task and simply schedule
that CPU instead. But because the softirq was executing, before it could
schedule, it would receive another IPI to do the same. The amount of IPIs
would slow down the currently running softirq so much that before it could
return back to task context, it would execute another softirq never
allowing the CPU to schedule. This live locked that CPU.

As RT_PUSH_IPI was created to help PREEMPT_RT, make it default off if
PREEMPT_RT is not enabled.

Fixes: b6366f048e0c ("sched/rt: Use IPI to trigger RT task push migration instead of pulling")
Closes: https://lore.kernel.org/all/20260506235716.2530720-1-tj@kernel.org/
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260515103740.25ccbed8@gandalf.local.home
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/features.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -79,8 +79,16 @@ SCHED_FEAT(WARN_DOUBLE_CLOCK, false)
  * rq lock and possibly create a large contention, sending an
  * IPI to that CPU and let that CPU push the RT task to where
  * it should go may be a better scenario.
+ *
+ * This is best for PREEMPT_RT, but for non-RT it can cause issues
+ * when preemption is disabled for long periods of time. Have
+ * it only default enabled for PREEMPT_RT.
  */
+# ifdef CONFIG_PREEMPT_RT
 SCHED_FEAT(RT_PUSH_IPI, true)
+# else
+SCHED_FEAT(RT_PUSH_IPI, false)
+# endif
 #endif
 
 SCHED_FEAT(RT_RUNTIME_SHARE, false)


