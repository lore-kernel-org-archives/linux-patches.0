Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB1544AB9F;
	Tue, 21 Jul 2026 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673316; cv=none; b=KsmMP2HMOCVqKhOFP53B6d6vYBX4DgNwdVv3iRGuIvuqD09omtEWudCsKM01FRByAiIqv3GOoMEyb+yiNg8unU0gi4axP8AcsyIoh7xuuxXUf2hBOXhXDVmgf/u1OtvKocigYJ2MEYUQaLtemKDY+TtsjXz1jyVHTNKqFkD+nzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673316; c=relaxed/simple;
	bh=ujBD8LIo277slxGl604Dqu8TOAzEvMBu7U1EYJl72Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9TfZ90FGmtZHcsayVjE85CPc+SYKKPWZ9seqNyaK70zcrhFd3tIdujcCphGOQdqAEffnWHFRc2YVhyUljG5PRRQCcIOIEFh79G26grATL9kTSKrjxiVoLW84lRT2bQXnTNRTbDSJeLg5uJi7KW3154y8k9d34zOnHQKKX3h7ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBFl/ygG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBFl/ygG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF9B1F000E9;
	Tue, 21 Jul 2026 22:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673314;
	bh=i7R4iCiHFucvMUKc8vclFhuIE+wNVnwk5gP5+NSYkYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBFl/ygGgxFiqsZRDcwUm8BNIqMFZd3cqtelGuTF0u+XHCer8e7m36IHDUWmh3hFM
	 Gx3UlTjMyCfuAhqPnIBqXbV1ngAo3RWMTsVVjhwpKW7A5pDSvFzBmBlftsHhNfbJg9
	 ajpZpPMU9t467djDIgpkhEvfbMYWTqpLxBjmvwu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Igor Kotrasinski <i.kotrasinsk@samsung.com>,
	Sam Day <me@samcday.com>
Subject: [PATCH 5.10 115/699] usbip: vudc: fix NULL deref in vep_dequeue()
Date: Tue, 21 Jul 2026 17:17:54 +0200
Message-ID: <20260721152358.300788647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


