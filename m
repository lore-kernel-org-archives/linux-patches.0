Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6102C3252;
	Wed, 25 Feb 2026 06:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002578; cv=none; b=tGMNvM52evPH00vVf6ImX9L9Yyldhn0cJqGaobg7tVP/7Wp4tqMiMg6MDafOqSoXH/Olo6tEzUTpScL5SZ57ReIsqtlrzMtOUMNqN5H+g6srAyNwoBqKKB4MifkC9GwIPTyAqarxBkJAAe5zYgAmsMCMrEG6puefiBIhC83IIg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002578; c=relaxed/simple;
	bh=zg+Zkv7bH0/uNJIJT9+mlDCTqLg+86dB186Tiu1Vdbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZD1xmFoCIrAHwK7th6J0XORtpp5fqtVStXaqOuz/U3P0bwp0IqfVKzEEeADOE4lqv+dZIiqdLpiGcKItp8ekokX1SA/XWVQ5mre4kprsjjuLAfhIczPwA1uGB+JXlUCEyuKfx0orPtXQNgNnq5ltM9N/KsjLMptWDC21UDilBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+BogKTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+BogKTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62840C116D0;
	Wed, 25 Feb 2026 06:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002578;
	bh=zg+Zkv7bH0/uNJIJT9+mlDCTqLg+86dB186Tiu1Vdbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+BogKTjN8LhUwCoGbnwkcDDHh3MrXneuJcOAJTju0bKbtyaizbVerGP7oLGCYmrU
	 MpwmOv1ejSktF3xE9kpezB8hIJykjBSpzQuhXxLLkWwHG5s8BZYRm4DHMXHu7RpQ4E
	 zXROcwZi9EE5Ogb5VMKCBtMoSekagqZEel+ufLgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 312/641] netfilter: nft_set_rbtree: remove seqcount_rwlock_t
Date: Tue, 24 Feb 2026 17:20:38 -0800
Message-ID: <20260225012356.287048293@linuxfoundation.org>
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

[ Upstream commit 5599fa810b503eafc2bd8cd15bd45f35fc8ff6b9 ]

After the conversion to binary search array, this is not required anymore.
Remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 782f2688128e ("netfilter: nft_set_rbtree: validate element belonging to interval")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 1b0502cc87301..6470bc5d38749 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -33,7 +33,6 @@ struct nft_rbtree {
 	rwlock_t		lock;
 	struct nft_array __rcu	*array;
 	struct nft_array	*array_next;
-	seqcount_rwlock_t	count;
 	unsigned long		last_gc;
 };
 
@@ -572,9 +571,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		write_seqcount_begin(&priv->count);
 		err = __nft_rbtree_insert(net, set, rbe, elem_priv);
-		write_seqcount_end(&priv->count);
 		write_unlock_bh(&priv->lock);
 	} while (err == -EAGAIN);
 
@@ -584,9 +581,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 static void nft_rbtree_erase(struct nft_rbtree *priv, struct nft_rbtree_elem *rbe)
 {
 	write_lock_bh(&priv->lock);
-	write_seqcount_begin(&priv->count);
 	rb_erase(&rbe->node, &priv->root);
-	write_seqcount_end(&priv->count);
 	write_unlock_bh(&priv->lock);
 }
 
@@ -798,7 +793,6 @@ static int nft_rbtree_init(const struct nft_set *set,
 	BUILD_BUG_ON(offsetof(struct nft_rbtree_elem, priv) != 0);
 
 	rwlock_init(&priv->lock);
-	seqcount_rwlock_init(&priv->count, &priv->lock);
 	priv->root = RB_ROOT;
 
 	priv->array = NULL;
-- 
2.51.0



