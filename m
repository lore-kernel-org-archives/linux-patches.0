Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1FA391E72;
	Sat, 12 Sep 2026 19:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243137; cv=none; b=VcLI5S8CUj0sRV/eju7mI4teO8aJqMrI53O4Y39DHKpX2Ne4Ysl46AhmkNurTw7P/Pl+6HqCqxBLALkoqPUHSnCt5tJLYepwkHRYm4qYJd/TkKhoH2Iun+ac8RMFr6bB/b7ool3vGdhQgarJPPhRWoBJzN9BkQN/zGA5EtH83qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243137; c=relaxed/simple;
	bh=ZrfAl7vvKjg4la0aHezQCFYbQoFXPFafwHHxtvsPd78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzhimMlqjlslUzXZRnN1b6gne1YcTSV/rIy9r2kfiQksVh3/2pzbS2GjNKWtjinIiRVguZwn+NpzjAlqzGy+/+Gf3V3H9a/cpJnzPp2cdZVpyfv405FGSUS7gUTvrf6beKhHtf8Nm953EvUma8tpvbSAyDmgDNy1M6Qgpb8Qp9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLKZ0etW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLKZ0etW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB261F00893;
	Sat, 12 Sep 2026 19:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243134;
	bh=Z1r+TzowZIoo0E25fDlU0FC7xXXwaAreocD1GWxTSM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLKZ0etWXCLwZYQR4zYc+ZGxtAYKlAovUbQBuPXb2rSFqbqXQMBe0Bf6E+0WOmq7H
	 3gv2JcGGdeJBP5X5+4+zCPzCydDb3dFkMfDsACJnOA4XG870SbjjVOIL1xltdP78/v
	 ffrrfiqVoGjnyMpTu4ZR2bbqF5JOHl/i+K7Tytk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <valentin.schneider@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Qais Yousef <qais.yousef@arm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Lingutla Chandrasekhar <clingutla@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 647/798] sched/fair: Introduce a CPU capacity comparison helper
Date: Sat, 12 Sep 2026 09:04:35 +0200
Message-ID: <20260912065531.942761009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 4aed8aa41524a1fc6439171881c2bb7ace197528 ]

During load-balance, groups classified as group_misfit_task are filtered
out if they do not pass

  group_smaller_max_cpu_capacity(<candidate group>, <local group>);

which itself employs fits_capacity() to compare the sgc->max_capacity of
both groups.

Due to the underlying margin, fits_capacity(X, 1024) will return false for
any X > 819. Tough luck, the capacity_orig's on e.g. the Pixel 4 are
{261, 871, 1024}. If a CPU-bound task ends up on one of those "medium"
CPUs, misfit migration will never intentionally upmigrate it to a CPU of
higher capacity due to the aforementioned margin.

One may argue the 20% margin of fits_capacity() is excessive in the advent
of counter-enhanced load tracking (APERF/MPERF, AMUs), but one point here
is that fits_capacity() is meant to compare a utilization value to a
capacity value, whereas here it is being used to compare two capacity
values. As CPU capacity and task utilization have different dynamics, a
sensible approach here would be to add a new helper dedicated to comparing
CPU capacities.

Also note that comparing capacity extrema of local and source sched_group's
doesn't make much sense when at the day of the day the imbalance will be
pulled by a known env->dst_cpu, whose capacity can be anywhere within the
local group's capacity extrema.

While at it, replace group_smaller_{min, max}_cpu_capacity() with
comparisons of the source group's min/max capacity and the destination
CPU's capacity.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Qais Yousef <qais.yousef@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Lingutla Chandrasekhar <clingutla@codeaurora.org>
Link: https://lkml.kernel.org/r/20210407220628.3798191-4-valentin.schneider@arm.com
Stable-dep-of: 50b101f6e586 ("sched/fair: Check CPU capacity before comparing group types during load balance")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fa85b84fdbc53..6e564b06efac5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -113,6 +113,13 @@ int __weak arch_asym_cpu_priority(int cpu)
  */
 #define fits_capacity(cap, max)	((cap) * 1280 < (max) * 1024)
 
+/*
+ * The margin used when comparing CPU capacities.
+ * is 'cap1' noticeably greater than 'cap2'
+ *
+ * (default: ~5%)
+ */
+#define capacity_greater(cap1, cap2) ((cap1) * 1024 > (cap2) * 1078)
 #endif
 
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -8607,26 +8614,6 @@ group_is_overloaded(unsigned int imbalance_pct, struct sg_lb_stats *sgs)
 	return false;
 }
 
-/*
- * group_smaller_min_cpu_capacity: Returns true if sched_group sg has smaller
- * per-CPU capacity than sched_group ref.
- */
-static inline bool
-group_smaller_min_cpu_capacity(struct sched_group *sg, struct sched_group *ref)
-{
-	return fits_capacity(sg->sgc->min_capacity, ref->sgc->min_capacity);
-}
-
-/*
- * group_smaller_max_cpu_capacity: Returns true if sched_group sg has smaller
- * per-CPU capacity_orig than sched_group ref.
- */
-static inline bool
-group_smaller_max_cpu_capacity(struct sched_group *sg, struct sched_group *ref)
-{
-	return fits_capacity(sg->sgc->max_capacity, ref->sgc->max_capacity);
-}
-
 static inline enum
 group_type group_classify(unsigned int imbalance_pct,
 			  struct sched_group *group,
@@ -8782,7 +8769,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * internally or be covered by avg_load imbalance (eventually).
 	 */
 	if (sgs->group_type == group_misfit_task &&
-	    (!group_smaller_max_cpu_capacity(sg, sds->local) ||
+	    (!capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
 	     sds->local_stat.group_type != group_has_spare))
 		return false;
 
@@ -8866,7 +8853,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 */
 	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
 	    (sgs->group_type <= group_fully_busy) &&
-	    (group_smaller_min_cpu_capacity(sds->local, sg)))
+	    (capacity_greater(sg->sgc->min_capacity, capacity_of(env->dst_cpu))))
 		return false;
 
 	return true;
@@ -9662,7 +9649,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * average load.
 		 */
 		if (env->sd->flags & SD_ASYM_CPUCAPACITY &&
-		    capacity_of(env->dst_cpu) < capacity &&
+		    !capacity_greater(capacity_of(env->dst_cpu), capacity) &&
 		    nr_running == 1)
 			continue;
 
-- 
2.53.0



