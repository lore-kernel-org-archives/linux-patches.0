Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21B441A8F;
	Sat, 30 May 2026 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166218; cv=none; b=qoX1d/63+/EvdGgJkSu7mYycGVz2dBbFKW3RUur+yP6oQRANRxk+1bQSBr/IzqwisHRw0SP2r3kpFS4TxOKciKPezBx7MuHgs6lII9jogzNx/5hzfkyMYeH8UnDfvhEmrqM/opp9/qVtTSuWbub2vmEbGuGNJNwSWkx7EJ2L4aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166218; c=relaxed/simple;
	bh=3yUaBhzFmKRaS4XovfVQSpUCDbHLZi/F50V+LDS2HT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlaiiSjGYQZnfjeu2Tk33soHEQxxhwxftQukyU0qNxg2HSNRkkK+yrs2OxFaAhV2+F7BOFf1HwG24CW2mNn9xcrQ5OML4nnhxR51RVZBH/j1T2G6oIt2REl28+BybogxxqH3SOJl/GiSd0yNXAFyhzk634jS2JXa6anMx5UAY5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aq2D1K5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aq2D1K5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A361F00893;
	Sat, 30 May 2026 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166217;
	bh=pPFF9mq1y8kCNqx+gAhapINshDssy519HE0IKGCyamQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aq2D1K5yE68XOmJ0UUu+gpsMPA/L+1UPRAYxmIPfOKQkPU4KpAw0Ktv1Baez+LAXz
	 gKHx2gQL9J2ekEUwjvaWDusuL1sX1T5nqxysMJC2VrY203AG6FF5u8XysajknFbOZM
	 cQQHLuETN88fOS3nBUzRKRZMCbGa5uBVU+0YwnXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/589] netfilter: nft_fwd_netdev: check ttl/hl before forwarding
Date: Sat, 30 May 2026 18:03:08 +0200
Message-ID: <20260530160233.022783643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1dfd95bdf4d18d263aa8fad06bfb9f4d9c992b18 ]

Drop packets if their ttl/hl is too small for forwarding.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_fwd_netdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 7730409f6f091..09aff403884b5 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -113,6 +113,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			goto out;
 		}
 		iph = ip_hdr(skb);
+		if (iph->ttl <= 1) {
+			verdict = NF_DROP;
+			goto out;
+		}
+
 		ip_decrease_ttl(iph);
 		neigh_table = NEIGH_ARP_TABLE;
 		break;
@@ -129,6 +134,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			goto out;
 		}
 		ip6h = ipv6_hdr(skb);
+		if (ip6h->hop_limit <= 1) {
+			verdict = NF_DROP;
+			goto out;
+		}
+
 		ip6h->hop_limit--;
 		neigh_table = NEIGH_ND_TABLE;
 		break;
-- 
2.53.0



