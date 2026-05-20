Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1D43D75DA;
	Wed, 20 May 2026 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296697; cv=none; b=KHD7WfWprPSXl15botq++Ic4ChC3nYRrfyRqZ/rFUQ5yH6w+JIbbBK5tlWu15e11zsEtfaRnHP7VIiscf9w8uKNKq/EJsCfHBk4HEPKK1ieCGnj8fkyLRdVkZ6eFBOq6kvXjUyIC4MaNwZhh/U9IIjV56YsCw+Wrz6Yh2rmk1pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296697; c=relaxed/simple;
	bh=a8KeOSjYQ6ViMP6q+KKg6+bvcRvdrMXMb5W0J/G5ukY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qkgj63o93YivBIMpI7/SbhYhtqAeGli2vt+MwRcNSo2fZLg+UfidVBpYAbYHf7yNic6XozptpzIGL5+Q4+WWsutZXkDQxD+b/+E/2oTrNp/1OO7QRJyM+E5kS47W/LwV9U+4ish8WJ2528hDO49x4/mdsT0NFh3BrbycC4JomJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7GB6j0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7GB6j0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8153A1F00894;
	Wed, 20 May 2026 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296696;
	bh=GJutnci1SsfpKEsw9vDlzRPZdffjvCRUjww+cZCMu84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7GB6j0idwDQkR+Ae5dZSTYSLRnLoGmmPHMCNvs5AXrPZdcYVHm1V7rJYkgn/tFwi
	 daJysLc0JyyWH80cctEssS6tHYDH78akiqGoX3EpVCdQ9ghPZH9UdA+kVG833HbNTZ
	 s7aZOZicPrT8Hy2pYkflQlTW+uJ9JPLiaotAomlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0896/1146] netfilter: nf_tables: use list_del_rcu for netlink hooks
Date: Wed, 20 May 2026 18:19:06 +0200
Message-ID: <20260520162208.513290744@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f3224ee463f8f6f6ced7dcdf6081add4f8128527 ]

nft_netdev_unregister_hooks and __nft_unregister_flowtable_net_hooks need
to use list_del_rcu(), this list can be walked by concurrent dumpers.

Add a new helper and use it consistently.

Fixes: f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration in netns path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 44 ++++++++++++++---------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c42247a176c7..090d4d688a333 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -374,6 +374,12 @@ static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
 	call_rcu(&hook->rcu, __nft_netdev_hook_free_rcu);
 }
 
+static void nft_netdev_hook_unlink_free_rcu(struct nft_hook *hook)
+{
+	list_del_rcu(&hook->list);
+	nft_netdev_hook_free_rcu(hook);
+}
+
 static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
@@ -384,10 +390,8 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
 			nf_unregister_net_hook(net, ops);
-		if (release_netdev) {
-			list_del(&hook->list);
-			nft_netdev_hook_free_rcu(hook);
-		}
+		if (release_netdev)
+			nft_netdev_hook_unlink_free_rcu(hook);
 	}
 }
 
@@ -2323,10 +2327,8 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 
 		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
-						 &basechain->hook_list, list) {
-				list_del_rcu(&hook->list);
-				nft_netdev_hook_free_rcu(hook);
-			}
+						 &basechain->hook_list, list)
+				nft_netdev_hook_unlink_free_rcu(hook);
 		}
 		module_put(basechain->type->owner);
 		if (rcu_access_pointer(basechain->stats)) {
@@ -3026,6 +3028,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				list_for_each_entry(ops, &h->ops_list, list)
 					nf_unregister_net_hook(ctx->net, ops);
 			}
+			/* hook.list is on stack, no need for list_del_rcu() */
 			list_del(&h->list);
 			nft_netdev_hook_free_rcu(h);
 		}
@@ -8903,10 +8906,8 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list)
 			nft_unregister_flowtable_ops(net, flowtable, ops);
-		if (release_netdev) {
-			list_del(&hook->list);
-			nft_netdev_hook_free_rcu(hook);
-		}
+		if (release_netdev)
+			nft_netdev_hook_unlink_free_rcu(hook);
 	}
 }
 
@@ -8977,8 +8978,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 			nft_unregister_flowtable_ops(net, flowtable, ops);
 		}
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
+		nft_netdev_hook_unlink_free_rcu(hook);
 	}
 
 	return err;
@@ -8988,10 +8988,8 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
 
-	list_for_each_entry_safe(hook, next, hook_list, list) {
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
-	}
+	list_for_each_entry_safe(hook, next, hook_list, list)
+		nft_netdev_hook_unlink_free_rcu(hook);
 }
 
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
@@ -9079,8 +9077,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 				nft_unregister_flowtable_ops(ctx->net,
 							     flowtable, ops);
 		}
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
+		nft_netdev_hook_unlink_free_rcu(hook);
 	}
 
 	return err;
@@ -9586,13 +9583,8 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 
 static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 {
-	struct nft_hook *hook, *next;
-
 	flowtable->data.type->free(&flowtable->data);
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		list_del_rcu(&hook->list);
-		nft_netdev_hook_free_rcu(hook);
-	}
+	nft_hooks_destroy(&flowtable->hook_list);
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
 	kfree(flowtable);
-- 
2.53.0



