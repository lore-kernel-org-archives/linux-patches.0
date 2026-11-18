Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037088;
	b=3KtjhMb2+K2gOJQf2QhOrK29QjGsXr+o5O/YFybbdFQSSs+NtFAYuve8yQQIxpeuro37
	 Vp03fS9ROFuc/0CnS/g4iWYleyT3NJXwXGKU2uCjvT/M8tNbWY/8UzFpIQRaOheYRV8FX
	 l+O/lg3jWTg1GeXMNKeqqXdeOVuFKXGhAwj3RRCr36z2FsJG3OnT2mg8gGE3calPsYEau
	 KgVIa3zORLVac+fOH2KqhYjR3O9ILyOC8+XOkOGCrvvjlsC63HRZziJLniVAs9Ze73wzg
	 LNu1UHsGF5m/PK84eZLcC2r3Xc4WbgAzNR+5B5NJBn9jobrEHC2TDCuWNLfORLM8L7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mS8AgpJ+MmOlsVxexs1zXPrx7HAKW5x1Qr1CrHMIrEU=;
	b=EF94I8Vrh4IGzIadx3NQ4O7XfvwPw33aY+rwpbgtEvyW5DsrVrSFYSrQwlZnZjFX/0qc
	 WKv2PeJ5ger6ys+PKNl251LhfetQTw2OZiGnoKrCJSu/Su9Eup24fBcMFboEZF4K99Q0n
	 4CAMlNrZ77W5rxKuHrxzjGnyRbhbsWCL3k8nrMwEaaewce2+WJfGUYHqK8abtJ8weqn7B
	 j8qNLNkAElgcZhwjUDc565nefTKgV6+V1owmkj/IHM/7QpL33vzp/1cZGyAkYsceVxNSs
	 cp5nnqlKU9kY6GqZ/6Pfw/9w1WtmSe8rK+tTXGDDf5UKaeay6mDDVv0tD26e/+JR7PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbM5vJAS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABD9606A320;
	Wed, 18 Nov 2026 21:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbM5vJAS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626C31F000C4;
	Wed, 18 Nov 2026 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037087;
	bh=mS8AgpJ+MmOlsVxexs1zXPrx7HAKW5x1Qr1CrHMIrEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbM5vJAS8EvBn4B22BOT02uyo6sC54WadlLb2iUBkDJsaFGYwCMi1WbrLZ1+wwQUi
	 I/uW+yi0LrUWftHnNTqCQZYRTc8a94JaiCltNTj+dB5xw2cMB2RQycvd2njQIUVeWs
	 xb3hFU/XJbz8qz3mswNj8noPQPDGp3D8aX2vwlLI=
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
Subject: [PATCH 6.6 1287/3318] net/packet: check TX_RING fragments before memory accounting
Date: Wed, 18 Nov 2026 15:31:49 +0100
Message-ID: <20261118150358.868529399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2509f878cffad..bd09a8c414907 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2696,6 +2696,12 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
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
 
@@ -2707,12 +2713,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
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



