Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567EA224FB
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ya75DDhr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610495; x=1728146495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UrZaf9/sFCZSVDnrmskYei92u/SNvt1MrCiAFvLj6EI=;
  b=Ya75DDhrEDaaIc85UWHQ98mvFchQ5TAVUQLbH+1rp3YsH7FCs4L2giDU
   vDnZie3KPjsJ84qtV2GMr/h76CURWS5TWrzSZv3UNaMEtU7yTFd56Hsf1
   WGFdpoTEKbb8RXlnYdFtEAT5nxVnN3f5ZzUZY4vqcTf8c0FeorzPi2CiY
   audSfjuWqxDBV0R2HWKsfetLiuaQSzVXGFTvNDmpKblW0NmQumu9s2JIx
   jG18W7OK1IwN5OnAMNiBi07eDbBnczqONHNluuGInB7FEAh4VvsokXRld
   Cr6z3cZmWdCjqr4Au8cQ2ouYxR1mUgvldO9t9iL+2uIwyTSH9qeHB8zpd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063168"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063168"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892848"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892848"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
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
Subject: [RFC PATCH V2 04/18] vfio/pci: Make core interrupt callbacks accessible to all virtual devices
Date: Fri,  6 Oct 2023 09:40:59 -0700
Message-Id: <42e2d8fdf80b6022bdc844ee3a18b5c7988fcf0f.1696609476.git.reinette.chatre@intel.com>
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

The functions handling actions on interrupts for a virtual PCI device
triggered by VFIO_DEVICE_SET_IRQS ioctl() expect to act on a passthrough
PCI device represented by a struct vfio_pci_core_device.

A virtual device can support MSI-X while not being a passthrough PCI
device and thus not be represented by a struct vfio_pci_core_device.

To support MSI-X in all virtual devices it needs to be possible for
their drivers to interact with the MSI-X interrupt management and
thus the interrupt management should not require struct
vfio_pci_core_device.

Introduce struct vfio_pci_intr_ctx that will contain the interrupt
context of a virtual device that can be managed by different backends.
The first supported backend is the existing PCI interrupt management.
The core VFIO PCI interrupt management functions are modified to expect
this structure. As a backend managing interrupts of passthrough PCI
devices the existing VFIO PCI functions do still require to operate on
an actual PCI device represented by struct vfio_pci_core_device that
is provided via a private pointer.

More members are added to struct vfio_pci_intr_ctx in later patches
as members unique to interrupt context are transitioned from struct
vfio_pci_core_device.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c  |  7 ++++---
 drivers/vfio/pci/vfio_pci_intrs.c | 29 ++++++++++++++++++++---------
 drivers/vfio/pci/vfio_pci_priv.h  |  2 +-
 include/linux/vfio_pci_core.h     |  9 +++++++++
 4 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1929103ee59a..bb8181444c41 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -594,7 +594,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	/* Stop the device from further DMA */
 	pci_clear_master(pdev);
 
-	vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+	vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, VFIO_IRQ_SET_DATA_NONE |
 				VFIO_IRQ_SET_ACTION_TRIGGER,
 				vdev->irq_type, 0, 0, NULL);
 
@@ -1216,8 +1216,8 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 
 	mutex_lock(&vdev->igate);
 
-	ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start,
-				      hdr.count, data);
+	ret = vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, hdr.flags, hdr.index,
+				      hdr.start, hdr.count, data);
 
 	mutex_unlock(&vdev->igate);
 	kfree(data);
@@ -2166,6 +2166,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
+	vdev->intr_ctx.priv = vdev;
 
 	return 0;
 }
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index c49588c8f4a3..6d09a82def87 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -552,11 +552,13 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 /*
  * IOCTL support
  */
-static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_intx_unmask(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
 
@@ -584,10 +586,12 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_intx_mask(struct vfio_pci_intr_ctx *intr_ctx,
 				  unsigned int index, unsigned int start,
 				  unsigned int count, uint32_t flags, void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
 
@@ -604,11 +608,13 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_intx_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				     unsigned int index, unsigned int start,
 				     unsigned int count, uint32_t flags,
 				     void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
 		return 0;
@@ -648,11 +654,12 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
@@ -757,11 +764,13 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 	return -EINVAL;
 }
 
-static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_err_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (!pci_is_pcie(vdev->pdev))
 		return -ENOTTY;
 
@@ -772,11 +781,13 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 					       count, flags, data);
 }
 
-static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
+static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
+	struct vfio_pci_core_device *vdev = intr_ctx->priv;
+
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
@@ -784,11 +795,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 					       count, flags, data);
 }
 
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
 {
-	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
+	int (*func)(struct vfio_pci_intr_ctx *intr_ctx, unsigned int index,
 		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
@@ -837,5 +848,5 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	if (!func)
 		return -ENOTTY;
 
-	return func(vdev, index, start, count, flags, data);
+	return func(intr_ctx, index, start, count, flags, data);
 }
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16..6dddcfe7ab19 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -26,7 +26,7 @@ struct vfio_pci_ioeventfd {
 bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..66bde5a60be7 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -49,6 +49,14 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
+/*
+ * Interrupt context of virtual PCI device
+ * @priv:		Private data
+ */
+struct vfio_pci_intr_ctx {
+	void				*priv;
+};
+
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -96,6 +104,7 @@ struct vfio_pci_core_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	struct vfio_pci_intr_ctx	intr_ctx;
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.34.1

