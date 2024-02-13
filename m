Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FFB5F54E;
	Tue, 13 Feb 2024 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845398; cv=none; b=j771/fWEvbX3asihBbbGVu2UPdT1AOeUN1Ga4q9VLhcTAJAabd1J3l5RydBlo+L/QLUEgxr09USJLSngWPcSLhpf1KtV6Ol0v3on8SjFKq5CaNOB0E4tUGX3yqmhelnAbfVIxaqnPzf5uVdjigtDJBRFUVSonp3uiLV/uOeuTKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845398; c=relaxed/simple;
	bh=4bF9ZFUbg6oXkB+jqIL6zw+SN7KlEnqXk2StyX9Tqpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nu7Janxr5lLXx3RJC/2rjud+r9JNc7VmMMzoPgGkyJSqQQ6HdfT1rfL9kZfHvCQkq+9Zkvw79PEsal3QkH6ipA3RDOiDKlYAKqcvatZxjy/tOdzFm/eloNNuuxW1aNA0FgpVrNIw8XU5F/p/ej9MFpWAqe+7QGZYdHaHuu/8HaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0WYpsIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0WYpsIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C5BC433F1;
	Tue, 13 Feb 2024 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845398;
	bh=4bF9ZFUbg6oXkB+jqIL6zw+SN7KlEnqXk2StyX9Tqpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0WYpsIe3AJx+iaDxaQdAxzVbbpUvbIvboW/4az97gM/qqw4DwQpv8PCjCeOBZqc+
	 mK457/nshE2c/WWaEUrtWt4txk4BCwES2CwONPqT60UhZvHn2m0TPuG87CHxWTJe8Q
	 dmC/u4tbYmHMUEl46G46OYRaCrb6xYlpY6bUvRUM=
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
Subject: [PATCH 6.6 066/121] rxrpc: Fix delayed ACKs to not set the reference serial number
Date: Tue, 13 Feb 2024 18:21:15 +0100
Message-ID: <20240213171854.922021478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

[ Upstream commit e7870cf13d20f56bfc19f9c3e89707c69cf104ef ]

Fix the construction of delayed ACKs to not set the reference serial number
as they can't be used as an RTT reference.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
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
 net/rxrpc/ar-internal.h | 1 -
 net/rxrpc/call_event.c  | 6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 668fdc94b299..f6375772fa93 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -692,7 +692,6 @@ struct rxrpc_call {
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	u16			ackr_sack_base;	/* Starting slot in SACK table ring */
-	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
 	rxrpc_seq_t		ackr_window;	/* Base of SACK window */
 	rxrpc_seq_t		ackr_wtop;	/* Base of SACK window */
 	unsigned int		ackr_nr_unacked; /* Number of unacked packets */
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index e363f21a2014..c61efe08695d 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -43,8 +43,6 @@ void rxrpc_propose_delay_ACK(struct rxrpc_call *call, rxrpc_serial_t serial,
 	unsigned long expiry = rxrpc_soft_ack_delay;
 	unsigned long now = jiffies, ack_at;
 
-	call->ackr_serial = serial;
-
 	if (rxrpc_soft_ack_delay < expiry)
 		expiry = rxrpc_soft_ack_delay;
 	if (call->peer->srtt_us != 0)
@@ -373,7 +371,6 @@ static void rxrpc_send_initial_ping(struct rxrpc_call *call)
 bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	unsigned long now, next, t;
-	rxrpc_serial_t ackr_serial;
 	bool resend = false, expired = false;
 	s32 abort_code;
 
@@ -423,8 +420,7 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_ack, now);
 		cmpxchg(&call->delay_ack_at, t, now + MAX_JIFFY_OFFSET);
-		ackr_serial = xchg(&call->ackr_serial, 0);
-		rxrpc_send_ACK(call, RXRPC_ACK_DELAY, ackr_serial,
+		rxrpc_send_ACK(call, RXRPC_ACK_DELAY, 0,
 			       rxrpc_propose_ack_ping_for_lost_ack);
 	}
 
-- 
2.43.0



