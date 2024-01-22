Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E141612D1;
	Tue, 23 Jan 2024 01:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974939; cv=none; b=DZS9CgAvmHK/0Kk6T4ta/KTXjyoGQ17CSK0nZviOn9FF2a7EnUrrd1kkQO/tNsE4gpLryUuLXJjWh6w+wkcmo9w53kxDRIkUSxT8zz3eaPqgkEgbvHLAUj0KqCi/hSVAbFW3Co6d71mY2jWqXIyz4gZ+ZotpaKvNvydMSYzwO24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974939; c=relaxed/simple;
	bh=MBsEtvfINL8f1UJpgVT/NSXVnhqfVZtumOnQSr0WP/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jA+8GSZN6kbZ6Sy8BGTxbqLHkrns7da8yrtU8aEPbxCpPmiGNXVT62Z8XRjkWZc8Nj/zCCLPuAusBKoTC6HmLKxPZEo1OcE5sJRSslgN7C6T3AKf1BO8DJS2syKWgOtgC020oKP7rcV08A+1X4o33issdo9c7Q0h7QNQvQzPiv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2v9gs5s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2v9gs5s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ADBC433C7;
	Tue, 23 Jan 2024 01:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974939;
	bh=MBsEtvfINL8f1UJpgVT/NSXVnhqfVZtumOnQSr0WP/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2v9gs5s3ZY03/sgTzboKvSZ39nPFlwSwjf38PrbbFVtRJAwtbZS8SelBe2RqHxv4Z
	 cMd/I80rRsU9ULU1xm6wfIdo9oNgsnnhMWFWzZpBBv7zDYVaNm9ylPBo2WdpEhJKEH
	 SjpJ4ysVJ/pLk8g4Ar2zD4EhZNsPpNcXd5iQDeSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 5.15 259/374] usb: cdns3: fix iso transfer error when mult is not zero
Date: Mon, 22 Jan 2024 15:58:35 -0800
Message-ID: <20240122235753.778544292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 92f02efa1d86d7dcaef7f38a5fe3396c4e88a93c upstream.

ISO basic transfer is
	ITP(SOF) Package_0 Package_1 ... Package_n

CDNS3 DMA start dma transfer from memmory to internal FIFO when get SOF,
controller will transfer data to usb bus from internal FIFO when get IN
token.

According USB spec defination:
	Maximum number of packets = (bMaxBurst + 1) * (Mult + 1)

Internal memory should be the same as (bMaxBurst + 1) * (Mult + 1). DMA
don't fetch data advance when ISO transfer, so only reserve
(bMaxBurst + 1) * (Mult + 1) internal memory for ISO transfer.

Need save Mult and bMaxBurst information and set it into EP_CFG register,
otherwise only 1 package is sent by controller, other package will be
lost.

Cc:  <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231224153816.1664687-3-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |   59 +++++++++++++++++++++++----------------
 drivers/usb/cdns3/cdns3-gadget.h |    3 +
 2 files changed, 39 insertions(+), 23 deletions(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2062,11 +2062,10 @@ int cdns3_ep_config(struct cdns3_endpoin
 	bool is_iso_ep = (priv_ep->type == USB_ENDPOINT_XFER_ISOC);
 	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
 	u32 bEndpointAddress = priv_ep->num | priv_ep->dir;
-	u32 max_packet_size = 0;
-	u8 maxburst = 0;
+	u32 max_packet_size = priv_ep->wMaxPacketSize;
+	u8 maxburst = priv_ep->bMaxBurst;
 	u32 ep_cfg = 0;
 	u8 buffering;
-	u8 mult = 0;
 	int ret;
 
 	buffering = priv_dev->ep_buf_size - 1;
@@ -2088,8 +2087,7 @@ int cdns3_ep_config(struct cdns3_endpoin
 		break;
 	default:
 		ep_cfg = EP_CFG_EPTYPE(USB_ENDPOINT_XFER_ISOC);
-		mult = priv_dev->ep_iso_burst - 1;
-		buffering = mult + 1;
+		buffering = (priv_ep->bMaxBurst + 1) * (priv_ep->mult + 1) - 1;
 	}
 
 	switch (priv_dev->gadget.speed) {
@@ -2100,17 +2098,8 @@ int cdns3_ep_config(struct cdns3_endpoin
 		max_packet_size = is_iso_ep ? 1024 : 512;
 		break;
 	case USB_SPEED_SUPER:
-		/* It's limitation that driver assumes in driver. */
-		mult = 0;
-		max_packet_size = 1024;
-		if (priv_ep->type == USB_ENDPOINT_XFER_ISOC) {
-			maxburst = priv_dev->ep_iso_burst - 1;
-			buffering = (mult + 1) *
-				    (maxburst + 1);
-
-			if (priv_ep->interval > 1)
-				buffering++;
-		} else {
+		if (priv_ep->type != USB_ENDPOINT_XFER_ISOC) {
+			max_packet_size = 1024;
 			maxburst = priv_dev->ep_buf_size - 1;
 		}
 		break;
@@ -2139,7 +2128,6 @@ int cdns3_ep_config(struct cdns3_endpoin
 	if (priv_dev->dev_ver < DEV_VER_V2)
 		priv_ep->trb_burst_size = 16;
 
-	mult = min_t(u8, mult, EP_CFG_MULT_MAX);
 	buffering = min_t(u8, buffering, EP_CFG_BUFFERING_MAX);
 	maxburst = min_t(u8, maxburst, EP_CFG_MAXBURST_MAX);
 
@@ -2173,7 +2161,7 @@ int cdns3_ep_config(struct cdns3_endpoin
 	}
 
 	ep_cfg |= EP_CFG_MAXPKTSIZE(max_packet_size) |
-		  EP_CFG_MULT(mult) |
+		  EP_CFG_MULT(priv_ep->mult) |			/* must match EP setting */
 		  EP_CFG_BUFFERING(buffering) |
 		  EP_CFG_MAXBURST(maxburst);
 
@@ -2263,6 +2251,13 @@ usb_ep *cdns3_gadget_match_ep(struct usb
 	priv_ep->type = usb_endpoint_type(desc);
 	priv_ep->flags |= EP_CLAIMED;
 	priv_ep->interval = desc->bInterval ? BIT(desc->bInterval - 1) : 0;
+	priv_ep->wMaxPacketSize =  usb_endpoint_maxp(desc);
+	priv_ep->mult = USB_EP_MAXP_MULT(priv_ep->wMaxPacketSize);
+	priv_ep->wMaxPacketSize &= USB_ENDPOINT_MAXP_MASK;
+	if (priv_ep->type == USB_ENDPOINT_XFER_ISOC && comp_desc) {
+		priv_ep->mult =  USB_SS_MULT(comp_desc->bmAttributes) - 1;
+		priv_ep->bMaxBurst = comp_desc->bMaxBurst;
+	}
 
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
 	return &priv_ep->endpoint;
@@ -3044,22 +3039,40 @@ static int cdns3_gadget_check_config(str
 	struct cdns3_endpoint *priv_ep;
 	struct usb_ep *ep;
 	int n_in = 0;
+	int iso = 0;
+	int out = 1;
 	int total;
+	int n;
 
 	list_for_each_entry(ep, &gadget->ep_list, ep_list) {
 		priv_ep = ep_to_cdns3_ep(ep);
-		if ((priv_ep->flags & EP_CLAIMED) && (ep->address & USB_DIR_IN))
-			n_in++;
+		if (!(priv_ep->flags & EP_CLAIMED))
+			continue;
+
+		n = (priv_ep->mult + 1) * (priv_ep->bMaxBurst + 1);
+		if (ep->address & USB_DIR_IN) {
+			/*
+			 * ISO transfer: DMA start move data when get ISO, only transfer
+			 * data as min(TD size, iso). No benefit for allocate bigger
+			 * internal memory than 'iso'.
+			 */
+			if (priv_ep->type == USB_ENDPOINT_XFER_ISOC)
+				iso += n;
+			else
+				n_in++;
+		} else {
+			if (priv_ep->type == USB_ENDPOINT_XFER_ISOC)
+				out = max_t(int, out, n);
+		}
 	}
 
 	/* 2KB are reserved for EP0, 1KB for out*/
-	total = 2 + n_in + 1;
+	total = 2 + n_in + out + iso;
 
 	if (total > priv_dev->onchip_buffers)
 		return -ENOMEM;
 
-	priv_dev->ep_buf_size = priv_dev->ep_iso_burst =
-			(priv_dev->onchip_buffers - 2) / (n_in + 1);
+	priv_dev->ep_buf_size = (priv_dev->onchip_buffers - 2 - iso) / (n_in + out);
 
 	return 0;
 }
--- a/drivers/usb/cdns3/cdns3-gadget.h
+++ b/drivers/usb/cdns3/cdns3-gadget.h
@@ -1168,6 +1168,9 @@ struct cdns3_endpoint {
 	u8			dir;
 	u8			num;
 	u8			type;
+	u8			mult;
+	u8			bMaxBurst;
+	u16			wMaxPacketSize;
 	int			interval;
 
 	int			free_trbs;


