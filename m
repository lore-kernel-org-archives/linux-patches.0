Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0608D3BCD33;
	Tue, 21 Jul 2026 21:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668342; cv=none; b=WpItG4vXJDvvA3sypoGZXtIqszMDE4k0cSeI6AjCTQMtaLik5wwCPF2YvQxY6DYJlhWI/cp1n4FoW8+9UEhgXNIlEij2JO5pPiRlTB53r2gd80kVQnOECGKCuG8S1YP0KwIPscagzt/yfoP56YLxm4K0up0i0TWJQ3X8fAs6Xx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668342; c=relaxed/simple;
	bh=/6EfoBqdEK8BITmzat7tY41a4PX12rwUvZb55F1+5Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRQUYOlE5TwPUW6V941PyeXPKTBFhK1FJ6V8L2zF3gQaUdLP1SczrxILOEFcvwO7b+4Ypx1/PW0vKofArTki9xiMyAPXr3R+lDMqA+Hrh5T/dU2Uzh7J6yxSXZmK5XNNaxs1HxPosjyYa90aiyeR63JcrMzh2ehaQjNERtNNxJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRcX1rj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRcX1rj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EF11F000E9;
	Tue, 21 Jul 2026 21:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668340;
	bh=UG/MNPevsHTrvFLd9mcVXJ73OW4SYLP4kUCbl/TyUm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRcX1rj+NfG1vH8t6mLPoAxoy+Mg8apaXUhh6eM74txFHxd+89OVLPhLoK8Rts+S8
	 99DZ4J5xr314wGmKxKWs13WETxFBH66zztcRBW3syvRis4KF6I9YvKTs7EbRMRC0Bo
	 2PSDESaq7TlTWLW4sSLN5WS0vrhBuA3Cgjn/3AUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0102/1067] tipc: fix out-of-bounds read in broadcast Gap ACK blocks
Date: Tue, 21 Jul 2026 17:11:43 +0200
Message-ID: <20260721152426.870806985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Samuel Page <sam@bynar.io>

commit 2b66974a1b6134a4bbc3bfed181f7418f688eb54 upstream.

A broadcast PROTOCOL/STATE_MSG can carry a Gap ACK blocks record in its
data area. tipc_get_gap_ack_blks() only verifies that the record's len
field is self-consistent with its ugack_cnt/bgack_cnt counts
(sz == struct_size(p, gacks, ugack_cnt + bgack_cnt)); it does not check
that the record actually fits in the message data area, msg_data_sz().

The unicast caller tipc_link_proto_rcv() bounds it ("if (glen > dlen)
break;"), but the broadcast caller tipc_bcast_sync_rcv() discards the
returned size, so tipc_link_advance_transmq() copies the record off the
receive skb with an attacker-controlled count:

	this_ga = kmemdup(ga, struct_size(ga, gacks, ga->bgack_cnt),
			  GFP_ATOMIC);

A TIPC neighbour that negotiated TIPC_GAP_ACK_BLOCK triggers it with one
ordinary broadcast STATE_MSG (msg_bc_ack_invalid() clear), sized so its
data area is short, carrying a Gap ACK record with len = 0x400,
bgack_cnt = 0xff and ugack_cnt = 0. len then equals
struct_size(p, gacks, 255), so the consistency check passes and ga is
non-NULL; kmemdup() reads struct_size(ga, gacks, 255) = 1024 bytes out
of the much smaller skb:

  BUG: KASAN: slab-out-of-bounds in kmemdup_noprof+0x48/0x60
  Read of size 1024 at addr ffff0000c7030d38 by task poc864/69
  Call trace:
   kmemdup_noprof+0x48/0x60
   tipc_link_advance_transmq+0x86c/0xb80
   tipc_link_bc_ack_rcv+0x19c/0x1e0
   tipc_bcast_sync_rcv+0x1c4/0x2c4
   tipc_rcv+0x85c/0x1340
   tipc_l2_rcv_msg+0xac/0x104
  The buggy address belongs to the object at ffff0000c7030d00
   which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 56 bytes inside of
   allocated 704-byte region [ffff0000c7030d00, ffff0000c7030fc0)

The copied-out bytes are subsequently consumed as gap/ack values, but
the read is already out of bounds at the kmemdup() regardless of how
they are used.

The unicast STATE path drops such a message: "if (glen > dlen) break;"
skips the rest of STATE_MSG handling and the skb is freed. Make the
broadcast path drop it too. tipc_bcast_sync_rcv() now bounds the record
against msg_data_sz() and, when it does not fit, reports it back through
tipc_node_bc_sync_rcv() to tipc_rcv() so the skb is discarded rather than
processed. ga is not cleared on this path: ga == NULL already means
"legacy peer without Selective ACK", a distinct legitimate state.

Fixes: d7626b5acff9 ("tipc: introduce Gap ACK blocks for broadcast link")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Page <sam@bynar.io>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260625143815.1525412-1-sam@bynar.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/bcast.c |   22 ++++++++++++++--------
 net/tipc/bcast.h |    2 +-
 net/tipc/node.c  |   15 ++++++++++++---
 3 files changed, 27 insertions(+), 12 deletions(-)

--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -497,12 +497,13 @@ void tipc_bcast_ack_rcv(struct net *net,
  */
 int tipc_bcast_sync_rcv(struct net *net, struct tipc_link *l,
 			struct tipc_msg *hdr,
-			struct sk_buff_head *retrq)
+			struct sk_buff_head *retrq, bool *valid)
 {
 	struct sk_buff_head *inputq = &tipc_bc_base(net)->inputq;
 	struct tipc_gap_ack_blks *ga;
 	struct sk_buff_head xmitq;
 	int rc = 0;
+	u16 glen;
 
 	__skb_queue_head_init(&xmitq);
 
@@ -510,13 +511,18 @@ int tipc_bcast_sync_rcv(struct net *net,
 	if (msg_type(hdr) != STATE_MSG) {
 		tipc_link_bc_init_rcv(l, hdr);
 	} else if (!msg_bc_ack_invalid(hdr)) {
-		tipc_get_gap_ack_blks(&ga, l, hdr, false);
-		if (!sysctl_tipc_bc_retruni)
-			retrq = &xmitq;
-		rc = tipc_link_bc_ack_rcv(l, msg_bcast_ack(hdr),
-					  msg_bc_gap(hdr), ga, &xmitq,
-					  retrq);
-		rc |= tipc_link_bc_sync_rcv(l, hdr, &xmitq);
+		glen = tipc_get_gap_ack_blks(&ga, l, hdr, false);
+		if (glen > msg_data_sz(hdr)) {
+			/* Malformed Gap ACK blocks; caller drops the msg */
+			*valid = false;
+		} else {
+			if (!sysctl_tipc_bc_retruni)
+				retrq = &xmitq;
+			rc = tipc_link_bc_ack_rcv(l, msg_bcast_ack(hdr),
+						  msg_bc_gap(hdr), ga, &xmitq,
+						  retrq);
+			rc |= tipc_link_bc_sync_rcv(l, hdr, &xmitq);
+		}
 	}
 	tipc_bcast_unlock(net);
 
--- a/net/tipc/bcast.h
+++ b/net/tipc/bcast.h
@@ -97,7 +97,7 @@ void tipc_bcast_ack_rcv(struct net *net,
 			struct tipc_msg *hdr);
 int tipc_bcast_sync_rcv(struct net *net, struct tipc_link *l,
 			struct tipc_msg *hdr,
-			struct sk_buff_head *retrq);
+			struct sk_buff_head *retrq, bool *valid);
 int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg,
 			struct tipc_link *bcl);
 int tipc_nl_bc_link_set(struct net *net, struct nlattr *attrs[]);
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1833,12 +1833,15 @@ static void tipc_node_mcast_rcv(struct t
 }
 
 static void tipc_node_bc_sync_rcv(struct tipc_node *n, struct tipc_msg *hdr,
-				  int bearer_id, struct sk_buff_head *xmitq)
+				  int bearer_id, struct sk_buff_head *xmitq,
+				  bool *valid)
 {
 	struct tipc_link *ucl;
 	int rc;
 
-	rc = tipc_bcast_sync_rcv(n->net, n->bc_entry.link, hdr, xmitq);
+	rc = tipc_bcast_sync_rcv(n->net, n->bc_entry.link, hdr, xmitq, valid);
+	if (!*valid)
+		return;
 
 	if (rc & TIPC_LINK_DOWN_EVT) {
 		tipc_node_reset_links(n);
@@ -2142,12 +2145,18 @@ rcv:
 
 	/* Ensure broadcast reception is in synch with peer's send state */
 	if (unlikely(usr == LINK_PROTOCOL)) {
+		bool valid = true;
+
 		if (unlikely(skb_linearize(skb))) {
 			tipc_node_put(n);
 			goto discard;
 		}
 		hdr = buf_msg(skb);
-		tipc_node_bc_sync_rcv(n, hdr, bearer_id, &xmitq);
+		tipc_node_bc_sync_rcv(n, hdr, bearer_id, &xmitq, &valid);
+		if (!valid) {
+			tipc_node_put(n);
+			goto discard;
+		}
 	} else if (unlikely(tipc_link_acked(n->bc_entry.link) != bc_ack)) {
 		tipc_bcast_ack_rcv(net, n->bc_entry.link, hdr);
 	}


