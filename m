Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619759;
	b=qz2rwHEa8cXKqxNCHWQl2xjPkzBz5flnjGN+tgbDLfiE7K+8Exz8v3m8c+SNCd+D1G0D
	 A9X65LwEjinZmsXF5mGTST+HQzM/1McZVlVVS5vy7bdc9tst8NweZt9HFNs0i3zpi3NC8
	 nYPbfw/5KSU6JjGRmp9cuwEOWtQ2Jm6DKBICm6WVp/0DwWSeIsmmXQEngmk4VNUTiLtxP
	 aZJutkLVwwJMdFujGFE5RWSVKkiCIdPc70bKo8+3RSGJ89RdMDBBILJ1MhCdrEgbkKH5B
	 nt3vsKJ1xw0rjL0EFPUP4zCfl6LZfombCPGMPuRrnahOv4JSR7s9MSsuW85+sZFQ+TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TMn8uD+JimKb15vaQur5NOCVGGj4kuRdvY2J4y2Jujk=;
	b=BvOEu++UqJT3EPm2xSeFUEtk6BjbF+MhAYvKbmvXwXbJ/NCGT2N7fFyT6gB3sVnR7uwy
	 gSLnIK1V5ZRkij1yoY1JoGmO/Rz9pOAVTKkga4m8VDwKKnU4khwJfP7pwj+ZO4gXPvQKD
	 SKO+VAYPvAeZsgpCEqW6ptdfWfJNAh32hQu/WoIiDfm1EMDve7NftM3YHWPQEq9JnMGAg
	 IGhylPJzsPsCROOiPYiiKETJAK+jgKDKoY4dK5skirhP5d+Wzrp70NqbtqxPpSkNovdKb
	 OEUpal735A4fFFwNtGvkXSG9Ie1Wr+xs2UZOMmrJJ7eu4f2UFNPOGN52OERetINoSSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZMAsCWs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83173606A323;
	Wed, 25 Nov 2026 15:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZMAsCWs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECA51F000D2;
	Wed, 25 Nov 2026 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619759;
	bh=TMn8uD+JimKb15vaQur5NOCVGGj4kuRdvY2J4y2Jujk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZMAsCWsz7cw4G3gq3NQo0Wa5NxsseU9dO0oA5Nr/Lgvy3m45r6z3RMu8v5/WmZxY
	 whJ+3ij0BBMQlR/ZoL1fVzvfyYeWWNGB8xQL1L7C1IOBH83SKon8k8CHyVTmbHhUJT
	 H5rKKa3fdQDHl7Q1hp5Rr6lw1G8QmIUFaAC8rEVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0644/1005] tcp: fix request_sock use-after-free during Fast Open accept()
Date: Wed, 25 Nov 2026 15:33:02 +0100
Message-ID: <20261125143836.837892971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 62754aad50d0b30938bd8ce30b43474ce502a2af upstream.

Commit e3d95ad7da4f ("inet: avoid fastopen lock for regular accept()")
made inet_csk_accept() check tfo_listener before taking fastopenq.lock
to avoid taking the lock for connections that did not use Fast Open.

reqsk_fastopen_remove() clears tfo_listener while holding fastopenq.lock,
then reads req->sk. If inet_csk_accept() concurrently observes
tfo_listener after it has been cleared, it skips fastopenq.lock and
drops the last reference to the request_sock. This can free the
request_sock while reqsk_fastopen_remove() is still using it.

If the freed memory is reused for a new request_sock with req->sk ==
NULL, the reset path in reqsk_fastopen_remove() can append the new
request_sock to the original listener's list of requests that caused an
RST. After the new request_sock is freed, the next append writes through
the stale rskq_rst_tail into freed memory.

KASAN reported the following use-after-free when writing
fastopenq->rskq_rst_tail->dl_next = req:

  BUG: KASAN: slab-use-after-free in reqsk_fastopen_remove+0x142/0x210
  Write of size 8 at addr ffff888108230688 by task swapper/5/0
  ...
  Call Trace:
   <IRQ>
   ...
   reqsk_fastopen_remove+0x142/0x210
   tcp_check_req+0x96f/0xdd0
   ...
   tcp_rcv_state_process+0x19c/0x26b0
   ...
   tcp_v4_do_rcv+0x16e/0x490
   tcp_v4_rcv+0x14a0/0x1af0
   ...
   ip_protocol_deliver_rcu+0x39/0x1e0
   ip_local_deliver_finish+0x124/0x1e0
   ip_local_deliver+0xfb/0x1e0
   ...
   </IRQ>

To widen the race windows, mdelay(5) was added after newsk = req->sk,
mdelay(20) after the if (req) reqsk_put(req) block, and mdelay(100)
after tcp_rsk(req)->tfo_listener = false. The KASAN report above was
reproduced with this kernel.

For the lockless check, use tcp_sk(newsk)->syn_fastopen_child instead of
tfo_listener, which reqsk_fastopen_remove() clears.

syn_fastopen_child is a field of the Fast Open child TCP socket
referenced by newsk, not of the request_sock. It is set before the child
socket is added to the accept queue. The paths that call
reqsk_fastopen_remove() in response to a remote ACK or RST do not clear
this field.

inet_csk_accept() uses this field to take fastopenq.lock only for Fast
Open child sockets and rechecks tfo_listener while holding the lock.
Connections that did not use Fast Open continue to avoid the lock.

Fixes: e3d95ad7da4f ("inet: avoid fastopen lock for regular accept()")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/avQKA_YTAThtbsYU@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -683,7 +683,7 @@ struct sock *inet_csk_accept(struct sock
 	newsk = req->sk;
 
 	if (sk->sk_protocol == IPPROTO_TCP &&
-	    tcp_rsk(req)->tfo_listener) {
+	    tcp_sk(newsk)->syn_fastopen_child) {
 		spin_lock_bh(&queue->fastopenq.lock);
 		if (tcp_rsk(req)->tfo_listener) {
 			/* We are still waiting for the final ACK from 3WHS


