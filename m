Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9658FFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2538C433D2;
	Mon, 15 May 2023 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171181;
	bh=zCCJ4DyqhlR+cowYn827qh7KqSIPNkOi/TWN/HQ8rYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STMRf4sN/OdAnNGx9aboE075Q9cZW5kysaOO3cEeF4SMyJoK3iR28FXykwNwKDm0/
	 PqVG01dtxNAoZUNmY9hrATYsEstKjCai2N2WZLjbZTtncTxwdGSDtm368peh+d0Erp
	 N4fxquuYeOx1ruok/6XAOa6FkZRycKFhZZkfnriM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 126/242] netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes
Date: Mon, 15 May 2023 18:27:32 +0200
Message-Id: <20230515161725.683906919@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
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

[ Upstream commit 8509f62b0b07ae8d6dec5aa9613ab1b250ff632f ]

If user does not specify hook number and priority, then assume this is
a chain/flowtable update. Therefore, report ENOENT which provides a
better hint than EINVAL. Set on extended netlink error report to refer
to the chain name.

Fixes: 5b6743fb2c2a ("netfilter: nf_tables: skip flowtable hooknum and priority on device updates")
Fixes: 5efe72698a97 ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4ffafef46d2e2..d64478af0129f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2053,8 +2053,10 @@ static int nft_chain_parse_hook(struct net *net,
 		return err;
 
 	if (ha[NFTA_HOOK_HOOKNUM] == NULL ||
-	    ha[NFTA_HOOK_PRIORITY] == NULL)
-		return -EINVAL;
+	    ha[NFTA_HOOK_PRIORITY] == NULL) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_NAME]);
+		return -ENOENT;
+	}
 
 	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
@@ -7556,7 +7558,7 @@ static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX
 };
 
 static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
-				    const struct nlattr *attr,
+				    const struct nlattr * const nla[],
 				    struct nft_flowtable_hook *flowtable_hook,
 				    struct nft_flowtable *flowtable,
 				    struct netlink_ext_ack *extack, bool add)
@@ -7568,15 +7570,18 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 
 	INIT_LIST_HEAD(&flowtable_hook->list);
 
-	err = nla_parse_nested_deprecated(tb, NFTA_FLOWTABLE_HOOK_MAX, attr,
+	err = nla_parse_nested_deprecated(tb, NFTA_FLOWTABLE_HOOK_MAX,
+					  nla[NFTA_FLOWTABLE_HOOK],
 					  nft_flowtable_hook_policy, NULL);
 	if (err < 0)
 		return err;
 
 	if (add) {
 		if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
-		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY])
-			return -EINVAL;
+		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY]) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
+			return -ENOENT;
+		}
 
 		hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
 		if (hooknum != NF_NETDEV_INGRESS)
@@ -7761,8 +7766,8 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	u32 flags;
 	int err;
 
-	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, extack, false);
+	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
+				       extack, false);
 	if (err < 0)
 		return err;
 
@@ -7907,8 +7912,8 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	if (err < 0)
 		goto err3;
 
-	err = nft_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, extack, true);
+	err = nft_flowtable_parse_hook(&ctx, nla, &flowtable_hook, flowtable,
+				       extack, true);
 	if (err < 0)
 		goto err4;
 
@@ -7970,8 +7975,8 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err;
 
-	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, extack, false);
+	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
+				       extack, false);
 	if (err < 0)
 		return err;
 
-- 
2.39.2



