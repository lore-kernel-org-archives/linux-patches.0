Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA66B44AB9C;
	Tue, 21 Jul 2026 21:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668427; cv=none; b=gFVFay9O9cnM28xHggPVzK3taG3aDLraEeLj2Yh7YhMUKbZGNRxNyyUudNK3YpWNYqcyAEJ8iatFpkoT+rWsPDNuVzF9UcskavjrLglKDM/AtEUUe3LGcn/ZLYTpsPH+63EQ5GIyHTdxU3LHoPVLFIUg93yHj3YfX6VHtg2RE0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668427; c=relaxed/simple;
	bh=V+EOOH4tzmFOcFxP26LlkphN2SomUvyEfdo0Q86FzWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPushYcFGont16peDi1aIia1KYL8I/DlU1JFnPVHu7Gtvz7HCGCC4rUy6nLH+EsCdOdRTPoufP6Tu/deqYp7Jp0Y28FE7NYdj6WWKWMuGNFZrBIezP0wj96b3o2tM5C8xXvSavYUTuMpgCXi0uHRMdGIfY58AODZsxjg4IpF0UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHHyEclh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHHyEclh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6101F000E9;
	Tue, 21 Jul 2026 21:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668425;
	bh=tbyfXPbUEgwQ3srp+nIzgYgw93Pch+c+Jpdi8fsFb8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHHyEclhvVtN4NuP8DEfuCrsDUhJEB/rYnFNH44Q8ivtSLSefPT3Z3Rjqx2pCUJZx
	 ge2xenn6aanptzcTTtDbxWO6llziTjOdsjKC8xXzDwnQ3ZKXPJRIWVCT668gfHXWjH
	 UTNACri0WJqrOa9mQTwjZ67X6Tib7G5B4F/4por0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>,
	Jimmy Hu <hhhuuu@google.com>
Subject: [PATCH 6.1 0171/1067] usb: gadget: udc: Fix use-after-free in gadget_match_driver
Date: Tue, 21 Jul 2026 17:12:52 +0200
Message-ID: <20260721152428.416387046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Hu <hhhuuu@google.com>

commit 67e511d2989eb1c8c588b599ce2fcc6bb8e6f7ea upstream.

The udc structure acts as the management structure for the gadget,
but their lifecycles are decoupled. A race condition exists where
usb_del_gadget() frees the udc memory (e.g., via mode-switch work)
while gadget_match_driver() concurrently accesses the freed udc memory
(e.g., via configfs), causing a Use-After-Free (UAF) that triggers a
NULL pointer dereference when the freed memory is zeroed:

[39430.908615][ T1171] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[39430.911397][ T1171] pc : __pi_strcmp+0x20/0x140
[39430.911441][ T1171] lr : gadget_match_driver+0x34/0x60
...
[39430.911890][ T1171]  usb_gadget_register_driver_owner+0x50/0xf8
[39430.911910][ T1171]  gadget_dev_desc_UDC_store+0xf4/0x140
[39430.931308][ T1171]  configfs_write_iter+0xec/0x134

[39430.957058][ T1171] Workqueue: events_freezable __dwc3_set_mode
[39430.957287][ T1171]  dwc3_gadget_exit+0x34/0x8c
[39430.957304][ T1171]  __dwc3_set_mode+0xc0/0x664

Fix this by ensuring the udc structure remains allocated until the
gadget is released. To achieve this, introduce a new
usb_gadget_release() routine to the core. When the gadget is added,
usb_add_gadget() stores the gadget's release routine in the udc
structure and takes a reference to the udc. When the gadget is
released, usb_gadget_release() drops the reference to the udc and
then calls the gadget's release routine.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Jimmy Hu <hhhuuu@google.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260625073705.803880-1-hhhuuu@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -31,8 +31,9 @@ static struct bus_type gadget_bus_type;
 /**
  * struct usb_udc - describes one usb device controller
  * @driver: the gadget driver pointer. For use by the class code
- * @dev: the child device to the actual controller
  * @gadget: the gadget. For use by the class code
+ * @gadget_release: the gadget's release routine
+ * @dev: the child device to the actual controller
  * @list: for use by the udc class driver
  * @vbus: for udcs who care about vbus status, this value is real vbus status;
  * for udcs who do not care about vbus status, this value is always true
@@ -53,6 +54,7 @@ static struct bus_type gadget_bus_type;
 struct usb_udc {
 	struct usb_gadget_driver	*driver;
 	struct usb_gadget		*gadget;
+	void				(*gadget_release)(struct device *dev);
 	struct device			dev;
 	struct list_head		list;
 	bool				vbus;
@@ -1351,6 +1353,17 @@ static void usb_udc_nop_release(struct d
 	dev_vdbg(dev, "%s\n", __func__);
 }
 
+static void usb_gadget_release(struct device *dev)
+{
+	struct usb_gadget *gadget = dev_to_usb_gadget(dev);
+	struct usb_udc *udc = gadget->udc;
+	/* Cache the gadget's release routine to prevent UAF */
+	void (*release)(struct device *dev) = udc->gadget_release;
+
+	put_device(&udc->dev);
+	release(dev);
+}
+
 /**
  * usb_initialize_gadget - initialize a gadget and its embedded struct device
  * @parent: the parent device to this udc. Usually the controller driver's
@@ -1407,6 +1420,14 @@ int usb_add_gadget(struct usb_gadget *ga
 	mutex_init(&udc->connect_lock);
 
 	udc->started = false;
+	/*
+	 * Align decoupled lifecycles: take a UDC reference to ensure it
+	 * remains allocated until the gadget is released, requiring an
+	 * override of the gadget's release routine to drop it.
+	 */
+	udc->gadget_release = gadget->dev.release;
+	gadget->dev.release = usb_gadget_release;
+	get_device(&udc->dev);
 
 	mutex_lock(&udc_lock);
 	list_add_tail(&udc->list, &udc_list);
@@ -1451,6 +1472,12 @@ int usb_add_gadget(struct usb_gadget *ga
 	mutex_lock(&udc_lock);
 	list_del(&udc->list);
 	mutex_unlock(&udc_lock);
+	/*
+	 * Revert the override and drop the UDC reference to prevent
+	 * leaking the UDC if the gadget was statically allocated.
+	 */
+	gadget->dev.release = udc->gadget_release;
+	put_device(&udc->dev);
 
  err_put_udc:
 	put_device(&udc->dev);


