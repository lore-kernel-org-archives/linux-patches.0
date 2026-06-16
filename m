Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51B23D8105;
	Tue, 16 Jun 2026 18:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634169; cv=none; b=l1K1ahZa/CDIYchcM+HoFTppWRyydlj5L8dT3R2dk3c41oAb5P0ObMcfSTrolayIsy85CIJeliX2T7Md7Q/Bez6Dv33cOaKhgEHIZ/eSPAvP1hfm+hvotJHR2g5ZX+TjEJkZheuNYPgaMFhQm1JPo7DYrwn+VrJV06ltSYF6+SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634169; c=relaxed/simple;
	bh=cM26CCxXnVy4Sk5Sf3VeW1xqZHg/Ff6nXUQKM4cd40w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddT3P3h+GkF+AKmOCLQwCIO2zOQszVWy3bHC7SvQP6bBbiQit3N0W2+Y+bvLHgqgimQBYFQceK4Ud+v7AUYmvKmJspukLh4xUl1Qve0EF9e7UnW91+9Y+aIZgIyAF6sGmS2+z8p8+m0ZwhdBHETo2ScstqBQIBPr77R/cOiyB3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLND9tL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLND9tL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63C91F000E9;
	Tue, 16 Jun 2026 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634168;
	bh=Uxoux+Zfv8LquwHNouJyVce2dYV6u5TFPxU6Pdn58uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLND9tL034L71wKCookWzZyEKtbhGP8D3ZPOIZ0ZEIjirY+Tw8Df+A5utG1dra9lc
	 s1E1r/cc16VmO5AzxeCr/mIZCYRemHSKat+rgpNDG5vhuFejTChTqoqM0oHYXsSRj4
	 txUHroq5giea5G59ZyvMqI0msAlapKIl010Bie9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/411] netfilter: nft_exthdr: fix register tracking for F_PRESENT flag
Date: Tue, 16 Jun 2026 20:27:12 +0530
Message-ID: <20260616145111.033535952@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

[ Upstream commit 772cecf198da732faebb5dcfc46d66a505be8495 ]

nft_exthdr_init() passes user-controlled priv->len to
nft_parse_register_store(), which marks that many bytes in the
register bitmap as initialized.  However, when NFT_EXTHDR_F_PRESENT
is set, the eval paths write only 1 byte (nft_reg_store8) or
4 bytes (*dest = 0 on TCP/DCCP error path).  When len > 4,
registers beyond the first are never written, retaining
uninitialized stack data from nft_regs.

Bail out if userspace requests too much data when F_PRESENT is set.

Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Fixes: c078ca3b0c5b ("netfilter: nft_exthdr: Add support for existence check")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 7c2931e024bb05..e8978a0aa7408f 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -454,6 +454,9 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			return err;
 	}
 
+	if ((flags & NFT_EXTHDR_F_PRESENT) && len != 1)
+		return -EINVAL;
+
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
-- 
2.53.0



