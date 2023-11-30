Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE52C495C2;
	Thu, 30 Nov 2023 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayfV/YQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AFAC433C7;
	Thu, 30 Nov 2023 16:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361456;
	bh=hmS6qzjC8ohOZlhzc6PcnbNDE31gKNBLew2/dLvKVNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayfV/YQ1tAhQLzYAvmEWp2Kdvb3Chja7rkcgNCpmKKndjnUnIY3AV7p9k6S7yetvj
	 DOWjQFuAwE+gDtPdHmoV3DXENgAfuoIllKMq7CwBxFHcjznsWUkIz3jMTdVZogQg6U
	 BE2q428nGioIRCTDKymYHFiAPPKPn1YI1hMxGXXA=
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
Subject: [PATCH 6.6 010/112] rxrpc: Defer the response to a PING ACK until weve parsed it
Date: Thu, 30 Nov 2023 16:20:57 +0000
Message-ID: <20231130162140.647405804@linuxfoundation.org>
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

[ Upstream commit 1a01319feef7047aa2ba400ffa3e047776aa29ca ]

Defer the generation of a PING RESPONSE ACK in response to a PING ACK until
we've parsed the PING ACK so that we pick up any changes to the packet
queue so that we can update ackinfo.

This is also applied to an ACK generated in response to an ACK with the
REQUEST_ACK flag set.

Note that whilst the problem was added in commit 248f219cb8bc, it didn't
really matter at that point because the ACK was proposed in softirq mode
and generated asynchronously later in process context, taking the latest
values at the time.  But this fix is only needed since the move to parse
incoming packets in an I/O thread rather than in softirq and generate the
ACK at point of proposal (b0346843b1076b34a0278ff601f8f287535cb064).

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
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
 net/rxrpc/input.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 3f9594d125192..92495e73b8699 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -814,14 +814,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		}
 	}
 
-	if (ack.reason == RXRPC_ACK_PING) {
-		rxrpc_send_ACK(call, RXRPC_ACK_PING_RESPONSE, ack_serial,
-			       rxrpc_propose_ack_respond_to_ping);
-	} else if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
-		rxrpc_send_ACK(call, RXRPC_ACK_REQUESTED, ack_serial,
-			       rxrpc_propose_ack_respond_to_ack);
-	}
-
 	/* If we get an EXCEEDS_WINDOW ACK from the server, it probably
 	 * indicates that the client address changed due to NAT.  The server
 	 * lost the call because it switched to a different peer.
@@ -832,7 +824,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    rxrpc_is_client_call(call)) {
 		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 					  0, -ENETRESET);
-		return;
+		goto send_response;
 	}
 
 	/* If we get an OUT_OF_SEQUENCE ACK from the server, that can also
@@ -846,7 +838,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    rxrpc_is_client_call(call)) {
 		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 					  0, -ENETRESET);
-		return;
+		goto send_response;
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
@@ -854,7 +846,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->acks_first_seq,
 					   prev_pkt, call->acks_prev_seq);
-		return;
+		goto send_response;
 	}
 
 	info.rxMTU = 0;
@@ -894,7 +886,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
 		break;
 	default:
-		return;
+		goto send_response;
 	}
 
 	if (before(hard_ack, call->acks_hard_ack) ||
@@ -906,7 +898,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	if (after(hard_ack, call->acks_hard_ack)) {
 		if (rxrpc_rotate_tx_window(call, hard_ack, &summary)) {
 			rxrpc_end_tx_phase(call, false, rxrpc_eproto_unexpected_ack);
-			return;
+			goto send_response;
 		}
 	}
 
@@ -924,6 +916,14 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 				   rxrpc_propose_ack_ping_for_lost_reply);
 
 	rxrpc_congestion_management(call, skb, &summary, acked_serial);
+
+send_response:
+	if (ack.reason == RXRPC_ACK_PING)
+		rxrpc_send_ACK(call, RXRPC_ACK_PING_RESPONSE, ack_serial,
+			       rxrpc_propose_ack_respond_to_ping);
+	else if (sp->hdr.flags & RXRPC_REQUEST_ACK)
+		rxrpc_send_ACK(call, RXRPC_ACK_REQUESTED, ack_serial,
+			       rxrpc_propose_ack_respond_to_ack);
 }
 
 /*
-- 
2.42.0



