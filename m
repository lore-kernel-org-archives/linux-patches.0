Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972BF33F8A2;
	Sat, 30 May 2026 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163106; cv=none; b=Uqaq67FVlBFa0q+6n0zYJoE3x+jnJfsW0TS1aOSAL4+QMbxHwoWsVYCkc3Fe9SuwfA6C1Y0Tce3dHG6VNxCYQsh4tVkQMEswOSVPsisWeXnH3HeJoBHJzw2f2hjN/77Wt+SOKDrmSdLOqhV8PCusOmMo+U6ddwf8lzz2IbAbI6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163106; c=relaxed/simple;
	bh=a35hfQEFGCRu2z5EKFLZEDIKYd1tVzZTA3/tbkpyT+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6ZN6gvzmrMpwBjh0jpce5JSasVaIY2G/ytP0gcCaY1pEPnDG3StYIECk9SQ2EWu5A1fGz8DnK6aWvH+DcmCmfPLu6TnATtd6D3bRrF0dskaSehGGq6lnSpe1H3AD7BRgSNqlBZVw6T5C5xYWYDdo7SpB3XmZlvHBsTjQ5cGNWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAeHeEAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAeHeEAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFBA1F00893;
	Sat, 30 May 2026 17:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163105;
	bh=0lZIkks0Vv3nr9Jm6ZTMOVMZ3frievWaBACBvtGKtl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAeHeEACRnuH/KIu5ExQqcKc6iWzLzeHfwgjb3DpOIiez3eEsgMxV5lwxj3xQSqqU
	 v4KN0suyvLiU6tCBlYTGMhZXALlpwEP+H8GxaqzeA9J8Ykj7hxHbOW57NYJar8ahJv
	 NH3azfxuwNXbD5XfmX4onXI3QX4Wz0kgfuVMBLVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith <faith@zellic.io>,
	Pumpkin Chang <pumpkin@devco.re>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jay Wang <wanjay@amazon.com>
Subject: [PATCH 5.15 156/776] rxrpc: Fix recvmsg() unconditional requeue
Date: Sat, 30 May 2026 17:57:50 +0200
Message-ID: <20260530160244.500264469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[Adapted to 5.15: use write_lock_bh/write_unlock_bh, trace_rxrpc_call
 directly for see-call tracing, 5.15 trace enum naming convention, and
 added entries to both plain enum and EM() macro list.]
Signed-off-by: Jay Wang <wanjay@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    8 ++++++++
 net/rxrpc/recvmsg.c          |   22 ++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

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
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -607,7 +607,8 @@ try_again:
 
 		if (after(call->rx_top, call->rx_hard_ack) &&
 		    call->rxtx_buffer[(call->rx_hard_ack + 1) & RXRPC_RXTX_BUFF_MASK])
-			rxrpc_notify_socket(call);
+			if (!(flags & MSG_PEEK))
+				rxrpc_notify_socket(call);
 		break;
 	default:
 		ret = 0;
@@ -642,11 +643,24 @@ error_unlock_call:
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


