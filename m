Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE783FA5D9;
	Tue, 31 Mar 2026 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975042; cv=none; b=qUAtOt61FWnpIxe11B393hFzhl8btt/rWcJqPFkZAMNYB3nS40qTFKHzsIY5Bc0/RL3l7Q8XBDGteJSAE0GbEhWoxoubtg53G7DSSxCUYxbxpwrSFni5jVT5vVOuK51QPjxoAuHH0h2sbOsmyXq+mpUMbJUDSF3pkoErc54Ma9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975042; c=relaxed/simple;
	bh=8rIz3mVR5Q0iCaWfEPRAGDhW76Xs+ZMAjeL5kmEArvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBEdIr6BBADwDCCYBuW5KNDWAF8pYc8DgQaZqqH/awCwlh8V9GOLlpL6W6pX5AWhQjTLxmsuekPercxB7cl8p/Jqkwu2h71xL3G+DfY9e6cfD4UcbeLxghb8jVPPZoVfkbbZLtZHmBfrreQCciq6OZ/bfRpTdhVO0PWG/9+UWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Uq9yoYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Uq9yoYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6582C19423;
	Tue, 31 Mar 2026 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975042;
	bh=8rIz3mVR5Q0iCaWfEPRAGDhW76Xs+ZMAjeL5kmEArvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Uq9yoYyPYFlDcbp+5Js1OXxrkXz7yzRrhAOeEjf5g7lFGWbpyXw0k24+GQ5t3y6v
	 Cujy0ZYX2eH0EMgzzK5zfykR6PcHSKPTkSDLVymEpMdKKhkpW8moavgfGhuAe9ME4d
	 7W/bYQhZzUeWLzYklvmfHIYVo10LVdGcN3wdmHKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Arges <carges@cloudflare.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 142/342] netfilter: nft_set_rbtree: revisit array resize logic
Date: Tue, 31 Mar 2026 18:19:35 +0200
Message-ID: <20260331161804.233214004@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit fafdd92b9e30fe057740c5bb5cd4f92ecea9bf26 ]

Chris Arges reports high memory consumption with thousands of
containers, this patch revisits the array allocation logic.

For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
Expand it by x2 until threshold of 512 slots is reached, over that
threshold, expand it by x1.5.

For non-anonymous set, start by 1024 slots in the array (which takes 16
Kbytes initially on x86_64). Expand it by x1.5.

Use set->ndeact to subtract deactivated elements when calculating the
number of the slots in the array, otherwise the array size array gets
increased artifically. Add special case shrink logic to deal with flush
set too.

The shrink logic is skipped by anonymous sets.

Use check_add_overflow() to calculate the new array size.

Add a WARN_ON_ONCE check to make sure elements fit into the new array
size.

Reported-by: Chris Arges <carges@cloudflare.com>
Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 92 +++++++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 5d91b7d08d33a..154bf2772e27d 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -572,14 +572,12 @@ static struct nft_array *nft_array_alloc(u32 max_intervals)
 	return array;
 }
 
-#define NFT_ARRAY_EXTRA_SIZE	10240
-
 /* Similar to nft_rbtree_{u,k}size to hide details to userspace, but consider
  * packed representation coming from userspace for anonymous sets too.
  */
 static u32 nft_array_elems(const struct nft_set *set)
 {
-	u32 nelems = atomic_read(&set->nelems);
+	u32 nelems = atomic_read(&set->nelems) - set->ndeact;
 
 	/* Adjacent intervals are represented with a single start element in
 	 * anonymous sets, use the current element counter as is.
@@ -595,27 +593,87 @@ static u32 nft_array_elems(const struct nft_set *set)
 	return (nelems / 2) + 2;
 }
 
-static int nft_array_may_resize(const struct nft_set *set)
+#define NFT_ARRAY_INITIAL_SIZE		1024
+#define NFT_ARRAY_INITIAL_ANON_SIZE	16
+#define NFT_ARRAY_INITIAL_ANON_THRESH	(8192U / sizeof(struct nft_array_interval))
+
+static int nft_array_may_resize(const struct nft_set *set, bool flush)
 {
-	u32 nelems = nft_array_elems(set), new_max_intervals;
+	u32 initial_intervals, max_intervals, new_max_intervals, delta;
+	u32 shrinked_max_intervals, nelems = nft_array_elems(set);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_array *array;
 
-	if (!priv->array_next) {
-		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
-		if (!array)
-			return -ENOMEM;
+	if (nft_set_is_anonymous(set))
+		initial_intervals = NFT_ARRAY_INITIAL_ANON_SIZE;
+	else
+		initial_intervals = NFT_ARRAY_INITIAL_SIZE;
+
+	if (priv->array_next) {
+		max_intervals = priv->array_next->max_intervals;
+		new_max_intervals = priv->array_next->max_intervals;
+	} else {
+		if (priv->array) {
+			max_intervals = priv->array->max_intervals;
+			new_max_intervals = priv->array->max_intervals;
+		} else {
+			max_intervals = 0;
+			new_max_intervals = initial_intervals;
+		}
+	}
 
-		priv->array_next = array;
+	if (nft_set_is_anonymous(set))
+		goto maybe_grow;
+
+	if (flush) {
+		/* Set flush just started, nelems still report elements.*/
+		nelems = 0;
+		new_max_intervals = NFT_ARRAY_INITIAL_SIZE;
+		goto realloc_array;
 	}
 
-	if (nelems < priv->array_next->max_intervals)
-		return 0;
+	if (check_add_overflow(new_max_intervals, new_max_intervals,
+			       &shrinked_max_intervals))
+		return -EOVERFLOW;
+
+	shrinked_max_intervals = DIV_ROUND_UP(shrinked_max_intervals, 3);
 
-	new_max_intervals = priv->array_next->max_intervals + NFT_ARRAY_EXTRA_SIZE;
-	if (nft_array_intervals_alloc(priv->array_next, new_max_intervals) < 0)
+	if (shrinked_max_intervals > NFT_ARRAY_INITIAL_SIZE &&
+	    nelems < shrinked_max_intervals) {
+		new_max_intervals = shrinked_max_intervals;
+		goto realloc_array;
+	}
+maybe_grow:
+	if (nelems > new_max_intervals) {
+		if (nft_set_is_anonymous(set) &&
+		    new_max_intervals < NFT_ARRAY_INITIAL_ANON_THRESH) {
+			new_max_intervals <<= 1;
+		} else {
+			delta = new_max_intervals >> 1;
+			if (check_add_overflow(new_max_intervals, delta,
+					       &new_max_intervals))
+				return -EOVERFLOW;
+		}
+	}
+
+realloc_array:
+	if (WARN_ON_ONCE(nelems > new_max_intervals))
 		return -ENOMEM;
 
+	if (priv->array_next) {
+		if (max_intervals == new_max_intervals)
+			return 0;
+
+		if (nft_array_intervals_alloc(priv->array_next, new_max_intervals) < 0)
+			return -ENOMEM;
+	} else {
+		array = nft_array_alloc(new_max_intervals);
+		if (!array)
+			return -ENOMEM;
+
+		priv->array_next = array;
+	}
+
 	return 0;
 }
 
@@ -630,7 +688,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 	nft_rbtree_maybe_reset_start_cookie(priv, tstamp);
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return -ENOMEM;
 
 	do {
@@ -741,7 +799,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 	    nft_rbtree_interval_null(set, this))
 		priv->start_rbe_cookie = 0;
 
-	if (nft_array_may_resize(set) < 0)
+	if (nft_array_may_resize(set, false) < 0)
 		return NULL;
 
 	while (parent != NULL) {
@@ -811,7 +869,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 	switch (iter->type) {
 	case NFT_ITER_UPDATE_CLONE:
-		if (nft_array_may_resize(set) < 0) {
+		if (nft_array_may_resize(set, true) < 0) {
 			iter->err = -ENOMEM;
 			break;
 		}
-- 
2.51.0



