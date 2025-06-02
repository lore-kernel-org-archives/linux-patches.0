Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C501A83E8;
	Mon,  2 Jun 2025 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876849; cv=none; b=KmKU4HPM/VWsTxZsvbb9WoF9itbH/cWV1E/95fFgPs/9yefCMe4tNP02bZWeK/NJ9tLINZVk/sc/Sd/x5xnK4MpIiFtvFa6sCcfKgzrIETOJijkT0ak0dP7pUXU3Mx5zu5w2HFtmqFksWWeNlqGqlu2329NTlFZiSDVk+gmXsgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876849; c=relaxed/simple;
	bh=nuyh4PE76+AXV0+DAeUpwOsz71nONFMZnY9kp80kiZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzXS3avP9Iv7wT+cXowawhfRiKvaToPWcJt+EnuDDJhFkmy7ijObJ4NhSUl2FUmhfpmlOXOyIQ5bTjzC4D3cnYZM4JYZ9rOrqVLTWY5oamGCEc/IeJJinmsR0LJmuFl1xGsikxO0TYVFLYvCOo5ZOspRF9PlO7B3fXQ8wG+8daM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWZE8r7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWZE8r7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152FDC4CEF0;
	Mon,  2 Jun 2025 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876849;
	bh=nuyh4PE76+AXV0+DAeUpwOsz71nONFMZnY9kp80kiZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWZE8r7/LRBjRCk0CyNs8aKV6QNbVxGAkbEdrdIKJUp85Za8xvbLS5+ZR1Lw1scoB
	 8kxxFcUT1yfEF7Hfr19GFc2Vmvg7b1HL1W3PZT8Ng8apsKaYqg1wiIntknLB0FnquM
	 zOvyyco8dNE4IQVYAVRDE4R8u4V6zKc9dDX5uKeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/325] cpufreq: tegra186: Share policy per cluster
Date: Mon,  2 Jun 2025 15:46:09 +0200
Message-ID: <20250602134323.558216005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6c88827f4e625..1d6b543037237 100644
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



