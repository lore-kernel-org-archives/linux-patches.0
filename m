Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F0D14389F;
	Tue, 23 Apr 2024 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908649; cv=none; b=c4f8wKunxEUDYzqeyzZEPlJFz54eQUQDJQnk2hZHaYDGtkWbJqEENwfK65qfRoD6qUSJJcQSxyj4Xc8pzNKM4wrCSUsM8KF8TFRCP1clx8lPpffJLvG25N3Lg/M4e0GziorbcM6PkkgmDzvrNC71tFmSxgyEq48l5f7WfwTvnJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908649; c=relaxed/simple;
	bh=LVVq99EWinDeS7H4FNPeTppxNvhdpEuPz0V4WXVUfF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ey+WhP5BgH7Kplz5ewyM3fduNLKrL6aPr1lw8/gdWVmnlFBf1VchwcAbNdBlzpFPh7ASxKM/OQOOX9rYGEt15QqLdaPyAaJsWmKF5Fc/uLCxAML2ILZzWAHQkmErvZqsi2TPcFjC6PnB/B2onI9mHn6BXS8GZDfKW+ZBgZxre18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2H6+df7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2H6+df7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39E3C32781;
	Tue, 23 Apr 2024 21:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908648;
	bh=LVVq99EWinDeS7H4FNPeTppxNvhdpEuPz0V4WXVUfF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2H6+df7UamryrFdqE08kknJjEUStCpaePOGu+RRzn2Nr3iR5iapy/V/cziwoSTc4l
	 rSZ8ZxsBCOPMfg6juPdqlG9oBShLzYuWkPItQgvrT8Kc7zBVFpF/K3X1ZRGVJcwo0Z
	 EaEIASZtHmq5vlVl7VaOMCOxlGZ+RQ7ufIvA8XXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	syzbot+5f29dc6a889fc42bd896@syzkaller.appspotmail.com
Subject: [PATCH 6.6 108/158] comedi: vmk80xx: fix incomplete endpoint checking
Date: Tue, 23 Apr 2024 14:39:05 -0700
Message-ID: <20240423213859.260995725@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit d1718530e3f640b7d5f0050e725216eab57a85d8 upstream.

While vmk80xx does have endpoint checking implemented, some things
can fall through the cracks. Depending on the hardware model,
URBs can have either bulk or interrupt type, and current version
of vmk80xx_find_usb_endpoints() function does not take that fully
into account. While this warning does not seem to be too harmful,
at the very least it will crash systems with 'panic_on_warn' set on
them.

Fix the issue found by Syzkaller [1] by somewhat simplifying the
endpoint checking process with usb_find_common_endpoints() and
ensuring that only expected endpoint types are present.

This patch has not been tested on real hardware.

[1] Syzkaller report:
usb 1-1: BOGUS urb xfer, pipe 1 != type 3
WARNING: CPU: 0 PID: 781 at drivers/usb/core/urb.c:504 usb_submit_urb+0xc4e/0x18c0 drivers/usb/core/urb.c:503
...
Call Trace:
 <TASK>
 usb_start_wait_urb+0x113/0x520 drivers/usb/core/message.c:59
 vmk80xx_reset_device drivers/comedi/drivers/vmk80xx.c:227 [inline]
 vmk80xx_auto_attach+0xa1c/0x1a40 drivers/comedi/drivers/vmk80xx.c:818
 comedi_auto_config+0x238/0x380 drivers/comedi/drivers.c:1067
 usb_probe_interface+0x5cd/0xb00 drivers/usb/core/driver.c:399
...

Similar issue also found by Syzkaller:
Link: https://syzkaller.appspot.com/bug?extid=5205eb2f17de3e01946e

Reported-and-tested-by: syzbot+5f29dc6a889fc42bd896@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Fixes: 49253d542cc0 ("staging: comedi: vmk80xx: factor out usb endpoint detection")
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20240408171633.31649-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/vmk80xx.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -641,33 +641,22 @@ static int vmk80xx_find_usb_endpoints(st
 	struct vmk80xx_private *devpriv = dev->private;
 	struct usb_interface *intf = comedi_to_usb_interface(dev);
 	struct usb_host_interface *iface_desc = intf->cur_altsetting;
-	struct usb_endpoint_descriptor *ep_desc;
-	int i;
+	struct usb_endpoint_descriptor *ep_rx_desc, *ep_tx_desc;
+	int ret;
 
-	if (iface_desc->desc.bNumEndpoints != 2)
-		return -ENODEV;
-
-	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
-		ep_desc = &iface_desc->endpoint[i].desc;
-
-		if (usb_endpoint_is_int_in(ep_desc) ||
-		    usb_endpoint_is_bulk_in(ep_desc)) {
-			if (!devpriv->ep_rx)
-				devpriv->ep_rx = ep_desc;
-			continue;
-		}
+	if (devpriv->model == VMK8061_MODEL)
+		ret = usb_find_common_endpoints(iface_desc, &ep_rx_desc,
+						&ep_tx_desc, NULL, NULL);
+	else
+		ret = usb_find_common_endpoints(iface_desc, NULL, NULL,
+						&ep_rx_desc, &ep_tx_desc);
 
-		if (usb_endpoint_is_int_out(ep_desc) ||
-		    usb_endpoint_is_bulk_out(ep_desc)) {
-			if (!devpriv->ep_tx)
-				devpriv->ep_tx = ep_desc;
-			continue;
-		}
-	}
-
-	if (!devpriv->ep_rx || !devpriv->ep_tx)
+	if (ret)
 		return -ENODEV;
 
+	devpriv->ep_rx = ep_rx_desc;
+	devpriv->ep_tx = ep_tx_desc;
+
 	if (!usb_endpoint_maxp(devpriv->ep_rx) || !usb_endpoint_maxp(devpriv->ep_tx))
 		return -EINVAL;
 


