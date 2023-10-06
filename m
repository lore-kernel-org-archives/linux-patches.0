Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DCA266CF
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPSA43nv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610499; x=1728146499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6qcjxSKPG49QsbYWnxrQpo18nDRlu23V1OPPdVp934=;
  b=VPSA43nvmvva+nuOtJJqWFVJCR4HhJYweFXWWkVh1ovve+4mh2gr0axs
   knaB8VmY2EiMJa+fbanukg6NZEHeK+CwQfF5eALoy/P9nTYXpQBQlYd30
   xNeYDXI63Yvy1DMxJWWYuPr3ofOzSsg63MebHhGXlrjmFvLVxxfmbd+bQ
   wVgz/6uBxPa67eAVof5iU5TL+lKlRiTyrmRo/h1qOwEYDWYvKsnJlhnJd
   OrgB1yGwSYdJsqxWHM9VxEqtONxpwb9CmHs7AU04F+MSMNMeChdfjjlcD
   vmuI2dSICPOHgeCu+2crDKKAgNKXFdf6+n0cVcBgP+WhkToB1A0y78yY2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063191"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063191"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892862"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892862"
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
Subject: [RFC PATCH V2 08/18] vfio/pci: Move mutex acquisition into function
Date: Fri,  6 Oct 2023 09:41:03 -0700
Message-Id: <51426f0278e0810530573827b6f4f45427215a17.1696609476.git.reinette.chatre@intel.com>
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

vfio_pci_set_irqs_ioctl() is the entrypoint for interrupt
management via the VFIO_DEVICE_SET_IRQS ioctl().
vfio_pci_set_irqs_ioctl() can be called from a virtual
device driver after its callbacks have been configured to
support the needed interrupt management.

The igate mutex is obtained before vfio_pci_set_irqs_ioctl()
to protect changes to interrupt context. It should not be
necessary for all users of vfio_pci_set_irqs_ioctl() to
remember to take the mutex - the mutex can be
acquired and released within vfio_pci_set_irqs_ioctl().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c  |  2 --
 drivers/vfio/pci/vfio_pci_intrs.c | 10 ++++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 5c9bd5d2db53..bf4de137ad2f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1214,12 +1214,10 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 			return PTR_ERR(data);
 	}
 
-	mutex_lock(&vdev->intr_ctx.igate);
 
 	ret = vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, hdr.flags, hdr.index,
 				      hdr.start, hdr.count, data);
 
-	mutex_unlock(&vdev->intr_ctx.igate);
 	kfree(data);
 
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b9c92ede3b6f..9fc0a568d392 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -825,7 +825,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	int (*func)(struct vfio_pci_intr_ctx *intr_ctx, unsigned int index,
 		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
+	int ret = -ENOTTY;
 
+	mutex_lock(&intr_ctx->igate);
 	switch (index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
@@ -886,7 +888,11 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	}
 
 	if (!func)
-		return -ENOTTY;
+		goto out_unlock;
+
+	ret = func(intr_ctx, index, start, count, flags, data);
 
-	return func(intr_ctx, index, start, count, flags, data);
+out_unlock:
+	mutex_unlock(&intr_ctx->igate);
+	return ret;
 }
-- 
2.34.1

