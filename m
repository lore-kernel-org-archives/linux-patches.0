Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E4948165C;
	Tue, 25 Aug 2026 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666371; cv=none; b=jMj4yGeA9U76+VBNSM67+qb5bEUgUFYV1el9C8PCEIgkCBtJ037a2RJPkjP/e6rsiCbAur9vTGKrqvFJZaPjwFZXlkq+WeuXU+3sZSwW+sdFNchuKzjjNwYhpyiml+4GXCi8AUBuZk7VKtVUmtmrbxCVeeqc81IT6R9dgJYcnlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666371; c=relaxed/simple;
	bh=82NcX4oTOsjz5tzAV6X9RKqDoaYExZFmD/mF9nUhXPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0/celoWlLwGDAMGZnOysnEVx/j0jPq8QqUmh2TYLpe1ZCf/6NzZPgeOuqO0jb1arnGF2K1RzEam358yKAY3HkrIom+tv1gK+NlF1kQVEfBMYDye1viilkF9+ZxONL9EPGVjFl8MfIRQnD7Ve0hnHFe7m/IJW+XJyHLMYFP7Vg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EThaFl80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EThaFl80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A180A1F000E9;
	Tue, 25 Aug 2026 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666370;
	bh=JdonPaZ8jSGcrhfbmoHcneIamk9AKcNTuXMRcokghyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EThaFl80b8SrBqFWjTAH6C6xx+wjaZqwEBqQ8QjbkYTlXSjZ+T5O5kpT2m391M+cD
	 jfFZSnC0vdNi7Olmcyr5z+XYx1TOClBMDIljPVj1EUzs4y+1LnJov6DLUpCfrXSTZk
	 /NyjIXnxce9p1IBvj+VXtQCddfm0VS/TYyAhL0c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Shaoxu Liu <shaoxul@foxmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 02/57] rndis_host: add overflow check in rndis_rx_fixup()
Date: Tue, 25 Aug 2026 15:26:24 +0200
Message-ID: <20260825132541.430175572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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


