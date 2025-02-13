Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA214B95A;
	Thu, 13 Feb 2025 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460328; cv=none; b=E8qf8Iq7EuRgx2jZ94qQHktxb0U31+7a7MZX68sWWeBOyeuk03YxcbSo1SCP+QWKjuqs1FuVSWMPLgPiNebAtlt4zCwYe6f0yQ2n4eDW4w1eEDFk8j1UUAl8DoetfkB18viHWQQ9ts/M6HAao94ysVaj94ZtS2XKxZ60BH6f1ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460328; c=relaxed/simple;
	bh=aJt2nrfpTWLEGj5nS5J4I2rTgx1/X6SDeVOB2U8kd4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6pL+GPI5pQjeY4TfN08taTGROJGgfrr8yk52Pvtoqmx9rsEYNJyUsgmtUCW84l1GtBZc4NTFw3cA4AlNzLt2diu3H3ypo2dCGqs0tlHhiXF26qAvhKVqbcXWmvCy2y/94n2v0REnFRx3Ks8J9OstLhjSIW3LMXXkLXnTkWODoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iX87bB5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iX87bB5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D5EC4CED1;
	Thu, 13 Feb 2025 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460328;
	bh=aJt2nrfpTWLEGj5nS5J4I2rTgx1/X6SDeVOB2U8kd4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iX87bB5xzK2Qe9PDNAkqkqiNSsiPvw54nxRgA5tWbSrbzFtFY42tp3C7rC6dd+k9s
	 3kCOS1KR+3fQG85SvWGTHi0f2yT9GkzaCfEK6RKLvV59SBpkr9l5/BuR8wpdy5xW0M
	 wba0JKXTVxqbcVtgGUWj66heX5lgw6dKJJ4TWofc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/273] rxrpc: Fix call state set to not include the SERVER_SECURING state
Date: Thu, 13 Feb 2025 15:27:32 +0100
Message-ID: <20250213142410.505464939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 41b996ce83bf944de5569d6263c8dbd5513e7ed0 ]

The RXRPC_CALL_SERVER_SECURING state doesn't really belong with the other
states in the call's state set as the other states govern the call's Rx/Tx
phase transition and govern when packets can and can't be received or
transmitted.  The "Securing" state doesn't actually govern the reception of
packets and would need to be split depending on whether or not we've
received the last packet yet (to mirror RECV_REQUEST/ACK_REQUEST).

The "Securing" state is more about whether or not we can start forwarding
packets to the application as recvmsg will need to decode them and the
decoding can't take place until the challenge/response exchange has
completed.

Fix this by removing the RXRPC_CALL_SERVER_SECURING state from the state
set and, instead, using a flag, RXRPC_CALL_CONN_CHALLENGING, to track
whether or not we can queue the call for reception by recvmsg() or notify
the kernel app that data is ready.  In the event that we've already
received all the packets, the connection event handler will poke the app
layer in the appropriate manner.

Also there's a race whereby the app layer sees the last packet before rxrpc
has managed to end the rx phase and change the state to one amenable to
allowing a reply.  Fix this by queuing the packet after calling
rxrpc_end_rx_phase().

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250204230558.712536-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h | 2 +-
 net/rxrpc/call_object.c | 6 ++----
 net/rxrpc/conn_event.c  | 4 +---
 net/rxrpc/input.c       | 2 +-
 net/rxrpc/sendmsg.c     | 2 +-
 5 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 66ad7dc10864e..86438c86eb2fd 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -558,6 +558,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_EXCLUSIVE,		/* The call uses a once-only connection */
 	RXRPC_CALL_RX_IS_IDLE,		/* recvmsg() is idle - send an ACK */
 	RXRPC_CALL_RECVMSG_READ_ALL,	/* recvmsg() read all of the received data */
+	RXRPC_CALL_CONN_CHALLENGING,	/* The connection is being challenged */
 };
 
 /*
@@ -578,7 +579,6 @@ enum rxrpc_call_state {
 	RXRPC_CALL_CLIENT_AWAIT_REPLY,	/* - client awaiting reply */
 	RXRPC_CALL_CLIENT_RECV_REPLY,	/* - client receiving reply phase */
 	RXRPC_CALL_SERVER_PREALLOC,	/* - service preallocation */
-	RXRPC_CALL_SERVER_SECURING,	/* - server securing request connection */
 	RXRPC_CALL_SERVER_RECV_REQUEST,	/* - server receiving request */
 	RXRPC_CALL_SERVER_ACK_REQUEST,	/* - server pending ACK of request */
 	RXRPC_CALL_SERVER_SEND_REPLY,	/* - server sending reply */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 29385908099ef..4f8e8f884d102 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -22,7 +22,6 @@ const char *const rxrpc_call_states[NR__RXRPC_CALL_STATES] = {
 	[RXRPC_CALL_CLIENT_AWAIT_REPLY]		= "ClAwtRpl",
 	[RXRPC_CALL_CLIENT_RECV_REPLY]		= "ClRcvRpl",
 	[RXRPC_CALL_SERVER_PREALLOC]		= "SvPrealc",
-	[RXRPC_CALL_SERVER_SECURING]		= "SvSecure",
 	[RXRPC_CALL_SERVER_RECV_REQUEST]	= "SvRcvReq",
 	[RXRPC_CALL_SERVER_ACK_REQUEST]		= "SvAckReq",
 	[RXRPC_CALL_SERVER_SEND_REPLY]		= "SvSndRpl",
@@ -458,17 +457,16 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	call->cong_tstamp	= skb->tstamp;
 
 	__set_bit(RXRPC_CALL_EXPOSED, &call->flags);
-	rxrpc_set_call_state(call, RXRPC_CALL_SERVER_SECURING);
+	rxrpc_set_call_state(call, RXRPC_CALL_SERVER_RECV_REQUEST);
 
 	spin_lock(&conn->state_lock);
 
 	switch (conn->state) {
 	case RXRPC_CONN_SERVICE_UNSECURED:
 	case RXRPC_CONN_SERVICE_CHALLENGING:
-		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_SECURING);
+		__set_bit(RXRPC_CALL_CONN_CHALLENGING, &call->flags);
 		break;
 	case RXRPC_CONN_SERVICE:
-		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_RECV_REQUEST);
 		break;
 
 	case RXRPC_CONN_ABORTED:
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index ca5e694ab858b..c4eb7986efddf 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -222,10 +222,8 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn)
  */
 static void rxrpc_call_is_secure(struct rxrpc_call *call)
 {
-	if (call && __rxrpc_call_state(call) == RXRPC_CALL_SERVER_SECURING) {
-		rxrpc_set_call_state(call, RXRPC_CALL_SERVER_RECV_REQUEST);
+	if (call && __test_and_clear_bit(RXRPC_CALL_CONN_CHALLENGING, &call->flags))
 		rxrpc_notify_socket(call);
-	}
 }
 
 /*
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 5dfda1ac51dda..9a162035d4c1d 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -574,7 +574,7 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 		rxrpc_propose_delay_ACK(call, sp->hdr.serial,
 					rxrpc_propose_ack_input_data);
 	}
-	if (notify) {
+	if (notify && !test_bit(RXRPC_CALL_CONN_CHALLENGING, &call->flags)) {
 		trace_rxrpc_notify_socket(call->debug_id, sp->hdr.serial);
 		rxrpc_notify_socket(call);
 	}
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 24f765d243db1..b9f2f12281b33 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -658,7 +658,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	} else {
 		switch (rxrpc_call_state(call)) {
 		case RXRPC_CALL_CLIENT_AWAIT_CONN:
-		case RXRPC_CALL_SERVER_SECURING:
+		case RXRPC_CALL_SERVER_RECV_REQUEST:
 			if (p.command == RXRPC_CMD_SEND_ABORT)
 				break;
 			fallthrough;
-- 
2.39.5



