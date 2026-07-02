Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C3633D4F0;
	Thu,  2 Jul 2026 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010801; cv=none; b=SW+23JxI7ZneslKmtlF88Hhlp/NjKuzV+bVymx+0beSrJolQDQlUX+7W2qH2flMmq91SQi8Y/uXm9T7g4wkGW8u00SRdYpdyOxwMLbznCBZkhN/KrpuqppJXC4ivcc9j96OioSVNUmgeZNnjbpltzY3VpigSMeEOWlaSXrnD468=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010801; c=relaxed/simple;
	bh=iuTg+r2aJb+oRyO/DoJzogbNTbF2ttFca0LZWep7glg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+dHySEwnYHM0LPL8ZqBueXdCLeKZY0xLbr5/t1j097DQNOGpkEl7xPKs8rJ8v0UkiGNEfUvfVpXPupEI3HzEyB2HBNm8ElljOky+/JEDHdBJd180c6fV/vdXZZYMU5Pv0m4dI3o0CWfyQuCFz5ytsZZ0dZM5/k8GjDpMCLeYps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+NF5mtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+NF5mtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25291F000E9;
	Thu,  2 Jul 2026 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010800;
	bh=UM0pK7gwBmjJaw0CK9vEfDTNkC2XC4JEI2BTkGaTyfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+NF5mtbKT1zcDglTmqIXncfUjP4HdQ2dbt5QyGFTfgLX/4fXPeTwlFfs3WWAFREL
	 p80ZJfP86Cpq6/8W0Cp13pToS/zFvG2lBvHI1gaJVI3n3LiPWsjK+84iXfZ0SxckOP
	 0mhSCtKnsNK4OYgLuapM4suIKrP+jaeZx5nXcZ0w=
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
Subject: [PATCH 6.6 040/175] rxrpc: Fix the ACK parser to extract the SACK table for parsing
Date: Thu,  2 Jul 2026 18:19:01 +0200
Message-ID: <20260702155116.642120945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/rxrpc/input.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -781,7 +781,18 @@ static void rxrpc_input_soft_acks(struct
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	unsigned int i, old_nacks = 0;
 	rxrpc_seq_t lowest_nak = seq + sp->nr_acks;
-	u8 *acks = skb->data + sizeof(struct rxrpc_wire_header) + sizeof(struct rxrpc_ackpacket);
+	u8 sack[256] __aligned(sizeof(unsigned long));
+	u8 *acks = sack;
+
+	/* Extract the SACK table into a flat buffer rather than accessing it
+	 * directly through skb->data, which is not guaranteed to be linear for
+	 * a fragmented packet (skb_condense() can silently fail to linearise
+	 * it).
+	 */
+	if (skb_copy_bits(skb,
+			  sizeof(struct rxrpc_wire_header) + sizeof(struct rxrpc_ackpacket),
+			  sack, umin(sp->nr_acks, sizeof(sack))) < 0)
+		return;
 
 	for (i = 0; i < sp->nr_acks; i++) {
 		if (acks[i] == RXRPC_ACK_TYPE_ACK) {


