Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB1C15198D;
	Wed,  5 Feb 2025 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764157; cv=none; b=XKGte/2LeFRUhSEfBMHf4gmlNUgt1crSRL1WWGPB8+FHVLjDHb96zjEp6drNa7L/c/RJK1YCNCjUChql4CR5ISwtI5aszszf6W8KZTCn757mPNaAzV/3zpEFKLK3SJzywjj6hlg2awUxmPE+CfLhuwmCE2Vmhul1vAx5f56c8Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764157; c=relaxed/simple;
	bh=jfVt4wlRccKJxTHdzHGGKO0Ece6ITtECHGg4gEJWclk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd4uf+oKASzZyjFkATEv22SluOWFiW49KsRZFtXVd8bQlOCA81gEFpV9NvmBqA3ASIT8uYO962VmL+A3Z1VbQ4liWnkjnrPKemOMm79yMgWu2+tMixS4UjwmxnjI2Y5KMcRiPpk83NEbX+cTS/PZYBARReJoZG/kWIKzPsAU8jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbraQCk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbraQCk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DECC4CED6;
	Wed,  5 Feb 2025 14:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764157;
	bh=jfVt4wlRccKJxTHdzHGGKO0Ece6ITtECHGg4gEJWclk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbraQCk9Ezs0F+mVSf93Lto/xqUttISxFq4hw6vK8HOIiZbmRnujOpI4DIU1mxwbH
	 Icc1O4oWM+nL84zqNjCLFSydxF/eqozi/Gt8XMRFUlvrlQ/9vIlZ5/LE3ne4PPO/5N
	 MMzk5kSSwaGhxyXWBmbAkagxrkMpQn0hTx14/PcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/393] netfilter: nf_tables: de-constify set commit ops function argument
Date: Wed,  5 Feb 2025 14:41:04 +0100
Message-ID: <20250205134425.852030946@linuxfoundation.org>
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

[ Upstream commit 256001672153af5786c6ca148114693d7d76d836 ]

The set backend using this already has to work around this via ugly
cast, don't spread this pattern.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 8d738c1869f6 ("netfilter: nf_tables: fix set size with rbtree backend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 2 +-
 net/netfilter/nft_set_pipapo.c    | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8321915dddb28..12a30d8e7efe0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -481,7 +481,7 @@ struct nft_set_ops {
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
-	void				(*commit)(const struct nft_set *set);
+	void				(*commit)(struct nft_set *set);
 	void				(*abort)(const struct nft_set *set);
 	u64				(*privsize)(const struct nlattr * const nla[],
 						    const struct nft_set_desc *desc);
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 334958ef8d66c..5dab9905ebbec 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1574,12 +1574,11 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 
 /**
  * pipapo_gc() - Drop expired entries from set, destroy start and end elements
- * @_set:	nftables API set representation
+ * @set:	nftables API set representation
  * @m:		Matching data
  */
-static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
+static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 {
-	struct nft_set *set = (struct nft_set *) _set;
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
 	int rules_f0, first_rule = 0;
@@ -1693,7 +1692,7 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
  * We also need to create a new working copy for subsequent insertions and
  * deletions.
  */
-static void nft_pipapo_commit(const struct nft_set *set)
+static void nft_pipapo_commit(struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *new_clone, *old;
-- 
2.39.5



