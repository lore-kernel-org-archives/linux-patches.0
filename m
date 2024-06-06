Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247311993A0;
	Thu,  6 Jun 2024 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683251; cv=none; b=hTDRJ8l8tkzXsa3O2RkTdgYT5sygVxbW5yJl/UamfD5YwOZzcu4PDwPh2PgQrr/41a0zUfRnxHWqV7BPWF1SdUNJUauVdDN05QmLVcFCTRjMSlCQGNs50A6dQC5wzabw1b0tl3Z+QDak3QZL1OG650LJu9GnM+Qj6FyhslZePlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683251; c=relaxed/simple;
	bh=G4tKwEePAqqVfdacfwcFx308VNBwCcpSZsx8oy1E7K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd/VQajpmrh1esvdfQaNxJcLLjidshZLQ8diHqC/Pqu1BhsitgykvK4VNGqycUThuLYjU0JUA+Yss10T1h4iyOCaOVn3rjY/Q3xb0uEaj1cd35rZqeVu2Z1s0GwFSkmTOxz2D8fcY4y++aEnE2EFHn3bbLT9TMa/FL4QLWJqotI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RX6HVej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RX6HVej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B99C2BD10;
	Thu,  6 Jun 2024 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683251;
	bh=G4tKwEePAqqVfdacfwcFx308VNBwCcpSZsx8oy1E7K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RX6HVejE7hrNHazRSoHJ2/5SAVga4qv45YTAsiC+zxEYc1gNfj08Q7cVsSwEzsbm
	 ZNqgQTwlJ9NAU/UQfgD5VQXOjxIgZ5LQ7mmBnamLehNVNGTE8sVWm4eeOcvRYXlQDt
	 BNZ0UEHG80+vFt0Jc4SzLJtJflV0yuvgxkbhQExw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/473] cppc_cpufreq: Fix possible null pointer dereference
Date: Thu,  6 Jun 2024 16:00:56 +0200
Message-ID: <20240606131704.137943127@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 022e3555407c8..8791a88c7741c 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -841,10 +841,15 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
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
@@ -924,10 +929,15 @@ static struct cpufreq_driver cppc_cpufreq_driver = {
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



