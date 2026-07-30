Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395BB396585;
	Thu, 30 Jul 2026 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428130; cv=none; b=S/Go5e+DS3ySgC8AnrVxht6c8jDrsqbJO/+39Ju/cp0CLDRO0Qm1vYVGQmChyJ9RXHf7iCYDh0JVqckQDO40ny+ivuE73x9cRjx1MjXB4iJpPYI03RS+6hpKZZHvbvNsXIqo9N3TnTlvoBpfk3Cc7HyKBVb6MimdPzNutcNwVI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428130; c=relaxed/simple;
	bh=2VS+puC5EJoqQEKPCGQBJgimOs90G82gyWxAs6LEALk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDwrsCtqR5DQ95ycl/PBAbGacqH+ilGYzmAKYEInpMLYtNtdSDvTL9kmvRVDFpEYBqdposT9VhTAxszDG3s642oRuqEOBBa7H6J13cFH7CGETXVgPpVpJGUhvd2a8Cpbn6cZ7r7jXus5zBJM0lVz9DCS4C02urFgErPbd+/lWmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kG94qWnc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kG94qWnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765471F00A3A;
	Thu, 30 Jul 2026 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428125;
	bh=RPMzXSLd/JI6MGCu86STxAZ+l7nRlr2llDEUmoOHaiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kG94qWncuG56cEPQosM3xR0ZKeS1IJZXwk/KQAOdiAs7NpAdSJxOCVuh9v1+NNbaT
	 LE+/ERn+JtvTsdJkBnHUC3mBe30ljVyNa/C84eLtvTFC/YOa4a18SjXDejHVYjAFge
	 ZdQj/Gq0Vw2dDGdASfSIB3TL8txVpLzjKNLiIQD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 410/484] netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone
Date: Thu, 30 Jul 2026 16:15:07 +0200
Message-ID: <20260730141432.381315896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a238106703ab4ae1090b86eba128815b8626d8f1 ]

The helper uses priv->clone unconditionally which will fail once we do
the clone conditionally on first insert or removal.

'nft get element' from userspace needs to use priv->match since this
runs from rcu read side lock section.

Prepare for this by passing the match backend data as argument.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -502,6 +502,7 @@ out:
  * pipapo_get() - Get matching element reference given key data
  * @net:	Network namespace
  * @set:	nftables API set representation
+ * @m:		storage containing active/existing elements
  * @data:	Key data to be matched against existing elements
  * @genmask:	If set, check that element is active in given genmask
  * @tstamp:	timestamp to check for expired elements
@@ -515,17 +516,15 @@ out:
  */
 static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 					  const struct nft_set *set,
+					  const struct nft_pipapo_match *m,
 					  const u8 *data, u8 genmask,
 					  u64 tstamp, gfp_t gfp)
 {
 	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
-	struct nft_pipapo *priv = nft_set_priv(set);
 	unsigned long *res_map, *fill_map = NULL;
-	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	int i;
 
-	m = priv->clone;
 	if (m->bsize_max == 0)
 		return ret;
 
@@ -609,7 +608,10 @@ out:
 static void *nft_pipapo_get(const struct net *net, const struct nft_set *set,
 			    const struct nft_set_elem *elem, unsigned int flags)
 {
-	return pipapo_get(net, set, (const u8 *)elem->key.val.data,
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_match *m = rcu_dereference(priv->match);
+
+	return pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
 			 nft_genmask_cur(net), get_jiffies_64(), GFP_ATOMIC);
 }
 
@@ -1258,7 +1260,7 @@ static int nft_pipapo_insert(const struc
 	else
 		end = start;
 
-	dup = pipapo_get(net, set, start, genmask, tstamp, GFP_KERNEL);
+	dup = pipapo_get(net, set, m, start, genmask, tstamp, GFP_KERNEL);
 	if (!IS_ERR(dup)) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
@@ -1280,7 +1282,7 @@ static int nft_pipapo_insert(const struc
 
 	if (PTR_ERR(dup) == -ENOENT) {
 		/* Look for partially overlapping entries */
-		dup = pipapo_get(net, set, end, nft_genmask_next(net), tstamp,
+		dup = pipapo_get(net, set, m, end, nft_genmask_next(net), tstamp,
 				 GFP_KERNEL);
 	}
 
@@ -1865,16 +1867,18 @@ static void *nft_pipapo_deactivate(const
 				   const struct nft_set *set,
 				   const struct nft_set_elem *elem)
 {
+	const struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_match *m = priv->clone;
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
 		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
 
 	nft_set_elem_change_active(net, set, &e->ext);
 
-	return &e->priv;
+	return e;
 }
 
 /**
@@ -1900,8 +1904,9 @@ static bool nft_pipapo_flush(const struc
 {
 	struct nft_pipapo_elem *e = elem;
 
-	return pipapo_deactivate(net, set, (const u8 *)nft_set_ext_key(&e->ext),
-				 &e->ext);
+	nft_set_elem_change_active(net, set, &e->ext);
+
+	return true;
 }
 
 /**


