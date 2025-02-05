Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479DA1519AA;
	Wed,  5 Feb 2025 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764173; cv=none; b=PaBVODdOsDacSo+KTJ7KP35SqAPMlg4nOORRHEZW+QM/s7wYeVIGSmPFCZ5YzN2ul2FKJQZ3O+MCBhJLJHR++3sIfGTe+zFM2ZOL8dw4U2GJ9WwuDvww1yiSFWyugqACLdk0syvfldPsPdlsY2g8/YwU21w6+YbQaYBsJYk4gxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764173; c=relaxed/simple;
	bh=1Pt50D20RzQZJjFdqLETBFAQJ0bDCTx1KYr/fC7NChc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1xa1qVFCPg2qSSVJpZQNanqaVldWxdzROEEcpPOrZX7akIOUZR8QEarquV71Xc73I5kAVPmyGVUM1413pbNXHOq0mlaRLsSWl/W0jY7rmMkL8neY6NMWnkrFF7Un/2aV8kSkHpyyfjExmug3LW7xpg71WDFVLd9lWkds1kH+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjZ0dwlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjZ0dwlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8693C4CED6;
	Wed,  5 Feb 2025 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764173;
	bh=1Pt50D20RzQZJjFdqLETBFAQJ0bDCTx1KYr/fC7NChc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjZ0dwlq1lB7Ur5IRPden3a6yuRwVk8DRVqSjZ0ctyOmBJOK6A2/8Dz95q3RmOYVE
	 VD4m/A2gyVR4w7fPJ2y/8G3ISsGFXYId7gK/SdChVlZcfpRfE30WiQfmjuzaIHh+qX
	 NK6fbBVRbo91ilJUW5XVJKOljVxjh7snvbNdrSLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/393] netfilter: nft_set_rbtree: rename gc deactivate+erase function
Date: Wed,  5 Feb 2025 14:41:05 +0100
Message-ID: <20250205134425.889302195@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8079fc30f79799e59d9602e7e080d434936a482d ]

Next patch adds a cllaer that doesn't hold the priv->write lock and
will need a similar function.

Rename the existing function to make it clear that it can only
be used for opportunistic gc during insertion.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 8d738c1869f6 ("netfilter: nf_tables: fix set size with rbtree backend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index afbda7e3fd048..896a9a7024b04 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -221,14 +221,15 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return rbe;
 }
 
-static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
-				 struct nft_rbtree *priv,
-				 struct nft_rbtree_elem *rbe)
+static void nft_rbtree_gc_elem_remove(struct net *net, struct nft_set *set,
+				      struct nft_rbtree *priv,
+				      struct nft_rbtree_elem *rbe)
 {
 	struct nft_set_elem elem = {
 		.priv	= rbe,
 	};
 
+	lockdep_assert_held_write(&priv->lock);
 	nft_setelem_data_deactivate(net, set, &elem);
 	rb_erase(&rbe->node, &priv->root);
 }
@@ -263,7 +264,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 	rbe_prev = NULL;
 	if (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
-		nft_rbtree_gc_remove(net, set, priv, rbe_prev);
+		nft_rbtree_gc_elem_remove(net, set, priv, rbe_prev);
 
 		/* There is always room in this trans gc for this element,
 		 * memory allocation never actually happens, hence, the warning
@@ -277,7 +278,7 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
 		nft_trans_gc_elem_add(gc, rbe_prev);
 	}
 
-	nft_rbtree_gc_remove(net, set, priv, rbe);
+	nft_rbtree_gc_elem_remove(net, set, priv, rbe);
 	gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
 	if (WARN_ON_ONCE(!gc))
 		return ERR_PTR(-ENOMEM);
-- 
2.39.5



