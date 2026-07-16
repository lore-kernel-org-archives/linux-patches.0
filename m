Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9406931ED7C;
	Thu, 16 Jul 2026 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211073; cv=none; b=h1BMa6SpT7M6DLfzcrmvlISrLoqY7dwOnmdkCNLn8aaTWDJ7ScDrLii6DjIvsfoaYJq2VWpzEJyXk3+NBItI9DA4jU9i6qKdyBs3HprkrINLOYrBv7VVn6jOJzALv4o2wWXgurrAVkFVwFEJBn2pfD2zF8EWxLyDbMAyD1vR97s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211073; c=relaxed/simple;
	bh=mAYlm3JZBKccQ2nLFEJQPq6X1RL+yhJl+h9kqQ4A4MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emt9U7+cLqz9qxg2GUT5r9p4TBbHNZHNJNf+bnku0202je7IcjTSbeZl0naEioDFe04jktHt5iF1L0xSkh/CN99/Q7hgsG7fBgBS9eRiQ7lpUvI0zToGAe4H+gKjH3O8dw9m7BYwYHj60rJp2vVKHdpLmScIkrjwOvcbxLOB8P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4OLAX5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4OLAX5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048F71F00A3A;
	Thu, 16 Jul 2026 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211072;
	bh=XQJXSUvtJIFnev9fBkQ6Z/1uMTZ2KOZcI+Vu7UKqOe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4OLAX5In7qy1nXwYGrkONfGdiL4uighyiIBzuq5CzBH8OvS3iyH2BXvrXcN9Syud
	 wLuEbAfXPYONNsuEM7HtlMUbFjKk6itmydT3RnMa7XvXb8Lxe7BrQc+sMSUYUzdr09
	 0O4Y97ME+c3NQcJX0yo+KhrRSA8XNOU9bGRpNB4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>,
	Jimmy Hu <hhhuuu@google.com>
Subject: [PATCH 6.18 290/480] usb: gadget: udc: Fix use-after-free in gadget_match_driver
Date: Thu, 16 Jul 2026 15:30:37 +0200
Message-ID: <20260716133051.095419742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -31,8 +31,9 @@ static const struct bus_type gadget_bus_
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
@@ -53,6 +54,7 @@ static const struct bus_type gadget_bus_
 struct usb_udc {
 	struct usb_gadget_driver	*driver;
 	struct usb_gadget		*gadget;
+	void				(*gadget_release)(struct device *dev);
 	struct device			dev;
 	struct list_head		list;
 	bool				vbus;
@@ -1356,6 +1358,17 @@ static void usb_udc_nop_release(struct d
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
@@ -1412,6 +1425,14 @@ int usb_add_gadget(struct usb_gadget *ga
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
@@ -1456,6 +1477,12 @@ int usb_add_gadget(struct usb_gadget *ga
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


