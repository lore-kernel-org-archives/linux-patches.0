Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCAA28980D;
	Wed,  7 May 2025 19:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644905; cv=none; b=HkEsNiTApcd/o6/6JVwcEgzHntLOQuMhyPg/noSFAvEfwBKoSJbAKfQlvh10hMGexyhx2MhodmnwS1unSvRc9/b6uZ4z7XX8tl6FOpfcdZP6lFD0jDDJycZXcBnMbLutfok7YNjEZf6M9z7LfXvOyETMtevlSWvNvfTZqqifW1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644905; c=relaxed/simple;
	bh=JUVBgYauPu436Mntm9h6jkZnOvHLZHAnx95zUdS/wJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8VwUzXU5RnHxf2sic2RnzX/3JPhedp+xvp/ZlAKBUX7DFF0YTleTLrB5gIQ7qX4PxpVhMXU4yLhVYBpM/Fy5e+YZoU4qA2Gzs6yoLHGEi/eddMBJsmdukoGft/xmGRZJCtOoTTweQomUeM9hXiLoCeB7z9CDHzUtOONttgtles=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUuTtiyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUuTtiyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DD4C4CEE2;
	Wed,  7 May 2025 19:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644905;
	bh=JUVBgYauPu436Mntm9h6jkZnOvHLZHAnx95zUdS/wJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUuTtiybaXpKuqMhp3AriTipMDy0YGWl/qo26SerkAhJDxlPV7e5qaf9vfwsQpU/A
	 xr5GWak6FPvK/3gLhaKqW+h1cqKt5iNz6fsVw6gj72pyiyWbiv0EYB1n46nMva3zk0
	 vWLRTLUuhCJQX0cnr7bsEGXLSZhp9IzDzibjqops=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>
Subject: [PATCH 6.6 031/129] cpufreq: Fix setting policy limits when frequency tables are used
Date: Wed,  7 May 2025 20:39:27 +0200
Message-ID: <20250507183814.788357180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit b79028039f440e7d2c4df6ab243060c4e3803e84 upstream.

Commit 7491cdf46b5c ("cpufreq: Avoid using inconsistent policy->min and
policy->max") overlooked the fact that policy->min and policy->max were
accessed directly in cpufreq_frequency_table_target() and in the
functions called by it.  Consequently, the changes made by that commit
led to problems with setting policy limits.

Address this by passing the target frequency limits to __resolve_freq()
and cpufreq_frequency_table_target() and propagating them to the
functions called by the latter.

Fixes: 7491cdf46b5c ("cpufreq: Avoid using inconsistent policy->min and policy->max")
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
Closes: https://lore.kernel.org/linux-pm/aAplED3IA_J0eZN0@linaro.org/
Reported-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/5896780.DvuYhMxLoT@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c          |   22 ++++++---
 drivers/cpufreq/cpufreq_ondemand.c |    3 -
 drivers/cpufreq/freq_table.c       |    6 +-
 include/linux/cpufreq.h            |   83 ++++++++++++++++++++++++-------------
 4 files changed, 73 insertions(+), 41 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -534,14 +534,18 @@ void cpufreq_disable_fast_switch(struct
 EXPORT_SYMBOL_GPL(cpufreq_disable_fast_switch);
 
 static unsigned int __resolve_freq(struct cpufreq_policy *policy,
-		unsigned int target_freq, unsigned int relation)
+				   unsigned int target_freq,
+				   unsigned int min, unsigned int max,
+				   unsigned int relation)
 {
 	unsigned int idx;
 
+	target_freq = clamp_val(target_freq, min, max);
+
 	if (!policy->freq_table)
 		return target_freq;
 
-	idx = cpufreq_frequency_table_target(policy, target_freq, relation);
+	idx = cpufreq_frequency_table_target(policy, target_freq, min, max, relation);
 	policy->cached_resolved_idx = idx;
 	policy->cached_target_freq = target_freq;
 	return policy->freq_table[idx].frequency;
@@ -575,8 +579,7 @@ unsigned int cpufreq_driver_resolve_freq
 	if (unlikely(min > max))
 		min = max;
 
-	return __resolve_freq(policy, clamp_val(target_freq, min, max),
-			      CPUFREQ_RELATION_LE);
+	return __resolve_freq(policy, target_freq, min, max, CPUFREQ_RELATION_LE);
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_resolve_freq);
 
@@ -2348,8 +2351,8 @@ int __cpufreq_driver_target(struct cpufr
 	if (cpufreq_disabled())
 		return -ENODEV;
 
-	target_freq = clamp_val(target_freq, policy->min, policy->max);
-	target_freq = __resolve_freq(policy, target_freq, relation);
+	target_freq = __resolve_freq(policy, target_freq, policy->min,
+				     policy->max, relation);
 
 	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
 		 policy->cpu, target_freq, relation, old_target_freq);
@@ -2644,8 +2647,11 @@ static int cpufreq_set_policy(struct cpu
 	 * compiler optimizations around them because they may be accessed
 	 * concurrently by cpufreq_driver_resolve_freq() during the update.
 	 */
-	WRITE_ONCE(policy->max, __resolve_freq(policy, new_data.max, CPUFREQ_RELATION_H));
-	new_data.min = __resolve_freq(policy, new_data.min, CPUFREQ_RELATION_L);
+	WRITE_ONCE(policy->max, __resolve_freq(policy, new_data.max,
+					       new_data.min, new_data.max,
+					       CPUFREQ_RELATION_H));
+	new_data.min = __resolve_freq(policy, new_data.min, new_data.min,
+				      new_data.max, CPUFREQ_RELATION_L);
 	WRITE_ONCE(policy->min, new_data.min > policy->max ? policy->max : new_data.min);
 
 	trace_cpu_frequency_limits(policy);
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -77,7 +77,8 @@ static unsigned int generic_powersave_bi
 		return freq_next;
 	}
 
-	index = cpufreq_frequency_table_target(policy, freq_next, relation);
+	index = cpufreq_frequency_table_target(policy, freq_next, policy->min,
+					       policy->max, relation);
 	freq_req = freq_table[index].frequency;
 	freq_reduc = freq_req * od_tuners->powersave_bias / 1000;
 	freq_avg = freq_req - freq_reduc;
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -116,8 +116,8 @@ int cpufreq_generic_frequency_table_veri
 EXPORT_SYMBOL_GPL(cpufreq_generic_frequency_table_verify);
 
 int cpufreq_table_index_unsorted(struct cpufreq_policy *policy,
-				 unsigned int target_freq,
-				 unsigned int relation)
+				 unsigned int target_freq, unsigned int min,
+				 unsigned int max, unsigned int relation)
 {
 	struct cpufreq_frequency_table optimal = {
 		.driver_data = ~0,
@@ -148,7 +148,7 @@ int cpufreq_table_index_unsorted(struct
 	cpufreq_for_each_valid_entry_idx(pos, table, i) {
 		freq = pos->frequency;
 
-		if ((freq < policy->min) || (freq > policy->max))
+		if (freq < min || freq > max)
 			continue;
 		if (freq == target_freq) {
 			optimal.driver_data = i;
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -787,8 +787,8 @@ int cpufreq_frequency_table_verify(struc
 int cpufreq_generic_frequency_table_verify(struct cpufreq_policy_data *policy);
 
 int cpufreq_table_index_unsorted(struct cpufreq_policy *policy,
-				 unsigned int target_freq,
-				 unsigned int relation);
+				 unsigned int target_freq, unsigned int min,
+				 unsigned int max, unsigned int relation);
 int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 		unsigned int freq);
 
@@ -853,12 +853,12 @@ static inline int cpufreq_table_find_ind
 	return best;
 }
 
-/* Works only on sorted freq-tables */
-static inline int cpufreq_table_find_index_l(struct cpufreq_policy *policy,
-					     unsigned int target_freq,
-					     bool efficiencies)
+static inline int find_index_l(struct cpufreq_policy *policy,
+			       unsigned int target_freq,
+			       unsigned int min, unsigned int max,
+			       bool efficiencies)
 {
-	target_freq = clamp_val(target_freq, policy->min, policy->max);
+	target_freq = clamp_val(target_freq, min, max);
 
 	if (policy->freq_table_sorted == CPUFREQ_TABLE_SORTED_ASCENDING)
 		return cpufreq_table_find_index_al(policy, target_freq,
@@ -868,6 +868,14 @@ static inline int cpufreq_table_find_ind
 						   efficiencies);
 }
 
+/* Works only on sorted freq-tables */
+static inline int cpufreq_table_find_index_l(struct cpufreq_policy *policy,
+					     unsigned int target_freq,
+					     bool efficiencies)
+{
+	return find_index_l(policy, target_freq, policy->min, policy->max, efficiencies);
+}
+
 /* Find highest freq at or below target in a table in ascending order */
 static inline int cpufreq_table_find_index_ah(struct cpufreq_policy *policy,
 					      unsigned int target_freq,
@@ -921,12 +929,12 @@ static inline int cpufreq_table_find_ind
 	return best;
 }
 
-/* Works only on sorted freq-tables */
-static inline int cpufreq_table_find_index_h(struct cpufreq_policy *policy,
-					     unsigned int target_freq,
-					     bool efficiencies)
+static inline int find_index_h(struct cpufreq_policy *policy,
+			       unsigned int target_freq,
+			       unsigned int min, unsigned int max,
+			       bool efficiencies)
 {
-	target_freq = clamp_val(target_freq, policy->min, policy->max);
+	target_freq = clamp_val(target_freq, min, max);
 
 	if (policy->freq_table_sorted == CPUFREQ_TABLE_SORTED_ASCENDING)
 		return cpufreq_table_find_index_ah(policy, target_freq,
@@ -936,6 +944,14 @@ static inline int cpufreq_table_find_ind
 						   efficiencies);
 }
 
+/* Works only on sorted freq-tables */
+static inline int cpufreq_table_find_index_h(struct cpufreq_policy *policy,
+					     unsigned int target_freq,
+					     bool efficiencies)
+{
+	return find_index_h(policy, target_freq, policy->min, policy->max, efficiencies);
+}
+
 /* Find closest freq to target in a table in ascending order */
 static inline int cpufreq_table_find_index_ac(struct cpufreq_policy *policy,
 					      unsigned int target_freq,
@@ -1006,12 +1022,12 @@ static inline int cpufreq_table_find_ind
 	return best;
 }
 
-/* Works only on sorted freq-tables */
-static inline int cpufreq_table_find_index_c(struct cpufreq_policy *policy,
-					     unsigned int target_freq,
-					     bool efficiencies)
+static inline int find_index_c(struct cpufreq_policy *policy,
+			       unsigned int target_freq,
+			       unsigned int min, unsigned int max,
+			       bool efficiencies)
 {
-	target_freq = clamp_val(target_freq, policy->min, policy->max);
+	target_freq = clamp_val(target_freq, min, max);
 
 	if (policy->freq_table_sorted == CPUFREQ_TABLE_SORTED_ASCENDING)
 		return cpufreq_table_find_index_ac(policy, target_freq,
@@ -1021,7 +1037,17 @@ static inline int cpufreq_table_find_ind
 						   efficiencies);
 }
 
-static inline bool cpufreq_is_in_limits(struct cpufreq_policy *policy, int idx)
+/* Works only on sorted freq-tables */
+static inline int cpufreq_table_find_index_c(struct cpufreq_policy *policy,
+					     unsigned int target_freq,
+					     bool efficiencies)
+{
+	return find_index_c(policy, target_freq, policy->min, policy->max, efficiencies);
+}
+
+static inline bool cpufreq_is_in_limits(struct cpufreq_policy *policy,
+					unsigned int min, unsigned int max,
+					int idx)
 {
 	unsigned int freq;
 
@@ -1030,11 +1056,13 @@ static inline bool cpufreq_is_in_limits(
 
 	freq = policy->freq_table[idx].frequency;
 
-	return freq == clamp_val(freq, policy->min, policy->max);
+	return freq == clamp_val(freq, min, max);
 }
 
 static inline int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 						 unsigned int target_freq,
+						 unsigned int min,
+						 unsigned int max,
 						 unsigned int relation)
 {
 	bool efficiencies = policy->efficiencies_available &&
@@ -1045,29 +1073,26 @@ static inline int cpufreq_frequency_tabl
 	relation &= ~CPUFREQ_RELATION_E;
 
 	if (unlikely(policy->freq_table_sorted == CPUFREQ_TABLE_UNSORTED))
-		return cpufreq_table_index_unsorted(policy, target_freq,
-						    relation);
+		return cpufreq_table_index_unsorted(policy, target_freq, min,
+						    max, relation);
 retry:
 	switch (relation) {
 	case CPUFREQ_RELATION_L:
-		idx = cpufreq_table_find_index_l(policy, target_freq,
-						 efficiencies);
+		idx = find_index_l(policy, target_freq, min, max, efficiencies);
 		break;
 	case CPUFREQ_RELATION_H:
-		idx = cpufreq_table_find_index_h(policy, target_freq,
-						 efficiencies);
+		idx = find_index_h(policy, target_freq, min, max, efficiencies);
 		break;
 	case CPUFREQ_RELATION_C:
-		idx = cpufreq_table_find_index_c(policy, target_freq,
-						 efficiencies);
+		idx = find_index_c(policy, target_freq, min, max, efficiencies);
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		return 0;
 	}
 
-	/* Limit frequency index to honor policy->min/max */
-	if (!cpufreq_is_in_limits(policy, idx) && efficiencies) {
+	/* Limit frequency index to honor min and max */
+	if (!cpufreq_is_in_limits(policy, min, max, idx) && efficiencies) {
 		efficiencies = false;
 		goto retry;
 	}


