Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7440B3DBD5E;
	Sat, 12 Sep 2026 10:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208324; cv=none; b=k4HVWa082sG3psbw1CIFw67A5Xp03FBi3P4sUyAPwkPYAtrQFZLS4DD/d5X0Uc+y8UqChOGYCcAoZZGDcgLa3XkcYzac4wvzT9h9bNat6RJlZGsf3Kyx9Fp4tWRnun1nRWBuqXaDPEHO3XbEioEHMQJ94D77nv/yHToXcS3c6Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208324; c=relaxed/simple;
	bh=obbZ/nl5dgixLW+ox25/2So1IBMeRgsZwLVFvcuGudc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdwP3DtVGQiL9pJ1VCMyLHTjAdOJmREq8MYTzLYkLIJMY0dYj9xlk5Mtn2OQKV4MOCsYZmX4wv3AadK+JwflvSkln4RRenpnmsBoUdJ3Pa+eKcmPqexGoJD4J2o/DCr9qlJjln/7yaH3hMtJlGSdvXbkQ1DOkl0WwibJdOip0hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vujyRYkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vujyRYkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D091F000FF;
	Sat, 12 Sep 2026 10:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208322;
	bh=qWTtTQb4ir1Z6hFMCrC8zuOcnF5HzO2krIXCieHvUp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vujyRYkhzn0f0v2/U6SOeCL+dfAZ7mj5AErod3pQMGu9VSxLF5bgXR6UFyTPE/4KE
	 zh6L1VZBv/8xzr3yOLFUmsSVwtf1Zet+y35blIE430XvSx94o9I8L+X87P+sG4Cca6
	 +v1N+6j2070/CkZEURUyGe2ktMjYa40b/5NW1CGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juan Martinez <juan.martinez@amd.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0592/1518] cpufreq/amd-pstate: Add comment explaining nominal_perf usage for performance policy
Date: Sat, 12 Sep 2026 08:46:01 +0200
Message-ID: <20260912065636.818467253@linuxfoundation.org>
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

From: Juan Martinez <juan.martinez@amd.com>

[ Upstream commit 94dbce6c13cd7634f9bdb402248991c95a8c3d57 ]

Add comment explaining why nominal_perf is used for MinPerf when the
CPU frequency policy is set to CPUFREQ_POLICY_PERFORMANCE, rather than
using highest_perf or lowest_nonlinear_perf.

Signed-off-by: Juan Martinez <juan.martinez@amd.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: 5c3ecf36d291 ("cpufreq/amd-pstate: Set min_limit_freq based on bios_min_perf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 081d2e60a21e6..17e8435d85ac5 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -635,6 +635,19 @@ static void amd_pstate_update_min_max_limit(struct cpufreq_policy *policy)
 	WRITE_ONCE(cpudata->max_limit_freq, policy->max);
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE) {
+		/*
+		 * For performance policy, set MinPerf to nominal_perf rather than
+		 * highest_perf or lowest_nonlinear_perf.
+		 *
+		 * Per commit 0c411b39e4f4c, using highest_perf was observed
+		 * to cause frequency throttling on power-limited platforms, leading to
+		 * performance regressions. Using lowest_nonlinear_perf would limit
+		 * performance too much for HPC workloads requiring high frequency
+		 * operation and minimal wakeup latency from idle states.
+		 *
+		 * nominal_perf therefore provides a balance by avoiding throttling
+		 * while still maintaining enough performance for HPC workloads.
+		 */
 		perf.min_limit_perf = min(perf.nominal_perf, perf.max_limit_perf);
 		WRITE_ONCE(cpudata->min_limit_freq, min(cpudata->nominal_freq, cpudata->max_limit_freq));
 	} else {
-- 
2.53.0



