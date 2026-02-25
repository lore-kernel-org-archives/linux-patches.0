Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789642C11CD;
	Wed, 25 Feb 2026 06:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002575; cv=none; b=CekkRNj4iYgoHuKcQMTlQAXqKVsvnt9DjE+EVia1uqDgMkJnoXc0L4WTOBsfzVApJP2GiRa5h5eU8USm+pt7D6dvm3xr+uAuoP6h00meGlgeGeJM77mM/dZPACTN3Guqijg1SkFajsEeTrkgLaArq/HS6hQb1HR26r3ACBtw+b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002575; c=relaxed/simple;
	bh=tW0Z4/Lp6GFLNOj++1I0XhjIKBeffNypBKQAGowHrK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJpnUaAJg0dnLtYLAxWeLzo1Ltk5KYGX4hIHKmoL4zd0o0g9nLHx0Pt8Ge2UvluRa+wc6oCuLKnkLv383RO9B9k8SwAg3dcPYxQX3pxsWJm4/raAqLfhZjUaFBTjPW3MdXDu0Vlrp0peV4ZZNHbZnv9GutYsYF5zJhLJIjgr4hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs1s8pEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs1s8pEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A218C116D0;
	Wed, 25 Feb 2026 06:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002575;
	bh=tW0Z4/Lp6GFLNOj++1I0XhjIKBeffNypBKQAGowHrK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs1s8pEvENT8Mk/ZFOOyYMEqfhBFvJxSvRf1V4dwp7tFUBmlRz59b6UYApBFQAi40
	 FvGUy6nHH2GmPh0+lK/Hbc1d9KtP1zWAJZvXw7KLcFNp9RaKkTsKKFLBsKKsW2K1U1
	 cQc8HDPQG4zH00jLsPCds/IUSgHA7YpZLCU6uxyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/641] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Tue, 24 Feb 2026 17:20:35 -0800
Message-ID: <20260225012356.217493731@linuxfoundation.org>
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
index eacb3acc2b957..f2a1aa8860184 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -309,11 +309,23 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
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
 			       struct nft_elem_priv **elem_priv)
 {
-	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
+	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
@@ -451,11 +463,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
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



