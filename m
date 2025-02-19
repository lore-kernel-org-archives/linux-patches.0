Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E451E285A;
	Wed, 19 Feb 2025 08:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955245; cv=none; b=E4rDSKBEi+0HpbpcVYN9tMll3iJ7jeTAyAuHA/dBFjA+whQh+eBso858hQp/C5fs5PbKJs1ZaIRob5LNhuQ2iz9McFc1F36ZWAZ1DD7aWGJctpZN7fXnM9UbjtGySNPZBIkYISEZqmgWX4ctLgE+XFkPKgN/4JUBf7vNZAIDcmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955245; c=relaxed/simple;
	bh=VP0boResydDu6xJOcyqaTpB765h7d1nzRMB7hgmGLFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXgZS4wvqofkztiY+YTbGmmbcZF0nRzi5aMJCNc1DgaTqfgMcnuTN2So4eMCUhyKIYd1fqbQt9IQbdcFBCAdG22qHjcSBoS6P60ElD2z8DqrQYPpEw21aBvR0Zqm6BoaUvtoS7niBAF3rsqc3/2tMS6g8paL6AeBtg/JmQU6S10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkqy4g4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkqy4g4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9918DC4CED1;
	Wed, 19 Feb 2025 08:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955245;
	bh=VP0boResydDu6xJOcyqaTpB765h7d1nzRMB7hgmGLFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkqy4g4AMVMhOyJdSMqhbayZ42sax0axR1pfrAPnuhp6HGREWa093cvi+/02zCmw8
	 EN4rvJ54X5zogmkhd80TX0GW/HbALMNoVK0EV/896vVmmy5E6xCPBJGIi0VEiKyYuw
	 8qGgmLl13NmDWv2zI/qu6DV1vfK1dtx4oQU8uj4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/230] cpufreq/amd-pstate: Refactor amd_pstate_epp_reenable() and amd_pstate_epp_offline()
Date: Wed, 19 Feb 2025 09:28:14 +0100
Message-ID: <20250219082608.630150372@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 895d108428b40..19906141ef7fe 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1579,25 +1579,17 @@ static int amd_pstate_epp_set_policy(struct cpufreq_policy *policy)
 
 static void amd_pstate_epp_reenable(struct amd_cpudata *cpudata)
 {
-	struct cppc_perf_ctrls perf_ctrls;
-	u64 value, max_perf;
+	u64 max_perf;
 	int ret;
 
 	ret = amd_pstate_enable(true);
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
@@ -1617,31 +1609,15 @@ static int amd_pstate_epp_cpu_online(struct cpufreq_policy *policy)
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



