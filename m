Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B62C372ECD;
	Tue, 21 Jul 2026 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653871; cv=none; b=oNJH6jD7rcAJC3JmG3ErWlt/oUsJLTZFcV/z/KcK7T+SyDOiTnwfFQKp0EtZj0Xeq7TQ3H4gXMwbDpjauaAxCdxhXMXgEffgsrcR8nizJY7ZA4cScWqMT82l80ghrwlx/prMWpKjJATz+tIYGlshmwGfM9RRqtKyFxXLvULo2gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653871; c=relaxed/simple;
	bh=NBPu8YECH5mqwcpZmFdpeiTIhAmYsTw/ZmDvjkyOR0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq0a8oLIpkFsYo0QRX//Xgr7rm2ZDN96+RUe8+fRvw7P/ycxclKVHT1rPJMKI9VNPl64l+M9AgIDmQ84sOLkiKijXwxQIMIUGWFgXOabc5TQdGWG3eU53EoNO+AP1Ns+4vMWxQpHPdWN0cgfckXkI+lVj732r6tLl67sEGvY8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVfZgJkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVfZgJkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236791F000E9;
	Tue, 21 Jul 2026 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653869;
	bh=DGjCvNP6Qd3dSVr8fAwTJ8pT9HAXWiOmF8GImqNEuwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVfZgJktHz55kGlb1TC2lHq7ImkktkHxph+5gukAxtuurEV5HItRkTQdIjFPGOGY/
	 rA2OQ6B3bF6ON1nnC/ssv/afU35Hihe7Yl0o5EhwYMw96SEGHCOC4T+pLsoXqRQd7y
	 lb4X+QTv9UZucoZjCMTtZdOtPgWzu039nBVZLfoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1491/2077] netfilter: nft_lookup: fix catchall element handling with inverted lookups
Date: Tue, 21 Jul 2026 17:19:24 +0200
Message-ID: <20260721152627.962357150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/netfilter/nft_lookup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 9fafe5afc490e0..8e2c3601133f04 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -103,13 +103,13 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	bool found;
 
 	ext = nft_set_do_lookup(net, set, &regs->data[priv->sreg]);
+	if (!ext)
+		ext = nft_set_catchall_lookup(net, set);
+
 	found = !!ext ^ priv->invert;
 	if (!found) {
-		ext = nft_set_catchall_lookup(net, set);
-		if (!ext) {
-			regs->verdict.code = NFT_BREAK;
-			return;
-		}
+		regs->verdict.code = NFT_BREAK;
+		return;
 	}
 
 	if (ext) {
-- 
2.53.0



