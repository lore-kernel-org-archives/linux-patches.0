Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054255;
	b=xtHhckbIOS6eqFp0+7k9gsta8dJGpUPO+aGV/EW7f68EavkoCCNrFUXgUJZ9RQnx4PJA
	 mwN0q6tJ7WQGXqJkQDY0HNBRg1fcZm+Fh7d7lLwAF4/JXD9ah8cX/KTSoHoQgkM5Cdewm
	 od24/4CLyZLk3xsi9vf8Sws4E1y2TNhRlgugHKGYvKT6w+dFbs+aQTd56R63Xw3sPsHgH
	 GN5WBsrsOrnifV22yt+BFD+2PVCvTDu8Co5NTPUrIeTm1Ab9qQXv2jdk0bOeyG8qb3yFA
	 iBgqsrO/OQOYzz2RdnWgEooN119ntnTaSUq/+yxXZHarSqnkbckvOi4UfLGS7ltmItw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IZrgTzttJxpT5RcIDoKwqB+z6zc2062BBtx1x7Gefzc=;
	b=lm8NDV61RRo16bJQTR+rRk2v/1akYA49CQC8q5k5uh4xx4uNKGOeDIDrif97dAwX8ZAk
	 YfE12t11lSxgsLvCPS9FoXFIPl8aQTc5CybrHe9B9uhouTv517F+bFucIB7oUBB+s47CM
	 BA+X49veiudkTi1LFWLXqq7dUALRLWsQBvC0E9d9ciTqrEs5b0Mocg1AazJ1ppBWXSnZw
	 vTU5gyz87q68qiRlOmtZMqosFuPynAVJrp9tTszFfNLBp2iU0q6cTWxQ10h9comQGQ6ec
	 4emyTnUcozFE2cjSVRQCSxJvvxDptCzzz9ivUvtwWIM+syuQTvxwMwuRN+6fEegR99A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2SlSSA/0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861CD606A31C;
	Thu, 19 Nov 2026 02:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SlSSA/0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7AE1F000C4;
	Thu, 19 Nov 2026 02:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054255;
	bh=IZrgTzttJxpT5RcIDoKwqB+z6zc2062BBtx1x7Gefzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SlSSA/0UX/NIxc9Lhg68iPf6wOJNS+dYDsnXzayUxK5oRGhIvm5QIF916PjABlWi
	 gFsegPfSpWnDQ9tAildk3gAGcf3h3khOiuENewHXmujMTdNLHx+Swf3rNdzyxdryFP
	 VcTp7ZvOAqR8rBT5ARhryfmspcx8gaSgnp9QtX9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1211/2214] net/packet: check TX_RING fragments before memory accounting
Date: Wed, 18 Nov 2026 15:48:07 +0100
Message-ID: <20261118150100.263031235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit dc4dd12f80e499dc034710cd8195489abcf0b059 ]

tpacket_fill_skb() adds the full non-linear payload length to
skb->truesize and sk_wmem_alloc before checking MAX_SKB_FRAGS. With
PACKET_VNET_HDR, userspace can submit a ring-sized frame even when it
greatly exceeds the device MTU.

A near-INT_MAX frame can saturate sk_wmem_alloc before the fragment
loop rejects it. A subsequent refcount_add(0x40000001) can temporarily
turn REFCOUNT_SATURATED into 1. A concurrent TX completion can then
drop that apparent last reference and free the still-live packet
socket before refcount_warn_saturate() restores the counter.

Check that the remaining payload fits in MAX_SKB_FRAGS pages before
accounting it. Include the initial page offset in the calculation,
and move the existing -EFAULT handling out of the fragment loop.
This preserves the accepted packet sizes and error code while
preventing an invalid frame from injecting an oversized byte charge.

Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
Cc: stable@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: use net_warn_ratelimited() instead of pr_err(), add a Fixes: tag]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261028181450.2221013-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ 5.15: adjust for context in kernels lacking 3948b05950fd ("net:
  introduce a config option to tweak MAX_SKB_FRAGS") ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1174b92343212..574c52c38f28e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2646,6 +2646,12 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	}
 
 	offset = offset_in_page(data);
+	if (unlikely(to_write > MAX_SKB_FRAGS * PAGE_SIZE - offset)) {
+		net_warn_ratelimited("Packet exceed the number of skb frags(%u)\n",
+				     (unsigned int)MAX_SKB_FRAGS);
+		return -EFAULT;
+	}
+
 	len_max = PAGE_SIZE - offset;
 	len = ((to_write > len_max) ? len_max : to_write);
 
@@ -2657,12 +2663,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	while (likely(to_write)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
 
-		if (unlikely(nr_frags >= MAX_SKB_FRAGS)) {
-			pr_err("Packet exceed the number of skb frags(%lu)\n",
-			       MAX_SKB_FRAGS);
-			return -EFAULT;
-		}
-
 		page = pgv_to_page(data);
 		data += len;
 		flush_dcache_page(page);
-- 
2.53.0



