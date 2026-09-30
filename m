Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590B33AFAE2;
	Wed, 30 Sep 2026 19:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795058; cv=none; b=fK36IFWZ3i+oRe3giqqEsFnD3XqXL/5dnuk3LD519tRM9w7K010hiMu/qL0yXPFgDF4pqEtwP/5KGT9lxvhG78c3zsYGkjowPU6FIIPPWIIgnY2T3RQRavxMiOI/DkzBFP/PkDl97hir7FoM7qcORuYIqIg0iWuGvAyfE3btd6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795058; c=relaxed/simple;
	bh=3FE3lb5SIC2EIbxrxpjAH3zaMEF2svscT9qNGiY4+Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAfL4Jw17/6PHa9OEF4g+vxEPRpIV4BcLXz21Eu7mzyMtUYLd1Nrs9Xl300y4J5hTIPl5rEgJVU3r75Fapx9fqzXlMgVzDbu4eTmWP69HtX1iH3EzbR4MkDbAxymDaH8Ws2zvs+vM57+ZE+j9qeTfxn//LB7YYSgeDAJoE8HMt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgRLSYGg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgRLSYGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D9F1F000FF;
	Wed, 30 Sep 2026 19:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795057;
	bh=7YmlLbMOCdkgNQzajRpg8XgEE3Yv7k2FutHzty+XCzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgRLSYGg1rcjRRZzcFvtt52fZ+CRw9PtfT1qyXU417Ynua+raNCAisfGYxeupwtrr
	 w8YYX/j9iYbDlDLiruDCHdKauXGvnFmoVE4f2/+5gXbM0iqob1rpIKgjAIQxmkGdVd
	 2qYeaPxzdPKrsT8ffjJSpPihUzY8vHBMP/YlUS1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Fourie Zhang <fouriezhang@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0429/1193] ipv6: sr: restore network header before routing and forwarding
Date: Wed, 30 Sep 2026 17:18:33 +0200
Message-ID: <20260930152443.728213881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 975b5b067f525a1b1338c4a3bee1c46545801518 ]

ipv6_srh_rcv() runs with skb->data at the Segment Routing Header (SRH)
while skb_network_header() points at the IPv6 header.

When segments_left > 0, ipv6_srh_rcv() previously restored the skb->data
position by pushing sizeof(struct ipv6hdr), assuming the SRH immediately
followed the fixed IPv6 header. If another extension header (such as a
Hop-by-Hop options header) precedes the SRH, skb_network_offset()
remained negative.

This led to two problems:
1. During ip6_route_input(), fib6_rules_early_flow_dissect() invokes
   __skb_flow_dissect() which passes the negative skb_network_offset()
   to flow dissection, breaking BPF and C flow dissector logic.
2. If forwarded via ip6_forward() or redirected via act_mirred, downstream
   handlers (like sch_fragment() or neighbour output) pass the negative
   offset as an unsigned length, triggering OOB memcpy or buffer overflows.

Fix this by pushing -skb_network_offset(skb) before routing, ensuring
skb_network_offset(skb) is 0 for route lookup / flow dissection as well as
downstream forwarding. On the loopback path, pull skb_transport_offset(skb)
to restore skb->data to the SRH before looping back.

Fixes: 1ababeba4a21 ("ipv6: implement dataplane support for rthdr type 4 (Segment Routing Header)")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Reported-by: Jun Yang <junvyyang@tencent.com>
Reported-by: Fourie Zhang <fouriezhang@tencent.com>
Closes: https://lore.kernel.org/netdev/20260817104128.22681-1-juny24602@gmail.com/
Closes: https://lore.kernel.org/netdev/20260827092345.2301937-1-fouriezhang@tencent.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828141727.2372570-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index e024d8da431c4..6b4cdc7745e85 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -454,7 +454,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 	hdr->segments_left--;
 	addr = hdr->segments + hdr->segments_left;
 
-	skb_push(skb, sizeof(struct ipv6hdr));
+	skb_push(skb, -skb_network_offset(skb));
 
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
 		seg6_update_csum(skb);
@@ -478,7 +478,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 		}
 		ipv6_hdr(skb)->hop_limit--;
 
-		skb_pull(skb, sizeof(struct ipv6hdr));
+		skb_pull(skb, skb_transport_offset(skb));
 		goto looped_back;
 	}
 
-- 
2.53.0



