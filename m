Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A031F2C45;
	Wed, 23 Apr 2025 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420305; cv=none; b=OjFZPp6cnDrB8um4qjCO72ffnXofKVViJzLewHcPk5EqfBIzj2CgSOaLDnZE2y+TOpP8F9yLBtKT7fQo8+QCuq6ymdycKJjtBrb3jRxIs6CBQ0weFWZkKcIkolCVb10aUCPRo6W8gSndgGR8MB9UJOokmPnMdu012+w9ioDrgcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420305; c=relaxed/simple;
	bh=oPUNRA4N4jjFfIScXoeHJLFGitr9Abt4g1F6aIr8NZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcvNE6cObySFy+uqctMjq3HSDXqfO8VOerO+1wpXdi/C0JWzvURpA1wG8zN/0WWb2uYjgFmK74635cYPS7/AtB8ZB3/3AMQuA3VXfMre1cK5Dv8vHeaVhbVs0JDvf/5+3oDeI+APe6WtIxh5tDV9tkSKiBg+o301XE/6e+RnwrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlz37wj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlz37wj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F70FC4CEE2;
	Wed, 23 Apr 2025 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420305;
	bh=oPUNRA4N4jjFfIScXoeHJLFGitr9Abt4g1F6aIr8NZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlz37wj9njRmph26bOYnPtzYRbWphsUkp4shxiazUGFdE3KxPVU3UOkL1LSu6n7Ei
	 YE3RBL6ACJj2QyR9g2jrLD5/4KuCGH9N9780tdvyaTB2uUDUxE29QLKRk4UISizQ4e
	 JdcBF6CGKv0zUPnH40RUoGu/fVYULnfVPYmnghS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 080/241] netfilter: conntrack: fix erronous removal of offload bit
Date: Wed, 23 Apr 2025 16:42:24 +0200
Message-ID: <20250423142623.855270556@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d2d31ea8cd80b9830cdab624e94f9d41178fc99d ]

The blamed commit exposes a possible issue with flow_offload_teardown():
We might remove the offload bit of a conntrack entry that has been
offloaded again.

1. conntrack entry c1 is offloaded via flow f1 (f1->ct == c1).
2. f1 times out and is pushed back to slowpath, c1 offload bit is
   removed.  Due to bug, f1 is not unlinked from rhashtable right away.
3. a new packet arrives for the flow and re-offload is triggered, i.e.
   f2->ct == c1.  This is because lookup in flowtable skip entries with
   teardown bit set.
4. Next flowtable gc cycle finds f1 again
5. flow_offload_teardown() is called again for f1 and c1 offload bit is
   removed again, even though we have f2 referencing the same entry.

This is harmless, but clearly not correct.
Fix the bug that exposes this: set 'teardown = true' to have the gc
callback unlink the flowtable entry from the table right away instead of
the unintentional defer to the next round.

Also prevent flow_offload_teardown() from fixing up the ct state more than
once: We could also be called from the data path or a notifier, not only
from the flowtable gc callback.

NF_FLOW_TEARDOWN can never be unset, so we can use it as synchronization
point: if we observe did not see a 0 -> 1 transition, then another CPU
is already doing the ct state fixups for us.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9d8361526f82a..9441ac3d8c1a2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -383,8 +383,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow);
+	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		flow_offload_fixup_ct(flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -558,10 +558,12 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_custom_gc(flow_table, flow))
+	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
-	else if (!teardown)
+		teardown = true;
+	} else if (!teardown) {
 		nf_flow_table_extend_ct_timeout(flow->ct);
+	}
 
 	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
-- 
2.39.5



