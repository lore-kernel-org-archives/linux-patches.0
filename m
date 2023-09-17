Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5397461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C08FC433C8;
	Sun, 17 Sep 2023 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980155;
	bh=hMEletprRqEIdeMQWJ2ikzpmvq7A/K03EOMTNoEhL4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSexr2C1onfpREVCHoT0O6EL//OSukMSxO2hofbpPkO/CCaW+c5ore7TBxu91v3dE
	 IpCCJOk9dUpZ9OUpoW0g92mqLBgZTJB50g9DSrP/5T1hLoBvd09oSLXV1yMhRZttF9
	 a54peUxq7C1Re6T6uzKOGKzIAN5dNMp6hjJDzfxg=
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
Subject: [PATCH 6.5 111/285] net: fib: avoid warn splat in flow dissector
Date: Sun, 17 Sep 2023 21:11:51 +0200
Message-ID: <20230917191055.501113839@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 05e6f756feafe..9ba6413fd2e3e 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -604,7 +604,10 @@ static inline bool fib6_rules_early_flow_dissect(struct net *net,
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
index a378eff827c74..f0c13864180e2 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -418,7 +418,10 @@ static inline bool fib4_rules_early_flow_dissect(struct net *net,
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



