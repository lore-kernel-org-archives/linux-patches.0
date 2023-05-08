Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A21D168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE1C433D2;
	Mon,  8 May 2023 11:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543900;
	bh=TU/YsTim8XUVqbcnXlabFsdQxxX0qY1dNTttIGBX8g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvYsXyIjx3MGv6eohbJCUXCE/dbLuxBs6p10KwFbblBQSocRsuvzBfBK7Rh9FAJPh
	 I2kqs30AtHkewiZnnPm7w9RSqWv+wjZUAYAS99dVjtN3LHbeAxAs+VgAS+AsMdsknP
	 SRExHjJYQYsNGcMDvFnfMIzj/gEJQe4IBxmsT8m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 237/694] cpufreq: qcom-cpufreq-hw: Revert adding cpufreq qos
Date: Mon,  8 May 2023 11:41:12 +0200
Message-Id: <20230508094440.036161241@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit e2b47e585931a988c856fd4ba31e1296f749aee3 ]

The OSM/EPSS hardware controls the frequency of each CPU cluster based
on requests from the OS and various throttling events in the system.
While throttling is in effect the related dcvs interrupt will be kept
high. The purpose of the code handling this interrupt is to
continuously report the thermal pressure based on the throttled
frequency.

The reasoning for adding QoS control to this mechanism is not entirely
clear, but the introduction of commit 'c4c0efb06f17 ("cpufreq:
qcom-cpufreq-hw: Add cpufreq qos for LMh")' causes the
scaling_max_frequncy to be set to the throttled frequency. On the next
iteration of polling, the throttled frequency is above or equal to the
newly requested frequency, so the polling is stopped.

With cpufreq limiting the max frequency, the hardware no longer report a
throttling state and no further updates to thermal pressure or qos
state are made.

The result of this is that scaling_max_frequency can only go down, and
the system becomes slower and slower every time a thermal throttling
event is reported by the hardware.

Even if the logic could be improved, there is no reason for software to
limit the max freqency in response to the hardware limiting the max
frequency. At best software will follow the reported hardware state, but
typically it will cause slower backoff of the throttling.

This reverts commit c4c0efb06f17fa4a37ad99e7752b18a5405c76dc.

Fixes: c4c0efb06f17 ("cpufreq: qcom-cpufreq-hw: Add cpufreq qos for LMh")
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index b2d2907200a9a..9e78640096383 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -14,7 +14,6 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/pm_opp.h>
-#include <linux/pm_qos.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/units.h>
@@ -57,8 +56,6 @@ struct qcom_cpufreq_data {
 	struct clk_hw cpu_clk;
 
 	bool per_core_dcvs;
-
-	struct freq_qos_request throttle_freq_req;
 };
 
 static struct {
@@ -348,8 +345,6 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 
 	throttled_freq = freq_hz / HZ_PER_KHZ;
 
-	freq_qos_update_request(&data->throttle_freq_req, throttled_freq);
-
 	/* Update thermal pressure (the boost frequencies are accepted) */
 	arch_update_thermal_pressure(policy->related_cpus, throttled_freq);
 
@@ -442,14 +437,6 @@ static int qcom_cpufreq_hw_lmh_init(struct cpufreq_policy *policy, int index)
 	if (data->throttle_irq < 0)
 		return data->throttle_irq;
 
-	ret = freq_qos_add_request(&policy->constraints,
-				   &data->throttle_freq_req, FREQ_QOS_MAX,
-				   FREQ_QOS_MAX_DEFAULT_VALUE);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to add freq constraint (%d)\n", ret);
-		return ret;
-	}
-
 	data->cancel_throttle = false;
 	data->policy = policy;
 
@@ -516,7 +503,6 @@ static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
 	if (data->throttle_irq <= 0)
 		return;
 
-	freq_qos_remove_request(&data->throttle_freq_req);
 	free_irq(data->throttle_irq, data);
 }
 
-- 
2.39.2



