Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214743;
	b=18EZ1dSM+Ra/n30O4C90VeehoixSBTlmrrN4f8mVTuDmiTDgubgfSBiYRtxARGU8LlNA
	 RUzXJUA1p/WRJJR14q1mPzuQJ+DhKf/Mj9qpS+/vD39d5vUba242IfAYxaAAmo3KxCojZ
	 Jon5pT0H6TY1YCacTWu5enWFQ028ZkEmejrIGYB4bw7FWEFxIdGC7vk6nzBRmzr8XkMVl
	 yhSz6jpNj2n85EhffQPjGQUi51Yfaic1U7SC0tQZ34YaYo5FwskHzdj0TeyZdWPaD9nyL
	 yjd7PDJ7g3TN1Z1soaawy9g92LJ6g6wv8spXAE6PeHZcXRzSadHracZDqd75RV6W2lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vUGquj54HQAvhX4ZuEy1Vomx8F7U3Zm8jukraEtnIVk=;
	b=JSByuy1Fm3p0+CujbmaTDjIe9IcRXu5k85ZCk6nugmA09JO7SbqiKOE8TMQvfB7eulUR
	 gqTz8WCifoclqYbhnkNOtPBGWN0f925gi2nOVSE0IeCy68IHrpD6ZKt1tt4bIXye9eKgZ
	 IltzQQgtt55jmiSkRjTeoYT+vOePJQ0DnvdpFcP6sEpiVVF/BCjt+HTDsZfirmsu4mBOL
	 hziEY9LdJLy8GUihLrz0949tUaQ+vY6HAyPpbvB9nFYOknAFrnWLpEdhcDHsdbAzgTEVj
	 a316YpFMKhTGce5Fe9eSTBoaUG0lOs77ArowyPLZGvnyuMZG5iT9JHVhQiIgpBveCIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUXA5hPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E4360A261B;
	Wed, 28 Oct 2026 19:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUXA5hPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332561F01825;
	Wed, 28 Oct 2026 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214742;
	bh=vUGquj54HQAvhX4ZuEy1Vomx8F7U3Zm8jukraEtnIVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUXA5hPWdE3MTJ0M/ou9KxCUO5F1WoxSNc2KYDztd0uUOGgtRtJcVWlbqy+thUY+6
	 xmR8wmwMKYp0wA+Yr5Ur2/KYRjVqolVS3yUCVw4Wvu1OIOCwik2N+SqkqEv50jxSgd
	 wwCA0P8DY3U8Pm00vpSKshi5Ym9BLn12r9nHApMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0966/1887] usb: gadget: f_eem: Fix net_device lifecycle with device_move
Date: Wed, 28 Oct 2026 17:51:02 +0100
Message-ID: <20261028170521.389834955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit d9270c9a8118c1535409db926ac1e2545dc97b81 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_eem.c | 59 +++++++++++++++--------------
 drivers/usb/gadget/function/u_eem.h | 21 +++++++---
 2 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/gadget/function/f_eem.c b/drivers/usb/gadget/function/f_eem.c
index a308163fc8bcc..803fe047c512c 100644
--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2009 EF Johnson Technologies
  */
 
+#include <linux/cleanup.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -251,24 +252,22 @@ static int eem_bind(struct usb_configuration *c, struct usb_function *f)
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
@@ -279,21 +278,19 @@ static int eem_bind(struct usb_configuration *c, struct usb_function *f)
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
@@ -309,18 +306,16 @@ static int eem_bind(struct usb_configuration *c, struct usb_function *f)
 	status = usb_assign_descriptors(f, eem_fs_function, eem_hs_function,
 			eem_ss_function, eem_ss_function);
 	if (status)
-		goto fail;
+		return status;
+
+	eem_opts->bind_count++;
+	no_free_ptr(net);
 
 	DBG(cdev, "CDC Ethernet (EEM): %s speed IN/%s OUT/%s\n",
 			gadget_is_superspeed(c->cdev->gadget) ? "super" :
 			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
 			eem->port.in_ep->name, eem->port.out_ep->name);
 	return 0;
-
-fail:
-	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
-
-	return status;
 }
 
 static void eem_cmd_complete(struct usb_ep *ep, struct usb_request *req)
@@ -599,7 +594,7 @@ static void eem_free_inst(struct usb_function_instance *f)
 	struct f_eem_opts *opts;
 
 	opts = container_of(f, struct f_eem_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
@@ -642,9 +637,17 @@ static void eem_free(struct usb_function *f)
 
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
diff --git a/drivers/usb/gadget/function/u_eem.h b/drivers/usb/gadget/function/u_eem.h
index 3bd85dfcd71c8..78ef558152197 100644
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
-- 
2.53.0



