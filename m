Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60A222581;
	Mon, 23 Jun 2025 21:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715788; cv=none; b=I8a05cveQrT2Y6uiwb9cU/cNVJsalZ0gGS8nMG+5YM3IXtNSB7cpA+Y6pgp412d1+b+D8p7QUH6bXGFDKySW/C/ZbaR4GXBQW/WNJ/fwCw5kQGi+VopT0LVcw2zAHvtbD7xVio6qIgP3lVqOdQfUqQYJx5Dq55E+Ai1ImrKpgjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715788; c=relaxed/simple;
	bh=k7KcV2ZwDAm3pGw0S0ohookRH3XxrZo9Cep6eeNhij4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCo5Qobrwdr0YDYb0lIv1yBGogl9lAyGP4uXclRJwwzLxtGRq7IQLtT5uwIrkcjjKEX8t7c/1PaFwfX7+0IeJ0s9DMA/SW3Yzqo9S83Ezh1Kb3+TDBmumew8Blj5Hi+Vj1uAKWdo+M+K8xHeGJZ06oommJDVslu72XfIC1DvvzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AdYjQRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AdYjQRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780D0C4CEEA;
	Mon, 23 Jun 2025 21:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715787;
	bh=k7KcV2ZwDAm3pGw0S0ohookRH3XxrZo9Cep6eeNhij4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AdYjQRt8a/EjcYK0L7mzygW4K6EVqAYu0f5gJqeH2gwf6LXRDmJnZalwzog9pbD1
	 1jmtI7aNbRzfvJyuTgYiXmbOKYArTwHsGnx+X7bqBYkxjLIWwJ2QTmAlChrprwmIgR
	 B1RBiIryaNUcczT78YVJmFTqdmEpBO3O9j6NiRGc=
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
Subject: [PATCH 6.12 207/414] cpufreq: scmi: Skip SCMI devices that arent used by the CPUs
Date: Mon, 23 Jun 2025 15:05:44 +0200
Message-ID: <20250623130647.182169272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7e7c1613a67c6..beb660ca240cc 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -367,6 +367,40 @@ static struct cpufreq_driver scmi_cpufreq_driver = {
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
@@ -375,7 +409,7 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
 	handle = sdev->handle;
 
-	if (!handle)
+	if (!handle || !scmi_dev_used_by_cpus(dev))
 		return -ENODEV;
 
 	perf_ops = handle->devm_protocol_get(sdev, SCMI_PROTOCOL_PERF, &ph);
-- 
2.39.5



