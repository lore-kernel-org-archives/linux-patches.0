Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11652040BB;
	Tue,  3 Dec 2024 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240209; cv=none; b=pjPULruPon1AqwOKJ96k1iOYBg4boQo99CjFOOLj2YGxwQFNjXVBwqpOlJ4tAraUtpY93KJMhyE75VMf2bW9WYqEm0r3i6+fzDo7yzCATjbkKL2mGqLq7I0gp0eGwXzs/HDaXmoigpw6Xhnb+sgP+n/rJQ8AcSP4hUuNP73L790=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240209; c=relaxed/simple;
	bh=LFLqWT5jnDkSaurY0UMEHI22SK74+1+DW2XQf5k9Ua8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERApYNDrWHQkskkEuV5oio3Zh/N5CS2LA8FwmbEYKLJcKh1kZpe66iDHbe7VLQumKPiWrhxmOiFjkTgW7XS8I0rzKX93sPg+NHSlbKFxnbtaVgjhrjQmqEhXUmkiU76oaTINK0+TJgMYRUCDoy/PJ+H7H3s6cPDxR7MMV2qqSMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB2EzC2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB2EzC2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E40C4CECF;
	Tue,  3 Dec 2024 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240209;
	bh=LFLqWT5jnDkSaurY0UMEHI22SK74+1+DW2XQf5k9Ua8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB2EzC2S4k4Z+LmvfAHmCFQ/hUokC0wwxu29m4j4JEX8eDbt+2Tm1BD16i7cQkSYK
	 67aN0tBV0nMfW9tY6va9rykXCWLJ14J7ptQhXjfKoeyDAvgG467FOCGz+nQsV3cSo/
	 WVAoqwz8v61DHonAFwIRCjZ8rGd+PLWWkCGKj4RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/826] cpufreq/amd-pstate: Dont update CPPC request in amd_pstate_cpu_boost_update()
Date: Tue,  3 Dec 2024 15:36:27 +0100
Message-ID: <20241203144745.813003196@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b63863f77c677..5138aa42caf22 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -665,34 +665,12 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
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



