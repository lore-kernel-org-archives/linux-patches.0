Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7B1ED4D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936EEC433C8;
	Tue, 25 Jul 2023 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285370;
	bh=NIpYwlLuahxfD0/Dds0gw8TPNMG8NLCY4TXz08WafZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMbuKCdilfZUoEQxKek6ONl/XV2t9le6PO3ee9AFcz8WKz7SxYaF6Tc8fh8KDhZCk
	 t9zTenX1hDzOv1poPuAVXVfqE2Uc+IWTESJrm0332cJI1UDRZUl/mXdWFNCry7Gkyb
	 6TunYV23xTIriCvHF0OacsVtMLxIlxAsuHgWX5vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 180/313] netfilter: nftables: add helper function to set the base sequence number
Date: Tue, 25 Jul 2023 12:45:33 +0200
Message-ID: <20230725104528.737752455@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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

[ 802b805162a1b7d8391c40ac8a878e9e63287aff ]

This patch adds a helper function to calculate the base sequence number
field that is stored in the nfnetlink header. Use the helper function
whenever possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -588,6 +588,11 @@ nf_tables_chain_type_lookup(struct net *
 	return ERR_PTR(-ENOENT);
 }
 
+static __be16 nft_base_seq(const struct net *net)
+{
+	return htons(net->nft.base_seq & 0xffff);
+}
+
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
@@ -610,7 +615,7 @@ static int nf_tables_fill_table_info(str
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
 	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
@@ -1274,7 +1279,7 @@ static int nf_tables_fill_chain_info(str
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name))
 		goto nla_put_failure;
@@ -2366,7 +2371,7 @@ static int nf_tables_fill_rule_info(stru
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_RULE_TABLE, table->name))
 		goto nla_put_failure;
@@ -3325,7 +3330,7 @@ static int nf_tables_fill_set(struct sk_
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -4180,7 +4185,7 @@ static int nf_tables_dump_set(struct sk_
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = table->family;
 	nfmsg->version      = NFNETLINK_V0;
-	nfmsg->res_id	    = htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id	    = nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_TABLE, table->name))
 		goto nla_put_failure;
@@ -4252,7 +4257,7 @@ static int nf_tables_fill_setelem_info(s
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -5383,7 +5388,7 @@ static int nf_tables_fill_obj_info(struc
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
@@ -6059,7 +6064,7 @@ static int nf_tables_fill_flowtable_info
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_FLOWTABLE_TABLE, flowtable->table->name) ||
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
@@ -6297,7 +6302,7 @@ static int nf_tables_fill_gen_info(struc
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= AF_UNSPEC;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||


