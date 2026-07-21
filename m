Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651D8227BB5;
	Tue, 21 Jul 2026 18:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658265; cv=none; b=i4POnkKpamXhjIMPVpMvS6fKT756o9q5TZsw2ChpvQbt2z5+u19MwXKPBMAGIe5of2eCjkStrW9ic2i0k79NuyXmvz7Xq9Vs//glb8ey9cGg6kWDyM685Vs4Z15AfwH0ZU82AZH+l7LdiDbUCt+UsupbTOQ9STWsgK/Odin6Zuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658265; c=relaxed/simple;
	bh=0wY8IFKfHDolt6ZuxUsbNUNtFajkPQRGo58LXKaBVjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LD9ItnCOG2zr0xs2ytI+x8jr9Mzbv2KNTIJLP9kbXjctK0WcRaUmeZRt6tOs4N8VEGGapWk19AA2OMqQb7czoHbpy2fJmOz8Mvx4SJwbL3FLga5B60QDHJaxXy4CVRqSrpJy77kY33gSM3IZ0kls4IjK5ipw/2DQMu5PG9Y/hbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSGZRxo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSGZRxo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB071F00A3D;
	Tue, 21 Jul 2026 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658264;
	bh=Dzt8WAwoNSUFeqj6F+nhwGJnRcDYodwo9wFxBakVmoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSGZRxo0yn/WpOtzSyOx0ICt9QaT4ehcxq73DNK6U8Xma+2WDvVec1cj4Zda8MDrl
	 Xy6AO9kuMH9ku2YhI1OX6RFajIX4XaJlAFbgcnhuBkDSgRcudcU+5GoBySlD9RmYyo
	 jMJA4AzbdQz/TnAGxE13CeLsADKEhONiIOeHLZ7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1079/1611] netfilter: nft_lookup: fix catchall element handling with inverted lookups
Date: Tue, 21 Jul 2026 17:19:55 +0200
Message-ID: <20260721152539.680090192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 58c5b14889c474..beca9c7705e016 100644
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



