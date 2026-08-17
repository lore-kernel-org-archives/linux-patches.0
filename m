Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5C32F1FDF;
	Mon, 17 Aug 2026 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980198; cv=none; b=Jypr12zk3TgeigqT5CEQwMiI5n611yRMDknwSK2uNUBW/Kq1qii+s7n2STZxmbVYYF2OgZ1XEXQwN+fmlje3Z+CFuFzOXbxOv63BKfH20kEyQRtabcCAosZijVX7WQlAoOXZYvOheKuEVQcaT/lAvZs3Njt4j7LEc9gR2+9c0YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980198; c=relaxed/simple;
	bh=gBtX+VaLV9PlLTIdl6O3GaPwiG4gENNA7RLSDaBjbns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+k1pjZNm1+jaijG87JEFsV/QKMsw2Ld41DwonIJ9hi0dgI2gnCm0e9mXjMIbvsiCDkC0+bDa9TDZRhFGprg9snomq3/LGqYB0CRuJi83hr7cAgMJvIp3EbdDBUXzuIQhufDg2GYxx+z/aaJdDdJcSgCGspMEuYHzEZdg/Fkg6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHActbRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHActbRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781921F000E9;
	Mon, 17 Aug 2026 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980197;
	bh=/6VOzkcW9TB/+DtxrBsdbeGOOPU0Uh/SGwQoysW6j5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHActbRCL8OhIdAKuvhBx58pOQUjcD9Uv7fUeGysTCGX3lVNAa3FCWDI5FtTtRcNF
	 SykkVBzZgsotrlEfrGM7qJgEciNASTLgLr+kFbXN4rB4KYES9zJuKaycXqZnpr4lN1
	 PFRGn3uhuT6DLrzrAfBb/oZjrXfxrRu9BiPsUWwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 450/609] can: ems_usb: validate CPC message lengths
Date: Mon, 17 Aug 2026 15:32:26 +0200
Message-ID: <20260817132559.115462065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 02925f51377f2a42a6724f00549167499c9302e5 upstream.

ems_usb_read_bulk_callback() walks CPC messages packed in one USB
receive buffer.

Check that each declared message fits in the URB payload. Also require the
type-specific payload to cover the fields used by the CAN, state, error and
overrun handlers.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706092752.79600-1-pengpeng@iscas.ac.cn
Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -409,6 +409,40 @@ static void ems_usb_rx_err(struct ems_us
 		netif_rx(skb);
 }
 
+static bool ems_usb_rx_msg_len_valid(struct ems_cpc_msg *msg)
+{
+	size_t len = msg->length;
+	size_t can_len;
+
+	switch (msg->type) {
+	case CPC_MSG_TYPE_CAN_STATE:
+		return len >= sizeof(msg->msg.can_state);
+
+	case CPC_MSG_TYPE_CAN_FRAME:
+	case CPC_MSG_TYPE_EXT_CAN_FRAME:
+	case CPC_MSG_TYPE_RTR_FRAME:
+	case CPC_MSG_TYPE_EXT_RTR_FRAME:
+		if (len < CPC_CAN_MSG_MIN_SIZE)
+			return false;
+
+		if (msg->type == CPC_MSG_TYPE_RTR_FRAME ||
+		    msg->type == CPC_MSG_TYPE_EXT_RTR_FRAME)
+			return true;
+
+		can_len = can_cc_dlc2len(msg->msg.can_msg.length & 0xf);
+		return len >= CPC_CAN_MSG_MIN_SIZE + can_len;
+
+	case CPC_MSG_TYPE_CAN_FRAME_ERROR:
+		return len >= sizeof(msg->msg.error);
+
+	case CPC_MSG_TYPE_OVERRUN:
+		return len >= sizeof(msg->msg.overrun);
+
+	default:
+		return true;
+	}
+}
+
 /*
  * callback for bulk IN urb
  */
@@ -451,6 +485,15 @@ static void ems_usb_read_bulk_callback(s
 			}
 
 			msg = (struct ems_cpc_msg *)&ibuf[start];
+			if (msg->length >
+			    urb->actual_length - start - CPC_MSG_HEADER_LEN) {
+				netdev_err(netdev, "format error\n");
+				break;
+			}
+			if (!ems_usb_rx_msg_len_valid(msg)) {
+				netdev_err(netdev, "format error\n");
+				break;
+			}
 
 			switch (msg->type) {
 			case CPC_MSG_TYPE_CAN_STATE:


