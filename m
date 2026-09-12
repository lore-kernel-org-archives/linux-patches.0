Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BF22E88A4;
	Sat, 12 Sep 2026 10:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208331; cv=none; b=FdCc+sSGus22Xh7n8da1YA6itl2omvdsontg5UzpTFV1Xpg1JrTlszxzoPDCOshnNMM1hHCAR3eu8UAyzkidwndJwrew3nJXCKG9pM9/59kujRxhuv1s4twG+FgqWOttVki7Bdc8hrS46VgusZ/q/+uY3TzJfrGaWzXkDbx6wKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208331; c=relaxed/simple;
	bh=sJfjSEwAmsG8ml9FRGipSIU2iMGy33aO3lsL36dhtko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F41CJ55gVAKwSoQOHvuM5j0RaCcq4O/ZD+YtWSh62JPZ04t5UPxjc4mvjs8QYDidk6yFLs3oKd5h8kXbwDDyXfjlA9PvM1SqQ5Kv1c3kcYgD5nVNeS7JcpB4qMHiXiCKiuXOjlXhcKktQtPPkzzEGII/wUefcUJKZjLVZ3C9HVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIGHJ7S2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIGHJ7S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C1B1F000FF;
	Sat, 12 Sep 2026 10:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208328;
	bh=sGgs+ULhTwZVAc4Uh25eLEqQiWiQb8sy9JfpAPwzSMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIGHJ7S2lKpbwDkZmfmSv5SwY8F5vatnuFhgkwsGZ8K1IExUE1PCuRKIf6WdZfwNb
	 JYsyRYPmxaCZJZ5Z1iJOVfbFWyu3hJ40xtxTtIredBiuSrQ2VH4sRPBmT6nqb569NM
	 a478TTLf78dVLhRwRX+dbU0Ql5TyGytctj4m01/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0593/1518] cpufreq/amd-pstate: Set min_limit_freq based on bios_min_perf
Date: Sat, 12 Sep 2026 08:46:02 +0200
Message-ID: <20260912065636.840837150@linuxfoundation.org>
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
index 17e8435d85ac5..0b29213a019f5 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -635,9 +635,12 @@ static void amd_pstate_update_min_max_limit(struct cpufreq_policy *policy)
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
@@ -645,11 +648,18 @@ static void amd_pstate_update_min_max_limit(struct cpufreq_policy *policy)
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



