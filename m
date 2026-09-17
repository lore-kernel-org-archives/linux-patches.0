Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555544E73D1;
	Thu, 17 Sep 2026 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665564; cv=none; b=gvF5ZkYWWsBcCFbzEfiOnS4AlpJUT76g2W8XjYYou9QbE5FXe96AVoiZYlqcIWIHmN7GUf9wgcpbVsj1VwwHQbQM3DLmkbI56yrHfHE8ZApeZezCamVkYS00QS5HCQMtHOEivTNDgLchPC/k4pwxySa/TXtGrXOdoFos07S0Ceo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665564; c=relaxed/simple;
	bh=ERVv8G0veUflmbHX1nkkEJeYOA6gO74dkaNX61lt9r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LU5whQk3SauStp5q/cpIg/XLrY3fXSom3rOG7Ht+ow4n9uI1fmt/ATt0UXE3fsFTsQJfprgcL2wl1+3JLuv7pXvmOYuXCzL63gTwzP4LDbJugGKXVLlVFKVG78fXyMiY3tVBzbyoeiiQv0R6+xo7jR1jAPZUJtm3+Y/Nm99OEUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNTXQt/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNTXQt/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970E21F000FF;
	Thu, 17 Sep 2026 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665563;
	bh=i3PvYe6XTShcE1RERXqrEEHKqpdo//qBsKMaz9gML5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNTXQt/rZdBk/w8qxCMeRE/q0khjS3wJF2E4C7xGTPUAZg8Y47fRyJcDTU/thPClU
	 H87Ph4xOJt59pIIpyFsCnCNnJRg6muvm5zGix5VnDE2G4Hi21482HiofISBofkte4A
	 4o5y2RMt2vw3CAZvrIlI5gDIOnE3U4MWt3v+mxwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoping Shu <zhaoping.shu@mediatek.com>,
	HW He <hw.he@mediatek.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0747/1250] net: gro: Fix nesting of TCP GSO SKBs in skb_gro_receive_list()
Date: Thu, 17 Sep 2026 16:09:02 +0100
Message-ID: <20260917151612.131583638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HW He <hw.he@mediatek.com>

[ Upstream commit 66817a9794263cd2a5dc4e99bf8e5fcc5ff7181e ]

Fraglist GRO and hardware GRO can create an fraglist of
HW-GRO packets. This cannot be segmented back into
the original form on TCP tethering scenario.

Avoid constructing such a GSO packet, by flushing an already
built fraglist GRO packet if a hardware GRO packet arrives.

Scenario (Tethering/Forwarding):
1.Driver submits a single TCP packet, P1. P1 is kept in the
gro_list as the first packet.

2. The driver submits a TCP GSO skb, P2. P2 has already aggregated
multiple TCP packets by HW_GRO, and its non-linear data is stored in
frags[].

3. P1 and P2 match the GRO rules, and since there is no local socket,
they are aggregated by skb_gro_receive_list(). The resulting skb,
P3, has a frag_list entry that still contains frags[]:
P3: [ Linear Data ] -> frag_list -> [ Linear Data ]
                                    [ frag[1] ]
                                    [ frag[2] ]
                                    ...
4. Later, tcp4_gso_segment() or tcp6_gso_segment() calls
skb_segment_list() to segment P3. However, skb_segment_list() only
segments the entries in frag_list. It does not segment the frags[]
inside P2, so P3 is not restored to the original packets, which leads
to IP fragmentation or packet drop in the following path.

Check skb_is_gso(skb) and current GRO method, make sure fraglist GRO
applies to consecutive non-GSO skb, others adopt regular GRO path.

Fixes: 8d95dc474f85 ("net: add code for TCP fraglist GRO")
Signed-off-by: Zhaoping Shu <zhaoping.shu@mediatek.com>
Signed-off-by: HW He <hw.he@mediatek.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260901082312.14596-1-zhaoping.shu@mediatek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_offload.c   | 22 ++++++++++++++++------
 net/ipv6/tcpv6_offload.c | 15 +++++++++++++--
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index ed4bc3209c973..3ae6b4e0763c0 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -360,6 +360,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
 		flush |= skb->ip_summed != p->ip_summed;
 		flush |= skb->csum_level != p->csum_level;
 		flush |= NAPI_GRO_CB(p)->count >= 64;
+		flush |= NAPI_GRO_CB(p)->is_flist != NAPI_GRO_CB(skb)->is_flist;
 		skb_set_network_header(skb, skb_gro_receive_network_offset(skb));
 
 		if (flush || skb_gro_receive_list(p, skb))
@@ -423,12 +424,20 @@ static void tcp4_check_fraglist_gro(struct list_head *head, struct sk_buff *skb,
 	struct net *net;
 	int iif, sdif;
 
-	if (likely(!(skb->dev->features & NETIF_F_GRO_FRAGLIST)))
-		return;
-
 	p = tcp_gro_lookup(head, th);
 	if (p) {
-		NAPI_GRO_CB(skb)->is_flist = NAPI_GRO_CB(p)->is_flist;
+		/* flist GRO applies to consecutive non-GSO skbs */
+		if (!skb_is_gso(skb) || !NAPI_GRO_CB(p)->is_flist) {
+			NAPI_GRO_CB(skb)->is_flist = NAPI_GRO_CB(p)->is_flist;
+			return;
+		}
+
+		/* Fall back to the regular GRO path */
+		if (NAPI_GRO_CB(p)->count == 1)
+			NAPI_GRO_CB(p)->is_flist = 0;
+
+		NAPI_GRO_CB(skb)->is_flist = 0;
+
 		return;
 	}
 
@@ -438,7 +447,7 @@ static void tcp4_check_fraglist_gro(struct list_head *head, struct sk_buff *skb,
 	sk = __inet_lookup_established(net, iph->saddr, th->source,
 				       iph->daddr, ntohs(th->dest),
 				       iif, sdif);
-	NAPI_GRO_CB(skb)->is_flist = !sk;
+	NAPI_GRO_CB(skb)->is_flist = !sk && !skb_is_gso(skb);
 	if (sk)
 		sock_gen_put(sk);
 }
@@ -458,7 +467,8 @@ struct sk_buff *tcp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 	if (!th)
 		goto flush;
 
-	tcp4_check_fraglist_gro(head, skb, th);
+	if (unlikely(skb->dev->features & NETIF_F_GRO_FRAGLIST))
+		tcp4_check_fraglist_gro(head, skb, th);
 
 	return tcp_gro_receive(head, skb, th);
 
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 5670d32c27f80..798a63267ff24 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -29,7 +29,18 @@ static void tcp6_check_fraglist_gro(struct list_head *head, struct sk_buff *skb,
 
 	p = tcp_gro_lookup(head, th);
 	if (p) {
-		NAPI_GRO_CB(skb)->is_flist = NAPI_GRO_CB(p)->is_flist;
+		/* flist GRO applies to consecutive non-GSO skbs */
+		if (!skb_is_gso(skb) || !NAPI_GRO_CB(p)->is_flist) {
+			NAPI_GRO_CB(skb)->is_flist = NAPI_GRO_CB(p)->is_flist;
+			return;
+		}
+
+		/* Fall back to the regular GRO path */
+		if (NAPI_GRO_CB(p)->count == 1)
+			NAPI_GRO_CB(p)->is_flist = 0;
+
+		NAPI_GRO_CB(skb)->is_flist = 0;
+
 		return;
 	}
 
@@ -39,7 +50,7 @@ static void tcp6_check_fraglist_gro(struct list_head *head, struct sk_buff *skb,
 	sk = __inet6_lookup_established(net, &hdr->saddr, th->source,
 					&hdr->daddr, ntohs(th->dest),
 					iif, sdif);
-	NAPI_GRO_CB(skb)->is_flist = !sk;
+	NAPI_GRO_CB(skb)->is_flist = !sk && !skb_is_gso(skb);
 	if (sk)
 		sock_gen_put(sk);
 #endif /* IS_ENABLED(CONFIG_IPV6) */
-- 
2.53.0



