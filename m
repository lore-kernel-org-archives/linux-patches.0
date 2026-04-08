Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39923D75C3;
	Wed,  8 Apr 2026 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674138; cv=none; b=sBxXWohdDZz99S+UV3lvZm40hQlHZ4sXe8I5H4UkKprAMUodKzALGAuR2pu0jJ2Cc+n1hkPdKuZ6UxaFwQ7BsOILN42dFlrY0zw5PXp0B2pkSs8ZJuYAOIstajU5NAazBxiIwh0w4Z0y6NCS1v2++q3sv6kEWFSyxNkgMLcLLLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674138; c=relaxed/simple;
	bh=syJBIgJOvkkm/q85URyJ6D6C5/mfKf5pvywCcoBcaMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsbO4zndbxCwUyrUJt/xfjI7dW1EAA4jEQtnNsywAqYDUbTJ82aBJ+0EKvhiuNsZmqhds3pFDe0ti7LLqtHPPZBTyXyLNIesG8xbcG5BrzB8oXsnuKcwi3PTpAmwHJOky3NUeo+v3g1Lz1UZw+Nwicp4CsoNvuTTSzPdE7kJ0wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5aFyhq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5aFyhq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E8EC2BC87;
	Wed,  8 Apr 2026 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674138;
	bh=syJBIgJOvkkm/q85URyJ6D6C5/mfKf5pvywCcoBcaMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5aFyhq94SgkN9aj1o0K77C5ylNYPW6NF40x9X1L16Gtb3ljjd1DREABtuSUkUFrs
	 hc3uproeYMZU7R7H1mhm06HnJ8g25raxzc5kgv9jFhvkz/zY//FlSSKnXfqz2pZm1i
	 g1uWLRpWB+HcYvkrhZp1Nlkq0iyWOpd1m5j9Q6Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.12 207/242] usb: gadget: f_eem: Fix net_device lifecycle with device_move
Date: Wed,  8 Apr 2026 20:04:07 +0200
Message-ID: <20260408175934.827311337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit d9270c9a8118c1535409db926ac1e2545dc97b81 upstream.

The net_device is allocated during function instance creation and
registered during the bind phase with the gadget device as its sysfs
parent. When the function unbinds, the parent device is destroyed, but
the net_device survives, resulting in dangling sysfs symlinks:

console:/ # ls -l /sys/class/net/usb0
lrwxrwxrwx ... /sys/class/net/usb0 ->
/sys/devices/platform/.../gadget.0/net/usb0
console:/ # ls -l /sys/devices/platform/.../gadget.0/net/usb0
ls: .../gadget.0/net/usb0: No such file or directory

Use device_move() to reparent the net_device between the gadget device
tree and /sys/devices/virtual across bind and unbind cycles. During the
final unbind, calling device_move(NULL) moves the net_device to the
virtual device tree before the gadget device is destroyed. On rebinding,
device_move() reparents the device back under the new gadget, ensuring
proper sysfs topology and power management ordering.

To maintain compatibility with legacy composite drivers (e.g., multi.c),
the bound flag is used to indicate whether the network device is shared
and pre-registered during the legacy driver's bind phase.

Fixes: b29002a15794 ("usb: gadget: f_eem: convert to new function interface with backward compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-5-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_eem.c |   59 ++++++++++++++++++------------------
 drivers/usb/gadget/function/u_eem.h |   21 +++++++++---
 2 files changed, 46 insertions(+), 34 deletions(-)

--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2009 EF Johnson Technologies
  */
 
+#include <linux/cleanup.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -251,24 +252,22 @@ static int eem_bind(struct usb_configura
 	struct usb_ep		*ep;
 
 	struct f_eem_opts	*eem_opts;
+	struct net_device	*net __free(detach_gadget) = NULL;
 
 	eem_opts = container_of(f->fi, struct f_eem_opts, func_inst);
-	/*
-	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
-	 * configurations are bound in sequence with list_for_each_entry,
-	 * in each configuration its functions are bound in sequence
-	 * with list_for_each_entry, so we assume no race condition
-	 * with regard to eem_opts->bound access
-	 */
-	if (!eem_opts->bound) {
-		mutex_lock(&eem_opts->lock);
-		gether_set_gadget(eem_opts->net, cdev->gadget);
-		status = gether_register_netdev(eem_opts->net);
-		mutex_unlock(&eem_opts->lock);
-		if (status)
-			return status;
-		eem_opts->bound = true;
-	}
+
+	scoped_guard(mutex, &eem_opts->lock)
+		if (eem_opts->bind_count == 0 && !eem_opts->bound) {
+			if (!device_is_registered(&eem_opts->net->dev)) {
+				gether_set_gadget(eem_opts->net, cdev->gadget);
+				status = gether_register_netdev(eem_opts->net);
+			} else
+				status = gether_attach_gadget(eem_opts->net, cdev->gadget);
+
+			if (status)
+				return status;
+			net = eem_opts->net;
+		}
 
 	us = usb_gstrings_attach(cdev, eem_strings,
 				 ARRAY_SIZE(eem_string_defs));
@@ -279,21 +278,19 @@ static int eem_bind(struct usb_configura
 	/* allocate instance-specific interface IDs */
 	status = usb_interface_id(c, f);
 	if (status < 0)
-		goto fail;
+		return status;
 	eem->ctrl_id = status;
 	eem_intf.bInterfaceNumber = status;
 
-	status = -ENODEV;
-
 	/* allocate instance-specific endpoints */
 	ep = usb_ep_autoconfig(cdev->gadget, &eem_fs_in_desc);
 	if (!ep)
-		goto fail;
+		return -ENODEV;
 	eem->port.in_ep = ep;
 
 	ep = usb_ep_autoconfig(cdev->gadget, &eem_fs_out_desc);
 	if (!ep)
-		goto fail;
+		return -ENODEV;
 	eem->port.out_ep = ep;
 
 	/* support all relevant hardware speeds... we expect that when
@@ -309,16 +306,14 @@ static int eem_bind(struct usb_configura
 	status = usb_assign_descriptors(f, eem_fs_function, eem_hs_function,
 			eem_ss_function, eem_ss_function);
 	if (status)
-		goto fail;
+		return status;
+
+	eem_opts->bind_count++;
+	retain_and_null_ptr(net);
 
 	DBG(cdev, "CDC Ethernet (EEM): IN/%s OUT/%s\n",
 			eem->port.in_ep->name, eem->port.out_ep->name);
 	return 0;
-
-fail:
-	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
-
-	return status;
 }
 
 static void eem_cmd_complete(struct usb_ep *ep, struct usb_request *req)
@@ -597,7 +592,7 @@ static void eem_free_inst(struct usb_fun
 	struct f_eem_opts *opts;
 
 	opts = container_of(f, struct f_eem_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
@@ -640,9 +635,17 @@ static void eem_free(struct usb_function
 
 static void eem_unbind(struct usb_configuration *c, struct usb_function *f)
 {
+	struct f_eem_opts *opts;
+
 	DBG(c->cdev, "eem unbind\n");
 
+	opts = container_of(f->fi, struct f_eem_opts, func_inst);
+
 	usb_free_all_descriptors(f);
+
+	opts->bind_count--;
+	if (opts->bind_count == 0 && !opts->bound)
+		gether_detach_gadget(opts->net);
 }
 
 static struct usb_function *eem_alloc(struct usb_function_instance *fi)
--- a/drivers/usb/gadget/function/u_eem.h
+++ b/drivers/usb/gadget/function/u_eem.h
@@ -15,17 +15,26 @@
 
 #include <linux/usb/composite.h>
 
+/**
+ * struct f_eem_opts - EEM function options
+ * @func_inst: USB function instance.
+ * @net: The net_device associated with the EEM function.
+ * @bound: True if the net_device is shared and pre-registered during the
+ *         legacy composite driver's bind phase (e.g., multi.c). If false,
+ *         the EEM function will register the net_device during its own
+ *         bind phase.
+ * @bind_count: Tracks the number of configurations the EEM function is
+ *              bound to, preventing double-registration of the @net device.
+ * @lock: Protects the data from concurrent access by configfs read/write
+ *        and create symlink/remove symlink operations.
+ * @refcnt: Reference counter for the function instance.
+ */
 struct f_eem_opts {
 	struct usb_function_instance	func_inst;
 	struct net_device		*net;
 	bool				bound;
+	int				bind_count;
 
-	/*
-	 * Read/write access to configfs attributes is handled by configfs.
-	 *
-	 * This is to protect the data from concurrent access by read/write
-	 * and create symlink/remove symlink.
-	 */
 	struct mutex			lock;
 	int				refcnt;
 };


