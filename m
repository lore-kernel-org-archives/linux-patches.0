Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C881C3A16B0;
	Mon, 23 Mar 2026 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278901; cv=none; b=cHBjCP8ZAxXvlN94szUc7x230Razk1sA8mbKdeYbJE+2EcPvBOyF4TfDRBVfjqezt2/3ZkERNH9UorPXw1866tB9nsxVyGieCSXEpXDAOC+kW9N4gyoWL1j1qR4eD5oC7fZiRGp0gekoI/RK6QhcaC0x4ezVIMiT76N5MQdw/EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278901; c=relaxed/simple;
	bh=yPatdwKzB2Vra6pI2Kmdz0HMMn+FFitnGOXHWOqmj/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6gnjMHqQ5nnQxqFZQOGGFNJ4c9iPSP+7qlLxy9D93bO6n+oNnJ1lf2eJtpQ3KZ7a0CxtvJB9/Celioq/G6mUmJ3j452czwgfzzIycdiHyQM8Xz6MmQYzTkE34YRDuB3rbHu+f/JjRVbxGUFK6FcRWYTs22RVCeYxr9ES810UuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUoei75j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUoei75j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82B2C4CEF7;
	Mon, 23 Mar 2026 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278901;
	bh=yPatdwKzB2Vra6pI2Kmdz0HMMn+FFitnGOXHWOqmj/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUoei75j6htvzg1GAWVeAYEewl2GNbmz2mm966/5/4aKPiULuwlVF/wUcdgDEWLMN
	 BWz39jtlGM4UtX8DmvDqSg4XRKm8pm8Btyii28fZSpzCrHtW8KW6po1+5zdg42BeSG
	 ZO3oB9Pmv67eQgzdU+CdsjJNkYVBzoB2dy+V/Yn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6182afad5045e6703b3d@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.6 418/567] rxrpc: Fix data-race warning and potential load/store tearing
Date: Mon, 23 Mar 2026 14:45:38 +0100
Message-ID: <20260323134544.230896637@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

[ Upstream commit 5d5fe8bcd331f1e34e0943ec7c18432edfcf0e8b ]

Fix the following:

        BUG: KCSAN: data-race in rxrpc_peer_keepalive_worker / rxrpc_send_data_packet

which is reporting an issue with the reads and writes to ->last_tx_at in:

        conn->peer->last_tx_at = ktime_get_seconds();

and:

        keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;

The lockless accesses to these to values aren't actually a problem as the
read only needs an approximate time of last transmission for the purposes
of deciding whether or not the transmission of a keepalive packet is
warranted yet.

Also, as ->last_tx_at is a 64-bit value, tearing can occur on a 32-bit
arch.

Fix both of these by switching to an unsigned int for ->last_tx_at and only
storing the LSW of the time64_t.  It can then be reconstructed at need
provided no more than 68 years has elapsed since the last transmission.

Fixes: ace45bec6d77 ("rxrpc: Fix firewall route keepalive")
Reported-by: syzbot+6182afad5045e6703b3d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/695e7cfb.050a0220.1c677c.036b.GAE@google.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/1107124.1768903985@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ The context change is due to the commit f3a123b25429
("rxrpc: Allow the app to store private data on peer structs"),
the commit 372d12d191cb
("rxrpc: Add a reason indicator to the tx_data tracepoint"),
the commit 153f90a066dd
("rxrpc: Use ktimes for call timeout tracking and set the timer lazily")
and the commit 9d1d2b59341f
("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI))
which are irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h |    9 ++++++++-
 net/rxrpc/conn_event.c  |    2 +-
 net/rxrpc/output.c      |   11 ++++++-----
 net/rxrpc/peer_event.c  |   17 ++++++++++++++++-
 net/rxrpc/proc.c        |    4 ++--
 net/rxrpc/rxkad.c       |    2 +-
 6 files changed, 34 insertions(+), 11 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -331,7 +331,7 @@ struct rxrpc_peer {
 	struct hlist_head	error_targets;	/* targets for net error distribution */
 	struct rb_root		service_conns;	/* Service connections */
 	struct list_head	keepalive_link;	/* Link in net->peer_keepalive[] */
-	time64_t		last_tx_at;	/* Last time packet sent here */
+	unsigned int		last_tx_at;	/* Last time packet sent here (time64_t LSW) */
 	seqlock_t		service_conn_lock;
 	spinlock_t		lock;		/* access lock */
 	unsigned int		if_mtu;		/* interface MTU for this peer */
@@ -1171,6 +1171,13 @@ void rxrpc_transmit_one(struct rxrpc_cal
 void rxrpc_input_error(struct rxrpc_local *, struct sk_buff *);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
+/* Update the last transmission time on a peer for keepalive purposes. */
+static inline void rxrpc_peer_mark_tx(struct rxrpc_peer *peer)
+{
+	/* To avoid tearing on 32-bit systems, we only keep the LSW. */
+	WRITE_ONCE(peer->last_tx_at, ktime_get_seconds());
+}
+
 /*
  * peer_object.c
  */
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -180,7 +180,7 @@ void rxrpc_conn_retransmit_call(struct r
 	}
 
 	ret = kernel_sendmsg(conn->local->socket, &msg, iov, ioc, len);
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 	if (ret < 0)
 		trace_rxrpc_tx_fail(chan->call_debug_id, serial, ret,
 				    rxrpc_tx_point_call_final_resend);
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -233,7 +233,7 @@ int rxrpc_send_ack_packet(struct rxrpc_c
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
-	call->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(call->peer);
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_ack);
@@ -307,7 +307,7 @@ int rxrpc_send_abort_packet(struct rxrpc
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, sizeof(pkt));
 	ret = do_udp_sendmsg(conn->local->socket, &msg, sizeof(pkt));
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_abort);
@@ -392,6 +392,7 @@ dont_set_request_ack:
 					    txb->wire.flags,
 					    test_bit(RXRPC_TXBUF_RESENT, &txb->flags),
 					    true);
+			rxrpc_peer_mark_tx(conn->peer);
 			goto done;
 		}
 	}
@@ -425,7 +426,7 @@ dont_set_request_ack:
 	 */
 	rxrpc_inc_stat(call->rxnet, stat_tx_data_send);
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 
 	if (ret < 0) {
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_fail);
@@ -572,7 +573,7 @@ void rxrpc_send_conn_abort(struct rxrpc_
 
 	trace_rxrpc_tx_packet(conn->debug_id, &whdr, rxrpc_tx_point_conn_abort);
 
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 }
 
 /*
@@ -691,7 +692,7 @@ void rxrpc_send_keepalive(struct rxrpc_p
 		trace_rxrpc_tx_packet(peer->debug_id, &whdr,
 				      rxrpc_tx_point_version_keepalive);
 
-	peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(peer);
 	_leave("");
 }
 
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -225,6 +225,21 @@ static void rxrpc_distribute_error(struc
 }
 
 /*
+ * Reconstruct the last transmission time.  The difference calculated should be
+ * valid provided no more than ~68 years elapsed since the last transmission.
+ */
+static time64_t rxrpc_peer_get_tx_mark(const struct rxrpc_peer *peer, time64_t base)
+{
+	s32 last_tx_at = READ_ONCE(peer->last_tx_at);
+	s32 base_lsw = base;
+	s32 diff = last_tx_at - base_lsw;
+
+	diff = clamp(diff, -RXRPC_KEEPALIVE_TIME, RXRPC_KEEPALIVE_TIME);
+
+	return diff + base;
+}
+
+/*
  * Perform keep-alive pings.
  */
 static void rxrpc_peer_keepalive_dispatch(struct rxrpc_net *rxnet,
@@ -252,7 +267,7 @@ static void rxrpc_peer_keepalive_dispatc
 		spin_unlock(&rxnet->peer_hash_lock);
 
 		if (use) {
-			keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
+			keepalive_at = rxrpc_peer_get_tx_mark(peer, base) + RXRPC_KEEPALIVE_TIME;
 			slot = keepalive_at - base;
 			_debug("%02x peer %u t=%d {%pISp}",
 			       cursor, peer->debug_id, slot, &peer->srx.transport);
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -225,13 +225,13 @@ static int rxrpc_peer_seq_show(struct se
 	now = ktime_get_seconds();
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %3u"
-		   " %3u %5u %6llus %8u %8u\n",
+		   " %3u %5u %6ds %8u %8u\n",
 		   lbuff,
 		   rbuff,
 		   refcount_read(&peer->ref),
 		   peer->cong_ssthresh,
 		   peer->mtu,
-		   now - peer->last_tx_at,
+		   (s32)now - (s32)READ_ONCE(peer->last_tx_at),
 		   peer->srtt_us >> 3,
 		   jiffies_to_usecs(peer->rto_j));
 
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -674,7 +674,7 @@ static int rxkad_issue_challenge(struct
 		return -EAGAIN;
 	}
 
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 	trace_rxrpc_tx_packet(conn->debug_id, &whdr,
 			      rxrpc_tx_point_rxkad_challenge);
 	_leave(" = 0");


