Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C303D44C51B;
	Thu, 20 Aug 2026 17:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248099; cv=none; b=f68pMz61K6mpydOLQxIlwySHZm/e5IQSpQZKRkr3TKMv4YF5uJeiOvzZZQUleX9Wkvf8U/cJCyXkkqn0rzOLUjNgfrbyTA5ChaNlilW5+YCq7NYArbe63y/8c3zehZAtAjATQAbc47yFH/52By6T43+y5SZtdKmW2i26ctZAek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248099; c=relaxed/simple;
	bh=Dhxz+s1Dueapa/STPTfKloRaq3DQcwQnlJk+VC3nlBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osZskVQ15oiu8rOxpoeqX/Ue2LOWMlNgZvm8+wRr4CoctBZrWV3NgFuWwN+unMQZB40EblWwVE7V8j5SMc3bVpeBaQWDAr0hWeSCmyT8qWRXvKZF8rFtkzWqvU0CFAUpznJUX6ktPVOORwkIuAgXyDSFUooDGsSgxEKo+q8SZGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HU7Q+h4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HU7Q+h4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80131F000E9;
	Thu, 20 Aug 2026 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248098;
	bh=VzORKOyWAKR1T8xenmdz8JVsfmB215bDWaT+ttp1df0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HU7Q+h4kXGdnlteVajhnOmao58EN4laqCs6onejiKcjuDyNPQc9XZEspZ/plR8+iX
	 ysrB1v7XpCT5lP5nHpi500640UMkhcoP+t897JohqU66dg4K1JJ7lsg21lkzxdZ/PX
	 nuHn9WStglmLBuRNSAxTrmzcuFqOcDkXnFcryjl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/303] netfilter: nft_set_pipapo: merge deactivate helper into caller
Date: Thu, 20 Aug 2026 16:53:59 +0200
Message-ID: <20260820145256.381836376@linuxfoundation.org>
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
@@ -1855,52 +1855,31 @@ static void nft_pipapo_activate(const st
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


