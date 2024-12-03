Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2CD1F76BA;
	Tue,  3 Dec 2024 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238817; cv=none; b=FL+cxjElNqk/G54YLszW0LmqWDNH9GQ/fCBic6cTZFkDbvQNCkLlytkCNScMlMy73wqFNlDRwEyNr99QVAotwczatvCQpgjWAjdiQve4W9MiGfyEzy9BQuPwOEOzgSj28sg7Af+uiL8PsTCP5sdZRHzLP4oX/PIa6DjcMPWXbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238817; c=relaxed/simple;
	bh=sVJslK/sFIuPpSE+z90dA8ENT/GzFO8LQGhePOROnHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAsmxmOkSf+AgZgbCZjygR+qKnBo88mTiTFAXWNfId5Y/+wMm+EnE/4XB/UUbrpFzh62B1QlQcSBdnVxeD4Mzm1HgdW6sf/eLJnAfSOXBBFP8bCIDUepETHu+8WIaRraaTFc65vZkBtEFLO91WvwAnG3xeasSI+Efs1t5X98WxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6pSHTrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6pSHTrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A41C4CECF;
	Tue,  3 Dec 2024 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238816;
	bh=sVJslK/sFIuPpSE+z90dA8ENT/GzFO8LQGhePOROnHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6pSHTrmJ5saNoLlk8ecRLL1nOMYn0HMcnwAEaDdgSrY4gsefx0fK3ycmvH+/r2V1
	 can+BSxlRw67zfsKPZokPk/OAlt4AoYKp4VEKYcIhAAN2Go9Nfw4cu6hDH46QKVaW+
	 +JxeUjPGkBjux8rYNsGZuXGHacOOjww38sl0HIb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Ionela Voinescu <ionela.voinescu@arm.com>,
	Huisong Li <lihuisong@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 375/817] cppc_cpufreq: Use desired perf if feedback ctrs are 0 or unchanged
Date: Tue,  3 Dec 2024 15:39:07 +0100
Message-ID: <20241203144010.482901328@linuxfoundation.org>
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

From: Jie Zhan <zhanjie9@hisilicon.com>

[ Upstream commit c47195631960b626058c335aec31f186fa854f97 ]

The CPPC performance feedback counters could be 0 or unchanged when the
target cpu is in a low-power idle state, e.g. power-gated or clock-gated.

When the counters are 0, cppc_cpufreq_get_rate() returns 0 KHz, which makes
cpufreq_online() get a false error and fail to generate a cpufreq policy.

When the counters are unchanged, the existing cppc_perf_from_fbctrs()
returns a cached desired perf, but some platforms may update the real
frequency back to the desired perf reg.

For the above cases in cppc_cpufreq_get_rate(), get the latest desired perf
from the CPPC reg to reflect the frequency because some platforms may
update the actual frequency back there; if failed, use the cached desired
perf.

Fixes: 6a4fec4f6d30 ("cpufreq: cppc: cppc_cpufreq_get_rate() returns zero in all error cases.")
Signed-off-by: Jie Zhan <zhanjie9@hisilicon.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Ionela Voinescu <ionela.voinescu@arm.com>
Reviewed-by: Huisong Li <lihuisong@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 57 +++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index bafa32dd375d5..357dc7f4a98ce 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -118,6 +118,9 @@ static void cppc_scale_freq_workfn(struct kthread_work *work)
 
 	perf = cppc_perf_from_fbctrs(cpu_data, &cppc_fi->prev_perf_fb_ctrs,
 				     &fb_ctrs);
+	if (!perf)
+		return;
+
 	cppc_fi->prev_perf_fb_ctrs = fb_ctrs;
 
 	perf <<= SCHED_CAPACITY_SHIFT;
@@ -724,13 +727,31 @@ static int cppc_perf_from_fbctrs(struct cppc_cpudata *cpu_data,
 	delta_delivered = get_delta(fb_ctrs_t1->delivered,
 				    fb_ctrs_t0->delivered);
 
-	/* Check to avoid divide-by zero and invalid delivered_perf */
+	/*
+	 * Avoid divide-by zero and unchanged feedback counters.
+	 * Leave it for callers to handle.
+	 */
 	if (!delta_reference || !delta_delivered)
-		return cpu_data->perf_ctrls.desired_perf;
+		return 0;
 
 	return (reference_perf * delta_delivered) / delta_reference;
 }
 
+static int cppc_get_perf_ctrs_sample(int cpu,
+				     struct cppc_perf_fb_ctrs *fb_ctrs_t0,
+				     struct cppc_perf_fb_ctrs *fb_ctrs_t1)
+{
+	int ret;
+
+	ret = cppc_get_perf_ctrs(cpu, fb_ctrs_t0);
+	if (ret)
+		return ret;
+
+	udelay(2); /* 2usec delay between sampling */
+
+	return cppc_get_perf_ctrs(cpu, fb_ctrs_t1);
+}
+
 static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 {
 	struct cppc_perf_fb_ctrs fb_ctrs_t0 = {0}, fb_ctrs_t1 = {0};
@@ -746,18 +767,32 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 
 	cpufreq_cpu_put(policy);
 
-	ret = cppc_get_perf_ctrs(cpu, &fb_ctrs_t0);
-	if (ret)
-		return 0;
-
-	udelay(2); /* 2usec delay between sampling */
-
-	ret = cppc_get_perf_ctrs(cpu, &fb_ctrs_t1);
-	if (ret)
-		return 0;
+	ret = cppc_get_perf_ctrs_sample(cpu, &fb_ctrs_t0, &fb_ctrs_t1);
+	if (ret) {
+		if (ret == -EFAULT)
+			/* Any of the associated CPPC regs is 0. */
+			goto out_invalid_counters;
+		else
+			return 0;
+	}
 
 	delivered_perf = cppc_perf_from_fbctrs(cpu_data, &fb_ctrs_t0,
 					       &fb_ctrs_t1);
+	if (!delivered_perf)
+		goto out_invalid_counters;
+
+	return cppc_perf_to_khz(&cpu_data->perf_caps, delivered_perf);
+
+out_invalid_counters:
+	/*
+	 * Feedback counters could be unchanged or 0 when a cpu enters a
+	 * low-power idle state, e.g. clock-gated or power-gated.
+	 * Use desired perf for reflecting frequency.  Get the latest register
+	 * value first as some platforms may update the actual delivered perf
+	 * there; if failed, resort to the cached desired perf.
+	 */
+	if (cppc_get_desired_perf(cpu, &delivered_perf))
+		delivered_perf = cpu_data->perf_ctrls.desired_perf;
 
 	return cppc_perf_to_khz(&cpu_data->perf_caps, delivered_perf);
 }
-- 
2.43.0



