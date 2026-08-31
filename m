Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106E443E083;
	Mon, 31 Aug 2026 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184671; cv=none; b=fzrYyj2PHAEg3ur3C2340p0Csd08t7xKNZrOJB99xO3BKKGQ/2yZQqN1jj9OM0WhY9H8Npyp7OdwXO1QNjBxYtgR9lDm3HwellMI9trMOfuisUMASJx8XxHEkksOapl4YUi2FmyL23545bklLA+2OHQ8bkUQjcdSPHpmOTwQzRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184671; c=relaxed/simple;
	bh=C09lEy7nw6BHU576sG/FcwyY4JZvPks+nipnO1OPl9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhhGDGrGPlz4uKKIVHA7SZkpyYZQx5HD28mSDKZEtsAIb/UXqOw13Fc7sl/bXk97bawArMpskRfkiTpXLCzhICeKi4RcH2fgL4M+ZHlpHP3C4bFKm6nx/MnT+elNiJPJe1M4Lh/MImUg6De+E5ZWxTC2Q46wjZCemMi+Y4HWV+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xal+jxQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xal+jxQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5461F000E9;
	Mon, 31 Aug 2026 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184669;
	bh=QCHbH2B1oGg9bCdgazRAmqLCmVaB51yeQWRAAv4Lo4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xal+jxQuzXSCFOf3vUh0XoOeojN4AM7sHrE9fJfFlWt4xy/OEXGtOQ4aM0XBz9Pv2
	 6jl9Y87EJh89iocuWxMKZAcoJ7B3XeT6/BpmkhSEike63DWT8yGi3x3wn3gWRalDt3
	 bd59jNP6DHHWfh4n2f6GW5boyIW/Wsg1MHM1XrDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 88/91] USB: serial: option: fix slab OOB read in interrupt URB callback
Date: Mon, 31 Aug 2026 15:35:16 +0200
Message-ID: <20260831133404.036113012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 885d802f544ca7bfa8f3984d94233cce715bb6b3 upstream.

The interrupt URB buffer is allocated in setup_port_interrupt_in() based
on the endpoint's wMaxPacketSize:

    buffer_size = usb_endpoint_maxp(epd);
    port->interrupt_in_buffer = kmalloc(buffer_size, GFP_KERNEL);

When a USB device declares wMaxPacketSize = 8 on its interrupt IN
endpoint, the buffer is allocated from kmalloc-8 cache (exactly
8 bytes).

If the device sends a short packet (actual_length < wMaxPacketSize),
the URB completes with status == 0 and the callback proceeds to read:

    data[sizeof(struct usb_ctrlrequest)]

which evaluates to data[8], accessing 1 byte beyond the allocated 8-byte
buffer. This results in a slab out-of-bounds read.

Fix this by adding the missing bounds check: first verify that the
actual length is large enough to contain the struct usb_ctrlrequest
header before accessing req_pkt->bRequestType and req_pkt->bRequest,
and then verify that there is an additional byte for the modem signal
state before reading data[sizeof(struct usb_ctrlrequest)] inside the
conditional.  Use sizeof(*req_pkt) instead of sizeof(struct
usb_ctrlrequest) for consistency.

Assisted-by: Claude:deepseek-v4-pro
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Fixes: 58cfe9113e48 ("[PATCH] USB: add Option Card driver")
Cc: stable@vger.kernel.org	# v2.6.12
[ johan: use dev_err(); split signals declaration and initialisation ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2691,12 +2691,26 @@ static void option_instat_callback(struc
 			dev_dbg(dev, "%s: NULL req_pkt\n", __func__);
 			return;
 		}
+
+		if (urb->actual_length < sizeof(*req_pkt)) {
+			dev_err(dev, "%s: short packet: %u bytes\n", __func__,
+				urb->actual_length);
+			return;
+		}
+
 		if ((req_pkt->bRequestType == 0xA1) &&
 				(req_pkt->bRequest == 0x20)) {
+			unsigned char signals;
 			int old_dcd_state;
-			unsigned char signals = *((unsigned char *)
-					urb->transfer_buffer +
-					sizeof(struct usb_ctrlrequest));
+
+			if (urb->actual_length < sizeof(*req_pkt) + 1) {
+				dev_err(dev, "%s: short interrupt transfer: %u bytes\n",
+					__func__, urb->actual_length);
+				return;
+			}
+
+			signals = *((unsigned char *)urb->transfer_buffer +
+					sizeof(*req_pkt));
 
 			dev_dbg(dev, "%s: signal x%x\n", __func__, signals);
 


