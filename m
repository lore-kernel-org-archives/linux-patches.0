Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6160267B89;
	Tue,  8 Apr 2025 12:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116942; cv=none; b=mBQtihQfQXKmLMFK1WqA7U3O1gHQjrCK04nBebMMr6HX3IyMuhQdvXg1it+xte8ApqOyIBIe/0ejGE1yNwsnXWhT+MRi6aAkKIC0Cc5mFO9VwnCcVo1yuKYWOCwNrquGB3d0sn4dj28GkCHaLmVm3+cN5n1YlhYzAy3f9k7wJHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116942; c=relaxed/simple;
	bh=ltOOKadGMm4poFg97z+LhRwm+UMb/2/GutZprlFHlvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFkSbS0pyd5gUhyk0pQtb1GhNuwmDYlzGB/lu5vgro0QOkK+jBD/OIx8Nc8zuJalRtAn5cpnHZNvfzcFJkgqLX9Lgwe316XJ3eVzsxZqFI6svdqSIvbWD7Ni9Fe4ld743wfD1wM2xFXrkAUgFDhj8FGFaOyRJs0c7EG+JCEvgG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJoT5KEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJoT5KEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5498DC4CEE5;
	Tue,  8 Apr 2025 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116942;
	bh=ltOOKadGMm4poFg97z+LhRwm+UMb/2/GutZprlFHlvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJoT5KEVaMhuP/tzzUhySgcuDaFeQGG2CAsHa9Wlt8NYvOwxkovm0j49wYQ36uwl2
	 HqlhOIm4OZMhDXivZMJAoGhhzyD7oL+X8q+PetjcDjGhbXR5csxnCvRR04pAbE/6oS
	 peRUcqlGsa7GamYn6mh/I/tXh4z6OhyMXgMUwfKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/423] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
Date: Tue,  8 Apr 2025 12:50:52 +0200
Message-ID: <20250408104853.410132618@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 9d74da1177c800eb3d51c13f9821b7b0683845a5 ]

conncount has its own GC handler which determines when to reap stale
elements, this is convenient for dynamic sets. However, this also reaps
non-dynamic sets with static configurations coming from control plane.
Always run connlimit gc handler but honor feedback to reap element if
this set is dynamic.

Fixes: 290180e2448c ("netfilter: nf_tables: add connlimit support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index b93f046ac7d1e..4b3452dff2ec0 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -309,7 +309,8 @@ static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
 
 	nft_setelem_expr_foreach(expr, elem_expr, size) {
 		if (expr->ops->gc &&
-		    expr->ops->gc(read_pnet(&set->net), expr))
+		    expr->ops->gc(read_pnet(&set->net), expr) &&
+		    set->flags & NFT_SET_EVAL)
 			return true;
 	}
 
-- 
2.39.5



