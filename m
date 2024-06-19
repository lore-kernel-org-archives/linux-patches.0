Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1882495;
	Wed, 19 Jun 2024 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803137; cv=none; b=Rqtcm3rDMDLwTTCuasVQHNRfxbXDfzWJHT8YJejQn0DipLfpeqVi2QAf2BMqZggINPZBbdiPhJL5hdHJPxLzSUVzWw5ZpctPybQQQY3aX0NHvHr/TGs659eH0+oAAau97SflcaghLzMvQytPwouLD4zSR8jhpw4lW8qlTAUllMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803137; c=relaxed/simple;
	bh=0EZPGZzsZviI8vLwbfZzAMThvuZbUVBqNC39GyUqJoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDMDuU40a2c6yED82NbuCi4XlUDGwEjCTbZFtUdnKJVJ6P3JHGvCbdS3owS7Z0MvliG1gHHeugvkkrqBwUGF4Wm3F9YHuxjJYP8xppa/NmlRbS3BnIcG1KlQbBwRapOgYC8Dybqbm+Bkmv5onGKUnF6pDvskFHfsi1TXKUefaww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMfzcVEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMfzcVEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA34C2BBFC;
	Wed, 19 Jun 2024 13:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803137;
	bh=0EZPGZzsZviI8vLwbfZzAMThvuZbUVBqNC39GyUqJoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMfzcVEWo7B4DDPd0fc+XBfeAP5gsHnJ/emaY6ri7nhINDlmap0XkNBdTpid412yh
	 kx0UVFyiwfjsscDRD3hnYYQzPoXjwsUdK5qsFXaOQQe/mI+AJ4cA0uHOR2QS7ujv8Z
	 Dk0s2CloIL/LYT0pFORyXZhoTFehtEws5NI7RG1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 165/281] netfilter: nft_inner: validate mandatory meta and payload
Date: Wed, 19 Jun 2024 14:55:24 +0200
Message-ID: <20240619125616.187226672@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Ornaghi <d.ornaghi97@gmail.com>

[ Upstream commit c4ab9da85b9df3692f861512fe6c9812f38b7471 ]

Check for mandatory netlink attributes in payload and meta expression
when used embedded from the inner expression, otherwise NULL pointer
dereference is possible from userspace.

Fixes: a150d122b6bd ("netfilter: nft_meta: add inner match support")
Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_meta.c    | 3 +++
 net/netfilter/nft_payload.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ba0d3683a45d3..9139ce38ea7b9 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -839,6 +839,9 @@ static int nft_meta_inner_init(const struct nft_ctx *ctx,
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int len;
 
+	if (!tb[NFTA_META_KEY] || !tb[NFTA_META_DREG])
+		return -EINVAL;
+
 	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
 	switch (priv->key) {
 	case NFT_META_PROTOCOL:
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0c43d748e23ae..50429cbd42da4 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -650,6 +650,10 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 	struct nft_payload *priv = nft_expr_priv(expr);
 	u32 base;
 
+	if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
+	    !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
+		return -EINVAL;
+
 	base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	switch (base) {
 	case NFT_PAYLOAD_TUN_HEADER:
-- 
2.43.0



