Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A69F8833
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mXgb6oQt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426088; x=1729962088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RMArCxGqHD+3tMudRHMvYRNJuBVfq4KK4WYAG6z1Fl4=;
  b=mXgb6oQt0c9Xj4NDFnwWHvl+QSJuJ77EfedzLFnfy0Rk/QAqNXKk9AZ5
   7/k+ZVj8HRHu5TpDCI91xXb1CNqI7lXgPg+mmYUj0zaBXM/sREt5pNRvo
   iqZE2bMCnIBK8tXsCGSzBjhQ4SlhOTrfWRN3O45hGUpSSR2w33PN4t8jJ
   kk0cqFxXitq3kBTNn3mSfKVw1IrQ1flfuaW8UG4vlCMAsewj7WaXVsfHW
   cFr1qWKQ+nId3bsOxp+2vp/UudhHGkw2whGVH8p+4NAGaLaOnYOuCn2wu
   dzXzEGVTpBS1BtyTYTGu02GKTFLFWoTDj3tTfKuDwsQkZ1kN1ORtuZzvq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611829"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611829"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988146"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988146"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:13 -0700
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
Subject: [RFC PATCH V3 02/26] vfio/pci: Move PCI specific check from wrapper to PCI function
Date: Fri, 27 Oct 2023 10:00:34 -0700
Message-Id: <53d90183704bf3bd633a70983ef9ca8c7c341777.1698422237.git.reinette.chatre@intel.com>
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

vfio_pci_set_irqs_ioctl() uses a PCI device specific check to
determine if PCI specific vfio_pci_set_err_trigger() should be
called.

Move the PCI device specific check into PCI specific
vfio_pci_set_err_trigger() to make it easier for
vfio_pci_set_irqs_ioctl() to become a frontend for interrupt
backends for PCI devices as well as virtual devices.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index cbb4bcbfbf83..b5b1c09bef25 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -758,6 +758,9 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
+	if (!pci_is_pcie(vdev->pdev))
+		return -ENOTTY;
+
 	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
@@ -813,8 +816,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			if (pci_is_pcie(vdev->pdev))
-				func = vfio_pci_set_err_trigger;
+			func = vfio_pci_set_err_trigger;
 			break;
 		}
 		break;
-- 
2.34.1

