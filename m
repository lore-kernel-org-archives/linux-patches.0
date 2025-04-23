Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DA228A1F7;
	Wed, 23 Apr 2025 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420963; cv=none; b=hLNWcy/Kv340qZ/Snzraj02jMtF4EuosmI6Fe9YIOyr/biTU8/NLZrnC0jWocajLW6bQd6lr1Da9pYe2zG9CehhbRs4CZmZL0zvIj7eZLSL+OKIgt+z4hVE37WkEc19cLDWW5q9QtL/ijjRG/B8dr8NVMSELrOhNfQnDsJTq8SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420963; c=relaxed/simple;
	bh=xRKc71TJ6jvXwgJZHlEE47sjfe5laQPf/SkJFU6OL8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffhGkawA7tkQBW4yh0AylsddpBViG1u/tV/fXzxqQEIWPcpODjtlQ8bFS+3KVBLvsrryTyhqZGxSvRPgjavvdfVUoe756OK9PCRZ3lbw1/Hik2KlUT95NSkrAzVhnWukvqCJh4q8ywwEKgTj3EjNO27+t9Bo+f7KjgfKjSe45qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5gdkBZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5gdkBZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03D8C4CEE2;
	Wed, 23 Apr 2025 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420963;
	bh=xRKc71TJ6jvXwgJZHlEE47sjfe5laQPf/SkJFU6OL8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5gdkBZGI0G346pVQO32nniu3d7kynCeuW25PO5ukAzTQAm0ufgpfYZ5tqDm1JVpb
	 owHUSfwpP3GVg9I+a31Ta4ZHy7M6dp59KMPUCpg7Hvt96EaYVN+rTvovYNfzR7hjfQ
	 +/ZXc+V51HwUK6APj4DxFq142HdWLb3SMQMixRrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.14 130/241] cpufreq: Avoid using inconsistent policy->min and policy->max
Date: Wed, 23 Apr 2025 16:43:14 +0200
Message-ID: <20250423142625.881627603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 7491cdf46b5cbdf123fc84fbe0a07e9e3d7b7620 upstream.

Since cpufreq_driver_resolve_freq() can run in parallel with
cpufreq_set_policy() and there is no synchronization between them,
the former may access policy->min and policy->max while the latter
is updating them and it may see intermediate values of them due
to the way the update is carried out.  Also the compiler is free
to apply any optimizations it wants both to the stores in
cpufreq_set_policy() and to the loads in cpufreq_driver_resolve_freq()
which may result in additional inconsistencies.

To address this, use WRITE_ONCE() when updating policy->min and
policy->max in cpufreq_set_policy() and use READ_ONCE() for reading
them in cpufreq_driver_resolve_freq().  Moreover, rearrange the update
in cpufreq_set_policy() to avoid storing intermediate values in
policy->min and policy->max with the help of the observation that
their new values are expected to be properly ordered upfront.

Also modify cpufreq_driver_resolve_freq() to take the possible reverse
ordering of policy->min and policy->max, which may happen depending on
the ordering of operations when this function and cpufreq_set_policy()
run concurrently, into account by always honoring the max when it
turns out to be less than the min (in case it comes from thermal
throttling or similar).

Fixes: 151717690694 ("cpufreq: Make policy min/max hard requirements")
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/5907080.DvuYhMxLoT@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -539,8 +539,6 @@ static unsigned int __resolve_freq(struc
 {
 	unsigned int idx;
 
-	target_freq = clamp_val(target_freq, policy->min, policy->max);
-
 	if (!policy->freq_table)
 		return target_freq;
 
@@ -564,7 +562,22 @@ static unsigned int __resolve_freq(struc
 unsigned int cpufreq_driver_resolve_freq(struct cpufreq_policy *policy,
 					 unsigned int target_freq)
 {
-	return __resolve_freq(policy, target_freq, CPUFREQ_RELATION_LE);
+	unsigned int min = READ_ONCE(policy->min);
+	unsigned int max = READ_ONCE(policy->max);
+
+	/*
+	 * If this function runs in parallel with cpufreq_set_policy(), it may
+	 * read policy->min before the update and policy->max after the update
+	 * or the other way around, so there is no ordering guarantee.
+	 *
+	 * Resolve this by always honoring the max (in case it comes from
+	 * thermal throttling or similar).
+	 */
+	if (unlikely(min > max))
+		min = max;
+
+	return __resolve_freq(policy, clamp_val(target_freq, min, max),
+			      CPUFREQ_RELATION_LE);
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_resolve_freq);
 
@@ -2337,6 +2350,7 @@ int __cpufreq_driver_target(struct cpufr
 	if (cpufreq_disabled())
 		return -ENODEV;
 
+	target_freq = clamp_val(target_freq, policy->min, policy->max);
 	target_freq = __resolve_freq(policy, target_freq, relation);
 
 	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
@@ -2661,11 +2675,15 @@ static int cpufreq_set_policy(struct cpu
 	 * Resolve policy min/max to available frequencies. It ensures
 	 * no frequency resolution will neither overshoot the requested maximum
 	 * nor undershoot the requested minimum.
+	 *
+	 * Avoid storing intermediate values in policy->max or policy->min and
+	 * compiler optimizations around them because they may be accessed
+	 * concurrently by cpufreq_driver_resolve_freq() during the update.
 	 */
-	policy->min = new_data.min;
-	policy->max = new_data.max;
-	policy->min = __resolve_freq(policy, policy->min, CPUFREQ_RELATION_L);
-	policy->max = __resolve_freq(policy, policy->max, CPUFREQ_RELATION_H);
+	WRITE_ONCE(policy->max, __resolve_freq(policy, new_data.max, CPUFREQ_RELATION_H));
+	new_data.min = __resolve_freq(policy, new_data.min, CPUFREQ_RELATION_L);
+	WRITE_ONCE(policy->min, new_data.min > policy->max ? policy->max : new_data.min);
+
 	trace_cpu_frequency_limits(policy);
 
 	cpufreq_update_pressure(policy);


