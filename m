Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB1653A7;
	Fri,  6 Dec 2024 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497321; cv=none; b=g8Xs95jnML52lcbVefNijVEjYggC/Dv9ItR488eHfkAvZRMZF6yuSgdkjHbn7HTtIFO7mJfJxq0AiyH05YxuzRQqcErAKwgUGwQou2gb2OVXP9rV6pk+cLWyDPsMxuL2arfg+QmlIY8bIo7UTky8jZy0GB0eeMidiWqqmr8I9uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497321; c=relaxed/simple;
	bh=fw6qYwIkL3uXzFi6csHQzItrap+6IQMSdjnYlrySE7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p74cw7I0sLgUTOpgb22MAveCNh9HWEoyd38ueAtHFXs8ZTro366ZriOjRlS+f5uVJ9ulSOyRXFIxv9mvxya5Z5oOWcxYNHeB6zCIWvSzkDuvky8bWgcPODAlp+lZYSw1ZugwOCahVMnq/VdkQeXxESCedqRZjsJPgrF6XXVVBlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjYCTdB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjYCTdB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9597C4CED1;
	Fri,  6 Dec 2024 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497321;
	bh=fw6qYwIkL3uXzFi6csHQzItrap+6IQMSdjnYlrySE7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjYCTdB4zaO6ClUdkJ7fdlnOhU6QeR236Vs8l4cfYhms8bSncHRAKYGvIWp+zcicK
	 igdvTgketuvAOal3w/FaIPbNjdeNCrU5ZMq+5gKaZA+WSSJubX2LaGnbI7QcrqYpYq
	 8jkgmgnFm1qSQiQhoxfEIek7Lq3DNSHWfRlFPWq0=
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
Subject: [PATCH 6.6 259/676] cppc_cpufreq: Use desired perf if feedback ctrs are 0 or unchanged
Date: Fri,  6 Dec 2024 15:31:18 +0100
Message-ID: <20241206143703.448358871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 15f1d41920a33..9d476264075d8 100644
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
@@ -730,13 +733,31 @@ static int cppc_perf_from_fbctrs(struct cppc_cpudata *cpu_data,
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
@@ -752,18 +773,32 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 
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



