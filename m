Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8014D3D9043;
	Wed,  8 Apr 2026 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673374; cv=none; b=rJFBF7ah8koKVNHTqPjYBiO7N+WMJ5tpMqAQBJcna9fmA1Fi6MgaLI3zFcbXlHRsONaqEZpokeYLUnby89yAsnesqx1skLi/RJezyek8Zdw0jvt/96w/+GD7wF4wF2zuVb8xEZLVntZ3HE/5HspfSDHAk1xBi5YWziPlPgsQPzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673374; c=relaxed/simple;
	bh=5V0RO5Av50yzbFC0OqadP0A3ncfqwj9qr/jVo6y8PW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+e+6m7lYOyzdXxXSD9EJES1PcVwRqzzIqCTfuRrNh8W2OjHV3pGe9pSWlWv+nIgZk/Pi1poyW6Y/kLxxU7QaodEZKPZJpkpfXOSzMB8ExqlJ83WU65pQNGwb3TbbNErwimax3qRVhULgifQe/DoD3PCNt8pPGGlkP27PUgJPqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFhUoOb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFhUoOb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E02C19421;
	Wed,  8 Apr 2026 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673374;
	bh=5V0RO5Av50yzbFC0OqadP0A3ncfqwj9qr/jVo6y8PW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFhUoOb/ElSpUZspnTwooxYj2NrEuq0viLusjpPI13PyE7zW4SP5wxR0hWwDzkxXU
	 M70H2ekqn5EGRyOR0usxvUMht934K7BoQd0LfoBF1OtEoOuo7TlcMRuw19pEo6mszH
	 b8JrDEk+jac9loRp8avNIJAqAdLuG/Xz1jDnevRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guan-Yu Lin <guanyulin@google.com>,
	Hailong Liu <hailong.liu@oppo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.18 207/277] usb: core: use dedicated spinlock for offload state
Date: Wed,  8 Apr 2026 20:03:12 +0200
Message-ID: <20260408175941.592197930@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guan-Yu Lin <guanyulin@google.com>

commit bd3d245b0fef571f93504904df62b8865b1c0d34 upstream.

Replace the coarse USB device lock with a dedicated offload_lock
spinlock to reduce contention during offload operations. Use
offload_pm_locked to synchronize with PM transitions and replace
the legacy offload_at_suspend flag.

Optimize usb_offload_get/put by switching from auto-resume/suspend
to pm_runtime_get_if_active(). This ensures offload state is only
modified when the device is already active, avoiding unnecessary
power transitions.

Cc: stable <stable@kernel.org>
Fixes: ef82a4803aab ("xhci: sideband: add api to trace sideband usage")
Signed-off-by: Guan-Yu Lin <guanyulin@google.com>
Tested-by: Hailong Liu <hailong.liu@oppo.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260401123238.3790062-2-guanyulin@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/driver.c        |   23 +++++---
 drivers/usb/core/offload.c       |  102 ++++++++++++++++++++++-----------------
 drivers/usb/core/usb.c           |    1 
 drivers/usb/host/xhci-sideband.c |    4 -
 include/linux/usb.h              |   10 +++
 5 files changed, 84 insertions(+), 56 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1415,14 +1415,16 @@ static int usb_suspend_both(struct usb_d
 	int			status = 0;
 	int			i = 0, n = 0;
 	struct usb_interface	*intf;
+	bool			offload_active = false;
 
 	if (udev->state == USB_STATE_NOTATTACHED ||
 			udev->state == USB_STATE_SUSPENDED)
 		goto done;
 
+	usb_offload_set_pm_locked(udev, true);
 	if (msg.event == PM_EVENT_SUSPEND && usb_offload_check(udev)) {
 		dev_dbg(&udev->dev, "device offloaded, skip suspend.\n");
-		udev->offload_at_suspend = 1;
+		offload_active = true;
 	}
 
 	/* Suspend all the interfaces and then udev itself */
@@ -1436,8 +1438,7 @@ static int usb_suspend_both(struct usb_d
 			 * interrupt urbs, allowing interrupt events to be
 			 * handled during system suspend.
 			 */
-			if (udev->offload_at_suspend &&
-			    intf->needs_remote_wakeup) {
+			if (offload_active && intf->needs_remote_wakeup) {
 				dev_dbg(&intf->dev,
 					"device offloaded, skip suspend.\n");
 				continue;
@@ -1452,7 +1453,7 @@ static int usb_suspend_both(struct usb_d
 		}
 	}
 	if (status == 0) {
-		if (!udev->offload_at_suspend)
+		if (!offload_active)
 			status = usb_suspend_device(udev, msg);
 
 		/*
@@ -1498,7 +1499,7 @@ static int usb_suspend_both(struct usb_d
 	 */
 	} else {
 		udev->can_submit = 0;
-		if (!udev->offload_at_suspend) {
+		if (!offload_active) {
 			for (i = 0; i < 16; ++i) {
 				usb_hcd_flush_endpoint(udev, udev->ep_out[i]);
 				usb_hcd_flush_endpoint(udev, udev->ep_in[i]);
@@ -1507,6 +1508,8 @@ static int usb_suspend_both(struct usb_d
 	}
 
  done:
+	if (status != 0)
+		usb_offload_set_pm_locked(udev, false);
 	dev_vdbg(&udev->dev, "%s: status %d\n", __func__, status);
 	return status;
 }
@@ -1536,16 +1539,19 @@ static int usb_resume_both(struct usb_de
 	int			status = 0;
 	int			i;
 	struct usb_interface	*intf;
+	bool			offload_active = false;
 
 	if (udev->state == USB_STATE_NOTATTACHED) {
 		status = -ENODEV;
 		goto done;
 	}
 	udev->can_submit = 1;
+	if (msg.event == PM_EVENT_RESUME)
+		offload_active = usb_offload_check(udev);
 
 	/* Resume the device */
 	if (udev->state == USB_STATE_SUSPENDED || udev->reset_resume) {
-		if (!udev->offload_at_suspend)
+		if (!offload_active)
 			status = usb_resume_device(udev, msg);
 		else
 			dev_dbg(&udev->dev,
@@ -1562,8 +1568,7 @@ static int usb_resume_both(struct usb_de
 			 * pending interrupt urbs, allowing interrupt events
 			 * to be handled during system suspend.
 			 */
-			if (udev->offload_at_suspend &&
-			    intf->needs_remote_wakeup) {
+			if (offload_active && intf->needs_remote_wakeup) {
 				dev_dbg(&intf->dev,
 					"device offloaded, skip resume.\n");
 				continue;
@@ -1572,11 +1577,11 @@ static int usb_resume_both(struct usb_de
 					udev->reset_resume);
 		}
 	}
-	udev->offload_at_suspend = 0;
 	usb_mark_last_busy(udev);
 
  done:
 	dev_vdbg(&udev->dev, "%s: status %d\n", __func__, status);
+	usb_offload_set_pm_locked(udev, false);
 	if (!status)
 		udev->reset_resume = 0;
 	return status;
--- a/drivers/usb/core/offload.c
+++ b/drivers/usb/core/offload.c
@@ -25,33 +25,30 @@
  */
 int usb_offload_get(struct usb_device *udev)
 {
-	int ret;
+	int ret = 0;
 
-	usb_lock_device(udev);
-	if (udev->state == USB_STATE_NOTATTACHED) {
-		usb_unlock_device(udev);
+	if (!usb_get_dev(udev))
 		return -ENODEV;
-	}
 
-	if (udev->state == USB_STATE_SUSPENDED ||
-		   udev->offload_at_suspend) {
-		usb_unlock_device(udev);
-		return -EBUSY;
+	if (pm_runtime_get_if_active(&udev->dev) != 1) {
+		ret = -EBUSY;
+		goto err_rpm;
 	}
 
-	/*
-	 * offload_usage could only be modified when the device is active, since
-	 * it will alter the suspend flow of the device.
-	 */
-	ret = usb_autoresume_device(udev);
-	if (ret < 0) {
-		usb_unlock_device(udev);
-		return ret;
+	spin_lock(&udev->offload_lock);
+
+	if (udev->offload_pm_locked) {
+		ret = -EAGAIN;
+		goto err;
 	}
 
 	udev->offload_usage++;
-	usb_autosuspend_device(udev);
-	usb_unlock_device(udev);
+
+err:
+	spin_unlock(&udev->offload_lock);
+	pm_runtime_put_autosuspend(&udev->dev);
+err_rpm:
+	usb_put_dev(udev);
 
 	return ret;
 }
@@ -69,35 +66,32 @@ EXPORT_SYMBOL_GPL(usb_offload_get);
  */
 int usb_offload_put(struct usb_device *udev)
 {
-	int ret;
+	int ret = 0;
 
-	usb_lock_device(udev);
-	if (udev->state == USB_STATE_NOTATTACHED) {
-		usb_unlock_device(udev);
+	if (!usb_get_dev(udev))
 		return -ENODEV;
-	}
 
-	if (udev->state == USB_STATE_SUSPENDED ||
-		   udev->offload_at_suspend) {
-		usb_unlock_device(udev);
-		return -EBUSY;
+	if (pm_runtime_get_if_active(&udev->dev) != 1) {
+		ret = -EBUSY;
+		goto err_rpm;
 	}
 
-	/*
-	 * offload_usage could only be modified when the device is active, since
-	 * it will alter the suspend flow of the device.
-	 */
-	ret = usb_autoresume_device(udev);
-	if (ret < 0) {
-		usb_unlock_device(udev);
-		return ret;
+	spin_lock(&udev->offload_lock);
+
+	if (udev->offload_pm_locked) {
+		ret = -EAGAIN;
+		goto err;
 	}
 
 	/* Drop the count when it wasn't 0, ignore the operation otherwise. */
 	if (udev->offload_usage)
 		udev->offload_usage--;
-	usb_autosuspend_device(udev);
-	usb_unlock_device(udev);
+
+err:
+	spin_unlock(&udev->offload_lock);
+	pm_runtime_put_autosuspend(&udev->dev);
+err_rpm:
+	usb_put_dev(udev);
 
 	return ret;
 }
@@ -112,25 +106,47 @@ EXPORT_SYMBOL_GPL(usb_offload_put);
  * management.
  *
  * The caller must hold @udev's device lock. In addition, the caller should
- * ensure downstream usb devices are all either suspended or marked as
- * "offload_at_suspend" to ensure the correctness of the return value.
+ * ensure the device itself and the downstream usb devices are all marked as
+ * "offload_pm_locked" to ensure the correctness of the return value.
  *
  * Returns true on any offload activity, false otherwise.
  */
 bool usb_offload_check(struct usb_device *udev) __must_hold(&udev->dev->mutex)
 {
 	struct usb_device *child;
-	bool active;
+	bool active = false;
 	int port1;
 
+	if (udev->offload_usage)
+		return true;
+
 	usb_hub_for_each_child(udev, port1, child) {
 		usb_lock_device(child);
 		active = usb_offload_check(child);
 		usb_unlock_device(child);
+
 		if (active)
-			return true;
+			break;
 	}
 
-	return !!udev->offload_usage;
+	return active;
 }
 EXPORT_SYMBOL_GPL(usb_offload_check);
+
+/**
+ * usb_offload_set_pm_locked - set the PM lock state of a USB device
+ * @udev: the USB device to modify
+ * @locked: the new lock state
+ *
+ * Setting @locked to true prevents offload_usage from being modified. This
+ * ensures that offload activities cannot be started or stopped during critical
+ * power management transitions, maintaining a stable state for the duration
+ * of the transition.
+ */
+void usb_offload_set_pm_locked(struct usb_device *udev, bool locked)
+{
+	spin_lock(&udev->offload_lock);
+	udev->offload_pm_locked = locked;
+	spin_unlock(&udev->offload_lock);
+}
+EXPORT_SYMBOL_GPL(usb_offload_set_pm_locked);
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -670,6 +670,7 @@ struct usb_device *usb_alloc_dev(struct
 	set_dev_node(&dev->dev, dev_to_node(bus->sysdev));
 	dev->state = USB_STATE_ATTACHED;
 	dev->lpm_disable_count = 1;
+	spin_lock_init(&dev->offload_lock);
 	dev->offload_usage = 0;
 	atomic_set(&dev->urbnum, 0);
 
--- a/drivers/usb/host/xhci-sideband.c
+++ b/drivers/usb/host/xhci-sideband.c
@@ -285,8 +285,8 @@ EXPORT_SYMBOL_GPL(xhci_sideband_get_even
  * Allow other drivers, such as usb controller driver, to check if there are
  * any sideband activity on the host controller. This information could be used
  * for power management or other forms of resource management. The caller should
- * ensure downstream usb devices are all either suspended or marked as
- * "offload_at_suspend" to ensure the correctness of the return value.
+ * ensure downstream usb devices are all marked as "offload_pm_locked" to ensure
+ * the correctness of the return value.
  *
  * Returns true on any active sideband existence, false otherwise.
  */
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -21,6 +21,7 @@
 #include <linux/completion.h>	/* for struct completion */
 #include <linux/sched.h>	/* for current && schedule_timeout */
 #include <linux/mutex.h>	/* for struct mutex */
+#include <linux/spinlock.h>	/* for spinlock_t */
 #include <linux/pm_runtime.h>	/* for runtime PM */
 
 struct usb_device;
@@ -636,8 +637,9 @@ struct usb3_lpm_parameters {
  * @do_remote_wakeup:  remote wakeup should be enabled
  * @reset_resume: needs reset instead of resume
  * @port_is_suspended: the upstream port is suspended (L2 or U3)
- * @offload_at_suspend: offload activities during suspend is enabled.
+ * @offload_pm_locked: prevents offload_usage changes during PM transitions.
  * @offload_usage: number of offload activities happening on this usb device.
+ * @offload_lock: protects offload_usage and offload_pm_locked
  * @slot_id: Slot ID assigned by xHCI
  * @l1_params: best effor service latency for USB2 L1 LPM state, and L1 timeout.
  * @u1_params: exit latencies for USB3 U1 LPM state, and hub-initiated timeout.
@@ -726,8 +728,9 @@ struct usb_device {
 	unsigned do_remote_wakeup:1;
 	unsigned reset_resume:1;
 	unsigned port_is_suspended:1;
-	unsigned offload_at_suspend:1;
+	unsigned offload_pm_locked:1;
 	int offload_usage;
+	spinlock_t offload_lock;
 	enum usb_link_tunnel_mode tunnel_mode;
 	struct device_link *usb4_link;
 
@@ -849,6 +852,7 @@ static inline void usb_mark_last_busy(st
 int usb_offload_get(struct usb_device *udev);
 int usb_offload_put(struct usb_device *udev);
 bool usb_offload_check(struct usb_device *udev);
+void usb_offload_set_pm_locked(struct usb_device *udev, bool locked);
 #else
 
 static inline int usb_offload_get(struct usb_device *udev)
@@ -857,6 +861,8 @@ static inline int usb_offload_put(struct
 { return 0; }
 static inline bool usb_offload_check(struct usb_device *udev)
 { return false; }
+static inline void usb_offload_set_pm_locked(struct usb_device *udev, bool locked)
+{ }
 #endif
 
 extern int usb_disable_lpm(struct usb_device *udev);


