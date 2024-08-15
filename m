Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C41519FA99;
	Thu, 15 Aug 2024 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732274; cv=none; b=eiAJumxEVdiYHRaIsVcd+KalVuPueIJs0wXKRbJkCHnb/cMHz2Mw3VWKIoxmlUAPGU82cVBeMWXWEDmgUQEbvjEt9JvQXxV/KDZ5yzRs/hqZMpyA28C8aGu9kPopxeSXB0Nl5ERqjPqEZWTuLeQIBJjOFoFayJq6LSvDpn2hKQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732274; c=relaxed/simple;
	bh=MQOBFzygx2yi4JEjBD5NvZkXzd/p7acyVSIcgA9SVic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThwN+yuZ+gQEHTRSJWuRtb1N83Ff3MbvDzxsTh7cqXuCdOcDfafflmlNyv1kgUQBzXWXWmhuNmtEpDwCY/8i0Fi3ezaj5WEMBQ0bhhlZ+nolIi7V7nRevlg3hdrKVnbPc3jFb8EZCT+j0EE5Ndyn/SzxpS3abeF7t4guuHsckUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQkVlbpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQkVlbpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC50FC32786;
	Thu, 15 Aug 2024 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732274;
	bh=MQOBFzygx2yi4JEjBD5NvZkXzd/p7acyVSIcgA9SVic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQkVlbpicd0J9cGYQgOEDlOlOIYJczZYWP/PJyrKVy/ZxujCo5QwTbx+UEFXT0Tm8
	 4Ie+WPn03Oxr2M3AfIqMUMcI/gJ74aOmbli4mvf2S5zy7tRf88V/WvmRiOMXKCht+e
	 iYvUqaYF2JwL5+WhqxyDXt0pmJP22blK/56H6YlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 129/352] sched/fair: set_load_weight() must also call reweight_task() for SCHED_IDLE tasks
Date: Thu, 15 Aug 2024 15:23:15 +0200
Message-ID: <20240815131924.240080424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -848,27 +848,24 @@ static void set_load_weight(struct task_
 {
 	bool update_load = !(READ_ONCE(p->state) & TASK_NEW);
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
@@ -3119,15 +3119,14 @@ static void reweight_entity(struct cfs_r
 
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
@@ -1938,7 +1938,7 @@ extern void init_sched_dl_class(void);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 
-extern void reweight_task(struct task_struct *p, int prio);
+extern void reweight_task(struct task_struct *p, const struct load_weight *lw);
 
 extern void resched_curr(struct rq *rq);
 extern void resched_cpu(int cpu);


