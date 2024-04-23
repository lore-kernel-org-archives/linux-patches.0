Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F1220B3E;
	Tue, 23 Apr 2024 21:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908458; cv=none; b=fSuVF6GSWGvELYoShrjMsgaz9YpFN+W05bpssP6YjPqxKi/dXqNmGNw2rW+L4G3nDPAGRkhry4A2rQRhf2jyCvHd11mmTAdDIPd+bVEcLPML19NseOy+H9irrZhJA6QDTJgYaYW9uShNWb53F1gM6UpigfR5fXfxeuz3qWMpHvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908458; c=relaxed/simple;
	bh=kiYSqaOZPtve26X4nclrugcShxIvqWRaB4mx2+o4W3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd708EJYSIB/H4tYhFJ/Q04J92CZAgngWYxHuQc4aAyw/eniDf+a9gbCTxKpZ5akSwEAdnu4s2dVu+xxjq+QZJF7ftXLc4OtDd691KhJoP2f4CZflsBJgfe+cEhTBKlkzmN/0LEH+wxiEOSlH4B5qeUWYg3iRhuEwTgfqXumTYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uj8Klp/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj8Klp/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A37C116B1;
	Tue, 23 Apr 2024 21:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908458;
	bh=kiYSqaOZPtve26X4nclrugcShxIvqWRaB4mx2+o4W3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj8Klp/lCT0UIbt4/Vc0s7c+qRerX8FRPcBpBt4WzmGdtltRds0xvHhEMQz67/xrS
	 vYOiv/WB7mUYyGHggeoIOaElKtMno2KyUbVMYMjL1385YudfT2DEYWxTbNsbJtHn1U
	 8FFEqPSztUpbRh8geGsy7N5Mu5kd1rKO3RAX8Thc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 018/158] netfilter: nft_set_pipapo: walk over current view on netlink dump
Date: Tue, 23 Apr 2024 14:37:20 -0700
Message-ID: <20240423213856.456187401@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 29b359cf6d95fd60730533f7f10464e95bd17c73 ]

The generation mask can be updated while netlink dump is in progress.
The pipapo set backend walk iterator cannot rely on it to infer what
view of the datastructure is to be used. Add notation to specify if user
wants to read/update the set.

Based on patch from Florian Westphal.

Fixes: 2b84e215f874 ("netfilter: nft_set_pipapo: .walk does not deal with generations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 14 ++++++++++++++
 net/netfilter/nf_tables_api.c     |  6 ++++++
 net/netfilter/nft_set_pipapo.c    |  5 +++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 510244cc0f8f0..1cf9cb0f0a975 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -307,9 +307,23 @@ static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
 	return (void *)priv;
 }
 
+
+/**
+ * enum nft_iter_type - nftables set iterator type
+ *
+ * @NFT_ITER_READ: read-only iteration over set elements
+ * @NFT_ITER_UPDATE: iteration under mutex to update set element state
+ */
+enum nft_iter_type {
+	NFT_ITER_UNSPEC,
+	NFT_ITER_READ,
+	NFT_ITER_UPDATE,
+};
+
 struct nft_set;
 struct nft_set_iter {
 	u8		genmask;
+	enum nft_iter_type type:8;
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ad9fb019684b3..8a3fa7f5b456d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -626,6 +626,7 @@ static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_deactivate,
 	};
 
@@ -5441,6 +5442,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		}
 
 		iter.genmask	= nft_genmask_next(ctx->net);
+		iter.type	= NFT_ITER_UPDATE;
 		iter.skip 	= 0;
 		iter.count	= 0;
 		iter.err	= 0;
@@ -5514,6 +5516,7 @@ static void nft_map_activate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_iter iter = {
 		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_mapelem_activate,
 	};
 
@@ -5888,6 +5891,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	args.skb		= skb;
 	args.reset		= dump_ctx->reset;
 	args.iter.genmask	= nft_genmask_cur(net);
+	args.iter.type		= NFT_ITER_READ;
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
 	args.iter.err		= 0;
@@ -7372,6 +7376,7 @@ static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 {
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
+		.type		= NFT_ITER_UPDATE,
 		.fn		= nft_setelem_flush,
 	};
 
@@ -10871,6 +10876,7 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				continue;
 
 			iter.genmask	= nft_genmask_next(ctx->net);
+			iter.type	= NFT_ITER_UPDATE;
 			iter.skip 	= 0;
 			iter.count	= 0;
 			iter.err	= 0;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7756d70af868c..69b1ab6849e67 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2040,13 +2040,14 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_set_iter *iter)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct net *net = read_pnet(&set->net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	int i, r;
 
+	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+
 	rcu_read_lock();
-	if (iter->genmask == nft_genmask_cur(net))
+	if (iter->type == NFT_ITER_READ)
 		m = rcu_dereference(priv->match);
 	else
 		m = priv->clone;
-- 
2.43.0



