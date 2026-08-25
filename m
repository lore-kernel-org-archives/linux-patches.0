Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F4E392C21;
	Tue, 25 Aug 2026 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665942; cv=none; b=gWk9FRlyFomoqCXmGzX7U5hHFFOgmI/JE+dqvVwGCcU42BcWrnkBfhtDXjxlWjnWX2txtH34OCEi5KJ0WOvy6mZOf5xmcSUs11PzYdFaBRnR7uRF9Rw0GLSgQzomXEo8xVHMPNO8QD2JUJsfdGiatMbsHvhA/AETnCdoggORR7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665942; c=relaxed/simple;
	bh=pNXIeGjMjqOKWTKno+GBb8ZKXrOCAWNoCyjj0fxrLDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD/Rrhh1Fnz1ol/ZrvsGgN6tyMhQcJkbaBmCeXdZLA1SbATxNBR5k+RdpZPwmH8ilRJ2IJ2GHXWmE2bFDeR1D739N4Nq5eztVh4EAT08n/RYJ+xWHVE8ssuOc9nXM27J4YomOGQgh8TiOrHI04rWYfnEnk19hPWdBF7+ANVPTfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqaHv9ZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqaHv9ZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E4F1F000E9;
	Tue, 25 Aug 2026 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665941;
	bh=AfcWj3W0EBQfpETfmO3fUXK4ITufCinc7scjHqy5JhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqaHv9ZYx7a5etWlceWk+SvaZSXcUcdIVb4MKJdSKBMzhiqMsn/bhbMT9kYza+8V/
	 llSZVpn7aDr+jd0wMxhCcDKlkHNJaVW5TlKjioMHYzULVKwmcb5fTPUCJK6GO1LvDA
	 BGjXtSt1KKxHVb5hRXXJIbeX6sFDXqsjgSctkkv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Shaoxu Liu <shaoxul@foxmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 03/79] rndis_host: add overflow check in rndis_rx_fixup()
Date: Tue, 25 Aug 2026 15:25:43 +0200
Message-ID: <20260825132541.798974266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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


