Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DADB3DAAB7;
	Fri,  4 Sep 2026 05:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499537; cv=none; b=KE07u+m7iBIxkIzhfATfYD2jjgZ5dnHN4ZEaytSsvNWc2eRnxNtLpOXymyJRRvreFcH7FRtRIODeYpPlh+enVWcpDivd6kNvW1G4bLTj+ajs/DgzX7ndM8+/8VQZKkhJYdy80EoJ3is1WJaFMkqy+d2Vs5rqpPtfmVn31s59ugs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499537; c=relaxed/simple;
	bh=NGGDj4srUI0sk7wbxN45XiscAKNN4oL35Cu9iOcXpFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHE5Juzh//WuF4XJ1bdb+1s8ZXucAJ0rJsLE5tgKECx3DHVF+6IuZMD7fhT1F3XuCePmD4VbIlWHbP3fKy4hWWeXSPnAs5Ll7AbLQPCMp2qf2tJOkn336B8DRYw694cR77Fa0n15ofgQhKKhEPXCPLHsxIdDT4ZU1oNDJ0HlUc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qap5Ihbn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qap5Ihbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D961F00A3D;
	Fri,  4 Sep 2026 05:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499536;
	bh=FMONBQ9NrdQS595wYSL/I1zndHXd9nlUKy9ONYWUVlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qap5IhbnCe96vFcScPKGY7HAN03dY4iOckKFM3X/CR59z1aunKrS49zNqpcnmnrzP
	 tkxl32ncnMp3GdEFCafNi1PPeuREocbvPZ0NUwl0APMC6fu+0HRbIuxHH5ij9Cxvr1
	 498ZmEhbtRd+P11sN1WSoKJyEOgpmPwj3ikx0fNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.2 408/713] sched/core: Make core-sched flips wait for in-flight selections
Date: Fri,  4 Sep 2026 06:56:16 +0200
Message-ID: <20260904045812.970275403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f3629c63a4af3e491381780bc6c123cb498c4c40 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c  |   22 ++++++++++++++++++++++
 kernel/sched/sched.h |    1 +
 2 files changed, 23 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -443,6 +443,17 @@ static void __sched_core_flip(bool enabl
 
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
 
@@ -6242,6 +6253,8 @@ pick_next_task(struct rq *rq, struct rq_
 		return __pick_next_task(rq, rf);
 	}
 
+	rq->core->core_pick_in_flight++;
+
 	/*
 	 * If there were no {en,de}queues since we picked (IOW, the task
 	 * pointers are all still valid), and we haven't scheduled the last
@@ -6456,6 +6469,7 @@ restart:
 	}
 
 out_set_next:
+	rq->core->core_pick_in_flight--;
 	put_prev_set_next_task(rq, rq->donor, next);
 	if (rq->core->core_forceidle_count && next == rq->idle)
 		queue_core_balance(rq);
@@ -6651,6 +6665,13 @@ static void sched_core_cpu_deactivate(un
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
@@ -9064,6 +9085,7 @@ void __init sched_init(void)
 		rq->core_forceidle_count = 0;
 		rq->core_forceidle_occupation = 0;
 		rq->core_forceidle_start = 0;
+		rq->core_pick_in_flight = 0;
 
 		rq->core_cookie = 0UL;
 #endif
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1358,6 +1358,7 @@ struct rq {
 	unsigned int		core_forceidle_seq;
 	unsigned int		core_forceidle_occupation;
 	u64			core_forceidle_start;
+	unsigned int		core_pick_in_flight;
 #endif /* CONFIG_SCHED_CORE */
 
 	/* Scratch cpumask to be temporarily used under rq_lock */


