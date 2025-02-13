Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7869A2222A9;
	Thu, 13 Feb 2025 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457454; cv=none; b=OpIBLuE8Y+LGADkDyFL0fzYY9YBhdW4CDO11EKDi7pv8MGcY9gW7BGrw6csDtpbgJOby0lzu2DrdTPIBG75ZWS+w14GAV3KAv1I+BoUDr/dcY1Moq/y/tO4WG+nNo3p1V15tts1gB2s12/2HBjpdF+JQ/ldUTmJhZJ+5occ+tJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457454; c=relaxed/simple;
	bh=LgY6LwObS4dwKuRSajIOO2lIueqwd/ZiS+v80vlL/LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBzs0vRmUqplRXeoE8NGWXqtiOS7e466PCxwyP1TdwN9QRCHJodTy3RLcCusfyDLzAwo0Ws9w7THCi2mlY7dYDxwZnyLLqQQevEWLyRBQonPG0s0eyLtxtWExo2X6TKHMRh1sJ9PJZqMNltZSBIuGNLqXPdfBiMK2I3K7jQr0tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUxq5L5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUxq5L5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2211C4CED1;
	Thu, 13 Feb 2025 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457454;
	bh=LgY6LwObS4dwKuRSajIOO2lIueqwd/ZiS+v80vlL/LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUxq5L5ez7YbCMVZTBsi45OaB71SrC8IcPkxjK8eoF5qWsTgNBRNZjnAk6SXbPM8e
	 Q0nG6hly/iNRaMGe4QSPVZzZDq2mXtAqDqSLukMIsDGWsJN1cmdv64PAehkCHvXQFK
	 cbz4B9Nk9TUMJ2j3qOAehPMw3tsBFtPVD7yPqhhU=
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
Subject: [PATCH 6.12 115/422] rxrpc: Fix the rxrpc_connection attend queue handling
Date: Thu, 13 Feb 2025 15:24:24 +0100
Message-ID: <20250213142440.990396528@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
index 666fe1779ccc6..e1a37e9c2d42d 100644
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
index 1539d315afe74..7bc68135966e2 100644
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



