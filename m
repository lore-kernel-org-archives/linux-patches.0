Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E3A4F7CCF;
	Wed, 30 Sep 2026 15:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782468; cv=none; b=e/fS8FPo0WbIjboDeqpZXFgx+r0YbR/Xy6hORMfUj9622sKQJh8+pY38aTA5pFdPitCLJh8HTOE5u81WcPKgUzsJb5yh0TPLJDEL+a2QRuf+Y5lF73Ipq6jo6IuywXfTf0wJPYB95ZCf42qMms0yw+tbmKHFRkA4Wo4DYeevOhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782468; c=relaxed/simple;
	bh=V7dtYKZVdWcsuuwCuhkT0Q5sSoGUqJqYvIqYzasvJKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApXoKoMxu8Fo7jA5TJGubY6Hz8tu9d5SHMYdBnslUlQl8G4145MgM9zsxuvh6d316HnQgJ/+oIatSMySDahZ54e61rneaL16kkzh4LJ4vqNsOCriOL6xoDV6dOiQEE8EAv5QhV6KVtfDyLliuNSr95M0KbQUYwJy7WCVNNEpGiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMPxejFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMPxejFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234961F000FF;
	Wed, 30 Sep 2026 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782453;
	bh=IzxPV793UJLc5W2Rk5e5r4A2F4pmRYDEVwBeOrOWHHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMPxejFv9h2deCRwwUd79UrD3Ad3P4zZzobW7cMjBiPSvbRwMA14sveTPsIeG+2qt
	 NQgq4lGllBXUfPKHUCr8294LM26W0shSZ2KuwlS9uiR/F4ndRQ6/HZ3Om7y4F9YKDX
	 KhMak3dPDhE1UhWsh9tACtfRYRKDK3PhCMY+ZrLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/595] usb: core: hcd: fix possible deadlock in rh control transfers
Date: Wed, 30 Sep 2026 17:19:04 +0200
Message-ID: <20260930152348.828724739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit d5559f43d76b398392b26a15cbc16d731969cd1c ]

>From within the SCSI error handler memory allocations must not
trigger IO. Handling errors in UAS and the storage driver may
involve resetting a device. The thread doing the reset itself
relies on VM magic. However, that is insufficient, as resetting
a device involves resuming it. Resumption as well as resetting
involves conrol transfers to the parent of the device to be reset.
That may be a root hub. Hence usbcore must heed the flags passed
to usb_submit_urb() processing control transfers to root hubs.

The problem exist since the storage driver has been merged.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260429094413.181038-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 0e54f6f183486..eb0de366fb034 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -473,7 +473,8 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 
 
 /* Root hub control transfers execute synchronously */
-static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
+static int rh_call_control(struct usb_hcd *hcd,
+		struct urb *urb, gfp_t mem_flags)
 {
 	struct usb_ctrlrequest *cmd;
 	u16		typeReq, wValue, wIndex, wLength;
@@ -508,8 +509,8 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 	 * tbuf should be at least as big as the
 	 * USB hub descriptor.
 	 */
-	tbuf_size =  max_t(u16, sizeof(struct usb_hub_descriptor), wLength);
-	tbuf = kzalloc(tbuf_size, GFP_KERNEL);
+	tbuf_size = max_t(u16, sizeof(struct usb_hub_descriptor), wLength);
+	tbuf = kzalloc(tbuf_size, mem_flags);
 	if (!tbuf) {
 		status = -ENOMEM;
 		goto err_alloc;
@@ -839,12 +840,13 @@ static int rh_queue_status (struct usb_hcd *hcd, struct urb *urb)
 	return retval;
 }
 
-static int rh_urb_enqueue (struct usb_hcd *hcd, struct urb *urb)
+static int rh_urb_enqueue(struct usb_hcd *hcd,
+		struct urb *urb, gfp_t mem_flags)
 {
 	if (usb_endpoint_xfer_int(&urb->ep->desc))
 		return rh_queue_status (hcd, urb);
 	if (usb_endpoint_xfer_control(&urb->ep->desc))
-		return rh_call_control (hcd, urb);
+		return rh_call_control(hcd, urb, mem_flags);
 	return -EINVAL;
 }
 
@@ -1549,7 +1551,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	 */
 
 	if (is_root_hub(urb->dev)) {
-		status = rh_urb_enqueue(hcd, urb);
+		status = rh_urb_enqueue(hcd, urb, mem_flags);
 	} else {
 		status = map_urb_for_dma(hcd, urb, mem_flags);
 		if (likely(status == 0)) {
-- 
2.53.0



