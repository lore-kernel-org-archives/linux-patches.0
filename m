Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB103B52E2;
	Tue, 21 Jul 2026 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668479; cv=none; b=hHdyelcejp85aQCkoiF5oLHoC5c2NGSGwRKV1s9mFsyylNqFwwyyujUdyFio2LihAp5lNXuWYXYoobf2+YJoY1smCYR/KOwDzSeKKS4s0KuyRR28QsZEJ+c7w7C0Og3KXhATjScfiF8cIu+k37tUsh7Arh6msjrtuTnoL7Cczgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668479; c=relaxed/simple;
	bh=hZQ8OMbnqyOcV0FZU5y7pWwFanV8E7byQ8BmQF8q0ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miSf8b75yLH7+hYNrmS/640h3MJAAt+mrYbHH6cHnouMNa5UQ9JvlEmo8bxfF7+ZVMEGusq1wXM6hSZuebwr+4eMEBgjSebxJUH+Do3Q1Ut1mimUvP9PiCHkJZusJSb95PBsjko6tKCGZ+NwDlWpIwUto0XDoP46aFMWwGGi7BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHFVE1jX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHFVE1jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C531F000E9;
	Tue, 21 Jul 2026 21:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668478;
	bh=oW7IfXINK6kg/ETCOuKR8QrLT4yEKQRaMbjjjWDkEdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHFVE1jXqX6pEoOBhPnRAHF1Neugx/4P7Ct782UMPL+jGRJXpsGoB7+qwktUiEDqO
	 0LKBYRJeirBo5tj/Tj+Rsjn9L+XK8O1UG7eb+6uOmX9h8w2jSKXH6Ie2ZZHdSSNH+y
	 0oDdBWgTQZ9GozJehw1bBWK5m+yM/mGpYs+Nejrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Igor Kotrasinski <i.kotrasinsk@samsung.com>,
	Sam Day <me@samcday.com>
Subject: [PATCH 6.1 0189/1067] usbip: vudc: fix NULL deref in vep_dequeue()
Date: Tue, 21 Jul 2026 17:13:10 +0200
Message-ID: <20260721152428.821924822@linuxfoundation.org>
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

From: Sam Day <me@samcday.com>

commit c5371e0b91b24159a3ebaa61e70b0980bcf03c0a upstream.

vep_alloc_request() wasn't initializing vrequest->udc, so cancellations
on the FunctionFS AIO path were arriving in vep_dequeue without a valid
UDC reference.

Since vrequest->udc is never actually properly used anywhere, we opt to
remove it, and update vep_dequeue to obtain a reference to the udc with
ep_to_vudc(), consistent with the other vep_ ops.

AFAICT this bug has existed for ~10 years. Seems that nobody has really
stressed the FunctionFS AIO path on usbip's vudc.

I tested this fix in a QEMU aarch64 guest driving FunctionFS endpoints
via AIO. Before the fix, running `usbip attach` from the host would
cause the guest to oops with the following backtrace:

Call trace:
 vep_dequeue+0x1c/0xe4 (P)
 usb_ep_dequeue+0x14/0x20
 ffs_aio_cancel+0x24/0x34
 __arm64_sys_io_cancel+0xb0/0x124
 do_el0_svc+0x68/0x100
 el0_svc+0x18/0x5c
 el0t_64_sync_handler+0x98/0xdc
 el0t_64_sync+0x154/0x158

Assisted-by: opencode:openai/gpt-5.5
Cc: stable <stable@kernel.org>
Fixes: b6a0ca111867 ("usbip: vudc: Add UDC specific ops")
Reviewed-by: Igor Kotrasinski <i.kotrasinsk@samsung.com>
Signed-off-by: Sam Day <me@samcday.com>
Link: https://patch.msgid.link/20260626-usbip-vudc-deque-fix-v3-1-98c2dc4d6a48@samcday.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc.h     |    1 -
 drivers/usb/usbip/vudc_dev.c |    4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/usbip/vudc.h
+++ b/drivers/usb/usbip/vudc.h
@@ -38,7 +38,6 @@ struct vep {
 
 struct vrequest {
 	struct usb_request req;
-	struct vudc *udc;
 	struct list_head req_entry; /* Request queue */
 };
 
--- a/drivers/usb/usbip/vudc_dev.c
+++ b/drivers/usb/usbip/vudc_dev.c
@@ -333,7 +333,6 @@ static int vep_queue(struct usb_ep *_ep,
 static int vep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 {
 	struct vep *ep;
-	struct vrequest *req;
 	struct vudc *udc;
 	struct vrequest *lst;
 	unsigned long flags;
@@ -343,8 +342,7 @@ static int vep_dequeue(struct usb_ep *_e
 		return ret;
 
 	ep = to_vep(_ep);
-	req = to_vrequest(_req);
-	udc = req->udc;
+	udc = ep_to_vudc(ep);
 
 	if (!udc->driver)
 		return -ESHUTDOWN;


