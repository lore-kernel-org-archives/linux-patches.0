Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0D32772C
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UGaYcaRn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610497; x=1728146497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sqlUd/J5XBudJ04yCoAuAKyPY6TW044eZAMIMwmxPNU=;
  b=UGaYcaRnrmXnXL64Mt1jY0EsYYjyXoMRN7UMdtC/elazag2ZCrUNTPqe
   +Qfrg3Ji15ZI/JIpY4+Lnhby4aVf7Uhaf5dLy2wu6DMRL8Tp/F2YMDbOY
   poVv7Mb12+Oq6eAGmAEjokjj2ipg74j7iRYdHscnUEYSxnsJsIP9FoZX3
   jKjb6KqB0WSPaUBqjA1y3usr+NPFuqXwz5kiKMhrnbFykRlNppJt9lc2w
   F+C+8MCFs6+/PVTQnXOMZs29BYQDlC0Urs19VFBnfg2MnHaKiu7j4iBX/
   B9mNpC4NvYIJKu67cOtuoLGzPsJriJNZ45la0ngw/oDCeFzA2S7M1juwl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063180"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063180"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892855"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892855"
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
Subject: [RFC PATCH V2 06/18] vfio/pci: Separate MSI and MSI-X handling
Date: Fri,  6 Oct 2023 09:41:01 -0700
Message-Id: <3fcc1552648614e2d37fa2dc997f59184efad838.1696609476.git.reinette.chatre@intel.com>
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

VFIO PCI interrupt management uses a single entry for both
MSI and MSI-X management with the called functions using a boolean
when necessary to distinguish between MSI and MSI-X. This remains
unchanged.

Virtual device interrupt management should not be required to
use the same callback for both MSI and MSI-X. It may be possible
for a virtual device to not support MSI at all and only
provide MSI-X interrupt management.

Separate the MSI and MSI-X interrupt management by allowing
different callbacks for each interrupt type. For PCI devices
the callback remains the same.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 14 +++++++++++++-
 include/linux/vfio_pci_core.h     |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index e2d39b7561b8..76ec5af3681a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -800,6 +800,7 @@ struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
 	.set_intx_trigger = vfio_pci_set_intx_trigger,
 	.set_msi_trigger = vfio_pci_set_msi_trigger,
+	.set_msix_trigger = vfio_pci_set_msi_trigger,
 	.set_err_trigger = vfio_pci_set_err_trigger,
 	.set_req_trigger = vfio_pci_set_req_trigger,
 };
@@ -838,7 +839,6 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 		}
 		break;
 	case VFIO_PCI_MSI_IRQ_INDEX:
-	case VFIO_PCI_MSIX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
 		case VFIO_IRQ_SET_ACTION_UNMASK:
@@ -850,6 +850,18 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_MSIX_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			/* XXX Need masking support exported */
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			if (intr_ctx->ops->set_msix_trigger)
+				func = intr_ctx->ops->set_msix_trigger;
+			break;
+		}
+		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index aba69669ec25..e9bfca9a0c0a 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -72,6 +72,9 @@ struct vfio_pci_intr_ops {
 	int (*set_msi_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
 			       unsigned int index, unsigned int start,
 			       unsigned int count, uint32_t flags, void *data);
+	int (*set_msix_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
+				unsigned int index, unsigned int start,
+				unsigned int count, uint32_t flags, void *data);
 	int (*set_err_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
 			       unsigned int index, unsigned int start,
 			       unsigned int count, uint32_t flags, void *data);
-- 
2.34.1

