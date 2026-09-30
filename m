Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEB24F7CDC;
	Wed, 30 Sep 2026 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782955; cv=none; b=S+7bideHFRXW3Z59VOcx2p4kE83uxd/rasnFbHaVgGUrF69OGG74iHolHQM8gnCo82X0wsFCircAJq5OWZ7aqR+oriDjY7qWi0Gw8zSP0zQ1aAoOXEwwpK1tLOD1A5T7JQWHc0ZDx7V35bxN3aRewGgO0TqSNxXdyvolknRqxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782955; c=relaxed/simple;
	bh=GnlHEweG3hX8uS5a0eX/UXYdTyBhrEG7o+iqZ06uWZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jL4CgTWlhbtkzQ6vJF3hhy0v635bdO2Qx+WJtb6JWmVBaTh2ZSmPxZ5pFwjnaHjpxTObUg97lBntqoKkbQRb9N0tlusGa0eIH6DcJob5XFJ51holoHKYujROtjBw3U8yu3VQuYj21ruzlMYR+W+z/2WPqjSijYuiGwUK6tWES0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLbrzZto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLbrzZto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC001F00898;
	Wed, 30 Sep 2026 15:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782947;
	bh=9hcIS0QdnFt+aTVg5aMWBvWAViBF5rALIqcWOvqhsRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLbrzZto5HzM3mBCyEsznPU4nnCqsY55a2gK6ehdwH1wFwEn0XnJzx9EWRnzjpnnt
	 LUvb1fEblCCa9YIwHsZObyN+uz0FAcskQ+VxdePjD2LW0cr1syk+TYbfgtwB+R9zDQ
	 A354y++PvDpcIuO4DQXiOkzAGKwl9I+FQBYVu12Q=
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
Subject: [PATCH 5.10 209/595] ipv6: sr: restore network header before routing and forwarding
Date: Wed, 30 Sep 2026 17:21:42 +0200
Message-ID: <20260930152352.230791082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 0230fa98a3482..53b79a83e0e53 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -439,7 +439,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 	hdr->segments_left--;
 	addr = hdr->segments + hdr->segments_left;
 
-	skb_push(skb, sizeof(struct ipv6hdr));
+	skb_push(skb, -skb_network_offset(skb));
 
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
 		seg6_update_csum(skb);
@@ -465,7 +465,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 		}
 		ipv6_hdr(skb)->hop_limit--;
 
-		skb_pull(skb, sizeof(struct ipv6hdr));
+		skb_pull(skb, skb_transport_offset(skb));
 		goto looped_back;
 	}
 
-- 
2.53.0



