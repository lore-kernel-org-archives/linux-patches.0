Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CA167734;
	Tue, 23 Jan 2024 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975292; cv=none; b=rg0/lQtFHobDGCpCHLe8aYmCLdPzVRjVYJytY90LicT/VqwHrEaj3JaUn/DS1pE4cVYNwBUyQBPwip4TusxfZsKBnxPZqcGzL6fb/HI1yNTU2YxOVQMr7CR/aGMIvWg9iEnIETJjUTrnf6e+5xVBs1etX1yTXH9F4uHEs/O4770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975292; c=relaxed/simple;
	bh=MI13I/r4tcj83ynYUMe+B14zxG0+IfQWaD8e/Rk/r9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggtLvGhk6xHP5msM0rS65GcUqOQbzGG+PHxB8MzZNB6qgARjWXzL9K6+MhuaUjAD7ubHk3gVwaCY9/81qFXyaCjH2cIy0SLpsVcJoWOwyRAF5PygpaNsuOCARTY290Vl5hVz+Zv9hjB/tlq0Yer2alUR6p1YWiOSVPnMRIfoUb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRVQeKyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRVQeKyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A5FC433C7;
	Tue, 23 Jan 2024 02:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975292;
	bh=MI13I/r4tcj83ynYUMe+B14zxG0+IfQWaD8e/Rk/r9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRVQeKyk3cO8zcoZhHbkX6ER4mR4Z/I75E/qWhMqInkaV83NWWmeWmynbmwLFx/4H
	 5ZE4t8qPUtObEY6ccWuexU1WsfiH05i6cTPhNePUgqS3ACIoIigo7ai1fp154agGYH
	 yJLuJJ67NST4fXleN+FWHBABLXjEu/o1DPmzjv2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 345/374] netfilter: nft_connlimit: move stateful fields out of expression data
Date: Mon, 22 Jan 2024 16:00:01 -0800
Message-ID: <20240122235756.923226102@linuxfoundation.org>
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

[ Upstream commit 37f319f37d9005693dff085bb72852eeebc803ef ]

In preparation for the rule blob representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a139cee120 ("netfilter: nft_limit: do not ignore unsupported flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_connlimit.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 7d0761fad37e..58dcafe8bf79 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -14,7 +14,7 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 
 struct nft_connlimit {
-	struct nf_conncount_list	list;
+	struct nf_conncount_list	*list;
 	u32				limit;
 	bool				invert;
 };
@@ -43,12 +43,12 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	if (nf_conncount_add(nft_net(pkt), &priv->list, tuple_ptr, zone)) {
+	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
 
-	count = priv->list.count;
+	count = priv->list->count;
 
 	if ((count > priv->limit) ^ priv->invert) {
 		regs->verdict.code = NFT_BREAK;
@@ -76,7 +76,11 @@ static int nft_connlimit_do_init(const struct nft_ctx *ctx,
 			invert = true;
 	}
 
-	nf_conncount_list_init(&priv->list);
+	priv->list = kmalloc(sizeof(*priv->list), GFP_KERNEL);
+	if (!priv->list)
+		return -ENOMEM;
+
+	nf_conncount_list_init(priv->list);
 	priv->limit	= limit;
 	priv->invert	= invert;
 
@@ -87,7 +91,8 @@ static void nft_connlimit_do_destroy(const struct nft_ctx *ctx,
 				     struct nft_connlimit *priv)
 {
 	nf_ct_netns_put(ctx->net, ctx->family);
-	nf_conncount_cache_free(&priv->list);
+	nf_conncount_cache_free(priv->list);
+	kfree(priv->list);
 }
 
 static int nft_connlimit_do_dump(struct sk_buff *skb,
@@ -200,7 +205,11 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
-	nf_conncount_list_init(&priv_dst->list);
+	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
+	if (priv_dst->list)
+		return -ENOMEM;
+
+	nf_conncount_list_init(priv_dst->list);
 	priv_dst->limit	 = priv_src->limit;
 	priv_dst->invert = priv_src->invert;
 
@@ -212,7 +221,8 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
 
-	nf_conncount_cache_free(&priv->list);
+	nf_conncount_cache_free(priv->list);
+	kfree(priv->list);
 }
 
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
@@ -221,7 +231,7 @@ static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 	bool ret;
 
 	local_bh_disable();
-	ret = nf_conncount_gc_list(net, &priv->list);
+	ret = nf_conncount_gc_list(net, priv->list);
 	local_bh_enable();
 
 	return ret;
-- 
2.43.0



