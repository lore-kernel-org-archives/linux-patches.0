Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4060947ACC6;
	Thu, 20 Aug 2026 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244186; cv=none; b=TsJ/X0wxAMUhcapUo0ogZbfostKB2gTKi/xyDFdDzrquwtFvUvMea08wPpXGZV0FJDTiUdOD46GXqTxj6Axc5/hzGhVSRnjBXDm7N2PD5Yr0OkCYe5odwpBPSpsnUVvIx6kgx0U9MI7VvIOPM+b/HQU+rQi9WzZ8v+BlcUDq8sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244186; c=relaxed/simple;
	bh=ZptAN/0KgpyRw/ou+jl3tmw/XX+uAOK6SGHfVlH94JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRfVhRDdud/samQAfkZRFjEGIolykZZMz09jgL+kbqQC6AYFPYfJzgQug7jLnvzCUNeOrHsuSkftej/OKbMJUBm5UQIOeqATUXeYrLB/8d6mPu/U3ZKab1rONQpYRd+yvA84/WcazQxVFYZJzd2ATuJ0T8CYk+mmNVcv5TNLaCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dhQUR7T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dhQUR7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C2D1F000E9;
	Thu, 20 Aug 2026 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244185;
	bh=xfTPZyZoTcm3PCzg55WSru7U1gDlMDV5qN4ETAWmAJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dhQUR7TBJy0F0y3dOyimylDdplw813SxtyzjV4iz7+9mnWaCI/jFeHxv3bf6VawF
	 UHLrcO0n1xEFsiSogpPM1AG2m7YQKZ1akQ9Ro7SPlVfzyqJduQmW0UrlvGmUhIrG+X
	 So+3m6/aEfe3OY/HeTx+H3iMK7oQtarq1Es0nVJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	Seesee <cjc000013@gmail.com>
Subject: [PATCH 5.10 081/235] netfilter: nft_set_pipapo: dont leak bad clone into future transaction
Date: Thu, 20 Aug 2026 16:55:17 +0200
Message-ID: <20260820145218.906845277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 47e65eff50691f0a5b79d325e28d83ec1da43bcf ]

On memory allocation failure the cloned nft_pipapo_match can enter a bad
state:
 - some fields can have their lookup tables resized while others did
   not
 - bits might have been toggled
 - scratch map can be undersized which also means m->bsize_max can be
   lower than what is required

This means that the next insertion in the same batch can trigger
out-of-bounds writes.

Furthermore, a failure in the first can result in the bad clone to
leak into the next transaction because the abort callback is never
executed in this case (the upper layer saw an error and no attempt to
allocate a transactional request was made).

Record a state for the nft_pipapo_match structure:
- NEW (pristine clone)
- MOD (modified clone with good state)
- ERR (potentially bogus content)

Then make it so that deletes and insertions fail when the clone
entered ERR state.

In case the very first insert attempt results in an error, free the
clone right away.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Seesee <cjc000013@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   34 +++++++++++++++++++++++++++++-----
 net/netfilter/nft_set_pipapo.h |    8 ++++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -342,6 +342,8 @@
 #include "nft_set_pipapo_avx2.h"
 #include "nft_set_pipapo.h"
 
+static void nft_pipapo_abort(const struct nft_set *set);
+
 /**
  * pipapo_refill() - For each set bit, set bits from selected mapping table item
  * @map:	Bitmap to be scanned for set bits
@@ -1251,7 +1253,7 @@ static int nft_pipapo_insert(const struc
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
-	if (!m)
+	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
 		return -ENOMEM;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
@@ -1324,8 +1326,10 @@ static int nft_pipapo_insert(const struc
 		else
 			ret = pipapo_expand(f, start, end, f->groups * f->bb);
 
-		if (ret < 0)
-			return ret;
+		if (ret < 0) {
+			err = ret;
+			goto abort;
+		}
 
 		if (f->bsize > bsize_max)
 			bsize_max = f->bsize;
@@ -1341,7 +1345,7 @@ static int nft_pipapo_insert(const struc
 
 		err = pipapo_realloc_scratch(m, bsize_max);
 		if (err)
-			return err;
+			goto abort;
 
 		m->bsize_max = bsize_max;
 	} else {
@@ -1352,7 +1356,26 @@ static int nft_pipapo_insert(const struc
 
 	pipapo_map(m, rulemap, e);
 
+	m->state = NFT_PIPAPO_CLONE_MOD;
 	return 0;
+abort:
+	WARN_ON_ONCE(m->state == NFT_PIPAPO_CLONE_ERR);
+
+	/* Two rollback cases:
+	 * 1) no previous changes.  nft_pipapo_abort is not
+	 * guaranteed to be invoked (there might be no further
+	 * add/delete requests coming after this).
+	 *
+	 * 2) we had previous changes: there are transaction
+	 * records pointing to this set.  Leave the rollback to
+	 * the transaction handling.
+	 */
+	if (m->state == NFT_PIPAPO_CLONE_NEW)
+		nft_pipapo_abort(set); /* releases m */
+	else
+		m->state = NFT_PIPAPO_CLONE_ERR;
+
+	return err;
 }
 
 /**
@@ -1427,6 +1450,7 @@ static struct nft_pipapo_match *pipapo_c
 		dst++;
 	}
 
+	new->state = NFT_PIPAPO_CLONE_NEW;
 	return new;
 
 out_mt:
@@ -1849,7 +1873,7 @@ static void *nft_pipapo_deactivate(const
 	/* removal must occur on priv->clone, if we are low on memory
 	 * we have no choice and must fail the removal request.
 	 */
-	if (!m)
+	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
 		return NULL;
 
 	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -142,9 +142,16 @@ struct nft_pipapo_scratch {
 	unsigned long map[];
 };
 
+enum nft_pipapo_clone_state {
+	NFT_PIPAPO_CLONE_NEW,
+	NFT_PIPAPO_CLONE_MOD,
+	NFT_PIPAPO_CLONE_ERR,
+};
+
 /**
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count		Amount of fields in set
+ * @state:		add/delete state; used from control plane
  * @scratch:		Preallocated per-CPU maps for partial matching results
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
  * @rcu			Matching data is swapped on commits
@@ -152,6 +159,7 @@ struct nft_pipapo_scratch {
  */
 struct nft_pipapo_match {
 	int field_count;
+	enum nft_pipapo_clone_state state:8;
 	struct nft_pipapo_scratch * __percpu *scratch;
 	size_t bsize_max;
 	struct rcu_head rcu;


