Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D21A27E
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849860; cv=none; b=FjJXzdGKoqPNdOlGsVFz5VXYiYNv6rbynStbMIWCYHwMWZJzy+Wl2oq9lS2NqCVoZDOma6jRTTevnwn1VCa4XUQ1JXvUwnV/srelTj56IzoDotnn/2BesqTWfD7B1etWP5e/+g9H8++iVJNAj+PRdeTbZDkC5P9yDAAcyrbH2CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849860; c=relaxed/simple;
	bh=4QFGx+82iSOQD5Uy7w9iqIN8hz1HoOJM57vM7BEXPkc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LFPn5xMl0VNPzFWWlk6R4RmiCfAAnevGgz3SU8XkYGVuqFWphFSU6r5AQx15pUEWqhANC0xILncjyjflYmNOvlODYIazhN4aUu26uiZV/vwIhWXN1ueMFJ80e/YWMnnqAzdOTsCUdtWqzcL91LLn/mN3/ZdgjhFZ1hLALE/2dVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DYk3o2Sy; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DYk3o2Sy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849858; x=1738385858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4QFGx+82iSOQD5Uy7w9iqIN8hz1HoOJM57vM7BEXPkc=;
  b=DYk3o2SyNZ+we9v9IaUIOtSt0uUoeUATQUa9gPaYS82bCqpLUNyOw3al
   /f98ms1fviLMquHoRdDhVLahNi/O6++jjsABhS8hEfDKP1ioLteMyD7oF
   xeAZeh5ePonjQFGL9clyuANglneKOl7mCPV9NaqsW3eZFvcURs3TpZEOl
   q0oIG7CuT6F/bAY8MfwkIB/RXB84Ckni+aw5XYCj9T4SCw6ePfCjlcm47
   mvy8aYEGYxEStyywPXi4Gue14uWW349nAkMTFQyQcI6XBP9ldme4zD5Dq
   2pyXTHUpOO3hxaKsQK0tNbIeiGrdvSKHaBSRy5o11lxn5pmh2FVFsPiy3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615863"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615863"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339806"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339806"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
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
Subject: [PATCH 17/17] vfio/pci: Remove duplicate interrupt management flow
Date: Thu,  1 Feb 2024 20:57:11 -0800
Message-Id: <6ec901daffab4170d9740c7d066becd079925d53.1706849424.git.reinette.chatre@intel.com>
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

vfio_pci_set_intx_trigger() and vfio_pci_set_trigger() have the
same flow that calls interrupt type (INTx, MSI, MSI-X) specific
functions.

Create callbacks for the interrupt type specific code that
can be called by the shared code so that only one of these functions
are needed. Rename the final generic function shared by all
interrupt types vfio_pci_set_trigger().

Relocate the "IOCTL support" marker to correctly mark the
now generic code.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 104 ++++++++++--------------------
 1 file changed, 35 insertions(+), 69 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index daa84a317f40..a5b337cfae60 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -32,6 +32,12 @@ struct vfio_pci_irq_ctx {
 };
 
 struct vfio_pci_intr_ops {
+	int (*enable)(struct vfio_pci_core_device *vdev, unsigned int start,
+		      unsigned int count, unsigned int index);
+	void (*disable)(struct vfio_pci_core_device *vdev,
+			unsigned int index);
+	void (*send_eventfd)(struct vfio_pci_core_device *vdev,
+			     struct vfio_pci_irq_ctx *ctx);
 	int (*request_interrupt)(struct vfio_pci_core_device *vdev,
 				 struct vfio_pci_irq_ctx *ctx,
 				 unsigned int vector, unsigned int index);
@@ -356,6 +362,12 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev,
 /*
  * MSI/MSI-X
  */
+static void vfio_send_msi_eventfd(struct vfio_pci_core_device *vdev,
+				  struct vfio_pci_irq_ctx *ctx)
+{
+	eventfd_signal(ctx->trigger);
+}
+
 static irqreturn_t vfio_msihandler(int irq, void *arg)
 {
 	struct eventfd_ctx *trigger = arg;
@@ -544,13 +556,22 @@ static void vfio_msi_unregister_producer(struct vfio_pci_irq_ctx *ctx)
 	irq_bypass_unregister_producer(&ctx->producer);
 }
 
+/*
+ * IOCTL support
+ */
 static struct vfio_pci_intr_ops intr_ops[] = {
 	[VFIO_PCI_INTX_IRQ_INDEX] = {
+		.enable = vfio_intx_enable,
+		.disable = vfio_intx_disable,
+		.send_eventfd = vfio_send_intx_eventfd_ctx,
 		.request_interrupt = vfio_intx_request_interrupt,
 		.free_interrupt = vfio_intx_free_interrupt,
 		.device_name = vfio_intx_device_name,
 	},
 	[VFIO_PCI_MSI_IRQ_INDEX] = {
+		.enable = vfio_msi_enable,
+		.disable = vfio_msi_disable,
+		.send_eventfd = vfio_send_msi_eventfd,
 		.request_interrupt = vfio_msi_request_interrupt,
 		.free_interrupt = vfio_msi_free_interrupt,
 		.device_name = vfio_msi_device_name,
@@ -558,6 +579,9 @@ static struct vfio_pci_intr_ops intr_ops[] = {
 		.unregister_producer = vfio_msi_unregister_producer,
 	},
 	[VFIO_PCI_MSIX_IRQ_INDEX] = {
+		.enable = vfio_msi_enable,
+		.disable = vfio_msi_disable,
+		.send_eventfd = vfio_send_msi_eventfd,
 		.request_interrupt = vfio_msi_request_interrupt,
 		.free_interrupt = vfio_msi_free_interrupt,
 		.device_name = vfio_msi_device_name,
@@ -646,9 +670,6 @@ static int vfio_irq_set_block(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-/*
- * IOCTL support
- */
 static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
@@ -701,71 +722,16 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
-				     unsigned int index, unsigned int start,
-				     unsigned int count, uint32_t flags,
-				     void *data)
-{
-	struct vfio_pci_irq_ctx *ctx;
-	unsigned int i;
-
-	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_intx_disable(vdev, index);
-		return 0;
-	}
-
-	if (!(is_intx(vdev) || is_irq_none(vdev)))
-		return -EINVAL;
-
-	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
-		int32_t *fds = data;
-		int ret;
-
-		if (is_intx(vdev))
-			return vfio_irq_set_block(vdev, start, count, fds, index);
-
-		ret = vfio_intx_enable(vdev, start, count, index);
-		if (ret)
-			return ret;
-
-		ret = vfio_irq_set_block(vdev, start, count, fds, index);
-		if (ret)
-			vfio_intx_disable(vdev, index);
-
-		return ret;
-	}
-
-	if (!is_intx(vdev))
-		return -EINVAL;
-
-	/* temporary */
-	for (i = start; i < start + count; i++) {
-		ctx = vfio_irq_ctx_get(vdev, i);
-		if (!ctx || !ctx->trigger)
-			continue;
-		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-			vfio_send_intx_eventfd_ctx(vdev, ctx);
-		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
-			uint8_t *bools = data;
-
-			if (bools[i - start])
-				vfio_send_intx_eventfd_ctx(vdev, ctx);
-		}
-	}
-
-	return 0;
-}
-
-static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned int index, unsigned int start,
-				    unsigned int count, uint32_t flags,
-				    void *data)
+static int vfio_pci_set_trigger(struct vfio_pci_core_device *vdev,
+				unsigned int index, unsigned int start,
+				unsigned int count, uint32_t flags,
+				void *data)
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_msi_disable(vdev, index);
+		intr_ops[index].disable(vdev, index);
 		return 0;
 	}
 
@@ -780,13 +746,13 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 			return vfio_irq_set_block(vdev, start, count,
 						  fds, index);
 
-		ret = vfio_msi_enable(vdev, start, count, index);
+		ret = intr_ops[index].enable(vdev, start, count, index);
 		if (ret)
 			return ret;
 
 		ret = vfio_irq_set_block(vdev, start, count, fds, index);
 		if (ret)
-			vfio_msi_disable(vdev, index);
+			intr_ops[index].disable(vdev, index);
 
 		return ret;
 	}
@@ -799,11 +765,11 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 		if (!ctx || !ctx->trigger)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-			eventfd_signal(ctx->trigger);
+			intr_ops[index].send_eventfd(vdev, ctx);
 		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 			uint8_t *bools = data;
 			if (bools[i - start])
-				eventfd_signal(ctx->trigger);
+				intr_ops[index].send_eventfd(vdev, ctx);
 		}
 	}
 	return 0;
@@ -912,7 +878,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			func = vfio_pci_set_intx_unmask;
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_intx_trigger;
+			func = vfio_pci_set_trigger;
 			break;
 		}
 		break;
@@ -924,7 +890,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			/* XXX Need masking support exported */
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_msi_trigger;
+			func = vfio_pci_set_trigger;
 			break;
 		}
 		break;
-- 
2.34.1

