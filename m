Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2062C81AA8;
	Wed, 28 Jan 2026 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616087; cv=none; b=VidhCyPN8nqTgz28nbsHKVmWxdtDyvX84ikkDUQdu4dwjJokCxV2ALE1OoGDM3dnOh6X3uA6sHcdU9j3j/KG7Zn0b2NhvIG2vSRst1uGdZ/E/LZjuL9NLZu7aftcji6K8EmbN19+y662+fWxd9u18WyHlictLYw//xQxCZeU4Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616087; c=relaxed/simple;
	bh=HgdBqXDA3/U5q7DXIYHVTEx+sdp8CaRkVAzBY7YvX98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fofQtAIa3FC9i9if4R+FuOwZVEnV0xgcbzIM+ju7sKOuNgsPtXDAuUIsiGR4dtrzjOYYxQQhdH2bVbNBbTeafVbaBsRVpm9q6uj076ne9HQchhOfZ5QRtuViNuGK15H3g9NQKUSu+QMfTlRc06AllFLKHlq5s5zjBs7od1CJltQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrtvMbjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrtvMbjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A84C4CEF1;
	Wed, 28 Jan 2026 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616087;
	bh=HgdBqXDA3/U5q7DXIYHVTEx+sdp8CaRkVAzBY7YvX98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrtvMbjOYEgt+vmjwvXUeom6L8snUBqp37mS3ccJEVY92WAqoRvPZd11yWsCXSN/S
	 Bp//YKOlVtDWV6S+TZh1PSh/G7Mhm3UL75LLHbZnOSUx58aqg1ZI5Jd9shUbKOuiVR
	 AfRNVBQEZiVc7W9vG+v9uW50yYaslPX5jKDDw7cU=
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
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 201/227] rxrpc: Fix data-race warning and potential load/store tearing
Date: Wed, 28 Jan 2026 16:24:06 +0100
Message-ID: <20260128145351.674222129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 5d5fe8bcd331f1e34e0943ec7c18432edfcf0e8b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h |    9 ++++++++-
 net/rxrpc/conn_event.c  |    2 +-
 net/rxrpc/output.c      |   14 +++++++-------
 net/rxrpc/peer_event.c  |   17 ++++++++++++++++-
 net/rxrpc/proc.c        |    4 ++--
 net/rxrpc/rxgk.c        |    2 +-
 net/rxrpc/rxkad.c       |    2 +-
 7 files changed, 36 insertions(+), 14 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -387,7 +387,7 @@ struct rxrpc_peer {
 	struct rb_root		service_conns;	/* Service connections */
 	struct list_head	keepalive_link;	/* Link in net->peer_keepalive[] */
 	unsigned long		app_data;	/* Application data (e.g. afs_server) */
-	time64_t		last_tx_at;	/* Last time packet sent here */
+	unsigned int		last_tx_at;	/* Last time packet sent here (time64_t LSW) */
 	seqlock_t		service_conn_lock;
 	spinlock_t		lock;		/* access lock */
 	int			debug_id;	/* debug ID for printks */
@@ -1379,6 +1379,13 @@ void rxrpc_peer_keepalive_worker(struct
 void rxrpc_input_probe_for_pmtud(struct rxrpc_connection *conn, rxrpc_serial_t acked_serial,
 				 bool sendmsg_fail);
 
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
@@ -194,7 +194,7 @@ void rxrpc_conn_retransmit_call(struct r
 	}
 
 	ret = kernel_sendmsg(conn->local->socket, &msg, iov, ioc, len);
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 	if (ret < 0)
 		trace_rxrpc_tx_fail(chan->call_debug_id, serial, ret,
 				    rxrpc_tx_point_call_final_resend);
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -275,7 +275,7 @@ static void rxrpc_send_ack_packet(struct
 	rxrpc_local_dont_fragment(conn->local, why == rxrpc_propose_ack_ping_for_mtu_probe);
 
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
-	call->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(call->peer);
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_ack);
@@ -411,7 +411,7 @@ int rxrpc_send_abort_packet(struct rxrpc
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, sizeof(pkt));
 	ret = do_udp_sendmsg(conn->local->socket, &msg, sizeof(pkt));
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_abort);
@@ -698,7 +698,7 @@ void rxrpc_send_data_packet(struct rxrpc
 			ret = 0;
 			trace_rxrpc_tx_data(call, txb->seq, txb->serial, txb->flags,
 					    rxrpc_txdata_inject_loss);
-			conn->peer->last_tx_at = ktime_get_seconds();
+			rxrpc_peer_mark_tx(conn->peer);
 			goto done;
 		}
 	}
@@ -711,7 +711,7 @@ void rxrpc_send_data_packet(struct rxrpc
 	 */
 	rxrpc_inc_stat(call->rxnet, stat_tx_data_send);
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 
 	if (ret == -EMSGSIZE) {
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_msgsize);
@@ -797,7 +797,7 @@ void rxrpc_send_conn_abort(struct rxrpc_
 
 	trace_rxrpc_tx_packet(conn->debug_id, &whdr, rxrpc_tx_point_conn_abort);
 
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 }
 
 /*
@@ -917,7 +917,7 @@ void rxrpc_send_keepalive(struct rxrpc_p
 		trace_rxrpc_tx_packet(peer->debug_id, &whdr,
 				      rxrpc_tx_point_version_keepalive);
 
-	peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(peer);
 	_leave("");
 }
 
@@ -973,7 +973,7 @@ void rxrpc_send_response(struct rxrpc_co
 	if (ret < 0)
 		goto fail;
 
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 	return;
 
 fail:
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -238,6 +238,21 @@ static void rxrpc_distribute_error(struc
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
@@ -265,7 +280,7 @@ static void rxrpc_peer_keepalive_dispatc
 		spin_unlock_bh(&rxnet->peer_hash_lock);
 
 		if (use) {
-			keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
+			keepalive_at = rxrpc_peer_get_tx_mark(peer, base) + RXRPC_KEEPALIVE_TIME;
 			slot = keepalive_at - base;
 			_debug("%02x peer %u t=%d {%pISp}",
 			       cursor, peer->debug_id, slot, &peer->srx.transport);
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -296,13 +296,13 @@ static int rxrpc_peer_seq_show(struct se
 
 	now = ktime_get_seconds();
 	seq_printf(seq,
-		   "UDP   %-47.47s %-47.47s %3u %4u %5u %6llus %8d %8d\n",
+		   "UDP   %-47.47s %-47.47s %3u %4u %5u %6ds %8d %8d\n",
 		   lbuff,
 		   rbuff,
 		   refcount_read(&peer->ref),
 		   peer->cong_ssthresh,
 		   peer->max_data,
-		   now - peer->last_tx_at,
+		   (s32)now - (s32)READ_ONCE(peer->last_tx_at),
 		   READ_ONCE(peer->recent_srtt_us),
 		   READ_ONCE(peer->recent_rto_us));
 
--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -678,7 +678,7 @@ static int rxgk_issue_challenge(struct r
 
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
 	if (ret > 0)
-		conn->peer->last_tx_at = ktime_get_seconds();
+		rxrpc_peer_mark_tx(conn->peer);
 	__free_page(page);
 
 	if (ret < 0) {
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -694,7 +694,7 @@ static int rxkad_issue_challenge(struct
 		return -EAGAIN;
 	}
 
-	conn->peer->last_tx_at = ktime_get_seconds();
+	rxrpc_peer_mark_tx(conn->peer);
 	trace_rxrpc_tx_packet(conn->debug_id, &whdr,
 			      rxrpc_tx_point_rxkad_challenge);
 	_leave(" = 0");


