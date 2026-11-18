Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018779;
	b=bKlJPZSzcnSVmHoGOmHE52LsN75ORUiNbeixtEKbpuhqZWW2vRyt6+AspJ7FNnBO2hqc
	 uQ+fnwdmzhqVznKKj/HWvBkW68r+4PPBmyKs4eqEOZNBPnA0jx3ZjiXI4C1w1pkmzQAC3
	 b93V4FrJyCDy3xnGgwtpw0KYDUWV20nt72JlcxE7i+uVldymy8HySTycm1hIHsMnCY2An
	 HbLiav494QGcQXRbcs9qDfZOZhVSubvd1CnZJgH1QXa5NNyYNySVHYzxRTU5sCTBJKGoV
	 Wx9N8mnppiGZm5ZHxLWgBlbaWKx8nBho3vBxJlUlV/Wl7FKlOrwvIauc1QDJMyWgyrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eqfQNo98wrPHWeYqpcyEfxC2fGnflA039MmcIS5Q4r8=;
	b=cF+3MG8+kGE6dmQmLLRUBSfGdks/smPiUxNxoeVpbWGaRpheWEc/83LPJf6WdlwBWh4d
	 TVtkIF16q7wh8PKwHgvQQhf23rFYxyxHRsTCObhDl6ObUy3+9VKewHdA/3ueGukJ2obPl
	 V84j/5fa5FTDCNoqEXWKd8wPrP9zqRQXhd1POINzsN4Q4m5UOEhaddarvEP3TaTcIXXxO
	 ufOlQgRF1k8gVh0a96mPPxyX2z/dp5TSXY99IJcOUW266ft2DQ8wH8qscHXxU3Ffl2TLW
	 YX9gUKu3NVPl8AUvTTnB+rEOmeW5IhpWeVOJiOdmsargDzwERi4LG/4BdmfwUKDtsWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5d783TW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E57C606A331;
	Wed, 18 Nov 2026 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5d783TW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F761F000C4;
	Wed, 18 Nov 2026 16:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018779;
	bh=eqfQNo98wrPHWeYqpcyEfxC2fGnflA039MmcIS5Q4r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5d783TWEVj2spoowlFI4x/oRlNGlHKoWDS5t7PFERNp2+X6nC3yc4OUvBfb5Rr1X
	 tcU+sQq0uoufUKEsRKbLxuv4YIOk4kN/Z2QATKigd8ZBcWoPGYJFpnr6kFRPAghKoi
	 A7xRhJX6u3OsulfaoCGQxToWQADHIjsDoB6YG0Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1362/2651] ipv4: reserve one IP ID per segment for UDP GSO packets
Date: Wed, 18 Nov 2026 15:43:22 +0100
Message-ID: <20261118150337.058569874@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 852c08d6a99149dc71c51cea125b5083f555237e ]

__ip_make_skb() reserves a single IP ID for UDP GSO packets, but GSO
assigns one IP ID per segment. Following packets then reuse these IDs,
either from inet->inet_id or from the shared generator.

Unless IP_PMTUDISC_DO/PROBE is used, DF is not set on UDP GSO packets,
so segments can be fragmented on the path and IP ID reuse can lead to
incorrect reassembly.

Reserve one IP ID per segment, using the same test as udp_send_skb().

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930144018.1174068-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index eaa6fabda347e..3396f177a18d0 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1414,6 +1414,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	struct iphdr *iph;
 	u8 pmtudisc, ttl;
 	__be16 df = 0;
+	int segs;
 
 	skb = __skb_dequeue(queue);
 	if (!skb)
@@ -1468,7 +1469,19 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
-	ip_select_ident(net, skb, sk);
+
+	/* UDP GSO packets are segmented later (see udp_send_skb()):
+	 * reserve one IP ID per segment.
+	 */
+	segs = 1;
+	if (cork->gso_size && sk_is_udp(sk)) {
+		int datalen = skb->len - skb_transport_offset(skb) -
+			      sizeof(struct udphdr);
+
+		if (datalen > cork->gso_size)
+			segs = DIV_ROUND_UP(datalen, cork->gso_size);
+	}
+	ip_select_ident_segs(net, skb, sk, segs);
 
 	if (opt) {
 		iph->ihl += opt->optlen >> 2;
-- 
2.53.0



