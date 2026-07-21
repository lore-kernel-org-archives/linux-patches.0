Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E9B415F3C;
	Tue, 21 Jul 2026 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658504; cv=none; b=UK7kx0RoCTTRPIAH1Ggq1HY4QpJWMqUMHPZ2vf67OQgyxdeeGqBoq1XDB5F/uRUfKaW6s8ktiinAuKn8bsMEVuQL4nCujCKNsRKK17FncRc6Z3zZ2X1rPMb3IzGKyyvJMemAyNeHJdyZ1aYDgqROn5Q8By+hnASF19fzKISpJPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658504; c=relaxed/simple;
	bh=yXINkl1TQGZvgDR0CGxr4lSz03dTeKyJ57q/MI9IF1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PB/ZlJd1KK+DP1MUaV9FxNol2usiu5JuATU4eTY8blXBfUHvFlfEAcdTwptuVua2fqC8I3Tj/CkxZKNgNb/7GVCVLso3qfzd+XAFiczEqVQ27xxY4JANgiU9t1MzYoTr4nwSH6l8ai6x4zezKS5CplsDxqdthVGEf1LuAgJIL7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfNFHALL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfNFHALL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E43D1F00A3A;
	Tue, 21 Jul 2026 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658502;
	bh=RdWU8d+B+Wt5v2GZjuzI8bSZP5PgIYkhwAp976xz1ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfNFHALLGJDsP9f2ehICeb8UAExlnx9rOJ0PFwkYDDXcxkO2hbkPZ1jenX27sOwgK
	 QMSTnVEJ1kIxr6td2ko68d9Hr4m2zSi++2uEPuEtB8GNFAxrVZJLPWI3EDZe2hQJr0
	 bKc6CCiYnpbcpI7zFRymmy7VrkXMEBpztrwoZ1mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Seesee <cjc000013@gmail.com>
Subject: [PATCH 6.18 1169/1611] netfilter: nft_set_pipapo: dont leak bad clone into future transaction
Date: Tue, 21 Jul 2026 17:21:25 +0200
Message-ID: <20260721152541.720938272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 47e65eff50691f0a5b79d325e28d83ec1da43bcf upstream.

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
@@ -1298,7 +1300,7 @@ static int nft_pipapo_insert(const struc
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
-	if (!m)
+	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
 		return -ENOMEM;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
@@ -1369,8 +1371,10 @@ static int nft_pipapo_insert(const struc
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
@@ -1386,7 +1390,7 @@ static int nft_pipapo_insert(const struc
 
 		err = pipapo_realloc_scratch(m, bsize_max);
 		if (err)
-			return err;
+			goto abort;
 
 		m->bsize_max = bsize_max;
 	} else {
@@ -1398,7 +1402,26 @@ static int nft_pipapo_insert(const struc
 
 	pipapo_map(m, rulemap, e);
 
+	m->state = NFT_PIPAPO_CLONE_MOD;
 	return 0;
+abort:
+	DEBUG_NET_WARN_ON_ONCE(m->state == NFT_PIPAPO_CLONE_ERR);
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
@@ -1476,6 +1499,7 @@ static struct nft_pipapo_match *pipapo_c
 		dst++;
 	}
 
+	new->state = NFT_PIPAPO_CLONE_NEW;
 	return new;
 
 out_mt:
@@ -1899,7 +1923,7 @@ nft_pipapo_deactivate(const struct net *
 	/* removal must occur on priv->clone, if we are low on memory
 	 * we have no choice and must fail the removal request.
 	 */
-	if (!m)
+	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
 		return NULL;
 
 	e = pipapo_get(m, (const u8 *)elem->key.val.data,
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -134,9 +134,16 @@ struct nft_pipapo_scratch {
 	unsigned long __map[];
 };
 
+enum nft_pipapo_clone_state {
+	NFT_PIPAPO_CLONE_NEW,
+	NFT_PIPAPO_CLONE_MOD,
+	NFT_PIPAPO_CLONE_ERR,
+};
+
 /**
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count:	Amount of fields in set
+ * @state:		add/delete state; used from control plane
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
  * @scratch:		Preallocated per-CPU maps for partial matching results
  * @rcu:		Matching data is swapped on commits
@@ -144,6 +151,7 @@ struct nft_pipapo_scratch {
  */
 struct nft_pipapo_match {
 	u8 field_count;
+	enum nft_pipapo_clone_state state:8;
 	unsigned int bsize_max;
 	struct nft_pipapo_scratch * __percpu *scratch;
 	struct rcu_head rcu;


