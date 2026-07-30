Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B1635E950;
	Thu, 30 Jul 2026 16:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428123; cv=none; b=V5OdILBDlyGVEczo44w0gZLe/n2yy/cnOZcKQWcdSe9h0Sc0fHOOTTHG45ysWjraOQ4mOE/7FTj5CuuKBpdi0piRCaR0uPXOIUZa/LrPZMMSdoRJfxpR8vnvmq0Xzvpy/i0GwhFeWoj9D5pHlzIXuBuO9vOCU6qPJC6cNTQ2rks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428123; c=relaxed/simple;
	bh=SMzfYl3bw5XaKfv4K3utIomK49syNWVy6JP8KoeD+C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tt+9mT87VikdyVoBbEw4RnobMv0ppEa9lXVJUcOCaB95QQcc1BwePgjuIGBINRyCXagMCaT7F6EZeejXiHKa4eJZ2ayJ+ICSsm4J7Z71yQqRowGSDQG9vjVcnyfVIh4t0J1y0s1L9W+poyxjiscAwc66b5H4+J9K2nTfehqECNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWdZfNMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWdZfNMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09D01F00A3D;
	Thu, 30 Jul 2026 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428119;
	bh=7Iy7ZXh+wCXqVvKBsGSPNJWc2VPHttwmWU3b7tPfhvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWdZfNMchqgklyuF+XK0U/j+jIg46hT9r2p0/K4iSZqwCza7xAXOInsEMcG3sQYKp
	 a0uIQ+UNz1s3rH/TNcYRBvZ4zXdYtuBnu0kPkO8M2LJBBN1+JvWz4mpM9IaLbR7f5V
	 fDeG6jVldwrue4aTH2dc76tlxXP9o7PL2DSVObXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 408/484] netfilter: nft_set_pipapo: prepare walk function for on-demand clone
Date: Thu, 30 Jul 2026 16:15:05 +0200
Message-ID: <20260730141432.339020744@linuxfoundation.org>
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

[ Upstream commit 6c108d9bee448a850b03e682836bfe91fca645cb ]

The existing code uses iter->type to figure out what data is needed, the
live copy (READ) or clone (UPDATE).

Without pending updates, priv->clone and priv->match will point to
different memory locations, but they have identical content.

Future patch will make priv->clone == NULL if there are no pending changes,
in this case we must copy the live data for the UPDATE case.

Currently this would require GFP_ATOMIC allocation.  Split the walk
function in two parts: one that does the walk and one that decides which
data is needed.

In the UPDATE case, callers hold the transaction mutex so we do not need
the rcu read lock.  This allows to use GFP_KERNEL allocation while
cloning.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   60 ++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 21 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2109,35 +2109,23 @@ static void nft_pipapo_remove(const stru
 }
 
 /**
- * nft_pipapo_walk() - Walk over elements
+ * nft_pipapo_do_walk() - Walk over elements in m
  * @ctx:	nftables API context
  * @set:	nftables API set representation
+ * @m:		matching data pointing to key mapping array
  * @iter:	Iterator
  *
  * As elements are referenced in the mapping array for the last field, directly
  * scan that array: there's no need to follow rule mappings from the first
- * field.
+ * field. @m is protected either by RCU read lock or by transaction mutex.
  */
-static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_set_iter *iter)
+static void nft_pipapo_do_walk(const struct nft_ctx *ctx, struct nft_set *set,
+			       const struct nft_pipapo_match *m,
+			       struct nft_set_iter *iter)
 {
-	struct nft_pipapo *priv = nft_set_priv(set);
-	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	int i, r;
 
-	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
-		     iter->type != NFT_ITER_UPDATE);
-
-	rcu_read_lock();
-	if (iter->type == NFT_ITER_READ)
-		m = rcu_dereference(priv->match);
-	else
-		m = priv->clone;
-
-	if (unlikely(!m))
-		goto out;
-
 	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
 		;
 
@@ -2157,14 +2145,44 @@ static void nft_pipapo_walk(const struct
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
 		if (iter->err < 0)
-			goto out;
+			return;
 
 cont:
 		iter->count++;
 	}
+}
 
-out:
-	rcu_read_unlock();
+/**
+ * nft_pipapo_walk() - Walk over elements
+ * @ctx:	nftables API context
+ * @set:	nftables API set representation
+ * @iter:	Iterator
+ *
+ * Test if destructive action is needed or not, clone active backend if needed
+ * and call the real function to work on the data.
+ */
+static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_set_iter *iter)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	const struct nft_pipapo_match *m;
+
+	switch (iter->type) {
+	case NFT_ITER_UPDATE:
+		m = priv->clone;
+		nft_pipapo_do_walk(ctx, set, m, iter);
+		break;
+	case NFT_ITER_READ:
+		rcu_read_lock();
+		m = rcu_dereference(priv->match);
+		nft_pipapo_do_walk(ctx, set, m, iter);
+		rcu_read_unlock();
+		break;
+	default:
+		iter->err = -EINVAL;
+		WARN_ON_ONCE(1);
+		break;
+	}
 }
 
 /**


