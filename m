Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF2189BB0;
	Sun,  7 Sep 2025 20:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276673; cv=none; b=j0c65sZq+0fVlO7QlUzKCfqi5wAeenL/B6K2mAwxbFbg0HlTD2ice7vS/xNju68uv20yzN6rKjBGDpDVV+RF2EMK3cH/cr+H9U/QVu6z7UL/ZXxGqZrDkjXewxVUZSWwwB9FNJ/ZyZX1xY41z59ojCMwnoa81yvOPcLQmO+CvHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276673; c=relaxed/simple;
	bh=dPdvJCqXo2ARy2oBf52D8JhLYa469NUG0NK8R71zCfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9p1ovRZGEjahs/NA62kMzaH3HQ8SmxChhXevDnJ1xWmq7g8DfJuaENA3B9Y2uEWIhWELE66SbGxb+3N3U52GDVwD5Xl8RkQ7mgTZqXPzyHY61FsYQps7dVun0J5RPhm8k7WTXj7hFovsBsBsrnD9RVPbY5EbCdoGLMK4hmlYt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdpH/DJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdpH/DJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CDDC4CEF0;
	Sun,  7 Sep 2025 20:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276673;
	bh=dPdvJCqXo2ARy2oBf52D8JhLYa469NUG0NK8R71zCfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdpH/DJLZA0cCFRQFQnUyu+BvB9ZgzUEjIfdD/NAU2WAGPQBnqyISqFS8/jBJrvhf
	 GliSeEchinaZoEW9c2XWmzVa8s8a2XWwJ4HnIprunk/AhFEs0F+Nmi52TRpMHVFW0l
	 IOFK2XTumlAVPdDjNxO28zdWfo4sUwQjmZVUDj70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/121] cpufreq: intel_pstate: Do not update global.turbo_disabled after initialization
Date: Sun,  7 Sep 2025 21:58:30 +0200
Message-ID: <20250907195611.734373565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 0940f1a8011fd69be5082015068e0dc31c800c20 ]

The global.turbo_disabled is updated quite often, especially in the
passive mode in which case it is updated every time the scheduler calls
into the driver.  However, this is generally not necessary and it adds
MSR read overhead to scheduler code paths (and that particular MSR is
slow to read).

For this reason, make the driver read MSR_IA32_MISC_ENABLE_TURBO_DISABLE
just once at the cpufreq driver registration time and remove all of the
in-flight updates of global.turbo_disabled.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Stable-dep-of: ac4e04d9e378 ("cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   51 ++++++-----------------------------------
 1 file changed, 8 insertions(+), 43 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -172,7 +172,6 @@ struct vid_data {
  *			based on the MSR_IA32_MISC_ENABLE value and whether or
  *			not the maximum reported turbo P-state is different from
  *			the maximum reported non-turbo one.
- * @turbo_disabled_mf:	The @turbo_disabled value reflected by cpuinfo.max_freq.
  * @min_perf_pct:	Minimum capacity limit in percent of the maximum turbo
  *			P-state capacity.
  * @max_perf_pct:	Maximum capacity limit in percent of the maximum turbo
@@ -181,7 +180,6 @@ struct vid_data {
 struct global_params {
 	bool no_turbo;
 	bool turbo_disabled;
-	bool turbo_disabled_mf;
 	int max_perf_pct;
 	int min_perf_pct;
 };
@@ -592,12 +590,13 @@ static void intel_pstate_hybrid_hwp_adju
 	cpu->pstate.min_pstate = intel_pstate_freq_to_hwp(cpu, freq);
 }
 
-static inline void update_turbo_state(void)
+static bool turbo_is_disabled(void)
 {
 	u64 misc_en;
 
 	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
-	global.turbo_disabled = misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
+
+	return !!(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);
 }
 
 static int min_perf_pct_min(void)
@@ -1152,40 +1151,16 @@ static void intel_pstate_update_policies
 static void __intel_pstate_update_max_freq(struct cpudata *cpudata,
 					   struct cpufreq_policy *policy)
 {
-	policy->cpuinfo.max_freq = global.turbo_disabled_mf ?
+	policy->cpuinfo.max_freq = global.turbo_disabled ?
 			cpudata->pstate.max_freq : cpudata->pstate.turbo_freq;
 	refresh_frequency_limits(policy);
 }
 
-static void intel_pstate_update_max_freq(unsigned int cpu)
-{
-	struct cpufreq_policy *policy = cpufreq_cpu_acquire(cpu);
-
-	if (!policy)
-		return;
-
-	__intel_pstate_update_max_freq(all_cpu_data[cpu], policy);
-
-	cpufreq_cpu_release(policy);
-}
-
 static void intel_pstate_update_limits(unsigned int cpu)
 {
 	mutex_lock(&intel_pstate_driver_lock);
 
-	update_turbo_state();
-	/*
-	 * If turbo has been turned on or off globally, policy limits for
-	 * all CPUs need to be updated to reflect that.
-	 */
-	if (global.turbo_disabled_mf != global.turbo_disabled) {
-		global.turbo_disabled_mf = global.turbo_disabled;
-		arch_set_max_freq_ratio(global.turbo_disabled);
-		for_each_possible_cpu(cpu)
-			intel_pstate_update_max_freq(cpu);
-	} else {
-		cpufreq_update_policy(cpu);
-	}
+	cpufreq_update_policy(cpu);
 
 	mutex_unlock(&intel_pstate_driver_lock);
 }
@@ -1285,7 +1260,6 @@ static ssize_t show_no_turbo(struct kobj
 		return -EAGAIN;
 	}
 
-	update_turbo_state();
 	if (global.turbo_disabled)
 		ret = sprintf(buf, "%u\n", global.turbo_disabled);
 	else
@@ -1315,7 +1289,6 @@ static ssize_t store_no_turbo(struct kob
 
 	mutex_lock(&intel_pstate_limits_lock);
 
-	update_turbo_state();
 	if (global.turbo_disabled) {
 		pr_notice_once("Turbo disabled by BIOS or unavailable on processor\n");
 		mutex_unlock(&intel_pstate_limits_lock);
@@ -2296,8 +2269,6 @@ static void intel_pstate_adjust_pstate(s
 	struct sample *sample;
 	int target_pstate;
 
-	update_turbo_state();
-
 	target_pstate = get_target_pstate(cpu);
 	target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
 	trace_cpu_frequency(target_pstate * cpu->pstate.scaling, cpu->cpu);
@@ -2607,7 +2578,6 @@ static int intel_pstate_set_policy(struc
 		 * be invoked on them.
 		 */
 		intel_pstate_clear_update_util_hook(policy->cpu);
-		update_turbo_state();
 		intel_pstate_set_pstate(cpu, pstate);
 	} else {
 		intel_pstate_set_update_util_hook(policy->cpu);
@@ -2651,7 +2621,6 @@ static void intel_pstate_verify_cpu_poli
 {
 	int max_freq;
 
-	update_turbo_state();
 	if (hwp_active) {
 		intel_pstate_get_hwp_cap(cpu);
 		max_freq = global.no_turbo || global.turbo_disabled ?
@@ -2748,8 +2717,6 @@ static int __intel_pstate_cpu_init(struc
 
 	/* cpuinfo and default policy values */
 	policy->cpuinfo.min_freq = cpu->pstate.min_freq;
-	update_turbo_state();
-	global.turbo_disabled_mf = global.turbo_disabled;
 	policy->cpuinfo.max_freq = global.turbo_disabled ?
 			cpu->pstate.max_freq : cpu->pstate.turbo_freq;
 
@@ -2915,8 +2882,6 @@ static int intel_cpufreq_target(struct c
 	struct cpufreq_freqs freqs;
 	int target_pstate;
 
-	update_turbo_state();
-
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
 
@@ -2938,8 +2903,6 @@ static unsigned int intel_cpufreq_fast_s
 	struct cpudata *cpu = all_cpu_data[policy->cpu];
 	int target_pstate;
 
-	update_turbo_state();
-
 	target_pstate = intel_pstate_freq_to_hwp(cpu, target_freq);
 
 	target_pstate = intel_cpufreq_update_pstate(policy, target_pstate, true);
@@ -2957,7 +2920,6 @@ static void intel_cpufreq_adjust_perf(un
 	int old_pstate = cpu->pstate.current_pstate;
 	int cap_pstate, min_pstate, max_pstate, target_pstate;
 
-	update_turbo_state();
 	cap_pstate = global.turbo_disabled ? HWP_GUARANTEED_PERF(hwp_cap) :
 					     HWP_HIGHEST_PERF(hwp_cap);
 
@@ -3147,6 +3109,9 @@ static int intel_pstate_register_driver(
 
 	memset(&global, 0, sizeof(global));
 	global.max_perf_pct = 100;
+	global.turbo_disabled = turbo_is_disabled();
+
+	arch_set_max_freq_ratio(global.turbo_disabled);
 
 	intel_pstate_driver = driver;
 	ret = cpufreq_register_driver(intel_pstate_driver);


