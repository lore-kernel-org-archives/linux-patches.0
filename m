Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6C02EB5CA;
	Tue, 22 Jul 2025 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193651; cv=none; b=cM45CxBYSnsjiKQMdG8PIRT5rd4MobAlZrRtx4z3OQEoeyjRgwlrcY+dP+qCpfqG3e6BgpgRphywkCEOFTSxmR3NrJ07ctq3H/8uCd8C/QpQT9VDikZPpUjgUGHZQtGAybYtzVx7LoeWDFTN/q59Q/Hbx3wPeVYOfDrUb9Qb+YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193651; c=relaxed/simple;
	bh=lcG0dZJrQsUHcURR7fArHLhxd6qgFu3n624JVh0mRnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFZClXFydHaPOvS3+plueZeh8y2fKqw7wU83HHWz6q2VBRhuJT9J2jOPjo/rDBb1zZ/xP7GnPZTpY3DYVDz/XhhxKjvL6Q9BReDuWxeDwgLUz4Ggv3gtZEk4+f/gZv7cTN29YZIlqOueExdWdALtdgHMnR8+hvIginyspl0C12o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obuGRWiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obuGRWiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5735C4CEEB;
	Tue, 22 Jul 2025 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193651;
	bh=lcG0dZJrQsUHcURR7fArHLhxd6qgFu3n624JVh0mRnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obuGRWiRaFLElRD2FJoUC7vFauRgsUypT6/VaufRF4VrTM7mwtYZmUUc/aRvCUEjm
	 EYa6xKpuQms9yzfWxw0YoAmkdqe0rDJQRcAH9gEC6HRMnOKt9IJHgG5SlxrqTcTkK1
	 RBmLYxQE6ZTPSOUPqk/kuhE0yJW3bCZDODdcBC/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 157/187] rxrpc: Fix recv-recv race of completed call
Date: Tue, 22 Jul 2025 15:45:27 +0200
Message-ID: <20250722134351.628198102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 962fb1f651c2cf2083e0c3ef53ba69e3b96d3fbc ]

If a call receives an event (such as incoming data), the call gets placed
on the socket's queue and a thread in recvmsg can be awakened to go and
process it.  Once the thread has picked up the call off of the queue,
further events will cause it to be requeued, and once the socket lock is
dropped (recvmsg uses call->user_mutex to allow the socket to be used in
parallel), a second thread can come in and its recvmsg can pop the call off
the socket queue again.

In such a case, the first thread will be receiving stuff from the call and
the second thread will be blocked on call->user_mutex.  The first thread
can, at this point, process both the event that it picked call for and the
event that the second thread picked the call for and may see the call
terminate - in which case the call will be "released", decoupling the call
from the user call ID assigned to it (RXRPC_USER_CALL_ID in the control
message).

The first thread will return okay, but then the second thread will wake up
holding the user_mutex and, if it sees that the call has been released by
the first thread, it will BUG thusly:

	kernel BUG at net/rxrpc/recvmsg.c:474!

Fix this by just dequeuing the call and ignoring it if it is seen to be
already released.  We can't tell userspace about it anyway as the user call
ID has become stale.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Reported-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250717074350.3767366-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  3 +++
 net/rxrpc/call_accept.c      |  1 +
 net/rxrpc/recvmsg.c          | 19 +++++++++++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index cad50d91077ef..a785b177c6927 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -283,12 +283,15 @@
 	EM(rxrpc_call_put_userid,		"PUT user-id ") \
 	EM(rxrpc_call_see_accept,		"SEE accept  ") \
 	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
+	EM(rxrpc_call_see_already_released,	"SEE alrdy-rl") \
 	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
 	EM(rxrpc_call_see_connected,		"SEE connect ") \
 	EM(rxrpc_call_see_conn_abort,		"SEE conn-abt") \
+	EM(rxrpc_call_see_discard,		"SEE discard ") \
 	EM(rxrpc_call_see_disconnected,		"SEE disconn ") \
 	EM(rxrpc_call_see_distribute_error,	"SEE dist-err") \
 	EM(rxrpc_call_see_input,		"SEE input   ") \
+	EM(rxrpc_call_see_recvmsg,		"SEE recvmsg ") \
 	EM(rxrpc_call_see_release,		"SEE release ") \
 	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
 	EM(rxrpc_call_see_waiting_call,		"SEE q-conn  ") \
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index bbed314b7d963..978f0c6ee3c8a 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -219,6 +219,7 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	tail = b->call_backlog_tail;
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_call *call = b->call_backlog[tail];
+		rxrpc_see_call(call, rxrpc_call_see_discard);
 		rcu_assign_pointer(call->socket, rx);
 		if (rx->discard_new_call) {
 			_debug("discard %lx", call->user_call_ID);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 32cd5f1d541db..1668495e4ae63 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -351,6 +351,16 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		goto try_again;
 	}
 
+	rxrpc_see_call(call, rxrpc_call_see_recvmsg);
+	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		rxrpc_see_call(call, rxrpc_call_see_already_released);
+		list_del_init(&call->recvmsg_link);
+		spin_unlock_irq(&rx->recvmsg_lock);
+		release_sock(&rx->sk);
+		trace_rxrpc_recvmsg(call->debug_id, rxrpc_recvmsg_unqueue, 0);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		goto try_again;
+	}
 	if (!(flags & MSG_PEEK))
 		list_del_init(&call->recvmsg_link);
 	else
@@ -374,8 +384,13 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	release_sock(&rx->sk);
 
-	if (test_bit(RXRPC_CALL_RELEASED, &call->flags))
-		BUG();
+	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		rxrpc_see_call(call, rxrpc_call_see_already_released);
+		mutex_unlock(&call->user_mutex);
+		if (!(flags & MSG_PEEK))
+			rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		goto try_again;
+	}
 
 	if (test_bit(RXRPC_CALL_HAS_USERID, &call->flags)) {
 		if (flags & MSG_CMSG_COMPAT) {
-- 
2.39.5



