Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622974;
	b=j1xjo5hoUsgPfNUOWvsG2PIeub7gkbfjtTeETG6BocO6Ge8t1HmMySUVn+ZxN02ureYq
	 wEZCyxd8Tn5wBaZDp5Z39sAlRwclnuycirLYCmotRMSpEcqE9Y0+FoiX3Nh3/Cq+PAGjk
	 0e6R98KtHtDON19LXjlkcC/yXy9KM2xV4nT0ucVllqlK5O9FodbknppPpIpFVId4NSx82
	 rudS3FWOuhOt/GTt52V+EzmwlqthaShmgPcUSQ84GysqxSZg1M95jHwpdhjYbDDTw84sK
	 iX6OJRMe1y03n0edZ0MIC2cECRjDRJ7fTe57UUFpUox5GQpH0BVegfUVMIYvyrFTe+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mPjOQIDkKIacdgfJu2FNYg7RLodT3197PcmNkQdU1yA=;
	b=dgYdnZyJQvRMvEf6zm7+aiqY2M3ucA/f3Rl6xS+VKSlZMD8kn6/Osvm5fjFeZHrm1QCE
	 mRWVj18+oMfmghIYhMCLbNHWSbpz8V76DnFjiKc0dN6ezOnduf+sVp0weaLR7fsgwdyAK
	 ZDwNpTuKZE/nuD78B2Vc+5k2S/5oF0YjI4YOiZPF/ykWYsIJYPVyuVh8lAlMsy2ZnRhPp
	 GkwEUZ1kJGhNKe+pA3zQ33jCv7kCZTEuGKVr5erIqX8GzKMb0Zo2QNIhWv25m2LKwbHSK
	 hggMhqMBqAoJELm3StEMtXdtM6dVDPQJMkJTfGBLQF7VewrluB3R4y/62ormLVzp60g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AsxqUkJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C6E606A31E;
	Wed, 25 Nov 2026 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AsxqUkJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE671F000F0;
	Wed, 25 Nov 2026 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622974;
	bh=mPjOQIDkKIacdgfJu2FNYg7RLodT3197PcmNkQdU1yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsxqUkJZgKyz0GL9Xsrb6/xG4AoxTMIBHhmIJzbUQYLuGjbVifleWm+DDkfOzryIT
	 NlQY8xPj4+MV9K2N+pR/L5CC+8YzRQBAhEgtMCX2HkA+f4/W9a9cwxzfCNY6O74W5t
	 EdfZ8pIUluNe1IItFw+ljf1gm9UPkRzFuJZ+250g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 709/990] tcp: fix request_sock use-after-free during Fast Open accept()
Date: Wed, 25 Nov 2026 15:34:36 +0100
Message-ID: <20261125143838.690358182@linuxfoundation.org>
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
@@ -684,7 +684,7 @@ struct sock *inet_csk_accept(struct sock
 	newsk = req->sk;
 
 	if (sk->sk_protocol == IPPROTO_TCP &&
-	    tcp_rsk(req)->tfo_listener) {
+	    tcp_sk(newsk)->syn_fastopen_child) {
 		spin_lock_bh(&queue->fastopenq.lock);
 		if (tcp_rsk(req)->tfo_listener) {
 			/* We are still waiting for the final ACK from 3WHS


