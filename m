Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B98246542;
	Tue, 14 May 2024 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683647; cv=none; b=m/IbIWNrIEVqsK/9WYk2V1LFIIevfJ13Z+CU77NDvGq7cn9X7qCuPRttlQsba7mT3qcNbL51bHnySRfh06DoMIWe4eRlIBQWmr4yrptfaYo5CreCRTTnvUchq6CS7i1FoCwUFjgFMioq2FLYboi9xV60pxTudSN2I/tis+qc6Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683647; c=relaxed/simple;
	bh=vV2H6WB21GlPJ/RIIYBMqZgs8fcCaQRFYGZn7WOCkeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzdDS4wmdPkCRsbeCWGj4W8wz7M9+yyCeKl69QFQJdrWILfM4NQE5AvAWQIT8zzaJXOUJ3V/m3Lud1gw5phok9FApqUzCibWoMhXDToarA3eD4Z9rJoqqEn/PX2h9YDR/UKPo4qLYKXd67VLw1cDRNZeXpp7rdYub1FNIqimX2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJeLg0bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJeLg0bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFCBC2BD10;
	Tue, 14 May 2024 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683645;
	bh=vV2H6WB21GlPJ/RIIYBMqZgs8fcCaQRFYGZn7WOCkeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJeLg0bpQmZIX0XzR2EBeg+aR3SWZ0haKHm84AM5jPEdeJHwLUy3OALxCKb5jzoEW
	 q5rR64SzWsIkpML035vuA/N9d/T96Iwif62kLx1VS9sN5yFU8EeeewLl0uJzYUY8tB
	 Cfmy14G7VCLG5wJQZHWV4lYEOckOPszmi7IJUib4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Jeffrey Altman <jaltman@auristor.commailto:jaltman@auristor.com>
Subject: [PATCH 6.8 218/336] rxrpc: Only transmit one ACK per jumbo packet received
Date: Tue, 14 May 2024 12:17:02 +0200
Message-ID: <20240514101046.844778216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 012b7206918dcc5a4dcf1432b3e643114c95957e ]

Only generate one ACK packet for all the subpackets in a jumbo packet.  If
we would like to generate more than one ACK, we prioritise them base on
their reason code, in the order, highest first:

   OutOfSeq > NoSpace > ExceedsWin > Duplicate > Requested > Delay > Idle

For the first four, we reference the lowest offending subpacket; for the
last three, the highest.

This reduces the number of ACKs we end up transmitting to one per UDP
packet transmitted to reduce network loading and packet parsing.

Fixes: 5d7edbc9231e ("rxrpc: Get rid of the Rx ring")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Reviewed-by: Jeffrey Altman <jaltman@auristor.com <mailto:jaltman@auristor.com>>
Link: https://lore.kernel.org/r/20240503150749.1001323-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/input.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index f7304e06aadca..5dfda1ac51dda 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -9,6 +9,17 @@
 
 #include "ar-internal.h"
 
+/* Override priority when generating ACKs for received DATA */
+static const u8 rxrpc_ack_priority[RXRPC_ACK__INVALID] = {
+	[RXRPC_ACK_IDLE]		= 1,
+	[RXRPC_ACK_DELAY]		= 2,
+	[RXRPC_ACK_REQUESTED]		= 3,
+	[RXRPC_ACK_DUPLICATE]		= 4,
+	[RXRPC_ACK_EXCEEDS_WINDOW]	= 5,
+	[RXRPC_ACK_NOSPACE]		= 6,
+	[RXRPC_ACK_OUT_OF_SEQUENCE]	= 7,
+};
+
 static void rxrpc_proto_abort(struct rxrpc_call *call, rxrpc_seq_t seq,
 			      enum rxrpc_abort_reason why)
 {
@@ -366,7 +377,7 @@ static void rxrpc_input_queue_data(struct rxrpc_call *call, struct sk_buff *skb,
  * Process a DATA packet.
  */
 static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
-				 bool *_notify)
+				 bool *_notify, rxrpc_serial_t *_ack_serial, int *_ack_reason)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct sk_buff *oos;
@@ -419,8 +430,6 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 		/* Send an immediate ACK if we fill in a hole */
 		else if (!skb_queue_empty(&call->rx_oos_queue))
 			ack_reason = RXRPC_ACK_DELAY;
-		else
-			call->ackr_nr_unacked++;
 
 		window++;
 		if (after(window, wtop)) {
@@ -498,12 +507,16 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 	}
 
 send_ack:
-	if (ack_reason >= 0)
-		rxrpc_send_ACK(call, ack_reason, serial,
-			       rxrpc_propose_ack_input_data);
-	else
-		rxrpc_propose_delay_ACK(call, serial,
-					rxrpc_propose_ack_input_data);
+	if (ack_reason >= 0) {
+		if (rxrpc_ack_priority[ack_reason] > rxrpc_ack_priority[*_ack_reason]) {
+			*_ack_serial = serial;
+			*_ack_reason = ack_reason;
+		} else if (rxrpc_ack_priority[ack_reason] == rxrpc_ack_priority[*_ack_reason] &&
+			   ack_reason == RXRPC_ACK_REQUESTED) {
+			*_ack_serial = serial;
+			*_ack_reason = ack_reason;
+		}
+	}
 }
 
 /*
@@ -514,9 +527,11 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 	struct rxrpc_jumbo_header jhdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb), *jsp;
 	struct sk_buff *jskb;
+	rxrpc_serial_t ack_serial = 0;
 	unsigned int offset = sizeof(struct rxrpc_wire_header);
 	unsigned int len = skb->len - offset;
 	bool notify = false;
+	int ack_reason = 0;
 
 	while (sp->hdr.flags & RXRPC_JUMBO_PACKET) {
 		if (len < RXRPC_JUMBO_SUBPKTLEN)
@@ -536,7 +551,7 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 		jsp = rxrpc_skb(jskb);
 		jsp->offset = offset;
 		jsp->len = RXRPC_JUMBO_DATALEN;
-		rxrpc_input_data_one(call, jskb, &notify);
+		rxrpc_input_data_one(call, jskb, &notify, &ack_serial, &ack_reason);
 		rxrpc_free_skb(jskb, rxrpc_skb_put_jumbo_subpacket);
 
 		sp->hdr.flags = jhdr.flags;
@@ -549,7 +564,16 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 
 	sp->offset = offset;
 	sp->len    = len;
-	rxrpc_input_data_one(call, skb, &notify);
+	rxrpc_input_data_one(call, skb, &notify, &ack_serial, &ack_reason);
+
+	if (ack_reason > 0) {
+		rxrpc_send_ACK(call, ack_reason, ack_serial,
+			       rxrpc_propose_ack_input_data);
+	} else {
+		call->ackr_nr_unacked++;
+		rxrpc_propose_delay_ACK(call, sp->hdr.serial,
+					rxrpc_propose_ack_input_data);
+	}
 	if (notify) {
 		trace_rxrpc_notify_socket(call->debug_id, sp->hdr.serial);
 		rxrpc_notify_socket(call);
-- 
2.43.0



