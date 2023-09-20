Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A590168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71D5C433CB;
	Wed, 20 Sep 2023 12:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214019;
	bh=06kRVzEeMqIj8oxoBuN3s9RA3eQDIm4tenDzwULI4OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5QO3uARW30Rt60MmJwE7otggzLcY2rz2sQwPDeGZCBM6n79bU8UrrggKZBv5TU6m
	 nufuqQDJiDqWi57Rv0qpCvMPCzT4DwB8FtWgQndAtf7n0ma/q7G+0rliLlPlhaHBlj
	 neaLdB6bzEscjWYSseJSwCmpJdDROjmBzCjhbZsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/110] netfilter: nf_tables: make validation state per table
Date: Wed, 20 Sep 2023 13:32:20 +0200
Message-ID: <20230920112833.489041399@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

[ Upstream commit 00c320f9b75560628e840bef027a27c746706759 ]

We only need to validate tables that saw changes in the current
transaction.

The existing code revalidates all tables, but this isn't needed as
cross-table jumps are not allowed (chains have table scope).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  3 ++-
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++----------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1458b3eae8ada..b8d967e0eb1e2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1183,6 +1183,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@genmask: generation mask
  *	@afinfo: address family info
  *	@name: name of the table
+ *	@validate_state: internal, set when transaction adds jumps
  */
 struct nft_table {
 	struct list_head		list;
@@ -1201,6 +1202,7 @@ struct nft_table {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	u8				validate_state;
 };
 
 static inline bool nft_table_has_owner(const struct nft_table *table)
@@ -1682,7 +1684,6 @@ struct nftables_pernet {
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	unsigned int		base_seq;
-	u8			validate_state;
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d84da11aaee5c..dde19be41610d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -102,11 +102,9 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
 	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
 };
 
-static void nft_validate_state_update(struct net *net, u8 new_validate_state)
+static void nft_validate_state_update(struct nft_table *table, u8 new_validate_state)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
-
-	switch (nft_net->validate_state) {
+	switch (table->validate_state) {
 	case NFT_VALIDATE_SKIP:
 		WARN_ON_ONCE(new_validate_state == NFT_VALIDATE_DO);
 		break;
@@ -117,7 +115,7 @@ static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 			return;
 	}
 
-	nft_net->validate_state = new_validate_state;
+	table->validate_state = new_validate_state;
 }
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
@@ -1286,6 +1284,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (table == NULL)
 		goto err_kzalloc;
 
+	table->validate_state = NFT_VALIDATE_SKIP;
 	table->name = nla_strdup(attr, GFP_KERNEL);
 	if (table->name == NULL)
 		goto err_strdup;
@@ -3650,7 +3649,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		}
 
 		if (expr_info[i].ops->validate)
-			nft_validate_state_update(net, NFT_VALIDATE_NEED);
+			nft_validate_state_update(table, NFT_VALIDATE_NEED);
 
 		expr_info[i].ops = NULL;
 		expr = nft_expr_next(expr);
@@ -3704,7 +3703,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (flow)
 		nft_trans_flow_rule(trans) = flow;
 
-	if (nft_net->validate_state == NFT_VALIDATE_DO)
+	if (table->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
 	return 0;
@@ -6347,7 +6346,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			if (desc.type == NFT_DATA_VERDICT &&
 			    (elem.data.val.verdict.code == NFT_GOTO ||
 			     elem.data.val.verdict.code == NFT_JUMP))
-				nft_validate_state_update(ctx->net,
+				nft_validate_state_update(ctx->table,
 							  NFT_VALIDATE_NEED);
 		}
 
@@ -6465,7 +6464,6 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -6503,7 +6501,7 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 			return err;
 	}
 
-	if (nft_net->validate_state == NFT_VALIDATE_DO)
+	if (table->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
 	return 0;
@@ -8600,19 +8598,20 @@ static int nf_tables_validate(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
 
-	switch (nft_net->validate_state) {
-	case NFT_VALIDATE_SKIP:
-		break;
-	case NFT_VALIDATE_NEED:
-		nft_validate_state_update(net, NFT_VALIDATE_DO);
-		fallthrough;
-	case NFT_VALIDATE_DO:
-		list_for_each_entry(table, &nft_net->tables, list) {
+	list_for_each_entry(table, &nft_net->tables, list) {
+		switch (table->validate_state) {
+		case NFT_VALIDATE_SKIP:
+			continue;
+		case NFT_VALIDATE_NEED:
+			nft_validate_state_update(table, NFT_VALIDATE_DO);
+			fallthrough;
+		case NFT_VALIDATE_DO:
 			if (nft_table_validate(net, table) < 0)
 				return -EAGAIN;
+
+			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
 		}
 
-		nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 		break;
 	}
 
@@ -10344,7 +10343,6 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
-	nft_net->validate_state = NFT_VALIDATE_SKIP;
 
 	return 0;
 }
-- 
2.40.1



