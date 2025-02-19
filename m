Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9101D14FF;
	Wed, 19 Feb 2025 08:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954558; cv=none; b=Jmh+BSPaevhDRea3LkcQorHGpUeRIjRSM9DolUai1B+Ouhu2DZbVqgpSU/xaBG42eDg0pssaY4MB+yYQKJ29cKN2aUVgEdpg8m0ZlxZPyAjYivKh24W+Fp6Dk0dwJGZXJ8rwwBwFZrse4zUgM3BMbFkeiFXUPyurCPX2wtvMAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954558; c=relaxed/simple;
	bh=kDJYY5RrjyFgsXu0rlRCylI3qhLvp4KP7klQZZFBsQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf7eSYpDvN8dk6RFBH0odEcq8Q4Zo+jg6Osd5h3VA/nwhq/QKbpVsevVyRYtTGl+4+HLi0afG3CCUO5EgEZwi2uNcT6RC1/oCGyetSLUXxnQesFQaJrP1bJFsEvvIYj67RouDk6bYcFo4dqdvVjZVUylrrmFj+MY5PwVR99p2QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2E91636; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2E91636"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB035C4CED1;
	Wed, 19 Feb 2025 08:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954558;
	bh=kDJYY5RrjyFgsXu0rlRCylI3qhLvp4KP7klQZZFBsQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2E91636IXIBYn9JmQQUc9z3luh5FFWSfvexoDL3Annpjq4zUFaBN6NfUkBzF8Wsf
	 feyRWmuVqIDnm/r4uWPtifjTU/bi8czr1OcqiJ02yaL46TZYody3e8ghStOU52fHTQ
	 fg/K1PtsorFoMspgvmhvt//seSG0Q5HEOrW2mvgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 209/274] cpufreq/amd-pstate: Refactor amd_pstate_epp_reenable() and amd_pstate_epp_offline()
Date: Wed, 19 Feb 2025 09:27:43 +0100
Message-ID: <20250219082617.758039198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit b1089e0c8817fda93d474eaa82ad86386887aefe ]

Replace similar code chunks with amd_pstate_update_perf() and
amd_pstate_set_epp() function calls.

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20241204144842.164178-4-Dhananjay.Ugwekar@amd.com
[ML: Fix LKP reported error about unused variable]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 3ace20038e19 ("cpufreq/amd-pstate: Fix cpufreq_policy ref counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 38 +++++++-----------------------------
 1 file changed, 7 insertions(+), 31 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index f6d04eb40af94..72c613cba7086 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1605,25 +1605,17 @@ static int amd_pstate_epp_set_policy(struct cpufreq_policy *policy)
 
 static void amd_pstate_epp_reenable(struct amd_cpudata *cpudata)
 {
-	struct cppc_perf_ctrls perf_ctrls;
-	u64 value, max_perf;
+	u64 max_perf;
 	int ret;
 
 	ret = amd_pstate_cppc_enable(true);
 	if (ret)
 		pr_err("failed to enable amd pstate during resume, return %d\n", ret);
 
-	value = READ_ONCE(cpudata->cppc_req_cached);
 	max_perf = READ_ONCE(cpudata->highest_perf);
 
-	if (cpu_feature_enabled(X86_FEATURE_CPPC)) {
-		wrmsrl_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ, value);
-	} else {
-		perf_ctrls.max_perf = max_perf;
-		cppc_set_perf(cpudata->cpu, &perf_ctrls);
-		perf_ctrls.energy_perf = AMD_CPPC_ENERGY_PERF_PREF(cpudata->epp_cached);
-		cppc_set_epp_perf(cpudata->cpu, &perf_ctrls, 1);
-	}
+	amd_pstate_update_perf(cpudata, 0, 0, max_perf, false);
+	amd_pstate_set_epp(cpudata, cpudata->epp_cached);
 }
 
 static int amd_pstate_epp_cpu_online(struct cpufreq_policy *policy)
@@ -1643,31 +1635,15 @@ static int amd_pstate_epp_cpu_online(struct cpufreq_policy *policy)
 static void amd_pstate_epp_offline(struct cpufreq_policy *policy)
 {
 	struct amd_cpudata *cpudata = policy->driver_data;
-	struct cppc_perf_ctrls perf_ctrls;
 	int min_perf;
-	u64 value;
 
 	min_perf = READ_ONCE(cpudata->lowest_perf);
-	value = READ_ONCE(cpudata->cppc_req_cached);
 
 	mutex_lock(&amd_pstate_limits_lock);
-	if (cpu_feature_enabled(X86_FEATURE_CPPC)) {
-		cpudata->epp_policy = CPUFREQ_POLICY_UNKNOWN;
-
-		/* Set max perf same as min perf */
-		value &= ~AMD_CPPC_MAX_PERF(~0L);
-		value |= AMD_CPPC_MAX_PERF(min_perf);
-		value &= ~AMD_CPPC_MIN_PERF(~0L);
-		value |= AMD_CPPC_MIN_PERF(min_perf);
-		wrmsrl_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ, value);
-	} else {
-		perf_ctrls.desired_perf = 0;
-		perf_ctrls.min_perf = min_perf;
-		perf_ctrls.max_perf = min_perf;
-		cppc_set_perf(cpudata->cpu, &perf_ctrls);
-		perf_ctrls.energy_perf = AMD_CPPC_ENERGY_PERF_PREF(HWP_EPP_BALANCE_POWERSAVE);
-		cppc_set_epp_perf(cpudata->cpu, &perf_ctrls, 1);
-	}
+
+	amd_pstate_update_perf(cpudata, min_perf, 0, min_perf, false);
+	amd_pstate_set_epp(cpudata, AMD_CPPC_EPP_BALANCE_POWERSAVE);
+
 	mutex_unlock(&amd_pstate_limits_lock);
 }
 
-- 
2.39.5



