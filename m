Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605EF429CDF;
	Thu, 16 Jul 2026 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209735; cv=none; b=GKG3cnj1utB+NuRYb7jM1Fg/EJ9S5r8XHtSDVNu8PtnZd+nioyrYwrr5Sc4+jJIjO+9sQFYlwL64/o/Wj1Vi+HPoBeYiajskFkr5+QW958pEgBpmpA7GAvtQhRb9BmTb/mhZUex/oZsgglzFcsGl5RHuQv3ZZXTGextLlqcrFvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209735; c=relaxed/simple;
	bh=NMlhlMjB7ztX51srcZk4/O3CftsOKOz2QQALw6L8ER4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/UhSAIJuHcqOD8HeBRlFN5g96RBQvFlsXdy1rGShPrO7dqOhPStWejbiKPwvCnyua0EQu6jlIcWDhLJkeflztc5eqzEllKK3bdqYEvrTuwySDNYmPU0VUil77wEldSAur3bajGHjcA5t7spdh1ETOTR2cTkHHyz7BZsRs6SoKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUHgaGIG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUHgaGIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE5E1F000E9;
	Thu, 16 Jul 2026 13:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209731;
	bh=OUIl9kRlU7tNC/TTo/ZtJsojsazhgfCDcsqIwcuAtA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUHgaGIGFnBpjpL9tVupq2Za50umu6lX+4MyiBXGFsHIFmmy3JCyRjIcs9alPjHqC
	 gpT2NbvkIZ10I7RykkZWgT41ARWrCNtJxeIExlCmC4CSeAoLHn+VfRaRTCmj5Dbyf3
	 x/NmH5KzNn3U7RwJz41hbXhxZDQyOOfaSjDOr9Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 296/518] net: usb: kalmia: bound RX frame length in kalmia_rx_fixup()
Date: Thu, 16 Jul 2026 15:29:24 +0200
Message-ID: <20260716133054.294883376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 47b6bcef6e679593d2e86e04ee72c46a4e2f7139 upstream.

kalmia_rx_fixup() computes usb_packet_length = skb->len - (2 *
KALMIA_HEADER_LENGTH) as a u16, guarded only by a pre-loop check that
skb->len is at least KALMIA_HEADER_LENGTH, which is 6. A device can
deliver a short bulk-IN frame with skb->len in the 6 to 11 range, or
leave a short trailing remainder on a later loop iteration. Either case
underflows usb_packet_length to about 65530.

That bypasses the usb_packet_length < ether_packet_length truncation path.
The device-supplied ether_packet_length, a le16 up to 65535 read from
header_start[2], then drives a memcmp() and the following skb_trim() and
skb_pull() past the end of the rx buffer. The rx buffer is hard_mtu * 10,
which is 14000 bytes. That is an out of bounds read.

Require both the start and end framing headers to be present before
subtracting them, on every loop iteration.

Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B3730")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/178211531778.2216480.12637613349790980750@maoyixie.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/kalmia.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -276,6 +276,14 @@ kalmia_rx_fixup(struct usbnet *dev, stru
 				"Received header: %6phC. Package length: %i\n",
 				header_start, skb->len - KALMIA_HEADER_LENGTH);
 
+		/* both framing headers must be present before we subtract
+		 * them, otherwise usb_packet_length underflows and the
+		 * device-supplied ether_packet_length drives an out of bounds
+		 * access below
+		 */
+		if (skb->len < 2 * KALMIA_HEADER_LENGTH)
+			return 0;
+
 		/* subtract start header and end header */
 		usb_packet_length = skb->len - (2 * KALMIA_HEADER_LENGTH);
 		ether_packet_length = get_unaligned_le16(&header_start[2]);


