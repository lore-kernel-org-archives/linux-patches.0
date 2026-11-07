Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063763;
	b=TT0UYPfcO9qeuDa8G1nWbVX3UVrvGtQ0c2AzADGUCniCrp6PUNuIde7rezIHU9DCSXUc
	 ZWJU4DJSfHqrWjQhYYlPXjDQNqJWEKrcrVVJ5p+oit8yjAD7H8Mbn/hsoq9AdM3b9xSOA
	 v6PuVOYtqeNfeD/Nnb8fpcqBrVlnY/D1NgyJsF2DiD5f5G1pkZQTysTUuA2TE25TB/TqE
	 weKcHYXJjnUyE5H3mxZkPJp0G4QUXDQ40l5zO1R9Jf4VXKw3frQw17f4aKmSIEF6GnADt
	 dbdoJaVzTZZDgsgw80zr9BKBAsCH6miZO/oR3Py1Il54RoiBPAVGrJpWgycH+mdY+MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=00lhxzGxQMHz/W9eUGNZw2w8MMiYqItuYUchE6+dJrM=;
	b=S4qzSyYj2366lYD4FSq7jFd/31IOwAMJBlr7sjfyGPAq+fwoKdLjGuDAjV7I7N47h0z3
	 olWLdG3ho0d7Hpyk0J3/4XpuD5cwEhwWMq0YBMbGtANSiNTqRRt0GVV2LfqFSMg4iiaal
	 sLtLpttC7dlI/eYseUv1u5I1Kh0tfEaDayoazuCwZaCQEjP54umQVpUGclb8QNPhoLrRt
	 jfsICh0/go89i/BFyS3n7HOx27ylzZmL5Jc+4V0nc039w0EhWjksvgE9qQkYTO+jg3Evv
	 cW/U0J+/w3xwjLeE3QuR4KqhC+aCnaIpshNujjGga0nHOV2mZvVzAX/2cSr76wlA4OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rRL7t2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4310D608363D;
	Sat,  7 Nov 2026 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rRL7t2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98EC1F008A1;
	Sat,  7 Nov 2026 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063763;
	bh=00lhxzGxQMHz/W9eUGNZw2w8MMiYqItuYUchE6+dJrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rRL7t2NkkSMUS60LOg+V8uzZffvsV2cbibvVKDNrcdw36eyOmuHQUzxpMyLcGncP
	 C1wkvDb/hDyYaGB7VmMwfkuknwzYhqlGfOHTkhJZiKpGR6MnS1t6MoNZGErpJZ7jUK
	 bBPZYbqCyBDt2ls6Y4X9F9wwPRhSX8lsra/BePDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 856/869] net/packet: check TX_RING fragments before memory accounting
Date: Sat,  7 Nov 2026 08:58:58 -0500
Message-ID: <20261107134921.783468108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 4516e54525223..7b8ba1690d543 100644
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
-			pr_err("Packet exceed the number of skb frags(%u)\n",
-			       (unsigned int)MAX_SKB_FRAGS);
-			return -EFAULT;
-		}
-
 		page = pgv_to_page(data);
 		data += len;
 		flush_dcache_page(page);
-- 
2.53.0



