Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC62DECC4;
	Tue,  8 Jul 2025 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992985; cv=none; b=TR92F5/I3nqhwjbmpYlzV6fw9lN4sEpDKFseAld+s5VCPhfEtSd88BC9AFzvuPmb8B7vD7xQa7bI7uZCNjwu+eG2S1jI4gI+3HAZoR9BRnu65P2GJrrLttwiXP8dNVj5eZqkAVGzhLL4LrKy8V+s+FbzxzC3PNSLR3/8YvlCfXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992985; c=relaxed/simple;
	bh=3ps+4Nb/Bt+ppRnaXVLnE4Or9WlfBHTPT7hp2UulKBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtGnpdAIi8KGDsppbq+qz96EYg6YEMIhQxl/OspkZ9Iv4waFwD+CxRJieNyLjBHV4RZXQxHwjeT8kO1nJdpMve1IZiiOMnFZ89r/+LGZTxzmgLufa1OBOXg0tda/RCnHiXbpVPweaxWGqHKC90oBf14lMV5Cnl55qLB+vIdN5qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvbG8dSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvbG8dSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA0C4CEED;
	Tue,  8 Jul 2025 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992985;
	bh=3ps+4Nb/Bt+ppRnaXVLnE4Or9WlfBHTPT7hp2UulKBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvbG8dSyEIuQegbHF+2BVAB4tEtG082etZc899WIR4600+xzVK/Et7MUpgde5Fpou
	 8ho9sCC7XMEI+bGyBMiHgkS+ZuN2pHVwyQPXV/6uK4Oh5+RZB2+BEtcr5LN/GIqHhp
	 xF8FQUbK6Q2y/m07sysph/EcX82t9B0fBZTwsv3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/232] remoteproc: k3-r5: Use devm_ioremap_wc() helper
Date: Tue,  8 Jul 2025 18:22:24 +0200
Message-ID: <20250708162245.313296005@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit a572439f7143db5ea8446b7d755a16dfb12da7c7 ]

Use a device lifecycle managed ioremap helper function. This helps
prevent mistakes like unmapping out of order in cleanup functions and
forgetting to unmap on all error paths.

Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20241219110545.1898883-4-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 701177511abd ("remoteproc: k3-r5: Refactor sequential core power up/down operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 38 +++++-------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index c730ba09b92c7..c38b76b4943d5 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -996,17 +996,13 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 	/* use remaining reserved memory regions for static carveouts */
 	for (i = 0; i < num_rmems; i++) {
 		rmem_np = of_parse_phandle(np, "memory-region", i + 1);
-		if (!rmem_np) {
-			ret = -EINVAL;
-			goto unmap_rmem;
-		}
+		if (!rmem_np)
+			return -EINVAL;
 
 		rmem = of_reserved_mem_lookup(rmem_np);
 		of_node_put(rmem_np);
-		if (!rmem) {
-			ret = -EINVAL;
-			goto unmap_rmem;
-		}
+		if (!rmem)
+			return -EINVAL;
 
 		kproc->rmem[i].bus_addr = rmem->base;
 		/*
@@ -1021,12 +1017,11 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 		 */
 		kproc->rmem[i].dev_addr = (u32)rmem->base;
 		kproc->rmem[i].size = rmem->size;
-		kproc->rmem[i].cpu_addr = ioremap_wc(rmem->base, rmem->size);
+		kproc->rmem[i].cpu_addr = devm_ioremap_wc(dev, rmem->base, rmem->size);
 		if (!kproc->rmem[i].cpu_addr) {
 			dev_err(dev, "failed to map reserved memory#%d at %pa of size %pa\n",
 				i + 1, &rmem->base, &rmem->size);
-			ret = -ENOMEM;
-			goto unmap_rmem;
+			return -ENOMEM;
 		}
 
 		dev_dbg(dev, "reserved memory%d: bus addr %pa size 0x%zx va %pK da 0x%x\n",
@@ -1037,19 +1032,6 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 	kproc->num_rmems = num_rmems;
 
 	return 0;
-
-unmap_rmem:
-	for (i--; i >= 0; i--)
-		iounmap(kproc->rmem[i].cpu_addr);
-	return ret;
-}
-
-static void k3_r5_reserved_mem_exit(struct k3_r5_rproc *kproc)
-{
-	int i;
-
-	for (i = 0; i < kproc->num_rmems; i++)
-		iounmap(kproc->rmem[i].cpu_addr);
 }
 
 /*
@@ -1278,8 +1260,8 @@ static int k3_r5_cluster_rproc_init(struct platform_device *pdev)
 
 		ret = rproc_add(rproc);
 		if (ret) {
-			dev_err(dev, "rproc_add failed, ret = %d\n", ret);
-			goto err_add;
+			dev_err_probe(dev, ret, "rproc_add failed\n");
+			goto out;
 		}
 
 		/* create only one rproc in lockstep, single-cpu or
@@ -1325,8 +1307,6 @@ static int k3_r5_cluster_rproc_init(struct platform_device *pdev)
 
 err_powerup:
 	rproc_del(rproc);
-err_add:
-	k3_r5_reserved_mem_exit(kproc);
 out:
 	/* undo core0 upon any failures on core1 in split-mode */
 	if (cluster->mode == CLUSTER_MODE_SPLIT && core == core1) {
@@ -1371,8 +1351,6 @@ static void k3_r5_cluster_rproc_exit(void *data)
 		mbox_free_channel(kproc->mbox);
 
 		rproc_del(rproc);
-
-		k3_r5_reserved_mem_exit(kproc);
 	}
 }
 
-- 
2.39.5



