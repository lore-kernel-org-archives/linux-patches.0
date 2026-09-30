Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C08F3D9DBF;
	Wed, 30 Sep 2026 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794110; cv=none; b=aapOj+SK7wES82+MhQ5jUbkf3/CSAa7jSgf0b8AE5NEBa8Ujrxw4eeyj+d+H2c8LNiM5hfMUeuG+mLU1LZ1By7VeVNF2pIa0OlnsWw7Cm4I08i6JCFkApu7ijizgNCv3mpPN0+6e56LMkbmLWospqA3C18tvgyar1I1BmXNsLA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794110; c=relaxed/simple;
	bh=7/KYYYubisFPX0GcOrTF4Jji5585Z/+XepYBdeWIyp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4QA+RLVPiHKGQkt/AFMGUaubFMVIuF2wr/hg5rd2Hs6LG/RivKz4rx4xnbh+tQCuAzvySmDWqiRJYGn9bWAFVacmFYn4QOivPw7rL+/H7bge3D6F0D5oPz+It4wVFulUopx1okFHb4Wqp4MHGLHQK5Qb0WE6xeXGYRgixVQ+1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hD1DbsKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hD1DbsKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BA71F000FF;
	Wed, 30 Sep 2026 18:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794109;
	bh=biGAJGs+gWf6RtRyrP2j8BW++ndVE7JugWFnEWJiWrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hD1DbsKF+8RDUr0roC1KyCX0Nd9rICWWtBaLLYob0DNRCRsuDm6YpTdGeaZCfrtzo
	 d4oFab012s82C3P4JjFOUDa6DCzMFREoRfsuOOTG/2NFB0T/JKLCjrlpxxkguYrrih
	 lC+E4M2+zlzFWOFUufDPN+Ml1sXEstINPStPglI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0093/1193] usb: core: hcd: fix possible deadlock in rh control transfers
Date: Wed, 30 Sep 2026 17:12:57 +0200
Message-ID: <20260930152436.307709290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 884391a30ad4b..47bc0980baf10 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -452,7 +452,8 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 
 
 /* Root hub control transfers execute synchronously */
-static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
+static int rh_call_control(struct usb_hcd *hcd,
+		struct urb *urb, gfp_t mem_flags)
 {
 	struct usb_ctrlrequest *cmd;
 	u16		typeReq, wValue, wIndex, wLength;
@@ -487,8 +488,8 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
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
@@ -813,12 +814,13 @@ static int rh_queue_status (struct usb_hcd *hcd, struct urb *urb)
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
 
@@ -1526,7 +1528,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	 */
 
 	if (is_root_hub(urb->dev)) {
-		status = rh_urb_enqueue(hcd, urb);
+		status = rh_urb_enqueue(hcd, urb, mem_flags);
 	} else {
 		status = map_urb_for_dma(hcd, urb, mem_flags);
 		if (likely(status == 0)) {
-- 
2.53.0



