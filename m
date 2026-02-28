Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97587342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301812; cv=none; b=G0ORiOT0iVoPTPIR/TrYcg8s7xwcArW3Wkq3yjA6F+IaJ5eh6TWoO7btqXOxnNEYZ/YelymtY5lD1+xtrgaWW+FR5H2Y+CA08oeglBELiEsxji+qbxP4IxrVlVG1sdVdp9Go209ObbJsHoMx+btdTgSyAnGJ6Ovco3B271TDpEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301812; c=relaxed/simple;
	bh=2QFLGyzx5TJQ999hIC55PBCE8FwfB/SRFrxQwGJ/oMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFQwFdQHSE0JH29eEAzEKggRINWTKnkrIHlBKha7ftgDRI1jgvplk0M06dN6niiSxOi8N3mdl9CGcuM9QTeE1x+XDzAeNwT5YG2lkkhRcVm8PaRYwTr9yblc3Co1CAYYmMdsgX5Ghy3K1+IuFJgjvBlISrrzCMtQegzy0mKx/O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VymnDEyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VymnDEyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE6CC116D0;
	Sat, 28 Feb 2026 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301812;
	bh=2QFLGyzx5TJQ999hIC55PBCE8FwfB/SRFrxQwGJ/oMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VymnDEyTXtD+cOT2bLzOZzNEOdYW4ulepunVsW1DAuhDVb6pRN2uAwaRSbIBiygDR
	 ptAyqo5L1cim7EQ0xxLMclbeZDb8DcyFTieXB+jzemtbupBIub6SNsCSlvQUIh2Clt
	 wHuoEwsJ/CwiH8eE1nYYRX5Lzr7oUKJE5eVzgjOvalb8VB9vJa8zWQbsfM/qf97i+6
	 a+QvVck9yhVc4wxzlK4wZErZwjVOnu/BlqGkaZdghjAIRnv6r/W+aniN/ohAN0HOKL
	 7RvlcwxCCLjZK3CnbbKiYd0UtVYzsVq88KutJK1blsmyCBg2mcQodUwulF2In10w/s
	 064PaYk5Q85mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/385] netfilter: nft_set_hash: fix get operation on big endian
Date: Sat, 28 Feb 2026 12:57:28 -0500
Message-ID: <20260228180011.1568201-226-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2f635adbe2642d398a0be3ab245accd2987be0c3 ]

tests/shell/testcases/packetpath/set_match_nomatch_hash_fast
fails on big endian with:

Error: Could not process rule: No such file or directory
reset element ip test s { 244.147.90.126 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Fatal: Cannot fetch element "244.147.90.126"

... because the wrong bucket is searched, jhash() and jhash1_word are
not interchangeable on big endian.

Fixes: 3b02b0adc242 ("netfilter: nft_set_hash: fix lookups with fixed size hash on big endian")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 900eddb93dcc8..e87398cefef00 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -527,15 +527,20 @@ static struct nft_elem_priv *
 nft_hash_get(const struct net *net, const struct nft_set *set,
 	     const struct nft_set_elem *elem, unsigned int flags)
 {
+	const u32 *key = (const u32 *)&elem->key.val;
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
 	struct nft_hash_elem *he;
 	u32 hash;
 
-	hash = jhash(elem->key.val.data, set->klen, priv->seed);
+	if (set->klen == 4)
+		hash = jhash_1word(*key, priv->seed);
+	else
+		hash = jhash(key, set->klen, priv->seed);
+
 	hash = reciprocal_scale(hash, priv->buckets);
 	hlist_for_each_entry_rcu(he, &priv->table[hash], node) {
-		if (!memcmp(nft_set_ext_key(&he->ext), elem->key.val.data, set->klen) &&
+		if (!memcmp(nft_set_ext_key(&he->ext), key, set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask))
 			return &he->priv;
 	}
-- 
2.51.0

