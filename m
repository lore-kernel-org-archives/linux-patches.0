Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC70D387588;
	Tue, 21 Jul 2026 20:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667069; cv=none; b=CCohk/gGRmdqu1Cz/oD6wjGUhwnxxEdIqUTkIqh8uhynGkT3WTKrDGNBGagVAFaCWtCYjB2kK33WNVtf3GVS4q8tTMEqpoNRVVXJurVjZWy42cj/P9ihveOZ8CDoULvECI+rVV4vAxhWlO6+59RrFeASDE3hhf6CjB8y+EprsuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667069; c=relaxed/simple;
	bh=3NK1YdKPQ3CuZJ3spvFzvTaKySpxElJyuoF6tHwyt64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtEK268LQhkGMxAiDGg4nH3YoaHClGrqGlGsgimWe9V7lCy+SiALuvy/GgvtwbaHJZvCr6JhIDKPAo45Hai8CgCA/Ma8q5qmwByeQmlmIMhP8VJhSCgbvTOetA34EvCQy5khVqXO8HSRkNL15sqmWQsSrrTQv8m5i0SYOpuQEow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdFM5QUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdFM5QUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6251F000E9;
	Tue, 21 Jul 2026 20:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667067;
	bh=YGHYQERND83Wnp1XxmX9BfwyRCFyWOoWydJFgtsYAQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdFM5QUno5pP5qF/Z3fLoamqtBqKPEUm8yYoY7+BlRY2SxG60OWk0Rz4919gTKr8v
	 KIu2vOUifTNM8zjX4fvYtiUKXU3QIRoeLHJl/YGDmCLA05EsTGA99743+5IRAl/q6R
	 qyZon+qsWO0kB9QfLWDd6gB7/gYZTRsLziE8g5SE=
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
Subject: [PATCH 6.6 0877/1266] ipvs: fix PMTU for GUE/GRE tunnel ICMP errors
Date: Tue, 21 Jul 2026 17:21:54 +0200
Message-ID: <20260721152501.473065270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0fa8f04f7a1c3..e6b0053672759f 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1585,6 +1585,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	bool tunnel, new_cp = false;
 	union nf_inet_addr *raddr;
 	char *outer_proto = "IPIP";
+	int ulen = 0;
 
 	*related = 1;
 
@@ -1649,7 +1650,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		   /* Error for our tunnel must arrive at LOCAL_IN */
 		   (skb_rtable(skb)->rt_flags & RTCF_LOCAL)) {
 		__u8 iproto;
-		int ulen;
 
 		/* Non-first fragment has no UDP/GRE header */
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
@@ -1754,8 +1754,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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



