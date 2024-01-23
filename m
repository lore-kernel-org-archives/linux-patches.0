Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D006772E;
	Tue, 23 Jan 2024 02:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975291; cv=none; b=HoklB6etFoskpHN9jH0xS2U3q4oyo7qsEQ+trZ+qHK0lQExX2ORWJ/fVOQiHSOmWpvVT34cp1ZDSuhK3so7vAzt6c201N4MSoOdJiQkt8QdDlAUUzl9w0Pkmt+Xx783jlQ+JQeOBru46wz6zvFwROzRbdoOhhRSheSSoThLHSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975291; c=relaxed/simple;
	bh=7ubf1BClcqPedgqjXyVGquKUgQg1IDxJwk+3+dxPLgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZ8NAxHxYJ3UaIA6Gc1167cW3JXH0aJhp5VO9GBpN8pvQuVuVLNBRolrJwT5bUXsZsgrajPlqujssEXJbPJ1Dg7dSgSkRFZH44wZtoDJT/2OSgxWMpt+2mev1o4ahYVFidt6FyGOOhBoUcZRyNPzivTiiQ4lSFxsrTQn9uPFjc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtJ4Y2Qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtJ4Y2Qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB84C433C7;
	Tue, 23 Jan 2024 02:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975290;
	bh=7ubf1BClcqPedgqjXyVGquKUgQg1IDxJwk+3+dxPLgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtJ4Y2QqdrSx1MuYp5Cfi2tML7bEZv3VlDYd6k5cFzFa60eU4BS35uPwq4jsLUx+H
	 QGtffU1ceWyv0ayAYVuv7vn6J7DJ0E8xo4VYg9ddYEdx7i5PpgeEmoZSWcSvpaj02h
	 WLMdMQsWqBD8G1QlnT13Xaymz7PnK5d+j0zmJ6oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 349/374] netfilter: nft_limit: move stateful fields out of expression data
Date: Mon, 22 Jan 2024 16:00:05 -0800
Message-ID: <20240122235757.068305108@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

[ Upstream commit 3b9e2ea6c11bff72ac1d607f6b954e7666b47409 ]

In preparation for the rule blob representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a139cee120 ("netfilter: nft_limit: do not ignore unsupported flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_limit.c | 94 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index d6e0226b7603..f04be5be73a0 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -14,10 +14,14 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_limit_priv {
+struct nft_limit {
 	spinlock_t	lock;
 	u64		last;
 	u64		tokens;
+};
+
+struct nft_limit_priv {
+	struct nft_limit *limit;
 	u64		tokens_max;
 	u64		rate;
 	u64		nsecs;
@@ -30,21 +34,21 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 	u64 now, tokens;
 	s64 delta;
 
-	spin_lock_bh(&priv->lock);
+	spin_lock_bh(&priv->limit->lock);
 	now = ktime_get_ns();
-	tokens = priv->tokens + now - priv->last;
+	tokens = priv->limit->tokens + now - priv->limit->last;
 	if (tokens > priv->tokens_max)
 		tokens = priv->tokens_max;
 
-	priv->last = now;
+	priv->limit->last = now;
 	delta = tokens - cost;
 	if (delta >= 0) {
-		priv->tokens = delta;
-		spin_unlock_bh(&priv->lock);
+		priv->limit->tokens = delta;
+		spin_unlock_bh(&priv->limit->lock);
 		return priv->invert;
 	}
-	priv->tokens = tokens;
-	spin_unlock_bh(&priv->lock);
+	priv->limit->tokens = tokens;
+	spin_unlock_bh(&priv->limit->lock);
 	return !priv->invert;
 }
 
@@ -86,8 +90,12 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 				 priv->rate);
 	}
 
-	priv->tokens = tokens;
-	priv->tokens_max = priv->tokens;
+	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL);
+	if (!priv->limit)
+		return -ENOMEM;
+
+	priv->limit->tokens = tokens;
+	priv->tokens_max = priv->limit->tokens;
 
 	if (tb[NFTA_LIMIT_FLAGS]) {
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
@@ -95,8 +103,8 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 		if (flags & NFT_LIMIT_F_INV)
 			priv->invert = true;
 	}
-	priv->last = ktime_get_ns();
-	spin_lock_init(&priv->lock);
+	priv->limit->last = ktime_get_ns();
+	spin_lock_init(&priv->limit->lock);
 
 	return 0;
 }
@@ -121,6 +129,32 @@ static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit_priv *priv
 	return -1;
 }
 
+static void nft_limit_destroy(const struct nft_ctx *ctx,
+			      const struct nft_limit_priv *priv)
+{
+	kfree(priv->limit);
+}
+
+static int nft_limit_clone(struct nft_limit_priv *priv_dst,
+			   const struct nft_limit_priv *priv_src)
+{
+	priv_dst->tokens_max = priv_src->tokens_max;
+	priv_dst->rate = priv_src->rate;
+	priv_dst->nsecs = priv_src->nsecs;
+	priv_dst->burst = priv_src->burst;
+	priv_dst->invert = priv_src->invert;
+
+	priv_dst->limit = kmalloc(sizeof(*priv_dst->limit), GFP_ATOMIC);
+	if (priv_dst->limit)
+		return -ENOMEM;
+
+	spin_lock_init(&priv_dst->limit->lock);
+	priv_dst->limit->tokens = priv_src->tokens_max;
+	priv_dst->limit->last = ktime_get_ns();
+
+	return 0;
+}
+
 struct nft_limit_priv_pkts {
 	struct nft_limit_priv	limit;
 	u64			cost;
@@ -166,12 +200,30 @@ static int nft_limit_pkts_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
 
+static void nft_limit_pkts_destroy(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
+
+	nft_limit_destroy(ctx, &priv->limit);
+}
+
+static int nft_limit_pkts_clone(struct nft_expr *dst, const struct nft_expr *src)
+{
+	struct nft_limit_priv_pkts *priv_dst = nft_expr_priv(dst);
+	struct nft_limit_priv_pkts *priv_src = nft_expr_priv(src);
+
+	return nft_limit_clone(&priv_dst->limit, &priv_src->limit);
+}
+
 static struct nft_expr_type nft_limit_type;
 static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.type		= &nft_limit_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.eval		= nft_limit_pkts_eval,
 	.init		= nft_limit_pkts_init,
+	.destroy	= nft_limit_pkts_destroy,
+	.clone		= nft_limit_pkts_clone,
 	.dump		= nft_limit_pkts_dump,
 };
 
@@ -203,12 +255,30 @@ static int nft_limit_bytes_dump(struct sk_buff *skb,
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
 
+static void nft_limit_bytes_destroy(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	const struct nft_limit_priv *priv = nft_expr_priv(expr);
+
+	nft_limit_destroy(ctx, priv);
+}
+
+static int nft_limit_bytes_clone(struct nft_expr *dst, const struct nft_expr *src)
+{
+	struct nft_limit_priv *priv_dst = nft_expr_priv(dst);
+	struct nft_limit_priv *priv_src = nft_expr_priv(src);
+
+	return nft_limit_clone(priv_dst, priv_src);
+}
+
 static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.type		= &nft_limit_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv)),
 	.eval		= nft_limit_bytes_eval,
 	.init		= nft_limit_bytes_init,
 	.dump		= nft_limit_bytes_dump,
+	.clone		= nft_limit_bytes_clone,
+	.destroy	= nft_limit_bytes_destroy,
 };
 
 static const struct nft_expr_ops *
-- 
2.43.0



