Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF05018B0A;
	Wed, 25 Feb 2026 01:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983277; cv=none; b=NAz/tlhr7EehWVPtZE5ufKgQ5oSmGJpHT+qZNuyrA5GUPbyLkrMEOnMBYhPTHZyH3ipBl2OjgwaqcozRZb5Gw1wXye9oM4mLIXokAQ01X6U1Pn76cOzE3s5tRbhwOG63g9EWEFA8QvuUtA2hclf8ux4Tpndyn6h5LA11dT1WXLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983277; c=relaxed/simple;
	bh=IPIyiV2TMkUB+sTW+eGAy0iYXvaawPyo+8cAedswuAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f60asJpjwbGxdEzhyXSlufYq4xkfAF2O2/7Yi0mpsESV8Ddn7Qcy3/DNLhSSV69fTCDmlACFdc43Gf9me/i055XhQewFSAlN+qcry47wXNcsnWJPDGlAOjXkl/+ed0orJNS6WOOliepSToYzIRFARftylK7W+20vasbxDntzJOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEmg0AXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEmg0AXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE90C116D0;
	Wed, 25 Feb 2026 01:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983276;
	bh=IPIyiV2TMkUB+sTW+eGAy0iYXvaawPyo+8cAedswuAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEmg0AXqK9lb7QuxKevpwDqDm6qZEgUUpPTcERkgXNsAhBXBL2FTBIlaDmcJFYXxa
	 c9EkEm6Ki54/1G/FTqlCBwXzhGevB9QBuRZuRcAqjxIz/WLAnz6aip7I1xI+W/cpML
	 SQVcaDKSM1khu5tJdhWy0CcM59RYW1+g/ELWLDyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 416/781] netfilter: nft_set_rbtree: remove seqcount_rwlock_t
Date: Tue, 24 Feb 2026 17:18:45 -0800
Message-ID: <20260225012409.900434551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



