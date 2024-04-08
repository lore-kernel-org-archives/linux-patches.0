Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BA37FBAF;
	Mon,  8 Apr 2024 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584800; cv=none; b=Lo6x4mFEqFY6BZkLPpoc4olY9rPAD/qilSt+YI8eDvYj2IWX45Zti8njgJonI/C8Cqg5qeL0EmL034VSJuopuXADbkQJsTAi9TNZgvAjK5/GG8Rcv2BD7u6EuZuzfrsqUtkkJriNtfx7WGSWL/Lmd6q9KpAyqUuNEVUAKcJpLNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584800; c=relaxed/simple;
	bh=q8sMp8kGQH1QPa+IvpAyYesEQUSNfYfKNh9MGYdLWnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgBIV4MvMXGUuqhDSDZA9SbB91W10yhxDU+AcwTaKOiFcxPBEyC54cTOJAmRwA6/KgBvN+53/G0/AW7mwIJqQcVD7+1yKtSbcwl9lNGwug8rBn2MvJWt1BDqTMz+NBMVcgq1PRw5dG088eNOyWZZGu2LVdECekmB+OQaCJ+uUBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WD68KZ/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WD68KZ/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A8BC433F1;
	Mon,  8 Apr 2024 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584800;
	bh=q8sMp8kGQH1QPa+IvpAyYesEQUSNfYfKNh9MGYdLWnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WD68KZ/9ym+SORWLlt5hV/skwKWzcCnVSmj+oQLJjPIeFJk6Ot90kqq3RUDyWyHZm
	 Ln1Veotzu4EYeX0pjs3T98tdaVkB4yviCXIkFUwAxv99XnPdDAntDBMsqaSOyLny4d
	 I9gFkvmK1fcOcuHOtz+Cdard13Belp1zG1uEfbyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.15 562/690] vfio/pci: Lock external INTx masking ops
Date: Mon,  8 Apr 2024 14:57:08 +0200
Message-ID: <20240408125419.999234256@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -33,11 +33,13 @@ static void vfio_send_intx_eventfd(void
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
 
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+static void __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
 
+	lockdep_assert_held(&vdev->igate);
+
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
 	/*
@@ -65,6 +67,13 @@ void vfio_pci_intx_mask(struct vfio_pci_
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 }
 
+void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+{
+	mutex_lock(&vdev->igate);
+	__vfio_pci_intx_mask(vdev);
+	mutex_unlock(&vdev->igate);
+}
+
 /*
  * If this is triggered by an eventfd, we can't call eventfd_signal
  * or else we'll deadlock on the eventfd wait queue.  Return >0 when
@@ -107,12 +116,21 @@ static int vfio_pci_intx_unmask_handler(
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
@@ -428,11 +446,11 @@ static int vfio_pci_set_intx_unmask(stru
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
 		int32_t fd = *(int32_t *)data;
 		if (fd >= 0)
@@ -455,11 +473,11 @@ static int vfio_pci_set_intx_mask(struct
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


