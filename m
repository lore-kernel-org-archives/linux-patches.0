Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2FA18784A;
	Thu, 13 Feb 2025 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460401; cv=none; b=qPyzKoTzpwDOBf4Vz1G5wgQVHWPMC7AVtlB2qOZfCeKqe0oQi/plkdxP7oK8ejd4UP6lnwFkSDjbrOrZ79D7LcBUht20xXzFmr8z0wWviq1WPfOh0Si7R6ZSi0b+xWezGMnZd4zeZ3NAtlgFROJy6oKmOPQ02qr9/PBPaARNXHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460401; c=relaxed/simple;
	bh=jPhj8uuUzZxpVtcFHLi9Kd+x8WzDChV/z6bs2zIWfP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfLnVdR/KJuOsWwi0c2gis/eAe58ouP+9QcMay0UW0vUiBcdoi/JXyKe47bc88bW0bfc5cZeis1sa1mXh2cUbhnW1ea1t8TeWgqcSwOExW0+gkK7ZpTB+wbaWZVpeS1n2Fp0PrDUh7FjRmoKGD55YI/txx+sQ7swwtrF6U3SgKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByD2QoFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByD2QoFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECC4C4CED1;
	Thu, 13 Feb 2025 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460401;
	bh=jPhj8uuUzZxpVtcFHLi9Kd+x8WzDChV/z6bs2zIWfP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByD2QoFl3yonaTTAV0177rqj7ScS+KMUXvWKsEJu+5FHArufe0+TZPmNjdbTXibxp
	 RLUDjo2/B+/EOEi8TT8sVmzxf0h0K2h7p6+oFibQuk1tuzQAoy0PPBjXGqeRVHl1vi
	 UJ+HgGdf1lQttBtNauRJc5Z2fCrq80W6eHnkPcNo=
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
Subject: [PATCH 6.6 070/273] rxrpc: Fix the rxrpc_connection attend queue handling
Date: Thu, 13 Feb 2025 15:27:22 +0100
Message-ID: <20250213142410.119572049@linuxfoundation.org>
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
index 252bb90aca599..e7c7b63894362 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -214,6 +214,7 @@
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
index 7aa58129ae455..f0c77f437b616 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -67,6 +67,7 @@ struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *rxnet,
 		INIT_WORK(&conn->destructor, rxrpc_clean_up_connection);
 		INIT_LIST_HEAD(&conn->proc_link);
 		INIT_LIST_HEAD(&conn->link);
+		INIT_LIST_HEAD(&conn->attend_link);
 		mutex_init(&conn->security_lock);
 		skb_queue_head_init(&conn->rx_queue);
 		conn->rxnet = rxnet;
-- 
2.39.5



