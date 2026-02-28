Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C1639B94B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302571; cv=none; b=f4CozqGz3dA2BoY8R+P3RY92i66yi2a1eTcletGl8yw91CwF7Qin5pV1daPa5rPooNGjj2dkavHhUf6BMLwehyJaLEM7WpzCeZ8j8FnkYfgnh2BNH60+3kPydIQJipsIwb6IvXNf8AkwNa5utYsgTNtHz9eC7XpFgvRK/l6gZbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302571; c=relaxed/simple;
	bh=hV38o68gWMb+1D8YAfotRuzxukbc1ibVAcAhIYlgHaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgqzwJti6lLxQepi9eHtuC+LSW+HijiGl4l3m0xoQCEHWv99ZQ71/4aDoz4/IL58IpRO33NnEbad7O1ZMk0fPUUbeQHm323CASonuyprARM4ZuLTlAL1Ra5bH9R4139+58kg9Yn2E+Wpx0DJIQFW6cp/zMNhE2H4ooqR/9LvLh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2O6l6P9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2O6l6P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB83DC19423;
	Sat, 28 Feb 2026 18:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302571;
	bh=hV38o68gWMb+1D8YAfotRuzxukbc1ibVAcAhIYlgHaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2O6l6P94TksDwy9u8/hfMuUkffiIAL4+ciOfwMQFBnOlilqH0vlaJS4xrejNK4Tl
	 ywTu7vVnnwM5XGxEGPzEdACPaF21ka9kkt/FknoOntbrXB+taUxitdtgvNyBpobtmS
	 cikPgNwqWKNIZ5h4pYfESiaVUvduKU6q8MuGd5K+q86t00sglWXnZUJyK9gYHjCXS9
	 l3FNu9Jzu0dxMy6h4qrGAndZzpg2OKwPONX2uS6acyvkIDCIgjjG/lLPk0QsnPY132
	 DuQ0jfi5zPhDBYhuW0Z7zNosCUr7mt3SdzT0C3aHyQ4QES7YMmeNsv+EJ6mNC+BdMD
	 95ZHpSlj1MnYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/164] netfilter: nft_set_hash: fix get operation on big endian
Date: Sat, 28 Feb 2026 13:13:37 -0500
Message-ID: <20260228181505.1600663-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index a592cca7a61f9..9ea4a09903186 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -527,15 +527,20 @@ bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
 static void *nft_hash_get(const struct net *net, const struct nft_set *set,
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
 			return he;
 	}
-- 
2.51.0

