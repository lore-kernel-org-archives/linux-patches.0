Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44411754A
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849854; cv=none; b=Wye5hQpYe38Kg/cg6m5WCjZvdIxXD6h2DRsY3FKuVPOkPVNS+E29B3HQca7RQJhC/Yf73IlBw8Vv2Y8NIcfpoI4eJMvlLDvptbOhsTtRf1ECWn2k6P6CEiyOLqQafGpnzdtrcYA4NMS0+ZIX1//WLUq75CwN5zeT5BRs+Qk/JW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849854; c=relaxed/simple;
	bh=hPTVpULSZEGp+qlRQ7yydOeKGAslemxYjjTwBe0NPao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QdF3wYwceJHbRGjIKWZpUln8Vkb4/hqld/KoU7LYdclXd58gFhb1/AXpU2irNBk2mAXgo/p8G4XhjtmKzWvRdHkIrL55Vuwnmgv8HOyOda0oXyGiqH13CYJYyLEl+mRrTjFcruqLS9tAg2+e5b+E4UsAmYdnwjrwgaVOWzx+ob4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rw96C49p; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rw96C49p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849853; x=1738385853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hPTVpULSZEGp+qlRQ7yydOeKGAslemxYjjTwBe0NPao=;
  b=Rw96C49pbPi8xR/oS/LHw4mZpzudHtLb6/Ozki+YbcYhbYNgLtK5bI82
   MPQKqVcJEI26mVqmRMoPYkIg2/HrDhnmLquAKs7qc8xrcBDEgAUbNfmYr
   I7J9Urf96NPa30w05XS0mYMUdLWx4RrsqOa0RpfyVWRizBqAYxzQXXXHM
   g8fyIn4eBYsGgWgQXQDKMzwydgvbt3REBh6R0DHWjGGK4VkmX5Su9bQUP
   abdsUJdNesJ5/uGF7r0cazJQ209voIxjfszm47m/3dSFuqM1ooC/VOQbF
   aGGA2Ph0jQjOY+bbFzz4UOVVn+2ntfKbwfG1SNPdwhdQzjnV4knT1WKPC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615822"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615822"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339780"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339780"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:24 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	ashok.raj@intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 08/17] vfio/pci: Extract MSI/MSI-X specific code from common flow
Date: Thu,  1 Feb 2024 20:57:02 -0800
Message-Id: <79aec9a35a494dcd11be059021a3c4c3f4f74b40.1706849424.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vfio_intx_set_signal() and vfio_msi_set_signal() have similar code
flow mixed with actions specific to the interrupt type.

Code that is similar between MSI, MSI-X, and INTx management can
be shared instead of duplicated. Start by replacing the MSI/MSI-X
specific code within vfio_msi_set_signal() with functions. These
functions that are specific to the management of MSI/MSI-X can
later be called from a shared flow.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to maintainers:
This is similar to "vfio/pci: Separate frontend and backend code during
interrupt enable/disable" that was submitted as part of IMS changes,
but is not specific to IMS.
https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com

 drivers/vfio/pci/vfio_pci_intrs.c | 134 ++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 45 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 7ca2b983b66e..70f2382c9c0c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -414,26 +414,99 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
 	return map.index < 0 ? map.index : map.virq;
 }
 
+static void vfio_msi_free_interrupt(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_irq_ctx *ctx,
+				    unsigned int vector)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int irq;
+	u16 cmd;
+
+	irq = pci_irq_vector(pdev, vector);
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
+	free_irq(irq, ctx->trigger);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+	/*Interrupt stays allocated, will be freed at MSI/MSI-X disable. */
+}
+
+static int vfio_msi_request_interrupt(struct vfio_pci_core_device *vdev,
+				      struct vfio_pci_irq_ctx *ctx,
+				      unsigned int vector, unsigned int index)
+{
+	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
+	int irq, ret;
+	u16 cmd;
+
+	irq = vfio_msi_alloc_irq(vdev, vector, msix);
+	if (irq < 0)
+		return irq;
+
+	/*
+	 * If the vector was previously allocated, refresh the on-device
+	 * message data before enabling in case it had been cleared or
+	 * corrupted (e.g. due to backdoor resets) since writing.
+	 */
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
+	if (msix) {
+		struct msi_msg msg;
+
+		get_cached_msi_msg(irq, &msg);
+		pci_write_msi_msg(irq, &msg);
+	}
+
+	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, ctx->trigger);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+
+	return ret;
+}
+
+static char *vfio_msi_device_name(struct vfio_pci_core_device *vdev,
+				  unsigned int vector, unsigned int index)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
+			 index == VFIO_PCI_MSIX_IRQ_INDEX ? "x" : "",
+			 vector, pci_name(pdev));
+}
+
+static void vfio_msi_register_producer(struct vfio_pci_core_device *vdev,
+				       struct vfio_pci_irq_ctx *ctx,
+				       unsigned int vector)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	ctx->producer.token = ctx->trigger;
+	ctx->producer.irq = pci_irq_vector(pdev, vector);
+	ret = irq_bypass_register_producer(&ctx->producer);
+	if (unlikely(ret)) {
+		dev_info(&pdev->dev,
+			 "irq bypass producer (token %p) registration fails: %d\n",
+			 ctx->producer.token, ret);
+		ctx->producer.token = NULL;
+		ctx->producer.irq = 0;
+	}
+}
+
+static void vfio_msi_unregister_producer(struct vfio_pci_irq_ctx *ctx)
+{
+	irq_bypass_unregister_producer(&ctx->producer);
+}
+
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      unsigned int vector, int fd,
 				      unsigned int index)
 {
-	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
-	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
-	int irq = -EINVAL, ret;
-	u16 cmd;
+	int ret;
 
 	ctx = vfio_irq_ctx_get(vdev, vector);
 
 	if (ctx && ctx->trigger) {
-		irq_bypass_unregister_producer(&ctx->producer);
-		irq = pci_irq_vector(pdev, vector);
-		cmd = vfio_pci_memory_lock_and_enable(vdev);
-		free_irq(irq, ctx->trigger);
-		vfio_pci_memory_unlock_and_restore(vdev, cmd);
-		/* Interrupt stays allocated, will be freed at MSI-X disable. */
+		vfio_msi_unregister_producer(ctx);
+		vfio_msi_free_interrupt(vdev, ctx, vector);
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -443,13 +516,6 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0)
 		return 0;
 
-	if (irq == -EINVAL) {
-		/* Interrupt stays allocated, will be freed at MSI-X disable. */
-		irq = vfio_msi_alloc_irq(vdev, vector, msix);
-		if (irq < 0)
-			return irq;
-	}
-
 	/* Per-interrupt context remain allocated. */
 	if (!ctx) {
 		ctx = vfio_irq_ctx_alloc(vdev, vector);
@@ -457,8 +523,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 			return -ENOMEM;
 	}
 
-	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
-			      msix ? "x" : "", vector, pci_name(pdev));
+	ctx->name = vfio_msi_device_name(vdev, vector, index);
 	if (!ctx->name)
 		return -ENOMEM;
 
@@ -468,40 +533,19 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		goto out_free_name;
 	}
 
-	/*
-	 * If the vector was previously allocated, refresh the on-device
-	 * message data before enabling in case it had been cleared or
-	 * corrupted (e.g. due to backdoor resets) since writing.
-	 */
-	cmd = vfio_pci_memory_lock_and_enable(vdev);
-	if (msix) {
-		struct msi_msg msg;
-
-		get_cached_msi_msg(irq, &msg);
-		pci_write_msi_msg(irq, &msg);
-	}
+	ctx->trigger = trigger;
 
-	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
-	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+	ret = vfio_msi_request_interrupt(vdev, ctx, vector, index);
 	if (ret)
 		goto out_put_eventfd_ctx;
 
-	ctx->producer.token = trigger;
-	ctx->producer.irq = irq;
-	ret = irq_bypass_register_producer(&ctx->producer);
-	if (unlikely(ret)) {
-		dev_info(&pdev->dev,
-		"irq bypass producer (token %p) registration fails: %d\n",
-		ctx->producer.token, ret);
-
-		ctx->producer.token = NULL;
-	}
-	ctx->trigger = trigger;
+	vfio_msi_register_producer(vdev, ctx, vector);
 
 	return 0;
 
 out_put_eventfd_ctx:
-	eventfd_ctx_put(trigger);
+	eventfd_ctx_put(ctx->trigger);
+	ctx->trigger = NULL;
 out_free_name:
 	kfree(ctx->name);
 	ctx->name = NULL;
-- 
2.34.1

