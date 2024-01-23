Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A1765BB9;
	Tue, 23 Jan 2024 01:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975099; cv=none; b=Il3o7ZTEShynku4YHBtRwgH19MsjmciU6zj33pBzH+qSJIU2bavOQY4y5i3jLvyxKWeGN/uhS3ehXhwxcLxLMrEaF0407figt/fr0zmm6nYm1VH2/0dOdjOxSQkWSRch0f/UmL9r/wqN9cvv6huxvbRWlyKcKPP4vquxZvqrzXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975099; c=relaxed/simple;
	bh=TucIF5faZD3XjtBOwC6XJr7Sq/Mr3FVc0y3eBnaXSAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M33ktp0lSz03zBsq4E3nN9HMtpdCRdIBxxU8XN0tIhF2zXl65euMcRvaH91GneI4zkPTu1yNfsvpbVeolzsKdH10XH6TnGlryiIQf+6kXXBECWiXEXDQP2+5n79fLxQchZgILBfOOgkMA54lgWbrZy916b/UuULtdlgrNG79xaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diuclUDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diuclUDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F914C43394;
	Tue, 23 Jan 2024 01:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975099;
	bh=TucIF5faZD3XjtBOwC6XJr7Sq/Mr3FVc0y3eBnaXSAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diuclUDjsJ5PffHH8OA43VXOKoXho4nRo/aeM49O/sQognGV0Zyi3vALrPbCiuzY2
	 6AJtJuT36TWQr0K2FoKslE40hzlFSGTrNp6Qy1IpE7WGQN7NJI+iA8/6Sq7rxDvy3S
	 vv4d2GeezleA3crII71DDAiaumekvBK52oXvp/2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/374] netfilter: nft_quota: move stateful fields out of expression data
Date: Mon, 22 Jan 2024 16:00:03 -0800
Message-ID: <20240122235756.993868390@linuxfoundation.org>
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

[ Upstream commit ed0a0c60f0e50fa52853620672af97edde3d3a03 ]

In preparation for the rule blob representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a139cee120 ("netfilter: nft_limit: do not ignore unsupported flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_quota.c | 52 +++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index c4d1389f7185..0484aef74273 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -15,13 +15,13 @@
 struct nft_quota {
 	atomic64_t	quota;
 	unsigned long	flags;
-	atomic64_t	consumed;
+	atomic64_t	*consumed;
 };
 
 static inline bool nft_overquota(struct nft_quota *priv,
 				 const struct sk_buff *skb)
 {
-	return atomic64_add_return(skb->len, &priv->consumed) >=
+	return atomic64_add_return(skb->len, priv->consumed) >=
 	       atomic64_read(&priv->quota);
 }
 
@@ -90,13 +90,23 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 			return -EOPNOTSUPP;
 	}
 
+	priv->consumed = kmalloc(sizeof(*priv->consumed), GFP_KERNEL);
+	if (!priv->consumed)
+		return -ENOMEM;
+
 	atomic64_set(&priv->quota, quota);
 	priv->flags = flags;
-	atomic64_set(&priv->consumed, consumed);
+	atomic64_set(priv->consumed, consumed);
 
 	return 0;
 }
 
+static void nft_quota_do_destroy(const struct nft_ctx *ctx,
+				 struct nft_quota *priv)
+{
+	kfree(priv->consumed);
+}
+
 static int nft_quota_obj_init(const struct nft_ctx *ctx,
 			      const struct nlattr * const tb[],
 			      struct nft_object *obj)
@@ -128,7 +138,7 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	 * that we see, don't go over the quota boundary in what we send to
 	 * userspace.
 	 */
-	consumed = atomic64_read(&priv->consumed);
+	consumed = atomic64_read(priv->consumed);
 	quota = atomic64_read(&priv->quota);
 	if (consumed >= quota) {
 		consumed_cap = quota;
@@ -145,7 +155,7 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 		goto nla_put_failure;
 
 	if (reset) {
-		atomic64_sub(consumed, &priv->consumed);
+		atomic64_sub(consumed, priv->consumed);
 		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
 	}
 	return 0;
@@ -162,11 +172,20 @@ static int nft_quota_obj_dump(struct sk_buff *skb, struct nft_object *obj,
 	return nft_quota_do_dump(skb, priv, reset);
 }
 
+static void nft_quota_obj_destroy(const struct nft_ctx *ctx,
+				  struct nft_object *obj)
+{
+	struct nft_quota *priv = nft_obj_data(obj);
+
+	return nft_quota_do_destroy(ctx, priv);
+}
+
 static struct nft_object_type nft_quota_obj_type;
 static const struct nft_object_ops nft_quota_obj_ops = {
 	.type		= &nft_quota_obj_type,
 	.size		= sizeof(struct nft_quota),
 	.init		= nft_quota_obj_init,
+	.destroy	= nft_quota_obj_destroy,
 	.eval		= nft_quota_obj_eval,
 	.dump		= nft_quota_obj_dump,
 	.update		= nft_quota_obj_update,
@@ -205,12 +224,35 @@ static int nft_quota_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return nft_quota_do_dump(skb, priv, false);
 }
 
+static void nft_quota_destroy(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr)
+{
+	struct nft_quota *priv = nft_expr_priv(expr);
+
+	return nft_quota_do_destroy(ctx, priv);
+}
+
+static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
+{
+	struct nft_quota *priv_dst = nft_expr_priv(dst);
+
+	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
+	if (priv_dst->consumed)
+		return -ENOMEM;
+
+	atomic64_set(priv_dst->consumed, 0);
+
+	return 0;
+}
+
 static struct nft_expr_type nft_quota_type;
 static const struct nft_expr_ops nft_quota_ops = {
 	.type		= &nft_quota_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_quota)),
 	.eval		= nft_quota_eval,
 	.init		= nft_quota_init,
+	.destroy	= nft_quota_destroy,
+	.clone		= nft_quota_clone,
 	.dump		= nft_quota_dump,
 };
 
-- 
2.43.0



