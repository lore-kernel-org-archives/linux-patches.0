Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A74D35AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302718; cv=none; b=G6b8XWfRk1RkFW24fkquUbC+z0dUMLWJEUeV1jzS+cZTLvXYttfqd32okYjBMQlHY+gCV/9XGbh5gfmrdKM1oLAe6+h4ziMUKMlYzoTgilhCiCsSUMBuNS1NLA8RGgbWc0wcJuaOUt9BJswQlWp+VlzYlkvgLITINNC+1YLrMGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302718; c=relaxed/simple;
	bh=aK7/zT5PHCiFpbjb4b0JHZ1uM2XOHXa9HbiA3XHZgiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwAGYRLzJemzl4xf4O8JITSLIXKKgdArIiN7DvByRACVbs3K67TiKktGh6cxorCn2fOVEryAUvzxoHJY+lu+Hp+8QlPO8QKK5AdCOT3SpFuZL5rvfMphnSKV29lsTF1gCrDbZ5s2/016TEk08Endt5ON6K0T4EcM0xKWnoBzG50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6/EHBic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6/EHBic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3274C19423;
	Sat, 28 Feb 2026 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302718;
	bh=aK7/zT5PHCiFpbjb4b0JHZ1uM2XOHXa9HbiA3XHZgiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6/EHBicMOW12bnP8MMPm5CZ9D5yEWXh+mKGsL2UnwnuC5yOx/le/m9duRN4B9zDM
	 pWNAUpw+EctOc90jIpNSnN1ECL3O5NGe6OF3fY8nRbP5s8F8UJlQhHxQJwUC2XqOVy
	 B7NvaQ80ty/dPDSZzYyN6Z+4Jx5BXX14hgZ7xiBfSlt64Ck0/vXFS3dBl8OgYwkGoA
	 Qb7RE36otYDsw9scAis/rEMmKwIqs+Y9izddFk20lI+en2vzuyETJHlkB56509lCBB
	 mi/TQUdrWoa92ifwwwutzB7RA8ZoVhXCQDDyW+Xa1FIGiM0BSJDelKxo2lTqtSUikL
	 mPD1A5YUxXVAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/147] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Sat, 28 Feb 2026 13:16:26 -0500
Message-ID: <20260228181736.1605592-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 4780ec142cbb24b794129d3080eee5cac2943ffc ]

Userspace provides an optimized representation in case intervals are
adjacent, where the end element is omitted.

The existing partial overlap detection logic skips anonymous set checks
on start elements for this reason.

However, it is possible to add intervals that overlap to this anonymous
where two start elements with the same, eg. A-B, A-C where C < B.

      start     end
	A        B
      start  end
        A     C

Restore the check on overlapping start elements to report an overlap.

Fixes: c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index bbced30113e4e..e3cd66260c2d6 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -307,11 +307,23 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
 	return false;
 }
 
+/* Only for anonymous sets which do not allow updates, all element are active. */
+static struct nft_rbtree_elem *nft_rbtree_prev_active(struct nft_rbtree_elem *rbe)
+{
+	struct rb_node *node;
+
+	node = rb_prev(&rbe->node);
+	if (!node)
+		return NULL;
+
+	return rb_entry(node, struct nft_rbtree_elem, node);
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
 {
-	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
+	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
@@ -443,11 +455,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	/* - new start element with existing closest, less or equal key value
 	 *   being a start element: partial overlap, reported as -ENOTEMPTY.
 	 *   Anonymous sets allow for two consecutive start element since they
-	 *   are constant, skip them to avoid bogus overlap reports.
+	 *   are constant, but validate that this new start element does not
+	 *   sit in between an existing start and end elements: partial overlap,
+	 *   reported as -ENOTEMPTY.
 	 */
-	if (!nft_set_is_anonymous(set) && rbe_le &&
-	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
-		return -ENOTEMPTY;
+	if (rbe_le &&
+	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new)) {
+		if (!nft_set_is_anonymous(set))
+			return -ENOTEMPTY;
+
+		rbe_prev = nft_rbtree_prev_active(rbe_le);
+		if (rbe_prev && nft_rbtree_interval_end(rbe_prev))
+			return -ENOTEMPTY;
+	}
 
 	/* - new end element with existing closest, less or equal key value
 	 *   being a end element: partial overlap, reported as -ENOTEMPTY.
-- 
2.51.0

