Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A454F5F54E;
	Tue, 13 Feb 2024 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845390; cv=none; b=hX49eTK7MD7P/D+ckTvG3Vod7mnMJFzTPHXaORS3nnC9TBf3W8acZTnYr88ZMTwYHLy9OAtUfTav7+MBSFLtBT6w8CQ7Qh6zQFRuTTyXXyrTu506iMgH3fv8m6187nKO08sr+Kp4Tzy4VMnNvnO2UisPyg2FFtpxsIsKqhMJBT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845390; c=relaxed/simple;
	bh=+jLJhLN4OOUbhIyI7Qtc7m/uwK0BQ4gzj1NI49mGJbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ+FiB5rGTLQSducIZJHYWM/KIPkV3owtEx3qr6tM0tMxWSEGOyqe2sZAvdH+AxKclq2rbIpXqQa3BqYmXS0JlR9Q2g43UMTLurY2r/w1G3CDWZsk6nTp9HmEEaUWQAPdx5u8tXJShcRpacAzVtbdYqi0cyIFFYbei7Q/GLMMFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnPZd5Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnPZd5Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05E8C433F1;
	Tue, 13 Feb 2024 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845390;
	bh=+jLJhLN4OOUbhIyI7Qtc7m/uwK0BQ4gzj1NI49mGJbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnPZd5KrtIUFKko1Usc7+hUC81PUZj+7/8G2SPvkYu7U8qHSo+/R01JBEvvRZMRFN
	 burT5ccemoHokWBXkAktZ7UTTLDqe5SeahS2DwlVh55uymPA+8awnznhfutgkza2zl
	 ez1k758GNpAU15fl+PYzaX1d+mlESEFZHOi2wPTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/121] rxrpc: Fix generation of serial numbers to skip zero
Date: Tue, 13 Feb 2024 18:21:14 +0100
Message-ID: <20240213171854.892721295@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit f31041417bf7f4a4df8b3bfb52cb31bbe805b934 ]

In the Rx protocol, every packet generated is marked with a per-connection
monotonically increasing serial number.  This number can be referenced in
an ACK packet generated in response to an incoming packet - thereby
allowing the sender to use this for RTT determination, amongst other
things.

However, if the reference field in the ACK is zero, it doesn't refer to any
incoming packet (it could be a ping to find out if a packet got lost, for
example) - so we shouldn't generate zero serial numbers.

Fix the generation of serial numbers to retry if it comes up with a zero.

Furthermore, since the serial numbers are only ever allocated within the
I/O thread this connection is bound to, there's no need for atomics so
remove that too.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h | 16 +++++++++++++++-
 net/rxrpc/conn_event.c  |  2 +-
 net/rxrpc/output.c      |  8 ++++----
 net/rxrpc/proc.c        |  2 +-
 net/rxrpc/rxkad.c       |  4 ++--
 5 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index e8b43408136a..668fdc94b299 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -506,7 +506,7 @@ struct rxrpc_connection {
 	enum rxrpc_call_completion completion;	/* Completion condition */
 	s32			abort_code;	/* Abort code of connection abort */
 	int			debug_id;	/* debug ID for printks */
-	atomic_t		serial;		/* packet serial number counter */
+	rxrpc_serial_t		tx_serial;	/* Outgoing packet serial number counter */
 	unsigned int		hi_serial;	/* highest serial number received */
 	u32			service_id;	/* Service ID, possibly upgraded */
 	u32			security_level;	/* Security level selected */
@@ -818,6 +818,20 @@ static inline bool rxrpc_sending_to_client(const struct rxrpc_txbuf *txb)
 
 #include <trace/events/rxrpc.h>
 
+/*
+ * Allocate the next serial number on a connection.  0 must be skipped.
+ */
+static inline rxrpc_serial_t rxrpc_get_next_serial(struct rxrpc_connection *conn)
+{
+	rxrpc_serial_t serial;
+
+	serial = conn->tx_serial;
+	if (serial == 0)
+		serial = 1;
+	conn->tx_serial = serial + 1;
+	return serial;
+}
+
 /*
  * af_rxrpc.c
  */
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 95f4bc206b3d..ec5eae60ab0c 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -117,7 +117,7 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 	iov[2].iov_base	= &ack_info;
 	iov[2].iov_len	= sizeof(ack_info);
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = rxrpc_get_next_serial(conn);
 
 	pkt.whdr.epoch		= htonl(conn->proto.epoch);
 	pkt.whdr.cid		= htonl(conn->proto.cid | channel);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index a0906145e829..4a292f860ae3 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -216,7 +216,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	iov[0].iov_len	= sizeof(txb->wire) + sizeof(txb->ack) + n;
 	len = iov[0].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = rxrpc_get_next_serial(conn);
 	txb->wire.serial = htonl(serial);
 	trace_rxrpc_tx_ack(call->debug_id, serial,
 			   ntohl(txb->ack.firstPacket),
@@ -302,7 +302,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	iov[0].iov_base	= &pkt;
 	iov[0].iov_len	= sizeof(pkt);
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = rxrpc_get_next_serial(conn);
 	pkt.whdr.serial = htonl(serial);
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, sizeof(pkt));
@@ -334,7 +334,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	_enter("%x,{%d}", txb->seq, txb->len);
 
 	/* Each transmission of a Tx packet needs a new serial number */
-	serial = atomic_inc_return(&conn->serial);
+	serial = rxrpc_get_next_serial(conn);
 	txb->wire.serial = htonl(serial);
 
 	if (test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags) &&
@@ -558,7 +558,7 @@ void rxrpc_send_conn_abort(struct rxrpc_connection *conn)
 
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = rxrpc_get_next_serial(conn);
 	whdr.serial = htonl(serial);
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 682636d3b060..208312c244f6 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -181,7 +181,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   atomic_read(&conn->active),
 		   state,
 		   key_serial(conn->key),
-		   atomic_read(&conn->serial),
+		   conn->tx_serial,
 		   conn->hi_serial,
 		   conn->channels[0].call_id,
 		   conn->channels[1].call_id,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index b52dedcebce0..6b32d61d4cdc 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -664,7 +664,7 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = rxrpc_get_next_serial(conn);
 	whdr.serial = htonl(serial);
 
 	ret = kernel_sendmsg(conn->local->socket, &msg, iov, 2, len);
@@ -721,7 +721,7 @@ static int rxkad_send_response(struct rxrpc_connection *conn,
 
 	len = iov[0].iov_len + iov[1].iov_len + iov[2].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = rxrpc_get_next_serial(conn);
 	whdr.serial = htonl(serial);
 
 	rxrpc_local_dont_fragment(conn->local, false);
-- 
2.43.0



