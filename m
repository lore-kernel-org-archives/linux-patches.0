Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BBB3033F4;
	Wed, 28 Jan 2026 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615747; cv=none; b=nTtKcHCk+jjmwBa+a+LC7UdkCXpD4mVOSxnsZh56vqEd/TUubme22PDv9gjzaeg2VoiMF4N/XaBCUUiuUfQWHqcEhE2APhc5yO2MgptVSlkgCpno2BLx/oWfjCiTYo3niQVCR2gfIMgREvluYiQKz2C5jyaOmY1g4rUOHQciAP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615747; c=relaxed/simple;
	bh=CnyOi5V25s2N7gskAcNF8EsCYV9QC1GdlAdsUB6cFRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mazaYRNRvjMnf3AT6MGmKuu79uvC1+AtUIcCwTXaIa6AI2ajd/cjaQk1dGmzz16b5Tl+9QaeKutCpZATsIII+pOl6aVbMQ2P1AkNXkz+CE4wuDRnAoBK/XINe5eG7jIXkc1nuLuFK6/WLSx37C5scUWs0CnMpk1bePiBbYH/zZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P69JdpNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P69JdpNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17389C4CEF1;
	Wed, 28 Jan 2026 15:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615746;
	bh=CnyOi5V25s2N7gskAcNF8EsCYV9QC1GdlAdsUB6cFRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P69JdpNc0ixJbm31Fy3/pRZPKZivfrHl5GrSeOu0j3rsNBHxfzYCAeQ/88CCR3SwB
	 5V1zRMWEZzL+l+b86/mtfRcK6G9DU3DXjlHzv2pjUaka4QChMtGJJ3J5GmvKg7XKEZ
	 bsEmDCNcChEp8DYeevAnZBUydiFYpcsnKbzyCXho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith <faith@zellic.io>,
	Pumpkin Chang <pumpkin@devco.re>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Nir Ohfeld <niro@wiz.io>,
	Willy Tarreau <w@1wt.eu>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 069/227] rxrpc: Fix recvmsg() unconditional requeue
Date: Wed, 28 Jan 2026 16:21:54 +0100
Message-ID: <20260128145346.823162493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

commit 2c28769a51deb6022d7fbd499987e237a01dd63a upstream.

If rxrpc_recvmsg() fails because MSG_DONTWAIT was specified but the call at
the front of the recvmsg queue already has its mutex locked, it requeues
the call - whether or not the call is already queued.  The call may be on
the queue because MSG_PEEK was also passed and so the call was not dequeued
or because the I/O thread requeued it.

The unconditional requeue may then corrupt the recvmsg queue, leading to
things like UAFs or refcount underruns.

Fix this by only requeuing the call if it isn't already on the queue - and
moving it to the front if it is already queued.  If we don't queue it, we
have to put the ref we obtained by dequeuing it.

Also, MSG_PEEK doesn't dequeue the call so shouldn't call
rxrpc_notify_socket() for the call if we didn't use up all the data on the
queue, so fix that also.

Fixes: 540b1c48c37a ("rxrpc: Fix deadlock between call creation and sendmsg/recvmsg")
Reported-by: Faith <faith@zellic.io>
Reported-by: Pumpkin Chang <pumpkin@devco.re>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Marc Dionne <marc.dionne@auristor.com>
cc: Nir Ohfeld <niro@wiz.io>
cc: Willy Tarreau <w@1wt.eu>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/95163.1768428203@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    4 ++++
 net/rxrpc/recvmsg.c          |   19 +++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -322,6 +322,7 @@
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
 	EM(rxrpc_call_put_poke,			"PUT poke    ") \
 	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
+	EM(rxrpc_call_put_recvmsg_peek_nowait,	"PUT peek-nwt") \
 	EM(rxrpc_call_put_release_recvmsg_q,	"PUT rls-rcmq") \
 	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
@@ -340,6 +341,9 @@
 	EM(rxrpc_call_see_input,		"SEE input   ") \
 	EM(rxrpc_call_see_notify_released,	"SEE nfy-rlsd") \
 	EM(rxrpc_call_see_recvmsg,		"SEE recvmsg ") \
+	EM(rxrpc_call_see_recvmsg_requeue,	"SEE recv-rqu") \
+	EM(rxrpc_call_see_recvmsg_requeue_first, "SEE recv-rqF") \
+	EM(rxrpc_call_see_recvmsg_requeue_move,	"SEE recv-rqM") \
 	EM(rxrpc_call_see_release,		"SEE release ") \
 	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
 	EM(rxrpc_call_see_waiting_call,		"SEE q-conn  ") \
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -518,7 +518,8 @@ try_again:
 	if (rxrpc_call_has_failed(call))
 		goto call_failed;
 
-	if (!skb_queue_empty(&call->recvmsg_queue))
+	if (!(flags & MSG_PEEK) &&
+	    !skb_queue_empty(&call->recvmsg_queue))
 		rxrpc_notify_socket(call);
 	goto not_yet_complete;
 
@@ -549,11 +550,21 @@ error_unlock_call:
 error_requeue_call:
 	if (!(flags & MSG_PEEK)) {
 		spin_lock_irq(&rx->recvmsg_lock);
-		list_add(&call->recvmsg_link, &rx->recvmsg_q);
-		spin_unlock_irq(&rx->recvmsg_lock);
+		if (list_empty(&call->recvmsg_link)) {
+			list_add(&call->recvmsg_link, &rx->recvmsg_q);
+			rxrpc_see_call(call, rxrpc_call_see_recvmsg_requeue);
+			spin_unlock_irq(&rx->recvmsg_lock);
+		} else if (list_is_first(&call->recvmsg_link, &rx->recvmsg_q)) {
+			spin_unlock_irq(&rx->recvmsg_lock);
+			rxrpc_put_call(call, rxrpc_call_see_recvmsg_requeue_first);
+		} else {
+			list_move(&call->recvmsg_link, &rx->recvmsg_q);
+			spin_unlock_irq(&rx->recvmsg_lock);
+			rxrpc_put_call(call, rxrpc_call_see_recvmsg_requeue_move);
+		}
 		trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_requeue, 0);
 	} else {
-		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg_peek_nowait);
 	}
 error_no_call:
 	release_sock(&rx->sk);


