Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90740350D46;
	Tue, 26 Aug 2025 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218434; cv=none; b=GtNaXzKM0tMT2SdA/+RkLiMYanyQ1ysN6Q/FGVmsPbBEuGN6nMBVvtBhXJUALKOtPflTvP3dsCMqybhLmoLEIeqNTO7vKM5gEdN/zuRY6GuPqhF2sv/jIoLIyCSOo3OjMt9WUS7MYarXXpjoPlEFxAokYdF7NMcpcwXqDIFusps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218434; c=relaxed/simple;
	bh=7hQWE8WTZ+JoTpjO0auMkiJ0B8FRDJLnwZrvopPMecM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um+YFFaANahx79VbkRrWLw42MI3mhR1083Kc7VV7gvn/pML0zzUAmHK3pnNuaUCVMN9wUO3ASjrOZNoOQmbMMQlRqFxjZzcFYT9weCfF4TZj4CsE+qWg3LRPARyHggEfISKq5jamOC28qR6mYgdRGNvAatSxvaE5lbIlTZRaL0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sk0QKJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sk0QKJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEB1C4CEF1;
	Tue, 26 Aug 2025 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218434;
	bh=7hQWE8WTZ+JoTpjO0auMkiJ0B8FRDJLnwZrvopPMecM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sk0QKJrKvoTQetqaavyVQ/LiyVM+n76UE7vCfUzgMXipGhsbQTdctCzeeNNTDum0
	 JjrmHDNJG9VuJrcacm6JHXXUSejHs5Y0FwadlefEzVfEvb9piFBl0Z0bXu1AjYQCqw
	 pO3mpP+/6CyFmGZW3J8ZsZtM5W9EFxbDgM+HnB2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose M. Guisado Gomez" <guigom@riseup.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 521/523] netfilter: nft_reject: unify reject init and dump into nft_reject
Date: Tue, 26 Aug 2025 13:12:11 +0200
Message-ID: <20250826110937.289702834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jose M. Guisado Gomez <guigom@riseup.net>

[ Upstream commit 312ca575a50543a886a5dfa2af1e72aa6a5b601e ]

Bridge family is using the same static init and dump function as inet.

This patch removes duplicate code unifying these functions body into
nft_reject.c so they can be reused in the rest of families supporting
reject verdict.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a79b792204 ("netfilter: nf_reject: don't leak dst refcount for loopback packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/nft_reject_bridge.c | 60 +-----------------------
 net/netfilter/nft_reject.c               | 12 ++++-
 net/netfilter/nft_reject_inet.c          | 60 +-----------------------
 3 files changed, 15 insertions(+), 117 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index deae2c9a0f69..9ffadcd524f8 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -364,69 +364,13 @@ static int nft_reject_bridge_validate(const struct nft_ctx *ctx,
 						    (1 << NF_BR_LOCAL_IN));
 }
 
-static int nft_reject_bridge_init(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr,
-				  const struct nlattr * const tb[])
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code;
-
-	if (tb[NFTA_REJECT_TYPE] == NULL)
-		return -EINVAL;
-
-	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
-			return -EINVAL;
-
-		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
-		    icmp_code > NFT_REJECT_ICMPX_MAX)
-			return -EINVAL;
-
-		priv->icmp_code = icmp_code;
-		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int nft_reject_bridge_dump(struct sk_buff *skb,
-				  const struct nft_expr *expr)
-{
-	const struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, htonl(priv->type)))
-		goto nla_put_failure;
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
-			goto nla_put_failure;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
 static struct nft_expr_type nft_reject_bridge_type;
 static const struct nft_expr_ops nft_reject_bridge_ops = {
 	.type		= &nft_reject_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
 	.eval		= nft_reject_bridge_eval,
-	.init		= nft_reject_bridge_init,
-	.dump		= nft_reject_bridge_dump,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
 	.validate	= nft_reject_bridge_validate,
 };
 
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 61fb7e8afbf0..927ff8459bd9 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -40,6 +40,7 @@ int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nlattr * const tb[])
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
+	int icmp_code;
 
 	if (tb[NFTA_REJECT_TYPE] == NULL)
 		return -EINVAL;
@@ -47,9 +48,17 @@ int nft_reject_init(const struct nft_ctx *ctx,
 	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
+	case NFT_REJECT_ICMPX_UNREACH:
 		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
 			return -EINVAL;
-		priv->icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+
+		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
+		    icmp_code > NFT_REJECT_ICMPX_MAX)
+			return -EINVAL;
+
+		priv->icmp_code = icmp_code;
+		break;
 	case NFT_REJECT_TCP_RST:
 		break;
 	default:
@@ -69,6 +78,7 @@ int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
+	case NFT_REJECT_ICMPX_UNREACH:
 		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
 			goto nla_put_failure;
 		break;
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index c00b94a16682..115aa446f6d5 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -60,69 +60,13 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 	regs->verdict.code = NF_DROP;
 }
 
-static int nft_reject_inet_init(const struct nft_ctx *ctx,
-				const struct nft_expr *expr,
-				const struct nlattr * const tb[])
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code;
-
-	if (tb[NFTA_REJECT_TYPE] == NULL)
-		return -EINVAL;
-
-	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
-			return -EINVAL;
-
-		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
-		    icmp_code > NFT_REJECT_ICMPX_MAX)
-			return -EINVAL;
-
-		priv->icmp_code = icmp_code;
-		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int nft_reject_inet_dump(struct sk_buff *skb,
-				const struct nft_expr *expr)
-{
-	const struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, htonl(priv->type)))
-		goto nla_put_failure;
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
-			goto nla_put_failure;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
 static struct nft_expr_type nft_reject_inet_type;
 static const struct nft_expr_ops nft_reject_inet_ops = {
 	.type		= &nft_reject_inet_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
 	.eval		= nft_reject_inet_eval,
-	.init		= nft_reject_inet_init,
-	.dump		= nft_reject_inet_dump,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
 	.validate	= nft_reject_validate,
 };
 
-- 
2.50.1



