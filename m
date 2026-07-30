Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2895469847;
	Thu, 30 Jul 2026 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427497; cv=none; b=FouK9oBxhxI8adCTWB9Up8mv5KdVoHIo9NSZUQosOBNSBznCIgbdjjeu+iC11KOgazb+pmnMo7iYTQR7/c6Eg4SPYQcDy4Vfoexp5MSHdSp7tIULBfrhMSjQCXgPMwjut7wUEf1QS8J+v1Vs/K1+NfmHU7JO5EfoxtxX5RrBVb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427497; c=relaxed/simple;
	bh=H4Nv8dXHl4/QnicMvcgyvyKo7tnnEpmcJdjwsP7fVQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA6T561RWRZJFDDfzs/a+cOIjqQOWdscmLn9t+ninPTPMn18Ed0sGxhu3W53qbTQsa9L7jpuBGVtV0XruLM8S66gs6cCHDO9wQWHJR4e5VlTr8Tu29Y6OKHLcZhrIsdQeXP5bnx6LQtIL8Mw+uzDhV7y64wneIFLssgjF8FPUNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgW2LEtT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgW2LEtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088271F00A3A;
	Thu, 30 Jul 2026 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427496;
	bh=aZPc5SKqBQHjDEcz+pY0ZWnXflB5sPWw9g7G0ZIMwwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgW2LEtTHbkve/5eiHcy9+CUVi8PAOEq/o3PfJxUBAVmHMBC7mDzwh48u57XYl0ct
	 fr275Q+FUUQi9+7UTOD5arHBuv99KBHna9gduifNL85UDLFlGBEO6d+ZShDalRYR6/
	 ukavO0kSfkXJXvSJFcZXryamii+jvi6fILy/STWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ziad <muhzi100@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/484] ipv4: icmp: fill flow parameters in icmp_route_lookup decoy lookup
Date: Thu, 30 Jul 2026 16:11:29 +0200
Message-ID: <20260730141427.638515036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

[ Upstream commit 853e164c2b321f0711361bc23505aaeb7dc432c3 ]

When Linux forwards a packet and needs to generate an ICMP error,
icmp_route_lookup() performs a reverse-path relookup. For non-local
destinations, it performs a decoy lookup to find the expected egress
interface (rt2->dst.dev) before validating the path with ip_route_input().

Currently, the decoy flow structure (fl4_2) only sets .daddr = fl4_dec.saddr,
leaving .saddr, .flowi4_dscp, .flowi4_proto, .flowi4_mark, .flowi4_oif,
.fl4_sport, .fl4_dport, and .flowi4_uid zeroed out.

When policy routing rules (such as ip rule add from $SRC lookup 100, or
dscp/fwmark/ipproto/port rules, or VRF bindings) are configured:
1. The decoy lookup fails to match the policy rule because saddr and other
   key flow selectors are missing in fl4_2.
2. It resolves a route using the default table instead, returning an incorrect
   egress netdev.
3. Passing the wrong netdev to ip_route_input() causes strict reverse-path
   filtering (rp_filter=1) to fail, logging false-positive "martian source"
   warnings and causing the relookup to fail.

Fix this by initializing fl4_2 from fl4_dec and:
- Swapping source/destination IP addresses.
- Swapping L4 ports for transport protocols with ports (TCP, UDP, SCTP, DCCP)
  so port-based policy routing matches correctly. Non-port protocols (such as
  ICMP or GRE) leave the flowi_uli union fields intact to prevent corruption.
- Setting .flowi4_oif = l3mdev_master_ifindex(route_lookup_dev) to ensure
  VRF routing tables are respected.
- Setting .flowi4_flags |= FLOWI_FLAG_ANYSRC to allow output route lookups
  for non-local source IP addresses.
- Using __ip_route_output_key() instead of ip_route_output_key() for fl4_2
  so that raw FIB routing is used without triggering spurious XFRM policy
  lookups on the decoy flow (the actual XFRM lookup is performed later using
  fl4_dec).

Fixes: 415b3334a21a ("icmp: Fix regression in nexthop resolution during replies.")
Reported-by: Muhammad Ziad <muhzi100@gmail.com>
Closes: https://lore.kernel.org/netdev/CAOAwikA60AYKdFr_UDLyja3oU4hqyAE7uFZWqum5uRdaQsgRYg@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260722104236.2938082-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 3fcf11f83d87bd..7c4c7b7fe38468 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -536,11 +536,23 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 		if (IS_ERR(rt2))
 			err = PTR_ERR(rt2);
 	} else {
-		struct flowi4 fl4_2 = {};
+		struct flowi4 fl4_2 = fl4_dec;
 		unsigned long orefdst;
 
-		fl4_2.daddr = fl4_dec.saddr;
-		rt2 = ip_route_output_key(net, &fl4_2);
+		swap(fl4_2.daddr, fl4_2.saddr);
+		switch (fl4_2.flowi4_proto) {
+		case IPPROTO_TCP:
+		case IPPROTO_UDP:
+		case IPPROTO_SCTP:
+		case IPPROTO_DCCP:
+			swap(fl4_2.fl4_sport, fl4_2.fl4_dport);
+			break;
+		}
+
+		fl4_2.flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
+		fl4_2.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+
+		rt2 = __ip_route_output_key(net, &fl4_2);
 		if (IS_ERR(rt2)) {
 			err = PTR_ERR(rt2);
 			goto relookup_failed;
-- 
2.53.0



