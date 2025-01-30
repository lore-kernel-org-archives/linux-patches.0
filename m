Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6D61E6DCF;
	Thu, 30 Jan 2025 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246905; cv=none; b=eLL3qeJMiJRWRfKolG44wfaeSMtZAPhXIeEqXNM1RYctW0Veh3nVuBKcaE7p/P43W9S+aYBKmTeAgwOK8SPkpnx609yAvsM1JkorKzpJogTiaIE7E98Qs0vXVu6qJVjFXftE1g1R2R9fEuUCT+RaOvwCuUlpS0oF6T2fHlForeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246905; c=relaxed/simple;
	bh=zSEBRGjZZCCdVzJbHQIKU7+3ghwRap7l/l5AMzACClE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+eltzKAyHP1ln7DqvZZQd9oX3SrXL/srDGgGyG8P7elG9Hu+Kz1YdVYLCwIrP6RWLtddbR97B98UGgsT7h7mCD1MmMNj8VICEDNp5D0iUM+/v7j2Bzrfx6TU0bHRtlPAUc+xkCLJj8q2a2gbnzq8L3Gbjt8EdRUbCL/O+9hKCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4oXihWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4oXihWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44D7C4CED2;
	Thu, 30 Jan 2025 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246905;
	bh=zSEBRGjZZCCdVzJbHQIKU7+3ghwRap7l/l5AMzACClE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4oXihWyr8M9NzV3T3qd70s1H/eHfZ691lVjVfNhmsubI7snWY7nBWIsiW+FBm0tT
	 t2V4r+4XnDZgmk9vglpRNFfi8nnqdVrmUh3QHttqHpoYsdIeXm2fC7dqh6xZszX/g+
	 iua9nQ5nuo9j6bbgUljSV1T977LcYbS39nrn14Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/133] netfilter: nf_tables: imbalance in flowtable binding
Date: Thu, 30 Jan 2025 15:00:05 +0100
Message-ID: <20250130140143.160579016@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28ea2ed3f337..d4c9ea4fda9c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7006,6 +7006,7 @@ static void nft_unregister_flowtable_hook(struct net *net,
 }
 
 static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct nft_flowtable *flowtable,
 						 struct list_head *hook_list,
 					         bool release_netdev)
 {
@@ -7013,6 +7014,8 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+					    FLOW_BLOCK_UNBIND);
 		if (release_netdev) {
 			list_del(&hook->list);
 			kfree_rcu(hook, rcu);
@@ -7021,9 +7024,10 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 }
 
 static void nft_unregister_flowtable_net_hooks(struct net *net,
+					       struct nft_flowtable *flowtable,
 					       struct list_head *hook_list)
 {
-	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
+	__nft_unregister_flowtable_net_hooks(net, flowtable, hook_list, false);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -7645,8 +7649,6 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 
 	flowtable->data.type->free(&flowtable->data);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 	}
@@ -8787,6 +8789,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_DELFLOWTABLE);
 				nft_unregister_flowtable_net_hooks(net,
+								   nft_trans_flowtable(trans),
 								   &nft_trans_flowtable_hooks(trans));
 			} else {
 				list_del_rcu(&nft_trans_flowtable(trans)->list);
@@ -8795,6 +8798,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   &nft_trans_flowtable(trans)->hook_list,
 							   NFT_MSG_DELFLOWTABLE);
 				nft_unregister_flowtable_net_hooks(net,
+						nft_trans_flowtable(trans),
 						&nft_trans_flowtable(trans)->hook_list);
 			}
 			break;
@@ -9014,11 +9018,13 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
@@ -9582,7 +9588,8 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
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



