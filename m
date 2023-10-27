Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E4F3984F
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QKLWV0Eh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426104; x=1729962104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=81vCVvogpN6l9KpHrXDO0EMLjJAz80Wg8hp5eZraD+Q=;
  b=QKLWV0Eh2jjETKuFDLNwWwYDkkc1+Y810Nbjh8PiVIPP3JzawNqlROhh
   3p7cs6Be7R8K1r7UiWEykobugXWYcnSz9kZ/DLrv22aDVc9iITTH6gDb6
   jtZIEsoEZPm1T7b2FJxpIl0lJuy4WP+FGsT/52KJWFyDLm8SPs4tmNtIo
   JvJMG4TJpRSnEQEzBfSkBsfOLvAnkCOWers5TYJqx5EaqrK3KAnZTNFyw
   o3WfXhaaIcmPuXgcyVHoK21xf4r9UliqjQrtB/A2PLTWUitnppPdzrOHL
   X40IKdR1dN0mwiOJfLcaGOR+4w4rWPWEtlnNOV4VJ/S+xtgutPoaEhpLb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612130"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612130"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988233"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988233"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
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
Subject: [RFC PATCH V3 23/26] vfio/pci: Support emulated interrupts
Date: Fri, 27 Oct 2023 10:00:55 -0700
Message-Id: <5c1e815b67aa51dfa229027147e7c2e5a7676eea.1698422237.git.reinette.chatre@intel.com>
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

Access from a guest to a virtual device may be either 'direct-path',
where the guest interacts directly with the underlying hardware,
or 'intercepted path' where the virtual device emulates operations.

Support emulated interrupts that can be used to handle 'intercepted
path' operations. For example, a virtual device may use 'intercepted
path' for configuration. Doing so, configuration requests intercepted
by the virtual device driver are handled within the virtual device
driver with completion signaled to the guest without interacting with
the underlying hardware.

Add vfio_pci_set_emulated() and vfio_pci_send_signal() to the
VFIO PCI API. vfio_pci_set_emulated() configures a range of interrupts
to be emulated.

Any range of interrupts can be configured as emulated as long as no
interrupt has previously been allocated at that vector. The virtual
device driver uses vfio_pci_send_signal() to trigger interrupts in
the guest.

Originally-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Remove the backend "supports_emulated" flag. All backends now support
  emulated interrupts.
- Move emulated interrupt enabling from IMS backend to frontend.

 drivers/vfio/pci/vfio_pci_intrs.c | 87 ++++++++++++++++++++++++++++++-
 include/linux/vfio_pci_core.h     |  3 ++
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8c86f2d6229f..6e34b8d8c216 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -23,6 +23,7 @@
 #include "vfio_pci_priv.h"
 
 struct vfio_pci_irq_ctx {
+	bool			emulated:1;
 	struct eventfd_ctx	*trigger;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
@@ -497,8 +498,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 	ctx = vfio_irq_ctx_get(intr_ctx, vector);
 
 	if (ctx && ctx->trigger) {
-		irq_bypass_unregister_producer(&ctx->producer);
-		intr_ctx->ops->msi_free_interrupt(intr_ctx, ctx, vector);
+		if (!ctx->emulated) {
+			irq_bypass_unregister_producer(&ctx->producer);
+			intr_ctx->ops->msi_free_interrupt(intr_ctx, ctx, vector);
+		}
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -527,6 +530,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	ctx->trigger = trigger;
 
+	if (ctx->emulated)
+		return 0;
+
 	ret = intr_ctx->ops->msi_request_interrupt(intr_ctx, ctx, vector, index);
 	if (ret)
 		goto out_put_eventfd_ctx;
@@ -902,6 +908,83 @@ void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_release_intr_ctx);
 
+/*
+ * vfio_pci_send_signal() - Send signal to the eventfd.
+ * @intr_ctx:	Interrupt context.
+ * @vector:	Vector for which interrupt will be signaled.
+ *
+ * Trigger signal to guest for emulated interrupts.
+ */
+void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector)
+{
+	struct vfio_pci_irq_ctx *ctx;
+
+	mutex_lock(&intr_ctx->igate);
+
+	ctx = vfio_irq_ctx_get(intr_ctx, vector);
+
+	if (WARN_ON_ONCE(!ctx || !ctx->emulated || !ctx->trigger))
+		goto out_unlock;
+
+	eventfd_signal(ctx->trigger, 1);
+
+out_unlock:
+	mutex_unlock(&intr_ctx->igate);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_send_signal);
+
+/*
+ * vfio_pci_set_emulated() - Set range of interrupts that will be emulated.
+ * @intr_ctx:	Interrupt context.
+ * @start:	First emulated interrupt vector.
+ * @count:	Number of emulated interrupts starting from @start.
+ *
+ * Emulated interrupts will not be backed by hardware interrupts but
+ * instead triggered by virtual device driver.
+ *
+ * Return: error code on failure (-EBUSY if the vector is not available,
+ * -ENOMEM on allocation failure), 0 on success. No partial success, on
+ * success entire range was set as emulated, on failure no interrupt in
+ * range was set as emulated.
+ */
+int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
+			  unsigned int start, unsigned int count)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long i, j;
+	int ret = -EINVAL;
+
+	mutex_lock(&intr_ctx->igate);
+
+	for (i = start; i < start + count; i++) {
+		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+		if (!ctx) {
+			ret = -ENOMEM;
+			goto out_err;
+		}
+		ctx->emulated = true;
+		ret = xa_insert(&intr_ctx->ctx, i, ctx, GFP_KERNEL_ACCOUNT);
+		if (ret) {
+			kfree(ctx);
+			goto out_err;
+		}
+	}
+
+	mutex_unlock(&intr_ctx->igate);
+	return 0;
+
+out_err:
+	for (j = start; j < i; j++) {
+		ctx = vfio_irq_ctx_get(intr_ctx, j);
+		vfio_irq_ctx_free(intr_ctx, ctx, j);
+	}
+
+	mutex_unlock(&intr_ctx->igate);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_set_emulated);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index d5140a732741..4fe0df25162f 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -178,6 +178,9 @@ void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data);
+void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
+int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
+			  unsigned int start, unsigned int count);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-- 
2.34.1

