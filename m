Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC491B87D9;
	Mon, 23 Jun 2025 21:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715902; cv=none; b=WMrbp9VuTjM3f2WkxbV4telLod8xIvMj47UE6Z6tNriljX1onkEtMAIX50/Dd/gI+795bhSsaj3ITgoB+wM3CmLX/zyqX850JC6zvyPsV4/3Lsq2akW4i9LDDaB+UyXrGy/VWKNPnWADS+kuThYEqkL/whTjMtJkyqHVBY/x61E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715902; c=relaxed/simple;
	bh=e8PzW024Y6EEUdTjfI5iUg/cQeeVTvaPG3JbuHMfOOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scWZ8MqHMwKtj2HcOzVOKw+/QPUboKe00iVH0FaCJE5Ql1uG0WldTCjJELfqV8e+mrmcukQgkG/mLBi1a0f6a4/y96MfheEnMQRwbTSrBCUQhd0Bope7H7op1VdsBNKYrsQTSrTZ8SPEfE3rbN2tAyxBdS+YBBRgWrEY6j9rn9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAN16PCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAN16PCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A11C4CEEA;
	Mon, 23 Jun 2025 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715902;
	bh=e8PzW024Y6EEUdTjfI5iUg/cQeeVTvaPG3JbuHMfOOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAN16PCm0lGqRsfpaz6AB3RnoxPVvEMj+8lML/ELdpVYLZ9C0TYjLWreyCEPkWv+q
	 +5TD60tismJd57YaxkHulDBXV6saYXJn15nW7k+mTaMB+aH2q8d1Ia3QNaO0LzT/Ix
	 Ts0QkNRffgNQQFotnubad9NZGtT0wsT9e7nVpfLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Peng Fan <peng.fan@nxp.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/411] cpufreq: scmi: Skip SCMI devices that arent used by the CPUs
Date: Mon, 23 Jun 2025 15:07:35 +0200
Message-ID: <20250623130641.470159723@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit 6c9bb86922728c7a4cceb99f131e00dd87514f20 ]

Currently, all SCMI devices with performance domains attempt to register
a cpufreq driver, even if their performance domains aren't used to
control the CPUs. The cpufreq framework only supports registering a
single driver, so only the first device will succeed. And if that device
isn't used for the CPUs, then cpufreq will scale the wrong domains.

To avoid this, return early from scmi_cpufreq_probe() if the probing
SCMI device isn't referenced by the CPU device phandles.

This keeps the existing assumption that all CPUs are controlled by a
single SCMI device.

Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 36 +++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index 8c9c2f710790f..1f12109526fa6 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -288,6 +288,40 @@ static struct cpufreq_driver scmi_cpufreq_driver = {
 	.register_em	= scmi_cpufreq_register_em,
 };
 
+static bool scmi_dev_used_by_cpus(struct device *scmi_dev)
+{
+	struct device_node *scmi_np = dev_of_node(scmi_dev);
+	struct device_node *cpu_np, *np;
+	struct device *cpu_dev;
+	int cpu, idx;
+
+	if (!scmi_np)
+		return false;
+
+	for_each_possible_cpu(cpu) {
+		cpu_dev = get_cpu_device(cpu);
+		if (!cpu_dev)
+			continue;
+
+		cpu_np = dev_of_node(cpu_dev);
+
+		np = of_parse_phandle(cpu_np, "clocks", 0);
+		of_node_put(np);
+
+		if (np == scmi_np)
+			return true;
+
+		idx = of_property_match_string(cpu_np, "power-domain-names", "perf");
+		np = of_parse_phandle(cpu_np, "power-domains", idx);
+		of_node_put(np);
+
+		if (np == scmi_np)
+			return true;
+	}
+
+	return false;
+}
+
 static int scmi_cpufreq_probe(struct scmi_device *sdev)
 {
 	int ret;
@@ -296,7 +330,7 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
 	handle = sdev->handle;
 
-	if (!handle)
+	if (!handle || !scmi_dev_used_by_cpus(dev))
 		return -ENODEV;
 
 	perf_ops = handle->devm_protocol_get(sdev, SCMI_PROTOCOL_PERF, &ph);
-- 
2.39.5



