Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004583B7776;
	Sat, 17 Oct 2026 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259171; cv=none; b=lx0R7YZMNenjonY59v7HewbSeOrVmuBNWrB2qSk5TuF6bczDeX5SRNNEz7nDRnvjRD5fCBMivFEa2XfdcWxQwDltG2EIiLFCqtr4PemS5Boj/3zaA+uoE9/q/sV68UqGYTXH9gziM7Mv10QyoU07GHackp8NNa/4KggrWenbIPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259171; c=relaxed/simple;
	bh=Kv57jhs3mOKKpj5BZHFWtADO2DOAo2Z8vawpmakqteE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqze+0aSpKOZf+ADmj8yBKvS8H0dyOqtgf8u9WZXY2eMlhCBXJhgF7nGd5TcaEIfkFTXPwWsfKIAc1/HGv8wPsR0qM6/pzQ6qHJmftFq29iPDFIDtMvYVA/LJdU6J98SOOca41F3IzThSQU11EeGC6ubWc5WvwlHznrUwi4vZ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXuG/5cP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXuG/5cP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B0A1F000C5;
	Sat, 17 Oct 2026 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259170;
	bh=7Q26StqOcGJg4oFjLxgWttOwsPrVQ/ws1S6NHMW+ImA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXuG/5cPIKgsD3fgGGnpUbVfaNktwxnGyeq2NG76s1onCBnAw7b45aHTcOYrAt1NQ
	 SjhelHEs87RSPFg+JTF+8paGvEpN6LVeSgAcwP2zNx29xbfTqCv3SmtEIVuNEqMKe3
	 TCmFUeY9XPA/e1sBnC6FbRU10kSgLH6REDHexYGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1125/1674] netfilter: nft_lookup: fix catchall element handling with inverted lookups
Date: Sat, 17 Oct 2026 17:56:37 +0200
Message-ID: <20261017160500.037077308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamaki Yanagawa <ty@000ty.net>

[ Upstream commit e6107a4c74b54cb33e3bce162a63048ae5a6b198 ]

nft_lookup_eval() decides whether a lookup matched (`found`) from the
direct set lookup and priv->invert before falling back to the
catchall element used by interval sets (e.g. nft_set_rbtree) for the
open-ended default range. Since `found` is never recomputed after
`ext` is replaced by the catchall lookup, inverted lookups
(NFT_LOOKUP_F_INV, "!= @set") can wrongly match or wrongly skip the
catchall element, producing the wrong verdict. Fold the catchall
lookup into `ext` before computing `found`, matching the order
already used by nft_objref_map_eval().

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_lookup.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index c56cc6f3f8fad..fed08c103ae04 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -65,14 +65,16 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	const struct net *net = nft_net(pkt);
 	bool found;
 
-	found =	nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext) ^
-				  priv->invert;
+	found = nft_set_do_lookup(net, set, &regs->data[priv->sreg], &ext);
 	if (!found) {
 		ext = nft_set_catchall_lookup(net, set);
-		if (!ext) {
-			regs->verdict.code = NFT_BREAK;
-			return;
-		}
+		found = !!ext;
+	}
+
+	found ^= priv->invert;
+	if (!found) {
+		regs->verdict.code = NFT_BREAK;
+		return;
 	}
 
 	if (ext) {
-- 
2.53.0



