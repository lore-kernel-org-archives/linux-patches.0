Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D92D3112C1;
	Sat, 30 May 2026 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164511; cv=none; b=qWiqyAc3HubX8fua8z3RReTM/FoP1Ug4OSVOStefOPwuxeZCm1jA/v/0sphNaNQiizpVTwoQmUj4tVsSzk7PjsJ3j/W5+u2OeUsqj1X7MP5xwsqZJBI+gR/bAzPnvrlABw7YL1GKbbxr7gl2yDHz2XbmTbg1yWYOcbJjxbSlwkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164511; c=relaxed/simple;
	bh=rcl7cAI4VQW86Nh0w2xFghy1xJfrSrEz9XN9TpA6XSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaUKdidt86zV2+7FsWM+6/VAwK/2gvu/L6rE+m4i2XM0eqG0N82+a0qg8FUoQoNK0b5b8qv0zohOUlFDktjYWJZyioEyZf+m90UaVkB+jMgnwAhFKivr21jNtMwIx7a45xYBTlXDE6PfuSGsnlObCGvOfSrUkUuCbI/N+fC0tTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMREq9bA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMREq9bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6161F00893;
	Sat, 30 May 2026 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164510;
	bh=S/vY8unXXtP+I/1ELnPTrRtRz9QmijNy+Qr/SACcTys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMREq9bADwr9rbceNL0/wFhFRGuuedR8Xsi8ddCKXP5Hm3FVb0eTSqI3pRJBZjIQf
	 L1Mkrl93oTcHQ3SgV9Tp6LDc80LfLEC47rmr4M6J3xBpGdwGOpTUoozpabBfd498lH
	 JY5SgJFmuB/jQQjmeCNXIj8mC04KqqGxSjMP7rPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingnan Zhang <342144303@qq.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 576/776] ipvs: fix MTU check for GSO packets in tunnel mode
Date: Sat, 30 May 2026 18:04:50 +0200
Message-ID: <20260530160254.982912193@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f82834349ca2c..9e199f00eea73 100644
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
 
@@ -240,7 +251,7 @@ static inline bool ensure_mtu_is_adequate(struct netns_ipvs *ipvs, int skb_af,
 			return true;
 
 		if (unlikely(ip_hdr(skb)->frag_off & htons(IP_DF) &&
-			     skb->len > mtu && !skb_is_gso(skb) &&
+			     ip_vs_exceeds_mtu(skb, mtu) &&
 			     !ip_vs_iph_icmp(ipvsh))) {
 			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				  htonl(mtu));
-- 
2.53.0



