Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D51238166;
	Mon, 13 Apr 2026 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097839; cv=none; b=hn4sSYb0kZI52UV791mqOE4wGIeP8kXj4c4nIXeOQUxqAjkigb0pEgc37YTFESq8T+iTmWWp1W9AwVpZza0mU4C9eY3I8pAD8O3qActr2+q5VLDsS7KRogxEa2SoOAR7hrEADTUobD3+N4k2dT6nIaZrPqjNaMd/JouD05jMzTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097839; c=relaxed/simple;
	bh=duXzct/KRe9J1YFinvscEzKhR5qO9MwBe181NlehH1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shly8oO5m6rj6pJgaGTsaNuRuQ3h8IV68CWvPIad3bUqb2/Btx1Aq1n4ffwMotwPbSEHl4JlQ5mMj0z90LSt3hGatA0MDxaaOux4vZjB1ncaKvf5KEODMq+EozYxzg73QTDWamT7RiBGP44iz43MnRHjGGSMUjcno44lTjVd3Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb1rUySu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb1rUySu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4CFC2BCAF;
	Mon, 13 Apr 2026 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097839;
	bh=duXzct/KRe9J1YFinvscEzKhR5qO9MwBe181NlehH1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb1rUySukyptCLywf/cy6mcGkeyOq1T5a/KQXFw6sQID4ooqDLmAhhBWslasR58dD
	 JdDUojwcaB5yaENTtW2IvEyCWDUxkuZNgihm14zcCnk7R5+DpUKGrYlF3tzNGpX0qk
	 ippbmf922NB7rmxGlXp6k6k1dUgTZjSnqhe7pagw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 291/570] netfilter: nf_tables: de-constify set commit ops function argument
Date: Mon, 13 Apr 2026 17:57:02 +0200
Message-ID: <20260413155841.402591509@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 256001672153af5786c6ca148114693d7d76d836 upstream.

The set backend using this already has to work around this via ugly
cast, don't spread this pattern.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    2 +-
 net/netfilter/nft_set_pipapo.c    |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -455,7 +455,7 @@ struct nft_set_ops {
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
-	void				(*commit)(const struct nft_set *set);
+	void				(*commit)(struct nft_set *set);
 	void				(*abort)(const struct nft_set *set);
 	u64				(*privsize)(const struct nlattr * const nla[],
 						    const struct nft_set_desc *desc);
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1587,12 +1587,11 @@ static void nft_pipapo_gc_deactivate(str
 
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
 	u64 tstamp = nft_net_tstamp(net);
@@ -1707,7 +1706,7 @@ static void pipapo_reclaim_match(struct
  * We also need to create a new working copy for subsequent insertions and
  * deletions.
  */
-static void nft_pipapo_commit(const struct nft_set *set)
+static void nft_pipapo_commit(struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *new_clone, *old;


