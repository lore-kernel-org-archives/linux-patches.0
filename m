Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0984472531;
	Tue, 21 Jul 2026 20:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665296; cv=none; b=P/GSJ8hpmU2Tek4JjZvW9ZXen0HRdT9aOt9VdlGeZgCO43ZC5GpuqB2F8t5vYy1W3PwlTR2l0kFRxhju0tJ76DtA+Prt19IJB5+pOguqUitROW2rwxvgsr/e9cM74H5NTf7pup0J4iMCEevC0l15TnyN3MpW2hydeSJpRuDN8Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665296; c=relaxed/simple;
	bh=7cvjiMaLROYVWnPn5PQVYlZqB8pmKx+PvPOYKuJB+co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS7zCsRY+LBKMy28Scn3CljJHgJAuG1Z1Sc2qldFbTT+gM4cDaRKWMfOR/RksH7+dUMvDU8iAmXpbCyTGHYsz/pVPFpzv/yna4fUmcGJuQi5lbBG+4UjWW1JfJMiZQvBDS26fh77KCyD9bdZoh1DE7PG3wSgS28QF3s98gyCXDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLFhf4/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLFhf4/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B46E1F000E9;
	Tue, 21 Jul 2026 20:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665294;
	bh=8IppM5pqw6Ssr4w0mZZG8Eyk+7qEXEWz7k3qkN9YYtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLFhf4/yicsdra0flhAy91Byd1oVEQyEVZMUVX/kHia5H1fWDIg/uEQ678xhbe1f+
	 jf14Mdw6a0hpKMvlPL8T/tac+Z56cTGpBRXsLZ+3R89Fb24I6OK+0FZEZQgUaKQ45V
	 YV1j5WW3cLS1PkUTn7SXKP85x/3hFSQ4VcDcB6OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Igor Kotrasinski <i.kotrasinsk@samsung.com>,
	Sam Day <me@samcday.com>
Subject: [PATCH 6.6 0250/1266] usbip: vudc: fix NULL deref in vep_dequeue()
Date: Tue, 21 Jul 2026 17:11:27 +0200
Message-ID: <20260721152447.408378459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


