Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E889B3F1AD9;
	Wed, 20 May 2026 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299205; cv=none; b=Q1beyrNC4LRJ+KwU3W1BtddmPESrjRi3X8/4DiRuBRpArxnfizvpq35/EOAZOg3k5WAnAn/KfGL/AgUCEnh4KyhmJKl1l3Ilrz6o2EP9fVsbFC1/qXwndKgVQJmR5d0DFKhKVEXnmoLIozyCD0VOfzNErCDCd8FFiUFVw9N7XFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299205; c=relaxed/simple;
	bh=yXtT8VctCHuPbNPbR/9/M4zxTXA3KOLI93IqOj47zc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGd3s2yf7diHJsWcCXCtdOqNuNny+gAB2cU4gg+PMlJH3/NcfRH2Mh5j1/H/sm9mglCRaKMU8yQwapeuZzyx6I3uy/naqTDoqqiMwuLJhFuMvrS2yJQZXDymUWRRYDwfS4/6z8LBh5j+XSS8PsaLlqPsiDyLGwxFx4NDRvhta/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eceKLjUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eceKLjUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CD31F000E9;
	Wed, 20 May 2026 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299203;
	bh=IFpSEWqsOfjXHp3H3I+NKT2T0ttTIIkP9gdkQts9Zr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eceKLjUoX8zF05LvNjztji7h4ioW7cUc7Oxx81098Hlj0Vvg+K7+ts1KFfwtwFhkw
	 R0nIOu1tyd8E0QbqKE7BxuWp3N8MDRnRakWpXvj+zC92ONJuCc1EuY+VT3grqL0LbN
	 QcpUQg7UOv96PWCnZyhkTC0911JJuAytkp3C7QK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingnan Zhang <342144303@qq.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 665/957] ipvs: fix MTU check for GSO packets in tunnel mode
Date: Wed, 20 May 2026 18:19:08 +0200
Message-ID: <20260520162148.954134951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Yingnan Zhang <342144303@qq.com>

[ Upstream commit 67bf42cae41d847fd6e5749eb68278ca5d748b25 ]

Currently, IPVS skips MTU checks for GSO packets by excluding them with
the !skb_is_gso(skb) condition. This creates problems when IPVS tunnel
mode encapsulates GSO packets with IPIP headers.

The issue manifests in two ways:

1. MTU violation after encapsulation:
   When a GSO packet passes through IPVS tunnel mode, the original MTU
   check is bypassed. After adding the IPIP tunnel header, the packet
   size may exceed the outgoing interface MTU, leading to unexpected
   fragmentation at the IP layer.

2. Fragmentation with problematic IP IDs:
   When net.ipv4.vs.pmtu_disc=1 and a GSO packet with multiple segments
   is fragmented after encapsulation, each segment gets a sequentially
   incremented IP ID (0, 1, 2, ...). This happens because:

   a) The GSO packet bypasses MTU check and gets encapsulated
   b) At __ip_finish_output, the oversized GSO packet is split into
      separate SKBs (one per segment), with IP IDs incrementing
   c) Each SKB is then fragmented again based on the actual MTU

   This sequential IP ID allocation differs from the expected behavior
   and can cause issues with fragment reassembly and packet tracking.

Fix this by properly validating GSO packets using
skb_gso_validate_network_len(). This function correctly validates
whether the GSO segments will fit within the MTU after segmentation. If
validation fails, send an ICMP Fragmentation Needed message to enable
proper PMTU discovery.

Fixes: 4cdd34084d53 ("netfilter: nf_conntrack_ipv6: improve fragmentation handling")
Signed-off-by: Yingnan Zhang <342144303@qq.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index ecbcdc43263d6..fc254d1f59de9 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -103,6 +103,18 @@ __ip_vs_dst_check(struct ip_vs_dest *dest)
 	return dest_dst;
 }
 
+/* Based on ip_exceeds_mtu(). */
+static bool ip_vs_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
+{
+	if (skb->len <= mtu)
+		return false;
+
+	if (skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu))
+		return false;
+
+	return true;
+}
+
 static inline bool
 __mtu_check_toobig_v6(const struct sk_buff *skb, u32 mtu)
 {
@@ -112,10 +124,9 @@ __mtu_check_toobig_v6(const struct sk_buff *skb, u32 mtu)
 		 */
 		if (IP6CB(skb)->frag_max_size > mtu)
 			return true; /* largest fragment violate MTU */
-	}
-	else if (skb->len > mtu && !skb_is_gso(skb)) {
+	} else if (ip_vs_exceeds_mtu(skb, mtu))
 		return true; /* Packet size violate MTU size */
-	}
+
 	return false;
 }
 
@@ -233,7 +244,7 @@ static inline bool ensure_mtu_is_adequate(struct netns_ipvs *ipvs, int skb_af,
 			return true;
 
 		if (unlikely(ip_hdr(skb)->frag_off & htons(IP_DF) &&
-			     skb->len > mtu && !skb_is_gso(skb) &&
+			     ip_vs_exceeds_mtu(skb, mtu) &&
 			     !ip_vs_iph_icmp(ipvsh))) {
 			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				  htonl(mtu));
-- 
2.53.0



