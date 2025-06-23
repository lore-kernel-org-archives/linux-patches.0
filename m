Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D69A21FF2B;
	Mon, 23 Jun 2025 22:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716620; cv=none; b=HzRpG6Gu4DjpXhVNYzXTiQ9lqpZLhog6wPsTEO+clXOlezYULDuw1u9mSCaaMWl83tPlQ1aW3AH14dwpOzncAqOtopQhBrmLufYSDcRh3DYMoaPfRoJu+nZLpZzDsm6QWJNSN5Z9gi24l24sBhDykcGlCZ2mLh5DTNNhVTAz21M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716620; c=relaxed/simple;
	bh=mo4z+DzLOTVzVOOJbmAvmeJb5C8YWPVHb8Ze6pWIIqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkjxMOiK4ijiyd8r0LTHaGxt3jBlMQ6Qgub7jSEIbj/5Sampdk/Wp7Vk9/kTIoR4KlRd+Nxbom05D2qxkJhfi21txsJtaPXftKDA177SeiO9ta3vsRM39dPgv5TcehwRuM20tzu8BvJUQEsiRYgjbEGUeawROr48ErLJienTKXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHBlhTOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHBlhTOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92FAC4CEEA;
	Mon, 23 Jun 2025 22:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716620;
	bh=mo4z+DzLOTVzVOOJbmAvmeJb5C8YWPVHb8Ze6pWIIqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHBlhTOcTczSOihkVHGei/eoplWTk+PwuhAyxckCfQm8XJRfjuBSQlVL129oIWUx7
	 QXFtr/LJ/3cCjKO3aiWAjEXFeB+yoyhNXqox2IP5u8P6zsa3hx5L7vkn9Zv7/L5J+D
	 wvG761HUhXj8Pd9V9aXJB7VWTivZ0iVMf3yfNw+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.6 277/290] Revert "cpufreq: tegra186: Share policy per cluster"
Date: Mon, 23 Jun 2025 15:08:58 +0200
Message-ID: <20250623130635.256029555@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

This reverts commit ac64f0e893ff370c4d3426c83c1bd0acae75bcf4 which is
upstream commit be4ae8c19492cd6d5de61ccb34ffb3f5ede5eec8.

This commit is causing a suspend regression on Tegra186 Jetson TX2 with
Linux v6.12.y kernels. This is not seen with Linux v6.15 that includes
this change but indicates that there are there changes missing.
Therefore, revert this change.

Fixes: ac64f0e893ff ("cpufreq: tegra186: Share policy per cluster")
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
 


