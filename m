Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37EF26A1B6;
	Tue, 11 Nov 2025 01:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825331; cv=none; b=P1VmjzxwdArug+fDA65KrjBm74SWztt+QlaZD0Vhzdl4fnkXVrWOza3vcqo0SUk0HsEaBHjVbCnYti2PqUBW366/aXQ1OzL0pZun6ZP7kkypQ7qN1MVJmwLwq2S7GA9DGzY8l2aX/hXy4kwinGrxxiYaStJwa/59dBnhGnT8ZZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825331; c=relaxed/simple;
	bh=tAPVCmpqUqIOLqKLd6pCxzEXjgQh++LdWFdMMPta3gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RokA4RbjMW4m8XOScm6qJ12ER0QBpR8FtBRAZLdWjPba6gO+cnSIkuUnNHkXptnghY+bLve9mJVs8P7niBG4tc8xEbKZtlFpM9RNpCcCLFQrgJZlMOkr40nHgW5wNeG6lVksB9rrGdO0i6/fWEvp6HMw/gZBk4mLvj6Z6ImyZsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHy4NzGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHy4NzGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E766EC4CEFB;
	Tue, 11 Nov 2025 01:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825331;
	bh=tAPVCmpqUqIOLqKLd6pCxzEXjgQh++LdWFdMMPta3gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHy4NzGsSxvGFn8uLZ9cs+eMmqkZojr4S8j8FlrDMexeAMJWsA7Yab0n5A1ErUOAv
	 hOgQUDVWJErzSXuFah4szlMrv4eho6tfX+7PxI+i5cWTBDUqDGQCOAOpLthpOeuma2
	 AzuaAJrwkX3HvaAVSF7r2FTPGGf9rbExoD3Oas80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 714/849] cpufreq: tegra186: Initialize all cores to max frequencies
Date: Tue, 11 Nov 2025 09:44:44 +0900
Message-ID: <20251111004553.694746981@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6c394b429b618..bd94beebc4cc2 100644
--- a/drivers/cpufreq/tegra186-cpufreq.c
+++ b/drivers/cpufreq/tegra186-cpufreq.c
@@ -138,13 +138,14 @@ static struct cpufreq_driver tegra186_cpufreq_driver = {
 
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
 
@@ -174,6 +175,7 @@ static struct cpufreq_frequency_table *init_vhint_table(
 		goto free;
 	}
 
+	*num_rates = 0;
 	for (i = data->vfloor; i <= data->vceil; i++) {
 		u16 ndiv = data->ndiv[i];
 
@@ -184,10 +186,10 @@ static struct cpufreq_frequency_table *init_vhint_table(
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
@@ -229,7 +231,9 @@ static int tegra186_cpufreq_probe(struct platform_device *pdev)
 {
 	struct tegra186_cpufreq_data *data;
 	struct tegra_bpmp *bpmp;
-	unsigned int i = 0, err;
+	unsigned int i = 0, err, edvd_offset;
+	int num_rates = 0;
+	u32 edvd_val, cpu;
 
 	data = devm_kzalloc(&pdev->dev,
 			    struct_size(data, clusters, TEGRA186_NUM_CLUSTERS),
@@ -252,10 +256,21 @@ static int tegra186_cpufreq_probe(struct platform_device *pdev)
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



