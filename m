Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AA73984A
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="czBKqSyo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426091; x=1729962091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0joQn3WaEtVm0P8mwhR6h/BllZzb35jHWARL4FWxWs=;
  b=czBKqSyocyW0P0M76sfMXdm3QJSfFj/xVsaXSJhpgsdy178wDaNk8g7L
   0xyLU33giXEfIJoVggm1bHSNIUnR9ZxSJFDrQdXmz67XZa70zH+Zh4+DV
   SMSbSpvyoS4zz98ks4zpSKfsehGSX5j0a1XJoE3F9ywfQlHq4BshQ5kge
   zf2Hc9O/OF5hmMZU68/o7dLneHWaxXJy3RTirqJaY9LSLF4JBzIrWP6ft
   iaNK/QbSbfZUglNLZB+tCnu98ALzJh9o/I1t8QzUbez28V8rGj0+HywMK
   Chz9Z8TKnnbDnmEKmoRzyDIeOiQFrBz6YGFuLag7YyROgAerSranyg4f5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611879"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611879"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988166"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988166"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:15 -0700
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
Subject: [RFC PATCH V3 06/26] vfio/pci: Separate MSI and MSI-X handling
Date: Fri, 27 Oct 2023 10:00:38 -0700
Message-Id: <397accb1341ac18273e6bc3e39361693a5411b4f.1698422237.git.reinette.chatre@intel.com>
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
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 14 +++++++++++++-
 include/linux/vfio_pci_core.h     |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 96587acfebf0..7de906363402 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -801,6 +801,7 @@ static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
 	.set_intx_trigger = vfio_pci_set_intx_trigger,
 	.set_msi_trigger = vfio_pci_set_msi_trigger,
+	.set_msix_trigger = vfio_pci_set_msi_trigger,
 	.set_err_trigger = vfio_pci_set_err_trigger,
 	.set_req_trigger = vfio_pci_set_req_trigger,
 };
@@ -839,7 +840,6 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 		}
 		break;
 	case VFIO_PCI_MSI_IRQ_INDEX:
-	case VFIO_PCI_MSIX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
 		case VFIO_IRQ_SET_ACTION_UNMASK:
@@ -851,6 +851,18 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
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
index d3fa0e49a1a8..db7ee9517d94 100644
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

