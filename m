Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D760DA32;
	Tue, 22 Jul 2025 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193657; cv=none; b=tJz7iMTKeBV2PZs+1PzW8g9+Uo7zOuDbaEeL+mGOyscf84wJ/hWeQQhI1WxPZ1o8Na3qH/WEtC9smAWa42FwGuXf5PgunvTy3qPhyszLUb3rWg11YMWAV40K5htE17QXGBd7zkf1uDG7cD1C6d3NGN8Wr3Fym1Zotmsrze7szus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193657; c=relaxed/simple;
	bh=G6xO+xurCB6bkhIijEY9EovtB8CopoqLs1VgmFqzhm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbaa52m75VDRW0sKd+C17j8XUyr0MeEB9NWmum3uKLd3/jhyqHwgDni4aVCpXavWMFt6V2wzCVMSIoynu2kOjzRjv8oWdP0S9/An959tE641/WoWtJWA5aQrxW67gNn9t8gCZFn32t3IRCeqr6/5Whr2rgYsN4FC1COVQfJd9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SC2b8qRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SC2b8qRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0CCC4CEEB;
	Tue, 22 Jul 2025 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193657;
	bh=G6xO+xurCB6bkhIijEY9EovtB8CopoqLs1VgmFqzhm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC2b8qRYTtXeOmWjy5nbfHU06XQ7ByRhz1oxlb5qbd5TXZ7LxhCiqIMfGYseoEG7C
	 k24Qkt42Mjr9D8MYp++jLWC1PyrYkE4GWuSmrg3KCCLyEI0LWxB0m2HPaA7+AFasLE
	 8TQnaJRKUek2Dua1GWabwJtH6tOh3lQv0uCT0Boc=
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
Subject: [PATCH 6.15 158/187] rxrpc: Fix notification vs call-release vs recvmsg
Date: Tue, 22 Jul 2025 15:45:28 +0200
Message-ID: <20250722134351.663559015@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  3 ++-
 net/rxrpc/call_object.c      | 28 ++++++++++++----------------
 net/rxrpc/recvmsg.c          |  4 ++++
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index a785b177c6927..f2ef106b61969 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -275,10 +275,10 @@
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
 	EM(rxrpc_call_put_poke,			"PUT poke    ") \
 	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
+	EM(rxrpc_call_put_release_recvmsg_q,	"PUT rls-rcmq") \
 	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
-	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
 	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
 	EM(rxrpc_call_put_userid,		"PUT user-id ") \
 	EM(rxrpc_call_see_accept,		"SEE accept  ") \
@@ -291,6 +291,7 @@
 	EM(rxrpc_call_see_disconnected,		"SEE disconn ") \
 	EM(rxrpc_call_see_distribute_error,	"SEE dist-err") \
 	EM(rxrpc_call_see_input,		"SEE input   ") \
+	EM(rxrpc_call_see_notify_released,	"SEE nfy-rlsd") \
 	EM(rxrpc_call_see_recvmsg,		"SEE recvmsg ") \
 	EM(rxrpc_call_see_release,		"SEE release ") \
 	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index fce58be65e7cf..4be3713a5a339 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -561,7 +561,7 @@ static void rxrpc_cleanup_rx_buffers(struct rxrpc_call *call)
 void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 {
 	struct rxrpc_connection *conn = call->conn;
-	bool put = false, putu = false;
+	bool putu = false;
 
 	_enter("{%d,%d}", call->debug_id, refcount_read(&call->ref));
 
@@ -573,23 +573,13 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
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
 
@@ -638,6 +628,12 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
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
 
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 1668495e4ae63..89dc612fb89e0 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -29,6 +29,10 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 
 	if (!list_empty(&call->recvmsg_link))
 		return;
+	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
+		rxrpc_see_call(call, rxrpc_call_see_notify_released);
+		return;
+	}
 
 	rcu_read_lock();
 
-- 
2.39.5



