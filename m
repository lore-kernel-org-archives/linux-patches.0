Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC65217F29;
	Sat,  7 Jun 2025 10:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290892; cv=none; b=R9TYgbaQlE8TWLyiH494Z3sS5hVBaZTN07furPviL721ga/N6s/E+hfkLdErMaPwa2Vq68mns6VfGJtmoBxFlRn1PW7KXTbje7VwmQJd5hl+BwZ5FNPst80OGeDnPsUIrrI0YhNohQ8E39+1TgRZU9KHQ278NylSdoMDv4goKvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290892; c=relaxed/simple;
	bh=aTA1IEPPAHcQw8OZS7M4ZG1hf27tbJBpDIw92yB/u8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1CYqZ+26DUIwxwroXJ87rmHpY8Et1p/Pv9XAY6svtxxSvbb1y9s+kZpuEmd0l/UYNQQXLlsiU8DcF4tH090oMC+2NFHxXCC6Iyb6qpIHgfVn/MS3SAH4VcPO5MQo3ms1qyziBsM8liEEVa9R4og5l1PfB8hm2eob53W/IHO530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nt3AAWKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nt3AAWKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CA4C4CEE4;
	Sat,  7 Jun 2025 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290892;
	bh=aTA1IEPPAHcQw8OZS7M4ZG1hf27tbJBpDIw92yB/u8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nt3AAWKhseEd3huiGVxLAT9ok2Zin3eodQ2/T/iYmiUIEdJ09po/mTNeRJQTuVYzH
	 A5ayY3dJeAB3u/le6rj+lER4/bmaPdEOzGgghABy6D9iVSiwJbGKmbShL5eCg5r/+j
	 tqCtAhSLzWZCIIiVG78e5Z3CRFypgYenLgHnc7Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.12 13/24] Revert "cpufreq: tegra186: Share policy per cluster"
Date: Sat,  7 Jun 2025 12:07:44 +0200
Message-ID: <20250607100718.422429163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

This reverts commit d95fdee2253e612216e72f29c65b92ec42d254eb which is
upstream commit be4ae8c19492cd6d5de61ccb34ffb3f5ede5eec8.

This commit is causing a suspend regression on Tegra186 Jetson TX2 with
Linux v6.12.y kernels. This is not seen with Linux v6.15 that includes
this change but indicates that there are there changes missing.
Therefore, revert this change.

Fixes: d95fdee2253e ("cpufreq: tegra186: Share policy per cluster")
Link: https://lore.kernel.org/linux-tegra/bf1dabf7-0337-40e9-8b8e-4e93a0ffd4cc@nvidia.com/
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
 


