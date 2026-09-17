Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8CB50E5A6;
	Thu, 17 Sep 2026 17:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666394; cv=none; b=S0X1qKUnDT02vuJy55JBPbnY6+53+hhVAmCA6eC7gLTPfaC4He+w2Hq3dLZu/hsmaDZA2+VJfWDQhoMAlv2K4tgajbHoA8CckCVUNd6obdHtRt/vcgXe/x55NIr8CrUAir3Laqp3WjGSMcqtwbRFXvs81mQc8hICv4tC0GeEuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666394; c=relaxed/simple;
	bh=y0GqzxjfEbWfnuQRTWhGhy64lwbbMMzf/NA7c4JeVZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUCNKSNf7ICDfUKeuwHjGHRHxiqVZfQWR7isb3wXoel3L3dpQEwD25oHe5M+ZwMQPbgJ8rMkDY7ZN52Hr8fEdDiBmXqw6WJtvGT9AbaNRpL3focSINeipc5hrcS7BbcNckGIPkIZbfHNEBva4QPF+8FwsTZUfSxtB0m6W0jo7JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deRBGS5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deRBGS5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541BA1F000FF;
	Thu, 17 Sep 2026 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666392;
	bh=9yy7lpQ6uYfrO++4jXAMkmbvXxq6+Hx674OdTpl0VJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=deRBGS5DSdqMQ+7tO7Xggk5jdmIhqYhWWXR6hpcP4i7K9iZDW0yBIurbvW2QMN6wg
	 4Y6+o1BZXDSYKdcHwchB3OKwJWd45d66z8rFO95HzqnPS5D+XanrVOAIyFi0cqF8Jv
	 o32OPDsN+sIppRxpPFCe+GkpUHlxH3VZSdOWV7NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laika Price <laikabcprice@gmail.com>,
	Yaroslav Dudkov <aroslavdudkov622@gmail.com>,
	Charles Bordet <rough.rock3059@datachamp.fr>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0984/1250] tunnels: Drop stale dst when building an ICMP error for PMTUD
Date: Thu, 17 Sep 2026 16:12:59 +0100
Message-ID: <20260917151618.695027483@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

commit b58d749633203d92c265317b45fccee555090352 upstream.

Bridged UDP tunnels such as VXLAN and GENEVE build an ICMP error packet
around an overlay packet if the packet is going to exceed the underlay
path MTU. The ICMP error packet is then injected back into the Rx path
with the source and destination addresses swapped, so that it will be
delivered to the overlay source.

If the overlay packet was routed to the UDP tunnel or locally generated,
then it is already carrying a valid dst entry and this entry is not
dropped when transforming the packet to an ICMP error packet. This
causes the IP layer to reuse the dst entry, leading to the ICMP error
packet being dropped or routed out of the UDP tunnel interface in case
of forwarding.

Prior to the blamed commit this could not happen, as
skb_tunnel_check_pmtu() did not build ICMP errors for PACKET_HOST
packets. Such packets were instead encapsulated and, unless the DF bit
was set in the outer header, fragmented by the underlay.

Fix this by making sure that the ICMP error packet does not have a valid
dst entry, thereby forcing the IP layer to perform a route lookup.

Adjust the bridged PMTU exception selftests accordingly. When the
local sender in ns_a pings the overlay destination with a deadline
(-w), ping exits on the first socket error before any reply is
received and returns a non-zero exit code. The test therefore only
passed because the ICMP error was never delivered. Use a packet count
(-c) like the ns_c line above it, so that the ICMP error counts
against the packet budget and the exit code depends on whether echo
replies were received. This passes with and without the fix.

Fixes: 8930424777e4 ("tunnels: Accept PACKET_HOST in skb_tunnel_check_pmtu().")
Cc: stable@vger.kernel.org
Reported-by: Laika Price <laikabcprice@gmail.com>
Closes: https://lore.kernel.org/netdev/20260614-master-v3-1-9f5060ba1ed1@gmail.com/
Reported-by: Yaroslav Dudkov <aroslavdudkov622@gmail.com>
Closes: https://lore.kernel.org/netdev/20260901081825.287173-1-aroslavdudkov622@gmail.com/
Reported-by: Charles Bordet <rough.rock3059@datachamp.fr>
Closes: https://lore.kernel.org/netdev/aHVhQLPJIhq-SYPM@eldamar.lan/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Yaroslav Dudkov <aroslavdudkov622@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20260902190112.4126199-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c           |    6 ++++++
 tools/testing/selftests/net/pmtu.sh |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -268,6 +268,9 @@ static int iptunnel_pmtud_build_icmp(str
 	eth_header(skb, skb->dev, ntohs(eh.h_proto), eh.h_source, eh.h_dest, 0);
 	skb_reset_mac_header(skb);
 
+	if (skb_valid_dst(skb))
+		skb_dst_drop(skb);
+
 	return skb->len;
 }
 
@@ -371,6 +374,9 @@ static int iptunnel_pmtud_build_icmpv6(s
 	eth_header(skb, skb->dev, ntohs(eh.h_proto), eh.h_source, eh.h_dest, 0);
 	skb_reset_mac_header(skb);
 
+	if (skb_valid_dst(skb))
+		skb_dst_drop(skb);
+
 	return skb->len;
 }
 
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1457,7 +1457,7 @@ test_pmtu_ipvX_over_bridged_vxlanY_or_ge
 	mtu "${ns_b}" ${type}_b $((${ll_mtu} + 1000))
 
 	run_cmd ${ns_c} ${ping} -q -M want -i 0.1 -c 10 -s $((${ll_mtu} + 500)) ${dst} || return 1
-	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1  -s $((${ll_mtu} + 500)) ${dst} || return 1
+	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -c 10 -s $((${ll_mtu} + 500)) ${dst} || return 1
 
 	# Check that exceptions were created
 	pmtu="$(route_get_dst_pmtu_from_exception "${ns_c}" ${dst})"


