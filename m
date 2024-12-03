Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FF033FE;
	Tue,  3 Dec 2024 15:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238035; cv=none; b=H0D6BylZySHwQC138QVXQRdSD7GZSSxUx9CRx1e380eB+ZKRCBPizVv+rkLbc/SUers0xrbJDNRImTahzZtcbW2uieSEi1fVc/u/BVM1U6e27PuO40XhlJudmRGT4C1A+fUho4rHL7iZhPCLRRtQ9sFrwVPU4+pLdZ86fageC1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238035; c=relaxed/simple;
	bh=cJ+XkqpUwNutlNYpvrJZhwCx8dlIVvNNSqEiEl4638U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFirXhYzY0JwlXkuaQXoeJYP0E8bWjXOmCUbGN59t5X7jWEe4/NLdT13hRGWOg7rI448Yjzbe6vb3Mr6tMY2VkziOTQExj+UOOxnEScxGq1RYLAggO0UOJXIwHvcSOj5LL4W8Bp6dnL4SZVlilmtwIxhKufJh+DMXcihWGKtPWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoR15qaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoR15qaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B349C4CECF;
	Tue,  3 Dec 2024 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238034;
	bh=cJ+XkqpUwNutlNYpvrJZhwCx8dlIVvNNSqEiEl4638U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoR15qaOwmffilybpArPKKbqbnPyPD32Xj72HYIKEmm4hAUlTRYOJAcrtbLcm+SXV
	 61icsKIbQvDnkMFktUzhiNuUxQSGJa+X2Gwxk84wRjpVv8Mrwg1OepwVZIJpA+sMBF
	 hqG+j/G2y1ecSValcta7iWuZPVHf05zEM+b8FG9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 109/817] cpufreq/amd-pstate: Dont update CPPC request in amd_pstate_cpu_boost_update()
Date: Tue,  3 Dec 2024 15:34:41 +0100
Message-ID: <20241203143959.965874942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 67c08d303e0a1a5665b3f198037c9fae2d808090 ]

When boost is changed the CPPC value is changed in amd_pstate_cpu_boost_update()
but then changed again when refresh_frequency_limits() and all it's callbacks
occur.  The first is a pointless write, so instead just update the limits for
the policy and let the policy refresh anchor everything properly.

Fixes: c8c68c38b56f ("cpufreq: amd-pstate: initialize core precision boost state")
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Perry Yuan <perry.yuan@amd.com>
Tested-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Link: https://lore.kernel.org/r/20241012174519.897-2-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 929b9097a6c17..62ae4ff290379 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -698,34 +698,12 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 static int amd_pstate_cpu_boost_update(struct cpufreq_policy *policy, bool on)
 {
 	struct amd_cpudata *cpudata = policy->driver_data;
-	struct cppc_perf_ctrls perf_ctrls;
-	u32 highest_perf, nominal_perf, nominal_freq, max_freq;
+	u32 nominal_freq, max_freq;
 	int ret = 0;
 
-	highest_perf = READ_ONCE(cpudata->highest_perf);
-	nominal_perf = READ_ONCE(cpudata->nominal_perf);
 	nominal_freq = READ_ONCE(cpudata->nominal_freq);
 	max_freq = READ_ONCE(cpudata->max_freq);
 
-	if (boot_cpu_has(X86_FEATURE_CPPC)) {
-		u64 value = READ_ONCE(cpudata->cppc_req_cached);
-
-		value &= ~GENMASK_ULL(7, 0);
-		value |= on ? highest_perf : nominal_perf;
-		WRITE_ONCE(cpudata->cppc_req_cached, value);
-
-		wrmsrl_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ, value);
-	} else {
-		perf_ctrls.max_perf = on ? highest_perf : nominal_perf;
-		ret = cppc_set_perf(cpudata->cpu, &perf_ctrls);
-		if (ret) {
-			cpufreq_cpu_release(policy);
-			pr_debug("Failed to set max perf on CPU:%d. ret:%d\n",
-				cpudata->cpu, ret);
-			return ret;
-		}
-	}
-
 	if (on)
 		policy->cpuinfo.max_freq = max_freq;
 	else if (policy->cpuinfo.max_freq > nominal_freq * 1000)
-- 
2.43.0



