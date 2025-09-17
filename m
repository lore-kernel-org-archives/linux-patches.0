Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BE536D;
	Wed, 17 Sep 2025 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112661; cv=none; b=o9oQTnfmowiUdecVQEDQgLgZtAKTacNsUoVy/vMTK6PpluxOP5YFjQeRRX8qDk4+RPu6MpjJontKc/R2fj4kkCUVYQnV0Zz3ky6V4KKSpcw7Xjmtm89kTwQon8nXpibkwmE3ZxOuwLCt91ouxwo+g0pDs1v2iKTUAxw6gUK2/eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112661; c=relaxed/simple;
	bh=xQWSbfzR8OcB6eKmozNDTVyLvpf1E68oDJ6tjz6xcVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7k2+AF1gzgdqbaoTTusBIoFbd02r7E+L1+RRtZjEgGUdiZl8YIgbwDq6OuQaCSYObb2krqNnDp7FoCVcLxRj/ZxMtts/ZgBidxCFTfY08tadHs5oQl/m+L1Fv/VBEo0zQkyl8q1XWe44lWZu7mBozzIjWaLGzaqZ86RlHdifQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWoTAAdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWoTAAdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CA4C4CEF0;
	Wed, 17 Sep 2025 12:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112661;
	bh=xQWSbfzR8OcB6eKmozNDTVyLvpf1E68oDJ6tjz6xcVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWoTAAdjUKAS9v0wWhTucfRUDeWHfSX7DNqkDNs5g9MvCskQfs9va5QDC/o/sKAkr
	 pJVGJYqrWMu2G2tYyYWH0WZDEGJPYDOctLPv8tStTBRN2JQkaR165P8LrQz561LPkC
	 wQ1kR7ztcx1QVRrGLbNBQSh9SeYP6m4oDkpNQUy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 037/189] cpufreq/amd-pstate: Fix setting of CPPC.min_perf in active mode for performance governor
Date: Wed, 17 Sep 2025 14:32:27 +0200
Message-ID: <20250917123352.766305742@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 220abf77e7c2835cc63ea8cd7158cf83952640af ]

In the "active" mode of the amd-pstate driver with performance
governor, the CPPC.min_perf is expected to be the nominal_perf.

However after commit a9b9b4c2a4cd ("cpufreq/amd-pstate: Drop min and
max cached frequencies"), this is not the case when the governor is
switched from performance to powersave and back to performance, and
the CPPC.min_perf will be equal to the scaling_min_freq that was set
for the powersave governor.

This is because prior to commit a9b9b4c2a4cd ("cpufreq/amd-pstate:
Drop min and max cached frequencies"), amd_pstate_epp_update_limit()
would unconditionally call amd_pstate_update_min_max_limit() and the
latter function would enforce the CPPC.min_perf constraint when the
governor is performance.

However, after the aforementioned commit,
amd_pstate_update_min_max_limit() is called by
amd_pstate_epp_update_limit() only when either the
scaling_{min/max}_freq is different from the cached value of
cpudata->{min/max}_limit_freq, which wouldn't have changed on a
governor transition from powersave to performance, thus missing out on
enforcing the CPPC.min_perf constraint for the performance governor.

Fix this by invoking amd_pstate_epp_udpate_limit() not only when the
{min/max} limits have changed from the cached values, but also when
the policy itself has changed.

Fixes: a9b9b4c2a4cd ("cpufreq/amd-pstate: Drop min and max cached frequencies")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250821042638.356-1-gautham.shenoy@amd.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index f3477ab377425..bbb8e18a6e2b9 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1547,13 +1547,15 @@ static void amd_pstate_epp_cpu_exit(struct cpufreq_policy *policy)
 	pr_debug("CPU %d exiting\n", policy->cpu);
 }
 
-static int amd_pstate_epp_update_limit(struct cpufreq_policy *policy)
+static int amd_pstate_epp_update_limit(struct cpufreq_policy *policy, bool policy_change)
 {
 	struct amd_cpudata *cpudata = policy->driver_data;
 	union perf_cached perf;
 	u8 epp;
 
-	if (policy->min != cpudata->min_limit_freq || policy->max != cpudata->max_limit_freq)
+	if (policy_change ||
+	    policy->min != cpudata->min_limit_freq ||
+	    policy->max != cpudata->max_limit_freq)
 		amd_pstate_update_min_max_limit(policy);
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE)
@@ -1577,7 +1579,7 @@ static int amd_pstate_epp_set_policy(struct cpufreq_policy *policy)
 
 	cpudata->policy = policy->policy;
 
-	ret = amd_pstate_epp_update_limit(policy);
+	ret = amd_pstate_epp_update_limit(policy, true);
 	if (ret)
 		return ret;
 
@@ -1651,7 +1653,7 @@ static int amd_pstate_epp_resume(struct cpufreq_policy *policy)
 		int ret;
 
 		/* enable amd pstate from suspend state*/
-		ret = amd_pstate_epp_update_limit(policy);
+		ret = amd_pstate_epp_update_limit(policy, false);
 		if (ret)
 			return ret;
 
-- 
2.51.0



