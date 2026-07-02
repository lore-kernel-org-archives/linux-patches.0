Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2AD33B6D1;
	Thu,  2 Jul 2026 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010302; cv=none; b=P4/Naewz8msp8/ZcHSoooE8ovpmAZWMBGMYzq/ygtSmdqdoH/6hdFXrb3qStDWHUp/9P5Er/XdsREXx6ll4dM+S5Xm1NJfYcxcHvkw5HdGxl4NSBwZpsMN3J1DsJms6sbK0W0VFMuZA5ESJ38OlQHtqMCPOa3NmkqBW7wPGK1Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010302; c=relaxed/simple;
	bh=YbkMwQXx1OlomRdJyOYIG0eztRSycrAl4dbTUXUEekQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHZWw1uNogj2JFedD6KGcPTd3Qu/euVk8x8jE66vWySkHZasDs0QZTHg4QlZiuUAG6k6XfjP4K5hGmDAPal6ocTeI+2sCADv7cd7OC7VHf9dOhzcHM7wCWVI872WwQbafRfDTFSoewwWA6lUok94DQOZLgSTS4tojPhU0TsAE9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM3nv1+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM3nv1+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAA31F000E9;
	Thu,  2 Jul 2026 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010301;
	bh=PtyvGxEYI8TFaymocx5DWgYaitw+9gSKjwsASF8ZahI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EM3nv1+fJUISf+D7qqcqkrUIp1dyuUh76etWuiTIWqvs+SCoQhp+SX2iMMYYYqbkj
	 Yclaxk/SaNG0uBdgdAP9Ar+BXUm18X18/yYznCzlniJewqGV1akmZkMVjN+DbKVCHg
	 80dpTeUnZiCH5BzGnp+zoCsH0J2CG0IeGFW78VDU=
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
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/204] rxrpc: Fix the ACK parser to extract the SACK table for parsing
Date: Thu,  2 Jul 2026 18:18:32 +0200
Message-ID: <20260702155119.813722666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

[ Upstream commit 333b6d5bb9f87827ac2639c737bf9613dbae7253 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -775,9 +775,23 @@ static void rxrpc_input_soft_acks(struct
 				  rxrpc_seq_t since)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	unsigned int i, old_nacks = 0;
+	unsigned int i, old_nacks = 0, nsack;
 	rxrpc_seq_t lowest_nak = seq + sp->ack.nr_acks;
-	u8 *acks = skb->data + sizeof(struct rxrpc_wire_header) + sizeof(struct rxrpc_ackpacket);
+	u8 sack[256] __aligned(sizeof(unsigned long));
+	u8 *acks = sack;
+
+	/* AF_RXRPC assumes that it can access the SACK table directly from
+	 * skb->data as a flat buffer, but the skb may be non-linear (e.g. a
+	 * fragmented UDP packet) and skb_condense() can silently fail to
+	 * linearise it.  Copy the SACK table out into a local buffer before
+	 * parsing it.
+	 */
+	memset(sack, 0, sizeof(sack));
+	nsack = umin(sp->ack.nr_acks, 256);
+	if (skb_copy_bits(skb,
+			  sizeof(struct rxrpc_wire_header) + sizeof(struct rxrpc_ackpacket),
+			  sack, nsack) < 0)
+		return;
 
 	for (i = 0; i < sp->ack.nr_acks; i++) {
 		if (acks[i] == RXRPC_ACK_TYPE_ACK) {
@@ -934,9 +948,6 @@ static void rxrpc_input_ack(struct rxrpc
 	    skb_copy_bits(skb, ioffset, &trailer, sizeof(trailer)) < 0)
 		return rxrpc_proto_abort(call, 0, rxrpc_badmsg_short_ack_trailer);
 
-	if (nr_acks > 0)
-		skb_condense(skb);
-
 	if (call->cong_last_nack) {
 		since = rxrpc_input_check_prev_ack(call, &summary, first_soft_ack);
 		rxrpc_free_skb(call->cong_last_nack, rxrpc_skb_put_last_nack);


