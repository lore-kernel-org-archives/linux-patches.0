Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4D13C10AB;
	Tue, 21 Jul 2026 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674121; cv=none; b=QiouEN5GhJWX0Z8Jml0wH8nU5HQzsQnMQV6Slj3iEaEuYLdCqtGgzDg+RbXvTwNWoGGlhGzAf1kdrrFPtHYDtIzS2u2MYYSPIMVFJGr9tUuPlKtnx8QMa655NCT6S1MWwisDufm9MUMtiLHMdnwctC9VNy8b+oPNp9p/y9rZzoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674121; c=relaxed/simple;
	bh=FR7ji6Wu5WKJUbGCWKpikh0dltCGL94t8YUwv0Vlr5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErTEexL+xwtO+LJH6c4rUN1tIfgF+IpE5dCBQ0/gcHz4sChwB8sxxvDro7HZKCvNgp22jIDvBD/zGq78asDuFo+Kvx+k57T/j+t2zLEKZXPLHpAWYFouIDBiUZknWQe9SZb0ZnsZPbDAJaCEZdGxekSr+CTMzxDsGBCAkR7zRCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEn4iucu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEn4iucu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291DF1F00A3A;
	Tue, 21 Jul 2026 22:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674120;
	bh=r3611gKwA/H/EqTMMvY7nLzez+jmEB02cEdv0Q7nsHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEn4iucuDQ5byefyNyessys6hPBRtgKuG4nbKT6ke9HrI2J5Ce/Eh+Kj1qGVZllf+
	 N899I1uRBmFrq2zgg8zbTuh4oYYTUCdM6wy8LguAPeE45yH88CmBfHTFBoYWoh8qhk
	 yEJNqCFva35IWgs/o9iUn5efPJy1gBeI/zw9cBhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/699] ipvs: fix PMTU for GUE/GRE tunnel ICMP errors
Date: Tue, 21 Jul 2026 17:23:01 +0200
Message-ID: <20260721152405.212827839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 6b335af0d0d1ff44ac579d106953bf19299e5233 ]

When an ICMP Fragmentation Needed error is received for a tunneled IPVS
connection, ip_vs_in_icmp() recomputes the MTU that the original packet
can use by subtracting the tunnel overhead from the reported next-hop
MTU.

The current code always subtracts sizeof(struct iphdr), which is only
the IPIP overhead. For GUE and GRE tunnels, ipvs_udp_decap() and
ipvs_gre_decap() already compute the additional tunnel header length,
but that value is scoped to the decapsulation block and is lost before
the ICMP_FRAG_NEEDED handling. As a result, the ICMP error sent back to
the client advertises an MTU that is too large, so PMTUD can fail to
converge for GUE/GRE-tunneled real servers.

With a reported next-hop MTU of 1400, a GUE tunnel currently returns
1380 to the client. The correct value is 1368:

  1400 - sizeof(struct iphdr) - sizeof(struct udphdr) -
  sizeof(struct guehdr)

Hoist the tunnel header length into the main ip_vs_in_icmp() scope and
subtract sizeof(struct iphdr) + ulen in the Fragmentation Needed path.
The IPIP path keeps ulen as 0, so its existing 1400 - 20 = 1380 result
is unchanged.

Fixes: 508f744c0de3 ("ipvs: strip udp tunnel headers from icmp errors")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 3f7a535ff0fa ("ipvs: ensure inner headers in ICMP errors are in headroom")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 9d9af5a754a955..3a338f20fb6c07 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1653,6 +1653,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	bool tunnel, new_cp = false;
 	union nf_inet_addr *raddr;
 	char *outer_proto = "IPIP";
+	int ulen = 0;
 
 	*related = 1;
 
@@ -1717,7 +1718,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		   /* Error for our tunnel must arrive at LOCAL_IN */
 		   (skb_rtable(skb)->rt_flags & RTCF_LOCAL)) {
 		__u8 iproto;
-		int ulen;
 
 		/* Non-first fragment has no UDP/GRE header */
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
@@ -1822,8 +1822,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 				if (dest_dst)
 					mtu = dst_mtu(dest_dst->dst_cache);
 			}
-			if (mtu > 68 + sizeof(struct iphdr))
-				mtu -= sizeof(struct iphdr);
+			if (mtu > 68 + sizeof(struct iphdr) + ulen)
+				mtu -= sizeof(struct iphdr) + ulen;
 			info = htonl(mtu);
 		}
 		/* Strip outer IP, ICMP and IPIP/UDP/GRE, go to IP header of
-- 
2.53.0



