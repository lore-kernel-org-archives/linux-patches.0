Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50C71519BE;
	Wed,  5 Feb 2025 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765131; cv=none; b=raeb5EjFZvA59epx1Lchb75vNpKyW6X1s2a4jy+3HmvXmk/+SYTXNwZK7WL2ZF4tvzC9Z842Iy/+yDOFlP+qFRk9DSemq/Q+vVaGINVCIHH300wEUipugCznPOhW46lHVe+esKPLg5hREDYAFB+XrPi+EfmC6TG8Z8qyHJNTY4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765131; c=relaxed/simple;
	bh=9bbhJLKCHdUX/NivN5NcYAMbkEJSCWOItz+xkAvAD/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE5gszRTT4htlUscPTUhciYPadGwFzZTQFlTMnyY5Zb139Efgx3+TGukvXcsdjIlVELM4vg8/MzTq6hLWSM7oufnr/L8hrtzdnGWuMphPat9s9Nv4md5k2/E2rXWdMArJDYFPC+egqm3yyglNo2Mu8UkyZOhnwMt1YYOZIssqSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VD1kueKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VD1kueKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41938C4CED1;
	Wed,  5 Feb 2025 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765131;
	bh=9bbhJLKCHdUX/NivN5NcYAMbkEJSCWOItz+xkAvAD/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VD1kueKs4Jqiw9sFg4B7+YWil6t4CoVYkRlflOHWA0bf/cxTwsXNZ7FCRPAq3ewyg
	 uqpfjq1kHQrF8/5s/D90qu1uKRbFlswhBGJ97V7uXTTSB960WRhjMhfBy2xxvMx9AO
	 O6PerywRIoub4qnTbR4ejUOXxR013WuedoYAgvsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 127/623] cpufreq: qcom: Fix qcom_cpufreq_hw_recalc_rate() to query LUT if LMh IRQ is not available
Date: Wed,  5 Feb 2025 14:37:49 +0100
Message-ID: <20250205134501.085011055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 85d8b11351a8f15d6ec7a5e97909861cb3b6bcec ]

Currently, qcom_cpufreq_hw_recalc_rate() returns the LMh throttled
frequency for the domain even if LMh IRQ is not available. But as per
qcom_cpufreq_hw_get(), the driver has to query LUT entries to get the
actual frequency of the domain. So do the same in
qcom_cpufreq_hw_recalc_rate().

While doing so, refactor the existing qcom_cpufreq_hw_get() function so
that qcom_cpufreq_hw_recalc_rate() can make use of the existing code and
avoid code duplication. This also requires setting the
qcom_cpufreq_data::policy even if LMh IRQ is not available.

Fixes: 4370232c727b ("cpufreq: qcom-hw: Add CPU clock provider support")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 98129565acb8e..c145ab7b0bb21 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -143,14 +143,12 @@ static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
 }
 
 /* Get the frequency requested by the cpufreq core for the CPU */
-static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
+static unsigned int qcom_cpufreq_get_freq(struct cpufreq_policy *policy)
 {
 	struct qcom_cpufreq_data *data;
 	const struct qcom_cpufreq_soc_data *soc_data;
-	struct cpufreq_policy *policy;
 	unsigned int index;
 
-	policy = cpufreq_cpu_get_raw(cpu);
 	if (!policy)
 		return 0;
 
@@ -163,12 +161,10 @@ static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
 	return policy->freq_table[index].frequency;
 }
 
-static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
+static unsigned int __qcom_cpufreq_hw_get(struct cpufreq_policy *policy)
 {
 	struct qcom_cpufreq_data *data;
-	struct cpufreq_policy *policy;
 
-	policy = cpufreq_cpu_get_raw(cpu);
 	if (!policy)
 		return 0;
 
@@ -177,7 +173,12 @@ static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
 	if (data->throttle_irq >= 0)
 		return qcom_lmh_get_throttle_freq(data) / HZ_PER_KHZ;
 
-	return qcom_cpufreq_get_freq(cpu);
+	return qcom_cpufreq_get_freq(policy);
+}
+
+static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
+{
+	return __qcom_cpufreq_hw_get(cpufreq_cpu_get_raw(cpu));
 }
 
 static unsigned int qcom_cpufreq_hw_fast_switch(struct cpufreq_policy *policy,
@@ -363,7 +364,7 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 	 * If h/w throttled frequency is higher than what cpufreq has requested
 	 * for, then stop polling and switch back to interrupt mechanism.
 	 */
-	if (throttled_freq >= qcom_cpufreq_get_freq(cpu))
+	if (throttled_freq >= qcom_cpufreq_get_freq(cpufreq_cpu_get_raw(cpu)))
 		enable_irq(data->throttle_irq);
 	else
 		mod_delayed_work(system_highpri_wq, &data->throttle_work,
@@ -441,7 +442,6 @@ static int qcom_cpufreq_hw_lmh_init(struct cpufreq_policy *policy, int index)
 		return data->throttle_irq;
 
 	data->cancel_throttle = false;
-	data->policy = policy;
 
 	mutex_init(&data->throttle_lock);
 	INIT_DEFERRABLE_WORK(&data->throttle_work, qcom_lmh_dcvs_poll);
@@ -552,6 +552,7 @@ static int qcom_cpufreq_hw_cpu_init(struct cpufreq_policy *policy)
 
 	policy->driver_data = data;
 	policy->dvfs_possible_from_any_cpu = true;
+	data->policy = policy;
 
 	ret = qcom_cpufreq_hw_read_lut(cpu_dev, policy);
 	if (ret) {
@@ -622,7 +623,7 @@ static unsigned long qcom_cpufreq_hw_recalc_rate(struct clk_hw *hw, unsigned lon
 {
 	struct qcom_cpufreq_data *data = container_of(hw, struct qcom_cpufreq_data, cpu_clk);
 
-	return qcom_lmh_get_throttle_freq(data);
+	return __qcom_cpufreq_hw_get(data->policy) * HZ_PER_KHZ;
 }
 
 static const struct clk_ops qcom_cpufreq_hw_clk_ops = {
-- 
2.39.5



