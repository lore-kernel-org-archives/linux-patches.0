Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB5934D916;
	Wed, 30 Sep 2026 16:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785545; cv=none; b=KjPGRx7aKTADjadZcxSETEuckRc7jwxN+hY/Ot/rSIMSKxxHy4T5lzxyBr2o7GyIcBIBUBnXAGV/xldzfrMGNTw6OZTMtRLFzK6qiLv4eSk/WZEhTNBNbmwhEy5bROesx8rP2tpkCfETYWEHeHw6VqaV/aBJq6wE9YwPPSmJjnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785545; c=relaxed/simple;
	bh=zZXCHPMbiy8viaPt9reAWXy2Q2iCgJxxHkGGgARsW2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAf63W+2syKjJo63kE6vByAGwriO+WONqICCBk4EucOdyCBrhaiq0MM1nW3+/xh3ton9d6gm6UY2yNNk1ktoEqUPTE7B3ZH0PF0qT8GdCbV1Sv5sY0RXQKmm/njn+tyLPmAFdEzrkJ+Jyof21LmH+rWWGM+v1n40fZbsvjz+0o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXywNjVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXywNjVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E181F00899;
	Wed, 30 Sep 2026 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785534;
	bh=3BM1sHZTPiGidKnFszRnVH51xRXkyVHYVTHjzCU0NrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXywNjVxI9IXVzIZXVTrI/ZcN6rITxF4F8F0yfY5EDHoKtB0NLw5pc1gteF+cGiZz
	 jl8S8u5fswQ16ygLGMKri8h0tYIUV3qfSE5SiRw7059bqpQcnTUKXTN2ug1DHk5gsA
	 0xpwcRXI2CN5vr/jlPq3a7G9VIpCJF6Cj5lnAe+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 498/982] ipv6: fix fib6 walker UAF on seq stop
Date: Wed, 30 Sep 2026 17:20:34 +0200
Message-ID: <20260930152427.478621697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit 19b4ed644d68098cc62ab612727f40d30f43476c upstream.

ipv6_route_iter_active() treats a walker in FWS_U at the table root as
already unlinked. fib6_del_route() can move a still-linked walker into
that same state when the current leaf is the last route at the root,
so ipv6_route_native_seq_stop() skips fib6_walker_unlink(). The seq
private object can then be freed while it remains on
net->ipv6.fib6_walkers. A later route deletion walks the dangling list
and uses the freed walker.

Use the list head as membership state and reinitialize it when
unlinking. Keep the existing w->node check so a never-started iterator
with a zeroed private object is not treated as linked.

The same stop helper is used by /proc/net/ipv6_route and by the BPF
ipv6_route iterator. The BPF show path only widens the race.

Fixes: 8d2ca1d7b5c3 ("ipv6: avoid high order memory allocations for /proc/net/ipv6_route")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/89699735763f6c297584d7c2ff106239cc1e8ce0.1788837093.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -85,7 +85,7 @@ static void fib6_walker_link(struct net
 static void fib6_walker_unlink(struct net *net, struct fib6_walker *w)
 {
 	write_lock_bh(&net->ipv6.fib6_walker_lock);
-	list_del(&w->lh);
+	list_del_init(&w->lh);
 	write_unlock_bh(&net->ipv6.fib6_walker_lock);
 }
 
@@ -2650,7 +2650,7 @@ static void *ipv6_route_seq_start(struct
 static bool ipv6_route_iter_active(struct ipv6_route_iter *iter)
 {
 	struct fib6_walker *w = &iter->w;
-	return w->node && !(w->state == FWS_U && w->node == w->root);
+	return w->node && !list_empty(&w->lh);
 }
 
 static void ipv6_route_native_seq_stop(struct seq_file *seq, void *v)


