Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831627;
	b=b9XMdDsxYJZN34oWIfbVERirT+cBEH0tC4Vd8CCDInvzo+MuRMvQxHMN8UPdDbP0K7PY
	 PeDzPrU/5odmQ8AmqUDulPHuhIO6Hs9ukg4UBSTrOixUOwAvBBYQcNje9Jj1zKp5Cyq1G
	 2MwxO2lXmxGDt9i3GNYK794ElZXtspAVCL7VCeAbwl2YdomHc9ZaIraGepuLB8AnZq0Z9
	 ALIA1EWKsGaQ2MStcu4YdUx2VRqSiBPjlRKiT3YcwSvJ7OyFxvk6zg0inWHL+km3Q5KYh
	 3mKL6TcAHOmkYXwRz6iaXOLATbD6WzWfv2pZS5nWPQ4A2xj9WEOahAa4bfPsjHkpXfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qCeG+CN6QPGMojwlPnLDpJ1l5BpcZ0nV2nMEqjL2Z1U=;
	b=oE7Qq3t3AWZCyb10uF2tKSERVpjdrC3kEPKoxNV3iMOz+e/2uz40pe1V9AI1+kyQ8Uws
	 YZnP3e2/8YGStEkr1e5QKVIpF8JCEq4sAja19QY77i4l/q+DKPw8mmsTvXBnnwlSoEK3+
	 q8GfMQahKYXkrzXC9Hb0aw6KJ9SzyfPa2XOsWEbvrPE/etJ1N35TWGgaSt8SIGOQ5nhPi
	 5kIgowphpMIMebro6OdNxCs+tE1K4V9zYvYe8SqWB9dEF4FlBeQZBGDAyeRP1uBEmqSrY
	 o1w3J+J2oRoUmZAOOPRN0NiMwOqr3FH84H6lSoXEZHypx6yrsZ92SdBCe0/dflk2Weg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtzZQA30;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64082606AC25;
	Wed,  4 Nov 2026 22:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtzZQA30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D261F000C1;
	Wed,  4 Nov 2026 22:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831627;
	bh=qCeG+CN6QPGMojwlPnLDpJ1l5BpcZ0nV2nMEqjL2Z1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtzZQA30iKGiFFP4Wk00Sjk3PfiKaj5aZEeBFlmFccYP8ryTY0lDyxjVn+BJMoxYF
	 p5KTGn0Bt8rOmnM62mO5SOcXNCByKf/6x5viWbPfLy0qdM4OAGRGnyWV/kfbhpn7+e
	 wPr1LtiIdtk1C+syqLDQbwoYFsmzj+Hynm2uQFoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0819/1005] netfilter: nf_tables: fix netdev hook allocation memleak with dormant tables
Date: Wed,  4 Nov 2026 16:09:12 -0500
Message-ID: <20261104211106.285135025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 63bac027860308d1344f761cb47aabb3b30973fd ]

sashiko says:
 could the related code in __nf_tables_abort() leak the struct nft_hook objects when the table is dormant?

 In __nf_tables_abort(), when rolling back a NEWCHAIN transaction that
 updates hooks, the code conditionally unregisters and frees the hooks only
 if the table is not dormant [..]
            if (!(table->flags & NFT_TABLE_F_DORMANT)) {
                nft_netdev_unregister_hooks(net,
                                            &nft_trans_chain_hooks(trans),
                                            true);
            }
            ...
            nft_trans_destroy(trans);

Unfortunately netdev family mixes hook registration and allocation.
Push table struct down and only check for the flag to unregister.

Fixes: 216e7bf7402c ("netfilter: nf_tables: skip netdev hook unregistration if table is dormant")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 31c3ff79b2d5c..76876761698eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -404,6 +404,7 @@ static void nft_netdev_unregister_trans_hook(struct net *net,
 }
 
 static void nft_netdev_unregister_hooks(struct net *net,
+					const struct nft_table *table,
 					struct list_head *hook_list,
 					bool release_netdev)
 {
@@ -411,8 +412,10 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	struct nf_hook_ops *ops;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		list_for_each_entry(ops, &hook->ops_list, list)
-			nf_unregister_net_hook(net, ops);
+		if (!(table->flags & NFT_TABLE_F_DORMANT)) {
+			list_for_each_entry(ops, &hook->ops_list, list)
+				nf_unregister_net_hook(net, ops);
+		}
 		if (release_netdev)
 			nft_netdev_hook_unlink_free_rcu(hook);
 	}
@@ -449,20 +452,25 @@ static void __nf_tables_unregister_hook(struct net *net,
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
 
-	if (table->flags & NFT_TABLE_F_DORMANT ||
-	    !nft_is_base_chain(chain))
+	if (!nft_is_base_chain(chain))
 		return;
 	basechain = nft_base_chain(chain);
 	ops = &basechain->ops;
 
+	/* must also be called for dormant tables */
+	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
+		nft_netdev_unregister_hooks(net, table, &basechain->hook_list,
+					    release_netdev);
+		return;
+	}
+
+	if (table->flags & NFT_TABLE_F_DORMANT)
+		return;
+
 	if (basechain->type->ops_unregister)
 		return basechain->type->ops_unregister(net, ops);
 
-	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
-		nft_netdev_unregister_hooks(net, &basechain->hook_list,
-					    release_netdev);
-	else
-		nf_unregister_net_hook(net, &basechain->ops);
+	nf_unregister_net_hook(net, &basechain->ops);
 }
 
 static void nf_tables_unregister_hook(struct net *net,
@@ -11296,11 +11304,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
-					nft_netdev_unregister_hooks(net,
-								    &nft_trans_chain_hooks(trans),
-								    true);
-				}
+				nft_netdev_unregister_hooks(net, table,
+							    &nft_trans_chain_hooks(trans),
+							    true);
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
-- 
2.53.0



