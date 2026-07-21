Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309174266BF;
	Tue, 21 Jul 2026 21:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671187; cv=none; b=JKf8yYqj6kzIuoBPmW7OkqAJsMoqgbAlQoImY5akmS3ebagqB9SKK2kSvBL9CojnKHK8zjSB4lm94uaGIfJzQZy8SV/aP3ZZ1RpD6K4VU39XWIbGjDXsukmAaMzqtrbuccsBgai5MOFzZedGsc6Xe6ORIhN2jPR+13ON2FWFiWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671187; c=relaxed/simple;
	bh=pqwJUaqCAYh32ReXUDNltoKLyv7dStEn+0SGNBOqegg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lgserb29WuZzkczIjBhp2G0S32AgRNNS+JBHDPvJV7ydUL9z6k68WX+F/TrqK7NDiu4jX3gwkH6F65/hCqAsCG54L19fuvB9//eJxDqoEHM+TUDQjThb/C+cENFO2P+6gsJEfCfQfPsNVJaiBKoE1Lf2m/xGTlQN+k3x3QTcRB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhhllTtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhhllTtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380F51F000E9;
	Tue, 21 Jul 2026 21:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671185;
	bh=tlWjE6mDJay/49UadbbvKqoOjouy5G+T7WDV39ESmOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhhllTtlsEEbGk/VdpmPL3/NXx6K3vaoPBocvhirMHKnMnvshEiv8LlTTpVaFArVO
	 E/iz5SLr8M3tRFSma9oEO3nJW5HDMKbTvHQHhqeOMjhWZ3IdCWPTNZFB8NuRUlQZUV
	 mWaCgVMf1lYkKJffEHui5j/RPXU8AmqB0T165XkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Igor Kotrasinski <i.kotrasinsk@samsung.com>,
	Sam Day <me@samcday.com>
Subject: [PATCH 5.15 151/843] usbip: vudc: fix NULL deref in vep_dequeue()
Date: Tue, 21 Jul 2026 17:16:26 +0200
Message-ID: <20260721152409.411498548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


