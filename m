Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD864125AB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3FBC433C0;
	Mon, 26 Jun 2023 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804859;
	bh=pip250l9QRYrNxTregSwR4UZsGIWOnUkRWGUb8gtMwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smeGorBBVqIX5W5plZGLPru5NS2Q6OifGFWiWhnbPAJBgUGW8wyOafpHM3qJzvfQt
	 S7Y0nsuYk+A/c+TkDlly6HgP5ddTWNhuQTMr7L0/SSCMtH3py1muIvMkFCIe/oW7Ty
	 6kikgZPtB5NO6FFtLf0YgQu6Rg/833LR6nvtVIKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/96] netfilter: nf_tables: reject unbound anonymous set before commit phase
Date: Mon, 26 Jun 2023 20:12:20 +0200
Message-ID: <20230626180749.643671404@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 938154b93be8cd611ddfd7bafc1849f3c4355201 ]

Add a new list to track set transaction and to check for unbound
anonymous sets before entering the commit phase.

Bail out at the end of the transaction handling if an anonymous set
remains unbound.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 35 ++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 603c156da210b..7da74b9428b9f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1503,6 +1503,7 @@ static inline void nft_set_elem_clear_busy(struct nft_set_ext *ext)
  *	struct nft_trans - nf_tables object update in transaction
  *
  *	@list: used internally
+ *	@binding_list: list of objects with possible bindings
  *	@msg_type: message type
  *	@put_net: ctx->net needs to be put
  *	@ctx: transaction context
@@ -1510,6 +1511,7 @@ static inline void nft_set_elem_clear_busy(struct nft_set_ext *ext)
  */
 struct nft_trans {
 	struct list_head		list;
+	struct list_head		binding_list;
 	int				msg_type;
 	bool				put_net;
 	struct nft_ctx			ctx;
@@ -1648,6 +1650,7 @@ static inline int nft_request_module(struct net *net, const char *fmt, ...) { re
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c4e3aaeeb795c..010ef3bce9e5f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -153,6 +153,7 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 		return NULL;
 
 	INIT_LIST_HEAD(&trans->list);
+	INIT_LIST_HEAD(&trans->binding_list);
 	trans->msg_type = msg_type;
 	trans->ctx	= *ctx;
 
@@ -165,9 +166,15 @@ static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
 	return nft_trans_alloc_gfp(ctx, msg_type, size, GFP_KERNEL);
 }
 
-static void nft_trans_destroy(struct nft_trans *trans)
+static void nft_trans_list_del(struct nft_trans *trans)
 {
 	list_del(&trans->list);
+	list_del(&trans->binding_list);
+}
+
+static void nft_trans_destroy(struct nft_trans *trans)
+{
+	nft_trans_list_del(trans);
 	kfree(trans);
 }
 
@@ -359,6 +366,14 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
+	switch (trans->msg_type) {
+	case NFT_MSG_NEWSET:
+		if (!nft_trans_set_update(trans) &&
+		    nft_set_is_anonymous(nft_trans_set(trans)))
+			list_add_tail(&trans->binding_list, &nft_net->binding_list);
+		break;
+	}
+
 	list_add_tail(&trans->list, &nft_net->commit_list);
 }
 
@@ -8565,7 +8580,7 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 	synchronize_rcu();
 
 	list_for_each_entry_safe(trans, next, &head, list) {
-		list_del(&trans->list);
+		nft_trans_list_del(trans);
 		nft_commit_release(trans);
 	}
 }
@@ -8883,6 +8898,19 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return 0;
 	}
 
+	list_for_each_entry(trans, &nft_net->binding_list, binding_list) {
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWSET:
+			if (!nft_trans_set_update(trans) &&
+			    nft_set_is_anonymous(nft_trans_set(trans)) &&
+			    !nft_trans_set_bound(trans)) {
+				pr_warn_once("nftables ruleset with unbound set\n");
+				return -EINVAL;
+			}
+			break;
+		}
+	}
+
 	/* 0. Validate ruleset, otherwise roll back for error reporting. */
 	if (nf_tables_validate(net) < 0)
 		return -EAGAIN;
@@ -9356,7 +9384,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 
 	list_for_each_entry_safe_reverse(trans, next,
 					 &nft_net->commit_list, list) {
-		list_del(&trans->list);
+		nft_trans_list_del(trans);
 		nf_tables_abort_release(trans);
 	}
 
@@ -10129,6 +10157,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
+	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
-- 
2.39.2



