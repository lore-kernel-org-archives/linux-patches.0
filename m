Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215477;
	b=Ct52JMek7dJyuD9u8/G6FTPL1rPki8GGUNjmTAaFsKExBZjmKBzbi+q4yxdlgbislrcL
	 7vtQHLtLQHwKqzhtzNwiQB0QATVDeMid0K7P2MqC1+ySMw7Aen9W+YgPKtc2P5xsoCXqj
	 CbXOX36jmIkZ5uV7d08eqQirwyupRLjo1npvV4qECDEanb0MCGvtnv6/JDfVj1FTThZ50
	 8TM0iAZkVJLavWQeh1it8IQaHPBxQwcIVWA5q2Ln70hksFb16ky3kSXy3cjuQKsg1OsFN
	 ezMRlMVzQcC07yr2rHlxWB/xyuh+280IU5XeLeq0bSz/tsCXYWdXjfRcwD9DWd4vpRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i3VX6Y0W4KhrkIkzDs58tWteQGPTi0YQ5v8VpD+XcNo=;
	b=1npqgJVbgC//6aYhcvmC98Bsesy+b8cSD89IpuzVCmZ0e7XzGf1Nf1uDWkpyH3fQ2cRz
	 6ftyTLy12MDT6btdcopN6nVmz6OF5WPVe6I6aUSSZ7lT3x4mlUUaE6KnqTBDTiMbZ5LBQ
	 PlFp2sU5lClyqlfadHU9hS/mPFRWWpKjM8UaJGUtWvsplVSIc2V23phC2ojJd+BKy5Dyy
	 EBTrUq5gbNHxbuTFBWpjGTZLi6TozY9f/mRmqEo90IbRxGX+tQmftfvDk18R64sLHCNRk
	 fFXmZDVzh3fE438zqFpeQlfcLQc4fBz/WhfoZ+r1DsiQyRHltdZXzk79TPLgThuJ64Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AIsWy2U5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41693606A31A;
	Wed, 28 Oct 2026 19:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AIsWy2U5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BE71F01825;
	Wed, 28 Oct 2026 19:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215477;
	bh=i3VX6Y0W4KhrkIkzDs58tWteQGPTi0YQ5v8VpD+XcNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIsWy2U54zk7npIdCOCJ9k5rNdYerEt0TlsIIOod11WrJ49mtUjHZBKKcB9yte8PK
	 w5oSB/B7ICt0em+2QuS4Z8jS9yShBhoWGZxlWpdsxoTJg8U47ddR23SoV7IlwM8iTd
	 6AJuTbXeCVd/J6Qd0Qzo8n2RwazQxoK2oPzt20oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamaki Yanagawa <ty@000ty.net>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1222/1887] netfilter: nft_lookup: fix catchall element handling with inverted lookups
Date: Wed, 28 Oct 2026 17:55:18 +0100
Message-ID: <20261028170527.234421172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b03e6eb2fe69..344d6d110b8d9 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -64,14 +64,16 @@ void nft_lookup_eval(const struct nft_expr *expr,
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



