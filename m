Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625664;
	b=Fd4TEvTsHN8fKv0/kECbmGSBZ0tbYkdKoSHORl1jeSj/SUAPbVzBkk2BpcsXx1WkXzDL
	 uFNaJRxWIbpbDjAzvxV4tHEcaV5flwdQelYB4hyOcs9QBlnsKSNqKNM69SrQYzxJSuhjL
	 3CLEN0JWCJpl18CPmFoaLB1WPFa+OU/ZXavtNvc4oLIaZvv9m9UGbKTrl7ZPKFtcMWaoj
	 9ZkWRlnJtTE8fbM4I7clW+w2YgkVjs9KycBDB9jDNLfakDwcA8+xUKS1/r/EhdFNhOzS9
	 xbC6woYvbgmibV4zEZ+UYFo3HcmKkLSJyjfDFVH8LKf4Ii6Su98eG/xcnoggU/lIqKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YsEw9k+vThpykQ4goaGw8kCIns/KGJcoXEQ0cfIYoxk=;
	b=pST1biMqWGerI+7e5bFtbicqi0ZQsrmfVZUeTAGbtnSm1iaSQZX7tkNnGZjRBK4XWFxe
	 Ht00Sr/c6BrX4W+LbFxs6Ne3Rc86ARlPZXp0PbLO3900R+8KXqmJ8sRTtY4tCY+Puhq2p
	 Xgtf2e10gV9VUcKtJsRv6BW3TuSnRReIQgMPz4PshaMeEW04M/rqQx07s/4h7r6HzDuhd
	 wtkDFRYpfNF7zJ53ykmtNH22t1lSjF7/uAoqkB0LD2DyzpA86p1TUsEChXucXjr8wLY+4
	 7BCXtuTLtnx6YnPeezBD6oRBbrbTX4bRhwUBwBfRQQTxgq6/q0c0cox0VczukiaTk3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzNyHYGN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5E606A321;
	Wed, 25 Nov 2026 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzNyHYGN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683531F000C6;
	Wed, 25 Nov 2026 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625663;
	bh=YsEw9k+vThpykQ4goaGw8kCIns/KGJcoXEQ0cfIYoxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzNyHYGNJ2YJwg5R+t2G5ALx2/VVoKnYuw6BdDyKiPzi9ygnjUynHzpxWJ+tXSLOb
	 KqUGeXSmxyFG5flcctHR0O7/iQDQP7pYD+zLONBtA88oNHpN1etpzKLJmZFFS0yB46
	 +r7xuzoaHIWiOURJhmZoIVJbfSL/4JvsRzbPpn0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 590/816] ipv4: keep XFRM headers out of corked skb lengths
Date: Wed, 25 Nov 2026 15:35:38 +0100
Message-ID: <20261125143902.834307519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 0f47fce51a98d3d9f439c16861d519a7b833a176 upstream.

__ip_append_data() allocates space for dst.header_len in the first skb,
but includes that space in skb->len until __ip_make_skb() pulls it.
Fragment accounting uses an MTU that already excludes the XFRM headers.
As a result, the next skb can have a fraggap larger than its capped
datalen, and skb_copy_and_csum_bits() can overwrite its shared info.

For example, five AH tunnel states can reserve 500 bytes while leaving
an effective MTU of 348. With 40 bytes of IPv4 options, the second skb
has room for 288 bytes of fragment data but receives a 500-byte gap
copy. The overwritten shared info is subsequently consumed by the skb
release paths.

Reserve the XFRM headers together with the link-layer headroom instead.
This keeps skb->len, the gap-copy offsets and the trim lengths relative
to the IPv4 packet throughout corking. The network and transport header
addresses and the headroom available to XFRM at output are unchanged.
Both paged and linear allocations, including subsequent corked appends,
use the corrected accounting.

Fixes: 353e5c9abd90 ("ipv4: Fix IPsec slowpath fragmentation problem")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261030042229.74068-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1152,16 +1152,16 @@ alloc_new_skb:
 			 */
 			skb->ip_summed = csummode;
 			skb->csum = 0;
-			skb_reserve(skb, hh_len);
+			skb_reserve(skb, hh_len + exthdrlen);
 
 			/*
 			 *	Find where to start putting bytes.
 			 */
-			data = skb_put(skb, fraglen + exthdrlen - pagedlen);
-			skb_set_network_header(skb, exthdrlen);
+			data = skb_put(skb, fraglen - pagedlen);
+			skb_reset_network_header(skb);
 			skb->transport_header = (skb->network_header +
 						 fragheaderlen);
-			data += fragheaderlen + exthdrlen;
+			data += fragheaderlen;
 
 			if (fraggap) {
 				skb->csum = skb_copy_and_csum_bits(


