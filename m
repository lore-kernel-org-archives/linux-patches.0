Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B1B47D474;
	Thu, 20 Aug 2026 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244172; cv=none; b=UkAyWI8tJO7Gmd1ZOhrNlRBpuiidR7AVEtzHtZr0MYXf0O5LZ8bQ6v/paLR1hlqqLtdIQSYLDaeMEBLsqWFNOrHxQNvEwidtoGIPdhozpFnSheeWhdfNPfSjPcfpoIYwul572mQZirW1PHkDHCItWXJqOwpOz2Qxt2nTPdVIZdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244172; c=relaxed/simple;
	bh=eQ557E7QL6GrFG9ooNe+BVyaIjzicxdKfaTzUQa65vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qac04OvGUon+mIcSZcsPozqVZ4ERIkxNFL1umKmdn4ac0TQuTgQPcocOxxgQS/ZxrMGmQbxteGNR0j5ciQchWh/Tp9qiRf42Uh49FaDbCShQyuNIOdKzxhWPv6fgvME1meLqS3LHmM2sB8CzKgnleu/1qOQqT7WmXnERyBnygZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g834ZzMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g834ZzMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACDB1F000E9;
	Thu, 20 Aug 2026 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244170;
	bh=8ZX8hn+iQr4F2Ja1/4MJ/cp5GCCjlXR4AEdBs9o4PeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g834ZzMIT7PCb/NUC4S3rsjglMLfkWZmfXeQUwHdOyGBZZ7LJ27h6bM2hrfLKAvlM
	 iQrsVKIB+Ga42we4eXxAU1FfVY269+1ByA8n7kgLVYkW1UPXUYcFQkq3nsFKGAPiVE
	 nwIkQrmpwN/4VA7euDewy6sZ8oPcjG/8tSOXdkOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/235] netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
Date: Thu, 20 Aug 2026 16:55:12 +0200
Message-ID: <20260820145218.753016901@linuxfoundation.org>
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
@@ -1318,7 +1318,7 @@ static int nft_pipapo_insert(const struc
  * pipapo_clone() - Clone matching data to create new working copy
  * @old:	Existing matching data
  *
- * Return: copy of matching data passed as 'old', error pointer on failure
+ * Return: copy of matching data passed as 'old' or NULL.
  */
 static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 {
@@ -1329,7 +1329,7 @@ static struct nft_pipapo_match *pipapo_c
 	new = kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
 		      GFP_KERNEL);
 	if (!new)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	new->field_count = old->field_count;
 	new->bsize_max = old->bsize_max;
@@ -1403,7 +1403,7 @@ out_scratch:
 	free_percpu(new->scratch);
 	kfree(new);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 /**
@@ -1743,7 +1743,7 @@ static void nft_pipapo_commit(const stru
 		goto out;
 
 	new_clone = pipapo_clone(priv->clone);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		goto out;
 
 	priv->dirty = false;
@@ -1769,7 +1769,7 @@ static void nft_pipapo_abort(const struc
 	m = rcu_dereference(priv->match);
 
 	new_clone = pipapo_clone(m);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -2214,8 +2214,8 @@ static int nft_pipapo_init(const struct
 
 	/* Create an initial clone of matching data for next insertion */
 	priv->clone = pipapo_clone(m);
-	if (IS_ERR(priv->clone)) {
-		err = PTR_ERR(priv->clone);
+	if (!priv->clone) {
+		err = -ENOMEM;
 		goto out_free;
 	}
 


