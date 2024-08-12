Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78515183CA6;
	Mon, 12 Aug 2024 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479536; cv=none; b=gc+XASrma9q6JKsA90uE2YmUYQhHpLxhJ2SbLVR/nkaO0//elQgGWkVhwD++KvJ9DpNUGC2v46DmJhNWhrXjEL92nxbmw+rziR5Vm1TtK9cBRtZ23HTwB4qEBxkVHYwIHFooxf6N7TapBLzBf2SwmrxwvQwHfh0q6vvm9BpblNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479536; c=relaxed/simple;
	bh=gKnC748HM8tdPffBhy6Ivf/XuTtyqIhod1X87Qjk80c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh9l/V9XHctkopz//sWv6wr4Eox1GorpXOSeXYiljXJxsV+0fDXjpnb8QxmW5qlvuSkOsDBr7ORpKgStIe561nO333PGHrXWRTlzHvESX2wITV5KXIp/VFj662jdFgovAu4tj9SCOv+gfZFLDGTeeteMmFIQxi+PuRwyDQm9iGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0lTGP70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0lTGP70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47D0C4AF0C;
	Mon, 12 Aug 2024 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479536;
	bh=gKnC748HM8tdPffBhy6Ivf/XuTtyqIhod1X87Qjk80c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0lTGP70CEk6T+khifB0i5TFASA55lYeYr6t5jdF1KEWS2W+15IuXWWBTg6gSOgRM
	 xzMmgOsmAzRqpzVmsIpGmJ8ctQbuTqTLlfG1MKHjAJn+CSs9HhIZDBh7Njgcj6TOQ5
	 aDnUyZGc+pnPd2dIxRqHsqy7gJ67qmcf4E9mNQZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 117/189] usb: vhci-hcd: Do not drop references before new references are gained
Date: Mon, 12 Aug 2024 18:02:53 +0200
Message-ID: <20240812160136.640960144@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1067,6 +1069,7 @@ static void vhci_shutdown_connection(str
 static void vhci_device_reset(struct usbip_device *ud)
 {
 	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
+	struct usb_device *old = vdev->udev;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ud->lock, flags);
@@ -1074,8 +1077,8 @@ static void vhci_device_reset(struct usb
 	vdev->speed  = 0;
 	vdev->devid  = 0;
 
-	usb_put_dev(vdev->udev);
 	vdev->udev = NULL;
+	usb_put_dev(old);
 
 	if (ud->tcp_socket) {
 		sockfd_put(ud->tcp_socket);


