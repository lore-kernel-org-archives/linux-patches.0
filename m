Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8DF20ED;
	Thu, 13 Jun 2024 12:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281860; cv=none; b=jNDNcHMruFKjLsBp5yTY0xCeHh4N9eRQ7N+fK77mPIbuDEu0/+4rBkfdlp/veRgDzOuALE8XTJSiCJzMtUniRpT2BMhn+QVdwkjDSEBHDnATsBTFtKDx9z2Nz/oXFYTugO/p2/8BBP0vF6piY/eeGkL5MTdJmKngE6Kvz+mn5Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281860; c=relaxed/simple;
	bh=GvX+ABvDPZcVzHGKLxU9vzo/jhR0JekS7PShJEyOsTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ80SCby++bU4P+TN3ek/O1ZQZECYs85vxOGqZEU07dsafudR2LwR6MikcS4tNpqXkDxmD+c3Yzh691qzsg9oEzmI1nebp2v46Lz7ex2YX4ziizsW1YR50xN249OSMkpVmxAdejF0CTyUtYWKOOJaEvFSKHINTObKjgmFsA3EpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tejz3kux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tejz3kux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9556FC32786;
	Thu, 13 Jun 2024 12:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281860;
	bh=GvX+ABvDPZcVzHGKLxU9vzo/jhR0JekS7PShJEyOsTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tejz3kux84Rj4huWI0rpIKw317CCSuas/lXXG5na3VViGW6v0f1hUoyMzTbpg3cpY
	 izv+2UEUieQKwziv0VMunzsZDW/KK353Qel/drQcNvnesewX31esCfiyAOWHKMi3FF
	 gCop37khMsKKKThKM6Ax4koIUHLDijcl/4PNLpWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/402] cppc_cpufreq: Fix possible null pointer dereference
Date: Thu, 13 Jun 2024 13:30:36 +0200
Message-ID: <20240613113305.217901796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e0ff09d66c96b..17cfa2b92eeec 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -615,10 +615,15 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
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
@@ -697,10 +702,15 @@ static struct cpufreq_driver cppc_cpufreq_driver = {
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



