Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BDB38F620
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302124; cv=none; b=rufNGZedsq3IphNoevImrqWQCAoPLKXHM83e4HJTHEmEa8b3V+6U8mjeyKAOX+gOmv9rTvI+bDTXgBcsxEB1jDgC1rp9ef76mohb4cvsD/ncdHJSUq31xblzrTRRbVsMgfAceL+RX0kX4XCIUO8u6Cv8Cq/y7v0g3YGsBWxsJes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302124; c=relaxed/simple;
	bh=HSdW39q43kmBaHfzUlPNAtBTA1bWZhFz8wiixKjE14I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUYF06nvd/SS7exiZdLACUD1elT4YIj52vsRGw+tjs+DSxNMDB2F2ATyh08MfpEiZws6dOXVzIFGwqMpNIEzrg16EEAe6TsxAFMw5Yg6pn3Z6v+DXvGD0JMCuW3mD1xhjr3QACGNJ4ZRVaTm2IEyp947uX/NAhO3NjEodX5usHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJCdnAPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJCdnAPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DA0C116D0;
	Sat, 28 Feb 2026 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302124;
	bh=HSdW39q43kmBaHfzUlPNAtBTA1bWZhFz8wiixKjE14I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJCdnAPDzvvvuFqi54LXIs+jz4v55VJxFRYoCS9gOr+OdzwMJEac3kmw5mCWdA4Ga
	 aKkC2oOTjrWUnHR5BGyV5HCSW5ucLwSH4PFq2V7RYQY4DHrOQMy7qhg2LReJC0FiDA
	 jF2VRwazZALTFGxze0fiU73FQA275SRzLLf108bWOUVV1E2BiBu5vcnWlZQ31+FB0S
	 zGPyrebnw6JtGYrov+h7TFQzJtkQWD/6MmoqCdc0Qw9Z7rWcRrzqrVMUekM7Blvbhy
	 sq3N/GaUfFj/ZFKhhsvEq9bmKkguSvERIulQYFAHBHQOjLB/8OO7VLbU2sHZ6eauJ6
	 KqPv6JHaq9QYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/283] netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
Date: Sat, 28 Feb 2026 13:04:18 -0500
Message-ID: <20260228180709.1583486-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c0362b5748282e22fa1592a8d3474f726ad964c2 ]

For convenience when performing GC over the connection list, make
nf_conncount_gc_list() to disable BH. This unifies the behavior with
nf_conncount_add() and nf_conncount_count().

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 21d033e47273 ("netfilter: nf_conncount: increase the connection clean up limit to 64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c  | 24 +++++++++++++++++-------
 net/netfilter/nft_connlimit.c |  7 +------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index a2c5a7ba0c6fc..70e9662fe1777 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -282,8 +282,8 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
 /* Return true if the list is empty. Must be called with BH disabled. */
-bool nf_conncount_gc_list(struct net *net,
-			  struct nf_conncount_list *list)
+static bool __nf_conncount_gc_list(struct net *net,
+				   struct nf_conncount_list *list)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
@@ -295,10 +295,6 @@ bool nf_conncount_gc_list(struct net *net,
 	if ((u32)jiffies == READ_ONCE(list->last_gc))
 		return false;
 
-	/* don't bother if other cpu is already doing GC */
-	if (!spin_trylock(&list->list_lock))
-		return false;
-
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
@@ -327,7 +323,21 @@ bool nf_conncount_gc_list(struct net *net,
 	if (!list->count)
 		ret = true;
 	list->last_gc = (u32)jiffies;
-	spin_unlock(&list->list_lock);
+
+	return ret;
+}
+
+bool nf_conncount_gc_list(struct net *net,
+			  struct nf_conncount_list *list)
+{
+	bool ret;
+
+	/* don't bother if other cpu is already doing GC */
+	if (!spin_trylock_bh(&list->list_lock))
+		return false;
+
+	ret = __nf_conncount_gc_list(net, list);
+	spin_unlock_bh(&list->list_lock);
 
 	return ret;
 }
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 83a7d5769396c..5dd50b3ab5a45 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -232,13 +232,8 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
-	bool ret;
 
-	local_bh_disable();
-	ret = nf_conncount_gc_list(net, priv->list);
-	local_bh_enable();
-
-	return ret;
+	return nf_conncount_gc_list(net, priv->list);
 }
 
 static struct nft_expr_type nft_connlimit_type;
-- 
2.51.0

