Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4BD30FC3D;
	Tue, 11 Nov 2025 01:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824605; cv=none; b=OqAkbKPZa0aN8V0Zk+A3C/FtIS4J0gFAOX1AxfHxQ0/7cUn3vy7Tk+44PzS/osjTno3soxCY2t7XOy2NYPuN1oD9q3uFmIIqI9mmFo4kJHzcmcWQZ2I+ZhHNCSNHgGlHfA/rssmsoe74W6oeHonEagzxDoG56lQf9fpcPcFginY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824605; c=relaxed/simple;
	bh=kexhX7+9n32yJILKSDP7znhUKDmCuPshhlYTWkroTBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auqpfKMldFuSltfX+t3fvluUf0/NCm3YhDXAqu6ta09kLxIDsKPQWPmvhglU+QDMaLQ/YI40vWIYjSdToKyO2HIJzOYJ7lmCbBGn+HjMnR7r6cn4JPI7LkUquVOX/WxAr6JVlhT0GiMs+AF9gfWVQX+E5eTwOef9ZHE3+2YfcKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjiz9jxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjiz9jxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFD0C116B1;
	Tue, 11 Nov 2025 01:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824605;
	bh=kexhX7+9n32yJILKSDP7znhUKDmCuPshhlYTWkroTBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjiz9jxek2a2kr+mxBhMRwUneoZZw7UW3A8X5YGDeI/IhnkYcG1O4x7cI2XErbrnk
	 3OJpkAssM/D37U7rAu2NYiLO40olt5fVwFvDUBvQCCS9FujoWzk1QXuurfZ5OrMee2
	 1fZYUaXJFe9VytKXTshcLOLjW1PgAPebczC+Wyug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 478/565] cpufreq: tegra186: Initialize all cores to max frequencies
Date: Tue, 11 Nov 2025 09:45:34 +0900
Message-ID: <20251111004537.670279422@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit ba6018929165fc914c665f071f8e8cdbac844a49 ]

During initialization, the EDVD_COREx_VOLT_FREQ registers for some cores
are still at reset values and not reflecting the actual frequency. This
causes get calls to fail. Set all cores to their respective max
frequency during probe to initialize the registers to working values.

Suggested-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra186-cpufreq.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/tegra186-cpufreq.c b/drivers/cpufreq/tegra186-cpufreq.c
index 39186008afbfd..233c82a834086 100644
--- a/drivers/cpufreq/tegra186-cpufreq.c
+++ b/drivers/cpufreq/tegra186-cpufreq.c
@@ -132,13 +132,14 @@ static struct cpufreq_driver tegra186_cpufreq_driver = {
 
 static struct cpufreq_frequency_table *init_vhint_table(
 	struct platform_device *pdev, struct tegra_bpmp *bpmp,
-	struct tegra186_cpufreq_cluster *cluster, unsigned int cluster_id)
+	struct tegra186_cpufreq_cluster *cluster, unsigned int cluster_id,
+	int *num_rates)
 {
 	struct cpufreq_frequency_table *table;
 	struct mrq_cpu_vhint_request req;
 	struct tegra_bpmp_message msg;
 	struct cpu_vhint_data *data;
-	int err, i, j, num_rates = 0;
+	int err, i, j;
 	dma_addr_t phys;
 	void *virt;
 
@@ -168,6 +169,7 @@ static struct cpufreq_frequency_table *init_vhint_table(
 		goto free;
 	}
 
+	*num_rates = 0;
 	for (i = data->vfloor; i <= data->vceil; i++) {
 		u16 ndiv = data->ndiv[i];
 
@@ -178,10 +180,10 @@ static struct cpufreq_frequency_table *init_vhint_table(
 		if (i > 0 && ndiv == data->ndiv[i - 1])
 			continue;
 
-		num_rates++;
+		(*num_rates)++;
 	}
 
-	table = devm_kcalloc(&pdev->dev, num_rates + 1, sizeof(*table),
+	table = devm_kcalloc(&pdev->dev, *num_rates + 1, sizeof(*table),
 			     GFP_KERNEL);
 	if (!table) {
 		table = ERR_PTR(-ENOMEM);
@@ -223,7 +225,9 @@ static int tegra186_cpufreq_probe(struct platform_device *pdev)
 {
 	struct tegra186_cpufreq_data *data;
 	struct tegra_bpmp *bpmp;
-	unsigned int i = 0, err;
+	unsigned int i = 0, err, edvd_offset;
+	int num_rates = 0;
+	u32 edvd_val, cpu;
 
 	data = devm_kzalloc(&pdev->dev,
 			    struct_size(data, clusters, TEGRA186_NUM_CLUSTERS),
@@ -246,10 +250,21 @@ static int tegra186_cpufreq_probe(struct platform_device *pdev)
 	for (i = 0; i < TEGRA186_NUM_CLUSTERS; i++) {
 		struct tegra186_cpufreq_cluster *cluster = &data->clusters[i];
 
-		cluster->table = init_vhint_table(pdev, bpmp, cluster, i);
+		cluster->table = init_vhint_table(pdev, bpmp, cluster, i, &num_rates);
 		if (IS_ERR(cluster->table)) {
 			err = PTR_ERR(cluster->table);
 			goto put_bpmp;
+		} else if (!num_rates) {
+			err = -EINVAL;
+			goto put_bpmp;
+		}
+
+		for (cpu = 0; cpu < ARRAY_SIZE(tegra186_cpus); cpu++) {
+			if (data->cpus[cpu].bpmp_cluster_id == i) {
+				edvd_val = cluster->table[num_rates - 1].driver_data;
+				edvd_offset = data->cpus[cpu].edvd_offset;
+				writel(edvd_val, data->regs + edvd_offset);
+			}
 		}
 	}
 
-- 
2.51.0



