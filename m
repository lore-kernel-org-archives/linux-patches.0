Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215956;
	b=aDu1O8n5p3jK41PNz6miXgtwAITktXNgn3HAD/XiopZHnjj3k74NBl0xT7CRTzu9ukPs
	 XaQ2TDC0AyctoKT9uUxpxJTXa1bVuxeWlvchM1SJNj4S8yoPYy6XgVfJdZOvIK60dAlPk
	 0HosYBULQxKC0f4rdgcj04QvScWo3NBZ6UjEuz8NxyrhhJTyX3HMt9mTVtcjyh+2ixs3p
	 nWUU/TrZpD2ZbUXcFqmkg1+s7xRvBj1gxagHJSFJccbnW0g4I7WcqkyKoex7gJ34AcX+Y
	 XCWN2dd1pxYvWZkUWv92uJnwrYyNXCi8aSsNkVdYmlV2oWX1cVcVJlKIuBJS7wEElhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/dbGxVI6nMwlZ8kmImBPMI7Z958KKBknAGvb/3eK6D8=;
	b=AexfHOUyVPcwfkT1pwsWNKgcKeLDo+ZFrD86BiP6Z37SvFgtQpMKhcBWv2qpCKcB3TCh
	 rF10UmAluJllpM5CnqNaatOJpUKCFXaws92oZXe+T59Cu0BdK7EaCmb99vKBEmui1QlqI
	 4MO+dKaWVoO+aA7bu/VN3zysULn62wRMUGAPboVNYYmEx3/JvscNJmgLxh+DdCKUN3dk0
	 WcK6XkmJk1qLw1uhaOZSIf/xle9qE0nVQMYcYNf2n20IJfkDI77/2cYAn5IxAfEML91Fn
	 7wO7dCmVlNtdPsJiM6zKVup3murYS+dMQh5q8IeXSdS4dzuHjeXTENUzJxad25ydQKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mDeDm2t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D27606A31A;
	Wed, 28 Oct 2026 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mDeDm2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AFC1F01825;
	Wed, 28 Oct 2026 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215956;
	bh=/dbGxVI6nMwlZ8kmImBPMI7Z958KKBknAGvb/3eK6D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mDeDm2taUcN4g7HpXphC/9FYxlkxPLjKglOMsK4NrKHlQJXweuDUtjH+bYkzHrr+
	 8vSWRGfPyvxjlqM72UxflK1DB100e42oqMch4pK6XncWtcl5S5wb4vRjvPNqCB+thc
	 9VFcrib1HMDH5TUlHfG40HSTpWp/UDHxIm9PxpqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1391/1887] sched/core: Make core-sched flips wait for in-flight selections
Date: Wed, 28 Oct 2026 17:58:07 +0100
Message-ID: <20261028170531.106593189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit f3629c63a4af3e491381780bc6c123cb498c4c40 ]

Core scheduling's pick_next_task() operates on all sibling rqs under one
acquisition of the shared core-wide lock. A ->pick_task() that releases the
rq lock leaves every sibling __lock momentarily free, letting
__sched_core_flip(false) complete mid-selection and rebind rq_lockp() under
it. The selection resumes on the split locks, touching sibling state it no
longer protects, and __schedule() finally releases a lock that was never
taken while leaking the one that was.

Count in-flight core-wide selections in the leader's rq->core_pick_in_flight
and make __sched_core_flip() wait for the count to drain. The count only
changes under the shared lock, which the flip holds while sampling, so no
other ordering is needed. The wait can repeat while selections overlap, but
the flip backs off between samples and flips are rare cookie-lifetime
events.

sched_core_cpu_deactivate() moves the count to the new leader - a stale copy
left behind would bias it forever if that CPU later returns as its own
leader.

Fixes: 539f65125d20 ("sched: Add core wide task selection and scheduling")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  | 22 ++++++++++++++++++++++
 kernel/sched/sched.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7494e05bbdc81..cf470ac63af72 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -345,6 +345,17 @@ static void __sched_core_flip(bool enabled)
 
 		sched_core_lock(cpu, &flags);
 
+		/*
+		 * A core-wide selection may have the shared rq lock temporarily
+		 * released by a lock-dropping ->pick_task(). Flipping would
+		 * rebind rq_lockp() under it. Wait it out.
+		 */
+		while (cpu_rq(cpu)->core->core_pick_in_flight) {
+			sched_core_unlock(cpu, &flags);
+			cpu_relax();
+			sched_core_lock(cpu, &flags);
+		}
+
 		for_each_cpu(t, smt_mask)
 			cpu_rq(t)->core_enabled = enabled;
 
@@ -5959,6 +5970,8 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 		return __pick_next_task(rq, prev, rf);
 	}
 
+	rq->core->core_pick_in_flight++;
+
 	/*
 	 * If there were no {en,de}queues since we picked (IOW, the task
 	 * pointers are all still valid), and we haven't scheduled the last
@@ -6152,6 +6165,7 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 out_set_next:
 	set_next_task(rq, next);
 out:
+	rq->core->core_pick_in_flight--;
 	if (rq->core->core_forceidle_count && next == rq->idle)
 		queue_core_balance(rq);
 
@@ -6344,6 +6358,13 @@ static void sched_core_cpu_deactivate(unsigned int cpu)
 	core_rq->core_forceidle_seq        = rq->core_forceidle_seq;
 	core_rq->core_forceidle_occupation = rq->core_forceidle_occupation;
 
+	/*
+	 * A stale leftover would bias the count forever if this CPU later
+	 * returns as its own leader. Move, don't copy.
+	 */
+	core_rq->core_pick_in_flight       = rq->core_pick_in_flight;
+	rq->core_pick_in_flight            = 0;
+
 	/*
 	 * Accounting edge for forced idle is handled in pick_next_task().
 	 * Don't need another one here, since the hotplug thread shouldn't
@@ -9862,6 +9883,7 @@ void __init sched_init(void)
 		rq->core_forceidle_count = 0;
 		rq->core_forceidle_occupation = 0;
 		rq->core_forceidle_start = 0;
+		rq->core_pick_in_flight = 0;
 
 		rq->core_cookie = 0UL;
 #endif
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a6c2b8f3045ee..accff24e091e4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1151,6 +1151,7 @@ struct rq {
 	unsigned int		core_forceidle_seq;
 	unsigned int		core_forceidle_occupation;
 	u64			core_forceidle_start;
+	unsigned int		core_pick_in_flight;
 #endif
 };
 
-- 
2.53.0



