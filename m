Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B96495C2;
	Thu, 30 Nov 2023 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j83gq1zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D0EC433C7;
	Thu, 30 Nov 2023 16:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361454;
	bh=3EF50quMPrPbvg00kmHOgCNwoHXsCNjbnPSGn8JvNu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j83gq1zEmv4NLjFgsuZuiQlYRxJw+iGPHfCdj5CABqZVeNJQbrZB+GOYIrhfFVR5H
	 TauEbpVvrx/EtmD7bdH8fdOlD3tVsrj170HUwm1CgUf86z+N0XIqCDZTA8Od51T7pf
	 LpS/MC+56RExiW1172eiIGn96Y4pLjnuzTrEyIRM=
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
Subject: [PATCH 6.6 009/112] rxrpc: Fix RTT determination to use any ACK as a source
Date: Thu, 30 Nov 2023 16:20:56 +0000
Message-ID: <20231130162140.616180723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

[ Upstream commit 3798680f2fbbe0ca3ab6138b34e0d161c36497ee ]

Fix RTT determination to be able to use any type of ACK as the response
from which RTT can be calculated provided its ack.serial is non-zero and
matches the serial number of an outgoing DATA or ACK packet.  This
shouldn't be limited to REQUESTED-type ACKs as these can have other types
substituted for them for things like duplicate or out-of-order packets.

Fixes: 4700c4d80b7b ("rxrpc: Fix loss of RTT samples due to interposed ACK")
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
 include/trace/events/rxrpc.h |  2 +-
 net/rxrpc/input.c            | 35 ++++++++++++++++-------------------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 4c53a5ef6257b..f7e537f64db45 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -328,7 +328,7 @@
 	E_(rxrpc_rtt_tx_ping,			"PING")
 
 #define rxrpc_rtt_rx_traces \
-	EM(rxrpc_rtt_rx_cancel,			"CNCL") \
+	EM(rxrpc_rtt_rx_other_ack,		"OACK") \
 	EM(rxrpc_rtt_rx_obsolete,		"OBSL") \
 	EM(rxrpc_rtt_rx_lost,			"LOST") \
 	EM(rxrpc_rtt_rx_ping_response,		"PONG") \
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 030d64f282f37..3f9594d125192 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -643,12 +643,8 @@ static void rxrpc_complete_rtt_probe(struct rxrpc_call *call,
 			clear_bit(i + RXRPC_CALL_RTT_PEND_SHIFT, &call->rtt_avail);
 			smp_mb(); /* Read data before setting avail bit */
 			set_bit(i, &call->rtt_avail);
-			if (type != rxrpc_rtt_rx_cancel)
-				rxrpc_peer_add_rtt(call, type, i, acked_serial, ack_serial,
-						   sent_at, resp_time);
-			else
-				trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_cancel, i,
-						   orig_serial, acked_serial, 0, 0);
+			rxrpc_peer_add_rtt(call, type, i, acked_serial, ack_serial,
+					   sent_at, resp_time);
 			matched = true;
 		}
 
@@ -801,20 +797,21 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 			   summary.ack_reason, nr_acks);
 	rxrpc_inc_stat(call->rxnet, stat_rx_acks[ack.reason]);
 
-	switch (ack.reason) {
-	case RXRPC_ACK_PING_RESPONSE:
-		rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
-					 rxrpc_rtt_rx_ping_response);
-		break;
-	case RXRPC_ACK_REQUESTED:
-		rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
-					 rxrpc_rtt_rx_requested_ack);
-		break;
-	default:
-		if (acked_serial != 0)
+	if (acked_serial != 0) {
+		switch (ack.reason) {
+		case RXRPC_ACK_PING_RESPONSE:
 			rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
-						 rxrpc_rtt_rx_cancel);
-		break;
+						 rxrpc_rtt_rx_ping_response);
+			break;
+		case RXRPC_ACK_REQUESTED:
+			rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
+						 rxrpc_rtt_rx_requested_ack);
+			break;
+		default:
+			rxrpc_complete_rtt_probe(call, skb->tstamp, acked_serial, ack_serial,
+						 rxrpc_rtt_rx_other_ack);
+			break;
+		}
 	}
 
 	if (ack.reason == RXRPC_ACK_PING) {
-- 
2.42.0



