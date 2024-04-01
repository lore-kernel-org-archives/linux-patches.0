Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1844AED9;
	Mon,  1 Apr 2024 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986980; cv=none; b=N2yQMGsJH0QPWDVRX/OJGScZaXHuJwUXxU2mozEOqp2AT8C5EHq9h3qp/HduH/hHtvLMZABxbUBxYVZRghYB5HNXm3/G+1Xm6iqeJhAHu1t06ELKl3CvkngUsPXRS6rtRu4LvCDDManma6ThpBtL7KAIb3pmtKDcw3bV+HcFIHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986980; c=relaxed/simple;
	bh=fj+AcyNKdYqLG7WleY7X/hXTI7Vv8XhkGQaY5LtLAVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgfF70XXZbp0Nh5lcRxEyxnJNzq/aDmMSqGHCLPLkv8D+XfYqaqz5c8T03rdS2nfHzecnlkBbM8gxZUBxzEsjxk6CEjyVyh/KpzjihL4P3CZIN1ycIdGWrZu8ERWfhKoGRGw592oFJq0LR83uiyCuc3N3YnV5N8Jms0d+B5E/oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbnOeCUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbnOeCUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB7FC433C7;
	Mon,  1 Apr 2024 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986980;
	bh=fj+AcyNKdYqLG7WleY7X/hXTI7Vv8XhkGQaY5LtLAVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbnOeCUhEYQ/DVnybjxf37UJOcrnFUxez0kv4GP8paLbP1U4mtob/5OicCkBaJt7r
	 JCNjMSgvqsjEjQargxgtu/oBQk5Y1cVUoYeLakQAhAX32DMVmGunURlQyfrFidaZQw
	 MWuGipp+8+uQ4VMw+n5+psHliQsF4hM4rkwvx310=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 147/399] vfio/pci: Lock external INTx masking ops
Date: Mon,  1 Apr 2024 17:41:53 +0200
Message-ID: <20240401152553.577698825@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 810cd4bb53456d0503cc4e7934e063835152c1b7 ]

Mask operations through config space changes to DisINTx may race INTx
configuration changes via ioctl.  Create wrappers that add locking for
paths outside of the core interrupt code.

In particular, irq_type is updated holding igate, therefore testing
is_intx() requires holding igate.  For example clearing DisINTx from
config space can otherwise race changes of the interrupt configuration.

This aligns interfaces which may trigger the INTx eventfd into two
camps, one side serialized by igate and the other only enabled while
INTx is configured.  A subsequent patch introduces synchronization for
the latter flows.

Cc:  <stable@vger.kernel.org>
Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-3-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 34 +++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 136101179fcbd..75c85eec21b3c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -99,13 +99,15 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 }
 
 /* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
-bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned long flags;
 	bool masked_changed = false;
 
+	lockdep_assert_held(&vdev->igate);
+
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
 	/*
@@ -143,6 +145,17 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 	return masked_changed;
 }
 
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+{
+	bool mask_changed;
+
+	mutex_lock(&vdev->igate);
+	mask_changed = __vfio_pci_intx_mask(vdev);
+	mutex_unlock(&vdev->igate);
+
+	return mask_changed;
+}
+
 /*
  * If this is triggered by an eventfd, we can't call eventfd_signal
  * or else we'll deadlock on the eventfd wait queue.  Return >0 when
@@ -194,12 +207,21 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	return ret;
 }
 
-void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
+static void __vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 {
+	lockdep_assert_held(&vdev->igate);
+
 	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
 		vfio_send_intx_eventfd(vdev, NULL);
 }
 
+void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
+{
+	mutex_lock(&vdev->igate);
+	__vfio_pci_intx_unmask(vdev);
+	mutex_unlock(&vdev->igate);
+}
+
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
 	struct vfio_pci_core_device *vdev = dev_id;
@@ -563,11 +585,11 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_pci_intx_unmask(vdev);
+		__vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t unmask = *(uint8_t *)data;
 		if (unmask)
-			vfio_pci_intx_unmask(vdev);
+			__vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
 		int32_t fd = *(int32_t *)data;
@@ -594,11 +616,11 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_pci_intx_mask(vdev);
+		__vfio_pci_intx_mask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t mask = *(uint8_t *)data;
 		if (mask)
-			vfio_pci_intx_mask(vdev);
+			__vfio_pci_intx_mask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		return -ENOTTY; /* XXX implement me */
 	}
-- 
2.43.0



