Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6561928E13
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O5jiOpMs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610505; x=1728146505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z0Mc5dvLT5KGnD3D7yCcZmtKbAh89mWjRJrUM/fYnfc=;
  b=O5jiOpMseUerPX+lx7LdRLGAEKXotklSszVDkBrSD219RFfDGKNmq99s
   fGj9j4wxZFAf8QBXWmnTA37H/WjHHlCYWETSw1p32AuabEVRVghQsMVpt
   ZiL125zoPdXKts+g7b6hHHrOIWzCnOMwYXYmKlAdI+giykCao87E4dj3V
   n/oWYPc6a9hDyIo1hlxPy6oWUwXWzHv3+6UyPx78/Sk/O925CXp37WnCd
   rScwDTyDdLco6GXqJ/qz5+/CyFRckZdy2yqTk8MImiBELUdzozpFlTl2G
   iGa9hGsHyu4j/D8Fgw8mVuBRr0hMj8bFiMkLpXS5+wpaZrXR9HVOkwNx9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063245"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063245"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892899"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892899"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:28 -0700
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
Subject: [RFC PATCH V2 17/18] vfio/pci: Add accessor for IMS index
Date: Fri,  6 Oct 2023 09:41:12 -0700
Message-Id: <1603f5122e63dd53c7d2f94bd5127fd1cf6aff65.1696609476.git.reinette.chatre@intel.com>
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

A virtual device driver needs to facilitate translation between
the guest's MSI-X interrupt and the backing IMS interrupt with
which the physical device is programmed. For example, the
guest may need to obtain the IMS index from the virtual device driver
that it needs to program into descriptors submitted to the device
to ensure that the completion interrupts are generated correctly.

Introduce vfio_pci_ims_hwirq() to the IMS backend as a helper
that returns the IMS interrupt index backing a provided MSI-X
interrupt index belonging to a guest.

Originally-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 25 +++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index f96d7481094a..df458aed2175 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -1203,6 +1203,31 @@ int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_set_emulated);
 
+/*
+ * Return IMS index of IMS interrupt backing MSI-X interrupt @vector
+ */
+int vfio_pci_ims_hwirq(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	int id = -EINVAL;
+
+	mutex_lock(&intr_ctx->igate);
+
+	if (!intr_ctx->ims_backed_irq)
+		goto out_unlock;
+
+	ctx = vfio_irq_ctx_get(intr_ctx, vector);
+	if (!ctx || ctx->emulated)
+		goto out_unlock;
+
+	id = ctx->ims_id;
+
+out_unlock:
+	mutex_unlock(&intr_ctx->igate);
+	return id;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_hwirq);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 3c5df1d13e5d..c6e399b39e90 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -167,6 +167,7 @@ int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
 			       struct vfio_pci_intr_ctx *intr_ctx,
 			       struct pci_dev *pdev,
 			       union msi_instance_cookie *default_cookie);
+int vfio_pci_ims_hwirq(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
 void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
-- 
2.34.1

