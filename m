Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A04134FF65;
	Wed,  3 Dec 2025 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778808; cv=none; b=BL6MWhVY1cbFb+Su3P10Rl2+0MKHayaEfrfTAKfOP+O2DeKJu8Uh83O+ByCh4qj+u2hOexKheIgn5CInVFcpIYoudHjOjUWpl5PIKfZvjfZua9D7cpom1CR1Bfkre9D03e4lYVPRcmF1mKPfpaLM8ADhQCNBUEaV//eSldji6mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778808; c=relaxed/simple;
	bh=zzPVokjFD9/YHZsQCRyd2MSyUtNQfS4Y65WIOiVEWX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiWkZAmTN74EFNYrjwgIA2A06ddxARMYmbhPfWe9SEZWaeXzgCMfs2kjFhxZ1KQT6RmpDBij92VNmWBqQ7oJB16ArQmhS0c46me3A8u+irn62uQQXZQknjJqt3A6pTJf8+ffcpPtrHVi2MVY6eJULV34+rOKWo3zJ6VTLLPK/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9q5FJjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9q5FJjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281C2C116B1;
	Wed,  3 Dec 2025 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778807;
	bh=zzPVokjFD9/YHZsQCRyd2MSyUtNQfS4Y65WIOiVEWX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9q5FJjjUWnM9sGnFIAYBDKLC/TQcJz+YuY6Xc8I5n18OZGnNQAzPYzfCCgPe2fLk
	 Gu9nfMe33zpxmjOA5ZmfaPDaJ2JzYFKdQxM643v1x43drowgz0fQ1rWssPGNVqwZcV
	 zaVAhBOtvc2/9jW3/ICI/7VPrNj9bb+DX7QB4xek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runcheng Lu <runcheng.lu@hpmicro.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Celeste Liu <uwu@coelacanthus.name>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 064/568] can: gs_usb: increase max interface to U8_MAX
Date: Wed,  3 Dec 2025 16:21:06 +0100
Message-ID: <20251203152443.047465538@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Celeste Liu <uwu@coelacanthus.name>

commit 2a27f6a8fb5722223d526843040f747e9b0e8060 upstream

This issue was found by Runcheng Lu when develop HSCanT USB to CAN FD
converter[1]. The original developers may have only 3 interfaces
device to test so they write 3 here and wait for future change.

During the HSCanT development, we actually used 4 interfaces, so the
limitation of 3 is not enough now. But just increase one is not
future-proofed. Since the channel index type in gs_host_frame is u8,
just make canch[] become a flexible array with a u8 index, so it
naturally constraint by U8_MAX and avoid statically allocate 256
pointer for every gs_usb device.

[1]: https://github.com/cherry-embedded/HSCanT-hardware

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Reported-by: Runcheng Lu <runcheng.lu@hpmicro.com>
Cc: stable@vger.kernel.org
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Celeste Liu <uwu@coelacanthus.name>
Link: https://patch.msgid.link/20250930-gs-usb-max-if-v5-1-863330bf6666@coelacanthus.name
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -277,10 +277,6 @@ struct gs_host_frame {
 #define GS_MAX_TX_URBS 10
 /* Only launch a max of GS_MAX_RX_URBS usb requests at a time. */
 #define GS_MAX_RX_URBS 30
-/* Maximum number of interfaces the driver supports per device.
- * Current hardware only supports 3 interfaces. The future may vary.
- */
-#define GS_MAX_INTF 3
 
 struct gs_tx_context {
 	struct gs_can *dev;
@@ -318,14 +314,15 @@ struct gs_can {
 
 /* usb interface struct */
 struct gs_usb {
-	struct gs_can *canch[GS_MAX_INTF];
 	struct usb_anchor rx_submitted;
 	struct usb_device *udev;
 	unsigned int hf_size_rx;
 	u8 active_channels;
+	u8 channel_cnt;
 
 	unsigned int pipe_in;
 	unsigned int pipe_out;
+	struct gs_can *canch[];
 };
 
 /* 'allocate' a tx context.
@@ -550,7 +547,7 @@ static void gs_usb_receive_bulk_callback
 	}
 
 	/* device reports out of range channel id */
-	if (hf->channel >= GS_MAX_INTF)
+	if (hf->channel >= parent->channel_cnt)
 		goto device_detach;
 
 	dev = parent->canch[hf->channel];
@@ -653,7 +650,7 @@ resubmit_urb:
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
 device_detach:
-		for (rc = 0; rc < GS_MAX_INTF; rc++) {
+		for (rc = 0; rc < parent->channel_cnt; rc++) {
 			if (parent->canch[rc])
 				netif_device_detach(parent->canch[rc]->netdev);
 		}
@@ -1374,17 +1371,19 @@ static int gs_usb_probe(struct usb_inter
 	icount = dconf.icount + 1;
 	dev_info(&intf->dev, "Configuring for %u interfaces\n", icount);
 
-	if (icount > GS_MAX_INTF) {
+	if (icount > type_max(typeof(parent->channel_cnt))) {
 		dev_err(&intf->dev,
 			"Driver cannot handle more that %u CAN interfaces\n",
-			GS_MAX_INTF);
+			type_max(typeof(parent->channel_cnt)));
 		return -EINVAL;
 	}
 
-	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	parent = kzalloc(struct_size(parent, canch, icount), GFP_KERNEL);
 	if (!parent)
 		return -ENOMEM;
 
+	parent->channel_cnt = icount;
+
 	init_usb_anchor(&parent->rx_submitted);
 
 	usb_set_intfdata(intf, parent);
@@ -1445,7 +1444,7 @@ static void gs_usb_disconnect(struct usb
 		return;
 	}
 
-	for (i = 0; i < GS_MAX_INTF; i++)
+	for (i = 0; i < parent->channel_cnt; i++)
 		if (parent->canch[i])
 			gs_destroy_candev(parent->canch[i]);
 


