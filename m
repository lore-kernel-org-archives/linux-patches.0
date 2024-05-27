Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5FD262BE;
	Mon, 27 May 2024 19:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838092; cv=none; b=bU+kyVAirP0pMehJoD30n/7axAbpbpXaFMnUJSK7qUNWworNMqZZP1w+LqotcSb9C1r5rAVUPIO2hDt9wzrugeDT9HfLGLONBFNIJuH+cw1pp3Xvn3XgNA1/5zqH/RbQvQOukL7f0yQxIm1mZxYudal27581qCTcA+f7C2qdYAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838092; c=relaxed/simple;
	bh=7Awt9Ru4gDnvmUgcxbOCPWgbh2fzmVL9ZCVpCUtXIkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kthWLgRo4BCtPdxnuWmVjl6AvTm+6YH20dHlcbacfR+hmjOql43azEqaCMOdAij6KxlI0QNdvwnCM1X98BTlF5AAhuLYMUCQgF0yR16I3cIrjiXaX2DUBcEx5JPi4kPRzogBFmtpx9pBLxShHNejzpiZncG08oq2XyOO7qE6WVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BboFJD1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BboFJD1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76061C2BBFC;
	Mon, 27 May 2024 19:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838091;
	bh=7Awt9Ru4gDnvmUgcxbOCPWgbh2fzmVL9ZCVpCUtXIkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BboFJD1zZvam4gTy3ePkkuh8ZPwwsTteZiLEDQ8nURlwZzrvwZYxqaflsEtaGRhJC
	 m818HtvSjppiIKEZOSxbdloGTZuzoDw49yya3bCQW6ZIu3SpOFOYCXFj0FWvhTEZ7g
	 pwh4cU2MkwM2cayD+eLgDlGH2/I6aDb6fZ4Yrmwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 221/493] cppc_cpufreq: Fix possible null pointer dereference
Date: Mon, 27 May 2024 20:53:43 +0200
Message-ID: <20240527185637.534571122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 64420d9cfd1ed..15f1d41920a33 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -741,10 +741,15 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
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
@@ -822,10 +827,15 @@ static struct cpufreq_driver cppc_cpufreq_driver = {
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



