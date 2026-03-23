Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D002343D2;
	Mon, 23 Mar 2026 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275338; cv=none; b=nn5UiapBVGShyaKtr+zaxmTID7vrC3htZYPJAYzXPtBpyZyBjDGpYZYXloPyTkkFCqT6EHZgUssduqRDfiZpap8Bo/mzLKwNZ03eGRxJHkrQZGGhisTSDaDtUFCz3uASMmVCjNwPdBOqN2GdmxqXDWZQB2PDKtHykfJv0x4Y+zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275338; c=relaxed/simple;
	bh=jpB9boU9+H6bLF/DcfKpocWGmujB6tAg/xfjnAEIxhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgH7PI/hyEaSUaJqxSq6ydBa0B4J8r3LqQhOR9lzH2RLK5xg6WW3W3ymnnVsr4CXsR9xG5MpT089P2nGBGeBHNVxbSIIZTSzHO5eCE/6s1pMoX4UUWPfroKbqEZGXdSQEJwe3T0/RJ4t5vIX1yJFlwHLKhCpUZq4uSCJFR7SPk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0nx1VZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0nx1VZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58175C4CEF7;
	Mon, 23 Mar 2026 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275338;
	bh=jpB9boU9+H6bLF/DcfKpocWGmujB6tAg/xfjnAEIxhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0nx1VZsT9w6UZNPgXT99b/oNm1amnpis+U63Mjyy9yZ03AfaG18shUbCXSWte9wn
	 vcHkJ8vphdGSiMWDBXv0K71cYrxLNIh2CxPyMYzIf0T8ChhOUsDezd9wX977BPTwo2
	 qlHZ/7kqsOyl8+RlVquWoEKDy7G2T8NswjivSDIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/460] netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()
Date: Mon, 23 Mar 2026 14:40:59 +0100
Message-ID: <20260323134528.258422772@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenny Guanni Qu <qguanni@gmail.com>

[ Upstream commit d6d8cd2db236a9dd13dbc2d05843b3445cc964b5 ]

pipapo_drop() passes rulemap[i + 1].n to pipapo_unmap() as the
to_offset argument on every iteration, including the last one where
i == m->field_count - 1. This reads one element past the end of the
stack-allocated rulemap array (declared as rulemap[NFT_PIPAPO_MAX_FIELDS]
with NFT_PIPAPO_MAX_FIELDS == 16).

Although pipapo_unmap() returns early when is_last is true without
using the to_offset value, the argument is evaluated at the call site
before the function body executes, making this a genuine out-of-bounds
stack read confirmed by KASAN:

  BUG: KASAN: stack-out-of-bounds in pipapo_drop+0x50c/0x57c [nf_tables]
  Read of size 4 at addr ffff8000810e71a4

  This frame has 1 object:
   [32, 160) 'rulemap'

  The buggy address is at offset 164 -- exactly 4 bytes past the end
  of the rulemap array.

Pass 0 instead of rulemap[i + 1].n on the last iteration to avoid
the out-of-bounds read.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index ab5045bf3e599..a2dd1212e0f0d 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1627,6 +1627,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 	int i;
 
 	nft_pipapo_for_each_field(f, i, m) {
+		bool last = i == m->field_count - 1;
 		int g;
 
 		for (g = 0; g < f->groups; g++) {
@@ -1646,7 +1647,7 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 		}
 
 		pipapo_unmap(f->mt, f->rules, rulemap[i].to, rulemap[i].n,
-			     rulemap[i + 1].n, i == m->field_count - 1);
+			     last ? 0 : rulemap[i + 1].n, last);
 		if (pipapo_resize(f, f->rules, f->rules - rulemap[i].n)) {
 			/* We can ignore this, a failure to shrink tables down
 			 * doesn't make tables invalid.
-- 
2.51.0



