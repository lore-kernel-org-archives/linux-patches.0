Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A573481FCB;
	Tue, 25 Aug 2026 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666178; cv=none; b=h6GkyIGwP0/HaS7Dttlt/rbr3goYwYxvwHsAp9rpuHCBg5lOMcJ7vy6Ti9xf3pNX5Jo0VXY9TRqTaoRp9gEhjBRzYgAE1z3sfzDWuUPp08VYsSEB5gJt3XgAyc1s64AC6/M+Aet6BGr8xKNBn/2rNfYzzYv5lF3edxg5mvEef4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666178; c=relaxed/simple;
	bh=H90v5iWQKfctABFU992utqvtKLAANfBeALFyTXg/mYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9TzVQfmu5BA4A4V7a1h/N8CN47HqebzZ2jTccLE9z1RrmrgFvOIaC3yNnzp4vqaeIhTTorjLpNC5xvzq3YinuutXbdd/xNCpDFGmTQVEPg8P+ohzZLNvNrCCvHR+FwRsDT46eqWzqEstojQpPmXSyS72lFdUSwhZpIOrAsDhts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NC+qTdnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NC+qTdnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0111F00A3A;
	Tue, 25 Aug 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666176;
	bh=wOvpku84lu7+lO0pUqGJAVblOPd+1BZkwDDRxU3oSIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NC+qTdnjW6jqQcbwmIuMtvFw2+vE4f/vW2WYetIb/MDY8/5+ZqMfc/tZS3IAljDHR
	 lyATqtpUzpQTrZksumPIEE2b1wrNwPnYkgYiIvQGKWKJ07oe58eSa1v38SxLZgZl53
	 vG7lvJBN3d0T9nz/cP2X5jmBOJxWJg8kLi/26b/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Shaoxu Liu <shaoxul@foxmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 03/76] rndis_host: add overflow check in rndis_rx_fixup()
Date: Tue, 25 Aug 2026 15:25:56 +0200
Message-ID: <20260825132541.689826453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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
@@ -495,6 +496,7 @@ int rndis_rx_fixup(struct usbnet *dev, s
 		struct rndis_data_hdr	*hdr = (void *)skb->data;
 		struct sk_buff		*skb2;
 		u32			msg_type, msg_len, data_offset, data_len;
+		u32			overflow_check;
 
 		msg_type = le32_to_cpu(hdr->msg_type);
 		msg_len = le32_to_cpu(hdr->msg_len);
@@ -503,7 +505,9 @@ int rndis_rx_fixup(struct usbnet *dev, s
 
 		/* don't choke if we see oob, per-packet data, etc */
 		if (unlikely(msg_type != RNDIS_MSG_PACKET || skb->len < msg_len
-				|| (data_offset + data_len + 8) > msg_len)) {
+				|| (data_offset + data_len + 8) > msg_len
+				|| check_add_overflow(data_offset, data_len, &overflow_check)
+				|| check_add_overflow(overflow_check, 8, &overflow_check))) {
 			dev->net->stats.rx_frame_errors++;
 			netdev_dbg(dev->net, "bad rndis message %d/%d/%d/%d, len %d\n",
 				   le32_to_cpu(hdr->msg_type),


