Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F842FA624;
	Tue, 17 Jun 2025 16:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179482; cv=none; b=osY5DGTXtJqxvVnzEQBvAvtYCQCRmDTW5gnP7sZ9lN3thlpVE3N78JDxbH9bu+iKBcU9woEBJvwSnlzTP8MC3M0z3RcoofS6cP214OSj5F79ghouQHKbVQq/amT9lhneKXuKsdQiiS/xLBh0ek7X5oaAlVp8vQa1xWWxuVGaxoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179482; c=relaxed/simple;
	bh=Cb7UW8QeMh2gP/n3jjNdF6ickI0AuIYxywr5ASOWs8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEHQc4nOhcMUA3nwowxphnASexV/yTAmc8hKRxJYoTs6ybiw7KJmfIEDJT2bCuFYbEDkQj9/aRy5EWNRC/qSc2mjCMEOFpidhCAROP5RM/iUMRMneydYKt1PM5rTjPwz4UyL7lGnz9MvvGt8FZ2rnt7cA5HCKyOoS4xsK+eDfVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5LwGe+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5LwGe+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01378C4CEE3;
	Tue, 17 Jun 2025 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179482;
	bh=Cb7UW8QeMh2gP/n3jjNdF6ickI0AuIYxywr5ASOWs8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5LwGe+KLuJO+1VSsq5oV9hlgBThp9madFnWImZOonUvDH8lj/HOVjvK2nb5GlWLd
	 CkV7qPNcP+Hp8guyabzwi3GJr9KNLT8K5iHshtBHKj/8dw3QjyAHyOxRzBgnGTz389
	 bPyUiRdVFTB0TX91pRcBbFWuyFzO3CrcHl2SNGEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.15 759/780] usb: Flush altsetting 0 endpoints before reinitializating them after reset.
Date: Tue, 17 Jun 2025 17:27:47 +0200
Message-ID: <20250617152522.416315993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6133,6 +6133,7 @@ static int usb_reset_and_verify_device(s
 	struct usb_hub			*parent_hub;
 	struct usb_hcd			*hcd = bus_to_hcd(udev->bus);
 	struct usb_device_descriptor	descriptor;
+	struct usb_interface		*intf;
 	struct usb_host_bos		*bos;
 	int				i, j, ret = 0;
 	int				port1 = udev->portnum;
@@ -6190,6 +6191,18 @@ static int usb_reset_and_verify_device(s
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
@@ -6221,12 +6234,11 @@ static int usb_reset_and_verify_device(s
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


