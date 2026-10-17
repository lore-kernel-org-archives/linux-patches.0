Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892533BAD95;
	Sat, 17 Oct 2026 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257268; cv=none; b=pGQvWDqFTCqXKF+BzkKHuQzI5P68cmlgla7HVD+9aCAXxjV2+HHbSvsG9UJhNGMf3yRfPFST/DgDZLSHFoH7Nib6YhU/nkr4YBjUQH18wJOBAi1BHMWHvjjE444ZQrHDVVBDHkIpwWcZoNdPhVSn09HFvwoMvyX2a45JYaMTl4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257268; c=relaxed/simple;
	bh=RoS3JDePKc+V5oOFRFl3jk84MLNLSfw1vqn1jvS75Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwtzHElj/kII+9eKAgVpTf+vTHSuSieXJ01gQsiqhKtSpeVcwmGaeYFrAvYzOOw8IWDpDHrFAiY3J7nxg3MSBHl2dLoOlMGHVkbzULlrwbCKzDq4HY1SBT6SqQCSqmUbGuX6usPuiZJkczN0bd63CJTeW6FoA3HehGSI1XyuXEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFk17CMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFk17CMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F721F000C4;
	Sat, 17 Oct 2026 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257267;
	bh=PytmFzwHsSpicXVr0i7hqIM0p23WAdnVN+GQp0Q5n00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFk17CMhldTTPz7YP28fuJJrs6qsZZaOP+7/c0HZHVXL+D5Vyo1XWhiLPYdxdoP8T
	 QL39O7Bk2k2qocaMUsBsnYOmYqlsP8tHF0KtdmHrxOUVS8Sar+J8xqXFJ6CrcKkly/
	 jXlWIu2QFBX6lc0j/qJoZI2nKpE+Ikg4WMe1VBQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredrik Nyberg <fredrik.nyberg@volvocars.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0505/1674] net: usb: ax88179_178a: fix rx frame length for non-last packets
Date: Sat, 17 Oct 2026 17:46:17 +0200
Message-ID: <20261017160444.070232819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1461,11 +1461,11 @@ static int ax88179_rx_fixup(struct usbne
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


