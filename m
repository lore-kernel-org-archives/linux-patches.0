Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732C51494C5;
	Thu, 15 Aug 2024 13:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729682; cv=none; b=CX5irsM9g1qTXWU4Pjocn7/bS6SjkOV5SpfoAtb4BH5drvokr3mx79RPhtP43avc8Ue55LbhMWkw1zfiKzGYN86JBO+tSg17D1Hs/9rLB3OXTkrW3A2HKJfRzex0F5ttVA9DYRDQZGjFssKn+FBWrBKtINAkJQkz1xTXnm6QAss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729682; c=relaxed/simple;
	bh=n5caRckWfIC/Yt7nq3JayI/1quvdw8B3WQQntFFskbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Laoy7WPplqIJwzW8xvTWGMhLU8ej2hJXkWnduvuuVnTyjN9HU691RJcMx9MJoyRLXqxSO9t0mZKvIBSFPCv1FAyiYV6TdxjLx9EA89REFdLatmKgsVG/pQbgzUv6kiQG2yhAoJyYHY3mzikF/mecLNdFNZkusdJgNWryBiQX1wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcOvFWL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcOvFWL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88776C32786;
	Thu, 15 Aug 2024 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729682;
	bh=n5caRckWfIC/Yt7nq3JayI/1quvdw8B3WQQntFFskbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcOvFWL887yyAYmT0yOpAumqTgApoGm80MdwMuO6+HDmoIKBDFSgMPYaA6BevHkAo
	 dCyV4boYkOTEU1BqvAjGiHRaT2ZL3VM9WIto4W4j7vGLjOht2uk9HDFGuPB1GS7X4U
	 Yh150HGXubKi6G0/gbZGnZ7TZCwLLB1APSYT+Fy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.15 175/484] sched/fair: set_load_weight() must also call reweight_task() for SCHED_IDLE tasks
Date: Thu, 15 Aug 2024 15:20:33 +0200
Message-ID: <20240815131948.174046531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d329605287020c3d1c3b0dadc63d8208e7251382 upstream.

When a task's weight is being changed, set_load_weight() is called with
@update_load set. As weight changes aren't trivial for the fair class,
set_load_weight() calls fair.c::reweight_task() for fair class tasks.

However, set_load_weight() first tests task_has_idle_policy() on entry and
skips calling reweight_task() for SCHED_IDLE tasks. This is buggy as
SCHED_IDLE tasks are just fair tasks with a very low weight and they would
incorrectly skip load, vlag and position updates.

Fix it by updating reweight_task() to take struct load_weight as idle weight
can't be expressed with prio and making set_load_weight() call
reweight_task() for SCHED_IDLE tasks too when @update_load is set.

Fixes: 9059393e4ec1 ("sched/fair: Use reweight_entity() for set_user_nice()")
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org # v4.15+
Link: http://lkml.kernel.org/r/20240624102331.GI31592@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c  |   23 ++++++++++-------------
 kernel/sched/fair.c  |    7 +++----
 kernel/sched/sched.h |    2 +-
 3 files changed, 14 insertions(+), 18 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1203,27 +1203,24 @@ int tg_nop(struct task_group *tg, void *
 static void set_load_weight(struct task_struct *p, bool update_load)
 {
 	int prio = p->static_prio - MAX_RT_PRIO;
-	struct load_weight *load = &p->se.load;
+	struct load_weight lw;
 
-	/*
-	 * SCHED_IDLE tasks get minimal weight:
-	 */
 	if (task_has_idle_policy(p)) {
-		load->weight = scale_load(WEIGHT_IDLEPRIO);
-		load->inv_weight = WMULT_IDLEPRIO;
-		return;
+		lw.weight = scale_load(WEIGHT_IDLEPRIO);
+		lw.inv_weight = WMULT_IDLEPRIO;
+	} else {
+		lw.weight = scale_load(sched_prio_to_weight[prio]);
+		lw.inv_weight = sched_prio_to_wmult[prio];
 	}
 
 	/*
 	 * SCHED_OTHER tasks have to update their load when changing their
 	 * weight
 	 */
-	if (update_load && p->sched_class == &fair_sched_class) {
-		reweight_task(p, prio);
-	} else {
-		load->weight = scale_load(sched_prio_to_weight[prio]);
-		load->inv_weight = sched_prio_to_wmult[prio];
-	}
+	if (update_load && p->sched_class == &fair_sched_class)
+		reweight_task(p, &lw);
+	else
+		p->se.load = lw;
 }
 
 #ifdef CONFIG_UCLAMP_TASK
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3121,15 +3121,14 @@ static void reweight_entity(struct cfs_r
 
 }
 
-void reweight_task(struct task_struct *p, int prio)
+void reweight_task(struct task_struct *p, const struct load_weight *lw)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	struct load_weight *load = &se->load;
-	unsigned long weight = scale_load(sched_prio_to_weight[prio]);
 
-	reweight_entity(cfs_rq, se, weight);
-	load->inv_weight = sched_prio_to_wmult[prio];
+	reweight_entity(cfs_rq, se, lw->weight);
+	load->inv_weight = lw->inv_weight;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2322,7 +2322,7 @@ extern void init_sched_dl_class(void);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 
-extern void reweight_task(struct task_struct *p, int prio);
+extern void reweight_task(struct task_struct *p, const struct load_weight *lw);
 
 extern void resched_curr(struct rq *rq);
 extern void resched_cpu(int cpu);


