Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1B21A186B;
	Thu,  6 Jun 2024 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683747; cv=none; b=jzscuoitcDkPJOMRAXwEZTKDPmiF3UlTpftQ/bC27134qQOrtrIv9Y0bwC8G9eXvAUglze9hEjK9V2dNI+GybRwA6JqyoHBjFWH6a0503gYhP2sNSeKbdP1i5X3JuobR+XyliDGQjq59h5zz/aBxpTi0kUscUbF9/gmbDE148Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683747; c=relaxed/simple;
	bh=p1S3r9C7diZTqdlxWcQNvjlg1R+tcXcpRoVpW+hi1Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8TuWIH0nBXm07y+oxtb3xQCpml4K2ocHwx4pA+ieHR28+fai585R6tWuJ7U5D6QzhVVG7TnDrNpdeUWJ1rLyfXCwaDG9PsFkHeWTJxApErIRI4KajKcaACReC2zukKxDdDx6CWFrurw6b+K9twkx1LljU6LZUgW661daok2S8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGJtQHLj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGJtQHLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A3DC2BD10;
	Thu,  6 Jun 2024 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683747;
	bh=p1S3r9C7diZTqdlxWcQNvjlg1R+tcXcpRoVpW+hi1Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGJtQHLjETh9NJpRCWaN/syXxlxOQbpBK2Pk2mk8/yi+NxTo8qlRcE+jGci6t1Tfl
	 HqGo3dMqOuBYgRs+1zNRWMHkj+/oE06ottArwxyEJGN1R4nGSgMT08o3JLqmKwFQdx
	 kG9m8pSEq5Vj14H4zx3/bItIip6FxtoYcFx3pTbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 714/744] netfilter: nft_fib: allow from forward/input without iif selector
Date: Thu,  6 Jun 2024 16:06:26 +0200
Message-ID: <20240606131755.373834166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Garver <eric@garver.life>

[ Upstream commit e8ded22ef0f4831279c363c264cd41cd9d59ca9e ]

This removes the restriction of needing iif selector in the
forward/input hooks for fib lookups when requested result is
oif/oifname.

Removing this restriction allows "loose" lookups from the forward hooks.

Fixes: be8be04e5ddb ("netfilter: nft_fib: reverse path filter for policy-based routing on iif")
Signed-off-by: Eric Garver <eric@garver.life>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_fib.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index ca905aa8227e5..bf825f6cb974e 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -35,11 +35,9 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
-		hooks = (1 << NF_INET_PRE_ROUTING);
-		if (priv->flags & NFTA_FIB_F_IIF) {
-			hooks |= (1 << NF_INET_LOCAL_IN) |
-				 (1 << NF_INET_FORWARD);
-		}
+		hooks = (1 << NF_INET_PRE_ROUTING) |
+			(1 << NF_INET_LOCAL_IN) |
+			(1 << NF_INET_FORWARD);
 		break;
 	case NFT_FIB_RESULT_ADDRTYPE:
 		if (priv->flags & NFTA_FIB_F_IIF)
-- 
2.43.0



