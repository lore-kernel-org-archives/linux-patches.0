Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CC71E4B2;
	Wed, 21 Feb 2024 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522886; cv=none; b=G38PVAc8cb9R2FAX6n4F96m7/gDPKzTnzdcodG2BB4CDLLaq6AXwljqoA6+9dBwcEwyfbviSFG6Se+ac2pv5KhYRq6Pc0Sea54OXyXkI7wONSObtpW0BFkMfIg22nHcvidIlItG86ZjVp+Qr9DkQz8zsqCPVDlgYzLLI61GKLFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522886; c=relaxed/simple;
	bh=I4iyKYTpGHKaQ+xU1Wn4Cq04IqOYjdwsKSx7xhP0TaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIyJarTOLgYcueWnDjm6XD5YHPCllmyuTmUNbp/4kSQAi9r49OLPFhFxjX29VhNExAQ8zpVhiZfoYwvwEQL5V/C0DvTHnOGnxM2oaO/UzD3rMM3LVg5IwEQ5gCYPujXNd1U8dk3Z7+XbkQ6r0NGStMNiYLB0yzAcnbC0Im1PCk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9itXbJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9itXbJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA2C433C7;
	Wed, 21 Feb 2024 13:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522885;
	bh=I4iyKYTpGHKaQ+xU1Wn4Cq04IqOYjdwsKSx7xhP0TaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9itXbJVScUs6F+TkfhBdl1X3vgWEzVABHOkVw6le7q0/lABUUJDmZg+vxh1ka+Rb
	 DUkTjESGunlqX73j4zjaI4v9OXba7ZbeEgPKBg3/GLAiOsW/FoeWadW1JrD67bVdZw
	 VtE1egWbIiEVZdbLKlLVWsTXCJAAku78QS3mOtkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/476] netfilter: nf_tables: restrict tunnel object to NFPROTO_NETDEV
Date: Wed, 21 Feb 2024 14:05:34 +0100
Message-ID: <20240221130018.459890062@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index 8e9c5bc1a9e6..1e6e4af4df0a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1253,6 +1253,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
  *	@type: stateful object numeric type
  *	@owner: module owner
  *	@maxattr: maximum netlink attribute
+ *	@family: address family for AF-specific object types
  *	@policy: netlink attribute policy
  */
 struct nft_object_type {
@@ -1262,6 +1263,7 @@ struct nft_object_type {
 	struct list_head		list;
 	u32				type;
 	unsigned int                    maxattr;
+	u8				family;
 	struct module			*owner;
 	const struct nla_policy		*policy;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 996238f0ca54..3ad2b22886ff 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6999,11 +6999,15 @@ static int nft_object_dump(struct sk_buff *skb, unsigned int attr,
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
@@ -7011,11 +7015,11 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype)
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
 
@@ -7108,7 +7112,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		type = __nft_obj_type_get(objtype);
+		type = __nft_obj_type_get(objtype, family);
 		if (WARN_ON_ONCE(!type))
 			return -ENOENT;
 
@@ -7122,7 +7126,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!nft_use_inc(&table->use))
 		return -EMFILE;
 
-	type = nft_obj_type_get(net, objtype);
+	type = nft_obj_type_get(net, objtype, family);
 	if (IS_ERR(type)) {
 		err = PTR_ERR(type);
 		goto err_type;
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 2ee50996da8c..c8822fa8196d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -684,6 +684,7 @@ static const struct nft_object_ops nft_tunnel_obj_ops = {
 
 static struct nft_object_type nft_tunnel_obj_type __read_mostly = {
 	.type		= NFT_OBJECT_TUNNEL,
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_obj_ops,
 	.maxattr	= NFTA_TUNNEL_KEY_MAX,
 	.policy		= nft_tunnel_key_policy,
-- 
2.43.0



