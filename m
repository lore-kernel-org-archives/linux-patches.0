Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65719418372;
	Fri,  7 Aug 2026 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114633; cv=none; b=Kqbi9buzqaIF9umAMmRN48aPbM3lC2Y+5e+dmdjeaVZq4ylZ385jXCm8p81L/HITBbD4W+pL+gbrPjdhC9ehBhgFMtBQcgfA+81dKDiKi4mDPsa6FDKzDPDHWZbWLxHyqiqFr+AhlGeTTdnvQuS9akkNnqgkug7EeFOaaynenms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114633; c=relaxed/simple;
	bh=YvV0xqusadnHv26xl1Mxm4DoKCPbq/OamoqJJXdxNmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6JlWdH4spjBGxqefPd6Sdtn17zOB8ZqypjSajbpnku4NukZNSYRWUzVh4ItBRcLPRBCRrb3Q93UX96rL9tPlb1yyeZ9RC53vFbWuW8CHteJKHRoMCZQEhRIdDobjeXMwRUzqkjROLSoAxFt5Y+AdDR24mTbqn/VOw0mi6/10Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyJIztDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyJIztDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67A41F000E9;
	Fri,  7 Aug 2026 14:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114622;
	bh=T4FtDcEt2cCERWtvJk+wp4ITOBfeSOLUCIIdfshTkzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vyJIztDqnWPjrACxl8leGRAtcd2CjE+U8WR/14caMg1USqNAZkcx4S5doVdE96XG6
	 wWQ9VowZcUAfECmwvbwdFyopTh3xdTvqtR4+RtXgKjLAmfmaieImsHIatRha5tJkkF
	 spBwpp4yUFFqIvmaoz1/prQY1LQkINCbb5kNwyzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/337] rxrpc: Adjust the rxrpc_rtt_rx tracepoint
Date: Fri,  7 Aug 2026 16:38:52 +0200
Message-ID: <20260807143425.673911720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 93dfca65a1df42a3c8b1094299dc42ab8f18e5c8 ]

Adjust the rxrpc_rtt_rx tracepoint in the following ways:

 (1) Display the collected RTT sample in the rxrpc_rtt_rx trace.

 (2) Move the division of srtt by 8 to the TP_printk() rather doing it
     before invoking the trace point.

 (3) Display the min_rtt value.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e4d2878369d5 ("rxrpc: Fix irq-disabled in local_bh_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |   14 ++++++++++----
 net/rxrpc/input.c            |    4 ++--
 net/rxrpc/rtt.c              |    2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1308,9 +1308,9 @@ TRACE_EVENT(rxrpc_rtt_rx,
 	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_rtt_rx_trace why,
 		     int slot,
 		     rxrpc_serial_t send_serial, rxrpc_serial_t resp_serial,
-		     u32 rtt, u32 rto),
+		     u32 rtt, u32 srtt, u32 rto),
 
-	    TP_ARGS(call, why, slot, send_serial, resp_serial, rtt, rto),
+	    TP_ARGS(call, why, slot, send_serial, resp_serial, rtt, srtt, rto),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call)
@@ -1319,7 +1319,9 @@ TRACE_EVENT(rxrpc_rtt_rx,
 		    __field(rxrpc_serial_t,		send_serial)
 		    __field(rxrpc_serial_t,		resp_serial)
 		    __field(u32,			rtt)
+		    __field(u32,			srtt)
 		    __field(u32,			rto)
+		    __field(u32,			min_rtt)
 			     ),
 
 	    TP_fast_assign(
@@ -1329,17 +1331,21 @@ TRACE_EVENT(rxrpc_rtt_rx,
 		    __entry->send_serial = send_serial;
 		    __entry->resp_serial = resp_serial;
 		    __entry->rtt = rtt;
+		    __entry->srtt = srtt;
 		    __entry->rto = rto;
+		    __entry->min_rtt = minmax_get(&call->peer->min_rtt)
 			   ),
 
-	    TP_printk("c=%08x [%d] %s sr=%08x rr=%08x rtt=%u rto=%u",
+	    TP_printk("c=%08x [%d] %s sr=%08x rr=%08x rtt=%u srtt=%u rto=%u min=%u",
 		      __entry->call,
 		      __entry->slot,
 		      __print_symbolic(__entry->why, rxrpc_rtt_rx_traces),
 		      __entry->send_serial,
 		      __entry->resp_serial,
 		      __entry->rtt,
-		      __entry->rto)
+		      __entry->srtt / 8,
+		      __entry->rto,
+		      __entry->min_rtt)
 	    );
 
 TRACE_EVENT(rxrpc_timer_set,
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -674,7 +674,7 @@ static void rxrpc_complete_rtt_probe(str
 		 */
 		if (after(acked_serial, orig_serial)) {
 			trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_obsolete, i,
-					   orig_serial, acked_serial, 0, 0);
+					   orig_serial, acked_serial, 0, 0, 0);
 			clear_bit(i + RXRPC_CALL_RTT_PEND_SHIFT, &call->rtt_avail);
 			smp_wmb();
 			set_bit(i, &call->rtt_avail);
@@ -682,7 +682,7 @@ static void rxrpc_complete_rtt_probe(str
 	}
 
 	if (!matched)
-		trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_lost, 9, 0, acked_serial, 0, 0);
+		trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_lost, 9, 0, acked_serial, 0, 0, 0);
 }
 
 /*
--- a/net/rxrpc/rtt.c
+++ b/net/rxrpc/rtt.c
@@ -175,7 +175,7 @@ void rxrpc_peer_add_rtt(struct rxrpc_cal
 	spin_unlock(&peer->rtt_input_lock);
 
 	trace_rxrpc_rtt_rx(call, why, rtt_slot, send_serial, resp_serial,
-			   peer->srtt_us >> 3, peer->rto_us);
+			   rtt_us, peer->srtt_us, peer->rto_us);
 }
 
 /*


