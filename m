Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58B7377A89;
	Thu, 20 Aug 2026 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243423; cv=none; b=CDRU0uO7i7bmf/Kdo8Jywv3cbQo6qHAKjAyueLAIymX9U+e8tqpv6rB8G4CPrW9qERZmJzOfmKCANBwDV5wlR2ZNrwiQKGxH28FXYfbohMzOngULSTes9gFdF+t9Wix/OQdxbI3exC/83m950QrQCdhc/QVlNGRSViPk0QRMwa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243423; c=relaxed/simple;
	bh=CVKNRlBwQGsV3xd4rfjrsYSzHAlUFiNhnd9WSs+2jDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWmU5f1laLm/nocCAg+diK6K54l1pBGoIXfQK6u8RAItcALNPWXNBmJT58sE8QqV9ALU7osSwpLk91REridIrdzgKI3rMYMff7O6vZxtYi7FSuBhjcX9E4mltMHbDD9zgCx34/i5KVw57MHGbLDkIyLVGqwhfJM5EmEKscCqH+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdVez+7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdVez+7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD8A1F000E9;
	Thu, 20 Aug 2026 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243421;
	bh=m7EB6LWKVmNUyTL1yAhGDWAYywTvGp0OUMR3AsZzI4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdVez+7GG7DCdqc+3OukihTBCvSRHlcNfRYv6TL/gWc2J2cSAQKFQnreGggjSvEIN
	 4/z6qEouPrJxP4dfX6eIb76nJh/jo7yzRFfCRQyE9+IlgT6f0z7upxq405weWnLO8/
	 U1WQXXUS0Ek3qwqidHK648VYKDhS/I5kdkHOthMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/272] netfilter: nft_set_pipapo: use GFP_KERNEL for insertions
Date: Thu, 20 Aug 2026 16:54:34 +0200
Message-ID: <20260820145233.972488019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 5b651783d80b97167ecd27dc6a4408c694873902 ]

An earlier attempt changed this to GFP_KERNEL, but the get helper is
also called for get requests from userspace, which uses rcu.

Let the caller pass in the kmalloc flags to allow insertions
to schedule if needed.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -505,6 +505,7 @@ out:
  * @data:	Key data to be matched against existing elements
  * @genmask:	If set, check that element is active in given genmask
  * @tstamp:	timestamp to check for expired elements
+ * @gfp:	the type of memory to allocate (see kmalloc).
  *
  * This is essentially the same as the lookup function, except that it matches
  * key data against the uncommitted copy and doesn't use preallocated maps for
@@ -515,7 +516,7 @@ out:
 static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 					  const struct nft_set *set,
 					  const u8 *data, u8 genmask,
-					  u64 tstamp)
+					  u64 tstamp, gfp_t gfp)
 {
 	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
 	struct nft_pipapo *priv = nft_set_priv(set);
@@ -528,13 +529,13 @@ static struct nft_pipapo_elem *pipapo_ge
 	if (m->bsize_max == 0)
 		return ret;
 
-	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
+	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), gfp);
 	if (!res_map) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
-	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
+	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), gfp);
 	if (!fill_map) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out;
@@ -609,7 +610,8 @@ static void *nft_pipapo_get(const struct
 			    const struct nft_set_elem *elem, unsigned int flags)
 {
 	return pipapo_get(net, set, (const u8 *)elem->key.val.data,
-			 nft_genmask_cur(net), get_jiffies_64());
+			 nft_genmask_cur(net), get_jiffies_64(),
+			 GFP_ATOMIC);
 }
 
 /**
@@ -1218,7 +1220,7 @@ static int nft_pipapo_insert(const struc
 	else
 		end = start;
 
-	dup = pipapo_get(net, set, start, genmask, tstamp);
+	dup = pipapo_get(net, set, start, genmask, tstamp, GFP_KERNEL);
 	if (!IS_ERR(dup)) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
@@ -1240,7 +1242,8 @@ static int nft_pipapo_insert(const struc
 
 	if (PTR_ERR(dup) == -ENOENT) {
 		/* Look for partially overlapping entries */
-		dup = pipapo_get(net, set, end, nft_genmask_next(net), tstamp);
+		dup = pipapo_get(net, set, end, nft_genmask_next(net), tstamp,
+				 GFP_KERNEL);
 	}
 
 	if (PTR_ERR(dup) != -ENOENT) {
@@ -1840,7 +1843,8 @@ static void *pipapo_deactivate(const str
 {
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, data, nft_genmask_next(net), nft_net_tstamp(net));
+	e = pipapo_get(net, set, data, nft_genmask_next(net),
+		       nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
 


