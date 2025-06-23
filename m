Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E9122370A;
	Mon, 23 Jun 2025 22:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717678; cv=none; b=NgmILE9Bbw5qrL+VxYSFU01pGdLPE3G7fOn0r9lUkLB5T4OdHdTtOT62jm3Yr4BOzbhv4gvh0EZaxyLaoepXy/+I/+t5SI+5YHEL7nWI1kcD0a0lHhmowWev6+3CHyljsrjWnEtMtPz22h1P9QcmmUN3c5OQtPguN6/3Tz0KdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717678; c=relaxed/simple;
	bh=omfFhS7QX1lR7+bORn1tVTkEVB/TaS7nj3PnJaW8/Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpwPIA/oPoPH+pAI/kE2zHUyjcfLJfIEo9QbRNf1enyzFblL9cioJGmlvFGZrvyff/JRttzHh6zNnZ9YvX8JSFEiJLGFShS+fLNvOTy+eu05mnh53C+GC9b4srzkteQxngUOdrqHutERmNNMKase0g87d9qjf5ETOgX8qcLUUUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ1TiU7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ1TiU7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44137C4CEEA;
	Mon, 23 Jun 2025 22:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717678;
	bh=omfFhS7QX1lR7+bORn1tVTkEVB/TaS7nj3PnJaW8/Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ1TiU7xaDyfhqd5Zduri2ZwlVYNJkQ8Uv07fuewPv84Ajda8GyIvYldhQJELvH/o
	 f8Kgmdhv3QrYpI+FEJ4rm+SenJTbdCsTCxYATSqLiu311a4sPMsh0T1zNQ7MDo8BgD
	 e12bNVzzgsEatNmw1NPq74fwlZqwDh7/3Uy272F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.1 500/508] Revert "cpufreq: tegra186: Share policy per cluster"
Date: Mon, 23 Jun 2025 15:09:05 +0200
Message-ID: <20250623130657.316779217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

This reverts commit 89172666228de1cefcacf5bc6f61c6281751d2ed which is
upstream commit be4ae8c19492cd6d5de61ccb34ffb3f5ede5eec8.

This commit is causing a suspend regression on Tegra186 Jetson TX2 with
Linux v6.12.y kernels. This is not seen with Linux v6.15 that includes
this change but indicates that there are there changes missing.
Therefore, revert this change.

Link: https://lore.kernel.org/linux-tegra/bf1dabf7-0337-40e9-8b8e-4e93a0ffd4cc@nvidia.com/
Fixes: 89172666228d ("cpufreq: tegra186: Share policy per cluster")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/tegra186-cpufreq.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/cpufreq/tegra186-cpufreq.c
+++ b/drivers/cpufreq/tegra186-cpufreq.c
@@ -73,18 +73,11 @@ static int tegra186_cpufreq_init(struct
 {
 	struct tegra186_cpufreq_data *data = cpufreq_get_driver_data();
 	unsigned int cluster = data->cpus[policy->cpu].bpmp_cluster_id;
-	u32 cpu;
 
 	policy->freq_table = data->clusters[cluster].table;
 	policy->cpuinfo.transition_latency = 300 * 1000;
 	policy->driver_data = NULL;
 
-	/* set same policy for all cpus in a cluster */
-	for (cpu = 0; cpu < ARRAY_SIZE(tegra186_cpus); cpu++) {
-		if (data->cpus[cpu].bpmp_cluster_id == cluster)
-			cpumask_set_cpu(cpu, policy->cpus);
-	}
-
 	return 0;
 }
 


