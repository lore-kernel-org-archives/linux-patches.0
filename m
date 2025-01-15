Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A4248BD1;
	Wed, 15 Jan 2025 10:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938633; cv=none; b=Gu8h5liDNxZZ6B8EBRq5yr2WmcCa/Iqj3nBsPCwoSO1yLEl1ffJ/owLW2gJQ79LqsQgfF7JLoQaDV91L4k+NCxTaiEWrvw6Z1Z2gH8w99mnyrgKwStIFXkrrDSocAKRYDKbPiMvgfEVNySRaL/DK1ut7pjCt6f0f9HHFWDTb9P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938633; c=relaxed/simple;
	bh=+CvVKcydw7hN65nZLkhDWML4Ibb/5X4NFAVrUdFUlng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km7PHKmC5hYfi4HnEM3JLCOnWAy61ln1/chTB0R3fnBegrILKrls15tisB/6YtN3piZ0GI9SHkMyO0S2cbz1DfKtReXqHwEVV7Cqd9oYEQV7X34J0arWJxqysoGXrTe2fvV6y/H6UuLbrpCu5JwmgN7CQ1/SitgzEZulLPMu+LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwhTfu/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwhTfu/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAE8C4CEDF;
	Wed, 15 Jan 2025 10:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938633;
	bh=+CvVKcydw7hN65nZLkhDWML4Ibb/5X4NFAVrUdFUlng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwhTfu/cCNgUhG+FrGuRuBsyWdjXAHErOQOs8c9TOheGslyxoZv838GHztHuSigHv
	 LeMYVbfc95tx5CjfA0ao/YhXahdNQQsFHjQlYEW/McyKVDv5382nyshroSY7g+zxzP
	 U3Im3hSMMMx0ci/ZKwRvnK/TJYv9molHydq1qwsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/129] netfilter: nf_tables: imbalance in flowtable binding
Date: Wed, 15 Jan 2025 11:36:57 +0100
Message-ID: <20250115103556.052798229@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 13210fc63f353fe78584048079343413a3cdf819 ]

All these cases cause imbalance between BIND and UNBIND calls:

- Delete an interface from a flowtable with multiple interfaces

- Add a (device to a) flowtable with --check flag

- Delete a netns containing a flowtable

- In an interactive nft session, create a table with owner flag and
  flowtable inside, then quit.

Fix it by calling FLOW_BLOCK_UNBIND when unregistering hooks, then
remove late FLOW_BLOCK_UNBIND call when destroying flowtable.

Fixes: ff4bf2f42a40 ("netfilter: nf_tables: add nft_unregister_flowtable_hook()")
Reported-by: Phil Sutter <phil@nwl.cc>
Tested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a110aad45fe4..1d1e998acd67 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8375,6 +8375,7 @@ static void nft_unregister_flowtable_hook(struct net *net,
 }
 
 static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct nft_flowtable *flowtable,
 						 struct list_head *hook_list,
 					         bool release_netdev)
 {
@@ -8382,6 +8383,8 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_UNBIND);
 		if (release_netdev) {
 			list_del(&hook->list);
 			kfree_rcu(hook, rcu);
@@ -8390,9 +8393,10 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 }
 
 static void nft_unregister_flowtable_net_hooks(struct net *net,
+					       struct nft_flowtable *flowtable,
 					       struct list_head *hook_list)
 {
-	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
+	__nft_unregister_flowtable_net_hooks(net, flowtable, hook_list, false);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -9028,8 +9032,6 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 
 	flowtable->data.type->free(&flowtable->data);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 	}
@@ -10399,6 +10401,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   &nft_trans_flowtable_hooks(trans),
 							   trans->msg_type);
 				nft_unregister_flowtable_net_hooks(net,
+								   nft_trans_flowtable(trans),
 								   &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
@@ -10407,6 +10410,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   NULL,
 							   trans->msg_type);
 				nft_unregister_flowtable_net_hooks(net,
+						nft_trans_flowtable(trans),
 						&nft_trans_flowtable(trans)->hook_list);
 			}
 			break;
@@ -10659,11 +10663,13 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_NEWFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
 				nft_unregister_flowtable_net_hooks(net,
+						nft_trans_flowtable(trans),
 						&nft_trans_flowtable_hooks(trans));
 			} else {
 				nft_use_dec_restore(&trans->ctx.table->use);
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
 				nft_unregister_flowtable_net_hooks(net,
+						nft_trans_flowtable(trans),
 						&nft_trans_flowtable(trans)->hook_list);
 			}
 			break;
@@ -11224,7 +11230,8 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	list_for_each_entry(chain, &table->chains, list)
 		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		__nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list,
+		__nft_unregister_flowtable_net_hooks(net, flowtable,
+						     &flowtable->hook_list,
 						     true);
 }
 
-- 
2.39.5



