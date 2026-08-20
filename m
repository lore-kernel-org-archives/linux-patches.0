Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77DE44C51B;
	Thu, 20 Aug 2026 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248165; cv=none; b=cidl+7qIPHvupxe8pm33ih4wfEoNavAmqD+hTXO9z2I9tBLPqTKmjugJN3/yKb2JmKIwegm8qjFt1dcUrrTXeiXPo26P8MdPB7OM03IPr0M/Lfzm7+6AVUb2gOy8p00tZce6WT5xi8SxEqAK8ybBd8jayhzS2OMIgJhNp+YD1rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248165; c=relaxed/simple;
	bh=KV4Z6IU7LlTdhyS9Xza0KxNSFnPxRxseq5aKoOObcxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nweTDE4d0O1tBODE9vRMS9QibMlz3aNf7g5pHTVCPecMHP8rcKHotF7DxZZ+5+EwSKTTcDRsvFye51D8sTHYeADGJC/mgx4lmkCaHv5Mj36qdX4j4TXD4ByBT5pBbNgPdWBsUCyKO0RYo6BiCzteFBG1xx/bFwnhYbW2etC85DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nB8NWAdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nB8NWAdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7821F000E9;
	Thu, 20 Aug 2026 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248163;
	bh=SAQcvsKXrGswcnDgw4dTUhphTz9uvCC+XToOWF7SmFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nB8NWAdx4Zi+8tRvEHk78bbPBC+57po/O1aSH6R7CSZkQC9xeOZ3l0qB5F4aDyodP
	 YRz+Qv2zyEmcOK9WWLaZgixkbQ9XAOCvGbRDC4vFx5nT7+ejZaZUVW2gMURYaasHTG
	 EQk+9P72SctdWJJQkGUnMQVgPgAsSQileQ+S/x2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/303] netfilter: nft_set_pipapo: move cloning of match info to insert/removal path
Date: Thu, 20 Aug 2026 16:54:01 +0200
Message-ID: <20260820145256.441188962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3f1d886cc7c3525d4dbeee24bfa9bb3fe0d48ddc ]

This set type keeps two copies of the sets' content,
   priv->match (live version, used to match from packet path)
   priv->clone (work-in-progress version of the 'future' priv->match).

All additions and removals are done on priv->clone.  When transaction
completes, priv->clone becomes priv->match and a new clone is allocated
for use by next transaction.

Problem is that the cloning requires GFP_KERNEL allocations but we
cannot fail at either commit or abort time.

This patch defers the clone until we get an insertion or removal
request.  This allows us to handle OOM situations correctly.

This also allows to remove ->dirty in a followup change:

If ->clone exists, ->dirty is always true
If ->clone is NULL, ->dirty is always false, no elements were added
or removed (except catchall elements which are external to the specific
set backend).

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   70 ++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 21 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1230,6 +1230,29 @@ static bool nft_pipapo_transaction_mutex
 #endif
 }
 
+static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old);
+
+/**
+ * pipapo_maybe_clone() - Build clone for pending data changes, if not existing
+ * @set:	nftables API set representation
+ *
+ * Return: newly created or existing clone, if any. NULL on allocation failure
+ */
+static struct nft_pipapo_match *pipapo_maybe_clone(const struct nft_set *set)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_match *m;
+
+	if (priv->clone)
+		return priv->clone;
+
+	m = rcu_dereference_protected(priv->match,
+				      nft_pipapo_transaction_mutex_held(set));
+	priv->clone = pipapo_clone(m);
+
+	return priv->clone;
+}
+
 /**
  * nft_pipapo_insert() - Validate and insert ranged elements
  * @net:	Network namespace
@@ -1247,14 +1270,17 @@ static int nft_pipapo_insert(const struc
 	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 	const u8 *start = (const u8 *)elem->key.val.data, *end;
 	struct nft_pipapo_elem *e = elem->priv, *dup;
+	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	u64 tstamp = nft_net_tstamp(net);
 	struct nft_pipapo_field *f;
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
+	if (!m)
+		return -ENOMEM;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
 		end = (const u8 *)nft_set_ext_key_end(ext)->data;
 	else
@@ -1792,7 +1818,10 @@ static void pipapo_reclaim_match(struct
 static void nft_pipapo_commit(struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *new_clone, *old;
+	struct nft_pipapo_match *old;
+
+	if (!priv->clone)
+		return;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
 		pipapo_gc_scan(set, priv->clone);
@@ -1800,40 +1829,29 @@ static void nft_pipapo_commit(struct nft
 	if (!priv->dirty)
 		return;
 
-	new_clone = pipapo_clone(priv->clone);
-	if (!new_clone)
-		return;
-
+	old = rcu_replace_pointer(priv->match, priv->clone,
+				  nft_pipapo_transaction_mutex_held(set));
+	priv->clone = NULL;
 	priv->dirty = false;
 
-	old = rcu_access_pointer(priv->match);
-	rcu_assign_pointer(priv->match, priv->clone);
 	if (old)
 		call_rcu(&old->rcu, pipapo_reclaim_match);
 
-	priv->clone = new_clone;
-
 	pipapo_gc_queue(set);
 }
 
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *new_clone, *m;
 
 	if (!priv->dirty)
 		return;
 
-	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
-
-	new_clone = pipapo_clone(m);
-	if (!new_clone)
+	if (!priv->clone)
 		return;
-
 	priv->dirty = false;
-
 	pipapo_free_match(priv->clone);
-	priv->clone = new_clone;
+	priv->clone = NULL;
 }
 
 /**
@@ -1868,10 +1886,15 @@ static void *nft_pipapo_deactivate(const
 				   const struct nft_set *set,
 				   const struct nft_set_elem *elem)
 {
-	const struct nft_pipapo *priv = nft_set_priv(set);
-	struct nft_pipapo_match *m = priv->clone;
+	struct nft_pipapo_match *m = pipapo_maybe_clone(set);
 	struct nft_pipapo_elem *e;
 
+	/* removal must occur on priv->clone, if we are low on memory
+	 * we have no choice and must fail the removal request.
+	 */
+	if (!m)
+		return NULL;
+
 	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
 		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
@@ -2154,7 +2177,12 @@ static void nft_pipapo_walk(const struct
 
 	switch (iter->type) {
 	case NFT_ITER_UPDATE:
-		m = priv->clone;
+		m = pipapo_maybe_clone(set);
+		if (!m) {
+			iter->err = -ENOMEM;
+			return;
+		}
+
 		nft_pipapo_do_walk(ctx, set, m, iter);
 		break;
 	case NFT_ITER_READ:


