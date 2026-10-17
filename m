Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976B11F16B;
	Sat, 17 Oct 2026 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258579; cv=none; b=k3FKRcNWoxxja3KEVBDNz3AYB0vWruez8GfiiHad1QjUv2oVQr4/mQuF0S5gNbh43MxxXqSRcO7PogKfFMzRkqtYGWIVOtJOyh9IczF1fFksRTPGHQa07+hNrWIrVSKTcrc2sdWNHFRP5UdBz7kWQFpbecnh+IZlcMOeE4jDEnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258579; c=relaxed/simple;
	bh=CVPQ9F1oHP8K5UjibTTyouJl1ucMfxawfp2CjYicgyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrZUOZXcoGONICHE97RcWoKh/uUs+0F1hLUPljx6NFfUFu7PzF6BoYde64I8tiyIPA6rzVBupg2jLC82vZsLA/e1iTXRY8vhNndhe9oMOVTD/ypBHMtIyUcw5OW5BQPeM9Q+cWCxCwKKoddmGhRJP8wWH7L1Yt9r4Bdjyo1/6Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1U8g3WI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1U8g3WI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB361F000C4;
	Sat, 17 Oct 2026 17:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258578;
	bh=4IVYmTl0Zw1Z9QIFi+MSdZXXtN7tIUvN1Orymdo8Hm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1U8g3WIdDN0HeugEZ4WRBnTN4/bLDJARSqjiAwy6zMTQZzxQTYRolBy1ZQUnbS0w
	 FACxbp/33yqtm1LkxhxK2hM4km48/4cP4tENMhO9qKW0m5ZkO9lWGmIV9lzbKjdRC+
	 jdVQtQp/dqtx4xOBAgxmCXeKHeE+fz83KokUAJpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0890/1674] usb: gadget: f_rndis: Fix net_device lifecycle with device_move
Date: Sat, 17 Oct 2026 17:52:42 +0200
Message-ID: <20261017160453.968843610@linuxfoundation.org>
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

[ Upstream commit e367599529dc42578545a7f85fde517b35b3cda7 ]

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
the borrowed_net flag is used to indicate whether the network device is
shared and pre-registered during the legacy driver's bind phase.

Fixes: f466c6353819 ("usb: gadget: f_rndis: convert to new function interface with backward compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-7-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_rndis.c | 42 ++++++++++++++++-----------
 drivers/usb/gadget/function/u_rndis.h | 31 +++++++++++++++-----
 2 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/function/f_rndis.c
index c117286442730..bac60612ffa66 100644
--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -666,6 +666,7 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 
 	struct f_rndis_opts *rndis_opts;
 	struct usb_os_desc_table        *os_desc_table __free(kfree) = NULL;
+	struct net_device		*net __free(detach_gadget) = NULL;
 	struct usb_request		*request __free(free_usb_request) = NULL;
 
 	if (!can_support_rndis(c))
@@ -683,21 +684,18 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 		rndis_iad_descriptor.bFunctionClass = rndis_opts->class;
 		rndis_iad_descriptor.bFunctionSubClass = rndis_opts->subclass;
 		rndis_iad_descriptor.bFunctionProtocol = rndis_opts->protocol;
-	}
 
-	/*
-	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
-	 * configurations are bound in sequence with list_for_each_entry,
-	 * in each configuration its functions are bound in sequence
-	 * with list_for_each_entry, so we assume no race condition
-	 * with regard to rndis_opts->bound access
-	 */
-	if (!rndis_opts->bound) {
-		gether_set_gadget(rndis_opts->net, cdev->gadget);
-		status = gether_register_netdev(rndis_opts->net);
-		if (status)
-			return status;
-		rndis_opts->bound = true;
+		if (rndis_opts->bind_count == 0 && !rndis_opts->borrowed_net) {
+			if (!device_is_registered(&rndis_opts->net->dev)) {
+				gether_set_gadget(rndis_opts->net, cdev->gadget);
+				status = gether_register_netdev(rndis_opts->net);
+			} else
+				status = gether_attach_gadget(rndis_opts->net, cdev->gadget);
+
+			if (status)
+				return status;
+			net = rndis_opts->net;
+		}
 	}
 
 	us = usb_gstrings_attach(cdev, rndis_strings,
@@ -796,6 +794,9 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 	}
 	rndis->notify_req = no_free_ptr(request);
 
+	rndis_opts->bind_count++;
+	no_free_ptr(net);
+
 	/* NOTE:  all that is done without knowing or caring about
 	 * the network link ... which is unavailable to this code
 	 * until we're activated via set_alt().
@@ -812,11 +813,11 @@ void rndis_borrow_net(struct usb_function_instance *f, struct net_device *net)
 	struct f_rndis_opts *opts;
 
 	opts = container_of(f, struct f_rndis_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
-	opts->borrowed_net = opts->bound = true;
+	opts->borrowed_net = true;
 	opts->net = net;
 }
 EXPORT_SYMBOL_GPL(rndis_borrow_net);
@@ -874,7 +875,7 @@ static void rndis_free_inst(struct usb_function_instance *f)
 
 	opts = container_of(f, struct f_rndis_opts, func_inst);
 	if (!opts->borrowed_net) {
-		if (opts->bound)
+		if (device_is_registered(&opts->net->dev))
 			gether_cleanup(netdev_priv(opts->net));
 		else
 			free_netdev(opts->net);
@@ -943,6 +944,9 @@ static void rndis_free(struct usb_function *f)
 static void rndis_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_rndis		*rndis = func_to_rndis(f);
+	struct f_rndis_opts	*rndis_opts;
+
+	rndis_opts = container_of(f->fi, struct f_rndis_opts, func_inst);
 
 	kfree(f->os_desc_table);
 	f->os_desc_n = 0;
@@ -950,6 +954,10 @@ static void rndis_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	kfree(rndis->notify_req->buf);
 	usb_ep_free_request(rndis->notify, rndis->notify_req);
+
+	rndis_opts->bind_count--;
+	if (rndis_opts->bind_count == 0 && !rndis_opts->borrowed_net)
+		gether_detach_gadget(rndis_opts->net);
 }
 
 static struct usb_function *rndis_alloc(struct usb_function_instance *fi)
diff --git a/drivers/usb/gadget/function/u_rndis.h b/drivers/usb/gadget/function/u_rndis.h
index a8c409b2f52f9..4e64619714dc2 100644
--- a/drivers/usb/gadget/function/u_rndis.h
+++ b/drivers/usb/gadget/function/u_rndis.h
@@ -15,12 +15,34 @@
 
 #include <linux/usb/composite.h>
 
+/**
+ * struct f_rndis_opts - RNDIS function options
+ * @func_inst: USB function instance.
+ * @vendor_id: Vendor ID.
+ * @manufacturer: Manufacturer string.
+ * @net: The net_device associated with the RNDIS function.
+ * @bind_count: Tracks the number of configurations the RNDIS function is
+ *              bound to, preventing double-registration of the @net device.
+ * @borrowed_net: True if the net_device is shared and pre-registered during
+ *                the legacy composite driver's bind phase (e.g., multi.c).
+ *                If false, the RNDIS function will register the net_device
+ *                during its own bind phase.
+ * @rndis_interf_group: ConfigFS group for RNDIS interface.
+ * @rndis_os_desc: USB OS descriptor for RNDIS.
+ * @rndis_ext_compat_id: Extended compatibility ID.
+ * @class: USB class.
+ * @subclass: USB subclass.
+ * @protocol: USB protocol.
+ * @lock: Protects the data from concurrent access by configfs read/write
+ *        and create symlink/remove symlink operations.
+ * @refcnt: Reference counter for the function instance.
+ */
 struct f_rndis_opts {
 	struct usb_function_instance	func_inst;
 	u32				vendor_id;
 	const char			*manufacturer;
 	struct net_device		*net;
-	bool				bound;
+	int				bind_count;
 	bool				borrowed_net;
 
 	struct config_group		*rndis_interf_group;
@@ -30,13 +52,6 @@ struct f_rndis_opts {
 	u8				class;
 	u8				subclass;
 	u8				protocol;
-
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



