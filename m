Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0F938F627
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302152; cv=none; b=t/9VRs9UDZrfUZv2d/0++tOl4DRaI3vsURTALcRATyC9rlNp6iOUZWJFFlWLo9qgMIJL/CwY30utmQ21ckXOErvatOMBc9CogWWa6dxlFDpd6jHHeSa/rpDJWOBFVyOMH2YKfPq07r4+XEi71z0HjE+byZmgdrOKS3+RehSZPQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302152; c=relaxed/simple;
	bh=b1MKOf6zqmOh9Wsq4xezOPsawU8ICZUqfmVjwbX0NpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXgGeSoSRJipNC4bBH6JUBnuQW46TqwqRrTD8oqr9i+hRxBbDSrtfDPh8VPJFth7VqFI+FsSwO2qQMBoPJ22k/kf72YMKe5MoQKBwZaVlvPSxryLz7CMIeC13SM7LrCu0Gzi1Yo6O6gPIeOZKI04qqXHUs3SePZ9du/2n2vJ3vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZBE1RNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZBE1RNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB87FC19423;
	Sat, 28 Feb 2026 18:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302152;
	bh=b1MKOf6zqmOh9Wsq4xezOPsawU8ICZUqfmVjwbX0NpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZBE1RNPEWC7CTx6laCwdwkIVFHcJk7PDp/4DnDfxJyxjeGLnh0KkZ6N6Vb5zXgpT
	 6v+8y8acbOKFnURy53HpjUTgejFBYilOk1AxXs4gZKffxIh4zm7buzzZ6lcayAJ2m6
	 QSAw/vNkVjx/U8C10X7xYB6m2cnniZWCxte24JubLlHjDh6iHW2sJNyJNnSuFTLFCD
	 unjbRtpq/olTfdtYTLXNjDT3wzuiS299ZqsWC5bLVdoGMv5oVCwh4dPVF5flMYrNk8
	 4Ox26ilG+5rA6QZTGH9mcmkyKqNDT1gn1PMPzfLjIeMiUKdtPYAaFAdNr0LIqB1Dvi
	 7tE9By7mLLsZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/283] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
Date: Sat, 28 Feb 2026 13:04:49 -0500
Message-ID: <20260228180709.1583486-147-sashal@kernel.org>
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
index 04672238e17dc..9c9b07f2def1b 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -305,11 +305,23 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
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
@@ -441,11 +453,19 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
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

