Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1447B2837B;
	Mon, 24 Feb 2025 14:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409034; cv=none; b=tNvqKk2+nMj575cW6uAVSBWSdZReXY2XBiIOpvk36VT3xzsmqrWoLYcQHbsckxp6Bxd9SOOrkbcb5kcvIHrW9kxGQ7WkAE7fSVzHBCiCQ76lt4h8Db+QVO37IloD/9GWwdLkAWVh4DttdfZ6RduraJJ25rbSDVepcyWMeHnQQlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409034; c=relaxed/simple;
	bh=zgAoPGunAFrjg0jxOGDJ9PdmNI+QAlAzDGCAbq/mqx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVtxszZC3fTGT9pswK5W5+59hzzy5qYUGd+7ZtOg5OOL3Ly5pSsEAuGxOuvAU86VFo28g5fY9q2m5AowtplxEsY8rxEMsM3AQWU7zjGpRHmtv8Y6fKoHJ7GsK5LivduOqt9xGZ+7xAl4eR8dxGZN9rQSWWG23f8WWLYMnf5CseY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ua6ElXJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ua6ElXJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810BEC4CED6;
	Mon, 24 Feb 2025 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409033;
	bh=zgAoPGunAFrjg0jxOGDJ9PdmNI+QAlAzDGCAbq/mqx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ua6ElXJp0Z+J3XNOtyVeiaaFagQKIII1C/81D/07xiMq/M0ujJ6bQB1/qRFZMkSqT
	 OssfDEA+tuG67/bSP1nwL3I6IsucvHPMjNpaTI7P2VJbgkXh7WJWxhclWRkX85Shp2
	 WqVdVUe+xB4v36RRvV3sL5HVXBY6A6uUsdAqvwVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Levi <ilia.levi@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 077/138] drm/xe/irq: Separate MSI and MSI-X flows
Date: Mon, 24 Feb 2025 15:35:07 +0100
Message-ID: <20250224142607.503141803@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Levi <ilia.levi@intel.com>

[ Upstream commit da889070be7b26b91e8b90f072687ca437d3ed7b ]

A new flow is added for devices that support MSI-X:
- MSI-X vector 0 is used for GuC-to-host interrupt
- MSI-X vector 1 (aka default MSI-X) is used for HW engines

The default MSI-X will be passed to the HW engines in a subsequent
patch.

Signed-off-by: Ilia Levi <ilia.levi@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241213072538.6823-2-ilia.levi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 0c455f3a1229 ("drm/xe: Fix error handling in xe_irq_install()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c       |   4 +-
 drivers/gpu/drm/xe/xe_device.h       |   3 +-
 drivers/gpu/drm/xe/xe_device_types.h |   6 +
 drivers/gpu/drm/xe/xe_irq.c          | 257 +++++++++++++++++++++++----
 drivers/gpu/drm/xe/xe_irq.h          |   3 +
 5 files changed, 237 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 06d6db8b50f93..7f902d50ebf69 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -324,7 +324,9 @@ struct xe_device *xe_device_create(struct pci_dev *pdev,
 	xe->info.revid = pdev->revision;
 	xe->info.force_execlist = xe_modparam.force_execlist;
 
-	spin_lock_init(&xe->irq.lock);
+	err = xe_irq_init(xe);
+	if (err)
+		goto err;
 
 	init_waitqueue_head(&xe->ufence_wq);
 
diff --git a/drivers/gpu/drm/xe/xe_device.h b/drivers/gpu/drm/xe/xe_device.h
index f1fbfe9168678..fc3c2af3fb7fd 100644
--- a/drivers/gpu/drm/xe/xe_device.h
+++ b/drivers/gpu/drm/xe/xe_device.h
@@ -157,8 +157,7 @@ static inline bool xe_device_has_sriov(struct xe_device *xe)
 
 static inline bool xe_device_has_msix(struct xe_device *xe)
 {
-	/* TODO: change this when MSI-X support is fully integrated */
-	return false;
+	return xe->irq.msix.nvec > 0;
 }
 
 static inline bool xe_device_has_memirq(struct xe_device *xe)
diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index 09068ea7349a8..782eb224a46e7 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -346,6 +346,12 @@ struct xe_device {
 
 		/** @irq.enabled: interrupts enabled on this device */
 		atomic_t enabled;
+
+		/** @irq.msix: irq info for platforms that support MSI-X */
+		struct {
+			/** @irq.msix.nvec: number of MSI-X interrupts */
+			u16 nvec;
+		} msix;
 	} irq;
 
 	/** @ttm: ttm device */
diff --git a/drivers/gpu/drm/xe/xe_irq.c b/drivers/gpu/drm/xe/xe_irq.c
index 32547b6a6d1cb..de220ce113c25 100644
--- a/drivers/gpu/drm/xe/xe_irq.c
+++ b/drivers/gpu/drm/xe/xe_irq.c
@@ -10,6 +10,7 @@
 #include <drm/drm_managed.h>
 
 #include "display/xe_display.h"
+#include "regs/xe_guc_regs.h"
 #include "regs/xe_irq_regs.h"
 #include "xe_device.h"
 #include "xe_drv.h"
@@ -29,6 +30,11 @@
 #define IIR(offset)				XE_REG(offset + 0x8)
 #define IER(offset)				XE_REG(offset + 0xc)
 
+static int xe_irq_msix_init(struct xe_device *xe);
+static void xe_irq_msix_free(struct xe_device *xe);
+static int xe_irq_msix_request_irqs(struct xe_device *xe);
+static void xe_irq_msix_synchronize_irq(struct xe_device *xe);
+
 static void assert_iir_is_zero(struct xe_mmio *mmio, struct xe_reg reg)
 {
 	u32 val = xe_mmio_read32(mmio, reg);
@@ -572,6 +578,11 @@ static void xe_irq_reset(struct xe_device *xe)
 	if (IS_SRIOV_VF(xe))
 		return vf_irq_reset(xe);
 
+	if (xe_device_uses_memirq(xe)) {
+		for_each_tile(tile, xe, id)
+			xe_memirq_reset(&tile->memirq);
+	}
+
 	for_each_tile(tile, xe, id) {
 		if (GRAPHICS_VERx100(xe) >= 1210)
 			dg1_irq_reset(tile);
@@ -614,6 +625,14 @@ static void xe_irq_postinstall(struct xe_device *xe)
 	if (IS_SRIOV_VF(xe))
 		return vf_irq_postinstall(xe);
 
+	if (xe_device_uses_memirq(xe)) {
+		struct xe_tile *tile;
+		unsigned int id;
+
+		for_each_tile(tile, xe, id)
+			xe_memirq_postinstall(&tile->memirq);
+	}
+
 	xe_display_irq_postinstall(xe, xe_root_mmio_gt(xe));
 
 	/*
@@ -656,60 +675,83 @@ static irq_handler_t xe_irq_handler(struct xe_device *xe)
 		return xelp_irq_handler;
 }
 
-static void irq_uninstall(void *arg)
+static int xe_irq_msi_request_irqs(struct xe_device *xe)
+{
+	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+	irq_handler_t irq_handler;
+	int irq, err;
+
+	irq_handler = xe_irq_handler(xe);
+	if (!irq_handler) {
+		drm_err(&xe->drm, "No supported interrupt handler");
+		return -EINVAL;
+	}
+
+	irq = pci_irq_vector(pdev, 0);
+	err = request_irq(irq, irq_handler, IRQF_SHARED, DRIVER_NAME, xe);
+	if (err < 0) {
+		drm_err(&xe->drm, "Failed to request MSI IRQ %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void xe_irq_msi_free(struct xe_device *xe)
 {
-	struct xe_device *xe = arg;
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
 	int irq;
 
+	irq = pci_irq_vector(pdev, 0);
+	free_irq(irq, xe);
+}
+
+static void irq_uninstall(void *arg)
+{
+	struct xe_device *xe = arg;
+
 	if (!atomic_xchg(&xe->irq.enabled, 0))
 		return;
 
 	xe_irq_reset(xe);
 
-	irq = pci_irq_vector(pdev, 0);
-	free_irq(irq, xe);
+	if (xe_device_has_msix(xe))
+		xe_irq_msix_free(xe);
+	else
+		xe_irq_msi_free(xe);
+}
+
+int xe_irq_init(struct xe_device *xe)
+{
+	spin_lock_init(&xe->irq.lock);
+
+	return xe_irq_msix_init(xe);
 }
 
 int xe_irq_install(struct xe_device *xe)
 {
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
-	unsigned int irq_flags = PCI_IRQ_MSIX;
-	irq_handler_t irq_handler;
-	int err, irq, nvec;
-
-	irq_handler = xe_irq_handler(xe);
-	if (!irq_handler) {
-		drm_err(&xe->drm, "No supported interrupt handler");
-		return -EINVAL;
-	}
+	unsigned int irq_flags = PCI_IRQ_MSI;
+	int nvec = 1;
+	int err;
 
 	xe_irq_reset(xe);
 
-	nvec = pci_msix_vec_count(pdev);
-	if (nvec <= 0) {
-		if (nvec == -EINVAL) {
-			/* MSIX capability is not supported in the device, using MSI */
-			irq_flags = PCI_IRQ_MSI;
-			nvec = 1;
-		} else {
-			drm_err(&xe->drm, "MSIX: Failed getting count\n");
-			return nvec;
-		}
+	if (xe_device_has_msix(xe)) {
+		nvec = xe->irq.msix.nvec;
+		irq_flags = PCI_IRQ_MSIX;
 	}
 
 	err = pci_alloc_irq_vectors(pdev, nvec, nvec, irq_flags);
 	if (err < 0) {
-		drm_err(&xe->drm, "MSI/MSIX: Failed to enable support %d\n", err);
+		drm_err(&xe->drm, "Failed to allocate IRQ vectors: %d\n", err);
 		return err;
 	}
 
-	irq = pci_irq_vector(pdev, 0);
-	err = request_irq(irq, irq_handler, IRQF_SHARED, DRIVER_NAME, xe);
-	if (err < 0) {
-		drm_err(&xe->drm, "Failed to request MSI/MSIX IRQ %d\n", err);
+	err = xe_device_has_msix(xe) ? xe_irq_msix_request_irqs(xe) :
+					xe_irq_msi_request_irqs(xe);
+	if (err)
 		return err;
-	}
 
 	atomic_set(&xe->irq.enabled, 1);
 
@@ -722,18 +764,28 @@ int xe_irq_install(struct xe_device *xe)
 	return 0;
 
 free_irq_handler:
-	free_irq(irq, xe);
+	if (xe_device_has_msix(xe))
+		xe_irq_msix_free(xe);
+	else
+		xe_irq_msi_free(xe);
 
 	return err;
 }
 
-void xe_irq_suspend(struct xe_device *xe)
+static void xe_irq_msi_synchronize_irq(struct xe_device *xe)
 {
-	int irq = to_pci_dev(xe->drm.dev)->irq;
+	synchronize_irq(to_pci_dev(xe->drm.dev)->irq);
+}
 
+void xe_irq_suspend(struct xe_device *xe)
+{
 	atomic_set(&xe->irq.enabled, 0); /* no new irqs */
 
-	synchronize_irq(irq); /* flush irqs */
+	/* flush irqs */
+	if (xe_device_has_msix(xe))
+		xe_irq_msix_synchronize_irq(xe);
+	else
+		xe_irq_msi_synchronize_irq(xe);
 	xe_irq_reset(xe); /* turn irqs off */
 }
 
@@ -754,3 +806,142 @@ void xe_irq_resume(struct xe_device *xe)
 	for_each_gt(gt, xe, id)
 		xe_irq_enable_hwe(gt);
 }
+
+/* MSI-X related definitions and functions below. */
+
+enum xe_irq_msix_static {
+	GUC2HOST_MSIX = 0,
+	DEFAULT_MSIX = XE_IRQ_DEFAULT_MSIX,
+	/* Must be last */
+	NUM_OF_STATIC_MSIX,
+};
+
+static int xe_irq_msix_init(struct xe_device *xe)
+{
+	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+	int nvec = pci_msix_vec_count(pdev);
+
+	if (nvec == -EINVAL)
+		return 0;  /* MSI */
+
+	if (nvec < 0) {
+		drm_err(&xe->drm, "Failed getting MSI-X vectors count: %d\n", nvec);
+		return nvec;
+	}
+
+	xe->irq.msix.nvec = nvec;
+	return 0;
+}
+
+static irqreturn_t guc2host_irq_handler(int irq, void *arg)
+{
+	struct xe_device *xe = arg;
+	struct xe_tile *tile;
+	u8 id;
+
+	if (!atomic_read(&xe->irq.enabled))
+		return IRQ_NONE;
+
+	for_each_tile(tile, xe, id)
+		xe_guc_irq_handler(&tile->primary_gt->uc.guc,
+				   GUC_INTR_GUC2HOST);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t xe_irq_msix_default_hwe_handler(int irq, void *arg)
+{
+	unsigned int tile_id, gt_id;
+	struct xe_device *xe = arg;
+	struct xe_memirq *memirq;
+	struct xe_hw_engine *hwe;
+	enum xe_hw_engine_id id;
+	struct xe_tile *tile;
+	struct xe_gt *gt;
+
+	if (!atomic_read(&xe->irq.enabled))
+		return IRQ_NONE;
+
+	for_each_tile(tile, xe, tile_id) {
+		memirq = &tile->memirq;
+		if (!memirq->bo)
+			continue;
+
+		for_each_gt(gt, xe, gt_id) {
+			if (gt->tile != tile)
+				continue;
+
+			for_each_hw_engine(hwe, gt, id)
+				xe_memirq_hwe_handler(memirq, hwe);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int xe_irq_msix_request_irq(struct xe_device *xe, irq_handler_t handler,
+				   const char *name, u16 msix)
+{
+	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+	int ret, irq;
+
+	irq = pci_irq_vector(pdev, msix);
+	if (irq < 0)
+		return irq;
+
+	ret = request_irq(irq, handler, IRQF_SHARED, name, xe);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void xe_irq_msix_free_irq(struct xe_device *xe, u16 msix)
+{
+	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+	int irq;
+
+	irq = pci_irq_vector(pdev, msix);
+	if (irq < 0) {
+		drm_err(&xe->drm, "MSI-X %u can't be released, there is no matching IRQ\n", msix);
+		return;
+	}
+
+	free_irq(irq, xe);
+}
+
+static int xe_irq_msix_request_irqs(struct xe_device *xe)
+{
+	int err;
+
+	err = xe_irq_msix_request_irq(xe, guc2host_irq_handler,
+				      DRIVER_NAME "-guc2host", GUC2HOST_MSIX);
+	if (err) {
+		drm_err(&xe->drm, "Failed to request MSI-X IRQ %d: %d\n", GUC2HOST_MSIX, err);
+		return err;
+	}
+
+	err = xe_irq_msix_request_irq(xe, xe_irq_msix_default_hwe_handler,
+				      DRIVER_NAME "-default-msix", DEFAULT_MSIX);
+	if (err) {
+		drm_err(&xe->drm, "Failed to request MSI-X IRQ %d: %d\n", DEFAULT_MSIX, err);
+		xe_irq_msix_free_irq(xe, GUC2HOST_MSIX);
+		return err;
+	}
+
+	return 0;
+}
+
+static void xe_irq_msix_free(struct xe_device *xe)
+{
+	xe_irq_msix_free_irq(xe, GUC2HOST_MSIX);
+	xe_irq_msix_free_irq(xe, DEFAULT_MSIX);
+}
+
+static void xe_irq_msix_synchronize_irq(struct xe_device *xe)
+{
+	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+
+	synchronize_irq(pci_irq_vector(pdev, GUC2HOST_MSIX));
+	synchronize_irq(pci_irq_vector(pdev, DEFAULT_MSIX));
+}
diff --git a/drivers/gpu/drm/xe/xe_irq.h b/drivers/gpu/drm/xe/xe_irq.h
index 067514e13675b..24ff16111b968 100644
--- a/drivers/gpu/drm/xe/xe_irq.h
+++ b/drivers/gpu/drm/xe/xe_irq.h
@@ -6,10 +6,13 @@
 #ifndef _XE_IRQ_H_
 #define _XE_IRQ_H_
 
+#define XE_IRQ_DEFAULT_MSIX 1
+
 struct xe_device;
 struct xe_tile;
 struct xe_gt;
 
+int xe_irq_init(struct xe_device *xe);
 int xe_irq_install(struct xe_device *xe);
 void xe_irq_suspend(struct xe_device *xe);
 void xe_irq_resume(struct xe_device *xe);
-- 
2.39.5



