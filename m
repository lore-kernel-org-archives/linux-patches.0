Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61174248DB;
	Sat, 12 Sep 2026 10:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207406; cv=none; b=usNda2VjjjIewlkC7cumy0pntcoWiEvmuinQF3PABvepyAN9a8xf+6nVj9NRoZnX26jRjyUql4kZww29MX51PUjjK52dfE3XdBxKibHeo6QthPub/TiaRg+1i2qsjrUJuOd96dGi9d1IZe4t9MuoG1xeefhZxTIiVz6Hdo6oFNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207406; c=relaxed/simple;
	bh=RvMOP8swL0Yv23Xel4ORg64xK7hmyLOqH9cOcENypng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfM7BwTNeSKNMHERZsb+7wADPRY4XchIOv+eKkdkb03onmCWRMc6b00AixiffQYdELWtjKvXVpap64eByG2As0viVBDYZ0SeLG/te1XLToASiq4aHinhsdMIe/hmW51nQ8uYdPkL4K+NUVjhzajkJDY7i/bM4drJUxr3s3EbTA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/OVecvq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/OVecvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0F41F00898;
	Sat, 12 Sep 2026 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207404;
	bh=gtYT5b/oyL2ZBO80+32oej3YCx8dAGPngsIgxbCM2KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/OVecvq/my9eKpcRzi3tDvgP/CR1sANkhBqYiUqN5+qzJTWiOOyBxnV/4RybqnqK
	 81UK/td1X2sgeZZ+vjifEzBvBMUCnyOOE1d6v5m3eFONwgEIRXBPkjbbQKN+8n9sdn
	 mY8vHmpU7VWfg76JQZZmKbGzzCgeIHWW95rBj3+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0405/1518] cpufreq: intel_pstate: Fix setting minimum P-state at init time
Date: Sat, 12 Sep 2026 08:42:54 +0200
Message-ID: <20260912065632.619165322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e6d6a30cf6c90..1de12358c0b98 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2389,8 +2389,6 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 
 	if (pstate_funcs.get_vid)
 		pstate_funcs.get_vid(cpu);
-
-	intel_pstate_set_min_pstate(cpu);
 }
 
 /*
@@ -3098,6 +3096,7 @@ static int __intel_pstate_cpu_init(struct cpufreq_policy *policy)
 static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	int ret = __intel_pstate_cpu_init(policy);
+	struct cpudata *cpu;
 
 	if (ret)
 		return ret;
@@ -3108,11 +3107,11 @@ static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
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
@@ -3336,8 +3335,6 @@ static int intel_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 
 	policy->cpuinfo.transition_latency = INTEL_CPUFREQ_TRANSITION_LATENCY;
-	/* This reflects the intel_pstate_get_cpu_pstates() setting. */
-	policy->cur = policy->cpuinfo.min_freq;
 
 	req = kcalloc(2, sizeof(*req), GFP_KERNEL);
 	if (!req) {
@@ -3358,9 +3355,15 @@ static int intel_cpufreq_cpu_init(struct cpufreq_policy *policy)
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



