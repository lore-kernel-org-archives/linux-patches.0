Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D861A23B61B;
	Tue, 13 Oct 2026 12:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894843; cv=none; b=WhWAeozBidSmb1hwjWu44so946z01RgNdAgnevmfVnmFWJwpGX1nn8orClLzNvLF3kOPgMQE9xJOGoHsEPHgRpdWllWcge63+KWUPNPeKlRdQKf2sBefATZ0k043HwPDaVarAFJTnz12cOwar/pH0eiRgD/FRz2vl0iVSFYuUnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894843; c=relaxed/simple;
	bh=Ma5QHdEy7PCzvdgjYhjmFSdYWKmmiVSp4FE6ra+yDe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra1o0yBc+3lFSkJn7BFJ5uvQaAXDOK88rac0dCFKyjupvslmPqDVo6qZLpC3j8GHy31yErVbwL3gwCWeJYSOuFxdP7fLnDiK32mhHTY9ysaVIXpaoYh9oG/aEPjEBUBSPk+dcgCQRbNuN/lPbb51d2GKmOyr1fMyhHhV9sk6/K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxHx9Y7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxHx9Y7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299651F000FF;
	Tue, 13 Oct 2026 12:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894842;
	bh=SbaPLRqGnsuieUduuetmGzuD86ifdszTwmwHWD4E83I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxHx9Y7iBmh5xJ8aGooLzWCnMVcmmPk5JAq12FL1jYezaufc19MSP522/tp5L0cuA
	 b2LRJU+iayK+d4bI4i5MAeoQ2pDnLgywhJ15VXGsLTR2Z+nvxQd692pLnr7NtMkih5
	 cEZu9mfP/zUNh8izh3IIBa5JGDqH7nWNwwOBwCZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/497] netfilter: ipset: do not update comments from kernel-side adds
Date: Tue, 13 Oct 2026 13:34:01 +0200
Message-ID: <20261013112909.644043250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a442c8a89fb9c531f9d6ab86120c31decd778d51 ]

'Fixes' commit stopped calling ip_set_init_comment() for hash types
from kernel-side-adds (xtables .. -j SET).  ip_set_init_comment() says:

   "The kadt functions don't use the comment extensions in any way."

But bitmap set type calls the function from kadt cb too.

While this appears to be safe (serialized via the set spinlock), it seems
better to not call the init function either, least of all to keep
behaviour consistent.

ip_set_list calls ip_set_init_comment() only from uadt cb, it can be
kept as-is.

This was triggered by yet another LLM review, hinting that the existing
rcu_dereference_protected() cannot be downgraded to only check if the
nfnl mutex is held.

Fixes: f30415929be8 ("netfilter: ipset: do not update comments from kernel-side hash adds")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index e6a092cea011e..edbba3b5752cc 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -159,7 +159,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(x, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
-- 
2.53.0



