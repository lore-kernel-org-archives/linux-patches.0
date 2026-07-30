Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD03A411691;
	Thu, 30 Jul 2026 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428052; cv=none; b=q4/GH3tPHIKEGUlRb1k7v/uLeFBOuE1tjbedVg5k/B3aCuqVWCeXJ6H4T8Aa/Bvft1/EtX9lu/esrJbkMJpPNlIp/DvVZQD8ZFsjJKXZxtoDKXyp1hgqZ9u2GSRbYY+aak6IthvUt4+aJ35I/HxHm0Ja1J5fgVlJCDq/VEKHcHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428052; c=relaxed/simple;
	bh=MsXzU/WFE7Jyv9ZmK9S4sgJuiITYclIojYIUe5o60E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHgUekqHkb4gJ82HfYXePKgjylRNGXh32t//Ygz9LWUieKDof3tnuoGneOW7Lib+fBJHM6OmqwgIWevglzsf58EfgKbLazc8+T+Gww0SFhFBh1kVHRURYUwZLKR6dGsGcuVBrxj7SdJpRB2oeVOIdfKJ67q+4g8D3r3XaLiVm88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kd/eIdVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kd/eIdVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B85B1F000E9;
	Thu, 30 Jul 2026 16:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428050;
	bh=msIxa8rl9K1nZvZLUxJ19nyBKNmqNNpV7RIrmaAefao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kd/eIdVaLnG8jmqFG9ghyj1yhNNnjHN9wxu921fpA5YEJQgn4i9EQNsRDrunrq9vk
	 PrcU6m3VTbCVNBq9oI9wpyot8pOKpOI/HTrZRzIL+Olw2OAYZXIDGcj+h+PDguKvZV
	 dMCu2oi4KcH0DVCe1Sk80Hr+ZE90/UmuUPzhNPwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 387/484] rxrpc: Fix notification vs call-release vs recvmsg
Date: Thu, 30 Jul 2026 16:14:44 +0200
Message-ID: <20260730141431.883152554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

[ Upstream commit 2fd895842d49c23137ae48252dd211e5d6d8a3ed ]

When a call is released, rxrpc takes the spinlock and removes it from
->recvmsg_q in an effort to prevent racing recvmsg() invocations from
seeing the same call.  Now, rxrpc_recvmsg() only takes the spinlock when
actually removing a call from the queue; it doesn't, however, take it in
the lead up to that when it checks to see if the queue is empty.  It *does*
hold the socket lock, which prevents a recvmsg/recvmsg race - but this
doesn't prevent sendmsg from ending the call because sendmsg() drops the
socket lock and relies on the call->user_mutex.

Fix this by firstly removing the bit in rxrpc_release_call() that dequeues
the released call and, instead, rely on recvmsg() to simply discard
released calls (done in a preceding fix).

Secondly, rxrpc_notify_socket() is abandoned if the call is already marked
as released rather than trying to be clever by setting both pointers in
call->recvmsg_link to NULL to trick list_empty().  This isn't perfect and
can still race, resulting in a released call on the queue, but recvmsg()
will now clean that up.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250717074350.3767366-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e66f8f32f501 ("rxrpc: Fix socket notification race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    3 ++-
 net/rxrpc/call_object.c      |   28 ++++++++++++----------------
 net/rxrpc/recvmsg.c          |    4 ++++
 3 files changed, 18 insertions(+), 17 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -271,10 +271,10 @@
 	EM(rxrpc_call_put_poke,			"PUT poke    ") \
 	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
 	EM(rxrpc_call_put_recvmsg_peek_nowait,	"PUT peek-nwt") \
+	EM(rxrpc_call_put_release_recvmsg_q,	"PUT rls-rcmq") \
 	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
-	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
 	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
 	EM(rxrpc_call_put_userid,		"PUT user-id ") \
 	EM(rxrpc_call_see_accept,		"SEE accept  ") \
@@ -287,6 +287,7 @@
 	EM(rxrpc_call_see_disconnected,		"SEE disconn ") \
 	EM(rxrpc_call_see_distribute_error,	"SEE dist-err") \
 	EM(rxrpc_call_see_input,		"SEE input   ") \
+	EM(rxrpc_call_see_notify_released,	"SEE nfy-rlsd") \
 	EM(rxrpc_call_see_recvmsg,		"SEE recvmsg ") \
 	EM(rxrpc_call_see_recvmsg_requeue,	"SEE recv-rqu") \
 	EM(rxrpc_call_see_recvmsg_requeue_first, "SEE recv-rqF") \
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -550,7 +550,7 @@ static void rxrpc_cleanup_ring(struct rx
 void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 {
 	struct rxrpc_connection *conn = call->conn;
-	bool put = false, putu = false;
+	bool putu = false;
 
 	_enter("{%d,%d}", call->debug_id, refcount_read(&call->ref));
 
@@ -562,23 +562,13 @@ void rxrpc_release_call(struct rxrpc_soc
 
 	rxrpc_put_call_slot(call);
 
-	/* Make sure we don't get any more notifications */
+	/* Note that at this point, the call may still be on or may have been
+	 * added back on to the socket receive queue.  recvmsg() must discard
+	 * released calls.  The CALL_RELEASED flag should prevent further
+	 * notifications.
+	 */
 	spin_lock_irq(&rx->recvmsg_lock);
-
-	if (!list_empty(&call->recvmsg_link)) {
-		_debug("unlinking once-pending call %p { e=%lx f=%lx }",
-		       call, call->events, call->flags);
-		list_del(&call->recvmsg_link);
-		put = true;
-	}
-
-	/* list_empty() must return false in rxrpc_notify_socket() */
-	call->recvmsg_link.next = NULL;
-	call->recvmsg_link.prev = NULL;
-
 	spin_unlock_irq(&rx->recvmsg_lock);
-	if (put)
-		rxrpc_put_call(call, rxrpc_call_put_unnotify);
 
 	write_lock(&rx->call_lock);
 
@@ -627,6 +617,12 @@ void rxrpc_release_calls_on_socket(struc
 		rxrpc_put_call(call, rxrpc_call_put_release_sock);
 	}
 
+	while ((call = list_first_entry_or_null(&rx->recvmsg_q,
+						struct rxrpc_call, recvmsg_link))) {
+		list_del_init(&call->recvmsg_link);
+		rxrpc_put_call(call, rxrpc_call_put_release_recvmsg_q);
+	}
+
 	_leave("");
 }
 
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -29,6 +29,10 @@ void rxrpc_notify_socket(struct rxrpc_ca
 
 	if (!list_empty(&call->recvmsg_link))
 		return;
+	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		rxrpc_see_call(call, rxrpc_call_see_notify_released);
+		return;
+	}
 
 	rcu_read_lock();
 


