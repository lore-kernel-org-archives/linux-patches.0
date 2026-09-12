Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A954630D3F6;
	Sat, 12 Sep 2026 14:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223524; cv=none; b=A9qR+KcQX9m4dN1UTTcDH0ASVUQAc7JXkU7SQhJ01SVbT4AOQC4rekw6UbIAHRElCrMqd/SptsUs48BmuW7AOGMS5luSy5cBTo1+9jFmRfWT0upnn5ANhvTcYWqfBSIzyWIsQhhuIUYLk89ACNL937HbhgM8tErSyoXB4FuoHkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223524; c=relaxed/simple;
	bh=Lz60YwFUfHjgxs7ccHyKqT/BioK4TuSusqaPq2+qNbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJr7Jm6bYkn8dg5yVAJGd64Vg5TEg8HiEyjKkQlHZABwT+4aqdRdQjv1E5wVaWfZ9vqQh5uXQQM+o7W3NMOsVbzrIwPB+jysibnVJBBIKPABvSoYZG2aX6BYrVejIBCM5qoWRWY8yadTIyx2VrGx7QRt2pMPWmtPDc0bpRE4sjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sElyJCXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sElyJCXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6399C1F000FF;
	Sat, 12 Sep 2026 14:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223522;
	bh=PWRkV7rmIgGq3xF7u3Y3eYk1Sn3rph5LrPfS75fh1uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sElyJCXx5431xs1UUjsM3xaQCijnuhn8fRDAyZuM/tlvPuF2NCbUJjBZxkmwV71OP
	 o5fE1ex94PHJjTbXpYymnbsoayoyTAvKwGaFLylNBKNhxMBo2z3QI9gLEp/TrXmIei
	 XLM3lXGaNRBJICP+tEA1KH712LnOiZlrzqfAs/WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0770/1424] cpufreq: intel_pstate: Fix setting minimum P-state at init time
Date: Sat, 12 Sep 2026 08:53:22 +0200
Message-ID: <20260912065624.540306561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit db53c573d31d07d5d782c5312d37cb33be788eba ]

If HWP is enabled, writes to MSR_IA32_PERF_CTL have no effect,
so intel_pstate_get_cpu_pstates() should not attempt to call
intel_pstate_set_min_pstate() to set the minimum P-state for the
given CPU in that case.

Accordingly, remove the intel_pstate_set_min_pstate()
call from intel_pstate_get_cpu_pstates() and make both
intel_pstate_cpu_init() and intel_cpufreq_cpu_init() call
that function in their non-HWP code paths.

The HWP code path in intel_pstate_cpu_init() does not need to update
the current P-state of the CPU directly at all because it is taken
care of the processor automatically, but the HWP code path of
intel_cpufreq_cpu_init() should update it in principle to
initialize the DESIRED_PERF field in MSR_HWP_REQUEST.  For this
purpose, make it call intel_cpufreq_hwp_update() and pass
the minimum P-state limit to it as the current target value along
with the current minimum and maximum limits.

Fixes: f6ebbcf08f37 ("cpufreq: intel_pstate: Implement passive mode with HWP enabled")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5090465.GXAFRqVoOG@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 048e2579e4fcf..df865612158ab 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2047,8 +2047,6 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 
 	if (pstate_funcs.get_vid)
 		pstate_funcs.get_vid(cpu);
-
-	intel_pstate_set_min_pstate(cpu);
 }
 
 /*
@@ -2746,6 +2744,7 @@ static int __intel_pstate_cpu_init(struct cpufreq_policy *policy)
 static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	int ret = __intel_pstate_cpu_init(policy);
+	struct cpudata *cpu;
 
 	if (ret)
 		return ret;
@@ -2756,11 +2755,11 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 	 */
 	policy->policy = CPUFREQ_POLICY_POWERSAVE;
 
-	if (hwp_active) {
-		struct cpudata *cpu = all_cpu_data[policy->cpu];
-
+	cpu = all_cpu_data[policy->cpu];
+	if (hwp_active)
 		cpu->epp_cached = intel_pstate_get_epp(cpu, 0);
-	}
+	else
+		intel_pstate_set_min_pstate(cpu);
 
 	return 0;
 }
@@ -2983,8 +2982,6 @@ static int intel_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 
 	policy->cpuinfo.transition_latency = INTEL_CPUFREQ_TRANSITION_LATENCY;
-	/* This reflects the intel_pstate_get_cpu_pstates() setting. */
-	policy->cur = policy->cpuinfo.min_freq;
 
 	req = kcalloc(2, sizeof(*req), GFP_KERNEL);
 	if (!req) {
@@ -3005,9 +3002,15 @@ static int intel_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		WRITE_ONCE(cpu->hwp_req_cached, value);
 
 		cpu->epp_cached = intel_pstate_get_epp(cpu, value);
+
+		intel_cpufreq_hwp_update(cpu, cpu->pstate.min_pstate,
+					 cpu->pstate.max_pstate,
+					 cpu->pstate.min_pstate, false);
 	} else {
 		policy->transition_delay_us = INTEL_CPUFREQ_TRANSITION_DELAY;
+		intel_pstate_set_min_pstate(cpu);
 	}
+	policy->cur = policy->cpuinfo.min_freq;
 
 	freq = DIV_ROUND_UP(cpu->pstate.turbo_freq * global.min_perf_pct, 100);
 
-- 
2.53.0



