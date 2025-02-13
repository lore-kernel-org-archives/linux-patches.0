Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E4223A9BE;
	Thu, 13 Feb 2025 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457576; cv=none; b=tvrnI30hPz6YO1PPAkJkVl2Lb09Q940/hIM1sQQjiKNciWWdIsuWqYB1VKI8+njsZM90zm3GeFgqzOwEWtfauVHiM7u0Q27sZBnRYkjWFr4OpyNxV1dnDk1FhQDXgZ/3apsV48BoGPGodMz0hMy3EPFWKI5GYpgBnJYlDjLjYrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457576; c=relaxed/simple;
	bh=V+YbQQeumw9Au/HabFEKjpA+ZIg6F/9twb+ohHlTolU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3r/63pOJO5UF8OTJAjRnAjF8D5XpGquH2TZ5USOdISueuJ5nLctcq5gGTXNW3YFTAK72i3XYY9oEeY3W+qItPhtlc/fj0dKu/FXNXTrmnQOEKDBBAR8fFl+84SH4ygX74jGQTSqEVTOo2VH/3ESV0f3e5oPzSwdWywtw4Rqq48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJeTFiMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJeTFiMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CACAC4CED1;
	Thu, 13 Feb 2025 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457575;
	bh=V+YbQQeumw9Au/HabFEKjpA+ZIg6F/9twb+ohHlTolU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJeTFiMg/W30TTfojkyBXvOSu3ymiWA5WqmLakmkXOrHxeSnJPk4A7CTWpJSrgW0G
	 BGmvDU10nMqBftXIR1sPQODG8vreOvyVSO8th0WHf3tDFCwOJUxPcIftEj7U0timTy
	 9aUVF1kRzXfmrE75hXN80INKWKSInpy1sfBzms5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.12 151/422] remoteproc: omap: Handle ARM dma_iommu_mapping
Date: Thu, 13 Feb 2025 15:25:00 +0100
Message-ID: <20250213142442.377956836@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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


