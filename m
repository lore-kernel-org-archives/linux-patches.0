Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CB8482DD;
	Sat,  3 Feb 2024 04:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933716; cv=none; b=ZfF9lDaFVVYKPF/4afo73o4DNAzLS3XMv+YBYDHOncloGC5e1b6Und+w3ynV7WNVsnNmkGpdc0+X1oWzL/qU7RsJl3CqA6Zbng9ygumfrHgWE7r1KmAcKID/+UJ44uAk8h0fynOiq/mG6G/893Lbi2yM5aRG49037SIjXeFTd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933716; c=relaxed/simple;
	bh=OZWVHSKTdVBYJybHFcFaadf0S5Zno4+AzPcOs3R9b+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMRMe/R4mESmldgcvHlpoHdEZKGJPwlLUDWTj33UwtqkuZ020QXiRQxIGMNbUfpEryCwpZ4Ai4Mesl6EBopSlF4ZOHSXaCpwJ71oP7tvPQfiCFZCYHtrD6u/u/YF8bAI3Z+4mvroybTG73flIDfGBlPUqVUeK3/eQFcniwdQMjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4lcUCrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4lcUCrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35643C43394;
	Sat,  3 Feb 2024 04:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933715;
	bh=OZWVHSKTdVBYJybHFcFaadf0S5Zno4+AzPcOs3R9b+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4lcUCrDmDbj9KmTwesDjgfHOJONeIhx5PKYOWcIhgEx1P0lLC20ZPS4d995RkGkE
	 2BWMFku37Ky+MN/VjLuosnKkOgh7tZKUkWXL0fkLkIRJVcg9jJFBboNCI86K7wHfwb
	 UjLXCHEzmg1k+2JutRQp90TjRX2I+u9MthUrJ6Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/322] netfilter: nf_tables: restrict tunnel object to NFPROTO_NETDEV
Date: Fri,  2 Feb 2024 20:06:31 -0800
Message-ID: <20240203035408.564307918@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 776d451648443f9884be4a1b4e38e8faf1c621f9 ]

Bail out on using the tunnel dst template from other than netdev family.
Add the infrastructure to check for the family in objects.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 14 +++++++++-----
 net/netfilter/nft_tunnel.c        |  1 +
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 75972e211ba1..5bb8a83e2604 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1307,6 +1307,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
  *	@type: stateful object numeric type
  *	@owner: module owner
  *	@maxattr: maximum netlink attribute
+ *	@family: address family for AF-specific object types
  *	@policy: netlink attribute policy
  */
 struct nft_object_type {
@@ -1316,6 +1317,7 @@ struct nft_object_type {
 	struct list_head		list;
 	u32				type;
 	unsigned int                    maxattr;
+	u8				family;
 	struct module			*owner;
 	const struct nla_policy		*policy;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4fc8348dd799..cb7d42a3faab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7415,11 +7415,15 @@ static int nft_object_dump(struct sk_buff *skb, unsigned int attr,
 	return -1;
 }
 
-static const struct nft_object_type *__nft_obj_type_get(u32 objtype)
+static const struct nft_object_type *__nft_obj_type_get(u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
 	list_for_each_entry(type, &nf_tables_objects, list) {
+		if (type->family != NFPROTO_UNSPEC &&
+		    type->family != family)
+			continue;
+
 		if (objtype == type->type)
 			return type;
 	}
@@ -7427,11 +7431,11 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype)
 }
 
 static const struct nft_object_type *
-nft_obj_type_get(struct net *net, u32 objtype)
+nft_obj_type_get(struct net *net, u32 objtype, u8 family)
 {
 	const struct nft_object_type *type;
 
-	type = __nft_obj_type_get(objtype);
+	type = __nft_obj_type_get(objtype, family);
 	if (type != NULL && try_module_get(type->owner))
 		return type;
 
@@ -7524,7 +7528,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		type = __nft_obj_type_get(objtype);
+		type = __nft_obj_type_get(objtype, family);
 		if (WARN_ON_ONCE(!type))
 			return -ENOENT;
 
@@ -7538,7 +7542,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!nft_use_inc(&table->use))
 		return -EMFILE;
 
-	type = nft_obj_type_get(net, objtype);
+	type = nft_obj_type_get(net, objtype, family);
 	if (IS_ERR(type)) {
 		err = PTR_ERR(type);
 		goto err_type;
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 9f21953c7433..f735d79d8be5 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -713,6 +713,7 @@ static const struct nft_object_ops nft_tunnel_obj_ops = {
 
 static struct nft_object_type nft_tunnel_obj_type __read_mostly = {
 	.type		= NFT_OBJECT_TUNNEL,
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_obj_ops,
 	.maxattr	= NFTA_TUNNEL_KEY_MAX,
 	.policy		= nft_tunnel_key_policy,
-- 
2.43.0



