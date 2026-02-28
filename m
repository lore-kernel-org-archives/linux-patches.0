Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258BF36C9ED
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302368; cv=none; b=sfOf3VYD+xg7pQwedhbvX8eJ6T0IZ3QrZCKaCx9OplEFBGjQY/f9u0MPXaO2+H3tYPi6Azkc5TP1wdetFyYEgDWK7QBBNx/g45eJbDPJS71XVyyI9mmhCsUItVuO0LTHTiuapNoe+a2mYSSIyvqtqp4o5p3B2ONYe28JsWIbMW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302368; c=relaxed/simple;
	bh=Us4u7UKJUcwuiKxU/zN/rDKx+I2ow7PPDJz2XclRFE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdoAZG98/tMSshA3cwocR1n+cOZtMbZJe3cGQl6ta1rbLBj19ChumpZv6HuB/dcLETO8VZQLpU0iszDfqftGJ+k/xWhun/+q82tYREpe4yP1Q5ZWHug4rKFjbIAyF/zuumI7zCGR9NQAgyYwMYszWhe5vkTXDg0rKOmXQqWqu4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gD/EZnnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gD/EZnnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C430C116D0;
	Sat, 28 Feb 2026 18:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302368;
	bh=Us4u7UKJUcwuiKxU/zN/rDKx+I2ow7PPDJz2XclRFE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gD/EZnnu4lh1mkRuxL7ziImjCA608yKH8R5e3Nar7I+HBYvfeWIHn0VFr/7Rggmn2
	 KSN/plhHH4v6ij4+BvMbrX7gPnNke9qkh6KrdTuhK3VS1gI1Tv2itQu0N6FCRMJ10U
	 WPeVNcrzsqy81DmQXWKtv1VMbuDJpD+g4gcY6d+b1C6FwUsgqey/nVWjRF89paHjbF
	 vLY1u1tHmBuPGMdWRqF1ux7xM0C7q5/idJtBU0bt/lXRgD4JRv5Koq2yKIUKr8aRzk
	 pAeeRja+dvF2cS2XZUWlDe3+nO2o90iDE+8/pDHT8+ywfBLEaRuG3E1ICMcI7XAFAu
	 Dmx+MqOzojpKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/232] netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
Date: Sat, 28 Feb 2026 13:09:09 -0500
Message-ID: <20260228181127.1592657-96-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index f47a4932dc734..b3411dec16fd2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -231,13 +231,8 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
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

