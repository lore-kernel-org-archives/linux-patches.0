Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8078833
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbTILmRd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426093; x=1729962093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oEdS6qGPsqVzRnAM51x5uz01SKSS8bbH3iIPSR6hDZw=;
  b=nbTILmRdJgO0g3gARHNKu2ui9LhsAqjBZC90/NPKsaZRRXYNHF9/XhQL
   WkltqsEY79yXCpxvVmg/H8MUVNc3D+N6dcVIr7agvOO9R/bCwUCgGV3cL
   /Fo+IkU8cjU5wQqkknmM3pYn3DEYB1+n15qkBBWprjxzf+B1NHh1B2wsT
   BWLIPWK1chYbZGjCyRnuhRgTX4kHhnFiEjFQsO5wYmlAUIlvhSZshzYyz
   NVOCKTS+ZyinBGQHkxIE0FGF0e4O4N3+hK4lgOgoDkXeg1ihvI+e75eSi
   A48z7JwaBpTORLU5HwkGFaij1ADteUAo5Yh8SPZ3eicE2ob0hDZhOHXAh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611896"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611896"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988174"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988174"
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
Subject: [RFC PATCH V3 08/26] vfio/pci: Move mutex acquisition into function
Date: Fri, 27 Oct 2023 10:00:40 -0700
Message-Id: <c960f7f8d0d07a613d37d61288f1b7f91e4c0da1.1698422237.git.reinette.chatre@intel.com>
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

vfio_pci_set_irqs_ioctl() is the entrypoint for interrupt management
via the VFIO_DEVICE_SET_IRQS ioctl(). vfio_pci_set_irqs_ioctl() can
be called from a virtual device driver after its callbacks have been
configured to support the needed interrupt management.

The igate mutex is obtained before vfio_pci_set_irqs_ioctl() to protect
against concurrent changes to interrupt context. It should not be
necessary for all users of vfio_pci_set_irqs_ioctl() to remember to
take the mutex.

Acquire and release the mutex within vfio_pci_set_irqs_ioctl().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Improve changelog.

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
index a4c8b589c87b..5d600548b5d7 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -826,7 +826,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	int (*func)(struct vfio_pci_intr_ctx *intr_ctx, unsigned int index,
 		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
+	int ret = -ENOTTY;
 
+	mutex_lock(&intr_ctx->igate);
 	switch (index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
@@ -887,7 +889,11 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
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

