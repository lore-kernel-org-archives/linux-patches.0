Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A482451056;
	Tue, 16 Jun 2026 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626113; cv=none; b=IgDRQf517XfRqkq5taCB8+e/LJULD684OhBRM2SfWIPiJ2e4ai7Rj4w7RezdNvfWjCv8HkhfdgmTaFFumoOZ87OOsrKnUA12FKzQSRU3zzsgMq12W5rz7+Z03H1nHEZbZPZe5zuSueVL0XWEZciXX2NONBDWo2ant8wlsAhq6XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626113; c=relaxed/simple;
	bh=PSxsqmTZBvEdRi31CbteAUnBuzedeTOvd1tuZd1tA4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb7zNEAZXlhdcr9sS8svTBBLdzcBmqTnQSvI0tGBJM1WeBhNi75gKGKUtlsrBaLVivskwlXYnVLN98hKBsk9IXsBfvlUrXvyY05WjgRwzZEZ62dnlk4oP3NIs9HyscgU2I8sof7wwDoPah/4HpoUwruwiSf3c7FLadJRSaKBGac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtWukzA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtWukzA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E3F1F000E9;
	Tue, 16 Jun 2026 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626112;
	bh=MeNTaO4byxvabOY6OxHZs0mR0TZrCeNwGa0VEULHMfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtWukzA2H5qY7YmhuKwc9cjw7xTBVV4ZRmArM7PXtCt/QKyhcTUdEst5aau7HsYrp
	 wY+5gJcPQafGF956yE4UsPKFZY9lmq/+xYq1RXj31qhvpm6QSCNix2oPDt8s4mS88N
	 6sjrp86jLtKn6OGUC83uCf3vRhC5cfWQhnRUvqdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	stable@kernel.org
Subject: [PATCH 6.18 266/325] rxrpc: Fix the ACK parser to extract the SACK table for parsing
Date: Tue, 16 Jun 2026 20:31:02 +0530
Message-ID: <20260616145111.888384892@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 333b6d5bb9f87827ac2639c737bf9613dbae7253 upstream.

Fix modification of the received skbuff in rxrpc_input_soft_acks() and a
potential incorrect access of the buffer in a fragmented UDP packet (the
packet would probably have to be deliberately pre-generated as fragmented)
when AF_RXRPC tries to extract the contents of the SACK table by copying
out the contents of the SACK table into a buffer before attempting to parse

AF_RXRPC assumes that it can just call skb_condense() and then validly
access the SACK table from skb->data and that it will be a flat buffer -
but skb_condense() can silently fail to do anything under some
circumstances.

Note that whilst rxrpc_input_soft_acks() should be able to parse extended
ACKs, the rest of AF_RXRPC doesn't currently support that.

Further, there's then no need to call skb_condense() in rxrpc_input_ack(),
so don't.

Fixes: d57a3a151660 ("rxrpc: Save last ACK's SACK table rather than marking txbufs")
Reported-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://lore.kernel.org/r/20260513180907.2061972-1-michael.bommarito@gmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
cc: stable@kernel.org
Link: https://patch.msgid.link/105362.1780573560@warthog.procyon.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -963,23 +963,34 @@ static void rxrpc_input_soft_acks(struct
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_txqueue *tq = call->tx_queue;
 	unsigned long extracted = ~0UL;
-	unsigned int nr = 0;
+	unsigned int nr = 0, nsack;
 	rxrpc_seq_t seq = call->acks_hard_ack + 1;
 	rxrpc_seq_t lowest_nak = seq + sp->ack.nr_acks;
-	u8 *acks = skb->data + sizeof(struct rxrpc_wire_header) + sizeof(struct rxrpc_ackpacket);
+	u8 sack[256] __aligned(sizeof(unsigned long));
+	u8 *acks = sack;
 
 	_enter("%x,%x,%u", tq->qbase, seq, sp->ack.nr_acks);
 
 	while (after(seq, tq->qbase + RXRPC_NR_TXQUEUE - 1))
 		tq = tq->next;
 
+	/* Extract an individual SACK table.  A normal SACK table is up to 255
+	 * bytes with 1 ACK flag per byte, but an extended SACK table can be up
+	 * to 256 bytes with up to 8 ACK/NACK flags per byte.  The ACK flags go
+	 * across all bit 0's then all bit 1's, then all bit 2's, ...
+	 */
+	memset(sack, 0, sizeof(sack));
+	nsack = umin(sp->ack.nr_acks, 256);
+	if (skb_copy_bits(skb,
+			  sizeof(struct rxrpc_wire_header) + sizeof(struct rxrpc_ackpacket),
+			  sack, nsack) < 0)
+		return;
+
 	for (unsigned int i = 0; i < sp->ack.nr_acks; i++) {
 		/* Decant ACKs until we hit a txqueue boundary. */
+		if ((i & 255) == 0)
+			acks = sack;
 		shiftr_adv_rotr(acks, extracted);
-		if (i == 256) {
-			acks -= i;
-			i = 0;
-		}
 		seq++;
 		nr++;
 		if ((seq & RXRPC_TXQ_MASK) != 0)
@@ -1117,9 +1128,6 @@ static void rxrpc_input_ack(struct rxrpc
 	    skb_copy_bits(skb, ioffset, &trailer, sizeof(trailer)) < 0)
 		return rxrpc_proto_abort(call, 0, rxrpc_badmsg_short_ack_trailer);
 
-	if (nr_acks > 0)
-		skb_condense(skb);
-
 	call->acks_latest_ts = ktime_get_real();
 	call->acks_hard_ack = hard_ack;
 	call->acks_prev_seq = prev_pkt;


