Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41772EBDCC;
	Tue, 17 Jun 2025 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174933; cv=none; b=Jpag4rXSl7fbb/dDaZkFmXBtOp44THSmypAQWdy7oxziB4hiaKUzwHJy48NfMhfpaosGEOZAN6k4ZBVB001Q731PJ1e8qHIeZ6tlgx6WgqY8bYHgURtBNFI/aOUXIqQPTrOwHRllUqqR4hjD2wk5l641PacZVSCiWQfx3dxX5lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174933; c=relaxed/simple;
	bh=dgd0XN278FXIdbdnhEvgEuZLi/BMIPl9paobHYAIvbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbLO1UjHmWeCEruiOpb4evo+kqxr+VqNtESssidh0vpZOU787JoIPHQhef2gwa6Yt88z0bio5izjbGwKWPMWqns/WgsqTwgX3XvInJaDx5np4KZlYiqvFDy6aHZe+17z+OhBxrkmOWJlwE1IvEXHx7cKR067WLdVqMD+Jy+RXmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUV9X4mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUV9X4mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFFDC4CEE7;
	Tue, 17 Jun 2025 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174933;
	bh=dgd0XN278FXIdbdnhEvgEuZLi/BMIPl9paobHYAIvbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUV9X4mGiZwPYpv6MbAsAOUIH1qCvUFexJvhUmYJPVZ+Nuvev/GRdcUjZ9llMfxyC
	 3+7SrTbb5ziQdbqnz+d9xoFmPqJrMUMw6kCnqMCSq0UxrmSOVUDTX6zNzf3cXujlPI
	 jLFyt/nbjGnyqcMlAV8pIv5EE+ZgmhKDLaUyQuPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Yao <andy.xu@hj-micro.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/512] perf: arm-ni: Unregister PMUs on probe failure
Date: Tue, 17 Jun 2025 17:20:40 +0200
Message-ID: <20250617152422.578675618@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Hongbo Yao <andy.xu@hj-micro.com>

[ Upstream commit 7f57afde6a44d9e044885e1125034edd4fda02e8 ]

When a resource allocation fails in one clock domain of an NI device,
we need to properly roll back all previously registered perf PMUs in
other clock domains of the same device.

Otherwise, it can lead to kernel panics.

Calling arm_ni_init+0x0/0xff8 [arm_ni] @ 2374
arm-ni ARMHCB70:00: Failed to request PMU region 0x1f3c13000
arm-ni ARMHCB70:00: probe with driver arm-ni failed with error -16
list_add corruption: next->prev should be prev (fffffd01e9698a18),
but was 0000000000000000. (next=ffff10001a0decc8).
pstate: 6340009 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : list_add_valid_or_report+0x7c/0xb8
lr : list_add_valid_or_report+0x7c/0xb8
Call trace:
 __list_add_valid_or_report+0x7c/0xb8
 perf_pmu_register+0x22c/0x3a0
 arm_ni_probe+0x554/0x70c [arm_ni]
 platform_probe+0x70/0xe8
 really_probe+0xc6/0x4d8
 driver_probe_device+0x48/0x170
 __driver_attach+0x8e/0x1c0
 bus_for_each_dev+0x64/0xf0
 driver_add+0x138/0x260
 bus_add_driver+0x68/0x138
 __platform_driver_register+0x2c/0x40
 arm_ni_init+0x14/0x2a [arm_ni]
 do_init_module+0x36/0x298
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops - BUG: Fatal exception
SMP: stopping secondary CPUs

Fixes: 4d5a7680f2b4 ("perf: Add driver for Arm NI-700 interconnect PMU")
Signed-off-by: Hongbo Yao <andy.xu@hj-micro.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20250403070918.4153839-1-andy.xu@hj-micro.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-ni.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/perf/arm-ni.c b/drivers/perf/arm-ni.c
index 90fcfe693439e..3f3d2e0f91fa7 100644
--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -576,6 +576,23 @@ static int arm_ni_init_cd(struct arm_ni *ni, struct arm_ni_node *node, u64 res_s
 	return err;
 }
 
+static void arm_ni_remove(struct platform_device *pdev)
+{
+	struct arm_ni *ni = platform_get_drvdata(pdev);
+
+	for (int i = 0; i < ni->num_cds; i++) {
+		struct arm_ni_cd *cd = ni->cds + i;
+
+		if (!cd->pmu_base)
+			continue;
+
+		writel_relaxed(0, cd->pmu_base + NI_PMCR);
+		writel_relaxed(U32_MAX, cd->pmu_base + NI_PMINTENCLR);
+		perf_pmu_unregister(&cd->pmu);
+		cpuhp_state_remove_instance_nocalls(arm_ni_hp_state, &cd->cpuhp_node);
+	}
+}
+
 static void arm_ni_probe_domain(void __iomem *base, struct arm_ni_node *node)
 {
 	u32 reg = readl_relaxed(base + NI_NODE_TYPE);
@@ -657,8 +674,11 @@ static int arm_ni_probe(struct platform_device *pdev)
 				reg = readl_relaxed(pd.base + NI_CHILD_PTR(c));
 				arm_ni_probe_domain(base + reg, &cd);
 				ret = arm_ni_init_cd(ni, &cd, res->start);
-				if (ret)
+				if (ret) {
+					ni->cds[cd.id].pmu_base = NULL;
+					arm_ni_remove(pdev);
 					return ret;
+				}
 			}
 		}
 	}
@@ -666,23 +686,6 @@ static int arm_ni_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static void arm_ni_remove(struct platform_device *pdev)
-{
-	struct arm_ni *ni = platform_get_drvdata(pdev);
-
-	for (int i = 0; i < ni->num_cds; i++) {
-		struct arm_ni_cd *cd = ni->cds + i;
-
-		if (!cd->pmu_base)
-			continue;
-
-		writel_relaxed(0, cd->pmu_base + NI_PMCR);
-		writel_relaxed(U32_MAX, cd->pmu_base + NI_PMINTENCLR);
-		perf_pmu_unregister(&cd->pmu);
-		cpuhp_state_remove_instance_nocalls(arm_ni_hp_state, &cd->cpuhp_node);
-	}
-}
-
 #ifdef CONFIG_OF
 static const struct of_device_id arm_ni_of_match[] = {
 	{ .compatible = "arm,ni-700" },
-- 
2.39.5



