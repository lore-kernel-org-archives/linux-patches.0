Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623803;
	b=w3+qQOOKSCIgEUSICkzqQMuRNIuvHagucl5eOFv+na/zdrCvu7fUhzZUNqwnvZoDeE35
	 ZZ07zHEAs/Oz4ujZNKmheKd0RKQ2eby0Aj/L1qS6vmTsSlwWNSVzp7cHhP4BgNKsVDgFH
	 GtjsR94WxjtkrdElB2z/4xxN6/cErPPach1ofduAatCJBdEXtHjUiOb7oTgh6ra6+bVw4
	 40Z0ribMv7upYXpUCTeqHhMnZI0eRyrBEAxqc3tsYLXqMXI2VfkM6i/vpOCeo4m/ZY/bK
	 AmBCF//Vg9XKG81DXpqeewpyQr2L6dRfMnk7AMuLylBmLKwzKRt5D3fLFCVVWfWXAeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FkAWs8NynR4igLpyOFh3paBwIsoPWZ31FPi3jFohCY=;
	b=i/1bWFsNBVIn+oAzju1LprupewAOcg60t3gI9FqEtmGxJ29l+sGf3jcXhiJGgUiJmRlk
	 6kKPhxBATTkaqO9hf0oABnNYZ+oaajit0sWpwnaLNE+P4tE1VnqTlgikDoh42jmMUWZkA
	 Lth1iUym9VLHoE3MgFulR8X2DCRWLEfJPq0zmmgsZDIdjhwE43iINVtUqkQK6UpiA9smI
	 abkVH/U/UaBeZRWKQlPSW7qaqW+WgcVz93kr7kGHF7vfZlzOQXzqP2uR1A5Vzs6iuue5B
	 iiZrUB/7klNXjHahFw3epYx1iZC/Qry60HkNjU5SILu8JZPnHdHNJwK2BMY91ySN9wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ANxTgE8/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BF4606A335;
	Wed, 25 Nov 2026 16:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANxTgE8/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B021F000C6;
	Wed, 25 Nov 2026 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623802;
	bh=7FkAWs8NynR4igLpyOFh3paBwIsoPWZ31FPi3jFohCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANxTgE8/4OK6LC3v68PMD/DAFNVXqRAfbp0lOTOkJGGbGanEbr2CMSxfRPd2DyNhA
	 EdmG3Go43C1x7I11jNumD+E91KuBZKh5B/ik7q8QMJH4Tul9QHe5OZFQ2Xjvheig3q
	 ENAAGWFx9Dnn2GUAfh9gCFo+tPu7bFMfwsKiwJMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 974/990] tcp: fix NULL pointer dereference when restarting a Fast Open listener
Date: Wed, 25 Nov 2026 15:39:01 +0100
Message-ID: <20261125143844.798902262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit aa40afa831ebfe45e40a23721711059f2ac584d4 upstream.

When a valid RST is received for a Fast Open child accepted before the
three-way handshake completes, reqsk_fastopen_remove() adds the
request_sock to the listener's RST list if the listener is in TCP_LISTEN.

An application can call shutdown(SHUT_RD) on a listener socket.
inet_csk_listen_stop() checks rskq_rst_head without holding
fastopenq.lock. If rskq_rst_head is NULL, it does not acquire the lock
and therefore does not synchronize with an insertion by
reqsk_fastopen_remove() after that function has passed the TCP_LISTEN
check.

The more likely outcome of this race, even without a subsequent
listen(), is a leak. If reqsk_fastopen_remove() inserts a request_sock
after inet_csk_listen_stop() observes an empty list and returns, the
request_sock is stranded in rskq_rst_head and keeps a reference on the
listener. The socket is already in TCP_CLOSE, so a subsequent close()
does not call inet_csk_listen_stop() again.

If listen() is called again on the same socket before the delayed list
insertion, the insertion can overlap the queue initialization in
reqsk_queue_alloc(). If it occurs after rskq_rst_head is set to NULL but
before rskq_rst_tail is set to NULL, rskq_rst_head points to the
request_sock while rskq_rst_tail is NULL.

When a valid RST is later received for another accepted Fast Open child,
rskq_rst_head is not NULL, so reqsk_fastopen_remove() attempts to write
the request_sock pointer to rskq_rst_tail->dl_next while rskq_rst_tail is
NULL. KASAN reports:

  BUG: KASAN: null-ptr-deref in reqsk_fastopen_remove+0x147/0x210
  Write of size 8 at addr 0000000000000088 by task swapper/3/0
  ...
  Call Trace:
   <IRQ>
   ...
   reqsk_fastopen_remove+0x147/0x210
   tcp_check_req+0xa70/0x1060
   ...
   tcp_rcv_state_process+0x1cb/0x2ae0
   ...
   tcp_v4_do_rcv+0x1fe/0x740
   tcp_v4_rcv+0x1744/0x2070
   ...
   ip_protocol_deliver_rcu+0x5c/0x280
   ip_local_deliver_finish+0x171/0x330
   ip_local_deliver+0x107/0x370
   ...
   </IRQ>

To widen the race window, the issue was reproduced after adding
mdelay(3000) immediately after reqsk_fastopen_remove() checks that the
listener is in TCP_LISTEN and immediately after reqsk_queue_alloc() sets
rskq_rst_head to NULL.

Make inet_csk_listen_stop() acquire fastopenq.lock regardless of the
value of rskq_rst_head and detach the list while holding the lock. With
this synchronization, reqsk_fastopen_remove() either inserts the
request_sock before inet_csk_listen_stop() acquires the lock, in which
case inet_csk_listen_stop() reclaims it, or sees that the listener is
not in TCP_LISTEN and does not insert anything.

Fixes: 0536fcc039a8 ("tcp: prepare fastopen code for upcoming listener changes")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/avMkfJrXhCFXn8M_@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1549,17 +1549,15 @@ skip_child_forget:
 		if (!has_current_bpf_ctx())
 			cond_resched();
 	}
-	if (queue->fastopenq.rskq_rst_head) {
-		/* Free all the reqs queued in rskq_rst_head. */
-		spin_lock_bh(&queue->fastopenq.lock);
-		req = queue->fastopenq.rskq_rst_head;
-		queue->fastopenq.rskq_rst_head = NULL;
-		spin_unlock_bh(&queue->fastopenq.lock);
-		while (req != NULL) {
-			next = req->dl_next;
-			reqsk_put(req);
-			req = next;
-		}
+	/* Free all the reqs queued in rskq_rst_head. */
+	spin_lock_bh(&queue->fastopenq.lock);
+	req = queue->fastopenq.rskq_rst_head;
+	queue->fastopenq.rskq_rst_head = NULL;
+	spin_unlock_bh(&queue->fastopenq.lock);
+	while (req != NULL) {
+		next = req->dl_next;
+		reqsk_put(req);
+		req = next;
 	}
 	WARN_ON_ONCE(sk->sk_ack_backlog);
 }


