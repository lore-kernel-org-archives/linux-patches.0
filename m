Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211556;
	b=InSk+RSAQv9qi7inGmLLXViP3LJ9UtfZ6z6PisX0V6yYHPpNl/2M5mEcWSEyhwr6eyTj
	 io+vVKu9M+QZ49DuLK1dXi97FknODJ3AIk8lp/5F4756h3WZx3EF3rSGSpyqj4J1MWC9Z
	 YWkeYVNjdITG61IcZcGB9Wrdl+D68nuddDU6ojWP3u/rUlJ0wdWkCjbXRsPTcgqGHyYiF
	 /ydRZD1N4jXba525j7XXqpy5WdgaNZkYLWmpXc7riPj6VnblgGhUm67BeS+hYcyvIyUt7
	 fB1erYGp3WW4lp+Sp5MBWxM0mdLDKh2X7g7fulgClRjFlF9zerYqVPEsj7/DigQwHew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4LgMR9Ki+b/Bj4HM9fWmJqqqpo4nPVyWJsWWpIDmtM=;
	b=Sa36Fb6Un9QjKAKKU62hcTLKRxdrtd7lBaKsVXQSPpbCHJyu16t3EVpDRJGs89eErASS
	 NIrq0WiRYZLPNS3iKTZF/BzrYD5VbcbkUC8y1GTjSS+qMG/WEOdVI+RoVeotk6+p57eTg
	 Y5k/EcRq4XB1HMQq0pUa5LzFRkWH4cAXtFQ7+8DoKtTQLptYaXCUUBS/ZMlppoSwPWSVE
	 EgVIut6HzIypD+vR5VRVzKnioqKQ2l7SdPTOJPUQvr0HiFlwzsF1XJe6kaJjHxULZsimO
	 Gzdz4SEftSvdF/XQx5OexaZwbZclUShukSc3sqyNCdE3VjAv/kEmGXtZbGMvZoItK8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfwd93pe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8007606A31C;
	Wed, 28 Oct 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfwd93pe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437341F01825;
	Wed, 28 Oct 2026 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211555;
	bh=Q4LgMR9Ki+b/Bj4HM9fWmJqqqpo4nPVyWJsWWpIDmtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfwd93peaPXq7Cc/A1/PAYpyabN6qU8RhixPO3Wgf9X78bxJhdCDnmx4gWNlmdJCg
	 9wkujbarPW4OSpxN6HtMek7jIBs7e0bVZVp5CApLt3L0Tsli3m7KM29tIzgbBQe9qu
	 p8UUtbMwB784ZTLQa6H8vHIMp7naQZvCdeijT7Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredrik Nyberg <fredrik.nyberg@volvocars.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 374/571] net: usb: ax88179_178a: fix rx frame length for non-last packets
Date: Wed, 28 Oct 2026 17:58:41 +0100
Message-ID: <20261028170016.887246904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1483,11 +1483,11 @@ static int ax88179_rx_fixup(struct usbne
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


