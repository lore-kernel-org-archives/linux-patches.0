Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79C318AE0
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 04:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849858; cv=none; b=iRJYVgrWflxikkS+5L9ARriTz6/Zkq4LN2b8311z+QMcxa1Brw5qobXSeux57Oz3nrLdZqOKkR15kMAwvobOgvwXzvRtJd/v4BsmCmNS7T3YveTdvh+jv/sWYjHbCD7Qbscv1Kn92urRPMg+silTcHe2TuoTzBWvaRCzajgdPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849858; c=relaxed/simple;
	bh=QAj3VSDW4vnn+85iNztQ9s3NyXx5nCvtMRrW9/sf7+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HWkFRrw6VoeB6VWtLHOrEwKDKvZgskeutYlvEovIIHmgMeY1UneSJajkClnMTN8bO0SZexT0PqkOYrU5yx2xYRhN+dYkrcy/9l64fgLy+X74Ec+dox3oBodGO9mfiZOh8MkOrPGU3xVK5sDacWn7JLBLdcNL4ewbLtKwXThUk/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BiBnVGqP; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BiBnVGqP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849857; x=1738385857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QAj3VSDW4vnn+85iNztQ9s3NyXx5nCvtMRrW9/sf7+4=;
  b=BiBnVGqPRvlahaCvBc9u5hp18MGI7rjvXeLLsV5iLWYeSK0E97WxLa3E
   4JdZaOssNPyc/1JdYCfaTW61p5xADwageOMGOgq6t2f+VFZevprGb6L37
   E+aiwjG028S2FawMLQMwvgd6p1qM0pkyQOtTJTKrcfCPyOlkQtBri43B1
   utEep5R+TXCOcpXPPfdP04Sm/N94kdqZQ72CmyOLN2OWQBMcFWEpHa5GJ
   NGp8i0ewJUfrKwVesyRSchu3AlpZ80eLl+oLRB/wDkyUwU04rbdGEgvF9
   TElc2YhQ2wVj6bEedwICM/ewO3yQg7azCini3FAAZmqA+AulPbf8Jz+5A
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615851"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615851"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339798"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339798"
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
Subject: [PATCH 14/17] vfio/pci: Add utility to trigger INTx eventfd knowing interrupt context
Date: Thu,  1 Feb 2024 20:57:08 -0800
Message-Id: <e9a8d78ed76e253c5c9f71484da91070ce5df775.1706849424.git.reinette.chatre@intel.com>
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

vfio_send_intx_eventfd() is available to signal the eventfd associated
with the INTx interrupt. It does so by first obtaining the vector's
interrupt context and then signaling the eventfd. The interrupt context
may already be available before vfio_send_intx_eventfd() is called,
making the additional query unnecessary.

Introduce vfio_send_intx_eventfd_ctx() that can be used to signal the
eventfd associated with the INTx interrupt when the interrupt context
is already known and use it instead of vfio_send_intx_eventfd() in the
one instance where the interrupt context is already known.

Replace usage of vfio_send_intx_eventfd() within
vfio_pci_set_intx_trigger() with a new snippet that results in the
same functionality while mirroring the flow vfio_pci_set_msi_trigger()
as a preparatory step to merge vfio_pci_set_msi_trigger() and
vfio_pci_set_intx_trigger(). The new snippet is marked as
"temporary" until the flows are merged.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 32 ++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d7c2cd739d74..37065623d286 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -103,6 +103,13 @@ vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
 /*
  * INTx
  */
+static void vfio_send_intx_eventfd_ctx(struct vfio_pci_core_device *vdev,
+				       struct vfio_pci_irq_ctx *ctx)
+{
+	if (likely(is_intx(vdev) && !vdev->virq_disabled))
+		eventfd_signal(ctx->trigger);
+}
+
 static void vfio_send_intx_eventfd(void *opaque, void *unused)
 {
 	struct vfio_pci_core_device *vdev = opaque;
@@ -245,7 +252,7 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
 	if (ret == IRQ_HANDLED)
-		vfio_send_intx_eventfd(vdev, NULL);
+		vfio_send_intx_eventfd_ctx(vdev, ctx);
 
 	return ret;
 }
@@ -690,6 +697,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 				     unsigned int count, uint32_t flags,
 				     void *data)
 {
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned int i;
+
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
 		return 0;
@@ -719,13 +729,21 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	if (!is_intx(vdev))
 		return -EINVAL;
 
-	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_send_intx_eventfd(vdev, NULL);
-	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
-		uint8_t trigger = *(uint8_t *)data;
-		if (trigger)
-			vfio_send_intx_eventfd(vdev, NULL);
+	/* temporary */
+	for (i = start; i < start + count; i++) {
+		ctx = vfio_irq_ctx_get(vdev, i);
+		if (!ctx || !ctx->trigger)
+			continue;
+		if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			vfio_send_intx_eventfd_ctx(vdev, ctx);
+		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+			uint8_t *bools = data;
+
+			if (bools[i - start])
+				vfio_send_intx_eventfd_ctx(vdev, ctx);
+		}
 	}
+
 	return 0;
 }
 
-- 
2.34.1

