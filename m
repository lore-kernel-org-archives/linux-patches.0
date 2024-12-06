Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E2A1714DF;
	Fri,  6 Dec 2024 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497212; cv=none; b=DhqU8a0gWOMSJ5IErnqMbnNG9y4yBwHyE+60zlt3qltYaGm7rJAjIjelNKqFLAKtI70su79ZwHYe9k39YRmoygrbWb2sQAJwrOk/4hpyf1MNbNL31ox0Al2YK37G4dXMTFltC/sMCK6U3Bo1MepG6YLhaT6y41hJA3Sk6nh+7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497212; c=relaxed/simple;
	bh=7HubA9v7G4eVt4n/EfLLO7V7dp+SU6Zlb8k9fsmo+bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj9B97JCrMxaH+P2mkd8TrANRjrjIzxqvEoeeRZp1hWh3Uhjm6u9kp4zh8QAA20YXem+oTeOVHsR/CqkU+gKwe6vTeg32XLyjOJXieWRIo2XleteSkCwnEwsJSYhjADxBea1sa7wFIAr//sJyOBXcr+Gq3SakN/Z25OA4WZNCCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/BYMfxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/BYMfxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2F1C4CED1;
	Fri,  6 Dec 2024 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497212;
	bh=7HubA9v7G4eVt4n/EfLLO7V7dp+SU6Zlb8k9fsmo+bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/BYMfxizTkXcAQPLZPfXqIl0LK5jIP1WY4+8/g1ppu3jc/7v3QiYLr9lscViyJj9
	 8haJ5WL0aOaWXi7gYcWWGYYqLeHINK/wqw5VSHQPR7B8gryL0FhUTXvZ2aawzV/Zpu
	 fdn5twNCGUUghmTL0EAApaedU7kgLzysvGjX5bks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/676] netfilter: nf_tables: Introduce nf_tables_getrule_single()
Date: Fri,  6 Dec 2024 15:30:46 +0100
Message-ID: <20241206143702.203413445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 1578c32877191815f631af32ba5dfc1f1b20c1b4 ]

Outsource the reply skb preparation for non-dump getrule requests into a
distinct function. Prep work for rule reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 9adbb4198bf6 ("netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 74 ++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a75cab71426da..a0eed189441e5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3662,65 +3662,81 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
-			     const struct nlattr * const nla[])
+static struct sk_buff *
+nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
+			 const struct nlattr * const nla[], bool reset)
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	u32 portid = NETLINK_CB(skb).portid;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
-	bool reset = false;
-	char *buf;
 	int err;
 
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start= nf_tables_dump_rules_start,
-			.dump = nf_tables_dump_rules,
-			.done = nf_tables_dump_rules_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
-		return PTR_ERR(table);
+		return ERR_CAST(table);
 	}
 
 	chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN], genmask);
 	if (IS_ERR(chain)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
-		return PTR_ERR(chain);
+		return ERR_CAST(chain);
 	}
 
 	rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 	if (IS_ERR(rule)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
-		return PTR_ERR(rule);
+		return ERR_CAST(rule);
 	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
-		return -ENOMEM;
-
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		reset = true;
+		return ERR_PTR(-ENOMEM);
 
 	err = nf_tables_fill_rule_info(skb2, net, portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, 0, reset);
-	if (err < 0)
-		goto err_fill_rule_info;
+	if (err < 0) {
+		kfree_skb(skb2);
+		return ERR_PTR(err);
+	}
+
+	return skb2;
+}
+
+static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const nla[])
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u32 portid = NETLINK_CB(skb).portid;
+	struct net *net = info->net;
+	struct sk_buff *skb2;
+	bool reset = false;
+	char *buf;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start= nf_tables_dump_rules_start,
+			.dump = nf_tables_dump_rules,
+			.done = nf_tables_dump_rules_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
+
+	skb2 = nf_tables_getrule_single(portid, info, nla, reset);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
 	if (!reset)
 		return nfnetlink_unicast(skb2, net, portid);
@@ -3734,10 +3750,6 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	kfree(buf);
 
 	return nfnetlink_unicast(skb2, net, portid);
-
-err_fill_rule_info:
-	kfree_skb(skb2);
-	return err;
 }
 
 void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
-- 
2.43.0



