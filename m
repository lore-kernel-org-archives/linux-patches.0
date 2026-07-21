Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EB03B4EAC;
	Tue, 21 Jul 2026 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658167; cv=none; b=S0At1bWmplC5l4lhfWsUSmv/oFSofJY09aq7rcll74lMx1kf2B2AGtgAfFHVQIX+ydnvGSH/b7VuylhpSIrSusTd/bV8Ab228fpD9FVQg9zMZokLIRIisR+8n/4qSMYJNjera2QaUFmvo/Xv5/kK1ShnG92f64kIe+7XBwpInsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658167; c=relaxed/simple;
	bh=+C0DyQyXKsRSI5WBlHZCcSgVigPGwnfGmQBep8G8/GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpsNgwDysrMrGTwEp9k7oaP2871pOYnsj0iLCidrgeaG7GjgTIbGX3mY4PDhSLGcLEG9ltBaxe3qJUvt8M7Fv3L/IBIRjO8cSSY0k0rYzQEqCF8olCcWHdXHulIMX7cdFlazQzeudhxlo+4rMdnruLoX8FDRqh0nhFclPKzA2iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOYLcwMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOYLcwMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371991F000E9;
	Tue, 21 Jul 2026 18:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658166;
	bh=AxcMmfvwjDP6r6E9Ql+FIFQeWWzxlCX25lm+ft2+jm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOYLcwMj9o6nQoKp6MGeu2Ta9TqrT759dYu++a7GfRTVsidGkM2cwk7sZNGwwMzSp
	 Z8QrC6fz7TuZCTIsNZS5lwLijQJeR9lS+SXVHJNFAa4eIH01PMEVHGVx+4qbTkCRZm
	 6MrrmYHkEGC5malIGgH5+pP8YHQHxKfGVL6+v1o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1041/1611] netfilter: nft_set_rbtree: get command skips end element with open interval
Date: Tue, 21 Jul 2026 17:19:17 +0200
Message-ID: <20260721152538.818320369@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d63611cbe8af99dd61b118ee6e5b5e3e518250b2 ]

The get command on intervals provide partial matches such as subranges
for usability reasons. However, an open interval has no closing end
element. If the closing element matches within the range of the open
internal, ie. its closest match is the start element of the open range,
then, return 0 but offer no matching element to userspace through
netlink as a special case. Userspace provides at least a matching start
element in this case and the closing end element matching the open
interal is ignored.

Another possibility is to report the matching start element of the open
interval for this end interval. However, this results in duplicated
matching being listed in userspace because userspace does not expect a
start element as response to a end element.

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Reported-by: Melbin K Mathew <mlbnkm1@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c  | 3 +++
 net/netfilter/nft_set_rbtree.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 64e6a95439abd5..0842916c19f503 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6552,6 +6552,9 @@ static int nft_get_set_elem(struct nft_ctx *ctx, const struct nft_set *set,
 	if (err < 0)
 		return err;
 
+	if (!elem.priv)
+		return 0;
+
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 154bf2772e27d8..a698420ab2b8c2 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -184,10 +184,14 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	if (!interval || nft_set_elem_expired(interval->from))
 		return ERR_PTR(-ENOENT);
 
-	if (flags & NFT_SET_ELEM_INTERVAL_END)
+	if (flags & NFT_SET_ELEM_INTERVAL_END) {
+		if (!interval->to)
+			return NULL;
+
 		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
-	else
+	} else {
 		rbe = container_of(interval->from, struct nft_rbtree_elem, ext);
+	}
 
 	return &rbe->priv;
 }
-- 
2.53.0



