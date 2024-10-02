Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753C125771;
	Wed,  2 Oct 2024 13:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875220; cv=none; b=pjm3Mt60qmsji7CZaTmarBW4ZhLQk+9tHS4QAw65ui9Iu0SRJImeaCO7M9xjNXPglKxm0XzUa0FfrttiG/6PHYE1hc0CpYytueyjITvMeBLXOo+JpdHnFV3mLtERXw8enCZEuiliCM+/5G7aTQgtLad3lW69VRrY+o65HoKpGUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875220; c=relaxed/simple;
	bh=rY+6kHR5fMQi18nD/8yo9gjnKi+2obeGaextNckbvTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoC/Ml14RSdlMtdCS0IIagPEZn5RRaKeSc9gD3Pc8QX2NW+k4mCgjpWpfyXnyDpR3r7ihVXCgl0u9+ajgy280WPNK7eGkCXd1NrPR5OVoH8TNnPvW/6fg1yAqPfMrQRs0uZsq7adzJvFLFzg5w41FaD0iDY4istKwCSwuGzmbX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JV4gPR/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JV4gPR/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFDEC4CEC5;
	Wed,  2 Oct 2024 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875220;
	bh=rY+6kHR5fMQi18nD/8yo9gjnKi+2obeGaextNckbvTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JV4gPR/3cEwoCUl/bkLSFHZ8LeCwSjpVOTslGXG55Tl+tASXVeP2Sz5KXzJf24EoV
	 f5qAFtqCVV2WczLonphnLqmGEUHOb2plCkor3hLPCZwhcYbSxLidccaV6fgNWU3TwP
	 Xp+xqNHC84fb90320/12vV14Hv0LZ6wSl+iJQfh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 032/695] netfilter: nf_tables: store new sets in dedicated list
Date: Wed,  2 Oct 2024 14:50:30 +0200
Message-ID: <20241002125823.774338784@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c1aa38866b9c58dc6cf7a5fc6a3e1ca75565169e ]

nft_set_lookup_byid() is very slow when transaction becomes large, due to
walk of the transaction list.

Add a dedicated list that contains only the new sets.

Before: nft -f ruleset 0.07s user 0.00s system 0% cpu 1:04.84 total
After: nft -f ruleset 0.07s user 0.00s system 0% cpu 30.115 total

.. where ruleset contains ~10 sets with ~100k elements.
The above number is for a combined flush+reload of the ruleset.

With previous flush, even the first NEWELEM has to walk through a few
hundred thousands of DELSET(ELEM) transactions before the first NEWSET
object. To cope with random-order-newset-newsetelem we'd need to replace
commit_set_list with a hashtable.

Expectation is that a NEWELEM operation refers to the most recently added
set, so last entry of the dedicated list should be the set we want.

NB: This is not a bug fix per se (functionality is fine), but with
larger transaction batches list search takes forever, so it would be
nice to speed this up for -stable too, hence adding a "fixes" tag.

Fixes: 958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")
Reported-by: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 29 ++++++++++++++++++++---------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1bfdd16890fac..2be4738eae1cc 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1674,6 +1674,7 @@ struct nft_trans_rule {
 
 struct nft_trans_set {
 	struct nft_trans_binding	nft_trans_binding;
+	struct list_head		list_trans_newset;
 	struct nft_set			*set;
 	u32				set_id;
 	u32				gc_int;
@@ -1875,6 +1876,7 @@ static inline int nft_request_module(struct net *net, const char *fmt, ...) { re
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct list_head	commit_set_list;
 	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0a2f793469589..3ea5d01635107 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -393,6 +393,7 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans_binding *binding;
+	struct nft_trans_set *trans_set;
 
 	list_add_tail(&trans->list, &nft_net->commit_list);
 
@@ -402,9 +403,13 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWSET:
+		trans_set = nft_trans_container_set(trans);
+
 		if (!nft_trans_set_update(trans) &&
 		    nft_set_is_anonymous(nft_trans_set(trans)))
 			list_add_tail(&binding->binding_list, &nft_net->binding_list);
+
+		list_add_tail(&trans_set->list_trans_newset, &nft_net->commit_set_list);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		if (!nft_trans_chain_update(trans) &&
@@ -611,6 +616,7 @@ static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 
 	trans_set = nft_trans_container_set(trans);
 	INIT_LIST_HEAD(&trans_set->nft_trans_binding.binding_list);
+	INIT_LIST_HEAD(&trans_set->list_trans_newset);
 
 	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] && !desc) {
 		nft_trans_set_id(trans) =
@@ -4485,17 +4491,16 @@ static struct nft_set *nft_set_lookup_byid(const struct net *net,
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	u32 id = ntohl(nla_get_be32(nla));
-	struct nft_trans *trans;
+	struct nft_trans_set *trans;
 
-	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		if (trans->msg_type == NFT_MSG_NEWSET) {
-			struct nft_set *set = nft_trans_set(trans);
+	/* its likely the id we need is at the tail, not at start */
+	list_for_each_entry_reverse(trans, &nft_net->commit_set_list, list_trans_newset) {
+		struct nft_set *set = trans->set;
 
-			if (id == nft_trans_set_id(trans) &&
-			    set->table == table &&
-			    nft_active_genmask(set, genmask))
-				return set;
-		}
+		if (id == trans->set_id &&
+		    set->table == table &&
+		    nft_active_genmask(set, genmask))
+			return set;
 	}
 	return ERR_PTR(-ENOENT);
 }
@@ -10447,6 +10452,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
+			list_del(&nft_trans_container_set(trans)->list_trans_newset);
 			if (nft_trans_set_update(trans)) {
 				struct nft_set *set = nft_trans_set(trans);
 
@@ -10755,6 +10761,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
+			list_del(&nft_trans_container_set(trans)->list_trans_newset);
 			if (nft_trans_set_update(trans)) {
 				nft_trans_destroy(trans);
 				break;
@@ -10850,6 +10857,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		}
 	}
 
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_set_list));
+
 	nft_set_abort_update(&set_update_list);
 
 	synchronize_rcu();
@@ -11519,6 +11528,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
+	INIT_LIST_HEAD(&nft_net->commit_set_list);
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
@@ -11549,6 +11559,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	gc_seq = nft_gc_seq_begin(nft_net);
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_set_list));
 
 	if (!list_empty(&nft_net->module_list))
 		nf_tables_module_autoload_cleanup(net);
-- 
2.43.0



