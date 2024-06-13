Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D2A1877;
	Thu, 13 Jun 2024 12:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281874; cv=none; b=fZ8eQZxBx982B4sS7zMrla6+WKtDQhxhYmWRtSZQSrz39/t0zW9W73S/L6MvbqDZD+vzMnDd3pJ23qbGpL0XGEjyuIej6W1TbrG5U3bsXZIzcGGeEb8K1r7nwzuDCo7QTQZys12/+f2ADH0gAoqkZBi1XiQlP10ePaD1BMcMrgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281874; c=relaxed/simple;
	bh=fQp+BUAYOXpsIn8yg2DbfqiKu70YMkk5Rmrfqq1N8m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSITOUdaAYymBhLx5JJFuuhUqcK85SW/kRnEzvDMFC3j2fpm15AmYeT75tH4Z2lKXTtzebHLxypg3A08tHJH8opLc9fp90De9VHGFSkq/Z7FLnkjEpdOkduFyCDA2YXszQ2RsmLnzYhlSrYgzVzphc/3SP2W0Z7SyEwufniV9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riPt4t83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riPt4t83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C89DC2BBFC;
	Thu, 13 Jun 2024 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281874;
	bh=fQp+BUAYOXpsIn8yg2DbfqiKu70YMkk5Rmrfqq1N8m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riPt4t83mLW7u2rrEEI9mBagByZ5JApJ42hQ+6aTPyw3hLw0wFM0ilXMbohsrlxmM
	 EwHLRlkW01/v7qqHRiUfTNm4nCZimGsatYuA8C4+yV00Sk3bfUqB9dOCo4cTyGja/J
	 Gg7obV/MubAWfvDZYbNcbar67GD3BhHdtivF95aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Qais Yousef <qyousef@layalina.io>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/402] sched/fair: Add EAS checks before updating root_domain::overutilized
Date: Thu, 13 Jun 2024 13:30:11 +0200
Message-ID: <20240613113304.243979650@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Shrikanth Hegde <sshegde@linux.ibm.com>

[ Upstream commit be3a51e68f2f1b17250ce40d8872c7645b7a2991 ]

root_domain::overutilized is only used for EAS(energy aware scheduler)
to decide whether to do load balance or not. It is not used if EAS
not possible.

Currently enqueue_task_fair and task_tick_fair accesses, sometime updates
this field. In update_sd_lb_stats it is updated often. This causes cache
contention due to true sharing and burns a lot of cycles. ::overload and
::overutilized are part of the same cacheline. Updating it often invalidates
the cacheline. That causes access to ::overload to slow down due to
false sharing. Hence add EAS check before accessing/updating this field.
EAS check is optimized at compile time or it is a static branch.
Hence it shouldn't cost much.

With the patch, both enqueue_task_fair and newidle_balance don't show
up as hot routines in perf profile.

  6.8-rc4:
  7.18%  swapper          [kernel.vmlinux]              [k] enqueue_task_fair
  6.78%  s                [kernel.vmlinux]              [k] newidle_balance

  +patch:
  0.14%  swapper          [kernel.vmlinux]              [k] enqueue_task_fair
  0.00%  swapper          [kernel.vmlinux]              [k] newidle_balance

While at it: trace_sched_overutilized_tp expect that second argument to
be bool. So do a int to bool conversion for that.

Fixes: 2802bf3cd936 ("sched/fair: Add over-utilization/tipping point indicator")
Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Qais Yousef <qyousef@layalina.io>
Reviewed-by: Srikar Dronamraju <srikar@linux.ibm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20240307085725.444486-2-sshegde@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 53 +++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4a1393405a6fe..94fcd585eb7f0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5746,21 +5746,41 @@ static inline unsigned long cpu_util(int cpu);
 
 static inline bool cpu_overutilized(int cpu)
 {
-	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
-	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+	unsigned long  rq_util_min, rq_util_max;
+
+	if (!sched_energy_enabled())
+		return false;
+
+	rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
 
 	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
-static inline void update_overutilized_status(struct rq *rq)
+static inline void set_rd_overutilized_status(struct root_domain *rd,
+					      unsigned int status)
 {
-	if (!READ_ONCE(rq->rd->overutilized) && cpu_overutilized(rq->cpu)) {
-		WRITE_ONCE(rq->rd->overutilized, SG_OVERUTILIZED);
-		trace_sched_overutilized_tp(rq->rd, SG_OVERUTILIZED);
-	}
+	if (!sched_energy_enabled())
+		return;
+
+	WRITE_ONCE(rd->overutilized, status);
+	trace_sched_overutilized_tp(rd, !!status);
+}
+
+static inline void check_update_overutilized_status(struct rq *rq)
+{
+	/*
+	 * overutilized field is used for load balancing decisions only
+	 * if energy aware scheduler is being used
+	 */
+	if (!sched_energy_enabled())
+		return;
+
+	if (!READ_ONCE(rq->rd->overutilized) && cpu_overutilized(rq->cpu))
+		set_rd_overutilized_status(rq->rd, SG_OVERUTILIZED);
 }
 #else
-static inline void update_overutilized_status(struct rq *rq) { }
+static inline void check_update_overutilized_status(struct rq *rq) { }
 #endif
 
 /* Runqueue only has SCHED_IDLE tasks enqueued */
@@ -5868,7 +5888,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	 * and the following generally works well enough in practice.
 	 */
 	if (!task_new)
-		update_overutilized_status(rq);
+		check_update_overutilized_status(rq);
 
 enqueue_throttle:
 	if (cfs_bandwidth_used()) {
@@ -9577,19 +9597,14 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
 
 	if (!env->sd->parent) {
-		struct root_domain *rd = env->dst_rq->rd;
-
 		/* update overload indicator if we are at root domain */
-		WRITE_ONCE(rd->overload, sg_status & SG_OVERLOAD);
+		WRITE_ONCE(env->dst_rq->rd->overload, sg_status & SG_OVERLOAD);
 
 		/* Update over-utilization (tipping point, U >= 0) indicator */
-		WRITE_ONCE(rd->overutilized, sg_status & SG_OVERUTILIZED);
-		trace_sched_overutilized_tp(rd, sg_status & SG_OVERUTILIZED);
+		set_rd_overutilized_status(env->dst_rq->rd,
+					   sg_status & SG_OVERUTILIZED);
 	} else if (sg_status & SG_OVERUTILIZED) {
-		struct root_domain *rd = env->dst_rq->rd;
-
-		WRITE_ONCE(rd->overutilized, SG_OVERUTILIZED);
-		trace_sched_overutilized_tp(rd, SG_OVERUTILIZED);
+		set_rd_overutilized_status(env->dst_rq->rd, SG_OVERUTILIZED);
 	}
 
 	update_idle_cpu_scan(env, sum_util);
@@ -11460,7 +11475,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		task_tick_numa(rq, curr);
 
 	update_misfit_status(curr, rq);
-	update_overutilized_status(task_rq(curr));
+	check_update_overutilized_status(task_rq(curr));
 
 	task_tick_core(rq, curr);
 }
-- 
2.43.0



