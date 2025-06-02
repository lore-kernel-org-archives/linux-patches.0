Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A652122FE18;
	Mon,  2 Jun 2025 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876158; cv=none; b=Yo85ApMgoZAkQ1ehids3/HA3EyMf3yhyky/lNB52u4hNbHuGfg+M6XJRUAPyDHsM8ri+zbbpQFRAleKUSibYKozq3SRxmmYYptsLo5eei1QWcajrgh6EYPXw+eCC1JC72BKZ/vlo5inf98P4ks+57INbp/D02ccPcoFqxpagVsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876158; c=relaxed/simple;
	bh=vh/A9RSvJj9pu01z/lTUXftNvminbeSsnhBaYuUl+bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLCV8hN63KO3d90KekJTLzj0guB1fn+ulhn62XFjE3J4A2SohRdwa0ipfkwjhwzBHqhcrGQd2NVaDgM9+MWACJP53NhD7hn8q0HzhRvX/T29504q+5LjV9O5wclTSJBwy+FTRdtdQQdBlfi1OeKeVu62cSrd14/jHxZBDsiKK8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1XonqIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1XonqIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3B5C4CEEB;
	Mon,  2 Jun 2025 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876158;
	bh=vh/A9RSvJj9pu01z/lTUXftNvminbeSsnhBaYuUl+bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1XonqInPghM+a7OuC0vqvoGJ1DpGU/Iliv/4BQLkHQ/Hx1STzp093i8zKa2u6eVL
	 NA9RoqHeUklBAvWynfKFAKSq6VWbafTz5BygjzCJQObjwdgiyUjpebJVoFGCTouilw
	 IdnefuvJm9hBWxn58KyyoAprRLvoAnLOygcBTgEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/207] cpufreq: tegra186: Share policy per cluster
Date: Mon,  2 Jun 2025 15:47:11 +0200
Message-ID: <20250602134301.062031152@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

From: Aaron Kling <luceoscutum@gmail.com>

[ Upstream commit be4ae8c19492cd6d5de61ccb34ffb3f5ede5eec8 ]

This functionally brings tegra186 in line with tegra210 and tegra194,
sharing a cpufreq policy between all cores in a cluster.

Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra186-cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/tegra186-cpufreq.c b/drivers/cpufreq/tegra186-cpufreq.c
index 5d1943e787b0c..19597246f9ccb 100644
--- a/drivers/cpufreq/tegra186-cpufreq.c
+++ b/drivers/cpufreq/tegra186-cpufreq.c
@@ -73,11 +73,18 @@ static int tegra186_cpufreq_init(struct cpufreq_policy *policy)
 {
 	struct tegra186_cpufreq_data *data = cpufreq_get_driver_data();
 	unsigned int cluster = data->cpus[policy->cpu].bpmp_cluster_id;
+	u32 cpu;
 
 	policy->freq_table = data->clusters[cluster].table;
 	policy->cpuinfo.transition_latency = 300 * 1000;
 	policy->driver_data = NULL;
 
+	/* set same policy for all cpus in a cluster */
+	for (cpu = 0; cpu < ARRAY_SIZE(tegra186_cpus); cpu++) {
+		if (data->cpus[cpu].bpmp_cluster_id == cluster)
+			cpumask_set_cpu(cpu, policy->cpus);
+	}
+
 	return 0;
 }
 
-- 
2.39.5



