Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9A021B191;
	Sat, 30 May 2026 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165601; cv=none; b=KmQt+idG+Jj521DmSjwi0tG+rrF3pPgeeVtDCZ4x0Q7B320yAwvZg692RfYNjq+QzB8Xfh6+ciSyOdoBzEn6YmOPl5raSZ71oE7afDGDrJngxEilCkLTfV00cEmj0IVPdAssL+7wjukwg/b99RnVqzVlNNW/2v0iALeACRHtLUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165601; c=relaxed/simple;
	bh=0GGQybIbDuHV0e1g6Xtmj0yfAOrM1qg1PPU9d7+pRgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxSLR1DXJGT+YrmBXGvYAsI0bvxRq91ZCHoI7ya7ldXKp6Tdv1841DYqmw2r0ZXjnOpYzrHzA5rjaGamJ4/V/RFGyrxSn+FVvIshBu/3eOwhMrJo1RG0n9zsFaJ2Vc7LU00OA3lcsf2ngZQoAKg3bwcZsJFmM3GlQFoXH6uxpyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdvja57A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdvja57A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925A51F00893;
	Sat, 30 May 2026 18:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165600;
	bh=6LPSTCjzGrKlG8nHtKDD2XY2Pkh2wXKmvPF4ZgqItOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdvja57A8rcg11Ol5R3yZ5cp0157YEGtFr65GMto1pOHUMSShyR4tC8HIcFadT2r/
	 1ZWkgKgff9vMeYsVSlUV0pAtwGvMqg1k/r1aKZVJZ054x31hrfclPiAH2Ob8x6/e5G
	 JTUfGg6FbJ9kXUkWwiyDSNELmWOpiInHqvdtFrNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith <faith@zellic.io>,
	Pumpkin Chang <pumpkin@devco.re>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jay Wang <wanjay@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/589] rxrpc: Fix recvmsg() unconditional requeue
Date: Sat, 30 May 2026 18:00:06 +0200
Message-ID: <20260530160228.053955055@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2c28769a51deb6022d7fbd499987e237a01dd63a ]

If rxrpc_recvmsg() fails because MSG_DONTWAIT was specified but the call
at the front of the recvmsg queue already has its mutex locked, it
requeues the call - whether or not the call is already queued.  The call
may be on the queue because MSG_PEEK was also passed and so the call was
not dequeued or because the I/O thread requeued it.

The unconditional requeue may then corrupt the recvmsg queue, leading to
things like UAFs or refcount underruns.

Fix this by only requeuing the call if it isn't already on the queue -
and moving it to the front if it is already queued.  If we don't queue
it, we have to put the ref we obtained by dequeuing it.

Also, MSG_PEEK doesn't dequeue the call so shouldn't call
rxrpc_notify_socket() for the call if we didn't use up all the data on
the queue, so fix that also.

Fixes: 540b1c48c37a ("rxrpc: Fix deadlock between call creation and sendmsg/recvmsg")
Reported-by: Faith <faith@zellic.io>
Reported-by: Pumpkin Chang <pumpkin@devco.re>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org
[Adapted to 5.10: use write_lock_bh/write_unlock_bh, trace_rxrpc_call
 directly for see-call tracing, 5.10 trace enum naming convention, and
 added entries to both plain enum and EM() macro list.]
Signed-off-by: Jay Wang <wanjay@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  8 ++++++++
 net/rxrpc/recvmsg.c          | 22 ++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 221856f2d295c..6cde10ae4445d 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -93,9 +93,13 @@ enum rxrpc_call_trace {
 	rxrpc_call_put_notimer,
 	rxrpc_call_put_timer,
 	rxrpc_call_put_userid,
+	rxrpc_call_put_recvmsg_peek_nowait,
 	rxrpc_call_queued,
 	rxrpc_call_queued_ref,
 	rxrpc_call_release,
+	rxrpc_call_see_recvmsg_requeue,
+	rxrpc_call_see_recvmsg_requeue_first,
+	rxrpc_call_see_recvmsg_requeue_move,
 	rxrpc_call_seen,
 };
 
@@ -291,9 +295,13 @@ enum rxrpc_tx_point {
 	EM(rxrpc_call_put_notimer,		"PnT") \
 	EM(rxrpc_call_put_timer,		"PTM") \
 	EM(rxrpc_call_put_userid,		"Pus") \
+	EM(rxrpc_call_put_recvmsg_peek_nowait,	"PpN") \
 	EM(rxrpc_call_queued,			"QUE") \
 	EM(rxrpc_call_queued_ref,		"QUR") \
 	EM(rxrpc_call_release,			"RLS") \
+	EM(rxrpc_call_see_recvmsg_requeue,	"SrQ") \
+	EM(rxrpc_call_see_recvmsg_requeue_first,"SrF") \
+	EM(rxrpc_call_see_recvmsg_requeue_move,	"SrM") \
 	E_(rxrpc_call_seen,			"SEE")
 
 #define rxrpc_transmit_traces \
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 7878267739378..301b8acf78f55 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -607,7 +607,8 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 		if (after(call->rx_top, call->rx_hard_ack) &&
 		    call->rxtx_buffer[(call->rx_hard_ack + 1) & RXRPC_RXTX_BUFF_MASK])
-			rxrpc_notify_socket(call);
+			if (!(flags & MSG_PEEK))
+				rxrpc_notify_socket(call);
 		break;
 	default:
 		ret = 0;
@@ -642,11 +643,24 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 error_requeue_call:
 	if (!(flags & MSG_PEEK)) {
 		write_lock_bh(&rx->recvmsg_lock);
-		list_add(&call->recvmsg_link, &rx->recvmsg_q);
-		write_unlock_bh(&rx->recvmsg_lock);
+		if (list_empty(&call->recvmsg_link)) {
+			list_add(&call->recvmsg_link, &rx->recvmsg_q);
+			trace_rxrpc_call(call->debug_id,
+					 rxrpc_call_see_recvmsg_requeue,
+					 refcount_read(&call->ref),
+					 __builtin_return_address(0), NULL);
+			write_unlock_bh(&rx->recvmsg_lock);
+		} else if (list_is_first(&call->recvmsg_link, &rx->recvmsg_q)) {
+			write_unlock_bh(&rx->recvmsg_lock);
+			rxrpc_put_call(call, rxrpc_call_see_recvmsg_requeue_first);
+		} else {
+			list_move(&call->recvmsg_link, &rx->recvmsg_q);
+			write_unlock_bh(&rx->recvmsg_lock);
+			rxrpc_put_call(call, rxrpc_call_see_recvmsg_requeue_move);
+		}
 		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0, 0, 0, 0);
 	} else {
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg_peek_nowait);
 	}
 error_no_call:
 	release_sock(&rx->sk);
-- 
2.53.0



