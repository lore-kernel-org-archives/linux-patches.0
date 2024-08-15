Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F412B1A76AB;
	Thu, 15 Aug 2024 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732852; cv=none; b=YBSZoZDEp1wZB8kOEnpLXGM9xPHwOOZM/iTv0tzcjPtMkh9UjIu3F40LWkvQcpH28WuHjVY1a4fY2yQNLRCJd81qgNtoV954XS0zWUyxUY6ClROf+4Sd3ZWAyikhbDnhWOWBcIQcBXFvNIHG3FLBM82BucSw5q9Tlc8wiZw/vgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732852; c=relaxed/simple;
	bh=J0mPdajvaiWwf1WUABRgdSxTqZJk4DEullL9jeaqqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK22Al6i6NIQE6XtluZ/wf2iC+hqWVN+UFCR01hZMApgvp90Z3U4C4voRJlW3B4+H8Wx81+2jwWgRGmD+7z2F5ZDnNv1OowNs9pgCw/ahD8SpGFl29tQX7XqLGNx7Zk50U1IUOxF9VbjPcVkX00Xzr8sLhUrf1e8HOpPTqhVGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWvCPMfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWvCPMfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD303C32786;
	Thu, 15 Aug 2024 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732851;
	bh=J0mPdajvaiWwf1WUABRgdSxTqZJk4DEullL9jeaqqzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWvCPMfpqy+hN3wjUjw/F/AICeyN6roHMb130pdMEghvoif4h6PJfPxnEhHnPwulO
	 mAoKNkMcfgMDVjdQPmyt7lmWrWodoC1ROleSnQ0NIrRw8DAS0T05YW4AUkVw3PU/pA
	 xUpvHRw6PnUexsnIFcc54/MVanFecHkJ4ktJK/Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 305/352] usb: vhci-hcd: Do not drop references before new references are gained
Date: Thu, 15 Aug 2024 15:26:11 +0200
Message-ID: <20240815131931.246255508@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit afdcfd3d6fcdeca2735ca8d994c5f2d24a368f0a upstream.

At a few places the driver carries stale pointers
to references that can still be used. Make sure that does not happen.
This strictly speaking closes ZDI-CAN-22273, though there may be
similar races in the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20240709113851.14691-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vhci_hcd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -745,6 +745,7 @@ static int vhci_urb_enqueue(struct usb_h
 	 *
 	 */
 	if (usb_pipedevice(urb->pipe) == 0) {
+		struct usb_device *old;
 		__u8 type = usb_pipetype(urb->pipe);
 		struct usb_ctrlrequest *ctrlreq =
 			(struct usb_ctrlrequest *) urb->setup_packet;
@@ -755,14 +756,15 @@ static int vhci_urb_enqueue(struct usb_h
 			goto no_need_xmit;
 		}
 
+		old = vdev->udev;
 		switch (ctrlreq->bRequest) {
 		case USB_REQ_SET_ADDRESS:
 			/* set_address may come when a device is reset */
 			dev_info(dev, "SetAddress Request (%d) to port %d\n",
 				 ctrlreq->wValue, vdev->rhport);
 
-			usb_put_dev(vdev->udev);
 			vdev->udev = usb_get_dev(urb->dev);
+			usb_put_dev(old);
 
 			spin_lock(&vdev->ud.lock);
 			vdev->ud.status = VDEV_ST_USED;
@@ -781,8 +783,8 @@ static int vhci_urb_enqueue(struct usb_h
 				usbip_dbg_vhci_hc(
 					"Not yet?:Get_Descriptor to device 0 (get max pipe size)\n");
 
-			usb_put_dev(vdev->udev);
 			vdev->udev = usb_get_dev(urb->dev);
+			usb_put_dev(old);
 			goto out;
 
 		default:
@@ -1095,6 +1097,7 @@ static void vhci_shutdown_connection(str
 static void vhci_device_reset(struct usbip_device *ud)
 {
 	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
+	struct usb_device *old = vdev->udev;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ud->lock, flags);
@@ -1102,8 +1105,8 @@ static void vhci_device_reset(struct usb
 	vdev->speed  = 0;
 	vdev->devid  = 0;
 
-	usb_put_dev(vdev->udev);
 	vdev->udev = NULL;
+	usb_put_dev(old);
 
 	if (ud->tcp_socket) {
 		sockfd_put(ud->tcp_socket);


