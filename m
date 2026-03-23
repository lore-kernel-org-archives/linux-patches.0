Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303032550D5;
	Mon, 23 Mar 2026 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283244; cv=none; b=XS/7jpeDE+PHLLOBJdBbncKWGbHSaafGBHMe7D7H/tlQG6j/TxetSN9hzkcPowtAa9eocosr+F2O3APGELwYCEgdfYcFptQPlN4ejlAJB8jFumqA5G0/J16FhvtJJy4vnvB12M/QynMkjxoUAN6YikAspMU/e96W7E0Frwy5tXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283244; c=relaxed/simple;
	bh=YvDbJvSLHxdnlF6Bkli3DJtOFhqFDZjVuxz3kVx0Q5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcad9atPWN7H21/qeia/PfXotuOt26KlQz5mdcgRxeFAn0jTw9BmMFEthboicEKnTahEgX/0VEbRsCUEqVg3x+YUfBh/t9GsGvlX760hh5I8pWuWvCsUlV6wCUWFCuax5w3Bsbxd4EvdbCLyzV6BgwlwaY5Jd+6WWHxh9PpMfSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zr5s+wCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zr5s+wCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B303EC4CEF7;
	Mon, 23 Mar 2026 16:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283244;
	bh=YvDbJvSLHxdnlF6Bkli3DJtOFhqFDZjVuxz3kVx0Q5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zr5s+wCYUin8bgQrWZ1PQfGiRuY9gd7KZ+zrjR5+8dbVZhOVUXPEafnWFjEsWNcda
	 guj18+r6NcgbnQ3IfeWkZoEChaGpA2k2TVScLh03pk59YACRd8VIDYyRn8ReZuKurV
	 oe9GJ/e1MjmtT/mgUOyBpMy+3b00XVCP78aOypSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 454/481] netfilter: nf_tables: de-constify set commit ops function argument
Date: Mon, 23 Mar 2026 14:47:16 +0100
Message-ID: <20260323134536.274851010@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -470,7 +470,7 @@ struct nft_set_ops {
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


