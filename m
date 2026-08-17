Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FDA33B6F4;
	Mon, 17 Aug 2026 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977592; cv=none; b=deE6kcvqHNCJatXVbLG4qYPC/NJY55nuZRmgWtlpvy/deYdekpJl4Gq2LZ7FIwBm2Rl84E2d8/KWOsG3crXkf1crK+Xs54eRqPG2Vp+qeR65pfD2A/7y9UhAmSJG7exLrT3hoAuAaf6VhOBHhKywRoN3prlMxNIP5RKRDpH34KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977592; c=relaxed/simple;
	bh=rSr1fzp70s4sSJQXZ5FtXNAWiYtbetzuwqfGA3Nk8AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkDHQxqlZ7mEfcPdvPV+8VhrIzBB3XOrlR2P48rxefGpzVSnpYG2qEWw1FAD7nxJCGbeSVSVP2zqKaQJr2ped9DXc9Stoe8zyx1BCZRx9CO06Qo3myiS4tceDyioDmOuhyANQ85RsJCYM08GhmJmZM/ZnogPfTRNXMKCyxAdOJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpkxhZmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpkxhZmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0D71F000E9;
	Mon, 17 Aug 2026 14:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977591;
	bh=wK5T5nLynVZ8x+b2/k3zLS2MyhL1SHr8s8lENbV+XBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpkxhZmh2U/8UVNKvucS4+d1gsuoJr1MkrX+YDoIqGwsl4zjJfSdtVAYEpqvjCM90
	 5BBUYvtPE1D5gPBKQyKfYggTIQhK++OveOBtZRn4PgD/kMdKVsgR2YSYBcf7VOdmHR
	 8bHHmoL6ZMXRGUOGIsbzJS3neSItfyjdc685WGRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 355/456] can: peak_usb: validate uCAN receive record lengths
Date: Mon, 17 Aug 2026 15:32:25 +0200
Message-ID: <20260817132553.419516229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
 				     dev->can.ctrlmode);
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
@@ -650,6 +657,24 @@ static void pcan_usb_fd_decode_ts(struct
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
@@ -664,6 +689,12 @@ static int pcan_usb_fd_decode_buf(struct
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
@@ -675,12 +706,19 @@ static int pcan_usb_fd_decode_buf(struct
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


