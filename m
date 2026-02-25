Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2420C012;
	Wed, 25 Feb 2026 01:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984006; cv=none; b=US/yxRvCFSVXk1txqIhCctjGAcrEANMWTKyhayoiLxfDwl8ShUW7U8a9+HLrNETCHjUASTDbhxc4uUDL7alE05vxCXNYTGBdt5H4yUJ8DmAKQgAt1PGw2aNzXW46aC+gXW7EKLAYjNom0QlePu2G5R2u6sbXefaREgIjN7xS3V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984006; c=relaxed/simple;
	bh=StMfyMdAexElVfSyxqvE+gZcYWW3iV5EnjPS+gwpa2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hunV2mJQRgj7g0fypneczc/LSsX6sFS4eRpuaU+EOR41ZzUQh0hlkFdOVkYr6HFiXIjxenE06p2HYHkxpMovQSFRbLhcap+RLfTu9N8YNbzcXUq50zuqpWdElyQqGlF7ieGCKs/oDVTwBxrvBqtVMckHhH1JNjRXg893ALqgyKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFGb867E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFGb867E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17E3C116D0;
	Wed, 25 Feb 2026 01:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984005;
	bh=StMfyMdAexElVfSyxqvE+gZcYWW3iV5EnjPS+gwpa2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFGb867EXFe6zT9mERAT4soanzlLGwIfZ8o1jAiVTFzkP11vTL8jAkjsI197g6XgY
	 31aLHEYhPKSwzQWJRUgbd67ubZ2fz8IqhpxfsnkWhNfXhuuJhcvC4HH9eGlanqcjwy
	 4t0o2L+JV5j4F7VIv+hhEKydm3nFnFpK5c86y5Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 257/641] netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
Date: Tue, 24 Feb 2026 17:19:43 -0800
Message-ID: <20260225012355.062807501@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 828d5c64c68a3..8487808c87614 100644
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
index d4964087bbc5e..714a594859357 100644
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



