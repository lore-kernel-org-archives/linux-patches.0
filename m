Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29A0227E95;
	Tue, 29 Apr 2025 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950285; cv=none; b=iuv65QbuVBeRQihvg/uzAwhAQaoBdNyaJArNcM5XNa+snyybRhbqUBo+F3LVRAobNHcDPPRXgLxxeGZPFUOTH40le2YG78PrFnVg8JYq6x+ack4tEjz505StxgaeQXZuRo9Nh3JdiUrBKOx2+2YRpAhvlZnklBSqqzAv108w3QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950285; c=relaxed/simple;
	bh=HzMr5l8wRCSd1Iz8eFjP39CUIHeeihR2yN7u/UJiQtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/5V3MQM1o4E4YQQ9A2yw+PQQmJBnSHfzMkFb/SzkcFgnXJkG+uYO7wBzrgCYRiBfISKyRnCJW8cDDeKlaYKOSulyrsJzAuh0jw5IFMBTP/6WUO8XvVHyfbCvJiXMRpetvIcKjtk8u8UWFCCf7+FYAFAsZRgli5g4k8BECFn8Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/1IaiQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/1IaiQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA2EC4CEE9;
	Tue, 29 Apr 2025 18:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950284;
	bh=HzMr5l8wRCSd1Iz8eFjP39CUIHeeihR2yN7u/UJiQtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/1IaiQt1aPPflUpRy2VTh+MFn08eYm1YGCjhamcQISdbt5nyXxbXlwAKjWVIbP5O
	 88H991k7nbsjkjutxs84RJoBsmckMR0QUiCcg4wvT7IZY+xX4BaI9GOcvaFClTsyyg
	 QGx1FaQ/6tnnSe5CfQsMTfdPinRnRKKM0VEbNGzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/204] cpufreq: apple-soc: Fix null-ptr-deref in apple_soc_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:42:15 +0200
Message-ID: <20250429161101.333562167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 021f423705e1b..9ba6b09775f61 100644
--- a/drivers/cpufreq/apple-soc-cpufreq.c
+++ b/drivers/cpufreq/apple-soc-cpufreq.c
@@ -103,11 +103,17 @@ static const struct of_device_id apple_soc_cpufreq_of_match[] = {
 
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



