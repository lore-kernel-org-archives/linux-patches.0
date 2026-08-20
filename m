Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19FC484258;
	Thu, 20 Aug 2026 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248076; cv=none; b=hiIIpqY5ryVVYTRW5WJi3yF94ZUuGXSUr4EnEnuyaAcTeVH4eQOYHdNPUlXqItKgw1bKba/LKspeY5RdolC4oaf7c9VvKQuyLsUOkIBwqF4ybQ1N1CRnGwqdr2ecuiguHPOvJ+3leChmqdAQOt/2MMWk2U89pj+BpNdiouJSBcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248076; c=relaxed/simple;
	bh=Zk85l7UWCkLl5+CE1karUVO0VfOU6gnrndXlJjot8nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRiyrD+AL07DLKrIxO9N4IUmqRBsWBQ4pb8p+KiGxNwgsgiGH+HhJlexNTny9k/xqqwaxKT2qBrIV78wXyJSgDYz8frJKC7fvxqcDas9ORoLaVYbFX9BknUdgWSLNFEiHOmxyXjTxOjNTcRQy2g/GGIV7Z1TIsoTcDvh6q/M13E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQQwKjUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQQwKjUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2691F000E9;
	Thu, 20 Aug 2026 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248075;
	bh=pSwU0uGODuX86Sv7GUq8+5RoZCRSmjGp7TC5m5eqQzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQQwKjUu1CZhbUvM0x/RA5+R0bBVmklGQ52ecAsjt9KiYcCigoLmkQ7ZAmm2/TEQ/
	 CTbZq4kksUX6r2W3wN/FtwulVCTu063rFEiTSFRF/g2e7PfHOCbofTy3j6jsn35zv8
	 X7CH49Gqh+FbP5V3ka/0FIakqSjrCb4YmsxWRJjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/303] netfilter: nft_set_pipapo: move prove_locking helper around
Date: Thu, 20 Aug 2026 16:53:56 +0200
Message-ID: <20260820145256.294271309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

[ Upstream commit a590f4760922acaa2d2b55a88004a38eecdd6412 ]

Preparation patch, the helper will soon get called from insert
function too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1217,6 +1217,17 @@ static int pipapo_realloc_scratch(struct
 	return 0;
 }
 
+static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	const struct net *net = read_pnet(&set->net);
+
+	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
+#else
+	return true;
+#endif
+}
+
 /**
  * nft_pipapo_insert() - Validate and insert ranged elements
  * @net:	Network namespace
@@ -1803,17 +1814,6 @@ static void nft_pipapo_commit(struct nft
 	pipapo_gc_queue(set);
 }
 
-static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
-{
-#ifdef CONFIG_PROVE_LOCKING
-	const struct net *net = read_pnet(&set->net);
-
-	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
-#else
-	return true;
-#endif
-}
-
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);


