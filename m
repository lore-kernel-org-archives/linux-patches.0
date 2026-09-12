Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64A23803CF;
	Sat, 12 Sep 2026 07:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199962; cv=none; b=bg4wy6YXMDEjmxXU5fm/H17R7knpimn6uD1yO7SaqLWw6IP4+hf8dFcNe8dkqWZPVugtHaTT4tcinDvssf3IgrCydQsWhm9lObJbrpRm8hHoKHtHWNiXwiISPc78Pb5VlTHTVBJkHxZfzDVf6qifNaO3qyeEP0gP3dFLpNZ8lAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199962; c=relaxed/simple;
	bh=pCrCYmi0xj+HeKfn0JOuHmI1c5tbE1oskRB5+1dM8ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvrrFX7qIeB6uWBJPAv62gA91qg197UkjIksTXIPLQel7v2cJzsJohFGUg77p7r2TVACctd/lzomTtiM5bBSPbGMMi0IrW09BQ7RSSrskW1UF+Bb/Yk7/TFcRq0LZ2G2S11TubcNb5a9Nud0Ssr7Z0NbvegNTKcODRx7XZvssuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL14RwG3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL14RwG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD511F00898;
	Sat, 12 Sep 2026 07:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199960;
	bh=gSK/FwyKq8rAzXd2siA5KrR1ITBrE+TSv8zJtQ5k+gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bL14RwG3/p1hpvzpXExeGDov6QPXDWUQwlJjq8G6WWPZgTsQgG/0u3dpFA8su55+m
	 WRUr0cJoXOYMmtfD/S2tXZqIXL+HKLAWOP/nOVQ6A791Sqh2rQ4JfPs5D9pF3r4OI4
	 7seampOEk3YVwB4YGT2tL9A1tJ2kf1MJkKqfXdG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0693/1815] cpufreq/amd-pstate: Set min_limit_freq based on bios_min_perf
Date: Sat, 12 Sep 2026 08:40:43 +0200
Message-ID: <20260912065705.158635550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 5c3ecf36d2918facff40548ee6ae28eef0865266 ]

amd_pstate_update_min_max_limit() sets the min_limit_perf to the
nominal_perf to avoid frequency throttling when the system is idling.

This was found to be an ideal default but is suboptimal for users who
have profiled their workload at different operating frequencies and have
configured the optimal idling frequency via bios_min_perf.

Use the bios_min_perf (if configured) as the min_limit_perf when running
with performance governor. In absence of bios_min_perf, continue using
nominal_perf as the default min_limit_perf to avoid throttling.

Fixes: 608a76b65288 ("cpufreq/amd-pstate: Add support for the "Requested CPU Min frequency" BIOS option")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260727072056.1248-2-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 31b320f329290..80d99ba1902c9 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -699,9 +699,12 @@ static void amd_pstate_update_min_max_limit(struct cpufreq_policy *policy)
 	WRITE_ONCE(cpudata->max_limit_freq, policy->max);
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE) {
+		u8 min_limit_perf = perf.bios_min_perf ?: perf.nominal_perf;
+		u32 min_limit_freq;
+
 		/*
-		 * For performance policy, set MinPerf to nominal_perf rather than
-		 * highest_perf or lowest_nonlinear_perf.
+		 * For performance policy, set MinPerf to nominal_perf / bios_min_perf
+		 * rather than highest_perf or lowest_nonlinear_perf.
 		 *
 		 * Per commit 0c411b39e4f4c, using highest_perf was observed
 		 * to cause frequency throttling on power-limited platforms, leading to
@@ -709,11 +712,18 @@ static void amd_pstate_update_min_max_limit(struct cpufreq_policy *policy)
 		 * performance too much for HPC workloads requiring high frequency
 		 * operation and minimal wakeup latency from idle states.
 		 *
-		 * nominal_perf therefore provides a balance by avoiding throttling
-		 * while still maintaining enough performance for HPC workloads.
+		 * nominal_perf therefore provides a balanced default by avoiding
+		 * throttling while still maintaining enough performance for HPC
+		 * workloads when bios_min_perf is not available.
+		 *
+		 * When bios_min_perf is available, users have profiled their workloads
+		 * to understand the best idling frequency. Use that instead.
 		 */
-		perf.min_limit_perf = min(perf.nominal_perf, perf.max_limit_perf);
-		WRITE_ONCE(cpudata->min_limit_freq, min(cpudata->nominal_freq, cpudata->max_limit_freq));
+		min_limit_perf = min(min_limit_perf, perf.max_limit_perf);
+		min_limit_freq = perf_to_freq(perf, cpudata->nominal_freq, min_limit_perf);
+		perf.min_limit_perf = min_limit_perf;
+
+		WRITE_ONCE(cpudata->min_limit_freq, min(min_limit_freq, cpudata->max_limit_freq));
 	} else {
 		perf.min_limit_perf = freq_to_perf(perf, cpudata->nominal_freq, policy->min);
 		WRITE_ONCE(cpudata->min_limit_freq, policy->min);
-- 
2.53.0



