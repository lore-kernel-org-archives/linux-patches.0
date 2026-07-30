Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAEB442139;
	Thu, 30 Jul 2026 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428117; cv=none; b=j/CNeDXTw/fF2Bys+jkxeu7Bt2yP2OfA1FMDKCSqOYAE9XvgUE8Gr6SZYi0ZymT7hvlnRO4e9p33cYPvVXNwoq4hK2LDgfpAxwFUfV4BJQMem18LpgyJTbYMxXyEme5ARtuBu9Rb9IjUbZXAXnMJa6T0VRWWne6gP1yfvAZmjHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428117; c=relaxed/simple;
	bh=cRsoHhyzZ1eepq9EZ2UteVtlw6UVQM7JamSnGGx4SDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Irdo2KizyQfOd8vADkNeUY6TGF33hH5FvuTWfuAl0SRmWHrnIlmhoJKc094F0UxDVIEj99g4b5Rcx8WEG0edkWq7+9PjHY/UJ5oF5bJ3LGh+/hRo9Hqdr6MTILbMESuMRREwREkZerAD1NkBRTG7j1Ya++JBqfg8BdRiw7ym89s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtCTqlyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtCTqlyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325B01F000E9;
	Thu, 30 Jul 2026 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428113;
	bh=wxgUP+xYUqB+/n5Uhpm/8jDN+kvOhFvSePkXXg54ACQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtCTqlybIoICv4SYAe3ejXQvAVMyg+KwLUzMr8fgMgQp6f8VxBCNcWAOrXISayOLS
	 295yxuI3MyQOAZEO0EdPwLV/5M5NdTIS5idS3Pd0wSGuI20LkS6M7t0Ufg7eB8pK5w
	 SYA7feJnS8cAViBFu+0iKIZdqog22fCBCqEaRxKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 407/484] netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
Date: Thu, 30 Jul 2026 16:15:04 +0200
Message-ID: <20260730141432.316223589@linuxfoundation.org>
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
@@ -1368,7 +1368,7 @@ static struct nft_pipapo_match *pipapo_c
 
 	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL_ACCOUNT);
 	if (!new)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	new->field_count = old->field_count;
 	new->bsize_max = old->bsize_max;
@@ -1444,7 +1444,7 @@ out_scratch:
 	free_percpu(new->scratch);
 	kfree(new);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 /**
@@ -1798,7 +1798,7 @@ static void nft_pipapo_commit(struct nft
 		return;
 
 	new_clone = pipapo_clone(priv->clone);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -1824,7 +1824,7 @@ static void nft_pipapo_abort(const struc
 	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
 
 	new_clone = pipapo_clone(m);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -2265,8 +2265,8 @@ static int nft_pipapo_init(const struct
 
 	/* Create an initial clone of matching data for next insertion */
 	priv->clone = pipapo_clone(m);
-	if (IS_ERR(priv->clone)) {
-		err = PTR_ERR(priv->clone);
+	if (!priv->clone) {
+		err = -ENOMEM;
 		goto out_free;
 	}
 


