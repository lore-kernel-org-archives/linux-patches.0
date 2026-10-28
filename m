Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209060;
	b=RWw6u2G4OiJO7A5k9HAIqazzf/LZJbynmrDluknNWWfU/AFPxExYgSU0wxbpAwvRZ7Ew
	 9jjA1uNsglXYtYYp7dw3Rq86kYq7RN7bTM4cSQMP+MOqbnRJEtfR8aowbB4zzgbuyb4f0
	 GAkMlNoPm0bCfNxw8EDDSdXPYrjgpkBhYVVD/uH2tDnhn2M97zOut/eDvTRqA7DPqvY8R
	 AGQam4UraxtuDSZI9EXp2xDcZHyb7wfCuBKuy9F2tX8sivgNuQioSyIlOpnhyi9BpM6y8
	 zahV48sFM2o2/z9K5bnArgVpdKMXD5BbYlOtPYyeJn6pKlEyAInKhjoZqA0zhmoyzWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lAeVzDqzfC4orOyyEwa0odY5VXpn3UDiz3uuSR/616Q=;
	b=HJll1Ka1iyls6BZhK+2pGskLs9HoIbzZe948oeiYaEcESRTLyrILYR49yIX+O64vFAgl
	 3dasK85v5w+RsN5YgdzX1fZJ6cXVVLpA/242fZJe0kIOFE51CRSLfZtCVmBtK37G1iHHz
	 Nv8dJ6KXARe1RnHZT93Ay9SbH/K4DdhT7g5QQEIcqiYgSg8HisRpmzY+EcWCbNfy5RVPm
	 6ez6DlY3XTIvP4uYBHaJjhILp+dP0vMdPG3k7nvMpMMbrUpjIpidMF6y+WCNaEpxjoemT
	 K5hsNgmzE+ljpFoI6GoRClOvmU1vDTB5GYUuQyX/9xh6ACcSRQ5frviJiuKpNOg7tlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyAl+rW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DD160A383E;
	Wed, 28 Oct 2026 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyAl+rW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6031F01825;
	Wed, 28 Oct 2026 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209059;
	bh=lAeVzDqzfC4orOyyEwa0odY5VXpn3UDiz3uuSR/616Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyAl+rW5mFI3wWMkwXyu997yDWI25x7UMrLC5Juv4L0S3Tvo7zEKwdm+i5Ih9lQJM
	 wkMayWmFr92og77j6FwAz7pvDp1dWXQDnVRYLJCKGo0bKsdq6/a30/zHJICQeZonKZ
	 ata9V+AgAojKPrJQft/Sevueqf2jlW1i8FAFcIT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredrik Nyberg <fredrik.nyberg@volvocars.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 339/516] net: usb: ax88179_178a: fix rx frame length for non-last packets
Date: Wed, 28 Oct 2026 17:58:11 +0100
Message-ID: <20261028170011.518645961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredrik Nyberg <fredrik.nyberg@volvocars.com>

commit 9b6c20f788472d2042717a3c2f1bc60b2b77083e upstream.

Commit 4ce62d5b2f7a ("net: usb: ax88179_178a: stop lying about
skb->truesize") replaced skb_clone() with a copy into a new skb for
every packet of a bulk-in transfer except the last one. The copy skips
the 2-byte IP alignment pseudo header but still copies pkt_len bytes,
and pkt_len includes that header. Each of these frames is therefore
delivered with two extra trailing bytes: the 0xeeee pseudo header of
the next slot when the frame ends on an 8-byte boundary, or slot
padding otherwise. The last packet is still trimmed to pkt_len - 2.

IPv4 and IPv6 trim the extra bytes, so most traffic is unaffected.
Anything that relies on the frame length is not. MACsec takes the ICV
from the last 16 bytes and drops every such frame as InPktsNotValid. In
our setup that was 0.2-1.2% of received MACsec frames, depending on how
many frames shared a transfer, including service discovery multicast.

Allocate and copy pkt_len - 2 bytes, like the last-packet path.

Fixes: 4ce62d5b2f7a ("net: usb: ax88179_178a: stop lying about skb->truesize")
Cc: stable@vger.kernel.org
Signed-off-by: Fredrik Nyberg <fredrik.nyberg@volvocars.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261002-ax88179-rx-len-v1-1-f01a2a295079@volvocars.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1563,11 +1563,11 @@ static int ax88179_rx_fixup(struct usbne
 			return 1;
 		}
 
-		ax_skb = netdev_alloc_skb_ip_align(dev->net, pkt_len);
+		ax_skb = netdev_alloc_skb_ip_align(dev->net, pkt_len - 2);
 		if (!ax_skb)
 			return 0;
-		skb_put(ax_skb, pkt_len);
-		memcpy(ax_skb->data, skb->data + 2, pkt_len);
+		skb_put(ax_skb, pkt_len - 2);
+		memcpy(ax_skb->data, skb->data + 2, pkt_len - 2);
 
 		ax88179_rx_checksum(ax_skb, pkt_hdr);
 		usbnet_skb_return(dev, ax_skb);


