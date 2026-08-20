Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B7377A82;
	Thu, 20 Aug 2026 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243437; cv=none; b=fXf9CDsVx5Z+/rYTLASuHLtN62N3+TmgqFn7XD80W+xOOpXGoNn90WOVUDzdPNHOMNyGdL7HSUE+IxOvQrFFBuVydo7V/qbYiHI9Cwew50jRu2+/QowMZWkFSKdrHVZP7tVRLF1DQdwVmSS8OUPfv1tVu0Gz8JqARxAEewKO07E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243437; c=relaxed/simple;
	bh=7jgFEpTG0fc0Zn+yFB6ucKSLs2IPlHkbga1AhBEcz6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgDLKuQ6JTaFAkfdURPHFhxAaHUxnxPnZ3WC2TFvO+Hlbsgp3W5dpQnuQkdrxNiAvnuFPzke0+mZZxTOTKQd+7Euct2VNI5uO2Qr2g9Fx03g11hVfNXFLbYbaOZZXBepQpIgNpmLIdNmtAQGwnM3LqVTlX/onzzqgi24Ec1o0NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xe+7vpPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xe+7vpPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFEA1F000E9;
	Thu, 20 Aug 2026 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243436;
	bh=SEeYSV+67fjyWxYs/asJrPoV3AiHE521ZQFuwFwolZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xe+7vpPAl2ANfJJFzaEjm83Ro3FIP47Ouw8Eg3qdurcCamQOC1BzzmTx7Bv+auDzN
	 S94ZFXDLSvHUa5Pe3eJxWm+vNwbxpEw9zR/x9Rupez9E0NrZl4Pq4aJ+YcIazyq+0e
	 O10j/lDo8vYbI7caWCzOlaKto9hXsOFKhR+QBCJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/272] netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
Date: Thu, 20 Aug 2026 16:54:38 +0200
Message-ID: <20260820145234.091057785@linuxfoundation.org>
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
@@ -1331,7 +1331,7 @@ static int nft_pipapo_insert(const struc
  * pipapo_clone() - Clone matching data to create new working copy
  * @old:	Existing matching data
  *
- * Return: copy of matching data passed as 'old', error pointer on failure
+ * Return: copy of matching data passed as 'old' or NULL.
  */
 static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 {
@@ -1342,7 +1342,7 @@ static struct nft_pipapo_match *pipapo_c
 	new = kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
 		      GFP_KERNEL);
 	if (!new)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	new->field_count = old->field_count;
 	new->bsize_max = old->bsize_max;
@@ -1416,7 +1416,7 @@ out_scratch:
 	free_percpu(new->scratch);
 	kfree(new);
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
 }
 
 /**
@@ -1770,7 +1770,7 @@ static void nft_pipapo_commit(struct nft
 		return;
 
 	new_clone = pipapo_clone(priv->clone);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -1796,7 +1796,7 @@ static void nft_pipapo_abort(const struc
 	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
 
 	new_clone = pipapo_clone(m);
-	if (IS_ERR(new_clone))
+	if (!new_clone)
 		return;
 
 	priv->dirty = false;
@@ -2238,8 +2238,8 @@ static int nft_pipapo_init(const struct
 
 	/* Create an initial clone of matching data for next insertion */
 	priv->clone = pipapo_clone(m);
-	if (IS_ERR(priv->clone)) {
-		err = PTR_ERR(priv->clone);
+	if (!priv->clone) {
+		err = -ENOMEM;
 		goto out_free;
 	}
 


