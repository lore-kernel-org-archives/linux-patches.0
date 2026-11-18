Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037444;
	b=r233xWGzQHtH9AUTVlWlBQeNY3DpJmPjBqwAcMzRUc6diXOViQalSY4KiZXyPubKlwna
	 0yk1wstMvUUkRWRpOv6ouY+kJR5sd1wKGrhdj8ZCUGVFrF691E/6P9SAfmperX0FUYXoT
	 /xxV8m5BaX7nzww1SG2ejMPJyvsRVGQzvHIoo5xWtZT9We1X3S+T4HZWC0Ig8UZLCpXN9
	 7NFjt6+Uv+9SvznVIrINtjrt2N1n5PB8CDoeK4WkWkD62L5mu/PQd4jrfYAZGBND3TWAw
	 r4mnN7WUTXczV/t48tnKE1oF/f+/0NQ2Mjqyc7D6c6HyfvEZ1p5uxSTpGoF7ZN8tZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJ8Bkevb77NteXP5AmQ1eY2C9LLXHOW3Hby4RWlAkQw=;
	b=PMHTewfKCT/kE/kXiLCNT/EFN9I1w4gDiVmF+mwfpil0voIbt2741FPK+xR6w5Hzd143
	 +hMxDaZDo86KiTJEo1AH7e3CTDJYKELhqON8k1FTQoxlYPKB6Qw+I+V99kAQCnqooh6sq
	 B+FDf4sbG1A5GHinicPZsH2QLAx75eUoxs42+X+sqbicQTG7QcQ7RKpPY4k7GmFRSfJ4w
	 Tw17t7T1+IREjwLTsWg8tsOJMc6YfDB0lfagJh+cROdkelwP8afVvCyvMnRhHJ7SPcdXq
	 bhWxsFCV+nRp+jL0gujj/tRSA8buFau4LJ5vrBhh4QAd+oHEWq6lFaensaerEAxe5Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fm51MtzH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B60606A32F;
	Wed, 18 Nov 2026 21:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fm51MtzH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEF51F000C4;
	Wed, 18 Nov 2026 21:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037443;
	bh=jJ8Bkevb77NteXP5AmQ1eY2C9LLXHOW3Hby4RWlAkQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fm51MtzHu9Xnk9PEEuyBiq3Q7wLBIsUle2G0/dVR3Bp4y5yGocrt2aKfrhwlIeR8+
	 Xgynn4chaOniuJHM9gEaTTo4vNWbn2zp33BZoNhxEnVZhW5xvR3cGPQguk4uW3PUR3
	 Oejf37ahAKmVcfVv0fLZHDLiKhmxQbZ557gJL+Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1401/3318] xfrm: retry inexact policy lookup after node reinsertion
Date: Wed, 18 Nov 2026 15:33:43 +0100
Message-ID: <20261118150402.635634833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 868f63c8bfafa9b827168c9126f85264c39c02ec ]

An inexact policy lookup first records pointers to candidate hlist heads
and then traverses the lists.  A concurrent policy insertion can merge
inexact tree nodes between those operations:

  lookup                         policy insertion
  ------                         ----------------
  find inexact candidates
    save obsolete hlist head
                                 write_seqcount_begin(&bin->count)
                                 merge inexact tree nodes
                                   hlist_del_rcu(&policy->bydst)
                                   reinsert policy->bydst in survivor
                                 write_seqcount_end(&bin->count)
  evaluate saved candidate list
    miss the moved policy

The merge immediately reinserts the same hlist node into the surviving
tree node.  RCU keeps the policy alive, but it does not provide a
consistent view while its list node is moved.  A lookup that selected the
obsolete list can observe it empty.  A lookup already traversing a moved
policy can instead follow the next pointer rewritten by the reinsertion.
Either case can return an incorrect IPsec policy result.

The per-bin sequence counter already brackets calls to
xfrm_policy_inexact_insert_node(), including node merges.  The read side,
however, currently validates the counter only while searching an
individual rb-tree.  A successful search returns without validation, and
the later candidate-list traversal is outside that read-side section.

Snapshot the per-bin sequence before discovering candidate heads and
validate it after evaluating all candidate lists.   Retry the lookup if
the inexact policy tree changes while it is being searched.

Fixes: 9cf545ebd591 ("xfrm: policy: store inexact policies in a tree ordered by destination address")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index cc8f4d4b70875..10e07f88882b4 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2182,6 +2182,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	struct xfrm_pol_inexact_bin *bin;
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
+	unsigned int inexact_sequence;
 	unsigned int sequence;
 	int err;
 
@@ -2216,12 +2217,18 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 		goto skip_inexact;
 
 	bin = xfrm_policy_inexact_lookup_rcu(net, type, family, dir, if_id);
-	if (!bin || !xfrm_policy_find_inexact_candidates(&cand, bin, saddr,
-							 daddr))
+	if (!bin)
+		goto skip_inexact;
+
+	inexact_sequence = read_seqcount_begin(&bin->count);
+	if (!xfrm_policy_find_inexact_candidates(&cand, bin, saddr, daddr))
 		goto skip_inexact;
 
 	pol = xfrm_policy_eval_candidates(&cand, ret, fl, type,
 					  family, if_id);
+	if (read_seqcount_retry(&bin->count, inexact_sequence))
+		goto retry;
+
 	if (pol) {
 		ret = pol;
 		if (IS_ERR(pol))
-- 
2.53.0



