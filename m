Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8A1347512;
	Wed, 20 May 2026 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297432; cv=none; b=RgkZhQjZ2PP/g7e0bcKxl+NSj/RIF6YM2RnxWsgpTJheR3lIDD/ew34wgXVKikUaW1OlAxWHCh2zihfWK6dhpeyl9uZCp9CcMaH7qjxKnRF63L2vbdvW3H7CqO0dGPB9xLWh5dVlcf55wvrBamGg3VJLRWMW6NAHwWGFekiej+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297432; c=relaxed/simple;
	bh=OHznrRx34dRilSOhAOVguclhopLK1/woU5KAltDw7wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiAwySQNI7WeTTTy2nLuktP8OxVrZbQc9AqubcuqIALEir9xN8XGKyNOR03pqPs6ELOK2QeZCr3LshPKTKmYCdWHJafc6xTD8kAm5mrhfxhKq4I67jwuMIk5gEzmx1k/j3vRJPHMBpTyLI2YqCsEUJ2rKCn1XP8n79DCpxDrbXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEBWu/j8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEBWu/j8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E131F000E9;
	Wed, 20 May 2026 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297431;
	bh=ZI9m1jmFICwZktrTvO5wzh63tXzckeRAIwASUQq8vno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEBWu/j8I5yZ6NSSC5onDlQ53uoMAhobmZyfP8pKua/CW7gZAsxbt0nHXJK4/m9HN
	 juzi+1jk8jUIz3rAq7dHTcPu85x2E7ag89WGRQDoLDIppE3JEgqaqOeIatvRbSCKY+
	 OfEIbECWT5rPV51NLp4Sqv4RoV16hZ8CDwuAy1KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 6.18 029/957] cpufreq: Pass the policy to cpufreq_driver->adjust_perf()
Date: Wed, 20 May 2026 18:08:32 +0200
Message-ID: <20260520162135.191380306@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit c03791085adcd61fa9b766ab303c7d0941d7378d ]

cpufreq_cpu_get() can sleep on PREEMPT_RT in presence of concurrent
writer(s), however amd-pstate depends on fetching the cpudata via the
policy's driver data which necessitates grabbing the reference.

Since schedutil governor can call "cpufreq_driver->update_perf()"
during sched_tick/enqueue/dequeue with rq_lock held and IRQs disabled,
fetching the policy object using the cpufreq_cpu_get() helper in the
scheduler fast-path leads to "BUG: scheduling while atomic" on
PREEMPT_RT [1].

Pass the cached cpufreq policy object in sg_policy to the update_perf()
instead of just the CPU. The CPU can be inferred using "policy->cpu".

The lifetime of cpufreq_policy object outlasts that of the governor and
the cpufreq driver (allocated when the CPU is onlined and only reclaimed
when the CPU is offlined / the CPU device is removed) which makes it
safe to be referenced throughout the governor's lifetime.

Closes:https://lore.kernel.org/all/20250731092316.3191-1-spasswolf@web.de/ [1]

Fixes: 1d215f0319c2 ("cpufreq: amd-pstate: Add fast switch function for AMD P-State")
Reported-by: Bert Karwatzki <spasswolf@web.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Acked-by: Gary Guo <gary@garyguo.net> # Rust
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260316081849.19368-3-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c     |  3 +--
 drivers/cpufreq/cpufreq.c        |  6 +++---
 drivers/cpufreq/intel_pstate.c   |  4 ++--
 include/linux/cpufreq.h          |  4 ++--
 kernel/sched/cpufreq_schedutil.c |  5 +++--
 rust/kernel/cpufreq.rs           | 13 ++++++-------
 6 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 39681ad1606f6..ce6d6b3ff58a3 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -697,13 +697,12 @@ static unsigned int amd_pstate_fast_switch(struct cpufreq_policy *policy,
 	return policy->cur;
 }
 
-static void amd_pstate_adjust_perf(unsigned int cpu,
+static void amd_pstate_adjust_perf(struct cpufreq_policy *policy,
 				   unsigned long _min_perf,
 				   unsigned long target_perf,
 				   unsigned long capacity)
 {
 	u8 max_perf, min_perf, des_perf, cap_perf;
-	struct cpufreq_policy *policy __free(put_cpufreq_policy) = cpufreq_cpu_get(cpu);
 	struct amd_cpudata *cpudata;
 	union perf_cached perf;
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 852e024facc3c..1ed528e34bab4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2222,7 +2222,7 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_fast_switch);
 
 /**
  * cpufreq_driver_adjust_perf - Adjust CPU performance level in one go.
- * @cpu: Target CPU.
+ * @policy: cpufreq policy object of the target CPU.
  * @min_perf: Minimum (required) performance level (units of @capacity).
  * @target_perf: Target (desired) performance level (units of @capacity).
  * @capacity: Capacity of the target CPU.
@@ -2241,12 +2241,12 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_fast_switch);
  * parallel with either ->target() or ->target_index() or ->fast_switch() for
  * the same CPU.
  */
-void cpufreq_driver_adjust_perf(unsigned int cpu,
+void cpufreq_driver_adjust_perf(struct cpufreq_policy *policy,
 				 unsigned long min_perf,
 				 unsigned long target_perf,
 				 unsigned long capacity)
 {
-	cpufreq_driver->adjust_perf(cpu, min_perf, target_perf, capacity);
+	cpufreq_driver->adjust_perf(policy, min_perf, target_perf, capacity);
 }
 
 /**
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 5efda8af4b708..eb7fb25dfbefc 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3270,12 +3270,12 @@ static unsigned int intel_cpufreq_fast_switch(struct cpufreq_policy *policy,
 	return target_pstate * cpu->pstate.scaling;
 }
 
-static void intel_cpufreq_adjust_perf(unsigned int cpunum,
+static void intel_cpufreq_adjust_perf(struct cpufreq_policy *policy,
 				      unsigned long min_perf,
 				      unsigned long target_perf,
 				      unsigned long capacity)
 {
-	struct cpudata *cpu = all_cpu_data[cpunum];
+	struct cpudata *cpu = all_cpu_data[policy->cpu];
 	u64 hwp_cap = READ_ONCE(cpu->hwp_cap_cached);
 	int old_pstate = cpu->pstate.current_pstate;
 	int cap_pstate, min_pstate, max_pstate, target_pstate;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 0465d1e6f72ac..fd26b3a4aa286 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -367,7 +367,7 @@ struct cpufreq_driver {
 	 * conditions) scale invariance can be disabled, which causes the
 	 * schedutil governor to fall back to the latter.
 	 */
-	void		(*adjust_perf)(unsigned int cpu,
+	void		(*adjust_perf)(struct cpufreq_policy *policy,
 				       unsigned long min_perf,
 				       unsigned long target_perf,
 				       unsigned long capacity);
@@ -612,7 +612,7 @@ struct cpufreq_governor {
 /* Pass a target to the cpufreq driver */
 unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
 					unsigned int target_freq);
-void cpufreq_driver_adjust_perf(unsigned int cpu,
+void cpufreq_driver_adjust_perf(struct cpufreq_policy *policy,
 				unsigned long min_perf,
 				unsigned long target_perf,
 				unsigned long capacity);
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 0ab5f9d4bc59a..307f3076635eb 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -461,6 +461,7 @@ static void sugov_update_single_perf(struct update_util_data *hook, u64 time,
 				     unsigned int flags)
 {
 	struct sugov_cpu *sg_cpu = container_of(hook, struct sugov_cpu, update_util);
+	struct sugov_policy *sg_policy = sg_cpu->sg_policy;
 	unsigned long prev_util = sg_cpu->util;
 	unsigned long max_cap;
 
@@ -482,10 +483,10 @@ static void sugov_update_single_perf(struct update_util_data *hook, u64 time,
 	if (sugov_hold_freq(sg_cpu) && sg_cpu->util < prev_util)
 		sg_cpu->util = prev_util;
 
-	cpufreq_driver_adjust_perf(sg_cpu->cpu, sg_cpu->bw_min,
+	cpufreq_driver_adjust_perf(sg_policy->policy, sg_cpu->bw_min,
 				   sg_cpu->util, max_cap);
 
-	sg_cpu->sg_policy->last_freq_update_time = time;
+	sg_policy->last_freq_update_time = time;
 }
 
 static unsigned int sugov_next_freq_shared(struct sugov_cpu *sg_cpu, u64 time)
diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
index df5d9f6f43f3b..19729ccb3f6d2 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -1257,18 +1257,17 @@ impl<T: Driver> Registration<T> {
     /// # Safety
     ///
     /// - This function may only be called from the cpufreq C infrastructure.
+    /// - The pointer arguments must be valid pointers.
     unsafe extern "C" fn adjust_perf_callback(
-        cpu: c_uint,
+        ptr: *mut bindings::cpufreq_policy,
         min_perf: c_ulong,
         target_perf: c_ulong,
         capacity: c_ulong,
     ) {
-        // SAFETY: The C API guarantees that `cpu` refers to a valid CPU number.
-        let cpu_id = unsafe { CpuId::from_u32_unchecked(cpu) };
-
-        if let Ok(mut policy) = PolicyCpu::from_cpu(cpu_id) {
-            T::adjust_perf(&mut policy, min_perf, target_perf, capacity);
-        }
+        // SAFETY: The `ptr` is guaranteed to be valid by the contract with the C code for the
+        // lifetime of `policy`.
+        let policy = unsafe { Policy::from_raw_mut(ptr) };
+        T::adjust_perf(policy, min_perf, target_perf, capacity);
     }
 
     /// Driver's `get_intermediate` callback.
-- 
2.53.0



