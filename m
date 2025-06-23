Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8364409;
	Mon, 23 Jun 2025 22:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716103; cv=none; b=QLeqWQDPm7HuH7vWpLzgXsrM8Ay4tgbsB0VPncGzDavqeoEcCWBuN0/iTQD7OPW4eJ/uSPugIQ7spN4qGb0UKXLpcyEdNA75dr8oWJhIriF9xQxNyARqF/YZJB59ACoVnlPlqfSxbJB0XNHQmcy7FdUbo4+A31zMIe/qjpv5jLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716103; c=relaxed/simple;
	bh=ZkywCTHGu5bj0hMkA8h9n61NU9B8yLPD5iBErB6vsmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWSl84a/9+BnHaDqO8MCRpqoAAst07CoBlyx4D+V44r/vWXgsadJdYkoU/Hv3TonW3YRTyZH8iumurrK5nw7kbYmyJAp1J1Z+zIcFBMk6obGUJWlAUBqgLngjZkG+IT2kmX+omgpxTSpjsyMDWlH6kabnZ1MF3MjCi1I6+8pl28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBLcWlAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBLcWlAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93B0C4CEEA;
	Mon, 23 Jun 2025 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716103;
	bh=ZkywCTHGu5bj0hMkA8h9n61NU9B8yLPD5iBErB6vsmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBLcWlAWbPx8AQiXX5jlypoLIBl3BRU5rNCrTN54heXNMzFOS5LBW60lh5nKCp8Pe
	 yzprxDzo+WieixTWYQTDAqFi6TOD9LGkbRw4AxxQ2ftOX/q2nLpBGZxEqWoF4CszVB
	 r380acprFx4saRNDFBt26ByRCMUhcOoiZR/8ivAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 280/508] usb: Flush altsetting 0 endpoints before reinitializating them after reset.
Date: Mon, 23 Jun 2025 15:05:25 +0200
Message-ID: <20250623130652.146698593@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6087,6 +6087,7 @@ static int usb_reset_and_verify_device(s
 	struct usb_hub			*parent_hub;
 	struct usb_hcd			*hcd = bus_to_hcd(udev->bus);
 	struct usb_device_descriptor	descriptor;
+	struct usb_interface		*intf;
 	struct usb_host_bos		*bos;
 	int				i, j, ret = 0;
 	int				port1 = udev->portnum;
@@ -6140,6 +6141,18 @@ static int usb_reset_and_verify_device(s
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
@@ -6171,12 +6184,11 @@ static int usb_reset_and_verify_device(s
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


