Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B964232142B;
	Mon, 27 Oct 2025 19:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592818; cv=none; b=K1BKC0BjbXTdwto4NpBMBfEbBFS5WRXfngzRGK8yAzkKRfxDTKLqgZEPBm4ynr+WyU1sCUh8fUfW65iod+xzzZUK1yND8Uho4EKn8cDVxOhYQcBkE3cWf0RtCU18Hmt0IjSsNU7FgWGW4kMn9aiO8l2pRTES6OipuQiNW4/+DKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592818; c=relaxed/simple;
	bh=yMhQDGrkvS57rcHpsvlRmJLeZ6Ttc7f0QSTHR9AnC4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjgaamQFzchKWINLVQ6wygfchWwl5C/3Z18+VTcAMErXf4L6dZiul/qhyVaJ2GFLqBNDuJEq4/qqNoPUNeJ1TEsMC65AVvb4CNBbyzb2c1pi3q65aYrpk0Svih+Ipr3ZKBW4s2AshttIGeasOxo2GBUvUR65G02lr8hSGxzoTdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VngZSRUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VngZSRUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486B9C4CEFD;
	Mon, 27 Oct 2025 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592818;
	bh=yMhQDGrkvS57rcHpsvlRmJLeZ6Ttc7f0QSTHR9AnC4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VngZSRUM27OJUXYQUd84apTyr+/zm7MncxwwiCty6FEAr8DxKcqRBpCRrrQfGwerk
	 H9esJE/vbXqVocn6X5vabdJwdWOqNJT/BPKZZ9wUevuG34tBQKEJ1T0+U0Tm1OJYVd
	 JYpCJ7j0XzyAGGNhz6iyumnVGSj5zM0MHpLFlCbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/117] PM: EM: Move CPU capacity check to em_adjust_new_capacity()
Date: Mon, 27 Oct 2025 19:35:49 +0100
Message-ID: <20251027183454.588654451@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 3e3ba654d3097e0031f2add215b12ff81c23814e ]

Move the check of the CPU capacity currently stored in the energy model
against the arch_scale_cpu_capacity() value to em_adjust_new_capacity()
so it will be done regardless of where the latter is called from.

This will be useful when a new em_adjust_new_capacity() caller is added
subsequently.

While at it, move the pd local variable declaration in
em_check_capacity_update() into the loop in which it is used.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://patch.msgid.link/7810787.EvYhyI6sBW@rjwysocki.net
Stable-dep-of: 1ebe8f7e7825 ("PM: EM: Fix late boot with holes in CPU topology")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/energy_model.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -722,10 +722,24 @@ free_em_table:
  * Adjustment of CPU performance values after boot, when all CPUs capacites
  * are correctly calculated.
  */
-static void em_adjust_new_capacity(struct device *dev,
+static void em_adjust_new_capacity(unsigned int cpu, struct device *dev,
 				   struct em_perf_domain *pd)
 {
+	unsigned long cpu_capacity = arch_scale_cpu_capacity(cpu);
 	struct em_perf_table *em_table;
+	struct em_perf_state *table;
+	unsigned long em_max_perf;
+
+	rcu_read_lock();
+	table = em_perf_state_from_pd(pd);
+	em_max_perf = table[pd->nr_perf_states - 1].performance;
+	rcu_read_unlock();
+
+	if (em_max_perf == cpu_capacity)
+		return;
+
+	pr_debug("updating cpu%d cpu_cap=%lu old capacity=%lu\n", cpu,
+		 cpu_capacity, em_max_perf);
 
 	em_table = em_table_dup(pd);
 	if (!em_table) {
@@ -741,9 +755,6 @@ static void em_adjust_new_capacity(struc
 static void em_check_capacity_update(void)
 {
 	cpumask_var_t cpu_done_mask;
-	struct em_perf_state *table;
-	struct em_perf_domain *pd;
-	unsigned long cpu_capacity;
 	int cpu;
 
 	if (!zalloc_cpumask_var(&cpu_done_mask, GFP_KERNEL)) {
@@ -754,7 +765,7 @@ static void em_check_capacity_update(voi
 	/* Check if CPUs capacity has changed than update EM */
 	for_each_possible_cpu(cpu) {
 		struct cpufreq_policy *policy;
-		unsigned long em_max_perf;
+		struct em_perf_domain *pd;
 		struct device *dev;
 
 		if (cpumask_test_cpu(cpu, cpu_done_mask))
@@ -777,24 +788,7 @@ static void em_check_capacity_update(voi
 		cpumask_or(cpu_done_mask, cpu_done_mask,
 			   em_span_cpus(pd));
 
-		cpu_capacity = arch_scale_cpu_capacity(cpu);
-
-		rcu_read_lock();
-		table = em_perf_state_from_pd(pd);
-		em_max_perf = table[pd->nr_perf_states - 1].performance;
-		rcu_read_unlock();
-
-		/*
-		 * Check if the CPU capacity has been adjusted during boot
-		 * and trigger the update for new performance values.
-		 */
-		if (em_max_perf == cpu_capacity)
-			continue;
-
-		pr_debug("updating cpu%d cpu_cap=%lu old capacity=%lu\n",
-			 cpu, cpu_capacity, em_max_perf);
-
-		em_adjust_new_capacity(dev, pd);
+		em_adjust_new_capacity(cpu, dev, pd);
 	}
 
 	free_cpumask_var(cpu_done_mask);


