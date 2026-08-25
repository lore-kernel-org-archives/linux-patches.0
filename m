Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3102748094F;
	Tue, 25 Aug 2026 13:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664920; cv=none; b=GAKDnQl4R4KaXLqkAj+dnzNp48xSXtQU1VU9GAJGWlZI9tMxy+KzF1Sf7mkY1FABUFdNwxsDJ3rrjf1FnEwLmFPGuit5MnDEpjqCvrqwRaTCA5xP7cVCx8l/hP7A7vhm4EUikvmScYULLV7rPVbkIlK4YZJeQAGecd7SMV6ZSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664920; c=relaxed/simple;
	bh=NnkPbUhtJI68hejGL1/ygMze+TadFBd9mnz7kMZLHeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOkWGT1CUhwkHaISSxiNODwYiz1jzijSl6Pv8hbHyxOqq2EnfTITxajQnddUzLC9ZoMcU546PwA4Jw5rp7QX1doWpDFKcEPLSObyGAr73MAr5za+SxUwqvm7WTL3ynVpF84Gqd/AEagzGUn12+4wkg2kPcycwERTg1bJX1nHZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=no57y4Ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="no57y4Ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CE41F000E9;
	Tue, 25 Aug 2026 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664919;
	bh=3xRuQ4zIkQY2AHTP+Ay//VGNshoe7ttR4OdYdpDC37U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=no57y4Ba5S7bmi0PTN90qx0ypzKAV1469ghSkNVcjBfz2AemIAKhTGh1yTv9QlNaa
	 noM3RlFVuG2kBhHzSjcgdHymcGWjLofPD26kbDRgnAwt/FauF7cmHX94LhA8txTLl4
	 9RkjaERoLHaVhIg9pLy5Nao3lk1WbkZmT0NLWfDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Shaoxu Liu <shaoxul@foxmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 011/101] rndis_host: add overflow check in rndis_rx_fixup()
Date: Tue, 25 Aug 2026 15:24:49 +0200
Message-ID: <20260825132542.445875704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 965a251f23ff69cfb4486974d4532e9bb551c7fc upstream.

Add an overflow check to ensure that data_offset + data_len + 8 does not
wrap, which would enable an OOB read of the USB data buffer.

Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Shaoxu Liu <shaoxul@foxmail.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/2026070900-denim-brook-52d4@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/rndis_host.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -14,6 +14,7 @@
 #include <linux/usb/cdc.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/rndis_host.h>
+#include <linux/overflow.h>
 
 
 /*
@@ -506,6 +507,7 @@ int rndis_rx_fixup(struct usbnet *dev, s
 		struct rndis_data_hdr	*hdr = (void *)skb->data;
 		struct sk_buff		*skb2;
 		u32			msg_type, msg_len, data_offset, data_len;
+		u32			overflow_check;
 
 		msg_type = le32_to_cpu(hdr->msg_type);
 		msg_len = le32_to_cpu(hdr->msg_len);
@@ -514,7 +516,9 @@ int rndis_rx_fixup(struct usbnet *dev, s
 
 		/* don't choke if we see oob, per-packet data, etc */
 		if (unlikely(msg_type != RNDIS_MSG_PACKET || skb->len < msg_len
-				|| (data_offset + data_len + 8) > msg_len)) {
+				|| (data_offset + data_len + 8) > msg_len
+				|| check_add_overflow(data_offset, data_len, &overflow_check)
+				|| check_add_overflow(overflow_check, 8, &overflow_check))) {
 			dev->net->stats.rx_frame_errors++;
 			netdev_dbg(dev->net, "bad rndis message %d/%d/%d/%d, len %d\n",
 				   le32_to_cpu(hdr->msg_type),


