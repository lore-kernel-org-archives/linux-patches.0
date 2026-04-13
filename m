Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E7F29B22F;
	Mon, 13 Apr 2026 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096413; cv=none; b=LG0njnZ2BT0SACyaeMltd++js9/vUxg+sRdP+g7UeA/1kUXb6SfzMvMcMYck/bksc6fAP0o/7tVbIZ+Y9sYi5sgT8jaD7WtbCsGOAqE8KKYu72FEBl+QjKM+0r0rJsWSLKYIaso7h1oMkOAub9RGr9F0klqOxHtW9BW9qrxTdq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096413; c=relaxed/simple;
	bh=KufDdCGvjaI0O5+fgoaVg4PllarQ4G7MFFX651lwqDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhhWnhbFBcoM7DqkuRd/7WAixhPVkq6MYMfasMo3pWeGNqq1KVkHE7uP11+G4XDwTGQsWD3Amp9ISstIskqAewEW3xntRyCnOW5FSW71EUZ7boBfI+Fd9cnWe5RR6v7FwIJfOLIQy92Q+X+BMYZIpOD3RlRPGmAELmw+bDbTQvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVMSx1QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVMSx1QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB0CC2BCAF;
	Mon, 13 Apr 2026 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096413;
	bh=KufDdCGvjaI0O5+fgoaVg4PllarQ4G7MFFX651lwqDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVMSx1QZ1wcSPZDKfWlqjx8ZCIqMxEQUK8gyi8mwbxtZNecTF57TloW6+A7of4q1u
	 5rdoJgWa+6PZJTMLaMpisvBgiBoQcnstUKTeSU2pSP8HNVMBEu0+/ovJH2cpIyG/tV
	 cxB9VwecQnB4R/Q6Ix/Y5GWOr5uX2DuN7XvzP8VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 68/86] rxrpc: Fix call removal to use RCU safe deletion
Date: Mon, 13 Apr 2026 18:00:15 +0200
Message-ID: <20260413155734.090025373@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 146d4ab94cf129ee06cd467cb5c71368a6b5bad6 upstream.

Fix rxrpc call removal from the rxnet->calls list to use list_del_rcu()
rather than list_del_init() to prevent stuffing up reading
/proc/net/rxrpc/calls from potentially getting into an infinite loop.

This, however, means that list_empty() no longer works on an entry that's
been deleted from the list, making it harder to detect prior deletion.  Fix
this by:

Firstly, make rxrpc_destroy_all_calls() only dump the first ten calls that
are unexpectedly still on the list.  Limiting the number of steps means
there's no need to call cond_resched() or to remove calls from the list
here, thereby eliminating the need for rxrpc_put_call() to check for that.

rxrpc_put_call() can then be fixed to unconditionally delete the call from
the list as it is the only place that the deletion occurs.

Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")
Closes: https://sashiko.dev/#/patchset/20260319150150.4189381-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    2 +-
 net/rxrpc/call_object.c      |   24 +++++++++---------------
 2 files changed, 10 insertions(+), 16 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -347,7 +347,7 @@
 	EM(rxrpc_call_see_release,		"SEE release ") \
 	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
 	EM(rxrpc_call_see_waiting_call,		"SEE q-conn  ") \
-	E_(rxrpc_call_see_zap,			"SEE zap     ")
+	E_(rxrpc_call_see_still_live,		"SEE !still-l")
 
 #define rxrpc_txqueue_traces \
 	EM(rxrpc_txqueue_await_reply,		"AWR") \
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -654,11 +654,9 @@ void rxrpc_put_call(struct rxrpc_call *c
 	if (dead) {
 		ASSERTCMP(__rxrpc_call_state(call), ==, RXRPC_CALL_COMPLETE);
 
-		if (!list_empty(&call->link)) {
-			spin_lock(&rxnet->call_lock);
-			list_del_init(&call->link);
-			spin_unlock(&rxnet->call_lock);
-		}
+		spin_lock(&rxnet->call_lock);
+		list_del_rcu(&call->link);
+		spin_unlock(&rxnet->call_lock);
 
 		rxrpc_cleanup_call(call);
 	}
@@ -730,24 +728,20 @@ void rxrpc_destroy_all_calls(struct rxrp
 	_enter("");
 
 	if (!list_empty(&rxnet->calls)) {
-		spin_lock(&rxnet->call_lock);
+		int shown = 0;
 
-		while (!list_empty(&rxnet->calls)) {
-			call = list_entry(rxnet->calls.next,
-					  struct rxrpc_call, link);
-			_debug("Zapping call %p", call);
+		spin_lock(&rxnet->call_lock);
 
-			rxrpc_see_call(call, rxrpc_call_see_zap);
-			list_del_init(&call->link);
+		list_for_each_entry(call, &rxnet->calls, link) {
+			rxrpc_see_call(call, rxrpc_call_see_still_live);
 
 			pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
 			       call, refcount_read(&call->ref),
 			       rxrpc_call_states[__rxrpc_call_state(call)],
 			       call->flags, call->events);
 
-			spin_unlock(&rxnet->call_lock);
-			cond_resched();
-			spin_lock(&rxnet->call_lock);
+			if (++shown >= 10)
+				break;
 		}
 
 		spin_unlock(&rxnet->call_lock);


