Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EDC27587E;
	Tue, 21 Oct 2025 20:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076802; cv=none; b=EZ+Plpuqbzpt/jz2GyNG9hJgOphTfpXPrLxtoIUhlJnKBipBuntDTWu8dnoQ7pcnHYJdZITihYHBlIMh7mpZ97rzR40LF1q1X39R6FWkEuifEYhV5LNSSJfP5KS3o2O5cBbFcamyoPDpzBUUxfG+Nj4uDLG6iSCjoj3J8SzpebU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076802; c=relaxed/simple;
	bh=0uujzXi2Wyxvo2GY1tlWZ2hN3KblriNCyFI31hijZOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da3F2wqU2V6uFSuXMo8MUsFYiMac0nRbWSL8+WWsNDNga0NG9pAblrp17M/awsVE43m8A7HnHrYsJ1Dkb62COMBvC9VI7ZEGNm9cgHqpfWKbXo9Fgs6EAQ0E9G+GFEzXSZd4cbGIazGONfrD4VtcpYNXzHrL0aTZCrEQ/JJrj/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFg2HE+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFg2HE+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C7C4CEF1;
	Tue, 21 Oct 2025 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076801;
	bh=0uujzXi2Wyxvo2GY1tlWZ2hN3KblriNCyFI31hijZOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFg2HE+tbwKFhAI16YMvVvY9LETZG5h409Dee2YpRMSgx+lNq6sEw9ocqgf0lklwk
	 R/A3k6GMWenuNCxrzvPhvTdRFx5aiSyNt3AfnW1ig/YJpu76TrF1wIld9PNT7p+xLB
	 e87wf+jZQMq156/GzvjUJfkMbR0Jd8pErhJOrZM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/136] usb: gadget: f_rndis: Refactor bind path to use __free()
Date: Tue, 21 Oct 2025 21:50:28 +0200
Message-ID: <20251021195036.944935213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

[ Upstream commit 08228941436047bdcd35a612c1aec0912a29d8cd ]

After an bind/unbind cycle, the rndis->notify_req is left stale. If a
subsequent bind fails, the unified error label attempts to free this
stale request, leading to a NULL pointer dereference when accessing
ep->ops->free_request.

Refactor the error handling in the bind path to use the __free()
automatic cleanup mechanism.

Fixes: 45fe3b8e5342 ("usb ethernet gadget: split RNDIS function")
Cc: stable@kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://lore.kernel.org/r/20250916-ready-v1-6-4997bf277548@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250916-ready-v1-6-4997bf277548@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_rndis.c |   85 ++++++++++++++--------------------
 1 file changed, 35 insertions(+), 50 deletions(-)

--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -19,6 +19,8 @@
 
 #include <linux/atomic.h>
 
+#include <linux/usb/gadget.h>
+
 #include "u_ether.h"
 #include "u_ether_configfs.h"
 #include "u_rndis.h"
@@ -662,6 +664,8 @@ rndis_bind(struct usb_configuration *c,
 	struct usb_ep		*ep;
 
 	struct f_rndis_opts *rndis_opts;
+	struct usb_os_desc_table        *os_desc_table __free(kfree) = NULL;
+	struct usb_request		*request __free(free_usb_request) = NULL;
 
 	if (!can_support_rndis(c))
 		return -EINVAL;
@@ -669,12 +673,9 @@ rndis_bind(struct usb_configuration *c,
 	rndis_opts = container_of(f->fi, struct f_rndis_opts, func_inst);
 
 	if (cdev->use_os_string) {
-		f->os_desc_table = kzalloc(sizeof(*f->os_desc_table),
-					   GFP_KERNEL);
-		if (!f->os_desc_table)
+		os_desc_table = kzalloc(sizeof(*os_desc_table), GFP_KERNEL);
+		if (!os_desc_table)
 			return -ENOMEM;
-		f->os_desc_n = 1;
-		f->os_desc_table[0].os_desc = &rndis_opts->rndis_os_desc;
 	}
 
 	rndis_iad_descriptor.bFunctionClass = rndis_opts->class;
@@ -692,16 +693,14 @@ rndis_bind(struct usb_configuration *c,
 		gether_set_gadget(rndis_opts->net, cdev->gadget);
 		status = gether_register_netdev(rndis_opts->net);
 		if (status)
-			goto fail;
+			return status;
 		rndis_opts->bound = true;
 	}
 
 	us = usb_gstrings_attach(cdev, rndis_strings,
 				 ARRAY_SIZE(rndis_string_defs));
-	if (IS_ERR(us)) {
-		status = PTR_ERR(us);
-		goto fail;
-	}
+	if (IS_ERR(us))
+		return PTR_ERR(us);
 	rndis_control_intf.iInterface = us[0].id;
 	rndis_data_intf.iInterface = us[1].id;
 	rndis_iad_descriptor.iFunction = us[2].id;
@@ -709,36 +708,30 @@ rndis_bind(struct usb_configuration *c,
 	/* allocate instance-specific interface IDs */
 	status = usb_interface_id(c, f);
 	if (status < 0)
-		goto fail;
+		return status;
 	rndis->ctrl_id = status;
 	rndis_iad_descriptor.bFirstInterface = status;
 
 	rndis_control_intf.bInterfaceNumber = status;
 	rndis_union_desc.bMasterInterface0 = status;
 
-	if (cdev->use_os_string)
-		f->os_desc_table[0].if_id =
-			rndis_iad_descriptor.bFirstInterface;
-
 	status = usb_interface_id(c, f);
 	if (status < 0)
-		goto fail;
+		return status;
 	rndis->data_id = status;
 
 	rndis_data_intf.bInterfaceNumber = status;
 	rndis_union_desc.bSlaveInterface0 = status;
 
-	status = -ENODEV;
-
 	/* allocate instance-specific endpoints */
 	ep = usb_ep_autoconfig(cdev->gadget, &fs_in_desc);
 	if (!ep)
-		goto fail;
+		return -ENODEV;
 	rndis->port.in_ep = ep;
 
 	ep = usb_ep_autoconfig(cdev->gadget, &fs_out_desc);
 	if (!ep)
-		goto fail;
+		return -ENODEV;
 	rndis->port.out_ep = ep;
 
 	/* NOTE:  a status/notification endpoint is, strictly speaking,
@@ -747,21 +740,19 @@ rndis_bind(struct usb_configuration *c,
 	 */
 	ep = usb_ep_autoconfig(cdev->gadget, &fs_notify_desc);
 	if (!ep)
-		goto fail;
+		return -ENODEV;
 	rndis->notify = ep;
 
-	status = -ENOMEM;
-
 	/* allocate notification request and buffer */
-	rndis->notify_req = usb_ep_alloc_request(ep, GFP_KERNEL);
-	if (!rndis->notify_req)
-		goto fail;
-	rndis->notify_req->buf = kmalloc(STATUS_BYTECOUNT, GFP_KERNEL);
-	if (!rndis->notify_req->buf)
-		goto fail;
-	rndis->notify_req->length = STATUS_BYTECOUNT;
-	rndis->notify_req->context = rndis;
-	rndis->notify_req->complete = rndis_response_complete;
+	request = usb_ep_alloc_request(ep, GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+	request->buf = kmalloc(STATUS_BYTECOUNT, GFP_KERNEL);
+	if (!request->buf)
+		return -ENOMEM;
+	request->length = STATUS_BYTECOUNT;
+	request->context = rndis;
+	request->complete = rndis_response_complete;
 
 	/* support all relevant hardware speeds... we expect that when
 	 * hardware is dual speed, all bulk-capable endpoints work at
@@ -778,7 +769,7 @@ rndis_bind(struct usb_configuration *c,
 	status = usb_assign_descriptors(f, eth_fs_function, eth_hs_function,
 			eth_ss_function, eth_ss_function);
 	if (status)
-		goto fail;
+		return status;
 
 	rndis->port.open = rndis_open;
 	rndis->port.close = rndis_close;
@@ -789,9 +780,18 @@ rndis_bind(struct usb_configuration *c,
 	if (rndis->manufacturer && rndis->vendorID &&
 			rndis_set_param_vendor(rndis->params, rndis->vendorID,
 					       rndis->manufacturer)) {
-		status = -EINVAL;
-		goto fail_free_descs;
+		usb_free_all_descriptors(f);
+		return -EINVAL;
+	}
+
+	if (cdev->use_os_string) {
+		os_desc_table[0].os_desc = &rndis_opts->rndis_os_desc;
+		os_desc_table[0].if_id = rndis_iad_descriptor.bFirstInterface;
+		f->os_desc_table = no_free_ptr(os_desc_table);
+		f->os_desc_n = 1;
+
 	}
+	rndis->notify_req = no_free_ptr(request);
 
 	/* NOTE:  all that is done without knowing or caring about
 	 * the network link ... which is unavailable to this code
@@ -802,21 +802,6 @@ rndis_bind(struct usb_configuration *c,
 			rndis->port.in_ep->name, rndis->port.out_ep->name,
 			rndis->notify->name);
 	return 0;
-
-fail_free_descs:
-	usb_free_all_descriptors(f);
-fail:
-	kfree(f->os_desc_table);
-	f->os_desc_n = 0;
-
-	if (rndis->notify_req) {
-		kfree(rndis->notify_req->buf);
-		usb_ep_free_request(rndis->notify, rndis->notify_req);
-	}
-
-	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
-
-	return status;
 }
 
 void rndis_borrow_net(struct usb_function_instance *f, struct net_device *net)


