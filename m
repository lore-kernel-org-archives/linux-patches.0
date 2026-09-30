Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D7330BF70;
	Wed, 30 Sep 2026 16:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784344; cv=none; b=Sks1Hf52Bza+dP8Eybju8afgTRdVeP9MkBmVjBJ+feez/gOxVdH4mLKdHQ5PZWAXE8C7Gi71tNhurSFSHw/3dy1iv/qGSc9ITQ49adeCwLEMz21RESgAJ9icgFdRaXSSdGsLrx96LZgv0/IouAyiygFIPZWv9fXfmpVRDjxB22E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784344; c=relaxed/simple;
	bh=TUSlaFug/U0sz9JJwDw+7pZvEGSRAIispAU1L/BH7tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEppsJfGKM0XM1MCxlAfEvZy8ZdzUMNzuh15ldZkEJo35Y7n63kU+zTXpMGEGVca0LEsFJLwCg1rW5OcvKXU6UCnlhyY/QELoOsG80/bRL7/HpJt5YI87PcMMmX2NO/lwxaMCak5CVnovdz0lAyo3WHo35J42q2Zd8yNLAEKhPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp2PnxUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp2PnxUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345371F00893;
	Wed, 30 Sep 2026 16:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784340;
	bh=L8Z3ha5tiJLsFD4lsHCFOI8mtcIH3MFeW0lX/bRjT64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yp2PnxUITAfxQKi/sPRSSIi/TAYHILH4/rguz8WgFio0hsFkq9c++OYB5BZRd0x+C
	 f7pQbXo3M1Dq00rffCvGRxM1f1MwxsM0qT1GLK3DKYWS8c72DjVRahhKoismNjfAFR
	 xWlDpAdzdbNTmmCwE8M254N0YwPNaPo+LJu6Nohc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/982] usb: core: hcd: fix possible deadlock in rh control transfers
Date: Wed, 30 Sep 2026 17:13:33 +0200
Message-ID: <20260930152418.461102074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 980e09f793a6a..f0a637dab11f9 100644
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
@@ -838,12 +839,13 @@ static int rh_queue_status (struct usb_hcd *hcd, struct urb *urb)
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
 
@@ -1551,7 +1553,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	 */
 
 	if (is_root_hub(urb->dev)) {
-		status = rh_urb_enqueue(hcd, urb);
+		status = rh_urb_enqueue(hcd, urb, mem_flags);
 	} else {
 		status = map_urb_for_dma(hcd, urb, mem_flags);
 		if (likely(status == 0)) {
-- 
2.53.0



