Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AFC41A88
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7iMP4KO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD33EC433C7;
	Wed, 15 Nov 2023 19:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076731;
	bh=1mj3vO6WB7Um1cDrTczpH7thkvYVu28x1xY3649GXVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7iMP4KOP1Mh/K5noDEgwP/SL6MaCg0xEYj3UppZFXBDuxITDYE3ESo+ayJLvx+2L
	 TwYBmxg/Y0tLufN8MXuByKZju2vg3i3nowOOtfUYeswr5IZLwA9rntGFHPFcWOgXaN
	 NQJtZkqPiqEq7EK+lU59EkQhkXe5U6g70Q7RL7No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Qais Yousef (Google)" <qyousef@layalina.io>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/603] sched/uclamp: Set max_spare_cap_cpu even if max_spare_cap is 0
Date: Wed, 15 Nov 2023 14:09:12 -0500
Message-ID: <20231115191613.641119948@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qais Yousef <qyousef@layalina.io>

[ Upstream commit 6b00a40147653c8ea748e8f4396510f252763364 ]

When uclamp_max is being used, the util of the task could be higher than
the spare capacity of the CPU, but due to uclamp_max value we force-fit
it there.

The way the condition for checking for max_spare_cap in
find_energy_efficient_cpu() was constructed; it ignored any CPU that has
its spare_cap less than or _equal_ to max_spare_cap. Since we initialize
max_spare_cap to 0; this lead to never setting max_spare_cap_cpu and
hence ending up never performing compute_energy() for this cluster and
missing an opportunity for a better energy efficient placement to honour
uclamp_max setting.

	max_spare_cap = 0;
	cpu_cap = capacity_of(cpu) - cpu_util(p);  // 0 if cpu_util(p) is high

	...

	util_fits_cpu(...);		// will return true if uclamp_max forces it to fit

	...

	// this logic will fail to update max_spare_cap_cpu if cpu_cap is 0
	if (cpu_cap > max_spare_cap) {
		max_spare_cap = cpu_cap;
		max_spare_cap_cpu = cpu;
	}

prev_spare_cap suffers from a similar problem.

Fix the logic by converting the variables into long and treating -1
value as 'not populated' instead of 0 which is a viable and correct
spare capacity value. We need to be careful signed comparison is used
when comparing with cpu_cap in one of the conditions.

Fixes: 1d42509e475c ("sched/fair: Make EAS wakeup placement consider uclamp restrictions")
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230916232955.2099394-2-qyousef@layalina.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6af1d48d467ed..a60b5d0edd039 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7764,11 +7764,10 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 	for (; pd; pd = pd->next) {
 		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cpu_cap, cpu_thermal_cap, util;
-		unsigned long cur_delta, max_spare_cap = 0;
+		long prev_spare_cap = -1, max_spare_cap = -1;
 		unsigned long rq_util_min, rq_util_max;
-		unsigned long prev_spare_cap = 0;
+		unsigned long cur_delta, base_energy;
 		int max_spare_cap_cpu = -1;
-		unsigned long base_energy;
 		int fits, max_fits = -1;
 
 		cpumask_and(cpus, perf_domain_span(pd), cpu_online_mask);
@@ -7831,7 +7830,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 				prev_spare_cap = cpu_cap;
 				prev_fits = fits;
 			} else if ((fits > max_fits) ||
-				   ((fits == max_fits) && (cpu_cap > max_spare_cap))) {
+				   ((fits == max_fits) && ((long)cpu_cap > max_spare_cap))) {
 				/*
 				 * Find the CPU with the maximum spare capacity
 				 * among the remaining CPUs in the performance
@@ -7843,7 +7842,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			}
 		}
 
-		if (max_spare_cap_cpu < 0 && prev_spare_cap == 0)
+		if (max_spare_cap_cpu < 0 && prev_spare_cap < 0)
 			continue;
 
 		eenv_pd_busy_time(&eenv, cpus, p);
@@ -7851,7 +7850,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		base_energy = compute_energy(&eenv, pd, cpus, p, -1);
 
 		/* Evaluate the energy impact of using prev_cpu. */
-		if (prev_spare_cap > 0) {
+		if (prev_spare_cap > -1) {
 			prev_delta = compute_energy(&eenv, pd, cpus, p,
 						    prev_cpu);
 			/* CPU utilization has changed */
-- 
2.42.0



