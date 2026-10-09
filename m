Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3052455631;
	Fri,  9 Oct 2026 14:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555651; cv=none; b=A4Fj+As6/Q7/GOPiknfHDDV571RxWrlwD91Z1Qd7mHKyCWhnFzhDDd6xXu5/DPdL8egfSdtt+EZ8nvzxWDq6ixFWjYYA7WiPvPFGN7iJq6sip2+LrqZ+8GncC/N0+0fE9ECBUxngVMs989Qh7D2Dw+PxOS6x/KN5jZIXiDiUKBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555651; c=relaxed/simple;
	bh=GejjRg8wfG/EiA84LH7JZBBNvyZtN58WyEidQJcfZ2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMF9XytPPuPBmr+cSZ9Fhzq9YCRrxYCiyQMOVzoi/i9J6/QekxSosiIlbdOswL1l4qH574wKaXFgyRr+LjP0Z4vg/BxJV9RFeqXGK8nfHN0EkAg4Jq4pejyccPzJwhrWzkZMP/qCXpJFn280nItEBCVilhpWx2z10Qfo/4KXQIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D1AQO12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D1AQO12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09471F0089A;
	Fri,  9 Oct 2026 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555648;
	bh=lO03o/lmQh3hZKZZATjD/UaJIH+XssnNpNjT1GaULRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1D1AQO12uI+ovoLBEG8k/nABovZQTFr01ipiF4ZYVX5UHNSGm8zZDU6RJZUGuuuOo
	 sZo88PFfj/PeQQG6bct2j9otHX4v8XPvSSDQD3vhf5zE/HK3k5+Ctjx9fn80kKp7LM
	 AJaHVVhmtDEoQ4YXxq2s8WTBdzzDdZ3pGdIwG3Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/403] netfilter: ipset: do not update comments from kernel-side adds
Date: Fri,  9 Oct 2026 16:07:34 +0200
Message-ID: <20261009140954.264774025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ca1119f651efd..25278f44ed2a9 100644
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



