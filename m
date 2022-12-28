Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411541863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4B8C433D2;
	Wed, 28 Dec 2022 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240497;
	bh=L9uaAJVPkUxFgkF0AHkAQx6gIJFm08x9VflOILVfPm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CejVpCoHn2IROoxZ+1HrAAEYR8oKSIpHvX9zAdJzXF9AYcIZW3FU6ryAylqG92vi
	 3LmvpbrQgq2TgWwTXg98cLMgjgZilsdzK/HVxb9oqHfMw8FD5Nnduzcnwte+tQqzZO
	 IEhfYFjV0UVKuzj7WmcLqjCYJttAXVRs5ZNCBpfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0132/1146] cpufreq: qcom-hw: Fix the frequency returned by cpufreq_driver->get()
Date: Wed, 28 Dec 2022 15:27:51 +0100
Message-Id: <20221228144333.736941252@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit c72cf0cb1d77f6b1b58c334dcc3d09fa13111c4c ]

The cpufreq_driver->get() callback is supposed to return the current
frequency of the CPU and not the one requested by the CPUFreq core.
Fix it by returning the frequency that gets supplied to the CPU after
the DCVS operation of EPSS/OSM.

Fixes: 2849dd8bc72b ("cpufreq: qcom-hw: Add support for QCOM cpufreq HW driver")
Reported-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 42 +++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index d15097549e8c..3c623a0bc147 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -125,7 +125,35 @@ static int qcom_cpufreq_hw_target_index(struct cpufreq_policy *policy,
 	return 0;
 }
 
+static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
+{
+	unsigned int lval;
+
+	if (data->soc_data->reg_current_vote)
+		lval = readl_relaxed(data->base + data->soc_data->reg_current_vote) & 0x3ff;
+	else
+		lval = readl_relaxed(data->base + data->soc_data->reg_domain_state) & 0xff;
+
+	return lval * xo_rate;
+}
+
+/* Get the current frequency of the CPU (after throttling) */
 static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
+{
+	struct qcom_cpufreq_data *data;
+	struct cpufreq_policy *policy;
+
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (!policy)
+		return 0;
+
+	data = policy->driver_data;
+
+	return qcom_lmh_get_throttle_freq(data) / HZ_PER_KHZ;
+}
+
+/* Get the frequency requested by the cpufreq core for the CPU */
+static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
 {
 	struct qcom_cpufreq_data *data;
 	const struct qcom_cpufreq_soc_data *soc_data;
@@ -287,18 +315,6 @@ static void qcom_get_related_cpus(int index, struct cpumask *m)
 	}
 }
 
-static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
-{
-	unsigned int lval;
-
-	if (data->soc_data->reg_current_vote)
-		lval = readl_relaxed(data->base + data->soc_data->reg_current_vote) & 0x3ff;
-	else
-		lval = readl_relaxed(data->base + data->soc_data->reg_domain_state) & 0xff;
-
-	return lval * xo_rate;
-}
-
 static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 {
 	struct cpufreq_policy *policy = data->policy;
@@ -342,7 +358,7 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 	 * If h/w throttled frequency is higher than what cpufreq has requested
 	 * for, then stop polling and switch back to interrupt mechanism.
 	 */
-	if (throttled_freq >= qcom_cpufreq_hw_get(cpu))
+	if (throttled_freq >= qcom_cpufreq_get_freq(cpu))
 		enable_irq(data->throttle_irq);
 	else
 		mod_delayed_work(system_highpri_wq, &data->throttle_work,
-- 
2.35.1



