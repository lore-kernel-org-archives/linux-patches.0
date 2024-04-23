Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D560143891;
	Tue, 23 Apr 2024 21:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908476; cv=none; b=PYz3i9ziIuviQZKUVnc9kynfpS8QtfR3lqpQIs9NwyYNyjKljOd4skOAUDlxYWggd1rWPYHzo3R3GVRG2OpXbO1ScWKEZd/6Vfn7I2hpab5c7afabTWJH1wDvP06MHkk0gEa60OPIPZ0+Vs9bgjCXCZj5698ZY4ugVrXIqedp+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908476; c=relaxed/simple;
	bh=OeZZ9t3c0urTmHBGY0/06s8Y9uCPiwRg0QaSU8Yf7YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI32MZ48zFvehdUTs+0dMh4xPL9w/vI1n2i2LVa3jiFxBGoe7IVhq99FhMfbMbvVxx6u7U2QYtphwd6za/2AMKZMsnq+P9Dqzh60FgquOs4YcIJjMK+dJTA1+DnZ+nWih+O1zLTCUjQFNwxam6SK0eetctrB36LJHcrLXi+LLqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JZUcnyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JZUcnyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019CEC4AF08;
	Tue, 23 Apr 2024 21:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908476;
	bh=OeZZ9t3c0urTmHBGY0/06s8Y9uCPiwRg0QaSU8Yf7YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JZUcnytobGGD9ph6+XVg6stsMGKo5Xj7iOmbNVxknOZP1+cgEwSkV0IJNZ9DAXWP
	 U0dM9BAR6Y9iaP4kOwUb00nrWnaB5C/vL3h5S6HeUf2d5t4kT2mTRdcqtGtArqv8lY
	 dbkYkvtnxWTPwsagO8go4Hg3v/51MIB9+Jfid6TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 044/158] netfilter: nf_tables: missing iterator type in lookup walk
Date: Tue, 23 Apr 2024 14:37:46 -0700
Message-ID: <20240423213857.348219262@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit efefd4f00c967d00ad7abe092554ffbb70c1a793 ]

Add missing decorator type to lookup expression and tighten WARN_ON_ONCE
check in pipapo to spot earlier that this is unset.

Fixes: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_lookup.c     | 1 +
 net/netfilter/nft_set_pipapo.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 870e5b113d13e..87c18eddb0689 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -216,6 +216,7 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 		return 0;
 
 	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 979b5e80c400b..c91efad49c6d5 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2048,7 +2048,8 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_field *f;
 	int i, r;
 
-	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
+		     iter->type != NFT_ITER_UPDATE);
 
 	rcu_read_lock();
 	if (iter->type == NFT_ITER_READ)
-- 
2.43.0



