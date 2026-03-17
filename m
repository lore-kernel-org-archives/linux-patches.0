Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D46C372B38;
	Tue, 17 Mar 2026 17:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768230; cv=none; b=TONGbNdqy8z8Mh+J267wJpSOwLXAR2D1Wrebzk7wlz1dLruMSgQ2i0MsKSIQxKYh5p6roGDjchKIm4MPKR0rSib3fj72yfr2QXQt3QSCvE2mOGmhVJsb3MLt5pHrT/vnDcW5w5H5TNxz6ryQNAZGLNqMLBmg7HqNoXYc1AyvWyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768230; c=relaxed/simple;
	bh=o8+34pHCM8Ew+po/wFPG2ejsnax8fLErSMBZr+PXqtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyrK94QEVea6QxwPtbpqratG7pc9pKPoI7c3GDRYjZCJ5oLY7rsauke+WGAUMazaoFParXVRg8pnZm1fE+5wWpMTnJ2lXjekTBLQcOoYgNqtpsjGmUN4AdcR5iLAekqjo4TwlTuBWMCHHRFbsUkORvg/J8g6mizz/Tb+cryiILY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X17iKAal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X17iKAal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F023C4CEF7;
	Tue, 17 Mar 2026 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768229;
	bh=o8+34pHCM8Ew+po/wFPG2ejsnax8fLErSMBZr+PXqtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X17iKAalFyWb2VY8slqATMXemgJWIMPg95Qpt7GlflKCoBGxPLjF/rTJKPXqevrCg
	 nTq8X1FgBvJZRobe1J08ckaWLXoeKAOLcYaY4IYMM+4hwxCA0V9L+1rby38i0OqGvp
	 UWy8HfU00fpRU5AvA6dzVb4GYX48CWf0NbPxzkBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 245/333] net: mctp: fix device leak on probe failure
Date: Tue, 17 Mar 2026 17:34:34 +0100
Message-ID: <20260317163008.450773491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 224a0d284c3caf1951302d1744a714784febed71 upstream.

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

This driver takes a reference to the USB device during probe but does
not to release it on probe failures.

Drop the redundant device reference to fix the leak, reduce cargo
culting, make it easier to spot drivers where an extra reference is
needed, and reduce the risk of further memory leaks.

Fixes: 0791c0327a6e ("net: mctp: Add MCTP USB transport driver")
Cc: stable@vger.kernel.org	# 6.15
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20260305104549.16110-1-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mctp/mctp-usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/mctp/mctp-usb.c
+++ b/drivers/net/mctp/mctp-usb.c
@@ -329,7 +329,7 @@ static int mctp_usb_probe(struct usb_int
 	SET_NETDEV_DEV(netdev, &intf->dev);
 	dev = netdev_priv(netdev);
 	dev->netdev = netdev;
-	dev->usbdev = usb_get_dev(interface_to_usbdev(intf));
+	dev->usbdev = interface_to_usbdev(intf);
 	dev->intf = intf;
 	usb_set_intfdata(intf, dev);
 
@@ -365,7 +365,6 @@ static void mctp_usb_disconnect(struct u
 	mctp_unregister_netdev(dev->netdev);
 	usb_free_urb(dev->tx_urb);
 	usb_free_urb(dev->rx_urb);
-	usb_put_dev(dev->usbdev);
 	free_netdev(dev->netdev);
 }
 


