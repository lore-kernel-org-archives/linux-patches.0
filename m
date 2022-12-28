Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4CE1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54128C433EF;
	Wed, 28 Dec 2022 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238945;
	bh=6dBn2pioj3pX4GhhE5irszBcK/xTLQuDMqWO/V4KxYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVdokcnXmOdbXLtjDtB8x3x0rCbIPLAfOPReJov6yYfDo917TH0yEqngGuj9k+GAI
	 NOYBxOu7gw7KqfCi9mmQJJ+SDHLwRxWKkD069vUcv4qECS+zQAFmjGK816eUqdZMA7
	 4LlIY9tLn36OBhdv8jFHjLEgfTJ1c8KjWZlaq6nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qais Yousef <qais.yousef@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 5.15 069/731] sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
Date: Wed, 28 Dec 2022 15:32:56 +0100
Message-Id: <20221228144258.552203041@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit b48e16a69792b5dc4a09d6807369d11b2970cc36 ]

So that the new uclamp rules in regard to migration margin and capacity
pressure are taken into account correctly.

Fixes: a7008c07a568 ("sched/fair: Make task_fits_capacity() consider uclamp restrictions")
Co-developed-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-3-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c  |   26 ++++++++++++++++----------
 kernel/sched/sched.h |    9 +++++++++
 2 files changed, 25 insertions(+), 10 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4243,10 +4243,12 @@ static inline int util_fits_cpu(unsigned
 	return fits;
 }
 
-static inline int task_fits_capacity(struct task_struct *p,
-				     unsigned long capacity)
+static inline int task_fits_cpu(struct task_struct *p, int cpu)
 {
-	return fits_capacity(uclamp_task_util(p), capacity);
+	unsigned long uclamp_min = uclamp_eff_value(p, UCLAMP_MIN);
+	unsigned long uclamp_max = uclamp_eff_value(p, UCLAMP_MAX);
+	unsigned long util = task_util_est(p);
+	return util_fits_cpu(util, uclamp_min, uclamp_max, cpu);
 }
 
 static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
@@ -4259,7 +4261,7 @@ static inline void update_misfit_status(
 		return;
 	}
 
-	if (task_fits_capacity(p, capacity_of(cpu_of(rq)))) {
+	if (task_fits_cpu(p, cpu_of(rq))) {
 		rq->misfit_task_load = 0;
 		return;
 	}
@@ -8157,7 +8159,7 @@ static int detach_tasks(struct lb_env *e
 
 		case migrate_misfit:
 			/* This is not a misfit task */
-			if (task_fits_capacity(p, capacity_of(env->src_cpu)))
+			if (task_fits_cpu(p, env->src_cpu))
 				goto next;
 
 			env->imbalance = 0;
@@ -9042,6 +9044,10 @@ static inline void update_sg_wakeup_stat
 
 	memset(sgs, 0, sizeof(*sgs));
 
+	/* Assume that task can't fit any CPU of the group */
+	if (sd->flags & SD_ASYM_CPUCAPACITY)
+		sgs->group_misfit_task_load = 1;
+
 	for_each_cpu(i, sched_group_span(group)) {
 		struct rq *rq = cpu_rq(i);
 		unsigned int local;
@@ -9061,12 +9067,12 @@ static inline void update_sg_wakeup_stat
 		if (!nr_running && idle_cpu_without(i, p))
 			sgs->idle_cpus++;
 
-	}
+		/* Check if task fits in the CPU */
+		if (sd->flags & SD_ASYM_CPUCAPACITY &&
+		    sgs->group_misfit_task_load &&
+		    task_fits_cpu(p, i))
+			sgs->group_misfit_task_load = 0;
 
-	/* Check if task fits in the group */
-	if (sd->flags & SD_ASYM_CPUCAPACITY &&
-	    !task_fits_capacity(p, group->sgc->max_capacity)) {
-		sgs->group_misfit_task_load = 1;
 	}
 
 	sgs->group_capacity = group->sgc->capacity;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2916,6 +2916,15 @@ static inline bool uclamp_is_used(void)
 	return static_branch_likely(&sched_uclamp_used);
 }
 #else /* CONFIG_UCLAMP_TASK */
+static inline unsigned long uclamp_eff_value(struct task_struct *p,
+					     enum uclamp_id clamp_id)
+{
+	if (clamp_id == UCLAMP_MIN)
+		return 0;
+
+	return SCHED_CAPACITY_SCALE;
+}
+
 static inline
 unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 				  struct task_struct *p)


