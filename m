Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292E14F7CD6;
	Thu, 17 Sep 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667671; cv=none; b=un+7lkp8OoblT1vqVgbGzFBZtQKWqV+X7yuD9YJbLWIoFFfPmwka5h2fFpydydxAe0ZnHVCVQmAT9MD/bW9S8g736WOC3A+rqlrHjdgJ0qoLwu+oKJReTZfcJVhbtrEkQ4EbFPHDqgEhwTUCntwOqw6xLOHw8Lt0tgCndw+3aGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667671; c=relaxed/simple;
	bh=d1eMeV2ZgeRgB0HWkLFg4bm+XHayTgQf+/2fkQ+kLGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpg6LZElzb/uac4e9pcglwBSMp1dhLvM9mjbw0f51dwZZDMRYvUY/PCsDfVqGt7G3iX8H3QZgCv5FmfQPXMPnkzgM4Q6STbZNU0I5klSes2a+xx5DooZlZMZn3MBmBv5ayL8fueQ1WGpqW+YdGO75byZeMGyVIRLXHCr265Z/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUS/gMF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUS/gMF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D591F000FF;
	Thu, 17 Sep 2026 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667669;
	bh=D5St37SOo4jOD/ai8vInkJUOMzHvixpmwxHOo4uZBTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUS/gMF3x0tcH64RbAk3vSRytRvANHRsnaEc8gLbRQYQ2OTRCGDnNjWhJx3/jkclN
	 hO7lZcMYsgT9lh+Cc+H6ZU3HTL1qRm7J5mQz0rFW4SSG1szpGu+a+WnVjAKLFSIZR1
	 Ij+oclYZM/AF+GEwqj9Ee8/TZM8ULkuof9ZDywPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0132/1102] usb: core: hcd: fix possible deadlock in rh control transfers
Date: Thu, 17 Sep 2026 16:01:15 +0100
Message-ID: <20260917151542.834349918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 01d0362b9abf8..78f4d7d3cf0eb 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -450,7 +450,8 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 
 
 /* Root hub control transfers execute synchronously */
-static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
+static int rh_call_control(struct usb_hcd *hcd,
+		struct urb *urb, gfp_t mem_flags)
 {
 	struct usb_ctrlrequest *cmd;
 	u16		typeReq, wValue, wIndex, wLength;
@@ -485,8 +486,8 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
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
@@ -811,12 +812,13 @@ static int rh_queue_status (struct usb_hcd *hcd, struct urb *urb)
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
 
@@ -1524,7 +1526,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	 */
 
 	if (is_root_hub(urb->dev)) {
-		status = rh_urb_enqueue(hcd, urb);
+		status = rh_urb_enqueue(hcd, urb, mem_flags);
 	} else {
 		status = map_urb_for_dma(hcd, urb, mem_flags);
 		if (likely(status == 0)) {
-- 
2.53.0



