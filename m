Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B05816423;
	Tue, 27 Feb 2024 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043096; cv=none; b=LvKauDXEaWqbpgCGAsWRYqFwskjY4R2WuMBhyKf9kFQYtDvl1ls5dYeRmf96R8JL9fgDEV0JLvW7Y8Jz1FUrdtjsiVJ5dsggODxYBo6eE6JMrPt+tHImlRkcaRWYDb2UTn3SO0AZ3uWKuqM3lgX3FWvg+6mCl30S4+KhOwA/SFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043096; c=relaxed/simple;
	bh=iNNEBRq+hAS96Am5yEDW/J/4Hag9SQnvQiso5a+wV70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoD7dU9oWP8LzNv47UBIVKPfPq/lg1eDUbw+rwhqWMNBXFkbPMTm6aBUY0e2J36rIgVOzBlmlb46uRY0Z/knUGSkTlSVCf3pu8N8So9qzHZi08ABjx3DAjtV7FgJh0gcRPaIwhIRnMusFu2pWfzXrdeZuTM5z0p/zq/uXSYD044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCTMxeuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCTMxeuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED735C433F1;
	Tue, 27 Feb 2024 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043096;
	bh=iNNEBRq+hAS96Am5yEDW/J/4Hag9SQnvQiso5a+wV70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCTMxeuBrJmDzgcnX06OXprYsc818quq7XFqJ50SGvN0en5yPDb0JwffNwwoFNaCf
	 Z/+GxFcuzMt59LVk56c/TBpPmSZZSg0pq+bEAxuYdPRW7M7QaJgs+S3wesfIVeMOSb
	 GYe6FKgVmdn6d1BdDCx5I8pVYCpokzeF9titNk4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/245] netfilter: flowtable: simplify route logic
Date: Tue, 27 Feb 2024 14:27:00 +0100
Message-ID: <20240227131622.719111928@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit fa502c86566680ac62bc28ec883a069bf7a2aa5e ]

Grab reference to dst from skbuff earlier to simplify route caching.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 9e0f0430389b ("netfilter: nft_flow_offload: reset dst in route object after setting up flow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  4 ++--
 net/netfilter/nf_flow_table_core.c    | 24 +++---------------------
 net/netfilter/nft_flow_offload.c      | 12 ++++++++----
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index aaa518e777e9e..7677aacf72002 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -257,8 +257,8 @@ nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 	up_write(&flow_table->flow_block_lock);
 }
 
-int flow_offload_route_init(struct flow_offload *flow,
-			    const struct nf_flow_route *route);
+void flow_offload_route_init(struct flow_offload *flow,
+			     const struct nf_flow_route *route);
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4f61eb1282834..4e0a2d47f6a6b 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -124,9 +124,6 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-		if (!dst_hold_safe(route->tuple[dir].dst))
-			return -1;
-
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
@@ -147,27 +144,12 @@ static void nft_flow_dst_release(struct flow_offload *flow,
 		dst_release(flow->tuplehash[dir].tuple.dst_cache);
 }
 
-int flow_offload_route_init(struct flow_offload *flow,
+void flow_offload_route_init(struct flow_offload *flow,
 			    const struct nf_flow_route *route)
 {
-	int err;
-
-	err = flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
-	if (err < 0)
-		return err;
-
-	err = flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
-	if (err < 0)
-		goto err_route_reply;
-
+	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
 	flow->type = NF_FLOW_OFFLOAD_ROUTE;
-
-	return 0;
-
-err_route_reply:
-	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
-
-	return err;
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index f8346497c9b49..fbb9f3a6c8444 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -240,9 +240,14 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 		break;
 	}
 
+	if (!dst_hold_safe(this_dst))
+		return -ENOENT;
+
 	nf_route(nft_net(pkt), &other_dst, &fl, false, nft_pf(pkt));
-	if (!other_dst)
+	if (!other_dst) {
+		dst_release(this_dst);
 		return -ENOENT;
+	}
 
 	nft_default_forward_path(route, this_dst, dir);
 	nft_default_forward_path(route, other_dst, !dir);
@@ -326,8 +331,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (!flow)
 		goto err_flow_alloc;
 
-	if (flow_offload_route_init(flow, &route) < 0)
-		goto err_flow_add;
+	flow_offload_route_init(flow, &route);
 
 	if (tcph) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
@@ -338,12 +342,12 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
-	dst_release(route.tuple[!dir].dst);
 	return;
 
 err_flow_add:
 	flow_offload_free(flow);
 err_flow_alloc:
+	dst_release(route.tuple[dir].dst);
 	dst_release(route.tuple[!dir].dst);
 err_flow_route:
 	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
-- 
2.43.0



