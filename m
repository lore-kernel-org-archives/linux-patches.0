Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C1911C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB18CC433CA;
	Mon, 28 Aug 2023 10:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218038;
	bh=0F/bwZVOFm/FePtuZtFRAEtPAp7ZQ4aFDqsubV11vF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imqnGIww5QItrRZUJ+IS4WWsinNmpF39o3C38BKAB+UG2E/3LTUYtC4X1qoTxNOzW
	 qoxkDX3TSMAQ1hzWz2J6L0sesH+UiM7Ax3ziLVcJaIacWwwGV6NJHB+ms7ND0GKlbj
	 shPh1Sw3U6uioeBsFL7zhohdvdhM7MShOwCrWPwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 043/129] netfilter: nf_tables: validate all pending tables
Date: Mon, 28 Aug 2023 12:12:02 +0200
Message-ID: <20230828101158.800486385@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4b80ced971b0d118f9a11dd503a5833a5016de92 ]

We have to validate all tables in the transaction that are in
VALIDATE_DO state, the blamed commit below did not move the break
statement to its right location so we only validate one table.

Moreover, we can't init table->validate to _SKIP when a table object
is allocated.

If we do, then if a transcaction creates a new table and then
fails the transaction, nfnetlink will loop and nft will hang until
user cancels the command.

Add back the pernet state as a place to stash the last state encountered.
This is either _DO (we hit an error during commit validation) or _SKIP
(transaction passed all checks).

Fixes: 00c320f9b755 ("netfilter: nf_tables: make validation state per table")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ad97049e28881..a9a730fb9f963 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1817,6 +1817,7 @@ struct nftables_pernet {
 	u64			table_handle;
 	unsigned int		base_seq;
 	unsigned int		gc_seq;
+	u8			validate_state;
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b280b151a9e98..5275c4112b57d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1372,7 +1372,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (table == NULL)
 		goto err_kzalloc;
 
-	table->validate_state = NFT_VALIDATE_SKIP;
+	table->validate_state = nft_net->validate_state;
 	table->name = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (table->name == NULL)
 		goto err_strdup;
@@ -9065,9 +9065,8 @@ static int nf_tables_validate(struct net *net)
 				return -EAGAIN;
 
 			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
+			break;
 		}
-
-		break;
 	}
 
 	return 0;
@@ -9813,8 +9812,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* 0. Validate ruleset, otherwise roll back for error reporting. */
-	if (nf_tables_validate(net) < 0)
+	if (nf_tables_validate(net) < 0) {
+		nft_net->validate_state = NFT_VALIDATE_DO;
 		return -EAGAIN;
+	}
 
 	err = nft_flow_rule_offload_commit(net);
 	if (err < 0)
@@ -10070,6 +10071,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
 
 	nft_gc_seq_end(nft_net, gc_seq);
+	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	nf_tables_commit_release(net);
 
 	return 0;
@@ -11126,6 +11128,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
 	nft_net->gc_seq = 0;
+	nft_net->validate_state = NFT_VALIDATE_SKIP;
 
 	return 0;
 }
-- 
2.40.1



