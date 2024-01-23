Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB72964CF0;
	Tue, 23 Jan 2024 01:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975075; cv=none; b=SzP/Xn6sTTm7w8Ts/CF6gMRe7yQIDos7/3reS51nEpPXIWm7yVBggD8mkrwOE7JxCk8Q7j5Fpf7tXnLhkJduP6zTymgNe5SZ5z8MAcFHn5AdAG3cqyeU2KQFhE5S+DScgBuCnhdoiZWvqLC61Wa/Sw3TSjm4GTKVOIavU9HS9e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975075; c=relaxed/simple;
	bh=uARX7/DlCit3J6jgAKo/zISns3caSqT7BXyFpVqDUHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObvDn4Qym6n9UMKt+1GwqWTyZi0jcxlo6MGXgn+DvPFSnnQ2biU5n1U4jdPJ2QeAS1iqYJCo24L3HGFpS/VSyFLU/nZA+xgm9gtqry5aqre/M4C33nJl0B/jFkFDEKqcd1fS2TESlb6C9e0dYJHo08ulen3HsL9HNuLM9Vn2vhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omhVdTyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omhVdTyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70211C433C7;
	Tue, 23 Jan 2024 01:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975075;
	bh=uARX7/DlCit3J6jgAKo/zISns3caSqT7BXyFpVqDUHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omhVdTytyDbGWpx0cIGnlHDWJHM2q+6rUQc53QeTuzAbo40lSF/T6yVTrnBVkP/UO
	 3mQwdRuUiG/3DT1wC8FgD6ZJLpBqRLAGz7Me2dyqsLNAOVZXkH7lprpyvqgYgHuWV/
	 6ZK03JtB7abPs7rMNnzEwG3/4hAULhfTMpMljZOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/374] netfilter: nft_last: move stateful fields out of expression data
Date: Mon, 22 Jan 2024 16:00:02 -0800
Message-ID: <20240122235756.957356741@linuxfoundation.org>
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

[ Upstream commit 33a24de37e814572491bcb35f42c0de74ad67586 ]

In preparation for the rule blob representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a139cee120 ("netfilter: nft_limit: do not ignore unsupported flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_last.c | 69 +++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 304e33cbed9b..5ee33d0ccd4e 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -8,9 +8,13 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
+struct nft_last {
+	unsigned long	jiffies;
+	unsigned int	set;
+};
+
 struct nft_last_priv {
-	unsigned long	last_jiffies;
-	unsigned int	last_set;
+	struct nft_last	*last;
 };
 
 static const struct nla_policy nft_last_policy[NFTA_LAST_MAX + 1] = {
@@ -22,47 +26,55 @@ static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
+	struct nft_last *last;
 	u64 last_jiffies;
-	u32 last_set = 0;
 	int err;
 
-	if (tb[NFTA_LAST_SET]) {
-		last_set = ntohl(nla_get_be32(tb[NFTA_LAST_SET]));
-		if (last_set == 1)
-			priv->last_set = 1;
-	}
+	last = kzalloc(sizeof(*last), GFP_KERNEL);
+	if (!last)
+		return -ENOMEM;
+
+	if (tb[NFTA_LAST_SET])
+		last->set = ntohl(nla_get_be32(tb[NFTA_LAST_SET]));
 
-	if (last_set && tb[NFTA_LAST_MSECS]) {
+	if (last->set && tb[NFTA_LAST_MSECS]) {
 		err = nf_msecs_to_jiffies64(tb[NFTA_LAST_MSECS], &last_jiffies);
 		if (err < 0)
-			return err;
+			goto err;
 
-		priv->last_jiffies = jiffies - (unsigned long)last_jiffies;
+		last->jiffies = jiffies - (unsigned long)last_jiffies;
 	}
+	priv->last = last;
 
 	return 0;
+err:
+	kfree(last);
+
+	return err;
 }
 
 static void nft_last_eval(const struct nft_expr *expr,
 			  struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
+	struct nft_last *last = priv->last;
 
-	if (READ_ONCE(priv->last_jiffies) != jiffies)
-		WRITE_ONCE(priv->last_jiffies, jiffies);
-	if (READ_ONCE(priv->last_set) == 0)
-		WRITE_ONCE(priv->last_set, 1);
+	if (READ_ONCE(last->jiffies) != jiffies)
+		WRITE_ONCE(last->jiffies, jiffies);
+	if (READ_ONCE(last->set) == 0)
+		WRITE_ONCE(last->set, 1);
 }
 
 static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
-	unsigned long last_jiffies = READ_ONCE(priv->last_jiffies);
-	u32 last_set = READ_ONCE(priv->last_set);
+	struct nft_last *last = priv->last;
+	unsigned long last_jiffies = READ_ONCE(last->jiffies);
+	u32 last_set = READ_ONCE(last->set);
 	__be64 msecs;
 
 	if (time_before(jiffies, last_jiffies)) {
-		WRITE_ONCE(priv->last_set, 0);
+		WRITE_ONCE(last->set, 0);
 		last_set = 0;
 	}
 
@@ -81,11 +93,32 @@ static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static void nft_last_destroy(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr)
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+
+	kfree(priv->last);
+}
+
+static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
+{
+	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
+
+	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
+	if (priv_dst->last)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_last_ops = {
 	.type		= &nft_last_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_last_priv)),
 	.eval		= nft_last_eval,
 	.init		= nft_last_init,
+	.destroy	= nft_last_destroy,
+	.clone		= nft_last_clone,
 	.dump		= nft_last_dump,
 };
 
-- 
2.43.0



