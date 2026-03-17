Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACE43EDADD;
	Tue, 17 Mar 2026 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766106; cv=none; b=cq1/VrLkFs9prlwEg2deRcPPd+Z6zhRxJxHVsiVT4Jw1li2M2GtheHnDb/b3ZFrCBOgUSKOFh6jyFgo7arXJOgbbCivSWUNkYaQGah1WUhjuzOMn11emmb8BQc/vDDCytil3+NA7pIOT6E5hvxgm6YpwMYdUl1yDqmB2DDNOo4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766106; c=relaxed/simple;
	bh=VwGkISruhX6OYdOvYT4GzEtpedB5b7EcLo+tn2REUbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQFNfAqDWtgz5GnrttdIE6ANYhX+8Z62u+FNcUP5+5hHiug+k1KyvupHfOT+xVYvmAtt2tTaOOKXIMo+KdnXnyMsqR64fnimE2R0XvBTkZ/4GgwMy3B81B4DQGqxDtkwyEJ4exQS8KRgihriHc2PqCn5pTlCTWP6VaeU/iGyA4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgeGTtY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgeGTtY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA79C4CEF7;
	Tue, 17 Mar 2026 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766106;
	bh=VwGkISruhX6OYdOvYT4GzEtpedB5b7EcLo+tn2REUbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgeGTtY0Hp2x+VqRdIbLSwZbc0DEqHw/WjEt1ZUN+QTM1KdpqnkKCxON+ELWVBJFC
	 JgvFJ7xeh8kOhJFybXKvShFQ5G6rXbsSAMoTIGsxHRmW0XTI43UgTuwd2cPnVLmwE6
	 N5+cePuylvSxdrZ2dQ0E3n8DyDay5n+TKCjCUaw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 172/378] usb: gadget: f_ncm: Fix net_device lifecycle with device_move
Date: Tue, 17 Mar 2026 17:32:09 +0100
Message-ID: <20260317163013.337193875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

commit ec35c1969650e7cb6c8a91020e568ed46e3551b0 upstream.

The network device outlived its parent gadget device during
disconnection, resulting in dangling sysfs links and null pointer
dereference problems.

A prior attempt to solve this by removing SET_NETDEV_DEV entirely [1]
was reverted due to power management ordering concerns and a NO-CARRIER
regression.

A subsequent attempt to defer net_device allocation to bind [2] broke
1:1 mapping between function instance and network device, making it
impossible for configfs to report the resolved interface name. This
results in a regression where the DHCP server fails on pmOS.

Use device_move to reparent the net_device between the gadget device and
/sys/devices/virtual/ across bind/unbind cycles. This preserves the
network interface across USB reconnection, allowing the DHCP server to
retain their binding.

Introduce gether_attach_gadget()/gether_detach_gadget() helpers and use
__free(detach_gadget) macro to undo attachment on bind failure. The
bind_count ensures device_move executes only on the first bind.

[1] https://lore.kernel.org/lkml/f2a4f9847617a0929d62025748384092e5f35cce.camel@crapouillou.net/
[2] https://lore.kernel.org/linux-usb/795ea759-7eaf-4f78-81f4-01ffbf2d7961@ixit.cz/

Fixes: 40d133d7f542 ("usb: gadget: f_ncm: convert to new function interface with backward compatibility")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260309-f-ncm-revert-v2-7-ea2afbc7d9b2@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c   |   38 ++++++++++++++++++++++------------
 drivers/usb/gadget/function/u_ether.c |   22 +++++++++++++++++++
 drivers/usb/gadget/function/u_ether.h |   26 +++++++++++++++++++++++
 drivers/usb/gadget/function/u_ncm.h   |    2 -
 4 files changed, 74 insertions(+), 14 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1439,6 +1439,7 @@ static int ncm_bind(struct usb_configura
 	struct f_ncm_opts	*ncm_opts;
 
 	struct usb_os_desc_table	*os_desc_table __free(kfree) = NULL;
+	struct net_device		*net __free(detach_gadget) = NULL;
 	struct usb_request		*request __free(free_usb_request) = NULL;
 
 	if (!can_support_ecm(cdev->gadget))
@@ -1452,18 +1453,19 @@ static int ncm_bind(struct usb_configura
 			return -ENOMEM;
 	}
 
-	mutex_lock(&ncm_opts->lock);
-	gether_set_gadget(ncm_opts->net, cdev->gadget);
-	if (!ncm_opts->bound) {
-		ncm_opts->net->mtu = (ncm_opts->max_segment_size - ETH_HLEN);
-		status = gether_register_netdev(ncm_opts->net);
-	}
-	mutex_unlock(&ncm_opts->lock);
-
-	if (status)
-		return status;
-
-	ncm_opts->bound = true;
+	scoped_guard(mutex, &ncm_opts->lock)
+		if (ncm_opts->bind_count == 0) {
+			if (!device_is_registered(&ncm_opts->net->dev)) {
+				ncm_opts->net->mtu = (ncm_opts->max_segment_size - ETH_HLEN);
+				gether_set_gadget(ncm_opts->net, cdev->gadget);
+				status = gether_register_netdev(ncm_opts->net);
+			} else
+				status = gether_attach_gadget(ncm_opts->net, cdev->gadget);
+
+			if (status)
+				return status;
+			net = ncm_opts->net;
+		}
 
 	ncm_string_defs[1].s = ncm->ethaddr;
 
@@ -1564,6 +1566,9 @@ static int ncm_bind(struct usb_configura
 	}
 	ncm->notify_req = no_free_ptr(request);
 
+	ncm_opts->bind_count++;
+	retain_and_null_ptr(net);
+
 	DBG(cdev, "CDC Network: IN/%s OUT/%s NOTIFY/%s\n",
 			ncm->port.in_ep->name, ncm->port.out_ep->name,
 			ncm->notify->name);
@@ -1655,7 +1660,7 @@ static void ncm_free_inst(struct usb_fun
 	struct f_ncm_opts *opts;
 
 	opts = container_of(f, struct f_ncm_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
@@ -1718,9 +1723,12 @@ static void ncm_free(struct usb_function
 static void ncm_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_ncm *ncm = func_to_ncm(f);
+	struct f_ncm_opts *ncm_opts;
 
 	DBG(c->cdev, "ncm unbind\n");
 
+	ncm_opts = container_of(f->fi, struct f_ncm_opts, func_inst);
+
 	hrtimer_cancel(&ncm->task_timer);
 
 	kfree(f->os_desc_table);
@@ -1736,6 +1744,10 @@ static void ncm_unbind(struct usb_config
 
 	kfree(ncm->notify_req->buf);
 	usb_ep_free_request(ncm->notify, ncm->notify_req);
+
+	ncm_opts->bind_count--;
+	if (ncm_opts->bind_count == 0)
+		gether_detach_gadget(ncm_opts->net);
 }
 
 static struct usb_function *ncm_alloc(struct usb_function_instance *fi)
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -896,6 +896,28 @@ void gether_set_gadget(struct net_device
 }
 EXPORT_SYMBOL_GPL(gether_set_gadget);
 
+int gether_attach_gadget(struct net_device *net, struct usb_gadget *g)
+{
+	int ret;
+
+	ret = device_move(&net->dev, &g->dev, DPM_ORDER_DEV_AFTER_PARENT);
+	if (ret)
+		return ret;
+
+	gether_set_gadget(net, g);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gether_attach_gadget);
+
+void gether_detach_gadget(struct net_device *net)
+{
+	struct eth_dev *dev = netdev_priv(net);
+
+	device_move(&net->dev, NULL, DPM_ORDER_NONE);
+	dev->gadget = NULL;
+}
+EXPORT_SYMBOL_GPL(gether_detach_gadget);
+
 int gether_set_dev_addr(struct net_device *net, const char *dev_addr)
 {
 	struct eth_dev *dev;
--- a/drivers/usb/gadget/function/u_ether.h
+++ b/drivers/usb/gadget/function/u_ether.h
@@ -151,6 +151,32 @@ static inline struct net_device *gether_
 void gether_set_gadget(struct net_device *net, struct usb_gadget *g);
 
 /**
+ * gether_attach_gadget - Reparent net_device to the gadget device.
+ * @net: The network device to reparent.
+ * @g: The target USB gadget device to parent to.
+ *
+ * This function moves the network device to be a child of the USB gadget
+ * device in the device hierarchy. This is typically done when the function
+ * is bound to a configuration.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int gether_attach_gadget(struct net_device *net, struct usb_gadget *g);
+
+/**
+ * gether_detach_gadget - Detach net_device from its gadget parent.
+ * @net: The network device to detach.
+ *
+ * This function moves the network device to be a child of the virtual
+ * devices parent, effectively detaching it from the USB gadget device
+ * hierarchy. This is typically done when the function is unbound
+ * from a configuration but the instance is not yet freed.
+ */
+void gether_detach_gadget(struct net_device *net);
+
+DEFINE_FREE(detach_gadget, struct net_device *, if (_T) gether_detach_gadget(_T))
+
+/**
  * gether_set_dev_addr - initialize an ethernet-over-usb link with eth address
  * @net: device representing this link
  * @dev_addr: eth address of this device
--- a/drivers/usb/gadget/function/u_ncm.h
+++ b/drivers/usb/gadget/function/u_ncm.h
@@ -18,7 +18,7 @@
 struct f_ncm_opts {
 	struct usb_function_instance	func_inst;
 	struct net_device		*net;
-	bool				bound;
+	int				bind_count;
 
 	struct config_group		*ncm_interf_group;
 	struct usb_os_desc		ncm_os_desc;


