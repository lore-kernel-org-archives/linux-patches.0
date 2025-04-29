Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819EA2459EA;
	Tue, 29 Apr 2025 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947617; cv=none; b=DBEkA42Q6PyWluyeO20Hi26hEitJAM3TpQkhEtGfdWD9+J2fm52/CEFuNVCLB7PrPqwLaXK4Ncr8gdyhRMDIrDxb54edJXnHVbRliAwljlaYLo8gHvABZ/stm/Cj4gx9ki5IESmfDJMTYk1bcJtS+GJ/YNuGMVA/2WLIxOEsIKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947617; c=relaxed/simple;
	bh=PH6J1WyMC/D8h4xM9cB5Y+XHHuQR9gxIcM5EBlJpVnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFDb3qRa/mBNLLGemshKsBNKS8NTfF2f5zOwaVAS4FNVrK8/oNpPVKDEaV18Mx1A7IBMFBg/6cV4FvRxsydtnkf50yAaiPvlFVEUBQCe7sfyw/dcGXyGjnRsE9mKfwndm0KLvskzA3SCDtR12V3UVWIxNsXxycRwrapVe7rMSvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2L9cIA64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2L9cIA64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3BCC4CEEA;
	Tue, 29 Apr 2025 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947617;
	bh=PH6J1WyMC/D8h4xM9cB5Y+XHHuQR9gxIcM5EBlJpVnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2L9cIA64VMLY13KfrrZl/QFFMdX0VfZvOpqBlFugRmC7VUPv5FAjR97fLsQPLhRV1
	 zbFy8IjabPQm7pGAd0Crwh30rHHMUlPGrvP+gTOn/drSgvOggZfqGvMaxVVklRU6EW
	 DG53LQEAYSP7wMGzwDNFOI0yHdSS4F2ZEWet47qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/280] cpufreq: apple-soc: Fix null-ptr-deref in apple_soc_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:39:54 +0200
Message-ID: <20250429161117.292469328@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 9992649f6786921873a9b89dafa5e04d8c5fef2b ]

cpufreq_cpu_get_raw() can return NULL when the target CPU is not present
in the policy->cpus mask. apple_soc_cpufreq_get_rate() does not check
for this case, which results in a NULL pointer dereference.

Fixes: 6286bbb40576 ("cpufreq: apple-soc: Add new driver to control Apple SoC CPU P-states")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/apple-soc-cpufreq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/apple-soc-cpufreq.c b/drivers/cpufreq/apple-soc-cpufreq.c
index 4dcacab9b4bf2..ddf7dcb3e9b0b 100644
--- a/drivers/cpufreq/apple-soc-cpufreq.c
+++ b/drivers/cpufreq/apple-soc-cpufreq.c
@@ -103,11 +103,17 @@ static const struct of_device_id apple_soc_cpufreq_of_match[] __maybe_unused = {
 
 static unsigned int apple_soc_cpufreq_get_rate(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get_raw(cpu);
-	struct apple_cpu_priv *priv = policy->driver_data;
+	struct cpufreq_policy *policy;
+	struct apple_cpu_priv *priv;
 	struct cpufreq_frequency_table *p;
 	unsigned int pstate;
 
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (unlikely(!policy))
+		return 0;
+
+	priv = policy->driver_data;
+
 	if (priv->info->cur_pstate_mask) {
 		u64 reg = readq_relaxed(priv->reg_base + APPLE_DVFS_STATUS);
 
-- 
2.39.5



