Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA7E2D73AB;
	Thu, 15 Jan 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499107; cv=none; b=SFUEhs5AWptrMnX3QMp8AIq1SdtVqiOPmh72W+BAlAdLa1IrAzJyWcH2Uaj7nOQbIFaRtfewZ+ck+P/ipXisuh9xw0zTT/wwi5eO6hwntJGurfYTlrc+mPyZBXjVlQfB9L8AmX/mLZXBMc0fOqUtueOhItl9E5buBVOHFdedzYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499107; c=relaxed/simple;
	bh=jHFLeeaRb0huO+TlcIc/XJ8tMSZsT2770N8IwUeaADM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz5fUniwjoWQ8HDX42tLHyM8ewKz4RJWMD88f5yqp9RkiCbsNDnUtYcE9+LNtTpHfKTZd1ff4tknXQ8oWeMdeF9x8tjIapY3KedIeU4QvfzZuY8OrQqgZab7nq4V964eLaOVTZ283TAbsoC9nwuU+jNKyJS85KdI9qWUxjIr0rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feXGHDp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feXGHDp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC413C116D0;
	Thu, 15 Jan 2026 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499107;
	bh=jHFLeeaRb0huO+TlcIc/XJ8tMSZsT2770N8IwUeaADM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feXGHDp6pWzR8QhPZJKcCk0sqErOvfP8OK81K8yka9DCzq4XtRFKrMZrnVOCdUsOS
	 oL0Cw98L0ATabQx51Y6Wot0gXvbvnjD7cpU4B0vNRraT4e4tWhnlUFZg5JfX3A3L02
	 CU51RlTnxcpC75loUnlBMLQNkAEQ2qwq88adGERQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/451] netfilter: nft_connlimit: move stateful fields out of expression data
Date: Thu, 15 Jan 2026 17:45:11 +0100
Message-ID: <20260115164234.897738785@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 37f319f37d9005693dff085bb72852eeebc803ef ]

In preparation for the rule blob representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_connlimit.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 091457e5c260d..332f1b21084f8 100644
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
@@ -200,7 +205,11 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src,
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
2.51.0



