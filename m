Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45833984F
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mrzWBlW5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426097; x=1729962097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a7OqrEqBGe0dtm6LA2KrhYz8WQmFLC+1PYXBMh2oJhw=;
  b=mrzWBlW5TfJMgcNw5B83QpVABZT5fybS+Ub+Aa0+cEh0H2Q37FPrQ/3b
   WeJjyl/rQ+qlOsgPDdPCzioR47FFuR4Ejgw6lUpCT14nu1faDlJqXdX0J
   lwXy/iAWJbskb0nK19VFAOe4+3l+ACAqKoUbOr4Rkq7smai2AeUYjspZl
   erajfvMqT1GxfEPaCjXI+mNpzFgOdexgGh5gNeYUO1X4nFQxDLL/VM1wf
   vRBi0cPMtWt2E5Gjll5ii1cL7GGuLC/NS2nv+/iZn6slsCDGzKckbfcGh
   V1x0ZEX/vVeSNgBJzdBpBZXjDtX/i3O5/ffFUUDQTKg9hQGH232LFrdYp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611961"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611961"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988197"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988197"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:17 -0700
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
Subject: [RFC PATCH V3 13/26] vfio/pci: Provide interrupt context to vfio_msi_enable() and vfio_msi_disable()
Date: Fri, 27 Oct 2023 10:00:45 -0700
Message-Id: <e94051e56d1484ed3398ba72b0ede89fbc8cf2c0.1698422237.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1698422237.git.reinette.chatre@intel.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vfio_msi_enable() and vfio_msi_disable() perform the PCI specific
operations to allocate and free interrupts on the device that will
back the guest interrupts. This makes these functions backend
specific calls that should be called by the interrupt management
frontend.

Pass the interrupt context as parameter to vfio_msi_enable() and
vfio_msi_disable() so that they can be called by a generic frontend
and make it possible for other backends to provide their own
vfio_msi_enable() and vfio_msi_disable().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index cdb6f875271f..ad3f9c1baccc 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -346,14 +346,15 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msix)
+static int vfio_msi_enable(struct vfio_pci_intr_ctx *intr_ctx, int nvec, bool msix)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
 	int ret;
 	u16 cmd;
 
-	if (!is_irq_none(&vdev->intr_ctx))
+	if (!is_irq_none(intr_ctx))
 		return -EINVAL;
 
 	/* return the number of supported vectors if we can't get all: */
@@ -367,7 +368,7 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-	vdev->intr_ctx.irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
+	intr_ctx->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
 				VFIO_PCI_MSI_IRQ_INDEX;
 
 	if (!msix) {
@@ -523,14 +524,15 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
+static void vfio_msi_disable(struct vfio_pci_intr_ctx *intr_ctx, bool msix)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned long i;
 	u16 cmd;
 
-	xa_for_each(&vdev->intr_ctx.ctx, i, ctx) {
+	xa_for_each(&intr_ctx->ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		vfio_msi_set_vector_signal(vdev, i, -1, msix);
@@ -547,7 +549,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	if (vdev->nointx)
 		pci_intx(pdev, 0);
 
-	vdev->intr_ctx.irq_type = VFIO_PCI_NUM_IRQS;
+	intr_ctx->irq_type = VFIO_PCI_NUM_IRQS;
 }
 
 /*
@@ -667,7 +669,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 
 	if (irq_is(intr_ctx, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_msi_disable(vdev, msix);
+		vfio_msi_disable(intr_ctx, msix);
 		return 0;
 	}
 
@@ -682,13 +684,13 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 			return vfio_msi_set_block(vdev, start, count,
 						  fds, msix);
 
-		ret = vfio_msi_enable(vdev, start + count, msix);
+		ret = vfio_msi_enable(intr_ctx, start + count, msix);
 		if (ret)
 			return ret;
 
 		ret = vfio_msi_set_block(vdev, start, count, fds, msix);
 		if (ret)
-			vfio_msi_disable(vdev, msix);
+			vfio_msi_disable(intr_ctx, msix);
 
 		return ret;
 	}
-- 
2.34.1

