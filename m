Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429311E4B2;
	Wed, 21 Feb 2024 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522274; cv=none; b=X2MihzFeRZiDzo4dJyO9kZH2wORhNAi1pYY2eAlQVaUzSfhcW6KhGwz0qd3Wre9VWXrkDt8gsNa0X6XafaVQlGrWmRt7LYTq1RIU8dD7Sdntax61rUkCrHigKunL+Tdr92lTuJ+GASz2KkThiQOEhcPCmVjQ8SIlFnD6PNMck8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522274; c=relaxed/simple;
	bh=L+cBp99oB6z2XjpGWeWXkOBSrSfxsrxWlpRSG0hhBJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT+o+u2+HWMUKKfGbtYTCmsDVwCSIse9cgQvs6iQKLDmkZ+tu89Ev0gviIC3d1vthiZgqbP3e1OyvTUWMJbA0SviXqv0V1iXAopLY3kipb+oSaf4NRLWhJg3Bty/7eP1w3NQbrLO5ECZiXjVKrb2cIh47QvXeU6fDQdQn1sJ5qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5cjWuJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5cjWuJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2319C433F1;
	Wed, 21 Feb 2024 13:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522274;
	bh=L+cBp99oB6z2XjpGWeWXkOBSrSfxsrxWlpRSG0hhBJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5cjWuJsTGGPMLOuO4alkEpdCScIyzesh+9NsazfKKANEEEp3uCrl5mDQFDHRbJRI
	 qGd0tbKcYHtYXzErS9OsfXyHXLXw9UogXXu8M9z2QkPaaUy4ZMFrikbrAUE6rdiOKH
	 M6RqN/clJM8Si/KgBfO62X75XXfDk1xpFYwZjdKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/476] cpufreq: intel_pstate: Refine computation of P-state for given frequency
Date: Wed, 21 Feb 2024 14:02:46 +0100
Message-ID: <20240221130012.241348067@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 192cdb1c907fd8df2d764c5bb17496e415e59391 ]

On systems using HWP, if a given frequency is equal to the maximum turbo
frequency or the maximum non-turbo frequency, the HWP performance level
corresponding to it is already known and can be used directly without
any computation.

Accordingly, adjust the code to use the known HWP performance levels in
the cases mentioned above.

This also helps to avoid limiting CPU capacity artificially in some
cases when the BIOS produces the HWP_CAP numbers using a different
E-core-to-P-core performance scaling factor than expected by the kernel.

Fixes: f5c8cf2a4992 ("cpufreq: intel_pstate: hybrid: Use known scaling factor for P-cores")
Cc: 6.1+ <stable@vger.kernel.org> # 6.1+
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 55 +++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f2a94afb6eec..dd5f4eee9ffb 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -490,6 +490,30 @@ static inline int intel_pstate_get_cppc_guaranteed(int cpu)
 }
 #endif /* CONFIG_ACPI_CPPC_LIB */
 
+static int intel_pstate_freq_to_hwp_rel(struct cpudata *cpu, int freq,
+					unsigned int relation)
+{
+	if (freq == cpu->pstate.turbo_freq)
+		return cpu->pstate.turbo_pstate;
+
+	if (freq == cpu->pstate.max_freq)
+		return cpu->pstate.max_pstate;
+
+	switch (relation) {
+	case CPUFREQ_RELATION_H:
+		return freq / cpu->pstate.scaling;
+	case CPUFREQ_RELATION_C:
+		return DIV_ROUND_CLOSEST(freq, cpu->pstate.scaling);
+	}
+
+	return DIV_ROUND_UP(freq, cpu->pstate.scaling);
+}
+
+static int intel_pstate_freq_to_hwp(struct cpudata *cpu, int freq)
+{
+	return intel_pstate_freq_to_hwp_rel(cpu, freq, CPUFREQ_RELATION_L);
+}
+
 /**
  * intel_pstate_hybrid_hwp_adjust - Calibrate HWP performance levels.
  * @cpu: Target CPU.
@@ -507,6 +531,7 @@ static void intel_pstate_hybrid_hwp_adjust(struct cpudata *cpu)
 	int perf_ctl_scaling = cpu->pstate.perf_ctl_scaling;
 	int perf_ctl_turbo = pstate_funcs.get_turbo(cpu->cpu);
 	int scaling = cpu->pstate.scaling;
+	int freq;
 
 	pr_debug("CPU%d: perf_ctl_max_phys = %d\n", cpu->cpu, perf_ctl_max_phys);
 	pr_debug("CPU%d: perf_ctl_turbo = %d\n", cpu->cpu, perf_ctl_turbo);
@@ -520,16 +545,16 @@ static void intel_pstate_hybrid_hwp_adjust(struct cpudata *cpu)
 	cpu->pstate.max_freq = rounddown(cpu->pstate.max_pstate * scaling,
 					 perf_ctl_scaling);
 
-	cpu->pstate.max_pstate_physical =
-			DIV_ROUND_UP(perf_ctl_max_phys * perf_ctl_scaling,
-				     scaling);
+	freq = perf_ctl_max_phys * perf_ctl_scaling;
+	cpu->pstate.max_pstate_physical = intel_pstate_freq_to_hwp(cpu, freq);
 
-	cpu->pstate.min_freq = cpu->pstate.min_pstate * perf_ctl_scaling;
+	freq = cpu->pstate.min_pstate * perf_ctl_scaling;
+	cpu->pstate.min_freq = freq;
 	/*
 	 * Cast the min P-state value retrieved via pstate_funcs.get_min() to
 	 * the effective range of HWP performance levels.
 	 */
-	cpu->pstate.min_pstate = DIV_ROUND_UP(cpu->pstate.min_freq, scaling);
+	cpu->pstate.min_pstate = intel_pstate_freq_to_hwp(cpu, freq);
 }
 
 static inline void update_turbo_state(void)
@@ -2333,13 +2358,12 @@ static void intel_pstate_update_perf_limits(struct cpudata *cpu,
 	 * abstract values to represent performance rather than pure ratios.
 	 */
 	if (hwp_active && cpu->pstate.scaling != perf_ctl_scaling) {
-		int scaling = cpu->pstate.scaling;
 		int freq;
 
 		freq = max_policy_perf * perf_ctl_scaling;
-		max_policy_perf = DIV_ROUND_UP(freq, scaling);
+		max_policy_perf = intel_pstate_freq_to_hwp(cpu, freq);
 		freq = min_policy_perf * perf_ctl_scaling;
-		min_policy_perf = DIV_ROUND_UP(freq, scaling);
+		min_policy_perf = intel_pstate_freq_to_hwp(cpu, freq);
 	}
 
 	pr_debug("cpu:%d min_policy_perf:%d max_policy_perf:%d\n",
@@ -2708,18 +2732,7 @@ static int intel_cpufreq_target(struct cpufreq_policy *policy,
 
 	cpufreq_freq_transition_begin(policy, &freqs);
 
-	switch (relation) {
-	case CPUFREQ_RELATION_L:
-		target_pstate = DIV_ROUND_UP(freqs.new, cpu->pstate.scaling);
-		break;
-	case CPUFREQ_RELATION_H:
-		target_pstate = freqs.new / cpu->pstate.scaling;
-		break;
-	default:
-		target_pstate = DIV_ROUND_CLOSEST(freqs.new, cpu->pstate.scaling);
-		break;
-	}
-
+	target_pstate = intel_pstate_freq_to_hwp_rel(cpu, freqs.new, relation);
 	target_pstate = intel_cpufreq_update_pstate(policy, target_pstate, false);
 
 	freqs.new = target_pstate * cpu->pstate.scaling;
@@ -2737,7 +2750,7 @@ static unsigned int intel_cpufreq_fast_switch(struct cpufreq_policy *policy,
 
 	update_turbo_state();
 
-	target_pstate = DIV_ROUND_UP(target_freq, cpu->pstate.scaling);
+	target_pstate = intel_pstate_freq_to_hwp(cpu, target_freq);
 
 	target_pstate = intel_cpufreq_update_pstate(policy, target_pstate, true);
 
-- 
2.43.0



