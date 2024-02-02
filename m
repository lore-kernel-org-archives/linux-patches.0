Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE432168D0
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849853; cv=none; b=E3qhE2KwuAwmu/bLHsUZK1qO2USgP/gFfrE2tSiCcQRfy1LJMhbs2viqsQ8fzEXfYmDC0vZqkd2Pi/3HyMteNtldC/ftdF8h7tCBQ3UFoHuDNasZ4M3FZhXPHwHsk266SEdAJ0zZV5fW+H4cHCQ2GeABQuUfiz9e05EW5nJDnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849853; c=relaxed/simple;
	bh=JgRfCrK7Y34Oc8Goi+1GvDvltDbKKC8kZ84KFNDHKXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nCYmvjp7vdFThokUHYR7ul5S62H61dHvjWLiG6qFPlkQgCQFfTKa79YkD5+wZYmom3SS5sK+xuVJENalnXPlAPr+D8G4pIxp6dZ28A4m/H4AC85W1SitMHvHlEjj8Z2AvynTy2LalH6eT1HdJ4eWz7giOxmpA746/rVlrHMKfN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFZ7ofY3; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFZ7ofY3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849852; x=1738385852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JgRfCrK7Y34Oc8Goi+1GvDvltDbKKC8kZ84KFNDHKXM=;
  b=jFZ7ofY3rBygnljUqyFOkJzq526CJJ/nxKV/1nxuu5nohx55IcTAe08K
   sWuSQKPeS0fanu3/a0HwdFMGCoec66NQbOlmoAimFjFCo3Vp7VIMZ7dBL
   fCwCS+iuT5OwD8HJ4k5P1cla+1FYfYr+9ZWm01/+bubXtrsmeZvNduptx
   terVCoMDWfhOIwyw08dF00WK/rjxJ2zMLxKiqEfqjmwJudswOANaPsyh2
   8ujoXArVthdljtki8DxiNztTpXMN93kWUlF8pDQ7kDLl22+6OHahTtDYr
   FaPTg9rue0cLz9tcJsmXo8I+oiygsfi8QGU0udKYGRCVNGeSXbjQUHprL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615820"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615820"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339783"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339783"
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
Subject: [PATCH 09/17] vfio/pci: Converge similar code flows
Date: Thu,  1 Feb 2024 20:57:03 -0800
Message-Id: <250808eb11a206075c0b92f2dae23a924f73c390.1706849424.git.reinette.chatre@intel.com>
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

vfio_intx_set_signal() and vfio_msi_set_vector_signal() have similar
code flows that can be shared.

Modify vfio_intx_set_signal()'s signature to resemble that of
vfio_msi_set_vector_signal() by also providing the vector and interrupt
type as parameters. For vfio_intx_set_signal() these two additional
parameters are redundant and unused since the vector is always 0 and
the interrupt type is always INTx. Adding these parameters make it
possible to refactor vfio_intx_set_signal() to call INTx specific
functions with the same signature as the MSI/MSI-X specific functions
in preparation for these interrupt type specific functions to be called
by shared code.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 70f2382c9c0c..98b099f58b2b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -260,7 +260,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	return 0;
 }
 
-static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
+static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
+				unsigned int vector, int fd,
+				unsigned int index)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long irqflags = IRQF_SHARED;
@@ -330,7 +332,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 	}
-	vfio_intx_set_signal(vdev, -1);
+	vfio_intx_set_signal(vdev, 0, -1, VFIO_PCI_INTX_IRQ_INDEX);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vfio_irq_ctx_free(vdev, ctx, 0);
 }
@@ -674,13 +676,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 		int ret;
 
 		if (is_intx(vdev))
-			return vfio_intx_set_signal(vdev, fd);
+			return vfio_intx_set_signal(vdev, start, fd, index);
 
 		ret = vfio_intx_enable(vdev);
 		if (ret)
 			return ret;
 
-		ret = vfio_intx_set_signal(vdev, fd);
+		ret = vfio_intx_set_signal(vdev, start, fd, index);
 		if (ret)
 			vfio_intx_disable(vdev);
 
-- 
2.34.1

