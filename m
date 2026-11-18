Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018829;
	b=OZmb1utwSntp+BAQgah4isxMmAqvsUFiwqhws2JJfq7pGYWRsYEfAZaEMeGAcswc4OEs
	 JdSiNkOgPMy+dnO7MnzYzYMB2Ai4hGIOWdva/9hKbxQbfvn3Kdom2megMCgeKhe1HwVos
	 VP07HILghNKyJBf9/s2X5Igv6wfNeoDDIEOfprlVH8z8MXK/nWhbaqnlZL5LG6UziHKAy
	 s9UqSkCPuaSehGWxikZPZkIv+RTZfuEZivjEvDBdN63tEMSAChfrAObS8J3CtNueeY+Cr
	 9oixKM9fRspve09kpkYJ4R6hCUbJx5MwuokIv1xqXYauUuBvxCNklvD6ZcK4kkAXInA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ldSwWppIA++mjkIqMUT75AVSVafWCd85UPAcKjeAoOY=;
	b=1G7k9uGeOr7wAib0v2luoDIR7dsJKnyMya8fu8QXuf/sst7+7YfZAxZyQGBspEXSPVz7
	 t/Zz2Dpe4xR46jbLIUGATYQpmehR99DKhmk/joVlKS5qoac7mMKv4S5nnCf6W69x3+b0U
	 UQe6d5X3Nuc2XHeT6F5bCfNyMQSZFtjiGEL3IOzoqfhHCby240Z12+oTX9ovetWY4sPep
	 OWN46R0ANV0Z8ksw8Z+BsDdaMcWcIv8ifdin/fMOoYNtL/D7sgzc7FTcxsrSrk8qrH5rZ
	 rvHjj5BOiNMAHg91dZGJa2qOcSEqtYcQ6RurojvxKeq3UhaCqfvQHNlJ3dmDdBYap3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqn33D53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0D7606A31C;
	Wed, 18 Nov 2026 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqn33D53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0AE1F000C4;
	Wed, 18 Nov 2026 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018828;
	bh=ldSwWppIA++mjkIqMUT75AVSVafWCd85UPAcKjeAoOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqn33D53STa2U0v/VpzmkmijtL+XPlW7dN1FJx8g8zTirWipj+LKeMc7p2YtZ8bnf
	 vYnY8qwA7WGgQ4qeewCk4CxBRU1PQg7ML6T/xomAr6+Iog/0UKEgvI/YjCs9vAaMnO
	 tLZd/nnjokQFEtT09LqRylgVViXa8rZYTre1uz4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Drake <dan@reactivated.net>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1378/2651] drm/vc4: Set DRM DMA device directly from HVS and V3D
Date: Wed, 18 Nov 2026 15:43:38 +0100
Message-ID: <20261118150337.636821087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dan@reactivated.net>

[ Upstream commit b0a6b769cc174dd9fd154270f78acf72dc3e5c7e ]

vc4 uses of_dma_configure() during bind to set the DMA configuration of
the drm device by borrowing the configuration of one of its component
devices.

This violates driver model expectations that IOMMU probing and domain
attachment occur before driver binding - see commit bcb81ac6ae3c ("iommu:
Get DT/ACPI parsing into the proper probe path").

With the introduction of the bcm2712-iommu driver behind the vc4 hvs
device, a warning is triggered:

    vc4-drm gpu: late IOMMU probe at driver bind, something fishy here!

Instead of configuring the virtual aggregate device, adopt the pattern
used by sun4i/sun8i/exynos where candidate DMA-capable hardware components
register themselves as the device to use for DRM allocations via
drm_dev_set_dma_dev(), provided a DMA device has not already been
assigned.

HVS will typically bind first and claim the DMA device. The gen6 36-bit
DMA mask configuration was moved into vc4_hvs_bind() accordingly. For
older generations, vc4's v3d component continues to be available as a
fallback, and the default platform bus 32-bit DMA mask is retained.

Fixes: da8e393e23ef ("drm/vc4: drv: Adopt the dma configuration from the HVS or V3D component")
Signed-off-by: Daniel Drake <dan@reactivated.net>
Link: https://patch.msgid.link/20261004-drm-dma-device-2-v3-1-45b121ab819f@reactivated.net
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c  |  3 ++-
 drivers/gpu/drm/vc4/vc4_drv.c | 28 ----------------------------
 drivers/gpu/drm/vc4/vc4_hvs.c | 10 ++++++++++
 drivers/gpu/drm/vc4/vc4_v3d.c |  7 +++++++
 4 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 7b8b3364000fc..da4b11b7ce9f7 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -303,7 +303,8 @@ static void vc4_bo_purge(struct drm_gem_object *obj)
 
 	drm_vma_node_unmap(&obj->vma_node, dev->anon_inode->i_mapping);
 
-	dma_free_wc(dev->dev, obj->size, bo->base.vaddr, bo->base.dma_addr);
+	dma_free_wc(drm_dev_dma_dev(dev), obj->size, bo->base.vaddr,
+		    bo->base.dma_addr);
 	bo->base.vaddr = NULL;
 	bo->madv = __VC4_MADV_PURGED;
 }
diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 6930ca20e14b4..6072b4e1ffed3 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -24,10 +24,8 @@
 #include <linux/clk.h>
 #include <linux/component.h>
 #include <linux/device.h>
-#include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/module.h>
-#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
@@ -273,15 +271,6 @@ static void vc4_component_unbind_all(void *ptr)
 	component_unbind_all(vc4->dev, &vc4->base);
 }
 
-static const struct of_device_id vc4_dma_range_matches[] = {
-	{ .compatible = "brcm,bcm2711-hvs" },
-	{ .compatible = "brcm,bcm2712-hvs" },
-	{ .compatible = "brcm,bcm2835-hvs" },
-	{ .compatible = "brcm,bcm2835-v3d" },
-	{ .compatible = "brcm,cygnus-v3d" },
-	{}
-};
-
 static int vc4_drm_bind(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -294,8 +283,6 @@ static int vc4_drm_bind(struct device *dev)
 	enum vc4_gen gen;
 	int ret = 0;
 
-	dev->coherent_dma_mask = DMA_BIT_MASK(32);
-
 	gen = (enum vc4_gen)of_device_get_match_data(dev);
 
 	if (gen > VC4_GEN_4)
@@ -303,21 +290,6 @@ static int vc4_drm_bind(struct device *dev)
 	else
 		driver = &vc4_drm_driver;
 
-	if (gen >= VC4_GEN_6_C)
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(36));
-	else
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
-
-	node = of_find_matching_node_and_match(NULL, vc4_dma_range_matches,
-					       NULL);
-	if (node) {
-		ret = of_dma_configure(dev, node, true);
-		of_node_put(node);
-
-		if (ret)
-			return ret;
-	}
-
 	vc4 = devm_drm_dev_alloc(dev, driver, struct vc4_dev, base);
 	if (IS_ERR(vc4))
 		return PTR_ERR(vc4);
diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index e715147d091ca..b1fb096858ccc 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -22,6 +22,7 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/component.h>
+#include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 
 #include <drm/drm_atomic_helper.h>
@@ -1662,6 +1663,15 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 		hvs->regset.nregs = ARRAY_SIZE(vc4_hvs_regs);
 	}
 
+	if (vc4->gen >= VC4_GEN_6_C) {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(36));
+		if (ret)
+			return ret;
+	}
+
+	if (drm_dev_dma_dev(drm) == drm->dev)
+		drm_dev_set_dma_dev(drm, dev);
+
 	if (vc4->gen >= VC4_GEN_5) {
 		struct rpi_firmware *firmware;
 		struct device_node *node;
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index d16eecf83fbaa..29737ae6a7459 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -441,6 +441,13 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 	vc4->v3d = v3d;
 	v3d->vc4 = vc4;
 
+	/*
+	 * In headless setups where HVS is absent, use V3D as the fallback
+	 * DMA controller for buffer allocations.
+	 */
+	if (drm_dev_dma_dev(drm) == drm->dev)
+		drm_dev_set_dma_dev(drm, dev);
+
 	v3d->clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(v3d->clk))
 		return dev_err_probe(dev, PTR_ERR(v3d->clk), "Failed to get V3D clock\n");
-- 
2.53.0



