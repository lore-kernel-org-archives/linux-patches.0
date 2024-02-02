Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC7317752
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849855; cv=none; b=KZpSyfqE8NRPFiqmFd984OAcCVHQ0P22XVmk4ualFlPihO9hvgRTi2BripqVRezjl2OEcH46SrS5h2oFxpp5CeYCEIzrCo1hZ3CvkRNV/Z/b9gr3He4X7J0ezEJDUfhLaleSgSZd5gP3Q7aN9fXZsZooBT5jnmYT/52yjSccRf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849855; c=relaxed/simple;
	bh=i1ZuVfKb6uZ0Dp+3vSDXltmIsz2QMq5Yyj+6aoiLHUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZVXOm+9zif6NfU81hYUtn7Eiop7gQfw19HcCXtQ/Yv7/OMxE4AhknfPeOaV8y78/vsQgrRgK+GGoXKvohGTK7wb0doaoUau8ixrOkmtz3ZBUKjIz2++PhjIn7S8xyHP/FQTh6ytKuVGOVz2hTjXCuvpwdrjt7mwOXdEHxX/iXP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dalA8Zbf; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dalA8Zbf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849854; x=1738385854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i1ZuVfKb6uZ0Dp+3vSDXltmIsz2QMq5Yyj+6aoiLHUY=;
  b=dalA8Zbf82p2Sq03WFvifSQojFcgyf91WvqmKPKvKSP16WfL1vYsPixX
   ROJkVtXcxd07xgVRkFEG3Kh8aghjKmCUpt4UK/sUJNE1MHYt32mPiZ3ld
   zToiuuIagDVIrdJkX2mF+88kRTOg/DpHhBOXqDK1BuegdPnxPPFJYvgpb
   AHjaHZqiTy/iqj+mftwANGf7RCM95DOub8UoI0AG1bxffqkjk9XHf69Ol
   ULkfkoj3KPqdmTN5qoFR++AYSdMxnzvKyYoM4wBr00Ii1LsmHeyX+jNqs
   G50Gsko6dXTxjHz4b5GwLWqeIELMo4iq2SoiwbQdS+9eTFygZisIZjGp2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615832"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615832"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339789"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339789"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
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
Subject: [PATCH 11/17] vfio/pci: Perform MSI/MSI-X interrupt management via callbacks
Date: Thu,  1 Feb 2024 20:57:05 -0800
Message-Id: <4e04371e86722f8e2d867fe813a67c10f48222af.1706849424.git.reinette.chatre@intel.com>
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

vfio_msi_set_vector_signal() is specific to MSI and MSI-X interrupt
management but its flow is the same as vfio_intx_set_signal() that
manages the INTx interrupts.

Replace the MSI and MSI-X specific calls with callbacks in preparation
for vfio_msi_set_vector_signal() to manage INTx interrupts also.

In preparation for support of INTx only the IRQ bypass code is
made optional.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to maintainers:
This change resembles "vfio/pci: Replace backend specific calls with
callbacks" that formed part of the IMS submission, but is not
specific to IMS.
https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com

 drivers/vfio/pci/vfio_pci_intrs.c | 44 +++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6eef4e2d7c13..07dc388c4513 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -31,6 +31,21 @@ struct vfio_pci_irq_ctx {
 	struct irq_bypass_producer	producer;
 };
 
+struct vfio_pci_intr_ops {
+	int (*request_interrupt)(struct vfio_pci_core_device *vdev,
+				 struct vfio_pci_irq_ctx *ctx,
+				 unsigned int vector, unsigned int index);
+	void (*free_interrupt)(struct vfio_pci_core_device *vdev,
+			       struct vfio_pci_irq_ctx *ctx,
+			       unsigned int vector);
+	char *(*device_name)(struct vfio_pci_core_device *vdev,
+			     unsigned int vector, unsigned int index);
+	void (*register_producer)(struct vfio_pci_core_device *vdev,
+				  struct vfio_pci_irq_ctx *ctx,
+				  unsigned int vector);
+	void (*unregister_producer)(struct vfio_pci_irq_ctx *ctx);
+};
+
 static bool irq_is(struct vfio_pci_core_device *vdev, int type)
 {
 	return vdev->irq_type == type;
@@ -525,6 +540,23 @@ static void vfio_msi_unregister_producer(struct vfio_pci_irq_ctx *ctx)
 	irq_bypass_unregister_producer(&ctx->producer);
 }
 
+static struct vfio_pci_intr_ops intr_ops[] = {
+	[VFIO_PCI_MSI_IRQ_INDEX] = {
+		.request_interrupt = vfio_msi_request_interrupt,
+		.free_interrupt = vfio_msi_free_interrupt,
+		.device_name = vfio_msi_device_name,
+		.register_producer = vfio_msi_register_producer,
+		.unregister_producer = vfio_msi_unregister_producer,
+	},
+	[VFIO_PCI_MSIX_IRQ_INDEX] = {
+		.request_interrupt = vfio_msi_request_interrupt,
+		.free_interrupt = vfio_msi_free_interrupt,
+		.device_name = vfio_msi_device_name,
+		.register_producer = vfio_msi_register_producer,
+		.unregister_producer = vfio_msi_unregister_producer,
+	},
+};
+
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      unsigned int vector, int fd,
 				      unsigned int index)
@@ -536,8 +568,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	ctx = vfio_irq_ctx_get(vdev, vector);
 
 	if (ctx && ctx->trigger) {
-		vfio_msi_unregister_producer(ctx);
-		vfio_msi_free_interrupt(vdev, ctx, vector);
+		if (intr_ops[index].unregister_producer)
+			intr_ops[index].unregister_producer(ctx);
+		intr_ops[index].free_interrupt(vdev, ctx, vector);
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -554,7 +587,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 			return -ENOMEM;
 	}
 
-	ctx->name = vfio_msi_device_name(vdev, vector, index);
+	ctx->name = intr_ops[index].device_name(vdev, vector, index);
 	if (!ctx->name)
 		return -ENOMEM;
 
@@ -566,11 +599,12 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	ctx->trigger = trigger;
 
-	ret = vfio_msi_request_interrupt(vdev, ctx, vector, index);
+	ret = intr_ops[index].request_interrupt(vdev, ctx, vector, index);
 	if (ret)
 		goto out_put_eventfd_ctx;
 
-	vfio_msi_register_producer(vdev, ctx, vector);
+	if (intr_ops[index].register_producer)
+		intr_ops[index].register_producer(vdev, ctx, vector);
 
 	return 0;
 
-- 
2.34.1

