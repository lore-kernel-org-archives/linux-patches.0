Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E666B288CA7;
	Tue, 22 Jul 2025 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193648; cv=none; b=pFkkVQpZeFRoQ4LlxTBhqq67lq+KV5Ei3Mc3biwwLhf5tCifjMSLG4BQP+dnETPc7hw22XWcTglTeWHj+eJHUil9RVejszGhXwv5qeLmSRmIsLntMnEWYKVK9dwX7uEsaMFa+jbQbMs9vPi21iVkOniSaxZbvtZZk461jobNSEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193648; c=relaxed/simple;
	bh=iVArfT0iChFfFS7gcVObb6vPdBRs1NMYdpKNAONxATo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzBmasM/nNc25tjEz6QGBa3NJgsV0347d86JZFwba8fEJJe8Ql7Lb1nfO5TnD0LEeSkjJZU3+mA1mgBdTF+t4iFNKz9CDs4CFe+mXX5elhuve+9/qvfdhMJbNwmiHMGxvbzVo8Czka/hBGMsSxso4m8+xq5woCHyfdBk4FEPppU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt2UuHgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt2UuHgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5497CC4CEEB;
	Tue, 22 Jul 2025 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193647;
	bh=iVArfT0iChFfFS7gcVObb6vPdBRs1NMYdpKNAONxATo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt2UuHgPOMAoSn0do/+Np7Yb1VoNHI9m2OPz2bneK75+f191Hk2acO/88hA6FHls2
	 ItStI/c6rK3riUDWZOZSTVZaXC7VmsMfLTOYhe8407aad1b7W3/rbNqDEwf6CXr9ao
	 i1RNELtgyaYyXLbSaR2vYg+jymd47teXQ5Trg404=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 156/187] rxrpc: Fix irq-disabled in local_bh_enable()
Date: Tue, 22 Jul 2025 15:45:26 +0200
Message-ID: <20250722134351.591995286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit e4d2878369d590bf8455e3678a644e503172eafa ]

The rxrpc_assess_MTU_size() function calls down into the IP layer to find
out the MTU size for a route.  When accepting an incoming call, this is
called from rxrpc_new_incoming_call() which holds interrupts disabled
across the code that calls down to it.  Unfortunately, the IP layer uses
local_bh_enable() which, config dependent, throws a warning if IRQs are
enabled:

WARNING: CPU: 1 PID: 5544 at kernel/softirq.c:387 __local_bh_enable_ip+0x43/0xd0
...
RIP: 0010:__local_bh_enable_ip+0x43/0xd0
...
Call Trace:
 <TASK>
 rt_cache_route+0x7e/0xa0
 rt_set_nexthop.isra.0+0x3b3/0x3f0
 __mkroute_output+0x43a/0x460
 ip_route_output_key_hash+0xf7/0x140
 ip_route_output_flow+0x1b/0x90
 rxrpc_assess_MTU_size.isra.0+0x2a0/0x590
 rxrpc_new_incoming_peer+0x46/0x120
 rxrpc_alloc_incoming_call+0x1b1/0x400
 rxrpc_new_incoming_call+0x1da/0x5e0
 rxrpc_input_packet+0x827/0x900
 rxrpc_io_thread+0x403/0xb60
 kthread+0x2f7/0x310
 ret_from_fork+0x2a/0x230
 ret_from_fork_asm+0x1a/0x30
...
hardirqs last  enabled at (23): _raw_spin_unlock_irq+0x24/0x50
hardirqs last disabled at (24): _raw_read_lock_irq+0x17/0x70
softirqs last  enabled at (0): copy_process+0xc61/0x2730
softirqs last disabled at (25): rt_add_uncached_list+0x3c/0x90

Fix this by moving the call to rxrpc_assess_MTU_size() out of
rxrpc_init_peer() and further up the stack where it can be done without
interrupts disabled.

It shouldn't be a problem for rxrpc_new_incoming_call() to do it after the
locks are dropped as pmtud is going to be performed by the I/O thread - and
we're in the I/O thread at this point.

Fixes: a2ea9a907260 ("rxrpc: Use irq-disabling spinlocks between app and I/O thread")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250717074350.3767366-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h | 1 +
 net/rxrpc/call_accept.c | 1 +
 net/rxrpc/peer_object.c | 6 ++----
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 3cc3af15086ff..b2d64586958fb 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1315,6 +1315,7 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *,
 					 const struct sockaddr_rxrpc *);
 struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_local *local,
 				     struct sockaddr_rxrpc *srx, gfp_t gfp);
+void rxrpc_assess_MTU_size(struct rxrpc_local *local, struct rxrpc_peer *peer);
 struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *, gfp_t,
 				    enum rxrpc_peer_trace);
 void rxrpc_new_incoming_peer(struct rxrpc_local *local, struct rxrpc_peer *peer);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 0b51f3ccf0358..bbed314b7d963 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -404,6 +404,7 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 
 	spin_unlock(&rx->incoming_lock);
 	read_unlock_irq(&local->services_lock);
+	rxrpc_assess_MTU_size(local, call->peer);
 
 	if (hlist_unhashed(&call->error_link)) {
 		spin_lock_irq(&call->peer->lock);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 71b6e07bf1616..7df8d984a96ac 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -149,8 +149,7 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *local,
  * assess the MTU size for the network interface through which this peer is
  * reached
  */
-static void rxrpc_assess_MTU_size(struct rxrpc_local *local,
-				  struct rxrpc_peer *peer)
+void rxrpc_assess_MTU_size(struct rxrpc_local *local, struct rxrpc_peer *peer)
 {
 	struct net *net = local->net;
 	struct dst_entry *dst;
@@ -277,8 +276,6 @@ static void rxrpc_init_peer(struct rxrpc_local *local, struct rxrpc_peer *peer,
 
 	peer->hdrsize += sizeof(struct rxrpc_wire_header);
 	peer->max_data = peer->if_mtu - peer->hdrsize;
-
-	rxrpc_assess_MTU_size(local, peer);
 }
 
 /*
@@ -297,6 +294,7 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_local *local,
 	if (peer) {
 		memcpy(&peer->srx, srx, sizeof(*srx));
 		rxrpc_init_peer(local, peer, hash_key);
+		rxrpc_assess_MTU_size(local, peer);
 	}
 
 	_leave(" = %p", peer);
-- 
2.39.5



