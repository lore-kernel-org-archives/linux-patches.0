Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF2E3F23B3;
	Tue, 17 Mar 2026 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766757; cv=none; b=pYB6NpAn9zV9C/ebVfgiFTGJNtScfBkUcZ5q6GF6YkGa4JNxL3EbEH5gFh0ui4QQ7q9HSbK7ncF9VRBxDBGhZ5c3jWn/wo9s8WDLCjrmc7URIZQ9BAFBKJcHTRcOtmC/qJ52XQWpubYaLhUV0h9Jt9aHIzXL70DJrc1tL+bnYQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766757; c=relaxed/simple;
	bh=GzuUF3fo4JHBL4PQ7Swhx90oUp+HnHBzKWdRoF9daO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZouWXTN64EVVlnHc2ntELKnJNJmTDwTXHFkSj/pP8iqrxlF6nDSVB098ce4CVEj0ep2+mFeLlm5iVCXLX3yMig7eBgGl+6mBtKSELGu60i0ytX+bTTKXPQl7354pWvbVJVNL9Z5/K9ZZ3yDO2Ie5KDt9+3vhhej7LL5wiKBHiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J43ZBR1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J43ZBR1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DC8C2BC86;
	Tue, 17 Mar 2026 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766757;
	bh=GzuUF3fo4JHBL4PQ7Swhx90oUp+HnHBzKWdRoF9daO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J43ZBR1NZTXqvHy5uwuBdr9HBjL5GGrOkJbux2H0HQMFeuUrXPtdQmAGqSs6zNDbU
	 L/xzh4FpszdittbxX/4XvkS9bbdW70sp8S50QxA5ZIPciasremWEgG02ZjSTJlsbDq
	 yp8KkE1eReoyigVhLCkz7Bjuf8hQIaivL5Wg4iZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koen Vandeputte <koen.vandeputte@citymesh.com>,
	Daniele Palmas <dnlplm@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 315/378] qmi_wwan: allow max_mtu above hard_mtu to control rx_urb_size
Date: Tue, 17 Mar 2026 17:34:32 +0100
Message-ID: <20260317163018.582300507@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Vivier <lvivier@redhat.com>

commit 55f854dd5bdd8e19b936a00ef1f8d776ac32c7b0 upstream.

Commit c7159e960f14 ("usbnet: limit max_mtu based on device's hard_mtu")
capped net->max_mtu to the device's hard_mtu in usbnet_probe(). While
this correctly prevents oversized packets on standard USB network
devices, it breaks the qmi_wwan driver.

qmi_wwan relies on userspace (e.g. ModemManager) setting a large MTU on
the wwan0 interface to configure rx_urb_size via usbnet_change_mtu().
QMI modems negotiate USB transfer sizes of 16,383 or 32,767 bytes, and
the USB receive buffers must be sized accordingly. With max_mtu capped
to hard_mtu (~1500 bytes), userspace can no longer raise the MTU, the
receive buffers remain small, and download speeds drop from >300 Mbps
to ~0.8 Mbps.

Introduce a FLAG_NOMAXMTU driver flag that allows individual usbnet
drivers to opt out of the max_mtu cap. Set this flag in qmi_wwan's
driver_info structures to restore the previous behavior for QMI devices,
while keeping the safety fix in place for all other usbnet drivers.

Fixes: c7159e960f14 ("usbnet: limit max_mtu based on device's hard_mtu")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/CAPh3n803k8JcBPV5qEzUB-oKzWkAs-D5CU7z=Vd_nLRCr5ZqQg@mail.gmail.com/
Reported-by: Koen Vandeputte <koen.vandeputte@citymesh.com>
Tested-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://patch.msgid.link/20260304134338.1785002-1-lvivier@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    4 ++--
 drivers/net/usb/usbnet.c   |    7 ++++---
 include/linux/usb/usbnet.h |    1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -928,7 +928,7 @@ err:
 
 static const struct driver_info	qmi_wwan_info = {
 	.description	= "WWAN/QMI device",
-	.flags		= FLAG_WWAN | FLAG_SEND_ZLP,
+	.flags		= FLAG_WWAN | FLAG_NOMAXMTU | FLAG_SEND_ZLP,
 	.bind		= qmi_wwan_bind,
 	.unbind		= qmi_wwan_unbind,
 	.manage_power	= qmi_wwan_manage_power,
@@ -937,7 +937,7 @@ static const struct driver_info	qmi_wwan
 
 static const struct driver_info	qmi_wwan_info_quirk_dtr = {
 	.description	= "WWAN/QMI device",
-	.flags		= FLAG_WWAN | FLAG_SEND_ZLP,
+	.flags		= FLAG_WWAN | FLAG_NOMAXMTU | FLAG_SEND_ZLP,
 	.bind		= qmi_wwan_bind,
 	.unbind		= qmi_wwan_unbind,
 	.manage_power	= qmi_wwan_manage_power,
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1821,11 +1821,12 @@ usbnet_probe(struct usb_interface *udev,
 		if ((dev->driver_info->flags & FLAG_NOARP) != 0)
 			net->flags |= IFF_NOARP;
 
-		if (net->max_mtu > (dev->hard_mtu - net->hard_header_len))
+		if ((dev->driver_info->flags & FLAG_NOMAXMTU) == 0 &&
+		    net->max_mtu > (dev->hard_mtu - net->hard_header_len))
 			net->max_mtu = dev->hard_mtu - net->hard_header_len;
 
-		if (net->mtu > net->max_mtu)
-			net->mtu = net->max_mtu;
+		if (net->mtu > (dev->hard_mtu - net->hard_header_len))
+			net->mtu = dev->hard_mtu - net->hard_header_len;
 
 	} else if (!info->in || !info->out)
 		status = usbnet_get_endpoints(dev, udev);
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -132,6 +132,7 @@ struct driver_info {
 #define FLAG_MULTI_PACKET	0x2000
 #define FLAG_RX_ASSEMBLE	0x4000	/* rx packets may span >1 frames */
 #define FLAG_NOARP		0x8000	/* device can't do ARP */
+#define FLAG_NOMAXMTU		0x10000	/* allow max_mtu above hard_mtu */
 
 	/* init device ... can sleep, or cause probe() failure */
 	int	(*bind)(struct usbnet *, struct usb_interface *);


