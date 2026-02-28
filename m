Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB0838D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302150; cv=none; b=PgXWRe2PfWys23iFF1AjOX4pOCEd6u8ZiChq8hCjEV0n2RJ1WOI4Wwj2whEPX9ov8NDaBEaYqX1+M5Yfgoc+MmKFw+PEp6sOwKWsYAgzAadNzD+vuwMOOHQ4vKySuIHPn3PQHiaZyxDlTHB/OZhug6qxkyjt/brZkIK0FEbTowE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302150; c=relaxed/simple;
	bh=RIT998OD5t0eCUcf2DYqwgiE9075VlXZbLJYpHvtgOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgWGIqFCfAaEqNJ1pirDQaX8peC3ilzNTqa87h8LU1yp7kRzkgamx1J6RPC1p8pgL7rrnkA0yHkD9Q4eEBFoO/bFBpD6TL73AXEewwTb0hs0al3ua5l+GsbfONzsFCT16yGtvr/iDWXqJQSHRNNHGQjyhOt5QYeysWsNDjFt+7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDfyA7vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDfyA7vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F87C19423;
	Sat, 28 Feb 2026 18:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302150;
	bh=RIT998OD5t0eCUcf2DYqwgiE9075VlXZbLJYpHvtgOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDfyA7vm9Dqcz0fiL/Ni8FmDM1LB4VL2Y8e/ArSwFOWbk2Uuv+Fi2RtrE76hMHnsC
	 32n3Iq0GsMWphsYaE/OHT3D2EJx7gglnh4cjGTazIRIfN5fhPCSw5Os+1atrnbRoAq
	 JH5xYGyU0ID5xtejNL9DHcmgIh7bOjmhJ319osgTGE387JGWVQlgpF0vSxavwVOh5a
	 5s1rrvLbiSs0duz6EAgeuOofqYEecWxKCwnCSzz33yM9TK6lH3nd/ZNJUbsP7kFrqB
	 2bM31sIokbm00K23f4XjEEgNJz8ZNtD+QJv3Wl+BU2oAZHAZpV2ChftYpnF7Xg/wfG
	 g66FN4ZSLkTiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/283] netfilter: nft_set_hash: fix get operation on big endian
Date: Sat, 28 Feb 2026 13:04:47 -0500
Message-ID: <20260228180709.1583486-145-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 2f1012bde1f34..5a74ee4b7dfb3 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -525,15 +525,20 @@ bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
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

