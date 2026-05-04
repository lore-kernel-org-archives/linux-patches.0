Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C0B3D75CE;
	Mon,  4 May 2026 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902930; cv=none; b=JR0yL5ROvjoPjK7mWhw34CYUhd6uY9Q+8dVC3sRhuPrHo+yxL8buO8cKU5DMJ+Pv0EAUpj9u/PXx9OS6M4KnF3mDmtsRWCzD2dmYmmdAZxSRhWVoSabz8xYdJ5I8R9uiAY2JgFohbJR4l0fJGELBcnt1wCGxG6F9kvSxxrdWtWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902930; c=relaxed/simple;
	bh=UiHYuIaEeusbiJZKW+QqG6XIm1Z56dPYRsDjfsr1S/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEe1V2fs9WlDQHDlhmhzQcjBzEC9VcyerR/BZ8UH1PVhVoka+O+ITQKg/XYNESaN6KdPbovH+kmBvbZQj8DQBywY1EJ8V4ajT1HR3vX9x7F7QQDLQxhFsSQKTvl3UUNPYPIoK3YPSHy3bRz39AB2JZSxlHDmkX8JAQKu/QExjGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSh9LvxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSh9LvxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8741C2BCB8;
	Mon,  4 May 2026 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902930;
	bh=UiHYuIaEeusbiJZKW+QqG6XIm1Z56dPYRsDjfsr1S/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSh9LvxNbRutcJwoxHFUXV1F6XXzwseFxucNBs5uNhpOWOkWlEWvJ++J5Yn/+hyPM
	 C0oEvpB53U7tWaEZSrs97yE5Sn3+UA/tCJS/wpw/749RYgJsZf2rTAgTYfJykWBGIG
	 QBQfQrolvpXT2DG7wIVVabwAC4w0vWSqx2EEqQaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 7.0 038/307] vfio/cdx: Serialize VFIO_DEVICE_SET_IRQS with a per-device mutex
Date: Mon,  4 May 2026 15:48:43 +0200
Message-ID: <20260504135144.254201403@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@nvidia.com>

commit 670e8864b1a218d72f08db40d0103adf38fa1d9b upstream.

vfio_cdx_set_msi_trigger() reads vdev->config_msi and operates on the
vdev->cdx_irqs array based on its value, but provides no serialization
against concurrent VFIO_DEVICE_SET_IRQS ioctls.  Two callers can race
such that one observes config_msi as set while another clears it and
frees cdx_irqs via vfio_cdx_msi_disable(), resulting in a use-after-free
of the cdx_irqs array.

Add a cdx_irqs_lock mutex to struct vfio_cdx_device and acquire it in
vfio_cdx_set_msi_trigger(), which is the single chokepoint through
which all updates to config_msi, cdx_irqs, and msi_count flow, covering
both the ioctl path and the close-device cleanup path.  This keeps the
test of config_msi atomic with the subsequent enable, disable, or
trigger operations.

Drop the pre-call !cdx_irqs test from vfio_cdx_irqs_cleanup() as part
of this change: the optimization it provided is redundant with the
!config_msi early-return inside vfio_cdx_msi_disable(), and leaving the
test in place would be an unsynchronized read of state the new lock is
meant to protect.

Fixes: 848e447e000c ("vfio/cdx: add interrupt support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Acked-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
Link: https://lore.kernel.org/r/20260417202800.88287-3-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/cdx/intr.c    |    9 ++-------
 drivers/vfio/cdx/main.c    |   19 +++++++++++++++++++
 drivers/vfio/cdx/private.h |    3 +++
 3 files changed, 24 insertions(+), 7 deletions(-)

--- a/drivers/vfio/cdx/intr.c
+++ b/drivers/vfio/cdx/intr.c
@@ -152,6 +152,8 @@ static int vfio_cdx_set_msi_trigger(stru
 	if (start + count > cdx_dev->num_msi)
 		return -EINVAL;
 
+	guard(mutex)(&vdev->cdx_irqs_lock);
+
 	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_cdx_msi_disable(vdev);
 		return 0;
@@ -206,12 +208,5 @@ int vfio_cdx_set_irqs_ioctl(struct vfio_
 /* Free All IRQs for the given device */
 void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
 {
-	/*
-	 * Device does not support any interrupt or the interrupts
-	 * were not configured
-	 */
-	if (!vdev->cdx_irqs)
-		return;
-
 	vfio_cdx_set_msi_trigger(vdev, 0, 0, 0, VFIO_IRQ_SET_DATA_NONE, NULL);
 }
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -8,6 +8,23 @@
 
 #include "private.h"
 
+static int vfio_cdx_init_dev(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+
+	mutex_init(&vdev->cdx_irqs_lock);
+	return 0;
+}
+
+static void vfio_cdx_release_dev(struct vfio_device *core_vdev)
+{
+	struct vfio_cdx_device *vdev =
+		container_of(core_vdev, struct vfio_cdx_device, vdev);
+
+	mutex_destroy(&vdev->cdx_irqs_lock);
+}
+
 static int vfio_cdx_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_cdx_device *vdev =
@@ -273,6 +290,8 @@ static int vfio_cdx_mmap(struct vfio_dev
 
 static const struct vfio_device_ops vfio_cdx_ops = {
 	.name		= "vfio-cdx",
+	.init		= vfio_cdx_init_dev,
+	.release	= vfio_cdx_release_dev,
 	.open_device	= vfio_cdx_open_device,
 	.close_device	= vfio_cdx_close_device,
 	.ioctl		= vfio_cdx_ioctl,
--- a/drivers/vfio/cdx/private.h
+++ b/drivers/vfio/cdx/private.h
@@ -6,6 +6,8 @@
 #ifndef VFIO_CDX_PRIVATE_H
 #define VFIO_CDX_PRIVATE_H
 
+#include <linux/mutex.h>
+
 #define VFIO_CDX_OFFSET_SHIFT    40
 
 static inline u64 vfio_cdx_index_to_offset(u32 index)
@@ -31,6 +33,7 @@ struct vfio_cdx_region {
 struct vfio_cdx_device {
 	struct vfio_device	vdev;
 	struct vfio_cdx_region	*regions;
+	struct mutex		cdx_irqs_lock;
 	struct vfio_cdx_irq	*cdx_irqs;
 	u32			flags;
 #define BME_SUPPORT BIT(0)


