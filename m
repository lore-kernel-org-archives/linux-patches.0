Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFEA2EE29C;
	Tue, 17 Jun 2025 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178409; cv=none; b=V+jfMORRnHMtvmdeLgAxFhjENYPgh3XU77m73gK9LaLZQyrruE2CC42pFX5nO8gxJJ0C3wUqMFD6+TO48XNBULNYsSV9/9lHn+5OIYizqnRDpqiJOWnBsJirrI6xoQLo/j7ndWon5y5hzkvelI57xs9CNtIGn1aW/CE7Vk9yzlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178409; c=relaxed/simple;
	bh=fFllyGyEGgdcNRL87FJ5AV4el3eQjhoqYUP2nla+ZVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOSOVPtEYGNbA5T8/HoIC89Xm3s8/APuYX0O4MLiOhWHcvsX+kYy80kf32rR+KLyEhZPb0iisn2HIaYT7qyHcqlRZ6o6vk9GQCEWSttrHFoFbLk8Tl7qp6XfGdLR/Ywt383EI9Du1cMn7BMdkVLqcrIE6VRIi4YsAFlSGrRRzy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tN1yfCyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tN1yfCyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A25AC4CEE3;
	Tue, 17 Jun 2025 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178409;
	bh=fFllyGyEGgdcNRL87FJ5AV4el3eQjhoqYUP2nla+ZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tN1yfCyjHQy1o3SJX3Y1emilPDHrpVYP9c7CG7/1fkf9GpGSvKEsFXmhf66OPRQZy
	 YxzRjsG7giPeGmXmHB+CQux+1qRgVuYp5JYauA/779CDgFF2NPXuOVfUims3Tw239j
	 kWevfneeSW0ZVMRBcq/m+LntAJWqQ6/iBm4FQzJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 495/512] usb: Flush altsetting 0 endpoints before reinitializating them after reset.
Date: Tue, 17 Jun 2025 17:27:41 +0200
Message-ID: <20250617152439.684524109@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 89bb3dc13ac29a563f4e4c555e422882f64742bd upstream.

usb core avoids sending a Set-Interface altsetting 0 request after device
reset, and instead relies on calling usb_disable_interface() and
usb_enable_interface() to flush and reset host-side of those endpoints.

xHCI hosts allocate and set up endpoint ring buffers and host_ep->hcpriv
during usb_hcd_alloc_bandwidth() callback, which in this case is called
before flushing the endpoint in usb_disable_interface().

Call usb_disable_interface() before usb_hcd_alloc_bandwidth() to ensure
URBs are flushed before new ring buffers for the endpoints are allocated.

Otherwise host driver will attempt to find and remove old stale URBs
from a freshly allocated new ringbuffer.

Cc: stable <stable@kernel.org>
Fixes: 4fe0387afa89 ("USB: don't send Set-Interface after reset")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250514132520.225345-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -6135,6 +6135,7 @@ static int usb_reset_and_verify_device(s
 	struct usb_hub			*parent_hub;
 	struct usb_hcd			*hcd = bus_to_hcd(udev->bus);
 	struct usb_device_descriptor	descriptor;
+	struct usb_interface		*intf;
 	struct usb_host_bos		*bos;
 	int				i, j, ret = 0;
 	int				port1 = udev->portnum;
@@ -6192,6 +6193,18 @@ static int usb_reset_and_verify_device(s
 	if (!udev->actconfig)
 		goto done;
 
+	/*
+	 * Some devices can't handle setting default altsetting 0 with a
+	 * Set-Interface request. Disable host-side endpoints of those
+	 * interfaces here. Enable and reset them back after host has set
+	 * its internal endpoint structures during usb_hcd_alloc_bandwith()
+	 */
+	for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
+		intf = udev->actconfig->interface[i];
+		if (intf->cur_altsetting->desc.bAlternateSetting == 0)
+			usb_disable_interface(udev, intf, true);
+	}
+
 	mutex_lock(hcd->bandwidth_mutex);
 	ret = usb_hcd_alloc_bandwidth(udev, udev->actconfig, NULL, NULL);
 	if (ret < 0) {
@@ -6223,12 +6236,11 @@ static int usb_reset_and_verify_device(s
 	 */
 	for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
 		struct usb_host_config *config = udev->actconfig;
-		struct usb_interface *intf = config->interface[i];
 		struct usb_interface_descriptor *desc;
 
+		intf = config->interface[i];
 		desc = &intf->cur_altsetting->desc;
 		if (desc->bAlternateSetting == 0) {
-			usb_disable_interface(udev, intf, true);
 			usb_enable_interface(udev, intf, true);
 			ret = 0;
 		} else {


