Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302993ACA54;
	Thu, 17 Sep 2026 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668912; cv=none; b=DrAJgfZRuANnBecBvFNhrLiIYezOQjmTmPHkQ5JfKcj0NyHTf/kElLQlCULPwNeh/Q/QijdNcewu/3stvUtkY/K79pV/B+lGYex9RFzjtRG/vK59Ytw5GHyrAu/oOzaosX/KM57yCzSBecn+h2Qh/uFUYrLAQ81gDp0fNEi0m38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668912; c=relaxed/simple;
	bh=98EDrvtR+Cc5Qhip4nzoBx4aN71XPocKTRQ/VlBskvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncFL5PPdaGK4zHsxfp3VJ2oHlFpMHUCdhXSM0rWWBr2mLiVb8Lj8b0lAkM5VbEMfzBBds5BRdxVG7Dj++eq7JJrSMXu7zViXa4QmVWFQaIqvmTnu5Mcwn94qXL5YWoNmNaE6zQJe+4lpCsYQDpMmv2rRggLzWUqKRLBizGYTou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2x6CrW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2x6CrW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D071F000FF;
	Thu, 17 Sep 2026 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668910;
	bh=tj//22cVnLKMzDas6eXf5VFhxfeKbCHheCxjfr/tkoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2x6CrW/I3e+a3kYyoHZVyN+b3d0IdPt0ssefNLLUFumrkEG+HC92ovycRTWpySf7
	 d1/qR6PKvhSTAxCiMVLKHZm17+Auz7bIAbzbojepXSl99Vy9SoH6CO1x9pRF1KFBQv
	 FyjhqIARPHkZkyLww6dCzZ+2kZN3ItTzP7uq+TbY=
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
Subject: [PATCH 6.12 0581/1102] ipv6: sr: restore network header before routing and forwarding
Date: Thu, 17 Sep 2026 16:08:44 +0100
Message-ID: <20260917151554.534035474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e91afe5ec0b5d..e7a343b72224c 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -455,7 +455,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 	hdr->segments_left--;
 	addr = hdr->segments + hdr->segments_left;
 
-	skb_push(skb, sizeof(struct ipv6hdr));
+	skb_push(skb, -skb_network_offset(skb));
 
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
 		seg6_update_csum(skb);
@@ -479,7 +479,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 		}
 		ipv6_hdr(skb)->hop_limit--;
 
-		skb_pull(skb, sizeof(struct ipv6hdr));
+		skb_pull(skb, skb_transport_offset(skb));
 		goto looped_back;
 	}
 
-- 
2.53.0



