Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062671;
	b=xLj1Kt3ixxUydPO5MjO52kUXKZzQEIUABQmGSS3lkz1bmwfBg64MS7cOV7A8isErEMnV
	 RUeaqqtmLLS0x0kxBNy0H97CngCmAp+FjPPq3VS0YBC3S5OAZpe7GdjFNvW3T3VvU8Pnx
	 Zi6NKV5YnKOE1PgRd1vHazXCkiy6HyLykg0tBszum1JgsVJtzcuXhRCPug2Hq95uxI3HS
	 i2mbzwSB9L4wc0gnjGUC707QZVzzzPd0W7/AFsrR0dOLqIPT7zRmhRO5EnnLoZHKa5Wgv
	 2VkxFtGNeV02/ut3yCPt4xghAyUPvrgeZGl/jUw937h5zrrFI2XG1nxfypyPJbxqhPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MIEhbQSeE3QyoZCFvEDZX7Ov+P9U7q/wzU9ytm3UvSM=;
	b=OE+c3wuNtriAKAhmwGCbWvxDuVx9rk19G242H80xnaCgZNVpwxSqLdvJDMMJx9zOFLL4
	 /wNsOyNmR081wSdJwZnvAuRgW+EuYwNIJMJe60n4fGkiTDB1ZCwi7FJPoVPWCJzy4OslD
	 J5h+I4OvcrC8TeqWcL721vGnGnw/uPN/yO0ZLY/oswTE0fHGayKqOh8vlJ/Z/BIfpKR4K
	 WgTsk03nPcNgLiaeMBa0ektx7gkX8R0EGwUotfTYJhv87N2Scr33N8pxR/MeIuvTRxkKw
	 XSwVHp8SecOh2cnTQqVX3SzpNRA/it9rt0/SOjeh73asbZCGEFucRo7wZiTnfGQiADQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GR1OmhLS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4297606A32C;
	Sat,  7 Nov 2026 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GR1OmhLS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679621F0089F;
	Sat,  7 Nov 2026 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062670;
	bh=MIEhbQSeE3QyoZCFvEDZX7Ov+P9U7q/wzU9ytm3UvSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GR1OmhLS76g3OHPnLG/I8DPTNxcnhNQ7YfbJXwnU/MH1wyESSk4uQJ/Wusu/R5g2Q
	 Tqg/t6oBuuWkY1p6UaNVStq8OMmXTiqyv7NWZV/YXU+jHxh86N+KonjhHcyMPamtz6
	 MtIQ+htuHj1VbberbGePQVUXif1zLznkeluZyPi4=
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
Subject: [PATCH 6.12 1525/1536] net/packet: check TX_RING fragments before memory accounting
Date: Sat,  7 Nov 2026 08:59:01 -0500
Message-ID: <20261107135040.712688359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 048dc025b911b..1f5353b5d7500 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2699,6 +2699,12 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
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
 
@@ -2710,12 +2716,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
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



