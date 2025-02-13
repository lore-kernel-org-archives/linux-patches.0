Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BF626B087;
	Thu, 13 Feb 2025 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459102; cv=none; b=reY9+Azu3RwqzdkHbR5nUH8FUivrhCFgKCVINI4ylOicuTnItaK+GZGzzdnnPzRWvYY0Kpi2atTgAgVFpJM+1cgB6VQ82BSe2bRj3KCkAErszWXrK05BiArszfww+Vw8MdswjoyTFGt5gkaMfv9C7bk6553O72x7PxMuTy1/Mpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459102; c=relaxed/simple;
	bh=MierPASdfVZ9g/kzjhQCPgU/9ipYo2OmmCzWqMJg89o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVZlpm9fqovNSCUcptV7K2xlPiVt8xAFk/WG7rxnbVOwc1w3Hh94vf5ili1e1MZXowpkryEMroDtmmINqXCgt8+d8ck7SObT/Q/zVFF3phNU+fNH8b+zTkbj3oIlWeOdqRUWBFzX/L/rUVwRb0tCHhfCx4KbgiLfxEFSvfjQpzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WZr2qaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WZr2qaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7170C4CED1;
	Thu, 13 Feb 2025 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459102;
	bh=MierPASdfVZ9g/kzjhQCPgU/9ipYo2OmmCzWqMJg89o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WZr2qaFHwjFgNk6x4cqpDqBzxKOjbRh3wn4S7zPSbcrkXsWcHFijEU3eO75/ll16
	 Hf6a6wVGkE7M1bDN+L8Wj35nsdDrzl3N2A3agn++ayFq6+ONFApFvEtlXQ0qsQXaFi
	 TKNH47FrN0K/UAsVLW7PemfS2FFXPufC1d8q8/+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.13 167/443] remoteproc: omap: Handle ARM dma_iommu_mapping
Date: Thu, 13 Feb 2025 15:25:32 +0100
Message-ID: <20250213142447.044817641@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 1dc7c8ed7cb378dd3974387692dfa833aee718d4 upstream.

It's no longer practical for the OMAP IOMMU driver to trick
arm_setup_iommu_dma_ops() into ignoring its presence, so let's use the
same tactic as other IOMMU API users on 32-bit ARM and explicitly kick
the arch code's dma_iommu_mapping out of the way to avoid problems.

Fixes: 4720287c7bf7 ("iommu: Remove struct iommu_ops *iommu from arch_setup_dma_ops()")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Beleswar Padhi <b-padhi@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/6186e311cb6f64a787f87fd41e49a73f409b789c.1730136799.git.robin.murphy@arm.com
[Fixed changelog title]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/omap_remoteproc.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -37,6 +37,10 @@
 
 #include <linux/platform_data/dmtimer-omap.h>
 
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
+#include <asm/dma-iommu.h>
+#endif
+
 #include "omap_remoteproc.h"
 #include "remoteproc_internal.h"
 
@@ -1323,6 +1327,19 @@ static int omap_rproc_probe(struct platf
 	/* All existing OMAP IPU and DSP processors have an MMU */
 	rproc->has_iommu = true;
 
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
+	/*
+	 * Throw away the ARM DMA mapping that we'll never use, so it doesn't
+	 * interfere with the core rproc->domain and we get the right DMA ops.
+	 */
+	if (pdev->dev.archdata.mapping) {
+		struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(&pdev->dev);
+
+		arm_iommu_detach_device(&pdev->dev);
+		arm_iommu_release_mapping(mapping);
+	}
+#endif
+
 	ret = omap_rproc_of_get_internal_memories(pdev, rproc);
 	if (ret)
 		return ret;


