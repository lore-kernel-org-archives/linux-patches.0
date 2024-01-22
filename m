Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E70D1350CA;
	Tue, 23 Jan 2024 01:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971954; cv=none; b=Vr4Iwup0X6wVQ0xz4Iw0aIw6v6JyIZEyuG/3U+uxDjkI+Ho5fGNQdN8qdG6WYBvQ+XeEfPXx19OUsyJcLzMmhRCVBP2bAxRD8NNCwcV5OOpMyCcnfIvqYwcNbx27DAiEyzO1JO8B01vT8d2xhqiKm6WSeY+oAT3awwbd3B/v+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971954; c=relaxed/simple;
	bh=DTyE1XY4mkeB3NXi/NgpwY8T/HlDs8yvQ9xLFs0GbB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgHNYx14b2+rCoy+GZ/kl/OHnQBjpk2f1nltbHFZ/hgyDHvBaEi+I6aLBapWJzAU+1UHXI8+Qd7f0ligUoMQD41qsdprixye9Kc3nTmI5qNru1Fdj4hzGx5jDxsHc27seJU8Fl/I8f1F1h+hnsfHC5KMpiGtLfAhWrOaWXYe72Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu5yT/by; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu5yT/by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47405C433C7;
	Tue, 23 Jan 2024 01:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971954;
	bh=DTyE1XY4mkeB3NXi/NgpwY8T/HlDs8yvQ9xLFs0GbB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu5yT/byp2mB6QofB8jM6f1QzWNJJRNuxTJP1bN0hmP53ysnvcK/txBK5ysDq4XcG
	 1DrPZ6r4JK6FMIwjzZwvqW1fmABPUvtSg83AoRxRvZnLXyx3iO8uQIO9nlX9V0GoEq
	 0P63IM5tqyn8qJxwbOsC5zurAbUHIJkvn3WFQdm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/286] netfilter: nf_tables: skip dead set elements in netlink dump
Date: Mon, 22 Jan 2024 15:59:38 -0800
Message-ID: <20240122235742.528649861@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6b1ca88e4bb63673dc9f9c7f23c899f22c3cb17a ]

Delete from packet path relies on the garbage collector to purge
elements with NFT_SET_ELEM_DEAD_BIT on.

Skip these dead elements from nf_tables_dump_setelem() path, I very
rarely see tests/shell/testcases/maps/typeof_maps_add_delete reports
[DUMP FAILED] showing a mismatch in the expected output with an element
that should not be there.

If the netlink dump happens before GC worker run, it might show dead
elements in the ruleset listing.

nft_rhash_get() already skips dead elements in nft_rhash_cmp(),
therefore, it already does not show the element when getting a single
element via netlink control plane.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 009cb23bc972..7a1a21cde760 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5011,7 +5011,7 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_set_dump_args *args;
 
-	if (nft_set_elem_expired(ext))
+	if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext))
 		return 0;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);
-- 
2.43.0



