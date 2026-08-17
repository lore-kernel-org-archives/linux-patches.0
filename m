Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0215FA81;
	Mon, 17 Aug 2026 14:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976217; cv=none; b=Hv9Pb8DJL/bhD4BiYAa318EYXQhUFPI9Rev6zKQXGP1BbMpnix2Z6eGuwK8NiE1BMqkRPXpRm0uNxH7MQw9x58wQpHeHEcHUTejDJzYmKZ8KnKxykUH11p5SvjU4FNgcQIDg0oKY0ZCU2caFCzOHPeQDcjtb3CSQ+Z9jtOxuxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976217; c=relaxed/simple;
	bh=J3+VotPSzcuGRlUXEbjZySiLJwJ33xEcKmqzoDr/CeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPtO5oLUNKY8grHLF3epLvI4y2LPQD+mB/7qT0CXicoEzlQ2VKrgYx5ItZAE8dco4ERhZ3OhcKF8WHZfe6chXO72zBdZYdIu+isypo8dx1fjXXSB24xvgpISdZwES8XzmFHbgtgUOJaLvglR0Cc9eCcxAGty/3JuY1JgdLAge4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGTnEkgR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGTnEkgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7531F1F000E9;
	Mon, 17 Aug 2026 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976216;
	bh=mNQB+l+GUJ89PfoZE4k1Th1B99bFeNQewz8xpGIWbe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGTnEkgR9Hm6szT7AyA6P0OwtPDEH5z1FvAN8bVAYcUXVOTgOynf/6RZpXZh6E/rw
	 Ld8oC4ohXrW4EdS2WCjoQu3AWIoysytR/VbcTrg6CGfxb0wtytzjy+alKTWnYKK2Dd
	 eRm5+i/KBYeDNaouLeHZz6GW5/8X0zLdcO8wqIP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 297/389] can: peak_usb: validate uCAN receive record lengths
Date: Mon, 17 Aug 2026 15:32:16 +0200
Message-ID: <20260817132550.659376120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 93fcab2c6968446316bbb49548848df604d6346f upstream.

pcan_usb_fd_decode_buf() walks uCAN records packed in one USB
receive buffer.

Require each record to contain the fixed header for its type, and verify
CAN payload bytes before copying them into the skb.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706092836.79754-1-pengpeng@iscas.ac.cn
Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c |   40 ++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -502,6 +502,13 @@ static int pcan_usb_fd_decode_canmsg(str
 		cfd->len = get_can_dlc(pucan_msg_get_dlc(rm));
 	}
 
+	if (!(rx_msg_flags & PUCAN_MSG_RTR) &&
+	    le16_to_cpu(rx_msg->size) - offsetof(struct pucan_rx_msg, d) <
+	    cfd->len) {
+		kfree_skb(skb);
+		return -EBADMSG;
+	}
+
 	cfd->can_id = le32_to_cpu(rm->can_id);
 
 	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
@@ -651,6 +658,24 @@ static void pcan_usb_fd_decode_ts(struct
 		peak_usb_set_ts_now(&usb_if->time_ref, le32_to_cpu(ts->ts_low));
 }
 
+static size_t pcan_usb_fd_rx_msg_min_size(u16 rx_msg_type)
+{
+	switch (rx_msg_type) {
+	case PUCAN_MSG_CAN_RX:
+		return offsetof(struct pucan_rx_msg, d);
+	case PCAN_UFD_MSG_CALIBRATION:
+		return sizeof(struct pcan_ufd_ts_msg);
+	case PUCAN_MSG_ERROR:
+		return sizeof(struct pucan_error_msg);
+	case PUCAN_MSG_STATUS:
+		return sizeof(struct pucan_status_msg);
+	case PCAN_UFD_MSG_OVERRUN:
+		return sizeof(struct pcan_ufd_ovr_msg);
+	default:
+		return sizeof(struct pucan_msg);
+	}
+}
+
 /* callback for bulk IN urb */
 static int pcan_usb_fd_decode_buf(struct peak_usb_device *dev, struct urb *urb)
 {
@@ -665,6 +690,12 @@ static int pcan_usb_fd_decode_buf(struct
 	msg_end = urb->transfer_buffer + urb->actual_length;
 	for (; msg_ptr < msg_end;) {
 		u16 rx_msg_type, rx_msg_size;
+		size_t rx_msg_min_size;
+
+		if (msg_end - msg_ptr < sizeof(*rx_msg)) {
+			err = -EBADMSG;
+			break;
+		}
 
 		rx_msg = (struct pucan_msg *)msg_ptr;
 		if (!rx_msg->size) {
@@ -676,12 +707,19 @@ static int pcan_usb_fd_decode_buf(struct
 		rx_msg_type = le16_to_cpu(rx_msg->type);
 
 		/* check if the record goes out of current packet */
-		if (msg_ptr + rx_msg_size > msg_end) {
+		if (rx_msg_size > msg_end - msg_ptr) {
 			netdev_err(netdev,
 				   "got frag rec: should inc usb rx buf sze\n");
 			err = -EBADMSG;
 			break;
 		}
+
+		rx_msg_min_size = pcan_usb_fd_rx_msg_min_size(rx_msg_type);
+		if (rx_msg_size < rx_msg_min_size) {
+			netdev_err(netdev, "got short rec\n");
+			err = -EBADMSG;
+			break;
+		}
 
 		switch (rx_msg_type) {
 		case PUCAN_MSG_CAN_RX:


