Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488DAA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9072C433D2;
	Tue, 10 Jan 2023 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374055;
	bh=dxvRW6dFLhKgPgWUlDfu+Oq5yPu/CSlBU1d0/Ct9OvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvR8vKnlnl8/2nbd6ESl2BqY6f+lWvK5Q/QUtXinxpbrTUKL3FYnQo9ZkgMucAimA
	 z44tMNUDWuMZ2/T2BL5X3PBbk6cel7wBl9d0gVERLkJb0vns0rvUIlFJhKCQKDwWHc
	 rnjgFybAG3rczYDI/EHKEHfFO5zDH77kT1qkE74I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Antoine Tenart <atenart@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 020/148] net: vrf: determine the dst using the original ifindex for multicast
Date: Tue, 10 Jan 2023 19:02:04 +0100
Message-Id: <20230110180017.842221790@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit f2575c8f404911da83f25b688e12afcf4273e640 ]

Multicast packets received on an interface bound to a VRF are marked as
belonging to the VRF and the skb device is updated to point to the VRF
device itself. This was fine even when a route was associated to a
device as when performing a fib table lookup 'oif' in fib6_table_lookup
(coming from 'skb->dev->ifindex' in ip6_route_input) was set to 0 when
FLOWI_FLAG_SKIP_NH_OIF was set.

With commit 40867d74c374 ("net: Add l3mdev index to flow struct and
avoid oif reset for port devices") this is not longer true and multicast
traffic is not received on the original interface.

Instead of adding back a similar check in fib6_table_lookup determine
the dst using the original ifindex for multicast VRF traffic. To make
things consistent across the function do the above for all strict
packets, which was the logic before commit 6f12fa775530 ("vrf: mark skb
for multicast or link-local as enslaved to VRF"). Note that reverting to
this behavior should be fine as the change was about marking packets
belonging to the VRF, not about their dst.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20221220171825.1172237-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 5df7a0abc39d..f7f40e3fe9cc 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1385,8 +1385,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
-	 * For strict packets with a source LLA, determine the dst using the
-	 * original ifindex.
+	 * For non-loopback strict packets, determine the dst using the original
+	 * ifindex.
 	 */
 	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
@@ -1395,7 +1395,7 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 		if (skb->pkt_type == PACKET_LOOPBACK)
 			skb->pkt_type = PACKET_HOST;
-		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
+		else
 			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
 
 		goto out;
-- 
2.35.1



