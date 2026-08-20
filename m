Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D707146D0BD;
	Thu, 20 Aug 2026 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243443; cv=none; b=YGKKfBBvZr2o6e3UT6tNFGG3P5Pu+IhhZs4tsqa+MSgzYb7BRxYF1aRDfvDYQF0nq4/dQmOykuTRKyL2ExI0lPZOQE2c2QufKqWAiXV7k8JPAO8Ytp2Z1dO50mQvE45PhLReKu/++h+MCuVDoQ9kgyzOVcCHdBkGc+MGEy0vAFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243443; c=relaxed/simple;
	bh=KP+v394QOCRDoZo/dtVgkGsYLZb90+RjD/0SjWGY6vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX8uafovZjbv6m7AQL37md1UT2PPWeDX+SAHSuOAEKkYl1EESNiWtkRCtx5rE3hfaRN4/dKC2u/JtNOj89x8VQ16+oECOXIsmO9dxEjOBtQT282woPw5w/Npe0/EFqNB9KjMdlJ42SgZnO/+LNXB8rZN2nGrklIiVFhKLkOUKAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+9yoCgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+9yoCgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410421F000E9;
	Thu, 20 Aug 2026 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243441;
	bh=rr9jUS+sIbETNgSx65v/+GcoXfqXhXyI5oXKc2BgJrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+9yoCgOwuV5mF/LrMSvl/mALdZtNt7S4Jz8Z+L//Q6oiteRfPSoLsAZQYxv5eoRV
	 w84Q10vp8xQQXq8FV2FBx4codC/Ww7y9F3ejy2HNQz+9vYvEZbh0KR02BsyA3jB3ba
	 JcLhj/qRxecxt21+fbrrK/LCyaIjb9YG5leHtFlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/272] netfilter: nft_set_pipapo: merge deactivate helper into caller
Date: Thu, 20 Aug 2026 16:54:40 +0200
Message-ID: <20260820145234.151640368@linuxfoundation.org>
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

[ Upstream commit c5444786d0ea2417a5e2cee7bd67137fc8bad687 ]

Its the only remaining call site so there is no need for this to
be separated anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 47e65eff5069 ("netfilter: nft_set_pipapo: don't leak bad clone into future transaction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1826,52 +1826,31 @@ static void nft_pipapo_activate(const st
 }
 
 /**
- * pipapo_deactivate() - Check that element is in set, mark as inactive
+ * nft_pipapo_deactivate() - Search for element and make it inactive
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @data:	Input key data
- * @ext:	nftables API extension pointer, used to check for end element
- *
- * This is a convenience function that can be called from both
- * nft_pipapo_deactivate() and nft_pipapo_flush(), as they are in fact the same
- * operation.
+ * @elem:	nftables API element representation containing key data
  *
  * Return: deactivated element if found, NULL otherwise.
  */
-static void *pipapo_deactivate(const struct net *net, const struct nft_set *set,
-			       const u8 *data, const struct nft_set_ext *ext)
+static void *nft_pipapo_deactivate(const struct net *net,
+				   const struct nft_set *set,
+				   const struct nft_set_elem *elem)
 {
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, data, nft_genmask_next(net),
-		       nft_net_tstamp(net), GFP_KERNEL);
+	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
 
 	nft_set_elem_change_active(net, set, &e->ext);
 
-	return e;
-}
-
-/**
- * nft_pipapo_deactivate() - Call pipapo_deactivate() to make element inactive
- * @net:	Network namespace
- * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
- *
- * Return: deactivated element if found, NULL otherwise.
- */
-static void *nft_pipapo_deactivate(const struct net *net,
-				   const struct nft_set *set,
-				   const struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-
-	return pipapo_deactivate(net, set, (const u8 *)elem->key.val.data, ext);
+	return &e->priv;
 }
 
 /**
- * nft_pipapo_flush() - Call pipapo_deactivate() to make element inactive
+ * nft_pipapo_flush() - make element inactive
  * @net:	Network namespace
  * @set:	nftables API set representation
  * @elem:	nftables API element representation containing key data


