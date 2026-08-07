Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05C231327A;
	Fri,  7 Aug 2026 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116446; cv=none; b=R0OKoT17vYiz2L/J9Inn3J+kXAWe3VwYO7/vDSecOChl2vi8Bm9bg8TfKtJOt8iy2w40JvrL30IcSHKU86ElfznjlblRN88seHiIh5efUKUBZnWg2oMLqy/1r//y9jkoWERmczaNorl1HqDrCgudVO4cNTqPDXmcrjOvac2HvJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116446; c=relaxed/simple;
	bh=Bt2TevpbwaC+9fRxTN6so/Lu0YgUEVtm7cRHkzPC2Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcpuiK5qWVBt4sBpEoTAi9AnU5bXZzhMJOYWmmuoF6hNL4EujY07HpkvUvxOcm4A8KdApA2ceNizMiAurqX9jpYjFF2IfFs84AiUvUHFO0BxfiJbDow1pQ3XPSmFSYliolrxirAg/KJBLRrZoTZoWQq8oaoYCCuJfWLkXyaQlMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viEKzgJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viEKzgJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEDD1F000E9;
	Fri,  7 Aug 2026 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116444;
	bh=1Nft9/DNh942atR3b1V0K2M0/WsgF+ZLyUwLmbCger8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viEKzgJ9Yneq547+rhPVJ2wHAnE7NR5qlx3NiO02wMzOWgAAfsVaEFQs/Yi6ieKO3
	 mBYSOHBlbv1Lsr2oL5SnIDXaTX6G0d+6iGMBxMOseead6yF6TYZTVVA1WgrNGQwufk
	 IYTLY3SDjumnPjbz+fhFn8GgbZ5yPwf9ZXaJvJs4=
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
Subject: [PATCH 6.6 234/261] rxrpc: Fix irq-disabled in local_bh_enable()
Date: Fri,  7 Aug 2026 16:39:51 +0200
Message-ID: <20260807143420.426507157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ moved `peer->mtu`/`peer->maxdata` derivation into `rxrpc_assess_MTU_size()` at both exits since 6.12 predates the `max_data` rework ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/call_accept.c |    1 +
 net/rxrpc/peer_object.c |   12 +++++++-----
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1188,6 +1188,7 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu
 					 const struct sockaddr_rxrpc *);
 struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_local *local,
 				     struct sockaddr_rxrpc *srx, gfp_t gfp);
+void rxrpc_assess_MTU_size(struct rxrpc_local *local, struct rxrpc_peer *peer);
 struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *, gfp_t,
 				    enum rxrpc_peer_trace);
 void rxrpc_new_incoming_peer(struct rxrpc_local *local, struct rxrpc_peer *peer);
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -407,6 +407,7 @@ bool rxrpc_new_incoming_call(struct rxrp
 
 	spin_unlock(&rx->incoming_lock);
 	read_unlock_irq(&local->services_lock);
+	rxrpc_assess_MTU_size(local, call->peer);
 
 	if (hlist_unhashed(&call->error_link)) {
 		spin_lock_irq(&call->peer->lock);
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -147,8 +147,7 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu
  * assess the MTU size for the network interface through which this peer is
  * reached
  */
-static void rxrpc_assess_MTU_size(struct rxrpc_local *local,
-				  struct rxrpc_peer *peer)
+void rxrpc_assess_MTU_size(struct rxrpc_local *local, struct rxrpc_peer *peer)
 {
 	struct net *net = local->net;
 	struct dst_entry *dst;
@@ -160,6 +159,8 @@ static void rxrpc_assess_MTU_size(struct
 #endif
 
 	peer->if_mtu = 1500;
+	peer->mtu = peer->if_mtu;
+	peer->maxdata = peer->mtu - peer->hdrsize;
 
 	memset(&fl, 0, sizeof(fl));
 	switch (peer->srx.transport.family) {
@@ -199,6 +200,9 @@ static void rxrpc_assess_MTU_size(struct
 	peer->if_mtu = dst_mtu(dst);
 	dst_release(dst);
 
+	peer->mtu = peer->if_mtu;
+	peer->maxdata = peer->mtu - peer->hdrsize;
+
 	_leave(" [if_mtu %u]", peer->if_mtu);
 }
 
@@ -240,8 +244,6 @@ static void rxrpc_init_peer(struct rxrpc
 			    unsigned long hash_key)
 {
 	peer->hash_key = hash_key;
-	rxrpc_assess_MTU_size(local, peer);
-	peer->mtu = peer->if_mtu;
 	peer->rtt_last_req = ktime_get_real();
 
 	switch (peer->srx.transport.family) {
@@ -266,7 +268,6 @@ static void rxrpc_init_peer(struct rxrpc
 	}
 
 	peer->hdrsize += sizeof(struct rxrpc_wire_header);
-	peer->maxdata = peer->mtu - peer->hdrsize;
 }
 
 /*
@@ -285,6 +286,7 @@ static struct rxrpc_peer *rxrpc_create_p
 	if (peer) {
 		memcpy(&peer->srx, srx, sizeof(*srx));
 		rxrpc_init_peer(local, peer, hash_key);
+		rxrpc_assess_MTU_size(local, peer);
 	}
 
 	_leave(" = %p", peer);


