Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF1F359A71
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302387; cv=none; b=YSJUM7+yX1zrF0PWtiXwLlI19JOszFBI0+vkuGlsJYUEqEKYLFc930gyoRxdtZ29SH/PkDUfGMZbdpSmCtszkp79NHeXlT0ODDMpbTRD00FyMpB4V6OBIy8M3K3rVdJNHYnWb55o05PGo3kM+S73BlesErbg/vVSLztBBNDxjwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302387; c=relaxed/simple;
	bh=hV38o68gWMb+1D8YAfotRuzxukbc1ibVAcAhIYlgHaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5pamBjFkEWgKkOxdHOlq9rkN66Bp85q60dfm2bcz0tFBjUI6ccPiLqjsz75GiT4ILqHC/OYG6L5or+yc1qSzBB/c7qCR9zgp5XA7PrPTvjQerycaIFlnCc6PB81Mb17aRn7vIYFS4v9PwELR7c9vYE/4CG22hmMmjvVSGAt+xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZpEY5U5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZpEY5U5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D868BC19424;
	Sat, 28 Feb 2026 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302387;
	bh=hV38o68gWMb+1D8YAfotRuzxukbc1ibVAcAhIYlgHaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpEY5U5i2z2C/qXIWMufPYpya1tbrcc/rOaV5SAZv704tv5/Eaa6BtsYbLli4yuMt
	 F4Eyt8ZTmzmIns8FJz/2+eHXQbI6nJqh9QYemip4NYFhb6jDS/wN/i0/OFA9S13TPw
	 y1soy62xqicVNywq1rEyj7YSejCXFKlOvXOkPc+TnUflGe6OvrWPlBBwgScXjumfCS
	 KihnaA+OIO6DzQl/FVIluEqmEtWpXf3J2SSZPfGNEtXV7GLAVv62yDC/Z/U/dfVSe4
	 ncFSl18qyNIb8E6aL4H43tX4OTovoYj1VwAkW0Lp5sVplFaJJI3VNSwA3QmYF1rpXd
	 frJMeWDRjcZSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/232] netfilter: nft_set_hash: fix get operation on big endian
Date: Sat, 28 Feb 2026 13:09:29 -0500
Message-ID: <20260228181127.1592657-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

