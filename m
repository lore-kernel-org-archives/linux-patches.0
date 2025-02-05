Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03105228;
	Wed,  5 Feb 2025 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764100; cv=none; b=BZJYEv7NPTOVzCyaRbjZeJWsLSOZb0HmTZFGZF0lhlrUgvv2e1IjBworpuN642xr9O3eVZV1U98Aj4Lxr0Zn534FCXmL/xuMifyOc9zH1X/TFIl74y8Y8kf2A83apQ3bOZpf1t2F8wpKB8Z08WRMywxe8NsZW8IO68bQhw1Y2M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764100; c=relaxed/simple;
	bh=tF1qP6auBSUY2z8wj3KIsavOlWj7Bh6r3EwFI35LEco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWj+WaQmSystvjvZJQgxecoyOob8c9CaHkJFSR0hRnlpX2QIVGyiWm0JcuZag9od5CFJ7aSvA0UoAr5gatvAkJ2n6cx8psVsVWwfQIShVqbsnQdtUG6bhW5C2vruXV3lavjj+dt8zSS3YUngDXXoWh3snov8i/limUaVTG1UZDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qK4UTpwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qK4UTpwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0D3C4CED1;
	Wed,  5 Feb 2025 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764100;
	bh=tF1qP6auBSUY2z8wj3KIsavOlWj7Bh6r3EwFI35LEco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qK4UTpwzZt8SfvXMC5L/nE+qsN1AFANnqlg/SWdFKP7wIVlfcnLdRrFUUsf/VATDg
	 8YoiT+VrpgE3R5wYaNshwg8OY5PrvVWUX9dWmfdA/YC9aPxFVbUi8vp1YD7qJnAAbf
	 nePk7lxJ3LSGxPKHO9sODpqVPhuQoo/lbpgIxpsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/590] rxrpc: Fix handling of received connection abort
Date: Wed,  5 Feb 2025 14:37:24 +0100
Message-ID: <20250205134458.656433386@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0e56ebde245e4799ce74d38419426f2a80d39950 ]

Fix the handling of a connection abort that we've received.  Though the
abort is at the connection level, it needs propagating to the calls on that
connection.  Whilst the propagation bit is performed, the calls aren't then
woken up to go and process their termination, and as no further input is
forthcoming, they just hang.

Also add some tracing for the logging of connection aborts.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20241204074710.990092-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h | 25 +++++++++++++++++++++++++
 net/rxrpc/conn_event.c       | 12 ++++++++----
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index cc22596c7250c..666fe1779ccc6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -117,6 +117,7 @@
 #define rxrpc_call_poke_traces \
 	EM(rxrpc_call_poke_abort,		"Abort")	\
 	EM(rxrpc_call_poke_complete,		"Compl")	\
+	EM(rxrpc_call_poke_conn_abort,		"Conn-abort")	\
 	EM(rxrpc_call_poke_error,		"Error")	\
 	EM(rxrpc_call_poke_idle,		"Idle")		\
 	EM(rxrpc_call_poke_set_timeout,		"Set-timo")	\
@@ -282,6 +283,7 @@
 	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
 	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
 	EM(rxrpc_call_see_connected,		"SEE connect ") \
+	EM(rxrpc_call_see_conn_abort,		"SEE conn-abt") \
 	EM(rxrpc_call_see_disconnected,		"SEE disconn ") \
 	EM(rxrpc_call_see_distribute_error,	"SEE dist-err") \
 	EM(rxrpc_call_see_input,		"SEE input   ") \
@@ -956,6 +958,29 @@ TRACE_EVENT(rxrpc_rx_abort,
 		      __entry->abort_code)
 	    );
 
+TRACE_EVENT(rxrpc_rx_conn_abort,
+	    TP_PROTO(const struct rxrpc_connection *conn, const struct sk_buff *skb),
+
+	    TP_ARGS(conn, skb),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	conn)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(u32,		abort_code)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->conn = conn->debug_id;
+		    __entry->serial = rxrpc_skb(skb)->hdr.serial;
+		    __entry->abort_code = skb->priority;
+			   ),
+
+	    TP_printk("C=%08x ABORT %08x ac=%d",
+		      __entry->conn,
+		      __entry->serial,
+		      __entry->abort_code)
+	    );
+
 TRACE_EVENT(rxrpc_rx_challenge,
 	    TP_PROTO(struct rxrpc_connection *conn, rxrpc_serial_t serial,
 		     u32 version, u32 nonce, u32 min_level),
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 598b4ee389fc1..2a1396cd892f3 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -63,11 +63,12 @@ int rxrpc_abort_conn(struct rxrpc_connection *conn, struct sk_buff *skb,
 /*
  * Mark a connection as being remotely aborted.
  */
-static bool rxrpc_input_conn_abort(struct rxrpc_connection *conn,
+static void rxrpc_input_conn_abort(struct rxrpc_connection *conn,
 				   struct sk_buff *skb)
 {
-	return rxrpc_set_conn_aborted(conn, skb, skb->priority, -ECONNABORTED,
-				      RXRPC_CALL_REMOTELY_ABORTED);
+	trace_rxrpc_rx_conn_abort(conn, skb);
+	rxrpc_set_conn_aborted(conn, skb, skb->priority, -ECONNABORTED,
+			       RXRPC_CALL_REMOTELY_ABORTED);
 }
 
 /*
@@ -202,11 +203,14 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn)
 
 	for (i = 0; i < RXRPC_MAXCALLS; i++) {
 		call = conn->channels[i].call;
-		if (call)
+		if (call) {
+			rxrpc_see_call(call, rxrpc_call_see_conn_abort);
 			rxrpc_set_call_completion(call,
 						  conn->completion,
 						  conn->abort_code,
 						  conn->error);
+			rxrpc_poke_call(call, rxrpc_call_poke_conn_abort);
+		}
 	}
 
 	_leave("");
-- 
2.39.5



