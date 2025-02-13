Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815B189BAF;
	Thu, 13 Feb 2025 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458960; cv=none; b=Dx8eQ7ImfbrS2No1suJ/47JnhZxKJ0As+UqoalQ2qn4ms/81fidMkPik+4IR9YVcSLOeSYhQYceLoOrYJIOymP0YUEMl8BAa1uZ/w+UPbdGgxAcNF1joD1ysFpGZfBUqrRT79TvMTxUoxHX07LuX6nishhiQ+auVwQVdUQu8Krg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458960; c=relaxed/simple;
	bh=EmxVxIPGz4HOpbWHwjiZIVlEniWaE2rYqEUYvmaCOgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMEP/Bc7j5Y4jmUKqSF3rdZ/aHz5hwPqgiM7RZxT4/lkt6w8wt9yLG2LW8MuHuD+MrnM85BjwreUAaM01fAVeKa/XntSgZeeObfHL+gNDVKc0V++DgPp3zxCRqGWycrEqeptu8zv0NzrRmd5BSigdZXZ1AhGNbJQbuZPhpn0WzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ybw808XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ybw808XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6D7C4CED1;
	Thu, 13 Feb 2025 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458960;
	bh=EmxVxIPGz4HOpbWHwjiZIVlEniWaE2rYqEUYvmaCOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ybw808XEkyVkLkR6GqjkQ1YN8JI0oL+9XJz+SjESHXiIATMBwBosoH43bNRAQ2hPL
	 AjyHa0SmK9n2LKdR2pvzZRSjxCT56Q56wWiyBaP6wNvlOeipY89dX8Xz3JHzlnY8ce
	 Z3DjDdTDesyMoWDmytwmEEmQtmnRVuOrH1/E8mNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 127/443] rxrpc: Fix the rxrpc_connection attend queue handling
Date: Thu, 13 Feb 2025 15:24:52 +0100
Message-ID: <20250213142445.510181582@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4241a702e0d0c2ca9364cfac08dbf134264962de ]

The rxrpc_connection attend queue is never used because conn::attend_link
is never initialised and so is always NULL'd out and thus always appears to
be busy.  This requires the following fix:

 (1) Fix this the attend queue problem by initialising conn::attend_link.

And, consequently, two further fixes for things masked by the above bug:

 (2) Fix rxrpc_input_conn_event() to handle being invoked with a NULL
     sk_buff pointer - something that can now happen with the above change.

 (3) Fix the RXRPC_SKB_MARK_SERVICE_CONN_SECURED message to carry a pointer
     to the connection and a ref on it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Fixes: f2cce89a074e ("rxrpc: Implement a mechanism to send an event notification to a connection")
Link: https://patch.msgid.link/20250203110307.7265-3-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  1 +
 net/rxrpc/conn_event.c       | 17 ++++++++++-------
 net/rxrpc/conn_object.c      |  1 +
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 27c23873c8811..ee4030f2e99da 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -218,6 +218,7 @@
 	EM(rxrpc_conn_get_conn_input,		"GET inp-conn") \
 	EM(rxrpc_conn_get_idle,			"GET idle    ") \
 	EM(rxrpc_conn_get_poke_abort,		"GET pk-abort") \
+	EM(rxrpc_conn_get_poke_secured,		"GET secured ") \
 	EM(rxrpc_conn_get_poke_timer,		"GET poke    ") \
 	EM(rxrpc_conn_get_service_conn,		"GET svc-conn") \
 	EM(rxrpc_conn_new_client,		"NEW client  ") \
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 2a1396cd892f3..ca5e694ab858b 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -266,6 +266,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			 * we've already received the packet, put it on the
 			 * front of the queue.
 			 */
+			sp->conn = rxrpc_get_connection(conn, rxrpc_conn_get_poke_secured);
 			skb->mark = RXRPC_SKB_MARK_SERVICE_CONN_SECURED;
 			rxrpc_get_skb(skb, rxrpc_skb_get_conn_secured);
 			skb_queue_head(&conn->local->rx_queue, skb);
@@ -431,14 +432,16 @@ void rxrpc_input_conn_event(struct rxrpc_connection *conn, struct sk_buff *skb)
 	if (test_and_clear_bit(RXRPC_CONN_EV_ABORT_CALLS, &conn->events))
 		rxrpc_abort_calls(conn);
 
-	switch (skb->mark) {
-	case RXRPC_SKB_MARK_SERVICE_CONN_SECURED:
-		if (conn->state != RXRPC_CONN_SERVICE)
-			break;
+	if (skb) {
+		switch (skb->mark) {
+		case RXRPC_SKB_MARK_SERVICE_CONN_SECURED:
+			if (conn->state != RXRPC_CONN_SERVICE)
+				break;
 
-		for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
-			rxrpc_call_is_secure(conn->channels[loop].call);
-		break;
+			for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
+				rxrpc_call_is_secure(conn->channels[loop].call);
+			break;
+		}
 	}
 
 	/* Process delayed ACKs whose time has come. */
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 694c4df7a1a31..88b4aab5a0913 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -67,6 +67,7 @@ struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *rxnet,
 		INIT_WORK(&conn->destructor, rxrpc_clean_up_connection);
 		INIT_LIST_HEAD(&conn->proc_link);
 		INIT_LIST_HEAD(&conn->link);
+		INIT_LIST_HEAD(&conn->attend_link);
 		mutex_init(&conn->security_lock);
 		mutex_init(&conn->tx_data_alloc_lock);
 		skb_queue_head_init(&conn->rx_queue);
-- 
2.39.5



