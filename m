Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D00D46D2DC;
	Mon, 31 Aug 2026 13:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184123; cv=none; b=Q7sa6IiRX7XPUrw27bhIPx5empuuF8ucCmtYr0kB4tQpDS6Z5UysVoCWyORwKpwBCzgkGP3z0sPPJrk57fxI1x3k6ujRF51X+LgOur+Z38I3QhOTbhDOdbG13Lce/NJobDTzet+y9v6iVyXMncL0sMddtC5l5FcjyVEjmW9DqAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184123; c=relaxed/simple;
	bh=54/mNDAJflKhvrOJbL0SfL8ShJPVcR6I6FunrmS32o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqbEv8e66hnNHxyLDsbhCt9sszM8NcjGoaNKMPJMxCqQHsp+alyy90CpArxgCsA1CDgmz4BTwZnrXqc0OpwEp3Niy5gbEBHYkqOFTdHM6Vi+0/I3co1HA4lOQI29AEXpWoqSU4DFbYgRoiRIW7CKnLcFL9Dq7TdEh/uB74cDCD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcv+24qn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcv+24qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DA21F000E9;
	Mon, 31 Aug 2026 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184122;
	bh=4wJrYG4jaqKe1q3vZynG5KkR0bt+cXLJ6qSWzMbel+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcv+24qnORsTQAUMdg79uXNBdLSnKsM+khc4awafqp1IsV5ipd6I5xiozBiSYT28I
	 rkX8sXTirU0b5Xit6p3KAxy1u122VghxNarYV7FM+lEdlp+vfI42TnHjOcW/SYlG+l
	 Kq7QHi1AGPSxrhRZic9jRBpVVkRAudjI9HM0EuVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 79/83] USB: serial: option: fix slab OOB read in interrupt URB callback
Date: Mon, 31 Aug 2026 15:34:55 +0200
Message-ID: <20260831133403.454551191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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
@@ -2690,12 +2690,26 @@ static void option_instat_callback(struc
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
 


