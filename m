Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022323;
	b=4BkvdKB8iI1tOLA8f1QcOu62SRhXuxfMMdj/KR3BPlarRcVWVaFj8Zg67cytB/+EtL6T
	 ocuYjny2a0idu/PoeLeK5kpLNdt9+OXyEPfUG7qVyS31xoxRsgc1edcVvvj7t48PgLuWd
	 +raQNkN6atzFi8CdJ2HyEdJCZ5USRxtKSsOD4yIaDtCDjs4CT/W/yfYKhFxUs8NuTE13z
	 ZgQaVIB8jl0wXVsGzgVtwS83xXpE02Ud5Pk5fV2zvrQTKElEgeReUPOFqGlcDls5V0LZu
	 nLGkmaaLMBMurjhzjsTAsKrmpOsbFZpdyNN5eY4zVMNi49gIpqPD8+g8fTCjrAQowtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YPXurzqsguMip1nBaJRTm460PBwM8vZsgIqLtuism8U=;
	b=st9h55yF39OtgiGyp/OAW5/CLpLzjxIDj2XY8wEak227ddYjyMg1a5gvBFEagRGxqZD+
	 WVIO70y/QJa9WGuAtF0NP76t+8Iyjjea2CSWI7nkynlpUYJlAtPRXMJfya9AfsQ3DCLDn
	 zGP5NuDTTWCR4IEBxoOulEU+5CS3rdtPvzyANl6jTyp6S1iRNfevf8ITHPg5HmM1Ti4J7
	 +uslPHMH0rIoZC4LaGRVEBcK0kDN/lsq4/DuPZ61JptBmlimYkzuYY3fB8BgtGHTKKOXc
	 IVrZQ3n8Tiv+MUG8T8WlwsFUUJGUNyL0pRgdufQiT10cZiOQrHaQbLhDJidd+nbuemg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2ney2Sd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F469606A31C;
	Wed, 18 Nov 2026 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2ney2Sd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074931F000C4;
	Wed, 18 Nov 2026 17:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022322;
	bh=YPXurzqsguMip1nBaJRTm460PBwM8vZsgIqLtuism8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2ney2SdtEjcqeMeh5D0hWCEoZwQ8dBXA4VruJsQ7E/ZBqME/Q1lpAqJJhf7dgWqg
	 7qiPc2DzzmH5yksg1zyHZmkwGM30VTCGt5Clm4lq2Tx4wX/vVq539Mpzz9WDgkdpNv
	 pXNJumZbaP3J0+4DYzkW83GVajZI7cfakJVttRwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2619/2651] gro: do not GRO GSO packets with inconsistent payload
Date: Wed, 18 Nov 2026 16:04:19 +0100
Message-ID: <20261118150418.504052854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ff828a3dce3ca..1b033855a20db 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -513,9 +513,10 @@ static enum gro_result dev_gro_receive(struct gro_node *gro,
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
index e74d99ca9face..b84fcd07c7230 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -315,14 +315,20 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
 
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
 	flush |= skb_cmp_decrypted(p, skb);
-- 
2.53.0



