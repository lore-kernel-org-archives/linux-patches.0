Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A67358363;
	Wed,  8 Apr 2026 19:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674964; cv=none; b=MBx2XuJkKrVxf93kfuLgKsSaL5qyL3V3TiCLJYeBaHUXCms0lpEN244wdA/gxoYWtrRr6oMweB2k6X6xpF7KsESkJJXnO6s2pS11pxNQB+yIRzONln/ienVzAP5aOaBtWS5LdTL1GoGf3Lwb5ocz8YooqxPRR3vZ4LhQpTKWzng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674964; c=relaxed/simple;
	bh=Q23xmrC15Lxn63RuB9OsYd2qvh1ePp/2T+4/Nz645uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uddr8OmjeWvhT3UHlOLPDwK48sWxCUTd2F7NpOjL0WzbLUHriBfxOddRqGm+0PQIFdbIBh8by3xSQpdfxvuzld0UxbzlM8pdS2vJu3xOWxNHDoXsDanbiSPUiJipJySBpoV4q3ztPxk9+MrydpoPlf0n65OImxQKC6Z8v8Ii3Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsHoK6yC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsHoK6yC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B881CC19421;
	Wed,  8 Apr 2026 19:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674964;
	bh=Q23xmrC15Lxn63RuB9OsYd2qvh1ePp/2T+4/Nz645uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsHoK6yCdNt3gUex/OwJC1Z9m4mIzhEDMiZtAek78aMM/u7isDCnFekrp5Lt7TblA
	 jbmsYfCc6GTnwvh4Geumi5m9o009keLDh8paX6L3wN+g7xYtdhlfbavjrttCeSULOt
	 PqFQEOUTO/yhwALd+t8Tnb2i0jOxDoM2WGwK62NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 301/311] usb: gadget: f_ecm: Fix net_device lifecycle with device_move
Date: Wed,  8 Apr 2026 20:05:01 +0200
Message-ID: <20260408175950.609461339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit b2cc4fae67a51f60d81d6af2678696accb07c656 upstream.

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

Fixes: fee562a6450b ("usb: gadget: f_ecm: convert to new function interface with backward compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-4-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ecm.c |   37 +++++++++++++++++++++++-------------
 drivers/usb/gadget/function/u_ecm.h |   21 ++++++++++++++------
 2 files changed, 39 insertions(+), 19 deletions(-)

--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -681,6 +681,7 @@ ecm_bind(struct usb_configuration *c, st
 	struct usb_ep		*ep;
 
 	struct f_ecm_opts	*ecm_opts;
+	struct net_device	*net __free(detach_gadget) = NULL;
 	struct usb_request	*request __free(free_usb_request) = NULL;
 
 	if (!can_support_ecm(cdev->gadget))
@@ -688,18 +689,18 @@ ecm_bind(struct usb_configuration *c, st
 
 	ecm_opts = container_of(f->fi, struct f_ecm_opts, func_inst);
 
-	mutex_lock(&ecm_opts->lock);
-
-	gether_set_gadget(ecm_opts->net, cdev->gadget);
-
-	if (!ecm_opts->bound) {
-		status = gether_register_netdev(ecm_opts->net);
-		ecm_opts->bound = true;
-	}
-
-	mutex_unlock(&ecm_opts->lock);
-	if (status)
-		return status;
+	scoped_guard(mutex, &ecm_opts->lock)
+		if (ecm_opts->bind_count == 0 && !ecm_opts->bound) {
+			if (!device_is_registered(&ecm_opts->net->dev)) {
+				gether_set_gadget(ecm_opts->net, cdev->gadget);
+				status = gether_register_netdev(ecm_opts->net);
+			} else
+				status = gether_attach_gadget(ecm_opts->net, cdev->gadget);
+
+			if (status)
+				return status;
+			net = ecm_opts->net;
+		}
 
 	ecm_string_defs[1].s = ecm->ethaddr;
 
@@ -790,6 +791,9 @@ ecm_bind(struct usb_configuration *c, st
 
 	ecm->notify_req = no_free_ptr(request);
 
+	ecm_opts->bind_count++;
+	retain_and_null_ptr(net);
+
 	DBG(cdev, "CDC Ethernet: IN/%s OUT/%s NOTIFY/%s\n",
 			ecm->port.in_ep->name, ecm->port.out_ep->name,
 			ecm->notify->name);
@@ -836,7 +840,7 @@ static void ecm_free_inst(struct usb_fun
 	struct f_ecm_opts *opts;
 
 	opts = container_of(f, struct f_ecm_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
@@ -906,9 +910,12 @@ static void ecm_free(struct usb_function
 static void ecm_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_ecm		*ecm = func_to_ecm(f);
+	struct f_ecm_opts	*ecm_opts;
 
 	DBG(c->cdev, "ecm unbind\n");
 
+	ecm_opts = container_of(f->fi, struct f_ecm_opts, func_inst);
+
 	usb_free_all_descriptors(f);
 
 	if (atomic_read(&ecm->notify_count)) {
@@ -918,6 +925,10 @@ static void ecm_unbind(struct usb_config
 
 	kfree(ecm->notify_req->buf);
 	usb_ep_free_request(ecm->notify, ecm->notify_req);
+
+	ecm_opts->bind_count--;
+	if (ecm_opts->bind_count == 0 && !ecm_opts->bound)
+		gether_detach_gadget(ecm_opts->net);
 }
 
 static struct usb_function *ecm_alloc(struct usb_function_instance *fi)
--- a/drivers/usb/gadget/function/u_ecm.h
+++ b/drivers/usb/gadget/function/u_ecm.h
@@ -15,17 +15,26 @@
 
 #include <linux/usb/composite.h>
 
+/**
+ * struct f_ecm_opts - ECM function options
+ * @func_inst: USB function instance.
+ * @net: The net_device associated with the ECM function.
+ * @bound: True if the net_device is shared and pre-registered during the
+ *         legacy composite driver's bind phase (e.g., multi.c). If false,
+ *         the ECM function will register the net_device during its own
+ *         bind phase.
+ * @bind_count: Tracks the number of configurations the ECM function is
+ *              bound to, preventing double-registration of the @net device.
+ * @lock: Protects the data from concurrent access by configfs read/write
+ *        and create symlink/remove symlink operations.
+ * @refcnt: Reference counter for the function instance.
+ */
 struct f_ecm_opts {
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


