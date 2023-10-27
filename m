Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0438FBB
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWr8UCFt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426092; x=1729962092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XaZOFPsmwRizI8imFAFKLm4WgdKXG4jjNnA6hIazfMw=;
  b=OWr8UCFtmmHBzpvTfDIliksmg+0gmEQ/UlX/P7ngzjrsNdPS/pUMCLmx
   wjNilHiCjshfv46aTy3e+jExhhdvqcbtRiEenMg+sPpRpLRuFovaSXDgB
   YIYSlPjjhKw2lR22wSy9OxqEvAPO+EJB9+CbdoYYdRg9qsDPNCGVAGNRt
   eVGAFQWro+XSxCxUljaPdRhthuN7qJUHYOWGQ5jZ4A6yy2ptd0YXkk4Pu
   oX29L/uLPT4lo/yrl66Q3knwWvfXlc7rfFkjcV8OoVPRBYRlXHMwuXiEs
   +wjgk1WDLew2MWXO6scqZ6Nvw8SMpHlt0KJOBWSLI1kqNA9v1Jco5+quX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611885"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611885"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988169"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988169"
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
Subject: [RFC PATCH V3 07/26] vfio/pci: Move interrupt eventfd to interrupt context
Date: Fri, 27 Oct 2023 10:00:39 -0700
Message-Id: <f43b8f19cf25e8c73e0f3f803712db7a8a54263b.1698422237.git.reinette.chatre@intel.com>
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

The eventfds associated with device request notification and
error IRQ are managed by VFIO PCI interrupt management as
triggered by the VFIO_DEVICE_SET_IRQS ioctl().

Move these eventfds as well as their mutex to the generic and
dedicated interrupt management context struct vfio_pci_intr_ctx
to enable another interrupt management backend to manage these
eventfd.

igate mutex protects eventfd modification. With the eventfd
within the bigger scoped interrupt context the mutex scope is
also expanded to mean that all members of struct
vfio_pci_intr_ctx are protected by it.

This move results in the vfio_pci_set_req_trigger() to
no longer require a struct vfio_pci_core_device, operating
just on the generic struct vfio_pci_intr_ctx, and thus
available for direct use by other interrupt management
backends.

This introduces the first interrupt context related
cleanup call. Create vfio_pci_release_intr_ctx()
to match existing vfio_pci_init_intr_ctx().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Improve changelog.

 drivers/vfio/pci/vfio_pci_core.c  | 39 +++++++++++++++----------------
 drivers/vfio/pci/vfio_pci_intrs.c | 13 +++++++----
 include/linux/vfio_pci_core.h     | 10 +++++---
 3 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 310259bbacae..5c9bd5d2db53 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -700,16 +700,16 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 #endif
 	vfio_pci_core_disable(vdev);
 
-	mutex_lock(&vdev->igate);
-	if (vdev->err_trigger) {
-		eventfd_ctx_put(vdev->err_trigger);
-		vdev->err_trigger = NULL;
+	mutex_lock(&vdev->intr_ctx.igate);
+	if (vdev->intr_ctx.err_trigger) {
+		eventfd_ctx_put(vdev->intr_ctx.err_trigger);
+		vdev->intr_ctx.err_trigger = NULL;
 	}
-	if (vdev->req_trigger) {
-		eventfd_ctx_put(vdev->req_trigger);
-		vdev->req_trigger = NULL;
+	if (vdev->intr_ctx.req_trigger) {
+		eventfd_ctx_put(vdev->intr_ctx.req_trigger);
+		vdev->intr_ctx.req_trigger = NULL;
 	}
-	mutex_unlock(&vdev->igate);
+	mutex_unlock(&vdev->intr_ctx.igate);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 
@@ -1214,12 +1214,12 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 			return PTR_ERR(data);
 	}
 
-	mutex_lock(&vdev->igate);
+	mutex_lock(&vdev->intr_ctx.igate);
 
 	ret = vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, hdr.flags, hdr.index,
 				      hdr.start, hdr.count, data);
 
-	mutex_unlock(&vdev->igate);
+	mutex_unlock(&vdev->intr_ctx.igate);
 	kfree(data);
 
 	return ret;
@@ -1876,20 +1876,20 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 
-	mutex_lock(&vdev->igate);
+	mutex_lock(&vdev->intr_ctx.igate);
 
-	if (vdev->req_trigger) {
+	if (vdev->intr_ctx.req_trigger) {
 		if (!(count % 10))
 			pci_notice_ratelimited(pdev,
 				"Relaying device request to user (#%u)\n",
 				count);
-		eventfd_signal(vdev->req_trigger, 1);
+		eventfd_signal(vdev->intr_ctx.req_trigger, 1);
 	} else if (count == 0) {
 		pci_warn(pdev,
 			"No device request channel registered, blocked until released by user\n");
 	}
 
-	mutex_unlock(&vdev->igate);
+	mutex_unlock(&vdev->intr_ctx.igate);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
@@ -2156,7 +2156,6 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
@@ -2177,7 +2176,7 @@ void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
-	mutex_destroy(&vdev->igate);
+	vfio_pci_release_intr_ctx(&vdev->intr_ctx);
 	mutex_destroy(&vdev->ioeventfds_lock);
 	mutex_destroy(&vdev->vma_lock);
 	kfree(vdev->region);
@@ -2300,12 +2299,12 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 {
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
 
-	mutex_lock(&vdev->igate);
+	mutex_lock(&vdev->intr_ctx.igate);
 
-	if (vdev->err_trigger)
-		eventfd_signal(vdev->err_trigger, 1);
+	if (vdev->intr_ctx.err_trigger)
+		eventfd_signal(vdev->intr_ctx.err_trigger, 1);
 
-	mutex_unlock(&vdev->igate);
+	mutex_unlock(&vdev->intr_ctx.igate);
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 7de906363402..a4c8b589c87b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -778,7 +778,7 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->err_trigger,
+	return vfio_pci_set_ctx_trigger_single(&intr_ctx->err_trigger,
 					       count, flags, data);
 }
 
@@ -787,12 +787,10 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
-	struct vfio_pci_core_device *vdev = intr_ctx->priv;
-
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->req_trigger,
+	return vfio_pci_set_ctx_trigger_single(&intr_ctx->req_trigger,
 					       count, flags, data);
 }
 
@@ -811,9 +809,16 @@ void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 {
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
+	mutex_init(&intr_ctx->igate);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
+void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
+{
+	mutex_destroy(&intr_ctx->igate);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_release_intr_ctx);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index db7ee9517d94..1eb5842cff11 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -53,10 +53,16 @@ struct vfio_pci_region {
  * Interrupt context of virtual PCI device
  * @ops:		Interrupt management backend functions
  * @priv:		Private data of interrupt management backend
+ * @igate:		Protects members of struct vfio_pci_intr_ctx
+ * @err_trigger:	Eventfd associated with error reporting IRQ
+ * @req_trigger:	Eventfd associated with device request notification
  */
 struct vfio_pci_intr_ctx {
 	const struct vfio_pci_intr_ops	*ops;
 	void				*priv;
+	struct mutex			igate;
+	struct eventfd_ctx		*err_trigger;
+	struct eventfd_ctx		*req_trigger;
 };
 
 struct vfio_pci_intr_ops {
@@ -92,7 +98,6 @@ struct vfio_pci_core_device {
 	u8			*vconfig;
 	struct perm_bits	*msi_perm;
 	spinlock_t		irqlock;
-	struct mutex		igate;
 	struct xarray		ctx;
 	int			irq_type;
 	int			num_regions;
@@ -117,8 +122,6 @@ struct vfio_pci_core_device {
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-	struct eventfd_ctx	*err_trigger;
-	struct eventfd_ctx	*req_trigger;
 	struct eventfd_ctx	*pm_wake_eventfd_ctx;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
@@ -152,6 +155,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
 void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 			    struct vfio_pci_intr_ctx *intr_ctx);
+void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
-- 
2.34.1

