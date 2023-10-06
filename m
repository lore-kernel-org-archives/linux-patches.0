Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805BF28E03
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hr7VP9+N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610503; x=1728146503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TaJU+BXhlSfdeHrywobTwHC64nLbtaTPM5WirImEic8=;
  b=Hr7VP9+NysTWc25R6LPJrCinX4k3mbP/WLt5HM1eUH5O9JXdyrRTYcSi
   iuLoLD8TrR9jbUe4BCI9scx8mSfaHgp+T8eC1E0lu3jFJ0nP01yKPiHoI
   CFfXe8wK5z17fYkip58+zXO9wNiInT57/BWhMW/WofBHgyGhKX9QPErlr
   RpcuW83oT5ONjKjsRBWmQY2REqd7GfGczlzUFhSvJEnD7ujC3U9s6O8vd
   Y7eKyfuu4ew1qGF4/lo7MX8FcBJ6efwaEZ3OnTxZqz+dIGXbxMWJGIuix
   5ytob0I5c3Q1Q73WyYWRI1ZbxEDRek3eXoJ0GtLdmerVaMZY32pAcJmQZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063234"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063234"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892889"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892889"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:27 -0700
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
Subject: [RFC PATCH V2 15/18] vfio/pci: Support emulated interrupts
Date: Fri,  6 Oct 2023 09:41:10 -0700
Message-Id: <bb8e249259f021a57eb9185f3178a665f39f82be.1696609476.git.reinette.chatre@intel.com>
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
to be emulated. A backend indicates support for emulated interrupts
with vfio_pci_intr_ctx::supports_emulated.

Any range of interrupts can be configured as emulated when the backend
supports emulated interrupts as long as no interrupt has previously been
allocated at that vector. The virtual device driver uses
vfio_pci_send_signal() to trigger interrupts in the guest.

Originally-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 86 +++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |  4 ++
 2 files changed, 90 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 7880fd4077a6..c6b213d52beb 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -38,6 +38,7 @@ struct vfio_pci_ims {
 };
 
 struct vfio_pci_irq_ctx {
+	bool			emulated:1;
 	struct eventfd_ctx	*trigger;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
@@ -847,6 +848,7 @@ void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
 	intr_ctx->ims_backed_irq = false;
+	intr_ctx->supports_emulated = false;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
@@ -1076,6 +1078,7 @@ int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
 
 	intr_ctx->ops = &vfio_pci_ims_intr_ops;
 	intr_ctx->priv = ims;
+	intr_ctx->supports_emulated = false;
 	intr_ctx->ims_backed_irq = true;
 
 	return 0;
@@ -1106,6 +1109,89 @@ void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_ims_release_intr_ctx);
 
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
+	if (!intr_ctx->supports_emulated)
+		goto out_unlock;
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
+	if (!intr_ctx->supports_emulated)
+		goto out_unlock;
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
+out_unlock:
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
index 13b807848286..3c5df1d13e5d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -67,6 +67,7 @@ struct vfio_pci_intr_ctx {
 	struct eventfd_ctx		*req_trigger;
 	struct xarray			ctx;
 	int				irq_type;
+	bool				supports_emulated:1;
 	bool				ims_backed_irq:1;
 };
 
@@ -167,6 +168,9 @@ int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
 			       struct pci_dev *pdev,
 			       union msi_instance_cookie *default_cookie);
 void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
+void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
+int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
+			  unsigned int start, unsigned int count);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-- 
2.34.1

