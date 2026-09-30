Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E8F4ED1A1;
	Wed, 30 Sep 2026 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789675; cv=none; b=LvdkaxmCwDFj0WuIF9dEfGkSSsBunjLDB/MUmhAANSD+s8JoIoAcdLTFcfGwJzylntB5LVVowXKdJyPUOz/6QNK44soa/GbEauQqAKpZ2M7a1R/tZ/OvUtaat06fGU33tlZgfeKbdWRnx7+XmPosi+pN7zv0DzkGEqJTVN21RYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789675; c=relaxed/simple;
	bh=I5ZJb4KKXYxee11FK/ReKfQLzFFo0JvC01GHpAtc26Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bzj/RZUa3DhRo0XlpfuoBytKC5XI8apPgc4AsbbnF052w2DBS0ZOM1+fuBFnWpvsYnyG1YrGpn2HUL+nKAKdj/KpNjhNX4c6iJDuQkwIVLzONtBI3g2wrFUJcM03dBwQXa3qlohimp8h1OMYR6ZrusYnbj1QEv1Nq+rN9sSowuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DChKxkUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DChKxkUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DAF1F000FF;
	Wed, 30 Sep 2026 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789672;
	bh=JkaA6oClvt8GrVfNIV1hN2JJX+s2zNO7RDOHiMjgSNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DChKxkUUGC6ljToQcLsuuP+rhUbZtbw6/dADKwOYCuxcHqwyWkytcNmWnuRCu5Xuo
	 0S1NL46D3kEM3Jo0YX3ABRT5WQcElITVV0uewkpNBzoWwT2xliPW1zh/5OuIBmireV
	 SLkeEGuaUW3zPeblW3KRxNE3YlSoIsT3k5KRipow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 561/877] sched/core: Make core-sched flips wait for in-flight selections
Date: Wed, 30 Sep 2026 17:24:32 +0200
Message-ID: <20260930152426.749028159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c  |   22 ++++++++++++++++++++++
 kernel/sched/sched.h |    1 +
 2 files changed, 23 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -401,6 +401,17 @@ static void __sched_core_flip(bool enabl
 
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
 
@@ -6092,6 +6103,8 @@ pick_next_task(struct rq *rq, struct rq_
 		return __pick_next_task(rq, rf);
 	}
 
+	rq->core->core_pick_in_flight++;
+
 	/*
 	 * If there were no {en,de}queues since we picked (IOW, the task
 	 * pointers are all still valid), and we haven't scheduled the last
@@ -6286,6 +6299,7 @@ pick_next_task(struct rq *rq, struct rq_
 	}
 
 out_set_next:
+	rq->core->core_pick_in_flight--;
 	put_prev_set_next_task(rq, rq->donor, next);
 	if (rq->core->core_forceidle_count && next == rq->idle)
 		queue_core_balance(rq);
@@ -6483,6 +6497,13 @@ static void sched_core_cpu_deactivate(un
 	core_rq->core_forceidle_occupation = rq->core_forceidle_occupation;
 
 	/*
+	 * A stale leftover would bias the count forever if this CPU later
+	 * returns as its own leader. Move, don't copy.
+	 */
+	core_rq->core_pick_in_flight       = rq->core_pick_in_flight;
+	rq->core_pick_in_flight            = 0;
+
+	/*
 	 * Accounting edge for forced idle is handled in pick_next_task().
 	 * Don't need another one here, since the hotplug thread shouldn't
 	 * have a cookie.
@@ -8553,6 +8574,7 @@ void __init sched_init(void)
 		rq->core_forceidle_count = 0;
 		rq->core_forceidle_occupation = 0;
 		rq->core_forceidle_start = 0;
+		rq->core_pick_in_flight = 0;
 
 		rq->core_cookie = 0UL;
 #endif
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1330,6 +1330,7 @@ struct rq {
 	unsigned int		core_forceidle_seq;
 	unsigned int		core_forceidle_occupation;
 	u64			core_forceidle_start;
+	unsigned int		core_pick_in_flight;
 #endif /* CONFIG_SCHED_CORE */
 
 	/* Scratch cpumask to be temporarily used under rq_lock */


