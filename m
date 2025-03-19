Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB0C1DEFD9;
	Wed, 19 Mar 2025 14:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395004; cv=none; b=MW0vBD9wQWxLKU4PTEFmNrFAna/bQ0Fw1/GWr6244KdE3Z1IhotMlwDf1eOiQ4bLCAjNDq+hsmAmGcySTjXX7YCIyz/AfZM92VsX/vHd13cQU0y2miXKR/ThMVetgqJw07of6T5OuWwWJZvK3M+bzq2mrwugDHwXPJu72LkARIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395004; c=relaxed/simple;
	bh=sw4Y1czwsDr5QYT3kJFOWltSjIyV2o8ZMH/535Gditw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2EDaWsshlIa2/rC4tZTWKN9ul37CsoBxSnMEFcNMipGxgYHVlbLeQMqp5vsTImI/4ca2ww21kI6AiiLVa69AIsq7Hx1R5umlOwPKiOI8ekuMCTDTCcXCUOwRM/LESJmccXGrJvKXp2vQGVzIy1Sf9Q7Ga+xdcPI0FXqu1v5Twk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfJcN9HD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfJcN9HD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CF9C4CEE4;
	Wed, 19 Mar 2025 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395004;
	bh=sw4Y1czwsDr5QYT3kJFOWltSjIyV2o8ZMH/535Gditw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfJcN9HDg7rdqlu+4YfF0GaF/UIVk0UMWnXsLAujnKIdKO0BFcpmuDKmtZF7ryV3l
	 shWgYDqm2XaRQGcp2Yfb6jY0BSZ9m8T0snNlATGLOybVBEL6ydf8O4100P/Ftg70qV
	 6qm+q6XoayuRqoDdzNtXsdb+jckZnzwsV/P1q2AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/231] netfilter: nf_tables: make destruction work queue pernet
Date: Wed, 19 Mar 2025 07:28:25 -0700
Message-ID: <20250319143027.160658745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit fb8286562ecfb585e26b033c5e32e6fb85efb0b3 ]

The call to flush_work before tearing down a table from the netlink
notifier was supposed to make sure that all earlier updates (e.g. rule
add) that might reference that table have been processed.

Unfortunately, flush_work() waits for the last queued instance.
This could be an instance that is different from the one that we must
wait for.

This is because transactions are protected with a pernet mutex, but the
work item is global, so holding the transaction mutex doesn't prevent
another netns from queueing more work.

Make the work item pernet so that flush_work() will wait for all
transactions queued from this netns.

A welcome side effect is that we no longer need to wait for transaction
objects from foreign netns.

The gc work queue is still global.  This seems to be ok because nft_set
structures are reference counted and each container structure owns a
reference on the net namespace.

The destroy_list is still protected by a global spinlock rather than
pernet one but the hold time is very short anyway.

v2: call cancel_work_sync before reaping the remaining tables (Pablo).

Fixes: 9f6958ba2e90 ("netfilter: nf_tables: unconditionally flush pending work before notifier")
Reported-by: syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_tables_api.c     | 24 ++++++++++++++----------
 net/netfilter/nft_compat.c        |  8 ++++----
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 788513cc384b7..757abcb54d117 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1889,7 +1889,7 @@ void nft_chain_filter_fini(void);
 void __init nft_chain_route_init(void);
 void nft_chain_route_fini(void);
 
-void nf_tables_trans_destroy_flush_work(void);
+void nf_tables_trans_destroy_flush_work(struct net *net);
 
 int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
 __be64 nf_jiffies64_to_msecs(u64 input);
@@ -1903,6 +1903,7 @@ static inline int nft_request_module(struct net *net, const char *fmt, ...) { re
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct list_head	destroy_list;
 	struct list_head	commit_set_list;
 	struct list_head	binding_list;
 	struct list_head	module_list;
@@ -1913,6 +1914,7 @@ struct nftables_pernet {
 	unsigned int		base_seq;
 	unsigned int		gc_seq;
 	u8			validate_state;
+	struct work_struct	destroy_work;
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 939510247ef5a..eb3a6f96b094d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -31,7 +31,6 @@ unsigned int nf_tables_net_id __read_mostly;
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
-static LIST_HEAD(nf_tables_destroy_list);
 static LIST_HEAD(nf_tables_gc_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
 static DEFINE_SPINLOCK(nf_tables_gc_list_lock);
@@ -122,7 +121,6 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 	table->validate_state = new_validate_state;
 }
 static void nf_tables_trans_destroy_work(struct work_struct *w);
-static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
 
 static void nft_trans_gc_work(struct work_struct *work);
 static DECLARE_WORK(trans_gc_work, nft_trans_gc_work);
@@ -9748,11 +9746,12 @@ static void nft_commit_release(struct nft_trans *trans)
 
 static void nf_tables_trans_destroy_work(struct work_struct *w)
 {
+	struct nftables_pernet *nft_net = container_of(w, struct nftables_pernet, destroy_work);
 	struct nft_trans *trans, *next;
 	LIST_HEAD(head);
 
 	spin_lock(&nf_tables_destroy_list_lock);
-	list_splice_init(&nf_tables_destroy_list, &head);
+	list_splice_init(&nft_net->destroy_list, &head);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
 	if (list_empty(&head))
@@ -9766,9 +9765,11 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 	}
 }
 
-void nf_tables_trans_destroy_flush_work(void)
+void nf_tables_trans_destroy_flush_work(struct net *net)
 {
-	flush_work(&trans_destroy_work);
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	flush_work(&nft_net->destroy_work);
 }
 EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
@@ -10226,11 +10227,11 @@ static void nf_tables_commit_release(struct net *net)
 
 	trans->put_net = true;
 	spin_lock(&nf_tables_destroy_list_lock);
-	list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
+	list_splice_tail_init(&nft_net->commit_list, &nft_net->destroy_list);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
 	nf_tables_module_autoload_cleanup(net);
-	schedule_work(&trans_destroy_work);
+	schedule_work(&nft_net->destroy_work);
 
 	mutex_unlock(&nft_net->commit_mutex);
 }
@@ -11653,7 +11654,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work(net);
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
@@ -11695,6 +11696,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
+	INIT_LIST_HEAD(&nft_net->destroy_list);
 	INIT_LIST_HEAD(&nft_net->commit_set_list);
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
@@ -11703,6 +11705,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	nft_net->base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
+	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
 
 	return 0;
 }
@@ -11731,14 +11734,17 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	if (!list_empty(&nft_net->module_list))
 		nf_tables_module_autoload_cleanup(net);
 
+	cancel_work_sync(&nft_net->destroy_work);
 	__nft_release_tables(net);
 
 	nft_gc_seq_end(nft_net, gc_seq);
 
 	mutex_unlock(&nft_net->commit_mutex);
+
 	WARN_ON_ONCE(!list_empty(&nft_net->tables));
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
 }
 
 static void nf_tables_exit_batch(struct list_head *net_exit_list)
@@ -11829,10 +11835,8 @@ static void __exit nf_tables_module_exit(void)
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
 	nft_chain_route_fini();
-	nf_tables_trans_destroy_flush_work();
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	cancel_work_sync(&trans_gc_work);
-	cancel_work_sync(&trans_destroy_work);
 	rcu_barrier();
 	rhltable_destroy(&nft_objname_ht);
 	nf_tables_core_module_exit();
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7ca4f0d21fe2a..72711d62fddfa 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -228,7 +228,7 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	return 0;
 }
 
-static void nft_compat_wait_for_destructors(void)
+static void nft_compat_wait_for_destructors(struct net *net)
 {
 	/* xtables matches or targets can have side effects, e.g.
 	 * creation/destruction of /proc files.
@@ -236,7 +236,7 @@ static void nft_compat_wait_for_destructors(void)
 	 * work queue.  If we have pending invocations we thus
 	 * need to wait for those to finish.
 	 */
-	nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work(net);
 }
 
 static int
@@ -262,7 +262,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
 
-	nft_compat_wait_for_destructors();
+	nft_compat_wait_for_destructors(ctx->net);
 
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0) {
@@ -515,7 +515,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
 
-	nft_compat_wait_for_destructors();
+	nft_compat_wait_for_destructors(ctx->net);
 
 	return xt_check_match(&par, size, proto, inv);
 }
-- 
2.39.5



