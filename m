Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC06A42FCD5;
	Thu, 16 Jul 2026 14:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212156; cv=none; b=Yokv0e5wUfsCMg+/D5tbG/tMsP87F/3RrS5Ej+hMRhg4VGTNVM93ogVHEKHVN+p6iZwbPcb7WzH3+7v4vi5n1XtrvzWZVsQXkcW0Dzneb4/2Q82FHgt7a//ww1D0K6LVMxz8/GqLW86omPOyHwp2IWBLwiaDj1gmK9UGR9h316E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212156; c=relaxed/simple;
	bh=DqYU5zXnEk6Qm5WucYt9Nee6uj5WC7NhxABs+1EOuBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV9CPJ3s8isWau0xT0H90vC1sqg9kjD3lgD0BbcKPgZqp/Q+UhXZymGtlj6/uBrv3Y1HJi0LN5KD33pAhnreXIY4EXQoSftITkkG/UxGXbhcpu5bZYce69E1XTNNV2N4r18tL24caYKBoHnLMUM0e2nonkS/bSYmQmtmn/iJzj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJCNvUe4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJCNvUe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC531F000E9;
	Thu, 16 Jul 2026 14:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212154;
	bh=PI5LIpfLnGzhe1WNAXAGDJHjnJrZJoWPvRACB60yyMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJCNvUe4yDgP3ZhLfF26Z3of/rn5euj2O2ixCo9IapR4xo3rbumCnyo2OGo5sum1Z
	 ErtzKyFSk5Xa/QkHjPC2ELirERffb5bciODKTiLkr9O+pkf9bC9rVJj3UY6l82h4cH
	 j5RPqSVyNUrVhgQSCBlObqGSNbXJgnnpUkHGGb4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 219/349] net: usb: kalmia: bound RX frame length in kalmia_rx_fixup()
Date: Thu, 16 Jul 2026 15:32:33 +0200
Message-ID: <20260716133038.264129835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


