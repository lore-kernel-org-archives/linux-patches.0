Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FF71E520;
	Tue, 27 Aug 2024 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771165; cv=none; b=b+fLaPunHVzOWdajLdchLR13wu8jpZhyukgvHDVuYnB/z+5rSFKgLowfzc60EkOpB+1n39CjG30wDAKtBWyxnVlq0ISwLfq25aSlSUSPQOZd0R1RZD5dcuT5X1JcZKxVPbp7SRRrw5jj9GQXpUYbftBTO0kSyVnkcjkbQiIh9mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771165; c=relaxed/simple;
	bh=CSMJ42RyBHVEnwhGep0c4i3MQOgqlIoIoKo5ogzZoek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXDfu+4bkWghyZ+ayMCamTUSfm+zSdHfdYxsD5kI6IzYxITklEWd6464zJz+pjF3pVZ97Z8l1ailm3BK+ZW6J5eqNjCavAgYZzP9DmCPugJMjMxwtFtylsooUaJGsH6swfG1/FkGNp0bl+jpV7JsBmXY7oEQlWdK/Hg/DrM28dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNj5VhLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNj5VhLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEECC6107C;
	Tue, 27 Aug 2024 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771165;
	bh=CSMJ42RyBHVEnwhGep0c4i3MQOgqlIoIoKo5ogzZoek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNj5VhLMHTe6RYXDWCVQZtVlLPFFjqXBIIEYbBjY2RrWNAenc7y0oNpZgugLKcLp5
	 dypNd20qZIz3BjYsj6uC66bmCx9lvIQwJ3kQkE6jPdHdTFE4lY3ke/meuO4RMQ2cB9
	 kwv9M1B0uIw+T9mIVll++pj9UBIb4EkHRMCJBsRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 107/273] netfilter: nf_tables: Introduce nf_tables_getobj_single
Date: Tue, 27 Aug 2024 16:37:11 +0200
Message-ID: <20240827143837.481468215@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 69fc3e9e90f1afc11f4015e6b75d18ab9acee348 ]

Outsource the reply skb preparation for non-dump getrule requests into a
distinct function. Prep work for object reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 75 ++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7ae055521cf36..2f32db2a09fec 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8009,10 +8009,10 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
-			    const struct nlattr * const nla[])
+static struct sk_buff *
+nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
+			const struct nlattr * const nla[], bool reset)
 {
-	const struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -8020,52 +8020,69 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
-	bool reset = false;
 	u32 objtype;
-	char *buf;
 	int err;
 
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
-			.done = nf_tables_dump_obj_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
 	if (!nla[NFTA_OBJ_NAME] ||
 	    !nla[NFTA_OBJ_TYPE])
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
-		return PTR_ERR(table);
+		return ERR_CAST(table);
 	}
 
 	objtype = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 	obj = nft_obj_lookup(net, table, nla[NFTA_OBJ_NAME], objtype, genmask);
 	if (IS_ERR(obj)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
-		return PTR_ERR(obj);
+		return ERR_CAST(obj);
 	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
+
+	err = nf_tables_fill_obj_info(skb2, net, portid,
+				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
+				      family, table, obj, reset);
+	if (err < 0) {
+		kfree_skb(skb2);
+		return ERR_PTR(err);
+	}
+
+	return skb2;
+}
+
+static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
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
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
+			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
 
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
-	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
-				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
-				      family, table, obj, reset);
-	if (err < 0)
-		goto err_fill_obj_info;
+	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
 	if (!reset)
 		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
@@ -8078,11 +8095,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
 	kfree(buf);
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
-
-err_fill_obj_info:
-	kfree_skb(skb2);
-	return err;
+	return nfnetlink_unicast(skb2, net, portid);
 }
 
 static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
-- 
2.43.0



