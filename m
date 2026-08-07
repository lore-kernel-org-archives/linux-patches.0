Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4081F396597;
	Fri,  7 Aug 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117473; cv=none; b=Xe9i/qaH/xIidSNmEmuH1cq+FnN3qK/sDbYHkZECx+dTwtU+JrZQV3T1tYh7rftFzF15eU3ZXb4aGWKw/HJPNBWKPlSpBkG6GwgmzQi2Hqj31ilmGIGZadtxhgg5Q0SaYUKf3LeSV+P3UCCan9BIHNOsX1Eov/295fQtwYffC3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117473; c=relaxed/simple;
	bh=TLr75ubtW48yCptkeoYYPZYFjZOlD2mhYUfyQFiFJcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRksTWo16bHpsBCPdH273hrBwavikNLpfGXjPwlteUOV2LBtn36MhmqP5pLVS7uC7lH3FpjAOJza3nx2TOK4Ig3S3p+0Uuf4tbZLZUova1TvevRT5CgPxZz3S2a9J6g/b8XkOFFGZOsjINeIhhCd6ug/A813okTtkihAP25Stx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znyfViEF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znyfViEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAAB1F000E9;
	Fri,  7 Aug 2026 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117472;
	bh=i0dESlNu6+P0by+ZHg2egiEY7X7b7SgYMclS/wE1/7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znyfViEFzXp3eQ5s5yFRzfGYqiN2e67ZXWftvCIMdu2I7Q3mCmkMI9a3n3FD+ow0V
	 feBxmocK4faSyu9hsyHxusAC1MJ9Hyzsnf27sJzw6DtVhiHMxlrcPbyZADpcibSHvk
	 STQrgpJH15ITpQ9UsIyX4LGK2u+RGntY+7cvaLWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 331/438] cpufreq: cppc: Sanitize lockless policy limit snapshots
Date: Fri,  7 Aug 2026 16:38:47 +0200
Message-ID: <20260807143435.030735036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 9753c0ab89b7516aba4884dc3cc725ca33c2e3da upstream.

cppc_cpufreq_update_perf_limits() reads policy->min and policy->max
without holding the policy lock. The cpufreq core updates those fields
with separate stores, so a reader can observe the old minimum together
with the new maximum and construct MIN_PERF greater than MAX_PERF.

Read both fields once and, if the lockless snapshot is inconsistent,
reduce the minimum to the observed maximum. This matches the conservative
correction used by cpufreq_driver_resolve_freq() and ensures that CPPC
never receives an inverted limit pair.

Fixes: ea3db45ae476 ("cpufreq: cppc: Update MIN_PERF/MAX_PERF in target callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260722093825.1030594-3-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cppc_cpufreq.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -290,19 +290,32 @@ static inline void cppc_freq_invariance_
 }
 #endif /* CONFIG_ACPI_CPPC_CPUFREQ_FIE */
 
-static void cppc_cpufreq_update_perf_limits(struct cppc_cpudata *cpu_data,
-					    struct cpufreq_policy *policy)
+static void cppc_cpufreq_get_perf_limits(struct cppc_cpudata *cpu_data,
+					 struct cpufreq_policy *policy,
+					 u32 *min_perf, u32 *max_perf)
 {
 	struct cppc_perf_caps *caps = &cpu_data->perf_caps;
-	u32 min_perf, max_perf;
+	unsigned int min_freq, max_freq;
+	u32 min, max;
+
+	min_freq = READ_ONCE(policy->min);
+	max_freq = READ_ONCE(policy->max);
+	if (unlikely(min_freq > max_freq))
+		min_freq = max_freq;
+
+	min = cppc_khz_to_perf(caps, min_freq);
+	max = cppc_khz_to_perf(caps, max_freq);
 
-	min_perf = cppc_khz_to_perf(caps, policy->min);
-	max_perf = cppc_khz_to_perf(caps, policy->max);
+	*min_perf = clamp_t(u32, min, caps->lowest_perf, caps->highest_perf);
+	*max_perf = clamp_t(u32, max, caps->lowest_perf, caps->highest_perf);
+}
 
-	cpu_data->perf_ctrls.min_perf =
-		clamp_t(u32, min_perf, caps->lowest_perf, caps->highest_perf);
-	cpu_data->perf_ctrls.max_perf =
-		clamp_t(u32, max_perf, caps->lowest_perf, caps->highest_perf);
+static void cppc_cpufreq_update_perf_limits(struct cppc_cpudata *cpu_data,
+					    struct cpufreq_policy *policy)
+{
+	cppc_cpufreq_get_perf_limits(cpu_data, policy,
+				     &cpu_data->perf_ctrls.min_perf,
+				     &cpu_data->perf_ctrls.max_perf);
 }
 
 static int cppc_cpufreq_set_target(struct cpufreq_policy *policy,


