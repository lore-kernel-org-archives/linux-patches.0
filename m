Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634DA46EF88;
	Tue, 21 Jul 2026 19:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660910; cv=none; b=hgaX1sW5rthq+2jt8gQJ9OdXRYpOzRsdxtJcGalFnLFa34AhC8mEaSsgLf+OvI9/6Rj2i1ary2s/54klNNA7Ri3M/y4PrI/5gIKQM5HKAyIBacqOlh9DYo6DVkyreRsYVU2Vf77s2DWpZCqvpn2JWgcPJWqT1HhyLw3jXjVdPdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660910; c=relaxed/simple;
	bh=yGDmWeDqmolPsN05bl068rgVOaX+SbuLBe5gc6+vfic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhTxhAR0q1ar8T9dTQjswqfAQv9hiNVncIcYsH4wfwOAWDDE9vbiEAZE8JVlE1hCwTy3+5q3HRPpR87AoQxlIq6qf1sVDaYgCGgCsbxjiroo2QL7zMmGDj4KyMg3BCrlNH8MWbWciNKha0raUgvVk47IyM+zhqG+t2ayY+3x+Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAH46zQc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAH46zQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F521F000E9;
	Tue, 21 Jul 2026 19:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660909;
	bh=4a0J3PjW5ab8Af2BoFyLTec+1Filb5MIlWL7C8MU14c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAH46zQc0UtXfHiVGfKbn6TJpt4cVgdqqHxNogNYe3+foHUKsMevNLkUqxrIOx6AI
	 X2GZhjp6rMBwQQl5fm/qD8QNA6MBWDiJkIBpL9sFxT24DhcMNDmLsR7F9niYC2JLnR
	 9jenp9xnhtHv4NGSkypDjHb1hmo2MRjt/veZfNis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1151/2077] netfilter: nft_meta_bridge: add validate callback for get operations
Date: Tue, 21 Jul 2026 17:13:44 +0200
Message-ID: <20260721152619.972711876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit bff1c8b49a9cb5c04af20f4e7d43bf4af5863bc6 ]

Blamed commit added NFT_META_BRI_IIFHWADDR to the set validate callback,
yet this is a get operation.

Add a get validate callback and move the NFT_META_BRI_IIFHWADDR key
there.

AFAICS this is harmless, NFT_META_BRI_IIFHWADDR can deal with a NULL
input device and the set handler ignores a NFT_META_BRI_IIFHWADDR
operation, but it allows to read 4 bytes off bridge skb->cb[].

Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nft_meta.h       |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c | 19 ++++++++++++++++++-
 net/netfilter/nft_meta.c               |  5 +++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index f74e63290603d9..6cf1d910bbf8da 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -40,6 +40,8 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 void nft_meta_set_destroy(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
+int nft_meta_get_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr);
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 219c4068026026..3d95f68e0906ab 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -107,12 +107,30 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 					NULL, NFT_DATA_VALUE, len);
 }
 
+static int nft_meta_bridge_get_validate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr)
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	switch (priv->key) {
+	case NFT_META_BRI_IIFHWADDR:
+		hooks = 1 << NF_BR_PRE_ROUTING;
+		break;
+	default:
+		return nft_meta_get_validate(ctx, expr);
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
 static struct nft_expr_type nft_meta_bridge_type;
 static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.type		= &nft_meta_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
+	.validate	= nft_meta_bridge_get_validate,
 	.dump		= nft_meta_get_dump,
 };
 
@@ -168,7 +186,6 @@ static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
 
 	switch (priv->key) {
 	case NFT_META_BRI_BROUTE:
-	case NFT_META_BRI_IIFHWADDR:
 		hooks = 1 << NF_BR_PRE_ROUTING;
 		break;
 	default:
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 5b25851381e524..db937d66210d91 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -635,8 +635,8 @@ static int nft_meta_get_validate_xfrm(const struct nft_ctx *ctx)
 #endif
 }
 
-static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr)
+int nft_meta_get_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -652,6 +652,7 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_validate);
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr)
-- 
2.53.0



