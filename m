Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A90F1D0795;
	Wed,  2 Oct 2024 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877368; cv=none; b=hU9dBCKlH1b20L4R9IySNto0ZE+Bfic3bnqgqVWPYGbkjtmrcmtHye6B0TrgdN/5Usxj8nRNZFSFxkPd5VZpARe4EDYruv3uukx7Sai17HNgRiqgYgLEHcepeJW+6cPwrMiFPx/wGTeqniF+1wvNUE/pgCJ/NLMtqxmqPQ+F43o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877368; c=relaxed/simple;
	bh=w3KCrI7KttNBJdtS2L4hOau3lO/vV7SVKYRcd2BSk34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyjfc0NnapN8vlKsVAo7vFIpixxtDlaswgqnYPZQjGZFMllQ+G6z9ztcKKENdJ9F/uo/c+eRFEZWKgcD3WcN88z2D+YS0ysJsH5+tC6bp5y0M0KLd/qHkUqwX4zqkgr0AjlpRkYVjTt+BbSsoqkfMKUIfIVV6UJ4sI4BJ3s2Nnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuAqnXvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuAqnXvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A8BC4CECD;
	Wed,  2 Oct 2024 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877367;
	bh=w3KCrI7KttNBJdtS2L4hOau3lO/vV7SVKYRcd2BSk34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuAqnXvtLx8xViMHF8lG0ywTyplthcXXxhqUVupJA6wOdnATIKI6BwOaHo8XNBOv3
	 +e0cds3wqUYakakPSl+67RjUnG0xfhlrl83gkE9ZV/6aJEGIJoeoV0T/YAx+POAsiT
	 oXogxGfF5Xl1zrfThcp3FfH+c2ZDY51Eydrb0oYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 057/634] netfilter: nft_dynset: annotate data-races around set timeout
Date: Wed,  2 Oct 2024 14:52:37 +0200
Message-ID: <20241002125813.357352781@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c5ad8ed61fa8410b272c077ec167c593602b4542 ]

set timeout can be read locklessly while being updated from control
plane, add annotation.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_dynset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index b4ada3ab21679..489a9b34f1ecc 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -56,7 +56,7 @@ static struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
 	if (!atomic_add_unless(&set->nelems, 1, set->size))
 		return NULL;
 
-	timeout = priv->timeout ? : set->timeout;
+	timeout = priv->timeout ? : READ_ONCE(set->timeout);
 	elem_priv = nft_set_elem_init(set, &priv->tmpl,
 				      &regs->data[priv->sreg_key], NULL,
 				      &regs->data[priv->sreg_data],
@@ -95,7 +95,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 			     expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
-			timeout = priv->timeout ? : set->timeout;
+			timeout = priv->timeout ? : READ_ONCE(set->timeout);
 			*nft_set_ext_expiration(ext) = get_jiffies_64() + timeout;
 		}
 
@@ -313,7 +313,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		nft_dynset_ext_add_expr(priv);
 
 	if (set->flags & NFT_SET_TIMEOUT) {
-		if (timeout || set->timeout) {
+		if (timeout || READ_ONCE(set->timeout)) {
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_EXPIRATION);
 		}
-- 
2.43.0



