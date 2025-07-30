Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D5A255F5C;
	Wed, 30 Jul 2025 09:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869038; cv=none; b=ql2yH5/YDUEadmrJYF2lPdkhCK/KIxWFRYACOZE9zEwUYw1m8yBtWZ5MolKU3525qP90vNmVwGFfquKDUvehxUEXKO094vR7UeVIp5s65oB1B4dlzx1N+YcdnRvCnv5AoY6oEUQL1KzCup36RIMediI4ptn4MGwiHIITDsVbwHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869038; c=relaxed/simple;
	bh=kd9pM9xsgil9mB+f1RhC8Q/PQVpymwCO0CNPjbqYPpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaJ0cTHNmSssqeeac0ai3BtKqH02u2pVW1dObmZu0byIAGogsvam1wY/ApyBOZ4SqGc+oMZGIC4otEPqK7mPnSmNRhxFc7NA7dknUdqstyJhCmoLITov/HyydBOF7/IVEvqwfSEDY/RaLKtM2tuH7sT5hJ7m70OC1cwfvhobzks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FibU/3Ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FibU/3Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250E9C4CEF5;
	Wed, 30 Jul 2025 09:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869036;
	bh=kd9pM9xsgil9mB+f1RhC8Q/PQVpymwCO0CNPjbqYPpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FibU/3Ir9eiZTBZ8Qz3XoyM1Rhxshp+DatP9coKronv6aULoLXqCoeqQ3Ax9nIN5z
	 6SByZSPVyoVutY/RoDXqXx/iTCJntDLChQxLJOxpr1GI9BwiOJ3IdWRYa94UHdQ8cv
	 hTyLesWg1V/iO/qYw9xCdwPNvLWJHfkYNIrIUfeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 21/92] xfrm: state: use a consistent pcpu_id in xfrm_state_find
Date: Wed, 30 Jul 2025 11:35:29 +0200
Message-ID: <20250730093231.432118434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 7eb11c0ab70777b9e5145a5ba1c0a2312c3980b2 ]

If we get preempted during xfrm_state_find, we could run
xfrm_state_look_at using a different pcpu_id than the one
xfrm_state_find saw. This could lead to ignoring states that should
have matched, and triggering acquires on a CPU that already has a pcpu
state.

    xfrm_state_find starts on CPU1
    pcpu_id = 1
    lookup starts
    <preemption, we're now on CPU2>
    xfrm_state_look_at pcpu_id = 2
       finds a state
found:
    best->pcpu_num != pcpu_id (2 != 1)
    if (!x && !error && !acquire_in_progress) {
        ...
        xfrm_state_alloc
        xfrm_init_tempstate
        ...

This can be avoided by passing the original pcpu_id down to all
xfrm_state_look_at() calls.

Also switch to raw_smp_processor_id, disabling preempting just to
re-enable it immediately doesn't really make sense.

Fixes: 1ddf9916ac09 ("xfrm: Add support for per cpu xfrm state handling.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index a5a3bf25fd1d4..cef8d3c20f652 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1307,14 +1307,8 @@ static void xfrm_hash_grow_check(struct net *net, int have_hash_collision)
 static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 			       const struct flowi *fl, unsigned short family,
 			       struct xfrm_state **best, int *acq_in_progress,
-			       int *error)
+			       int *error, unsigned int pcpu_id)
 {
-	/* We need the cpu id just as a lookup key,
-	 * we don't require it to be stable.
-	 */
-	unsigned int pcpu_id = get_cpu();
-	put_cpu();
-
 	/* Resolution logic:
 	 * 1. There is a valid state with matching selector. Done.
 	 * 2. Valid state with inappropriate selector. Skip.
@@ -1381,8 +1375,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	/* We need the cpu id just as a lookup key,
 	 * we don't require it to be stable.
 	 */
-	pcpu_id = get_cpu();
-	put_cpu();
+	pcpu_id = raw_smp_processor_id();
 
 	to_put = NULL;
 
@@ -1402,7 +1395,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
 			xfrm_state_look_at(pol, x, fl, encap_family,
-					   &best, &acquire_in_progress, &error);
+					   &best, &acquire_in_progress, &error, pcpu_id);
 	}
 
 	if (best)
@@ -1419,7 +1412,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
 			xfrm_state_look_at(pol, x, fl, family,
-					   &best, &acquire_in_progress, &error);
+					   &best, &acquire_in_progress, &error, pcpu_id);
 	}
 
 cached:
@@ -1460,7 +1453,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
 			xfrm_state_look_at(pol, x, fl, family,
-					   &best, &acquire_in_progress, &error);
+					   &best, &acquire_in_progress, &error, pcpu_id);
 	}
 	if (best || acquire_in_progress)
 		goto found;
@@ -1495,7 +1488,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		    tmpl->id.proto == x->id.proto &&
 		    (tmpl->id.spi == x->id.spi || !tmpl->id.spi))
 			xfrm_state_look_at(pol, x, fl, family,
-					   &best, &acquire_in_progress, &error);
+					   &best, &acquire_in_progress, &error, pcpu_id);
 	}
 
 found:
-- 
2.39.5



