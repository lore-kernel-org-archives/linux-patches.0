Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468C81171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE74C433C8;
	Mon, 21 Aug 2023 20:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648469;
	bh=1Y3djnkq4GcPRyptUoXXY6BGPdqFi+uZWkc2soq5ePw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JtlyDyjKLnMqp7+yp5wqp2Iz9hu4jJz+ilDs5zYQhvm5VLqX/HI/zLrC2SOTF+XV
	 6rLm+vVVayyD7sh4s3R++PWH49RL8/a79VsVVX5QsqHtMKpN2Dbd1V8giTFOgEBm5v
	 azOAXw2Jko1cGUBaWhXebDpRDeOLITovzWcmKqqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 159/234] netfilter: nf_tables: dont fail inserts if duplicate has expired
Date: Mon, 21 Aug 2023 21:42:02 +0200
Message-ID: <20230821194135.843121383@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7845914f45f066497ac75b30c50dbc735e84e884 ]

nftables selftests fail:
run-tests.sh testcases/sets/0044interval_overlap_0
Expected: 0-2 . 0-3, got:
W: [FAILED]     ./testcases/sets/0044interval_overlap_0: got 1

Insertion must ignore duplicate but expired entries.

Moreover, there is a strange asymmetry in nft_pipapo_activate:

It refetches the current element, whereas the other ->activate callbacks
(bitmap, hash, rhash, rbtree) use elem->priv.
Same for .remove: other set implementations take elem->priv,
nft_pipapo_remove fetches elem->priv, then does a relookup,
remove this.

I suspect this was the reason for the change that prompted the
removal of the expired check in pipapo_get() in the first place,
but skipping exired elements there makes no sense to me, this helper
is used for normal get requests, insertions (duplicate check)
and deactivate callback.

In first two cases expired elements must be skipped.

For ->deactivate(), this gets called for DELSETELEM, so it
seems to me that expired elements should be skipped as well, i.e.
delete request should fail with -ENOENT error.

Fixes: 24138933b97b ("netfilter: nf_tables: don't skip expired elements during walk")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 3b5c3919fff9c..352180b123fc7 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -566,6 +566,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 			goto out;
 
 		if (last) {
+			if (nft_set_elem_expired(&f->mt[b].e->ext))
+				goto next_match;
 			if ((genmask &&
 			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
 				goto next_match;
@@ -600,17 +602,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 static void *nft_pipapo_get(const struct net *net, const struct nft_set *set,
 			    const struct nft_set_elem *elem, unsigned int flags)
 {
-	struct nft_pipapo_elem *ret;
-
-	ret = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+	return pipapo_get(net, set, (const u8 *)elem->key.val.data,
 			 nft_genmask_cur(net));
-	if (IS_ERR(ret))
-		return ret;
-
-	if (nft_set_elem_expired(&ret->ext))
-		return ERR_PTR(-ENOENT);
-
-	return ret;
 }
 
 /**
@@ -1744,11 +1737,7 @@ static void nft_pipapo_activate(const struct net *net,
 				const struct nft_set *set,
 				const struct nft_set_elem *elem)
 {
-	struct nft_pipapo_elem *e;
-
-	e = pipapo_get(net, set, (const u8 *)elem->key.val.data, 0);
-	if (IS_ERR(e))
-		return;
+	struct nft_pipapo_elem *e = elem->priv;
 
 	nft_set_elem_change_active(net, set, &e->ext);
 }
@@ -1962,10 +1951,6 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 
 	data = (const u8 *)nft_set_ext_key(&e->ext);
 
-	e = pipapo_get(net, set, data, 0);
-	if (IS_ERR(e))
-		return;
-
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		const u8 *match_start, *match_end;
-- 
2.40.1



