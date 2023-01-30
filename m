Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBD3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6B8C433D2;
	Mon, 30 Jan 2023 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088380;
	bh=xYmaA+wONafaHmY7s1tEfwKwVF4wo4/dWHD+JYFlK3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlNvVFhZi3cXm2c0NpFW7eXuSkpsC4FiJQ61tGf+U3YSCSq82HUog79UWHFPZ2AWl
	 b7aCPeCp2N3u1bVvM+D8wKP2eYK/q8bxZtO3dyJmN0E/3es9RRIUPkmOnkmhqBNnzq
	 BZeUgQpvzAxgDquK65sfWXo8+o6egJJrrkwhe+hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/204] netfilter: nft_set_rbtree: skip elements in transaction from garbage collection
Date: Mon, 30 Jan 2023 14:52:19 +0100
Message-Id: <20230130134324.210714874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 5d235d6ce75c12a7fdee375eb211e4116f7ab01b ]

Skip interference with an ongoing transaction, do not perform garbage
collection on inactive elements. Reset annotated previous end interval
if the expired element is marked as busy (control plane removed the
element right before expiration).

Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 217225e13faf..19ea4d3c3553 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -563,23 +563,37 @@ static void nft_rbtree_gc(struct work_struct *work)
 	struct nft_rbtree *priv;
 	struct rb_node *node;
 	struct nft_set *set;
+	struct net *net;
+	u8 genmask;
 
 	priv = container_of(work, struct nft_rbtree, gc_work.work);
 	set  = nft_set_container_of(priv);
+	net  = read_pnet(&set->net);
+	genmask = nft_genmask_cur(net);
 
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
+		if (!nft_set_elem_active(&rbe->ext, genmask))
+			continue;
+
+		/* elements are reversed in the rbtree for historical reasons,
+		 * from highest to lowest value, that is why end element is
+		 * always visited before the start element.
+		 */
 		if (nft_rbtree_interval_end(rbe)) {
 			rbe_end = rbe;
 			continue;
 		}
 		if (!nft_set_elem_expired(&rbe->ext))
 			continue;
-		if (nft_set_elem_mark_busy(&rbe->ext))
+
+		if (nft_set_elem_mark_busy(&rbe->ext)) {
+			rbe_end = NULL;
 			continue;
+		}
 
 		if (rbe_prev) {
 			rb_erase(&rbe_prev->node, &priv->root);
-- 
2.39.0



