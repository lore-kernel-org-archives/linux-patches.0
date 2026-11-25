Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626367;
	b=Z8trwEcg9DLmIiZYvz6p8qEVTf+C/AoJUFJNXzu5Bv4jQF4P+xMJG3P8zgwCedVka7RE
	 u2OHmoUvhkfgkIevfr1NKMZIZG5tFFd3R2YJHVMva8imENX4tnXvtQwTJaMi8hpReZNLf
	 RhcyC7KkfWaN9nzCkb6fCbxYiNveaNlq0XpMpTnLI1k2XhnrFQgGsJ1OwPm8WiUlQzzGX
	 pFPf0OMhvkvPUGOj2I++cuqaUlt/pym2ZCs2S22d72qjvCOj5/By6anKlHagw9e7aoTqT
	 mS2hN6+NWEc6bdnThS047wziXjtvWuOZmrXFe63N/sV5DcrzAGqxWw3hKwt1dsFTVZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xdly9l2WmmfR+s7kIiRqm7VXWzGNHpNJ2GWG8DmVJ/E=;
	b=FhimCaG9nuAN9lzRARCRpGnpQvf8TgyPoHtZiPe2Fd0DZobaFxAGb5kJv/ggAD2SYIsd
	 B+RrSfelmpzX5m6lSc+DYd5RDtvEpln34DxMEIRm7/EU9sO5QW/Hme6//qVlyU+/wGTCN
	 F1ljAl9h/tNNrFy6EzXjFrd38iq8ldID1CMQWirrRhpp0pa+lff+fUN688Vo94BIiEfef
	 5UGFzgEXeSpHtCAXxtCa9hpQyHBSXbeEfYGkJmo4IFo71heTUAvpRpWqPtB0X2fHLSFO2
	 2TvMPbqEUt2GhRvXb9fgzzqxqCsl2y4gC8Kb4zpeUlU2A7N5yAIMfAjgjwmOHA91q7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iV+HVysg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE44D606A321;
	Wed, 25 Nov 2026 17:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iV+HVysg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD51F000C4;
	Wed, 25 Nov 2026 17:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626367;
	bh=Xdly9l2WmmfR+s7kIiRqm7VXWzGNHpNJ2GWG8DmVJ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iV+HVysgKgicFvJeVYWKvar+VjksdzyA/olkeYgtZGInn5BxrwxrlGkKEx61wR9wg
	 xHqmoCyGd91MrHA7QYcJbV4Vx0gPwPhuDpp6gZNGMiXDcsp/Lic0xrfC0XXN2Hy+Ip
	 VORM+MSSeqLYV4WpDoTrF05jTTM4qyH+096ny6IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 805/816] tcp: fix NULL pointer dereference when restarting a Fast Open listener
Date: Wed, 25 Nov 2026 15:39:13 +0100
Message-ID: <20261125143907.804216005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1575,17 +1575,15 @@ skip_child_forget:
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


