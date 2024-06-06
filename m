Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2339C196D9B;
	Thu,  6 Jun 2024 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683249; cv=none; b=TDjRo5B6zHDPIy8iGCDKKiAtaCG1RTSKe9GNwXeY0r+Fm3uWzyi1BpCDVo5TBoHDf1hHV69MspQvmpyb6+G9+hLXc91dIp8pxP7s4NLlbT6gi4PEnEZWs0wTBen69QsgsAhf+9Q8ps5grSnPw7ODLWJEj7mo7h2dqPPt/VjGWXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683249; c=relaxed/simple;
	bh=CAN4viD62BYdDL7AbFRFQ3QqueL74X/4dj82+uBqHGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHgsdr1mffwU/u/0AIxPsQ1lCl4KsPgFzr8IcOPjViVAa7nJrdlsJMcYxM3Wzc2xMBRUtD2twqxGJTsGA76ps/XxmmZStBg18n9zV9JZOLrR3eHCth+kw+gn2A494nyRX95gqbhdN5s02+/NHLxAPMY3ZkHUEFwMkAZf093UG3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIuLMF/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIuLMF/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFF1C32781;
	Thu,  6 Jun 2024 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683249;
	bh=CAN4viD62BYdDL7AbFRFQ3QqueL74X/4dj82+uBqHGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIuLMF/FJoCUXouL0UnGZ06StZtLnlMk2sbtCQihtMzBnPqvKvt+z2J1oeFY5ixzN
	 K42YgCfk67C0YNtR9BWMjrNs237WeYtyzYu4j/UidfJmizNvN3D1FOtsGgY8dRMo6+
	 Y5y4tK9iz3rTPvkOi/asrnzVL95nS0N6M3XyGPCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/744] cppc_cpufreq: Fix possible null pointer dereference
Date: Thu,  6 Jun 2024 15:57:27 +0200
Message-ID: <20240606131738.047282958@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit cf7de25878a1f4508c69dc9f6819c21ba177dbfe ]

cppc_cpufreq_get_rate() and hisi_cppc_cpufreq_get_rate() can be called from
different places with various parameters. So cpufreq_cpu_get() can return
null as 'policy' in some circumstances.
Fix this bug by adding null return check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a28b2bfc099c ("cppc_cpufreq: replace per-cpu data array with a list")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index fe08ca419b3dc..1ba3943be8a3d 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -844,10 +844,15 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 {
 	struct cppc_perf_fb_ctrs fb_ctrs_t0 = {0}, fb_ctrs_t1 = {0};
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	struct cppc_cpudata *cpu_data = policy->driver_data;
+	struct cppc_cpudata *cpu_data;
 	u64 delivered_perf;
 	int ret;
 
+	if (!policy)
+		return -ENODEV;
+
+	cpu_data = policy->driver_data;
+
 	cpufreq_cpu_put(policy);
 
 	ret = cppc_get_perf_ctrs(cpu, &fb_ctrs_t0);
@@ -927,10 +932,15 @@ static struct cpufreq_driver cppc_cpufreq_driver = {
 static unsigned int hisi_cppc_cpufreq_get_rate(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	struct cppc_cpudata *cpu_data = policy->driver_data;
+	struct cppc_cpudata *cpu_data;
 	u64 desired_perf;
 	int ret;
 
+	if (!policy)
+		return -ENODEV;
+
+	cpu_data = policy->driver_data;
+
 	cpufreq_cpu_put(policy);
 
 	ret = cppc_get_desired_perf(cpu, &desired_perf);
-- 
2.43.0



