Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1C7145FF0;
	Thu, 11 Apr 2024 10:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830865; cv=none; b=e6z/ge+bfF4vAC5jEpgRftORetaaypZ/UCL8ruPmX+EyJL7lU4rZa0xRRikMmZaqnZF6+M33a25v+7V0rhv81Ow26/IswVsp9JgcRh9F1Eeqb0fS5ITHlesFivdr4dUdrR/CyWUv1MSYqSqY03ucNg9F1dJ+iTGJgmANuXYL0Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830865; c=relaxed/simple;
	bh=kdR7EkKiMt7UDzpmyXvJEoVLKcmQPny1xGlYwcBeflA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpFO6Ud7ijRz5fnrKCGor/SiyRxrV+QkmeM6VIyOrmBn8GjiZECQeJRiEYQQECAJcdGpc1h/Xi8ECWe5hL327pBE6RSs8uyOtWRFI1qXw7t3hE+GXNXlEph6eJlTEEBPbH6hH1cTPwGDGE1MduRTUQbZ0if41qAu8JE4YkDxlK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00pzSJ99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00pzSJ99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42F8C43399;
	Thu, 11 Apr 2024 10:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830865;
	bh=kdR7EkKiMt7UDzpmyXvJEoVLKcmQPny1xGlYwcBeflA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00pzSJ99MODSVEGHBVMDXtoQXxnrBNhaHM5zY+zhI7OVyDcjCWPdBKdSnPTa0IIKe
	 6U8/eCGbKfs6x9YUUzefDNNr0VaXxjT1WYibUrf17X7QKXrZlkFsd/KMe1DGnyseI+
	 /WK6zA03yCHNuxY/g4TACr4mL1Z+lIPfvEYpJfO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 143/215] vfio/platform: Create persistent IRQ handlers
Date: Thu, 11 Apr 2024 11:55:52 +0200
Message-ID: <20240411095429.189592685@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 675daf435e9f8e5a5eab140a9864dfad6668b375 ]

The vfio-platform SET_IRQS ioctl currently allows loopback triggering of
an interrupt before a signaling eventfd has been configured by the user,
which thereby allows a NULL pointer dereference.

Rather than register the IRQ relative to a valid trigger, register all
IRQs in a disabled state in the device open path.  This allows mask
operations on the IRQ to nest within the overall enable state governed
by a valid eventfd signal.  This decouples @masked, protected by the
@locked spinlock from @trigger, protected via the @igate mutex.

In doing so, it's guaranteed that changes to @trigger cannot race the
IRQ handlers because the IRQ handler is synchronously disabled before
modifying the trigger, and loopback triggering of the IRQ via ioctl is
safe due to serialization with trigger changes via igate.

For compatibility, request_irq() failures are maintained to be local to
the SET_IRQS ioctl rather than a fatal error in the open device path.
This allows, for example, a userspace driver with polling mode support
to continue to work regardless of moving the request_irq() call site.
This necessarily blocks all SET_IRQS access to the failed index.

Cc: Eric Auger <eric.auger@redhat.com>
Cc:  <stable@vger.kernel.org>
Fixes: 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-7-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_irq.c |  101 ++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 33 deletions(-)

--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -136,6 +136,16 @@ static int vfio_platform_set_irq_unmask(
 	return 0;
 }
 
+/*
+ * The trigger eventfd is guaranteed valid in the interrupt path
+ * and protected by the igate mutex when triggered via ioctl.
+ */
+static void vfio_send_eventfd(struct vfio_platform_irq *irq_ctx)
+{
+	if (likely(irq_ctx->trigger))
+		eventfd_signal(irq_ctx->trigger, 1);
+}
+
 static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 {
 	struct vfio_platform_irq *irq_ctx = dev_id;
@@ -155,7 +165,7 @@ static irqreturn_t vfio_automasked_irq_h
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
 
 	if (ret == IRQ_HANDLED)
-		eventfd_signal(irq_ctx->trigger, 1);
+		vfio_send_eventfd(irq_ctx);
 
 	return ret;
 }
@@ -164,22 +174,19 @@ static irqreturn_t vfio_irq_handler(int
 {
 	struct vfio_platform_irq *irq_ctx = dev_id;
 
-	eventfd_signal(irq_ctx->trigger, 1);
+	vfio_send_eventfd(irq_ctx);
 
 	return IRQ_HANDLED;
 }
 
 static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
-			    int fd, irq_handler_t handler)
+			    int fd)
 {
 	struct vfio_platform_irq *irq = &vdev->irqs[index];
 	struct eventfd_ctx *trigger;
-	int ret;
 
 	if (irq->trigger) {
-		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
-		free_irq(irq->hwirq, irq);
-		kfree(irq->name);
+		disable_irq(irq->hwirq);
 		eventfd_ctx_put(irq->trigger);
 		irq->trigger = NULL;
 	}
@@ -187,30 +194,20 @@ static int vfio_set_trigger(struct vfio_
 	if (fd < 0) /* Disable only */
 		return 0;
 
-	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
-						irq->hwirq, vdev->name);
-	if (!irq->name)
-		return -ENOMEM;
-
 	trigger = eventfd_ctx_fdget(fd);
-	if (IS_ERR(trigger)) {
-		kfree(irq->name);
+	if (IS_ERR(trigger))
 		return PTR_ERR(trigger);
-	}
 
 	irq->trigger = trigger;
 
-	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
-	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
-	if (ret) {
-		kfree(irq->name);
-		eventfd_ctx_put(trigger);
-		irq->trigger = NULL;
-		return ret;
-	}
-
-	if (!irq->masked)
-		enable_irq(irq->hwirq);
+	/*
+	 * irq->masked effectively provides nested disables within the overall
+	 * enable relative to trigger.  Specifically request_irq() is called
+	 * with NO_AUTOEN, therefore the IRQ is initially disabled.  The user
+	 * may only further disable the IRQ with a MASK operations because
+	 * irq->masked is initially false.
+	 */
+	enable_irq(irq->hwirq);
 
 	return 0;
 }
@@ -229,7 +226,7 @@ static int vfio_platform_set_irq_trigger
 		handler = vfio_irq_handler;
 
 	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
-		return vfio_set_trigger(vdev, index, -1, handler);
+		return vfio_set_trigger(vdev, index, -1);
 
 	if (start != 0 || count != 1)
 		return -EINVAL;
@@ -237,7 +234,7 @@ static int vfio_platform_set_irq_trigger
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t fd = *(int32_t *)data;
 
-		return vfio_set_trigger(vdev, index, fd, handler);
+		return vfio_set_trigger(vdev, index, fd);
 	}
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
@@ -261,6 +258,14 @@ int vfio_platform_set_irqs_ioctl(struct
 		    unsigned start, unsigned count, uint32_t flags,
 		    void *data) = NULL;
 
+	/*
+	 * For compatibility, errors from request_irq() are local to the
+	 * SET_IRQS path and reflected in the name pointer.  This allows,
+	 * for example, polling mode fallback for an exclusive IRQ failure.
+	 */
+	if (IS_ERR(vdev->irqs[index].name))
+		return PTR_ERR(vdev->irqs[index].name);
+
 	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 	case VFIO_IRQ_SET_ACTION_MASK:
 		func = vfio_platform_set_irq_mask;
@@ -281,7 +286,7 @@ int vfio_platform_set_irqs_ioctl(struct
 
 int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 {
-	int cnt = 0, i;
+	int cnt = 0, i, ret = 0;
 
 	while (vdev->get_irq(vdev, cnt) >= 0)
 		cnt++;
@@ -292,29 +297,54 @@ int vfio_platform_irq_init(struct vfio_p
 
 	for (i = 0; i < cnt; i++) {
 		int hwirq = vdev->get_irq(vdev, i);
+		irq_handler_t handler = vfio_irq_handler;
 
-		if (hwirq < 0)
+		if (hwirq < 0) {
+			ret = -EINVAL;
 			goto err;
+		}
 
 		spin_lock_init(&vdev->irqs[i].lock);
 
 		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
 
-		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
+		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK) {
 			vdev->irqs[i].flags |= VFIO_IRQ_INFO_MASKABLE
 						| VFIO_IRQ_INFO_AUTOMASKED;
+			handler = vfio_automasked_irq_handler;
+		}
 
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
 		vdev->irqs[i].masked = false;
+		vdev->irqs[i].name = kasprintf(GFP_KERNEL,
+					       "vfio-irq[%d](%s)", hwirq,
+					       vdev->name);
+		if (!vdev->irqs[i].name) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		ret = request_irq(hwirq, handler, IRQF_NO_AUTOEN,
+				  vdev->irqs[i].name, &vdev->irqs[i]);
+		if (ret) {
+			kfree(vdev->irqs[i].name);
+			vdev->irqs[i].name = ERR_PTR(ret);
+		}
 	}
 
 	vdev->num_irqs = cnt;
 
 	return 0;
 err:
+	for (--i; i >= 0; i--) {
+		if (!IS_ERR(vdev->irqs[i].name)) {
+			free_irq(vdev->irqs[i].hwirq, &vdev->irqs[i]);
+			kfree(vdev->irqs[i].name);
+		}
+	}
 	kfree(vdev->irqs);
-	return -EINVAL;
+	return ret;
 }
 
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
@@ -324,7 +354,12 @@ void vfio_platform_irq_cleanup(struct vf
 	for (i = 0; i < vdev->num_irqs; i++) {
 		vfio_virqfd_disable(&vdev->irqs[i].mask);
 		vfio_virqfd_disable(&vdev->irqs[i].unmask);
-		vfio_set_trigger(vdev, i, -1, NULL);
+		if (!IS_ERR(vdev->irqs[i].name)) {
+			free_irq(vdev->irqs[i].hwirq, &vdev->irqs[i]);
+			if (vdev->irqs[i].trigger)
+				eventfd_ctx_put(vdev->irqs[i].trigger);
+			kfree(vdev->irqs[i].name);
+		}
 	}
 
 	vdev->num_irqs = 0;


