Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3355F3E4C79;
	Mon,  4 May 2026 14:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904907; cv=none; b=c3L2x1MNeWiNOvmxtS6M8JAyG+cTXAdrwMv+NYW6+BkBkxS2Fx5UNJuFgMokRvz3i0/Ad5RcjjCkAM/hKJrLY9Blax/zDoDRYJ8POeLwWsOuh61BrEfMoWKp8ISaDB3B3hYbnPjKyHN8HxTsECRumhTMK4AgXXbnFyrov+I9S/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904907; c=relaxed/simple;
	bh=FJFD5jBRMfM/L/1DQghHLCYw/s96suUCPuhcRBGSpYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWdTUrlmCuKeBLrc6+WymXb5TJcaP9I6roDT1/bTQv+IZSQHmikLV2GcR+m745HudTf4HOOy++Xz3AMomhv/zTTdChiVRz7GNi5V+fxXGWRDsNZj8wV4T3xxkpw+2C+j3Tz1++XqH6FvhUr7nFC4Mhq0ftwZD/E6hFUaqOP/sf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfszJTiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfszJTiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBEEC2BCB8;
	Mon,  4 May 2026 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904907;
	bh=FJFD5jBRMfM/L/1DQghHLCYw/s96suUCPuhcRBGSpYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfszJTiUNJz245kgxifMkJxAvhbTLsx8ZAwUb/Mh0R5quBON6F4bEFAa9Q8gPVwfu
	 yEiTVWFqWWGxEYcua1IBZGiZW3zRHEJqbRtfKrZ3HsyReqg0DrGYw3uc2mF4pnUj2y
	 V22P9lTe1BEwrBqXEXMGfT4es2UVYbpH/lML9olo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 211/215] ipv6: rpl: reserve mac_len headroom when recompressed SRH grows
Date: Mon,  4 May 2026 15:53:50 +0200
Message-ID: <20260504135138.529389401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9e6bf146b55999a095bb14f73a843942456d1adc upstream.

ipv6_rpl_srh_rcv() decompresses an RFC 6554 Source Routing Header, swaps
the next segment into ipv6_hdr->daddr, recompresses, then pulls the old
header and pushes the new one plus the IPv6 header back.  The
recompressed header can be larger than the received one when the swap
reduces the common-prefix length the segments share with daddr (CmprI=0,
CmprE>0, seg[0][0] != daddr[0] gives the maximum +8 bytes).

pskb_expand_head() was gated on segments_left == 0, so on earlier
segments the push consumed unchecked headroom.  Once skb_push() leaves
fewer than skb->mac_len bytes in front of data,
skb_mac_header_rebuild()'s call to:

	skb_set_mac_header(skb, -skb->mac_len);

will store (data - head) - mac_len into the u16 mac_header field, which
wraps to ~65530, and the following memmove() writes mac_len bytes ~64KiB
past skb->head.

A single AF_INET6/SOCK_RAW/IPV6_HDRINCL packet over lo with a two
segment type-3 SRH (CmprI=0, CmprE=15) reaches headroom 8 after one
pass; KASAN reports a 14-byte OOB write in ipv6_rthdr_rcv.

Fix this by expanding the head whenever the remaining room is less than
the push size plus mac_len, and request that much extra so the rebuilt
MAC header fits afterwards.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Cc: stable <stable@kernel.org>
Reported-by: Anthropic
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026042133-gout-unvented-1bd9@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -491,6 +491,7 @@ static int ipv6_rpl_srh_rcv(struct sk_bu
 	struct net *net = dev_net(skb->dev);
 	struct inet6_dev *idev;
 	struct ipv6hdr *oldhdr;
+	unsigned int chdr_len;
 	unsigned char *buf;
 	int accept_rpl_seg;
 	int i, err;
@@ -594,8 +595,10 @@ looped_back:
 	skb_pull(skb, ((hdr->hdrlen + 1) << 3));
 	skb_postpull_rcsum(skb, oldhdr,
 			   sizeof(struct ipv6hdr) + ((hdr->hdrlen + 1) << 3));
-	if (unlikely(!hdr->segments_left)) {
-		if (pskb_expand_head(skb, sizeof(struct ipv6hdr) + ((chdr->hdrlen + 1) << 3), 0,
+	chdr_len = sizeof(struct ipv6hdr) + ((chdr->hdrlen + 1) << 3);
+	if (unlikely(!hdr->segments_left ||
+		     skb_headroom(skb) < chdr_len + skb->mac_len)) {
+		if (pskb_expand_head(skb, chdr_len + skb->mac_len, 0,
 				     GFP_ATOMIC)) {
 			__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_OUTDISCARDS);
 			kfree_skb(skb);
@@ -605,7 +608,7 @@ looped_back:
 
 		oldhdr = ipv6_hdr(skb);
 	}
-	skb_push(skb, ((chdr->hdrlen + 1) << 3) + sizeof(struct ipv6hdr));
+	skb_push(skb, chdr_len);
 	skb_reset_network_header(skb);
 	skb_mac_header_rebuild(skb);
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));


