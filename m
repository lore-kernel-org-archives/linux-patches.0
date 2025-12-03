Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E138F327215;
	Wed,  3 Dec 2025 15:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776948; cv=none; b=DATQjB/nD51VSTPpRproZ3XHPaimp2r3B00tNittNCQxedb7+yzrjclbvbraOpOJyO7b/QZMxrPhQLfd8VfBnZ26E1bJIwFPntvtZLoyKhT3thJ0PhcefeZyUXIVEEBqeeuhTdAMuMN7obRK3Urf96exlmdFuTb6kfaNU+vxEAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776948; c=relaxed/simple;
	bh=3p2N1RHPp6CZjwnMH7VR44c54fqCtjPmLqBoxhgdZPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mrke/K/EEw7wffd0KtUTJ1ca7zde/lKc2EsMf5bB2OdAve8qo7VG2xMgi7hGh9nIAFuhbkuVEyyhyiSt8rMXkUg1pP06oliHDZ6NPfeMnV6em5bmRiaBmehIFBfetJP99XhVhgJn4joKjD71OHTkwhoBlWuh9TK2yXRUacoZEec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hhri77FM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hhri77FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA0EC116B1;
	Wed,  3 Dec 2025 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776947;
	bh=3p2N1RHPp6CZjwnMH7VR44c54fqCtjPmLqBoxhgdZPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hhri77FMnGPNaZrsShl7nS2k8hv4jZwoEltErql7/gEC++FHDKpjkMVgBPsd+bTcQ
	 ks1fAmogPDldevNuere+ApyNaz14XaUoaLFjj+x6Nx+UC2svpMZVewReP7feqDl//2
	 O6zWoB4oh7CyXt8aPyc2TYuiaGFGkDAbNXefwjmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 004/146] can: gs_usb: gs_usb_receive_bulk_callback(): check actual_length before accessing data
Date: Wed,  3 Dec 2025 16:26:22 +0100
Message-ID: <20251203152346.624609168@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 395d988f93861101ec89d0dd9e3b876ae9392a5b ]

The URB received in gs_usb_receive_bulk_callback() contains a struct
gs_host_frame. The length of the data after the header depends on the
gs_host_frame hf::flags and the active device features (e.g. time
stamping).

Introduce a new function gs_usb_get_minimum_length() and check that we have
at least received the required amount of data before accessing it. Only
copy the data to that skb that has actually been received.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://patch.msgid.link/20251114-gs_usb-fix-usb-callbacks-v1-3-a29b42eacada@pengutronix.de
[mkl: rename gs_usb_get_minimum_length() -> +gs_usb_get_minimum_rx_length()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 59 +++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 51f8d694104d9..8d8a610f91441 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -261,6 +261,11 @@ struct canfd_quirk {
 	u8 quirk;
 } __packed;
 
+/* struct gs_host_frame::echo_id == GS_HOST_FRAME_ECHO_ID_RX indicates
+ * a regular RX'ed CAN frame
+ */
+#define GS_HOST_FRAME_ECHO_ID_RX 0xffffffff
+
 struct gs_host_frame {
 	struct_group(header,
 		u32 echo_id;
@@ -570,6 +575,37 @@ gs_usb_get_echo_skb(struct gs_can *dev, struct sk_buff *skb,
 	return len;
 }
 
+static unsigned int
+gs_usb_get_minimum_rx_length(const struct gs_can *dev, const struct gs_host_frame *hf,
+			     unsigned int *data_length_p)
+{
+	unsigned int minimum_length, data_length = 0;
+
+	if (hf->flags & GS_CAN_FLAG_FD) {
+		if (hf->echo_id == GS_HOST_FRAME_ECHO_ID_RX)
+			data_length = can_fd_dlc2len(hf->can_dlc);
+
+		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+			/* timestamp follows data field of max size */
+			minimum_length = struct_size(hf, canfd_ts, 1);
+		else
+			minimum_length = sizeof(hf->header) + data_length;
+	} else {
+		if (hf->echo_id == GS_HOST_FRAME_ECHO_ID_RX &&
+		    !(hf->can_id & cpu_to_le32(CAN_RTR_FLAG)))
+			data_length = can_cc_dlc2len(hf->can_dlc);
+
+		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+			/* timestamp follows data field of max size */
+			minimum_length = struct_size(hf, classic_can_ts, 1);
+		else
+			minimum_length = sizeof(hf->header) + data_length;
+	}
+
+	*data_length_p = data_length;
+	return minimum_length;
+}
+
 static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
 	struct gs_usb *parent = urb->context;
@@ -578,7 +614,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
-	unsigned int minimum_length;
+	unsigned int minimum_length, data_length;
 	struct gs_tx_context *txc;
 	struct can_frame *cf;
 	struct canfd_frame *cfd;
@@ -621,20 +657,33 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	if (!netif_running(netdev))
 		goto resubmit_urb;
 
-	if (hf->echo_id == -1) { /* normal rx */
+	minimum_length = gs_usb_get_minimum_rx_length(dev, hf, &data_length);
+	if (urb->actual_length < minimum_length) {
+		stats->rx_errors++;
+		stats->rx_length_errors++;
+
+		if (net_ratelimit())
+			netdev_err(netdev,
+				   "short read (actual_length=%u, minimum_length=%u)\n",
+				   urb->actual_length, minimum_length);
+
+		goto resubmit_urb;
+	}
+
+	if (hf->echo_id == GS_HOST_FRAME_ECHO_ID_RX) { /* normal rx */
 		if (hf->flags & GS_CAN_FLAG_FD) {
 			skb = alloc_canfd_skb(netdev, &cfd);
 			if (!skb)
 				return;
 
 			cfd->can_id = le32_to_cpu(hf->can_id);
-			cfd->len = can_fd_dlc2len(hf->can_dlc);
+			cfd->len = data_length;
 			if (hf->flags & GS_CAN_FLAG_BRS)
 				cfd->flags |= CANFD_BRS;
 			if (hf->flags & GS_CAN_FLAG_ESI)
 				cfd->flags |= CANFD_ESI;
 
-			memcpy(cfd->data, hf->canfd->data, cfd->len);
+			memcpy(cfd->data, hf->canfd->data, data_length);
 		} else {
 			skb = alloc_can_skb(netdev, &cf);
 			if (!skb)
@@ -643,7 +692,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			cf->can_id = le32_to_cpu(hf->can_id);
 			can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);
 
-			memcpy(cf->data, hf->classic_can->data, 8);
+			memcpy(cf->data, hf->classic_can->data, data_length);
 
 			/* ERROR frames tell us information about the controller */
 			if (le32_to_cpu(hf->can_id) & CAN_ERR_FLAG)
-- 
2.51.0



