Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4D1604BC;
	Tue, 13 Feb 2024 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845759; cv=none; b=FN+dWc5uBhoDba++ndW0fHXpXPVYwWPUo2EEzmmQMtTikJBtMV7F1Q1cHn7W0HfW/MPrlueJXdLkouVRoDMUbMeAhphOxtnzYTx6lynzlp2MxA/W9RgDC52/No70y41bVdcGRHwb3OUwKVuqYIMN3TNZZOw59O2Lzil1J8hIgOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845759; c=relaxed/simple;
	bh=FAVQ1lVItBMoTTt2BSjI2ICT+LS7/vdy0HzpaSO1NXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3WqnnUJmhKt1214BqJQr0Q+z3Rvt+NaChfQBpKT7Iu1ysnYvM1Qlh8DvxsB2c5TNfLEInJE5BJIq0m3NlGoYQpk7huKfKwv/CFud6Aqhzi1J/0lBytR92RhHwrsZTxUM0ug1QLKtznNNJ7ZFoegZbGLhRSUxPUCqhYC77T93eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnf8V1qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnf8V1qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB431C433C7;
	Tue, 13 Feb 2024 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845759;
	bh=FAVQ1lVItBMoTTt2BSjI2ICT+LS7/vdy0HzpaSO1NXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnf8V1qZD//KMLMWnjoFh1/d/aAqMb/a0bR5+5LwWkkx2LpXaa4veGDdxHykSEeoV
	 wRyuRc/Yz8GJXXXhlAtbkqfdi/zTs6uT9LeBp2rMuxX/PH9rDwMuD8fcRArXGEGiEF
	 I73PHquPBAsqPqJnI65zr2z0tBk6/927ZQQZ8nsg=
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
Subject: [PATCH 6.7 049/124] rxrpc: Fix generation of serial numbers to skip zero
Date: Tue, 13 Feb 2024 18:21:11 +0100
Message-ID: <20240213171855.167470143@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5d5b19f20d1e..efbe82926769 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -507,7 +507,7 @@ struct rxrpc_connection {
 	enum rxrpc_call_completion completion;	/* Completion condition */
 	s32			abort_code;	/* Abort code of connection abort */
 	int			debug_id;	/* debug ID for printks */
-	atomic_t		serial;		/* packet serial number counter */
+	rxrpc_serial_t		tx_serial;	/* Outgoing packet serial number counter */
 	unsigned int		hi_serial;	/* highest serial number received */
 	u32			service_id;	/* Service ID, possibly upgraded */
 	u32			security_level;	/* Security level selected */
@@ -819,6 +819,20 @@ static inline bool rxrpc_sending_to_client(const struct rxrpc_txbuf *txb)
 
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



