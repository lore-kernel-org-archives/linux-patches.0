Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861D1273C5
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTkx+SEE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610499; x=1728146499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GrDkvFpLO+JPsGNBjwpaq6g93EzryzswXCI/VbdbsYc=;
  b=JTkx+SEEW6FkgUn8qpW4GvZBWn49dxDeuc+oh34l0vvKjVShkHBjEokm
   fjKlxbZ3730IXPrAuIKLJ9a2/bt9ZzzjXRB7wE8Oi/9JC8iLklrU/FnF3
   ROS/wUhbxShnvaE72gYr2NW18IaHZKpxrUkeJ//6AlIRVgrY9PRDD0dy8
   6D0AQrrhWrJhKhry7ngvsBUQxWrzbeHgf2apK9iDxx94y5S63z+gjFm2b
   FEKCUYh9xFK7GyzYCBQnAhhf1ldykVcAvFjW+TjEJatPO8gLkE3t9Pf4g
   yCnXf70eSo9vFQ+ExLhQimRcg9KBf/gimtzvD4I6McNw/XFi9hrc+31iM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063197"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063197"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892865"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892865"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:25 -0700
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
Subject: [RFC PATCH V2 09/18] vfio/pci: Move interrupt contexts to generic interrupt struct
Date: Fri,  6 Oct 2023 09:41:04 -0700
Message-Id: <daf21396fe1f2157e44ec28ad95aa7f780ca227d.1696609476.git.reinette.chatre@intel.com>
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

VFIO PCI interrupt management maintains per-interrupt
context within an xarray using the interrupt vector as index.

Move the per-interrupt context to the generic interrupt
context in struct vfio_pci_intr_ctx to enable this context to
be managed by a different backend.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 1 -
 drivers/vfio/pci/vfio_pci_intrs.c | 9 +++++----
 include/linux/vfio_pci_core.h     | 3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index bf4de137ad2f..cf303a9555f0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2162,7 +2162,6 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
-	xa_init(&vdev->ctx);
 	vfio_pci_init_intr_ctx(vdev, &vdev->intr_ctx);
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9fc0a568d392..3c8fed88208c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -52,13 +52,13 @@ static
 struct vfio_pci_irq_ctx *vfio_irq_ctx_get(struct vfio_pci_core_device *vdev,
 					  unsigned long index)
 {
-	return xa_load(&vdev->ctx, index);
+	return xa_load(&vdev->intr_ctx.ctx, index);
 }
 
 static void vfio_irq_ctx_free(struct vfio_pci_core_device *vdev,
 			      struct vfio_pci_irq_ctx *ctx, unsigned long index)
 {
-	xa_erase(&vdev->ctx, index);
+	xa_erase(&vdev->intr_ctx.ctx, index);
 	kfree(ctx);
 }
 
@@ -72,7 +72,7 @@ vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
 	if (!ctx)
 		return NULL;
 
-	ret = xa_insert(&vdev->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
+	ret = xa_insert(&vdev->intr_ctx.ctx, index, ctx, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(ctx);
 		return NULL;
@@ -529,7 +529,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	unsigned long i;
 	u16 cmd;
 
-	xa_for_each(&vdev->ctx, i, ctx) {
+	xa_for_each(&vdev->intr_ctx.ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		vfio_msi_set_vector_signal(vdev, i, -1, msix);
@@ -809,6 +809,7 @@ void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
 	mutex_init(&intr_ctx->igate);
+	xa_init(&intr_ctx->ctx);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index b1c299188bf5..46521dd82a6b 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -56,6 +56,7 @@ struct vfio_pci_region {
  * @igate:		Protects members of struct vfio_pci_intr_ctx
  * @err_trigger:	Eventfd associated with error reporting IRQ
  * @req_trigger:	Eventfd associated with device request notification
+ * @ctx:		Per-interrupt context indexed by vector
  */
 struct vfio_pci_intr_ctx {
 	const struct vfio_pci_intr_ops	*ops;
@@ -63,6 +64,7 @@ struct vfio_pci_intr_ctx {
 	struct mutex			igate;
 	struct eventfd_ctx		*err_trigger;
 	struct eventfd_ctx		*req_trigger;
+	struct xarray			ctx;
 };
 
 struct vfio_pci_intr_ops {
@@ -98,7 +100,6 @@ struct vfio_pci_core_device {
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
 	spinlock_t		irqlock;
-	struct xarray		ctx;
 	int			irq_type;
 	int			num_regions;
 	struct vfio_pci_region	*region;
-- 
2.34.1

