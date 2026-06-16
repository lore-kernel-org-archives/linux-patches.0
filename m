Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C61B472798;
	Tue, 16 Jun 2026 18:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634468; cv=none; b=o/g89XnsKxiNkL+X6tjUuTpXh1Qazu+B8+IC3+5V3tIRCAjDf0doNBsJ8D5P9K8Q+nwFiMwzxr1g9l4g9fmhd8T7OwwAn1chzEYPI3X7LyX4wmuFZyeGDT4ejrH7NExws9Are2a1vKIy3TumCP0RCqc4OY4cDrkXs1viHsyZE3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634468; c=relaxed/simple;
	bh=sMMRicNprOYQVZxmgfpJR22jZO2yQrS1hmOAcsxkbyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj8sv11yg8aZvrVzbKuYabsleEssUjm83TbMJkX3rH8Oqsp8kanAFPxUSCoS5f0THOvJ2YDBHXafAHYhK2lsWz/vrKoaRkZfceP344ynUHaDkqlT7NBkQ37GzA35NZRPwFCdY+eqqkXrEZgvrPpDhZcCBEjsONaVDgGxmGKUezU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Idb+92l2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Idb+92l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAEB1F000E9;
	Tue, 16 Jun 2026 18:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634467;
	bh=GHCCIVOquscRcExfJa6mbtMdYqvbi4e7ZD9ZZdCT09U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Idb+92l2/96GNbEajxpH0WCEUvB3gDRHNaNyXX1YlNYwLkrsT3ZtrROMoEUzDlVQa
	 IYisl5QeUge2xWrMU8nbHYc7xuAgw9QTiQywAqgl/rrtnrYI1SsY03GnoeRHqrQZla
	 K9GRXcHVQlCr5z+9NEBPDHJgCJbQI4YcAZdVC1pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/411] media: rc: igorplugusb: heed coherency rules
Date: Tue, 16 Jun 2026 20:28:29 +0530
Message-ID: <20260616145115.508137821@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit eac69475b01fe1e861dfe3960b57fa95671c132e ]

In a control request, the USB request structure
can be subject to DMA on some HCs. Hence it must obey
the rules for DMA coherency. Allocate it separately.

Fixes: b1c97193c6437 ("[media] rc: port IgorPlug-USB to rc-core")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ replaced kzalloc_obj() with kzalloc(sizeof(*ir->request), GFP_KERNEL) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/igorplugusb.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
 #include <media/rc-core.h>
@@ -34,7 +35,7 @@ struct igorplugusb {
 	struct device *dev;
 
 	struct urb *urb;
-	struct usb_ctrlrequest request;
+	struct usb_ctrlrequest *request;
 
 	struct timer_list timer;
 
@@ -123,7 +124,7 @@ static void igorplugusb_cmd(struct igorp
 {
 	int ret;
 
-	ir->request.bRequest = cmd;
+	ir->request->bRequest = cmd;
 	ir->urb->transfer_flags = 0;
 	ret = usb_submit_urb(ir->urb, GFP_ATOMIC);
 	if (ret)
@@ -165,13 +166,17 @@ static int igorplugusb_probe(struct usb_
 	if (!ir)
 		return -ENOMEM;
 
+	ir->request = kzalloc(sizeof(*ir->request), GFP_KERNEL);
+	if (!ir->request)
+		goto fail;
+
 	ir->dev = &intf->dev;
 
 	timer_setup(&ir->timer, igorplugusb_timer, 0);
 
-	ir->request.bRequest = GET_INFRACODE;
-	ir->request.bRequestType = USB_TYPE_VENDOR | USB_DIR_IN;
-	ir->request.wLength = cpu_to_le16(sizeof(ir->buf_in));
+	ir->request->bRequest = GET_INFRACODE;
+	ir->request->bRequestType = USB_TYPE_VENDOR | USB_DIR_IN;
+	ir->request->wLength = cpu_to_le16(sizeof(ir->buf_in));
 
 	ir->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!ir->urb)
@@ -223,6 +228,7 @@ fail:
 	rc_free_device(ir->rc);
 	usb_free_urb(ir->urb);
 	del_timer(&ir->timer);
+	kfree(ir->request);
 
 	return ret;
 }
@@ -236,6 +242,7 @@ static void igorplugusb_disconnect(struc
 	usb_set_intfdata(intf, NULL);
 	usb_kill_urb(ir->urb);
 	usb_free_urb(ir->urb);
+	kfree(ir->request);
 }
 
 static const struct usb_device_id igorplugusb_table[] = {


