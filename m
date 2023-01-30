Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EC528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2D5C433D2;
	Mon, 30 Jan 2023 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087514;
	bh=DtPozjq3otwUFtiMwPh58GGZVMOrQ5hpDU2WH9qPGW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5Pu9RCacq0qlAsnPrGN1omAYZVCq/3Cg/3/23o4A90ofuxICoL3qHfn1aD0xOONr
	 aWr4qQOVfgFeTa7K4oq/uO9atpOM06+qglk+lqNDqwIAPnOMr9pc0wU4LPY0+K3gG4
	 1Lfono+FxCqWrFwPWFetEWvE42zDqQ5wtweUHQzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/313] sched/fair: Check if prev_cpu has highest spare cap in feec()
Date: Mon, 30 Jan 2023 14:50:39 +0100
Message-Id: <20230130134346.204278839@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit ad841e569f5c88e3332b32a000f251f33ff32187 ]

When evaluating the CPU candidates in the perf domain (pd) containing
the previously used CPU (prev_cpu), find_energy_efficient_cpu()
evaluates the energy of the pd:
- without the task (base_energy)
- with the task placed on prev_cpu (if the task fits)
- with the task placed on the CPU with the highest spare capacity,
  prev_cpu being excluded from this set

If prev_cpu is already the CPU with the highest spare capacity,
max_spare_cap_cpu will be the CPU with the second highest spare
capacity.

On an Arm64 Juno-r2, with a workload of 10 tasks at a 10% duty cycle,
when prev_cpu and max_spare_cap_cpu are both valid candidates,
prev_spare_cap > max_spare_cap at ~82%.
Thus the energy of the pd when placing the task on max_spare_cap_cpu
is computed with no possible positive outcome 82% most of the time.

Do not consider max_spare_cap_cpu as a valid candidate if
prev_spare_cap > max_spare_cap.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20221006081052.3862167-2-pierre.gondois@arm.com
Stable-dep-of: e26fd28db828 ("sched/uclamp: Fix a uninitialized variable warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0f32acb05055..bb04ca795fc3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7217,7 +7217,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		unsigned long cur_delta, max_spare_cap = 0;
 		unsigned long rq_util_min, rq_util_max;
 		unsigned long util_min, util_max;
-		bool compute_prev_delta = false;
+		unsigned long prev_spare_cap = 0;
 		int max_spare_cap_cpu = -1;
 		unsigned long base_energy;
 
@@ -7279,18 +7279,19 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 
 			if (cpu == prev_cpu) {
 				/* Always use prev_cpu as a candidate. */
-				compute_prev_delta = true;
+				prev_spare_cap = cpu_cap;
 			} else if (cpu_cap > max_spare_cap) {
 				/*
 				 * Find the CPU with the maximum spare capacity
-				 * in the performance domain.
+				 * among the remaining CPUs in the performance
+				 * domain.
 				 */
 				max_spare_cap = cpu_cap;
 				max_spare_cap_cpu = cpu;
 			}
 		}
 
-		if (max_spare_cap_cpu < 0 && !compute_prev_delta)
+		if (max_spare_cap_cpu < 0 && prev_spare_cap == 0)
 			continue;
 
 		eenv_pd_busy_time(&eenv, cpus, p);
@@ -7298,7 +7299,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		base_energy = compute_energy(&eenv, pd, cpus, p, -1);
 
 		/* Evaluate the energy impact of using prev_cpu. */
-		if (compute_prev_delta) {
+		if (prev_spare_cap > 0) {
 			prev_delta = compute_energy(&eenv, pd, cpus, p,
 						    prev_cpu);
 			/* CPU utilization has changed */
@@ -7309,7 +7310,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		}
 
 		/* Evaluate the energy impact of using max_spare_cap_cpu. */
-		if (max_spare_cap_cpu >= 0) {
+		if (max_spare_cap_cpu >= 0 && max_spare_cap > prev_spare_cap) {
 			cur_delta = compute_energy(&eenv, pd, cpus, p,
 						   max_spare_cap_cpu);
 			/* CPU utilization has changed */
-- 
2.39.0



