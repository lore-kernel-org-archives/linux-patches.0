Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B32730C63B;
	Tue, 17 Mar 2026 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768237; cv=none; b=leJCECQk0K8Kk/syHRjHLC0FJpxNcaEa/Kg5KlStgqwuApnASDBo5qISfn54QzNrbG4NZmrTQ/V/sqtPYjfEKnkz9bykLkf1LbpO7MRcJzMEKjz2Y35Fn83ZQl2naEkwBHqGmHglsEVgBDgg1n5Uj6a47LrG3tRi9qgg7eVr98s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768237; c=relaxed/simple;
	bh=LaZLfIsAn3I6VbUGjyv0b2bvFkD1V8GdJqeAg2YTC9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrnN/c6PX/UxAbPs2rvbC/wnsZiIVhvzmwm/Y37vjepEQYM8FAMyxQMzZBpr2Yyx9QdRIR6wbOl79Dm/GWycuLeFVmOdTBEFdBnktOA6kZNlZ2ealIB6xK1wN5wRcuw+H+ZeiEu+kGFYcZxtleygqChH5mGJ9jQ8XsQVbeJRwac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAgqk2ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAgqk2ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6C2C19424;
	Tue, 17 Mar 2026 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768237;
	bh=LaZLfIsAn3I6VbUGjyv0b2bvFkD1V8GdJqeAg2YTC9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAgqk2ngwY2ICC2o+LgEvPyq3AhIUj002tjjW8HVXB7Z7LYDMCjfM1LM+XcUrI5aa
	 0jZrKzsWmpjvTXz9Uh10Wnylsy2lazja45dZ9Rh8QOnHrRjIWMyYErt7HO88DizVlW
	 bAGWkQE5wP3QGcy/HWTrXYaigzeSlvmHMzxUILaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koen Vandeputte <koen.vandeputte@citymesh.com>,
	Daniele Palmas <dnlplm@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 264/333] qmi_wwan: allow max_mtu above hard_mtu to control rx_urb_size
Date: Tue, 17 Mar 2026 17:34:53 +0100
Message-ID: <20260317163009.160800033@linuxfoundation.org>
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
@@ -1803,11 +1803,12 @@ usbnet_probe (struct usb_interface *udev
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
 		status = usbnet_get_endpoints (dev, udev);
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -130,6 +130,7 @@ struct driver_info {
 #define FLAG_MULTI_PACKET	0x2000
 #define FLAG_RX_ASSEMBLE	0x4000	/* rx packets may span >1 frames */
 #define FLAG_NOARP		0x8000	/* device can't do ARP */
+#define FLAG_NOMAXMTU		0x10000	/* allow max_mtu above hard_mtu */
 
 	/* init device ... can sleep, or cause probe() failure */
 	int	(*bind)(struct usbnet *, struct usb_interface *);


