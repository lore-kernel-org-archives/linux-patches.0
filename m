Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3141A336EDA;
	Fri,  9 Jan 2026 12:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962066; cv=none; b=AkyBhhRoFfTpWdvwbPItvGxymKxe+3LqfND4Px+rDOXNXmfWRiFFkkP8gQdulHyuv13dQ0STfEJ1Bj8F0GgAt1laChdB+O6Yg9qPEho3xBcnLF4VpA69aLEcSyFSXWOCzN+6ao7014ppUpL2ecKH1oc7iDv4Krk9TjmhgRvqHSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962066; c=relaxed/simple;
	bh=H4q7bG+TgWJ2NY5tGzPM4954tiN8JVzvsYTSEjfiy80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfR87DTZL4u0Gg3kAmuZY1aPVvir5gcSfp4H4c4veKgAVJHsBy8ICTPzJxuwJ4OYq2IPPMHFZBUIYcmK+hl9u0zbrl2uwteqvKqmaB7Vj3uhxwV90xCCbIcyOTE5z9Butan/mHR5ZB5lt/ElfcvNpmQSBbrUZOrgicJZdT10Lsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWoxKp+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWoxKp+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4648C4CEF1;
	Fri,  9 Jan 2026 12:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962066;
	bh=H4q7bG+TgWJ2NY5tGzPM4954tiN8JVzvsYTSEjfiy80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWoxKp+CrnaZeP90uOw5SvXBcTcjWCjool4W3LUQkp9Xx0iTKSk7HbEB67WRZUGZc
	 1MbMk4meq9DCa3Bxwi6kGbDbfquvmd4gCrD5WLkYy0hGmvgudH523TClnvjPULYNRX
	 CiMEreyENMpFk3mc1Gh8dUdJnhqvPs+683Df0hqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/634] cpufreq: s5pv210: fix refcount leak
Date: Fri,  9 Jan 2026 12:38:32 +0100
Message-ID: <20260109112126.233304967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit 2de5cb96060a1664880d65b120e59485a73588a8 ]

In function `s5pv210_cpu_init`, a possible refcount inconsistency has
been identified, causing a resource leak.

Why it is a bug:
1. For every clk_get, there should be a matching clk_put on every
successive error handling path.
2. After calling `clk_get(dmc1_clk)`, variable `dmc1_clk` will not be
freed even if any error happens.

How it is fixed: For every failed path, an extra goto label is added to
ensure `dmc1_clk` will be freed regardlessly.

Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 76c888ed8d160..d2fa42beae9c2 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -518,7 +518,7 @@ static int s5pv210_cpu_init(struct cpufreq_policy *policy)
 
 	if (policy->cpu != 0) {
 		ret = -EINVAL;
-		goto out_dmc1;
+		goto out;
 	}
 
 	/*
@@ -530,7 +530,7 @@ static int s5pv210_cpu_init(struct cpufreq_policy *policy)
 	if ((mem_type != LPDDR) && (mem_type != LPDDR2)) {
 		pr_err("CPUFreq doesn't support this memory type\n");
 		ret = -EINVAL;
-		goto out_dmc1;
+		goto out;
 	}
 
 	/* Find current refresh counter and frequency each DMC */
@@ -544,6 +544,8 @@ static int s5pv210_cpu_init(struct cpufreq_policy *policy)
 	cpufreq_generic_init(policy, s5pv210_freq_table, 40000);
 	return 0;
 
+out:
+	clk_put(dmc1_clk);
 out_dmc1:
 	clk_put(dmc0_clk);
 out_dmc0:
-- 
2.51.0



