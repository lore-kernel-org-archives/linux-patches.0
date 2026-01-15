Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB23BC4D8;
	Thu, 15 Jan 2026 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499268; cv=none; b=nT/I8zh/0aVmJcykZRBURbtZ1FL2sGDodsmb3qvZWzGgUP94eJ94sOtVr11Om3q4D8LZW8FpNdpPX0ff/UcdgE5f1oR+czLUM2lmXa3zmLdbrEATmE79HwIFgc58E4AoQQ9+x14u49e3EimlvowH26J4fFBtWGn4pqNCKbMtRLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499268; c=relaxed/simple;
	bh=FBZMR+GVAILah3JNNegM1kA+jz0hv7WtG5VikFnjiMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCIwXf+y/OD4AZ/FDeWz5Hn2qpVkcq57oqYlW7nfk9pp4YyxrnjDWdu+iyUkLTM0KJ/+rkKYPX0GFPL4coXh/SdoVFGIQwnF/us/+qVcAqfujUJ8a+wmcN33R/UdMII2osXEtBKZJAy7+/TZLlmIXrrLh9axVEubXW6vfzKyeSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfUbL6mL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfUbL6mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C9DC116D0;
	Thu, 15 Jan 2026 17:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499268;
	bh=FBZMR+GVAILah3JNNegM1kA+jz0hv7WtG5VikFnjiMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfUbL6mLpcwPyl3ED+AEtigPTzCsICt6Hgt83pJS+K/g1S8BDi1q9tMCWRWAmUKfy
	 +db2LCGa4ryg4tP8OkdcItAigxH1Nai/378BaFoza51WFoS5d9csksdvhGzCCE0DSK
	 wMK2I8jsT+VE5HLPc3C6vGCHq1U7tj57Me4zphNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/451] cpufreq: s5pv210: fix refcount leak
Date: Thu, 15 Jan 2026 17:46:01 +0100
Message-ID: <20260115164236.699687452@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bed496cf8d247..f95b4658097a6 100644
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



