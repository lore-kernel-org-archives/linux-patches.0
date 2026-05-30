Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB3F3B0ADF;
	Sat, 30 May 2026 17:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163037; cv=none; b=n1L1sWXJRT6rC4jLH0O1ousQiLk/Y1bTmkgTeYFS1EvlhhpFlv9MTk9spFarqUBRMJiReA31cldhB2Mw4n6MWn9kA5WQP9K1ut1MP6N+A94kxyZMj+WtuTnzvmJ24UaLeTyCoAqqIu3/GioSlzSJXRIE4qEJg2K1x7bndVZrqYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163037; c=relaxed/simple;
	bh=6o/5/+ouo19x4U2NiT9yT+cIGtqe4P639NXI/YSeBfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZrfCpO5IDXR+G7DLxNLSPMFxBMy52fI1zirMcHZ4KRLgRcTGSkoRrQ1JWQ1acy4GoD+UZAxItIcoU5w2MGlDqVPkbJpfc+2LT6/cEzH1VX6cQ37pDNJFT94+NqXNvlIAYy6eNTBBJt0+ZUAzkCKgFcxPsrPpmByAPAyL2WcaIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8SRtAZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8SRtAZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6218F1F00893;
	Sat, 30 May 2026 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163036;
	bh=eCGycngWz3OtcVjT5BIPBvaTslnMu5rkvlFa3jfT8A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8SRtAZqBX3btQmxU3wSepJzmm5GZO31wf2mrxExzQVG4anu4FwNh0Y4en8bFOh3P
	 iDb+AS6r2Z5RQt1l1iH+R7W57KAClUgrC67Z/nQKh49rebE1p+owacfhxaBtAr1oQk
	 AG/LogsCDr35HzKaEAX914TuNVfJkudHbHFTp800=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/776] rxrpc: Fix call removal to use RCU safe deletion
Date: Sat, 30 May 2026 17:57:04 +0200
Message-ID: <20260530160243.199380567@linuxfoundation.org>
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

[ Upstream commit 146d4ab94cf129ee06cd467cb5c71368a6b5bad6 ]

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
[ adapted to older API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_object.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -634,11 +634,9 @@ void rxrpc_put_call(struct rxrpc_call *c
 		_debug("call %d dead", call->debug_id);
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
-		if (!list_empty(&call->link)) {
-			spin_lock_bh(&rxnet->call_lock);
-			list_del_init(&call->link);
-			spin_unlock_bh(&rxnet->call_lock);
-		}
+		spin_lock_bh(&rxnet->call_lock);
+		list_del_rcu(&call->link);
+		spin_unlock_bh(&rxnet->call_lock);
 
 		rxrpc_cleanup_call(call);
 	}
@@ -709,24 +707,20 @@ void rxrpc_destroy_all_calls(struct rxrp
 	_enter("");
 
 	if (!list_empty(&rxnet->calls)) {
-		spin_lock_bh(&rxnet->call_lock);
+		int shown = 0;
 
-		while (!list_empty(&rxnet->calls)) {
-			call = list_entry(rxnet->calls.next,
-					  struct rxrpc_call, link);
-			_debug("Zapping call %p", call);
+		spin_lock_bh(&rxnet->call_lock);
 
+		list_for_each_entry(call, &rxnet->calls, link) {
 			rxrpc_see_call(call);
-			list_del_init(&call->link);
 
 			pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
 			       call, refcount_read(&call->ref),
 			       rxrpc_call_states[call->state],
 			       call->flags, call->events);
 
-			spin_unlock_bh(&rxnet->call_lock);
-			cond_resched();
-			spin_lock_bh(&rxnet->call_lock);
+			if (++shown >= 10)
+				break;
 		}
 
 		spin_unlock_bh(&rxnet->call_lock);


