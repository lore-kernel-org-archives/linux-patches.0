Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA18E1A01C7;
	Thu,  6 Jun 2024 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683635; cv=none; b=YQQIqtEL4f1OKirHXPOaAVMGkfXOxes2mjtMA5NPR1oDCxOPLGO74T+DKTOG09y9LUk/eJDwRlZfmNbczxsEulEm95K+aqmD4gnuWuT/ZXuhEhPckLQZC3d0QKST9COYhymE1ASMsEuxbzF26jKmW28kr8kQy90BUs+ir+TyyD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683635; c=relaxed/simple;
	bh=x8+jYjp3N6NEjlb8DIF+F1hySB7/g7XOjqgCiIxYV3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yogp6nFpA48TYuDZsaS4V5aalkfampF4X/kcxV8+X5k1XEu7d/e/+OMJRzDdYv/SB73gwqn5q8Rm2FZgIBvlQUTzGGzB9ewVdNwDUGVuiT098/UxCDmlNo4y4kRzlWA57bPuOgD5MDR+PJe/iFLuXZUwy/GygtKzcX7o8pGekw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXIHSY4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXIHSY4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8E1C32781;
	Thu,  6 Jun 2024 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683635;
	bh=x8+jYjp3N6NEjlb8DIF+F1hySB7/g7XOjqgCiIxYV3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXIHSY4Th4SRDDC7pyWIJWKcjwBNOvO6zfJstKeJ3CQHK3v1FR0BYGUd1BSfQS5E8
	 3kXZPfoHJy22h1FJW68LxQpeHFgnBVu3g2OswU6cAsa8VaGIaRYDSzuwbzWIzVHYKu
	 VTPbO1sy1CUwtttWM4XbuYnYvCBazG38Bm8rfk+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 456/473] netfilter: nft_payload: rebuild vlan header when needed
Date: Thu,  6 Jun 2024 16:06:25 +0200
Message-ID: <20240606131714.763512209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit de6843be3082d416eaf2a00b72dad95c784ca980 ]

Skip rebuilding the vlan header when accessing destination and source
mac address.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 33c563ebf8d3 ("netfilter: nft_payload: skbuff vlan metadata mangle support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e36627a654244..74777a687eb5f 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -126,7 +126,8 @@ void nft_payload_eval(const struct nft_expr *expr,
 		if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) == 0)
 			goto err;
 
-		if (skb_vlan_tag_present(skb)) {
+		if (skb_vlan_tag_present(skb) &&
+		    priv->offset >= offsetof(struct ethhdr, h_proto)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
-- 
2.43.0



