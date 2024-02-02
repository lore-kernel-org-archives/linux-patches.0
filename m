Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182F5F9C8
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849850; cv=none; b=CI17PGaJ/xrUdhPPLxRYvJmynGB4ID7W71b3onKF8NUguSbhQge/iaWu2p2MdGcKgxePuT3NaspzllVjuugBGvTGmBfFjnD4aMAyHhgBzmM3zE1DqDdNIC9oqBZWCx1/vOcGnbg4x7HmSzUCzkMZl8LQ2dpACYP4BpXdwAjOLmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849850; c=relaxed/simple;
	bh=HP2huTcvvO7TUh3mgU3qMuAjpGy887H4YuFiJWxsEUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cznFMj1wkPkUiAM54ju0L1/lpwHRBnHqx55Gov7gLNSUJxEliorhtRPhvEeKrWtxfMLrOchrhqdMMRFFNBdi2spXfbgs5XZfhsrx//0R3lUutFo0RHbPyoQ9LkBqL8QGKoVZjYQ9lgsU59oMmt09trWGpkw94J4oBUO7170WVcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ci9q/cyJ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ci9q/cyJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849849; x=1738385849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HP2huTcvvO7TUh3mgU3qMuAjpGy887H4YuFiJWxsEUU=;
  b=ci9q/cyJaAPHMPIORnnSaecv0X8mgHEwyjeEwlBBHywLC5XBj6YsDVlV
   aUdIQL3G9y5l184hSi8pHXGe7mw9jL2zgTGVwbgAtbIKksQ0sqlDskodF
   YpfacikInYgFUovCxaeBfUOAKB0EuClqNtPjP96KR3OdnG/uynKLx5sCa
   X0NqyzaOaGv0o5N+Qu0fMsGWXEZMjzfBBhpELYgs/0fTNqJGQMj2E9jyx
   rEISMf+RyLZ6N6ZYiCCnYQj0RkPELFOMrMdHgnIbsUuOGjEEoIoXaB6aa
   UbuH/r1miHMFyaDvhRduXNaa8v2rABUt3e5RUjGLu+jsDkTvbZm5N9WNp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615803"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615803"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339768"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339768"
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
Subject: [PATCH 04/17] vfio/pci: Remove duplicate interrupt management from core VFIO PCI
Date: Thu,  1 Feb 2024 20:56:58 -0800
Message-Id: <93dfe93e8fc53e83ac585ed3a891cefde32b3016.1706849424.git.reinette.chatre@intel.com>
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

The eventfds associated with device request notification and
error IRQ are managed by the VFIO PCI interrupt management code
contained in vfio_pci_intrs.c. The VFIO PCI interrupt management
code supports acquiring, releasing, as well as signaling of
these eventfd.

The VFIO PCI core code duplicates the signaling of device request
notification and error interrupts and does so by acquiring the lock
and accessing data that should ideally be contained within the
VFIO PCI interrupt management code.

Do not duplicate but instead call existing VFIO PCI interrupt
management code to signal device request notification
and error interrupts.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d2847ca2f0cb..de097174e455 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -700,16 +700,12 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 #endif
 	vfio_pci_core_disable(vdev);
 
-	mutex_lock(&vdev->igate);
-	if (vdev->err_trigger) {
-		eventfd_ctx_put(vdev->err_trigger);
-		vdev->err_trigger = NULL;
-	}
-	if (vdev->req_trigger) {
-		eventfd_ctx_put(vdev->req_trigger);
-		vdev->req_trigger = NULL;
-	}
-	mutex_unlock(&vdev->igate);
+	vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+				VFIO_IRQ_SET_ACTION_TRIGGER,
+				VFIO_PCI_ERR_IRQ_INDEX, 0, 0, NULL);
+	vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+				VFIO_IRQ_SET_ACTION_TRIGGER,
+				VFIO_PCI_REQ_IRQ_INDEX, 0, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 
-- 
2.34.1

