Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A1C17597
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849855; cv=none; b=K02TD6SHhDC3XDmp+u5Z3vGT1LxX1DQ82iwe2LtfG6BEOvurKgZ4N8PuPR4WNV+J55knXgHJB0KrTRu9vkUxQrjKWNZcHnguoQvhv1t/jHTHOChHuM4F125dXPkNK+8TWAdnokxzb+zsFt45R+UEJZp8XCDIz1+rqp5mCEY8mn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849855; c=relaxed/simple;
	bh=HLRJyna+Zk3jXF4APHd23iO3eqvDn9o+9jiToz4XQtQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CouILCAxzGPOfExwah759zQk3SqOnyX3payzykzqtF6d+o2awGzzFbPjzPPfcx7NFNhde99E8DOVC2VdIHfUrXK6bk/r/ptnLG2v5JiiXeUGBsdWxSyRuO1b66lLhofYGgFRI9EEHYtuzIna/370UfSsCek4N1PnIeJe9W99UGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZzF8kbn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZzF8kbn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849854; x=1738385854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HLRJyna+Zk3jXF4APHd23iO3eqvDn9o+9jiToz4XQtQ=;
  b=bZzF8kbnFfD6ePrnb1FsH6pXAI2YzADRBwBZA0v9mcDNsQWeEYUNmnm5
   e95AfmeLenQqQ2WoirBQESi2gtAwOMIReql3Ln1oRW6GGbDr9q2zEhGsW
   SGXtIrXtAFqkAuqaPpIkLH68xCt//WHX7OYbY41gPG+51inJD1Z/4TsTn
   cf+J13FesttL1viAD/QnFaOxJJLV+NXIaWcIgp1GQI0ZxqYpmSsLVNEY6
   1lSmXPT6/RSN89A2ZjZ4gcuTlNnRiiVZbVws5i/ZciGzTEpUjcMfGio2W
   H0I6iQPROaqdX8rzy76iUvB4Btz0srAjajHXQuspTNYE4HkcRLCRHWrsA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615829"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615829"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339786"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339786"
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
Subject: [PATCH 10/17] vfio/pci: Extract INTx specific code from vfio_intx_set_signal()
Date: Thu,  1 Feb 2024 20:57:04 -0800
Message-Id: <ca3f167da31dcc90ce4772bce9ff934b799b7cc6.1706849424.git.reinette.chatre@intel.com>
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

vfio_intx_set_signal() and vfio_msi_set_vector_signal() use the
same code flow for INTx, MSI, and MSI-X interrupt management.

Extract the INTx specific code from vfio_intx_set_signal() to
leave behind the same flow as vfio_msi_set_vector_signal(),
ready for sharing.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 69 ++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 98b099f58b2b..6eef4e2d7c13 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -260,15 +260,58 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	return 0;
 }
 
+static void vfio_intx_free_interrupt(struct vfio_pci_core_device *vdev,
+				     struct vfio_pci_irq_ctx *ctx,
+				     unsigned int vector)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	free_irq(pdev->irq, vdev);
+}
+
+static int vfio_intx_request_interrupt(struct vfio_pci_core_device *vdev,
+				       struct vfio_pci_irq_ctx *ctx,
+				       unsigned int vector, unsigned int index)
+{
+	unsigned long irqflags = IRQF_SHARED;
+	struct pci_dev *pdev = vdev->pdev;
+	unsigned long flags;
+	int ret;
+
+	if (!vdev->pci_2_3)
+		irqflags = 0;
+
+	ret = request_irq(pdev->irq, vfio_intx_handler, irqflags,
+			  ctx->name, vdev);
+	if (ret)
+		return ret;
+
+	/*
+	 * INTx disable will stick across the new irq setup,
+	 * disable_irq won't.
+	 */
+	spin_lock_irqsave(&vdev->irqlock, flags);
+	if (!vdev->pci_2_3 && ctx->masked)
+		disable_irq_nosync(pdev->irq);
+	spin_unlock_irqrestore(&vdev->irqlock, flags);
+
+	return 0;
+}
+
+static char *vfio_intx_device_name(struct vfio_pci_core_device *vdev,
+				   unsigned int vector, unsigned int index)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
+}
+
 static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
 				unsigned int vector, int fd,
 				unsigned int index)
 {
-	struct pci_dev *pdev = vdev->pdev;
-	unsigned long irqflags = IRQF_SHARED;
 	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
-	unsigned long flags;
 	int ret;
 
 	ctx = vfio_irq_ctx_get(vdev, 0);
@@ -276,7 +319,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (ctx->trigger) {
-		free_irq(pdev->irq, vdev);
+		vfio_intx_free_interrupt(vdev, ctx, vector);
 		kfree(ctx->name);
 		eventfd_ctx_put(ctx->trigger);
 		ctx->trigger = NULL;
@@ -285,8 +328,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
 	if (fd < 0) /* Disable only */
 		return 0;
 
-	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)",
-			      pci_name(pdev));
+	ctx->name = vfio_intx_device_name(vdev, vector, index);
 	if (!ctx->name)
 		return -ENOMEM;
 
@@ -298,11 +340,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
 
 	ctx->trigger = trigger;
 
-	if (!vdev->pci_2_3)
-		irqflags = 0;
-
-	ret = request_irq(pdev->irq, vfio_intx_handler,
-			  irqflags, ctx->name, vdev);
+	ret = vfio_intx_request_interrupt(vdev, ctx, vector, index);
 	if (ret) {
 		ctx->trigger = NULL;
 		kfree(ctx->name);
@@ -310,15 +348,6 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
 		return ret;
 	}
 
-	/*
-	 * INTx disable will stick across the new irq setup,
-	 * disable_irq won't.
-	 */
-	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && ctx->masked)
-		disable_irq_nosync(pdev->irq);
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
-
 	return 0;
 }
 
-- 
2.34.1

