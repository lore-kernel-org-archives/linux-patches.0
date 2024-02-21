Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2124F4D5B7;
	Wed, 21 Feb 2024 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523111; cv=none; b=lm36dF3H+d3Wlagq29Jhqt38F3jBfXv3unkfTmblwbaFefjSQPZPdhPyNXbLbg6KOlVlnmeYGMfgdDEflKFVEhHNW+FMw5PXDxObm5Ig3R+kqAkuEa0lUrTl7J1xI/QRu44Oq6D1yMtR8V8iPI3SAhRM+JtnIXFliYHhhwlxfw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523111; c=relaxed/simple;
	bh=PAxHFpP1DTW/mCkzaczQfaVyrN7q752ZHucVpXKw5yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOk0BlIrOJ/vp72BqQEZ/GeZzsFs0VrRxffHmIzbUQ0zbL9tA6VIAGr1QVbLD/Y+kS8png/xala9RMbRbMKd4pdUmujD7j2S0kAcqx8eVjV22Ad8stJLhiMXBP/hSnHc9dZIwc4wHWyH1yj9SE6mg8U3OPYR/+P9qPD2MbZ3wyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgV7Rpfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgV7Rpfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EDEC433F1;
	Wed, 21 Feb 2024 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523111;
	bh=PAxHFpP1DTW/mCkzaczQfaVyrN7q752ZHucVpXKw5yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgV7Rpfw4xGhI7rI8cynk6Kgv2lyL3BnQWkYN7+vFygjj2600N1kWZFWtlIPFYQHJ
	 0gBVcCMCiWuVcBBmm6cLD85KHLtsRJH+vxIrf/73ftxI9NByFz888Gof8TMQJKqDTE
	 vqhVoPGKwBsJhC496sMK1jEM7KtMpGKWfJD0THMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 343/476] netfilter: nft_set_rbtree: skip end interval element from gc
Date: Wed, 21 Feb 2024 14:06:34 +0100
Message-ID: <20240221130020.680349527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 60c0c230c6f046da536d3df8b39a20b9a9fd6af0 upstream.

rbtree lazy gc on insert might collect an end interval element that has
been just added in this transactions, skip end interval elements that
are not yet active.

Fixes: f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")
Cc: stable@vger.kernel.org
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -235,7 +235,7 @@ static void nft_rbtree_gc_remove(struct
 
 static const struct nft_rbtree_elem *
 nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
-		   struct nft_rbtree_elem *rbe, u8 genmask)
+		   struct nft_rbtree_elem *rbe)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
@@ -254,7 +254,7 @@ nft_rbtree_gc_elem(const struct nft_set
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
 		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, genmask))
+		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
 			break;
 
 		prev = rb_prev(prev);
@@ -365,7 +365,7 @@ static int __nft_rbtree_insert(const str
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			const struct nft_rbtree_elem *removed_end;
 
-			removed_end = nft_rbtree_gc_elem(set, priv, rbe, genmask);
+			removed_end = nft_rbtree_gc_elem(set, priv, rbe);
 			if (IS_ERR(removed_end))
 				return PTR_ERR(removed_end);
 


