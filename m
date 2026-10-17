Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B778F38F233;
	Sat, 17 Oct 2026 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258582; cv=none; b=kjYxd2/gnvUa4FWvsdt32m0oXAsSbI9vHLVbbSpD+VRs9ytKGAF91GsqjLSNwYwsRUul53uzza3JyUhV4cK7taP0npRRl5dPu680/+denLoCrWITYUbclAnEBCu7np50xIvAwaMz9a6Te3P0oaS+7/EW5k8X2gz11rc3TZwNdpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258582; c=relaxed/simple;
	bh=2wsdTwhu0E+Jew1VqVEmO0uTdc0AJWoTMetOipMRCjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgTcyMoPaLJVR0pphB4HFSTSGN7PzvZDPcgTLdPJHghO+Aqj4O6ZKL/ef493VAQgkca2FNJ8snnOvDe0Z6v0pdyDrG3Hf13w16ZVVmBp2cF2nO3KWfnB/jgJVJG7X3WLbw8TAK8uoeZntHm2FDbkd+i0fHFCNxiWRTcNDqbM7Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtXOe6iJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtXOe6iJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF55F1F000C4;
	Sat, 17 Oct 2026 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258581;
	bh=EWaOUQGUIBu5sSf8juTIEgxnuFPX+4g0AJkAg+6Na1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtXOe6iJO9hBK6+QSbcZViP9sN7I7zP0bhVgnp7u2IF3N/k8hMR4tmbUmfArKpAbR
	 Z54cVzudf24QKRDARokJoo6w0O0MPc3j5JUJblh2w7Le/bURqera4B2NIAyDHxzUhg
	 7bKq+V7X5pw12L0hHssKucTNwruvF3eOFEGK7SLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0891/1674] usb: gadget: f_subset: Fix net_device lifecycle with device_move
Date: Sat, 17 Oct 2026 17:52:43 +0200
Message-ID: <20261017160453.998077390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit 06524cd1c9011bee141a87e43ab878641ed3652b ]

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

Fixes: 8cedba7c73af ("usb: gadget: f_subset: convert to new function interface with backward compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-6-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_subset.c | 57 +++++++++++++-------------
 drivers/usb/gadget/function/u_gether.h | 22 ++++++----
 2 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/gadget/function/f_subset.c b/drivers/usb/gadget/function/f_subset.c
index 7d209382c0686..489b1f57f5c1f 100644
--- a/drivers/usb/gadget/function/f_subset.c
+++ b/drivers/usb/gadget/function/f_subset.c
@@ -299,25 +299,22 @@ geth_bind(struct usb_configuration *c, struct usb_function *f)
 	struct usb_ep		*ep;
 
 	struct f_gether_opts	*gether_opts;
+	struct net_device	*net __free(detach_gadget) = NULL;
 
 	gether_opts = container_of(f->fi, struct f_gether_opts, func_inst);
 
-	/*
-	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
-	 * configurations are bound in sequence with list_for_each_entry,
-	 * in each configuration its functions are bound in sequence
-	 * with list_for_each_entry, so we assume no race condition
-	 * with regard to gether_opts->bound access
-	 */
-	if (!gether_opts->bound) {
-		mutex_lock(&gether_opts->lock);
-		gether_set_gadget(gether_opts->net, cdev->gadget);
-		status = gether_register_netdev(gether_opts->net);
-		mutex_unlock(&gether_opts->lock);
-		if (status)
-			return status;
-		gether_opts->bound = true;
-	}
+	scoped_guard(mutex, &gether_opts->lock)
+		if (gether_opts->bind_count == 0 && !gether_opts->bound) {
+			if (!device_is_registered(&gether_opts->net->dev)) {
+				gether_set_gadget(gether_opts->net, cdev->gadget);
+				status = gether_register_netdev(gether_opts->net);
+			} else
+				status = gether_attach_gadget(gether_opts->net, cdev->gadget);
+
+			if (status)
+				return status;
+			net = gether_opts->net;
+		}
 
 	us = usb_gstrings_attach(cdev, geth_strings,
 				 ARRAY_SIZE(geth_string_defs));
@@ -330,20 +327,18 @@ geth_bind(struct usb_configuration *c, struct usb_function *f)
 	/* allocate instance-specific interface IDs */
 	status = usb_interface_id(c, f);
 	if (status < 0)
-		goto fail;
+		return status;
 	subset_data_intf.bInterfaceNumber = status;
 
-	status = -ENODEV;
-
 	/* allocate instance-specific endpoints */
 	ep = usb_ep_autoconfig(cdev->gadget, &fs_subset_in_desc);
 	if (!ep)
-		goto fail;
+		return -ENODEV;
 	geth->port.in_ep = ep;
 
 	ep = usb_ep_autoconfig(cdev->gadget, &fs_subset_out_desc);
 	if (!ep)
-		goto fail;
+		return -ENODEV;
 	geth->port.out_ep = ep;
 
 	/* support all relevant hardware speeds... we expect that when
@@ -361,21 +356,19 @@ geth_bind(struct usb_configuration *c, struct usb_function *f)
 	status = usb_assign_descriptors(f, fs_eth_function, hs_eth_function,
 			ss_eth_function, ss_eth_function);
 	if (status)
-		goto fail;
+		return status;
 
 	/* NOTE:  all that is done without knowing or caring about
 	 * the network link ... which is unavailable to this code
 	 * until we're activated via set_alt().
 	 */
 
+	gether_opts->bind_count++;
+	no_free_ptr(net);
+
 	DBG(cdev, "CDC Subset: IN/%s OUT/%s\n",
 			geth->port.in_ep->name, geth->port.out_ep->name);
 	return 0;
-
-fail:
-	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
-
-	return status;
 }
 
 static inline struct f_gether_opts *to_f_gether_opts(struct config_item *item)
@@ -418,7 +411,7 @@ static void geth_free_inst(struct usb_function_instance *f)
 	struct f_gether_opts *opts;
 
 	opts = container_of(f, struct f_gether_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
@@ -462,8 +455,16 @@ static void geth_free(struct usb_function *f)
 
 static void geth_unbind(struct usb_configuration *c, struct usb_function *f)
 {
+	struct f_gether_opts *opts;
+
+	opts = container_of(f->fi, struct f_gether_opts, func_inst);
+
 	geth_string_defs[0].id = 0;
 	usb_free_all_descriptors(f);
+
+	opts->bind_count--;
+	if (opts->bind_count == 0 && !opts->bound)
+		gether_detach_gadget(opts->net);
 }
 
 static struct usb_function *geth_alloc(struct usb_function_instance *fi)
diff --git a/drivers/usb/gadget/function/u_gether.h b/drivers/usb/gadget/function/u_gether.h
index 2f7a373ed4496..e7b6b51f69c12 100644
--- a/drivers/usb/gadget/function/u_gether.h
+++ b/drivers/usb/gadget/function/u_gether.h
@@ -15,17 +15,25 @@
 
 #include <linux/usb/composite.h>
 
+/**
+ * struct f_gether_opts - subset function options
+ * @func_inst: USB function instance.
+ * @net: The net_device associated with the subset function.
+ * @bound: True if the net_device is shared and pre-registered during the
+ *         legacy composite driver's bind phase (e.g., multi.c). If false,
+ *         the subset function will register the net_device during its own
+ *         bind phase.
+ * @bind_count: Tracks the number of configurations the subset function is
+ *              bound to, preventing double-registration of the @net device.
+ * @lock: Protects the data from concurrent access by configfs read/write
+ *        and create symlink/remove symlink operations.
+ * @refcnt: Reference counter for the function instance.
+ */
 struct f_gether_opts {
 	struct usb_function_instance	func_inst;
 	struct net_device		*net;
 	bool				bound;
-
-	/*
-	 * Read/write access to configfs attributes is handled by configfs.
-	 *
-	 * This is to protect the data from concurrent access by read/write
-	 * and create symlink/remove symlink.
-	 */
+	int				bind_count;
 	struct mutex			lock;
 	int				refcnt;
 };
-- 
2.53.0



