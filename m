Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC908746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E99C433C9;
	Sun, 17 Sep 2023 20:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983048;
	bh=hvqXLMvh4PnQZIn2CTOAPb2mg9MTjAeOLcPHF4OQWqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUG0d/Ccomo9W4gWhbRKtn9n684Y3K3cKcCg6fVUYeVL6QTPN7xuNTJJnv3Rko/Wr
	 qmE7n1WK4mHGt8RwjLSeEPx0JZENb3RH04MBKhuNoBCckDSXlOoZdE5Z0/bffg8MsA
	 v1fUerBiRo7zi8PPe6CZyoTppxXQG8BoYmLANyDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Florian Westphal <fw@strlen.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/511] net: fib: avoid warn splat in flow dissector
Date: Sun, 17 Sep 2023 21:14:17 +0200
Message-ID: <20230917191124.150691887@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8aae7625ff3f0bd5484d01f1b8d5af82e44bec2d ]

New skbs allocated via nf_send_reset() have skb->dev == NULL.

fib*_rules_early_flow_dissect helpers already have a 'struct net'
argument but its not passed down to the flow dissector core, which
will then WARN as it can't derive a net namespace to use:

 WARNING: CPU: 0 PID: 0 at net/core/flow_dissector.c:1016 __skb_flow_dissect+0xa91/0x1cd0
 [..]
  ip_route_me_harder+0x143/0x330
  nf_send_reset+0x17c/0x2d0 [nf_reject_ipv4]
  nft_reject_inet_eval+0xa9/0xf2 [nft_reject_inet]
  nft_do_chain+0x198/0x5d0 [nf_tables]
  nft_do_chain_inet+0xa4/0x110 [nf_tables]
  nf_hook_slow+0x41/0xc0
  ip_local_deliver+0xce/0x110
  ..

Cc: Stanislav Fomichev <sdf@google.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Ido Schimmel <idosch@nvidia.com>
Fixes: 812fa71f0d96 ("netfilter: Dissect flow after packet mangling")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217826
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230830110043.30497-1-fw@strlen.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_fib.h | 5 ++++-
 include/net/ip_fib.h  | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index bbb27639f2933..d72cee4dff70b 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -610,7 +610,10 @@ static inline bool fib6_rules_early_flow_dissect(struct net *net,
 	if (!net->ipv6.fib6_rules_require_fldissect)
 		return false;
 
-	skb_flow_dissect_flow_keys(skb, flkeys, flag);
+	memset(flkeys, 0, sizeof(*flkeys));
+	__skb_flow_dissect(net, skb, &flow_keys_dissector,
+			   flkeys, NULL, 0, 0, 0, flag);
+
 	fl6->fl6_sport = flkeys->ports.src;
 	fl6->fl6_dport = flkeys->ports.dst;
 	fl6->flowi6_proto = flkeys->basic.ip_proto;
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 3417ba2d27ad6..c3324a1949c3a 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -415,7 +415,10 @@ static inline bool fib4_rules_early_flow_dissect(struct net *net,
 	if (!net->ipv4.fib_rules_require_fldissect)
 		return false;
 
-	skb_flow_dissect_flow_keys(skb, flkeys, flag);
+	memset(flkeys, 0, sizeof(*flkeys));
+	__skb_flow_dissect(net, skb, &flow_keys_dissector,
+			   flkeys, NULL, 0, 0, 0, flag);
+
 	fl4->fl4_sport = flkeys->ports.src;
 	fl4->fl4_dport = flkeys->ports.dst;
 	fl4->flowi4_proto = flkeys->basic.ip_proto;
-- 
2.40.1



