Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26318F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7720EC433D2;
	Mon, 13 Feb 2023 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300028;
	bh=GyCGdW6FD89Vetw074HgGvNGB19z9svlks6wk0wps5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPrntCzwLgCJ6t2VLFewk4GWhRopPKRemH7orAIRuwVaWIjmiF/FwLSSfQVOFpoMJ
	 gccZZ2HVLwR9zPIcMvrM3tMhz0PSw2Ffxc3Gwvktr+MqHeSzTLKHghG5TVH6aTPq01
	 eW/eZyqGKVopjnWROtvrlciw4MSCyue3NogLI9w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/114] cpufreq: qcom-hw: Fix cpufreq_driver->get() for non-LMH systems
Date: Mon, 13 Feb 2023 15:47:47 +0100
Message-Id: <20230213144743.824867875@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 51be2fffd65d9f9cb427030ab0ee85d791b4437d ]

On a sc7180-based Chromebook, when I go to
/sys/devices/system/cpu/cpu0/cpufreq I can see:

  cpuinfo_cur_freq:2995200
  cpuinfo_max_freq:1804800
  scaling_available_frequencies:300000 576000 ... 1708800 1804800
  scaling_cur_freq:1804800
  scaling_max_freq:1804800

As you can see the `cpuinfo_cur_freq` is bogus. It turns out that this
bogus info started showing up as of commit c72cf0cb1d77 ("cpufreq:
qcom-hw: Fix the frequency returned by cpufreq_driver->get()"). That
commit seems to assume that everyone is on the LMH bandwagon, but
sc7180 isn't.

Let's go back to the old code in the case where LMH isn't used.

Fixes: c72cf0cb1d77 ("cpufreq: qcom-hw: Fix the frequency returned by cpufreq_driver->get()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
[ Viresh: Fixed the 'fixes' tag ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 3c623a0bc147f..d10bf7635a0d5 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -137,40 +137,42 @@ static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
 	return lval * xo_rate;
 }
 
-/* Get the current frequency of the CPU (after throttling) */
-static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
+/* Get the frequency requested by the cpufreq core for the CPU */
+static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
 {
 	struct qcom_cpufreq_data *data;
+	const struct qcom_cpufreq_soc_data *soc_data;
 	struct cpufreq_policy *policy;
+	unsigned int index;
 
 	policy = cpufreq_cpu_get_raw(cpu);
 	if (!policy)
 		return 0;
 
 	data = policy->driver_data;
+	soc_data = data->soc_data;
 
-	return qcom_lmh_get_throttle_freq(data) / HZ_PER_KHZ;
+	index = readl_relaxed(data->base + soc_data->reg_perf_state);
+	index = min(index, LUT_MAX_ENTRIES - 1);
+
+	return policy->freq_table[index].frequency;
 }
 
-/* Get the frequency requested by the cpufreq core for the CPU */
-static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
+static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
 {
 	struct qcom_cpufreq_data *data;
-	const struct qcom_cpufreq_soc_data *soc_data;
 	struct cpufreq_policy *policy;
-	unsigned int index;
 
 	policy = cpufreq_cpu_get_raw(cpu);
 	if (!policy)
 		return 0;
 
 	data = policy->driver_data;
-	soc_data = data->soc_data;
 
-	index = readl_relaxed(data->base + soc_data->reg_perf_state);
-	index = min(index, LUT_MAX_ENTRIES - 1);
+	if (data->throttle_irq >= 0)
+		return qcom_lmh_get_throttle_freq(data) / HZ_PER_KHZ;
 
-	return policy->freq_table[index].frequency;
+	return qcom_cpufreq_get_freq(cpu);
 }
 
 static unsigned int qcom_cpufreq_hw_fast_switch(struct cpufreq_policy *policy,
-- 
2.39.0



