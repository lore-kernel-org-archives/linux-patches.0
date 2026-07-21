Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A9D42D76B;
	Tue, 21 Jul 2026 19:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661024; cv=none; b=GVVu9SBtUiK38fLvt5m6KbEV4te0nOSmMuBL89CxpAHrHYXjvc6VzSQZCiD5cQQFumyS2F/dSmvslz9IZk4BmVE7Ncm1L/Thyc1MQhN8HiClRyva9NQfVq39dBJpenHq+b0sZyXbJp6b7B9UmONxAhJ/+9WpU5Z7rqihyRuDrcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661024; c=relaxed/simple;
	bh=d6h75WbixJm5uuqfSFHN30lyys9De3vFMtmUZJQbDyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm64z2HZkrx+COuJ63Ui2I1Ur1kliqvBAnn5lWNoN1WABtTVXfdDUYjztPGM/PahrdotlglWan60Wh3gCDNQTjDt6TC50cUOq02UUSyPIh/sw7x/b0QKJvSiSJLApSKk5109Ayz3pf9oMzf/YwCvnKG0E4pQ25MFOJosIcFijTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqZYCfoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqZYCfoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A621F000E9;
	Tue, 21 Jul 2026 19:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661023;
	bh=m6RnwF+8BeWoxTk1UWjIWJu1GcmCTDaFQ/1YpKoaWQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqZYCfoH6U/iIAbsQIriwh+53TfB0LCGZ75ecI7kh0f9EcqVDSaYNBgBO3+Np5Y1w
	 cyRIVpbsr+PbHs1S8haI6ucYaudGF4g1+ctyqgXJW4SilvmB1RkOuPO9nwsfeLabAG
	 PjNjUd6QT51M4tJP2Zxn+FBL55i3bB3m/p7cNNyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1150/2077] netfilter: nft_payload: reject offsets exceeding 65535 bytes
Date: Tue, 21 Jul 2026 17:13:43 +0200
Message-ID: <20260721152619.946503354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 213be32f46a29ca15a314df06c3424ecffd6c90a ]

Large offsets were rejected based on netlink policy, but blamed commit
removed the policy without updating nft_payload_inner_init() to use the
truncation-check helper.

Silent truncation is not a problem, but not wanted either, so add a
check.

Fixes: 077dc4a27579 ("netfilter: nft_payload: extend offset to 65535 bytes")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 484a5490832e4a..4438d05f8018c6 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -224,11 +224,17 @@ static int nft_payload_init(const struct nft_ctx *ctx,
 			    const struct nlattr * const tb[])
 {
 	struct nft_payload *priv = nft_expr_priv(expr);
+	u32 offset;
+	int err;
 
 	priv->base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
+	if (err < 0)
+		return err;
+	priv->offset = offset;
+
 	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
 					&priv->dreg, NULL, NFT_DATA_VALUE,
 					priv->len);
@@ -621,7 +627,8 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[])
 {
 	struct nft_payload *priv = nft_expr_priv(expr);
-	u32 base;
+	u32 base, offset;
+	int err;
 
 	if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
 	    !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
@@ -639,8 +646,11 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 	}
 
 	priv->base   = base;
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
+	if (err < 0)
+		return err;
+	priv->offset = offset;
 
 	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
 					&priv->dreg, NULL, NFT_DATA_VALUE,
-- 
2.53.0



