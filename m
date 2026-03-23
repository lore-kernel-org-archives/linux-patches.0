Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4747D3A961B;
	Mon, 23 Mar 2026 14:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276981; cv=none; b=hxuHFkUYP+1/Nr+o3iheI/Jomkd8Vk84xhO5WZyW0i2Ko/AwwRZObWAEEn5bdwjZ9skSC8PHQDDrelswndL4swnytYhSocXA8svWCC9/QIZishR59ZhwNqs2PXYdebpo5hxH7h+6Qil5AuB2rBUPL8O/YxxoaTh7XVgW4ZCaeLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276981; c=relaxed/simple;
	bh=TzB/tdDzCRdRdkhVUnWwTK++sp/mvKQLDL1F2oAY+t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSI8XTVewrv1MrBXkQHNh0P/HhdCtv9iuVlX+XYA1H9cZKkXQfsWZrt4fo3ursE0bwCKI7ByB7QqGqVSgfakxhRh4CxzfSzGc7GvbRkktEDueYrje8In7Q73jDsX0Cuzplr45Fd/oYE+tw/aIdLxl5bC86rSFn/mIFMUdRb3dKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmJoPn4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmJoPn4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57FDC4CEF7;
	Mon, 23 Mar 2026 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276981;
	bh=TzB/tdDzCRdRdkhVUnWwTK++sp/mvKQLDL1F2oAY+t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmJoPn4SvwCbIEBZKoHGKCWnfUuW+V6xf3XRXkAPOLnFb7ClvP7ztF5I6XfHxZFnR
	 0W0VvNgGa9Idv9gFAzURc76uvsIN7XfhEPZImwmLkBJYz5ahx1TZ1W7GwVF2Zz50z1
	 41QKUoksiEvtiYfCK5LpdgK/XGcJ6J7J5p4xdMbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, David Howells" <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith <faith@zellic.io>,
	Pumpkin Chang <pumpkin@devco.re>,
	Marc Dionne <marc.dionne@auristor.com>,
	Nir Ohfeld <niro@wiz.io>,
	Willy Tarreau <w@1wt.eu>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.12 276/460] rxrpc: Fix recvmsg() unconditional requeue
Date: Mon, 23 Mar 2026 14:44:32 +0100
Message-ID: <20260323134533.259783431@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

[ Upstream commit 2c28769a51deb6022d7fbd499987e237a01dd63a ]

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
[Use spin_unlock instead of spin_unlock_irq to maintain context consistency.]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    4 ++++
 net/rxrpc/recvmsg.c          |   19 +++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -274,6 +274,7 @@
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
 	EM(rxrpc_call_put_poke,			"PUT poke    ") \
 	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
+	EM(rxrpc_call_put_recvmsg_peek_nowait,	"PUT peek-nwt") \
 	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
@@ -291,6 +292,9 @@
 	EM(rxrpc_call_see_distribute_error,	"SEE dist-err") \
 	EM(rxrpc_call_see_input,		"SEE input   ") \
 	EM(rxrpc_call_see_recvmsg,		"SEE recvmsg ") \
+	EM(rxrpc_call_see_recvmsg_requeue,	"SEE recv-rqu") \
+	EM(rxrpc_call_see_recvmsg_requeue_first, "SEE recv-rqF") \
+	EM(rxrpc_call_see_recvmsg_requeue_move,	"SEE recv-rqM") \
 	EM(rxrpc_call_see_release,		"SEE release ") \
 	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
 	EM(rxrpc_call_see_waiting_call,		"SEE q-conn  ") \
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -430,7 +430,8 @@ try_again:
 	if (rxrpc_call_has_failed(call))
 		goto call_failed;
 
-	if (!skb_queue_empty(&call->recvmsg_queue))
+	if (!(flags & MSG_PEEK) &&
+	    !skb_queue_empty(&call->recvmsg_queue))
 		rxrpc_notify_socket(call);
 	goto not_yet_complete;
 
@@ -461,11 +462,21 @@ error_unlock_call:
 error_requeue_call:
 	if (!(flags & MSG_PEEK)) {
 		spin_lock(&rx->recvmsg_lock);
-		list_add(&call->recvmsg_link, &rx->recvmsg_q);
-		spin_unlock(&rx->recvmsg_lock);
+		if (list_empty(&call->recvmsg_link)) {
+			list_add(&call->recvmsg_link, &rx->recvmsg_q);
+			rxrpc_see_call(call, rxrpc_call_see_recvmsg_requeue);
+			spin_unlock(&rx->recvmsg_lock);
+		} else if (list_is_first(&call->recvmsg_link, &rx->recvmsg_q)) {
+			spin_unlock(&rx->recvmsg_lock);
+			rxrpc_put_call(call, rxrpc_call_see_recvmsg_requeue_first);
+		} else {
+			list_move(&call->recvmsg_link, &rx->recvmsg_q);
+			spin_unlock(&rx->recvmsg_lock);
+			rxrpc_put_call(call, rxrpc_call_see_recvmsg_requeue_move);
+		}
 		trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_requeue, 0);
 	} else {
-		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg_peek_nowait);
 	}
 error_no_call:
 	release_sock(&rx->sk);


