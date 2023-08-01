Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9651F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2858C433C7;
	Tue,  1 Aug 2023 09:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883027;
	bh=SCnDX6zxS/BovP1ObVCNx8DgiNnWQyFjmD7rbAi92K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mj588TOb7aXXn33b+wJ6vI4G9F+ppXTlI28LDWbnTGPa7d9F7Zra1e6zWsus+WmzL
	 kqYU4Fs+D/VvZlzdWBhr2t4uSJ1t8NSDkLTisPG3uDMJTt/56n58esuO592eZNKB1R
	 RkhO33c82zHVVOxHJ7jLJZc66a9oAmsbUc4IYYvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 088/239] netfilter: nft_set_rbtree: fix overlap expiration walk
Date: Tue,  1 Aug 2023 11:19:12 +0200
Message-ID: <20230801091928.909524361@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f718863aca469a109895cb855e6b81fff4827d71 ]

The lazy gc on insert that should remove timed-out entries fails to release
the other half of the interval, if any.

Can be reproduced with tests/shell/testcases/sets/0044interval_overlap_0
in nftables.git and kmemleak enabled kernel.

Second bug is the use of rbe_prev vs. prev pointer.
If rbe_prev() returns NULL after at least one iteration, rbe_prev points
to element that is not an end interval, hence it should not be removed.

Lastly, check the genmask of the end interval if this is active in the
current generation.

Fixes: c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 5c05c9b990fba..8d73fffd2d09d 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -217,29 +217,37 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 
 static int nft_rbtree_gc_elem(const struct nft_set *__set,
 			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe)
+			      struct nft_rbtree_elem *rbe,
+			      u8 genmask)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
-	struct nft_rbtree_elem *rbe_prev = NULL;
+	struct nft_rbtree_elem *rbe_prev;
 	struct nft_set_gc_batch *gcb;
 
 	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
 	if (!gcb)
 		return -ENOMEM;
 
-	/* search for expired end interval coming before this element. */
+	/* search for end interval coming before this element.
+	 * end intervals don't carry a timeout extension, they
+	 * are coupled with the interval start element.
+	 */
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		if (nft_rbtree_interval_end(rbe_prev))
+		if (nft_rbtree_interval_end(rbe_prev) &&
+		    nft_set_elem_active(&rbe_prev->ext, genmask))
 			break;
 
 		prev = rb_prev(prev);
 	}
 
-	if (rbe_prev) {
+	if (prev) {
+		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
+
 		rb_erase(&rbe_prev->node, &priv->root);
 		atomic_dec(&set->nelems);
+		nft_set_gc_batch_add(gcb, rbe_prev);
 	}
 
 	rb_erase(&rbe->node, &priv->root);
@@ -321,7 +329,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 		/* perform garbage collection to avoid bogus overlap reports. */
 		if (nft_set_elem_expired(&rbe->ext)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe);
+			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
 			if (err < 0)
 				return err;
 
-- 
2.39.2



