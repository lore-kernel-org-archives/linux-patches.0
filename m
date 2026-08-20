Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E591F47F774;
	Thu, 20 Aug 2026 17:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248080; cv=none; b=WdFKcsRZGndgOLAfEP1b9M2hxX02J6JBYsYxci/9RIqzA9Nkr5AdLJrmKMoAIs643Ua0odMMdVaDyEdgXkQPE+0/OeleDXIfdKPtWE1CrTj/2GiT/QkRiwgiCfZfZQcr5F6J4eapl7B2+TY81O/BpBRTfZSEf6dRMvsNi1QLpJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248080; c=relaxed/simple;
	bh=cOnDBd/RUlgVJfXY/BUQXa0tgDJmpNwiGF/RTD0942M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXPLIu1iSESMZ5DLuXAz/XydpaJ/sYF2HEMVuyfA1czYoin51UU1ed7mxB7+GXm8XDwwKsD75tOjGwbIfsWCjdkrRJDz3V9R9l3oBTD9F3El/8rSXQsNkbslgmEF7Xb18acvz6T1pFRWyMUr4YSqGACrlDP9bByjPpzqE2Zhn94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7ek5G8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7ek5G8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096F11F000E9;
	Thu, 20 Aug 2026 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248078;
	bh=/APahUOTcLImbQTaVrNCzdevfdZYjhkRZe5icC7dykY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7ek5G8VK7eEWZfB+P5tofw/nNBlDl442XY43kpk2q6Twgzb8DsaIUAlmGgqCtHtH
	 C2BFDwPj/OT4ND1OYWvRRN5yypdoIqoM+hBFQzWyvANDnCZ6dkQu1lf1+Jzglv/6DG
	 +ZCFLdocCbR5kOaAxWxtHi++0sleztnbb7iQYUr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/303] netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
Date: Thu, 20 Aug 2026 16:53:57 +0200
Message-ID: <20260820145256.323222437@linuxfoundation.org>
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

[ Upstream commit 80efd2997fb9343a0283cf3cac5524a4595c8ff4 ]

Currently it returns an error pointer, but the only possible failure
is ENOMEM.

After a followup patch, we'd need to discard the errno code, i.e.

x = pipapo_clone()
if (IS_ERR(x))
	return NULL

or make more changes to fix up callers to expect IS_ERR() code
from set->ops->deactivate().

So simplify this and make it return ptr-or-null.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1358,7 +1358,7 @@ static int nft_pipapo_insert(const struc
  * pipapo_clone() - Clone matching data to create new working copy
  * @old:	Existing matching data
  *
- * Return: copy of matching data passed as 'old', error pointer on failure
+ * Return: copy of matching data passed as 'old' or NULL.
  */
 static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 {
@@ -1369,7 +1369,7 @@ static struct nft_pipapo_match *pipapo_c
 	new = kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
 		      GFP_KERNEL_ACCOUNT);
 	if (!new)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	new->field_count = old->field_count;
 	new->bsize_max = old->bsize_max;
@@ -1445,7 +1445,7 @@ out_scratch:
 	free_percpu(new->scratch);
 	kfree(new);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 /**
@@ -1799,7 +1799,7 @@ static void nft_pipapo_commit(struct nft
 		return;
 
 	new_clone = pipapo_clone(priv->clone);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -1825,7 +1825,7 @@ static void nft_pipapo_abort(const struc
 	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
 
 	new_clone = pipapo_clone(m);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -2267,8 +2267,8 @@ static int nft_pipapo_init(const struct
 
 	/* Create an initial clone of matching data for next insertion */
 	priv->clone = pipapo_clone(m);
-	if (IS_ERR(priv->clone)) {
-		err = PTR_ERR(priv->clone);
+	if (!priv->clone) {
+		err = -ENOMEM;
 		goto out_free;
 	}
 


