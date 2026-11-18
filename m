Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042743;
	b=ZTFkDEM0HOZrfCbVKppYHGVZuuRqwJalAPl1Q2/qrpAwX+l8YlRdCI0rNv7yp7wXNq59
	 JBcT/VZ5ya9rRSBjOVMKVL3YxuE5U6BTF23e0Z/23FOj3wWJGLUTMmtpH5MDD76tmV5na
	 YTJG+S/MsPZ+qENzlPbZdfJbgjD/sMVhJN9kxvnpyjePQ5KZ27trcsBAled/00+Eo3ON/
	 9/l8vQqBA9nr0mDETrjozkcRJFrCAGj4dLRGlh72TtAlyPior7AtPlZ+X/ll47hv3z2nG
	 x6qu1WJPf32RdMc29x36rlj7EZEZgNfdI7VjoFuPzuFwvXMVydcguph61j9yZ1ZxqnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OUAmMlwkEYLjIcD8izPlYwTMGtIwS1B+Gq8PI5zom50=;
	b=F691JJsf2ujIlJUp7ahCciUSvCjbtPdOG4csfr4YXmHwzM3UQKMZSI6WnaI6GdVtbl/s
	 2dfUrLEbymKhJM9j93GRf0RtD3AMhNBlG1b55F/YS/qIuMl7eWsusCTGYpPI+JoPYZ+Z3
	 3qtdOCWbYJqHTO9qP0gsWTti1P9CiMzoOPtQEb+ita/xJX8NQHO0LF2q8H3CQC9Mg5xAA
	 0wjzvLKhVsNavVd/KlZn6zF2Z8srdDXBYHb68SNrbIPg3jALkkha6vPSjiHsJ0NZL5cuM
	 Y+JQ1lgzUIMDx2DUdO8TXkzGOm2DxxxI3YyIkRKI5s4ulV50FVaKNhVb7B/yXnusqVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjS4Km5A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4446E606A31C;
	Wed, 18 Nov 2026 22:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yjS4Km5A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4FD1F000C4;
	Wed, 18 Nov 2026 22:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042743;
	bh=OUAmMlwkEYLjIcD8izPlYwTMGtIwS1B+Gq8PI5zom50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjS4Km5A4MfJo6NOMgYC600vaDCmcxgQxikBmygCGoAcpVwsgonti2a3vZ+BDCNkg
	 fMpWPcokRIdvn+35nrnYbZWUJLwCxtUxATXlwfgt3IrzbMBOKv9OZ9Zy98XBdeDY4K
	 ls+oEMKmraSqkqRby4qBbbYuT0caC3xcM5FtRKMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3278/3318] gro: do not GRO GSO packets with inconsistent payload
Date: Wed, 18 Nov 2026 16:05:00 +0100
Message-ID: <20261118150457.951966549@linuxfoundation.org>
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

[ Upstream commit de788d8a7032475f900c16e9cc0c1417f4f719eb ]

tcp_gro_receive() excludes empty non-GSO packets with the unsigned
len - 1 check, but its GSO branch only checks that gso_size matches
the held packet's MSS. A trusted TCP GSO skb can reach GRO again with
no payload after TC pedit increases its TCP data offset.

If the skb is fully linear, skb_gro_receive() then enters its fragment
transfer path with nr_frags == 0. The do-while loop copies skb_frag_t
entries backwards beyond both fragment arrays. An unprivileged process
using its own user and network namespaces can trigger a KASAN
slab-out-of-bounds write and panic through veth, pedit and GRE.

More generally, the payload of such a packet can be shrunk to any
value, making it inconsistent with its gso_segs, and a GSO packet
with gso_segs == 0 contributes no segment to the GRO packet.

Do not aggregate GSO packets with gso_segs == 0, and require the
payload of GSO packets to be consistent with gso_segs and gso_size,
the last segment being allowed to be short. This rejects the empty
skb before either TCP merge helper, and covers both IPv4 and IPv6.

Fixes: 5eddb24901ee ("gro: add support of (hw)gro packets to gro stack")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: check payload against gso_segs, refuse gso_segs == 0]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261028171350.2205175-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c         |  5 +++--
 net/ipv4/tcp_offload.c | 12 +++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index a97d9428923b7..f2dc3e633044a 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -509,9 +509,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	NAPI_GRO_CB(skb)->count = 1;
 	if (unlikely(skb_is_gso(skb))) {
 		NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
-		/* Only support TCP and non DODGY users. */
+		/* Only support TCP and non DODGY users, with a sane gso_segs. */
 		if (!skb_is_gso_tcp(skb) ||
-		    (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY) ||
+		    !NAPI_GRO_CB(skb)->count)
 			NAPI_GRO_CB(skb)->flush = 1;
 	}
 
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 7b09f6d0818b7..2d91b93b8dd01 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -335,14 +335,20 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	mss = skb_shinfo(p)->gso_size;
 
-	/* If skb is a GRO packet, make sure its gso_size matches prior packet mss.
+	/* If skb is a GRO packet, make sure its gso_size matches prior packet
+	 * mss, and that its payload is consistent with its gso_segs
+	 * (the last segment can be short).
 	 * If it is a single frame, do not aggregate it if its length
 	 * is bigger than our mss.
 	 */
-	if (unlikely(skb_is_gso(skb)))
+	if (unlikely(skb_is_gso(skb))) {
+		unsigned int segs = NAPI_GRO_CB(skb)->count;
+
 		flush |= (mss != skb_shinfo(skb)->gso_size);
-	else
+		flush |= len <= (segs - 1) * mss || len > segs * mss;
+	} else {
 		flush |= (len - 1) >= mss;
+	}
 
 	flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
 #ifdef CONFIG_TLS_DEVICE
-- 
2.53.0



