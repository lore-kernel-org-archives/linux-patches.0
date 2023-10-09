Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4988B1A592
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KeQDe074"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A88C433C8;
	Mon,  9 Oct 2023 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858757;
	bh=UH0OEMJuIIK2PLSg8Hd4lS6MsZlT+hlACZEiuSNyD5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeQDe074XkcnzlDDHQA4eFVUkDHfVV7I5wdc8sATIiq4hKqaOOen1BLSQYVezG3Dy
	 1OhF93lE/49Tjm9YB1/2AcZ6h9tWXjj6oJEpUK6urkLd1b0CzogV/8fW04gKKaGaZy
	 spMeukzUFJ+mZiOY9dluxPflswrdjGlX4cWJ3QH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/226] netfilter: nf_tables: double hook unregistration in netns path
Date: Mon,  9 Oct 2023 15:00:24 +0200
Message-ID: <20231009130128.431993160@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit f9a43007d3f7ba76d5e7f9421094f00f2ef202f8 upstream.

[ This backport includes ab5e5c062f67 ("netfilter: nf_tables: use
  kfree_rcu(ptr, rcu) to release hooks in clean_net path") ]

__nft_release_hooks() is called from pre_netns exit path which
unregisters the hooks, then the NETDEV_UNREGISTER event is triggered
which unregisters the hooks again.

[  565.221461] WARNING: CPU: 18 PID: 193 at net/netfilter/core.c:495 __nf_unregister_net_hook+0x247/0x270
[...]
[  565.246890] CPU: 18 PID: 193 Comm: kworker/u64:1 Tainted: G            E     5.18.0-rc7+ #27
[  565.253682] Workqueue: netns cleanup_net
[  565.257059] RIP: 0010:__nf_unregister_net_hook+0x247/0x270
[...]
[  565.297120] Call Trace:
[  565.300900]  <TASK>
[  565.304683]  nf_tables_flowtable_event+0x16a/0x220 [nf_tables]
[  565.308518]  raw_notifier_call_chain+0x63/0x80
[  565.312386]  unregister_netdevice_many+0x54f/0xb50

Unregister and destroy netdev hook from netns pre_exit via kfree_rcu
so the NETDEV_UNREGISTER path see unregistered hooks.

Fixes: 767d1216bff8 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 54 ++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index efbcf85cd6b7a..16e2500e8590b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -303,12 +303,18 @@ static int nft_netdev_register_hooks(struct net *net,
 }
 
 static void nft_netdev_unregister_hooks(struct net *net,
-					struct list_head *hook_list)
+					struct list_head *hook_list,
+					bool release_netdev)
 {
-	struct nft_hook *hook;
+	struct nft_hook *hook, *next;
 
-	list_for_each_entry(hook, hook_list, list)
+	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		if (release_netdev) {
+			list_del(&hook->list);
+			kfree_rcu(hook, rcu);
+		}
+	}
 }
 
 static int nf_tables_register_hook(struct net *net,
@@ -334,9 +340,10 @@ static int nf_tables_register_hook(struct net *net,
 	return nf_register_net_hook(net, &basechain->ops);
 }
 
-static void nf_tables_unregister_hook(struct net *net,
-				      const struct nft_table *table,
-				      struct nft_chain *chain)
+static void __nf_tables_unregister_hook(struct net *net,
+					const struct nft_table *table,
+					struct nft_chain *chain,
+					bool release_netdev)
 {
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
@@ -351,11 +358,19 @@ static void nf_tables_unregister_hook(struct net *net,
 		return basechain->type->ops_unregister(net, ops);
 
 	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
-		nft_netdev_unregister_hooks(net, &basechain->hook_list);
+		nft_netdev_unregister_hooks(net, &basechain->hook_list,
+					    release_netdev);
 	else
 		nf_unregister_net_hook(net, &basechain->ops);
 }
 
+static void nf_tables_unregister_hook(struct net *net,
+				      const struct nft_table *table,
+				      struct nft_chain *chain)
+{
+	return __nf_tables_unregister_hook(net, table, chain, false);
+}
+
 static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net;
@@ -6822,13 +6837,25 @@ static void nft_unregister_flowtable_hook(struct net *net,
 				    FLOW_BLOCK_UNBIND);
 }
 
-static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct list_head *hook_list)
+static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct list_head *hook_list,
+					         bool release_netdev)
 {
-	struct nft_hook *hook;
+	struct nft_hook *hook, *next;
 
-	list_for_each_entry(hook, hook_list, list)
+	list_for_each_entry_safe(hook, next, hook_list, list) {
 		nf_unregister_net_hook(net, &hook->ops);
+		if (release_netdev) {
+			list_del(&hook->list);
+			kfree_rcu(hook, rcu);
+		}
+	}
+}
+
+static void nft_unregister_flowtable_net_hooks(struct net *net,
+					       struct list_head *hook_list)
+{
+	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -9472,9 +9499,10 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 	struct nft_chain *chain;
 
 	list_for_each_entry(chain, &table->chains, list)
-		nf_tables_unregister_hook(net, table, chain);
+		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list);
+		__nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list,
+						     true);
 }
 
 static void __nft_release_hooks(struct net *net)
-- 
2.40.1



