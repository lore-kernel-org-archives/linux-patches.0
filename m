Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D735143895;
	Thu, 13 Jun 2024 12:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281489; cv=none; b=iRmAGJb+nel28Cpd6aeYOpItRhmZ5HjRUlW1wtYHtsQQbzJ3cvt/L+RqDFJvOTZ5ZjJCklP0+DMOxqNA0HdKr4pai8PhY2Vma9lW5Dk3xLZj8qnsf8PtuQTGwiIW6XGk/NK9B19cj/jGReyOYx1YvUa3e58FxD5BFKyuWRcKbd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281489; c=relaxed/simple;
	bh=mC2TjjLJVr35yKowa0NbHADNr3ThTXNFwFmYvJqdtWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpAf+065ZOu2y1gBRrxALW9AGUe+cF9WE3sKsACwgrEzwCPxwA7f4JAE+P+TPBWjgKmhMqXqIPbRporX7LO7FMyxbK6uyVxwg2gJvO6ouAGFBNJgH9YoguGH1GACLg8p4TZQNNT1TVnNjEgzdkk9sVfS0FWS8Nf1azmwuAVy6sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pFCxLuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pFCxLuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10360C2BBFC;
	Thu, 13 Jun 2024 12:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281489;
	bh=mC2TjjLJVr35yKowa0NbHADNr3ThTXNFwFmYvJqdtWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pFCxLuGmxLh+3zYPaFJOs+sT7xbQz25SOlmFOhxHwLlFP3SBLO4sUCFLnaHI2oK2
	 YkaZL9mkgLjbAfRxYCra+6odMI/l5oXZZxF50tU6cBRixB9/q71yiSjILPEc6hePXa
	 qp0xyPX1QOW1HUBTN64fZ7xXfwNUawPiPBKxNEFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH 5.10 273/317] netfilter: nf_tables: restrict tunnel object to NFPROTO_NETDEV
Date: Thu, 13 Jun 2024 13:34:51 +0200
Message-ID: <20240613113258.113068400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 776d451648443f9884be4a1b4e38e8faf1c621f9 upstream.

Bail out on using the tunnel dst template from other than netdev family.
Add the infrastructure to check for the family in objects.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[KN: Backport patch according to v5.10.x source]
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c     |   14 +++++++++-----
 net/netfilter/nft_tunnel.c        |    1 +
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1174,6 +1174,7 @@ void nft_obj_notify(struct net *net, con
  *	@type: stateful object numeric type
  *	@owner: module owner
  *	@maxattr: maximum netlink attribute
+ *	@family: address family for AF-specific object types
  *	@policy: netlink attribute policy
  */
 struct nft_object_type {
@@ -1183,6 +1184,7 @@ struct nft_object_type {
 	struct list_head		list;
 	u32				type;
 	unsigned int                    maxattr;
+	u8				family;
 	struct module			*owner;
 	const struct nla_policy		*policy;
 };
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6234,11 +6234,15 @@ nla_put_failure:
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
@@ -6246,11 +6250,11 @@ static const struct nft_object_type *__n
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
 
@@ -6343,7 +6347,7 @@ static int nf_tables_newobj(struct net *
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		type = __nft_obj_type_get(objtype);
+		type = __nft_obj_type_get(objtype, family);
 		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
@@ -6354,7 +6358,7 @@ static int nf_tables_newobj(struct net *
 	if (!nft_use_inc(&table->use))
 		return -EMFILE;
 
-	type = nft_obj_type_get(net, objtype);
+	type = nft_obj_type_get(net, objtype, family);
 	if (IS_ERR(type)) {
 		err = PTR_ERR(type);
 		goto err_type;
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -684,6 +684,7 @@ static const struct nft_object_ops nft_t
 
 static struct nft_object_type nft_tunnel_obj_type __read_mostly = {
 	.type		= NFT_OBJECT_TUNNEL,
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_obj_ops,
 	.maxattr	= NFTA_TUNNEL_KEY_MAX,
 	.policy		= nft_tunnel_key_policy,


