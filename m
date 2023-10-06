Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B9828E0A
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JM+PNMa4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610503; x=1728146503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=44H3e8OIAR4AdEwORIgxqPqp8eHloccs4kRdOQa424c=;
  b=JM+PNMa4UZVqeAcKaKp6jqHeUZmjToHnEx+6WvI1Jn6B/2pkkwmAzRCw
   wmryrBQNnCXEcsCx0RWSwj0Txrn8wtLs7WoBb05FSoERbh6OOyWn97/nk
   dyfQKHryV/GLCuT7IkmsuQGFd5V3dApMmNkzMVZWZHyuSkxEi4gfyK4eB
   fBxnmDOeZSHvCiffxJ7iViXSi34EqNZ6R5vG7x9RMyx6VuSzfzlJBKKRR
   VgkWBaHa4uuBAdX6Y0mVqq8na8iUsmXYS23TGUX4dAO9aLh6zgELpjZP1
   oR/EW3zxzkiTBCe1D8hgVT/rqaawWQWSUjNY3A6gr01Q3wJxn4nCOipzg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063239"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063239"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892893"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892893"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:27 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	jing2.liu@intel.com,
	ashok.raj@intel.com,
	fenghua.yu@intel.com,
	tom.zanussi@linux.intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH V2 16/18] vfio/pci: Support emulated interrupts in IMS backend
Date: Fri,  6 Oct 2023 09:41:11 -0700
Message-Id: <ad5d28f37b96f1f8c9da27749de429a98c96ba4a.1696609476.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1696609476.git.reinette.chatre@intel.com>
References: <cover.1696609476.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An emulated interrupt has an associated eventfd but is
not backed by a hardware interrupt.

Add support for emulated interrupts to the IMS backend
that generally involves avoiding the actions involving
hardware configuration.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index c6b213d52beb..f96d7481094a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -863,8 +863,8 @@ EXPORT_SYMBOL_GPL(vfio_pci_release_intr_ctx);
 /*
  * Free the IMS interrupt associated with @ctx.
  *
- * For an IMS interrupt the interrupt is freed from the underlying
- * PCI device's IMS domain.
+ * For an emulated interrupt there is nothing to do. For an IMS interrupt
+ * the interrupt is freed from the underlying PCI device's IMS domain.
  */
 static void vfio_pci_ims_irq_free(struct vfio_pci_intr_ctx *intr_ctx,
 				  struct vfio_pci_irq_ctx *ctx)
@@ -872,6 +872,9 @@ static void vfio_pci_ims_irq_free(struct vfio_pci_intr_ctx *intr_ctx,
 	struct vfio_pci_ims *ims = intr_ctx->priv;
 	struct msi_map irq_map = {};
 
+	if (ctx->emulated)
+		return;
+
 	irq_map.index = ctx->ims_id;
 	irq_map.virq = ctx->virq;
 	pci_ims_free_irq(ims->pdev, irq_map);
@@ -882,8 +885,8 @@ static void vfio_pci_ims_irq_free(struct vfio_pci_intr_ctx *intr_ctx,
 /*
  * Allocate a host IMS interrupt for @ctx.
  *
- * For an IMS interrupt the interrupt is allocated from the underlying
- * PCI device's IMS domain.
+ * For an emulated interrupt there is nothing to do. For an IMS interrupt
+ * the interrupt is allocated from the underlying PCI device's IMS domain.
  */
 static int vfio_pci_ims_irq_alloc(struct vfio_pci_intr_ctx *intr_ctx,
 				  struct vfio_pci_irq_ctx *ctx)
@@ -891,6 +894,9 @@ static int vfio_pci_ims_irq_alloc(struct vfio_pci_intr_ctx *intr_ctx,
 	struct vfio_pci_ims *ims = intr_ctx->priv;
 	struct msi_map irq_map = {};
 
+	if (ctx->emulated)
+		return -EINVAL;
+
 	irq_map = pci_ims_alloc_irq(ims->pdev, &ctx->icookie, NULL);
 	if (irq_map.index < 0)
 		return irq_map.index;
@@ -913,9 +919,11 @@ static int vfio_pci_ims_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 	ctx = vfio_irq_ctx_get(intr_ctx, vector);
 
 	if (ctx && ctx->trigger) {
-		irq_bypass_unregister_producer(&ctx->producer);
-		free_irq(ctx->virq, ctx->trigger);
-		vfio_pci_ims_irq_free(intr_ctx, ctx);
+		if (!ctx->emulated) {
+			irq_bypass_unregister_producer(&ctx->producer);
+			free_irq(ctx->virq, ctx->trigger);
+			vfio_pci_ims_irq_free(intr_ctx, ctx);
+		}
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -945,6 +953,9 @@ static int vfio_pci_ims_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	ctx->trigger = trigger;
 
+	if (ctx->emulated)
+		return 0;
+
 	ret = vfio_pci_ims_irq_alloc(intr_ctx, ctx);
 	if (ret < 0)
 		goto out_put_eventfd_ctx;
@@ -1078,7 +1089,7 @@ int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
 
 	intr_ctx->ops = &vfio_pci_ims_intr_ops;
 	intr_ctx->priv = ims;
-	intr_ctx->supports_emulated = false;
+	intr_ctx->supports_emulated = true;
 	intr_ctx->ims_backed_irq = true;
 
 	return 0;
-- 
2.34.1

