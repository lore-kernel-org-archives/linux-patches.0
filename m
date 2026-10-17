Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183E224D6;
	Sat, 17 Oct 2026 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252643; cv=none; b=aL/YIZ3VcOCx8diuJVpJNytqJCFisePZ9+gAHZvJzXwNkSrx973bf6wROlSAHVXlNiwjd62u9Oy9exasmn/IJcPYyDBXMuhX/rk2MFt1ewVVtd/3kKF2Bes+2nAy/yHRUbjspGsBVlRW2he/lAua0W8wpgw7icbFka2iTEYEpVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252643; c=relaxed/simple;
	bh=adX59XQWIwBdNA3uYXdlck4uJSn8RTVBAi6j+2wTkxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Otr64lLt/PNcW8arVQhdK0ElA6+D2Ds3pIqdQQNAtQK2+UzAvgGBAtv+oxFe8Jp/lMUt2aCriDt1xyOFJLYMLgPul5MBnmz8rkIXmMi5NWIWcS0PrtTGQBu6VV0BZ9LmpSu5PmXZLCnyhJ0xRQTsR+nJH8CW6mIq5C/0gPBC+wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbWw266/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbWw266/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80CB1F000C4;
	Sat, 17 Oct 2026 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252641;
	bh=lJ1DPZ3GHVrzqA/QBTGoPFPYKB2HD7sJefOFl+ZuJ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbWw266/2++7pdoKZ1HFVi6mSisRRTgTt2jFMCCPR94K0O/WZ/U80STwEKceWyFYj
	 R69GmcYywmjYamK8U2FzcRVN+ajxy/y0IIGPZ/GbdojGDIL2EMRV209qVX4RnFb3mr
	 21sgBdW7KTFC7brcq8bNjZ7wCnmWIK45aSGplfeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 47/52] rose: hold a reference on incoming sockets queued for accept()
Date: Sat, 17 Oct 2026 17:54:48 +0200
Message-ID: <20261017155106.356685135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit 6b0223a4795f5db52dee038a7a29e9906122b0f7 upstream.

rose_rx_call_request() creates the socket for an incoming call and
queues the call's skb on the listening socket with skb->sk pointing at
it, without taking a reference. If the caller clears the call before
it is accepted, rose_disconnect() leaves that socket in STATE_0 with
SOCK_DEAD set, and since commit "rose: release netdev ref and destroy
orphaned incoming sockets" rose_heartbeat_expiry() reaps such orphaned
sockets and frees them. The skb stays on the listener's queue, so:

- closing the listener makes rose_destroy_socket() walk its queue and
  set flags and restart the heartbeat on the freed socket;
- accept() can hand the freed socket to user space.

On a live node running a KASAN kernel, stopping the FPAC daemons shortly
after a local (loopback) call had been set up and dropped gave:

  BUG: KASAN: slab-use-after-free in rose_destroy_socket+0x24a/0x570 [rose]
  Write of size 8 ... by task fpacwpd
   rose_destroy_socket
   rose_release
  Allocated by task 0: ... rose_rx_call_request <- rose_loopback_timer
  Freed by task ...: ... sk_free <- rose_heartbeat_expiry
  refcount_t: addition on 0; use-after-free.
   rose_start_heartbeat <- rose_destroy_socket <- rose_release

followed a few seconds later by a page fault in the re-armed heartbeat
and a kernel panic.

Make the listener's queue own a reference on each pending socket,
taken when the call is queued and dropped by rose_accept() or by the
listener's rose_destroy_socket() once the skb is off the queue. Have
the heartbeat set SOCK_DESTROY under the socket lock before reaping a
dead socket, as the other reaping paths already do, and make both
consumers check it under the child's lock: rose_accept() skips a
reaped socket and waits for the next call, and rose_destroy_socket()
no longer re-arms the heartbeat of a socket that is gone.

Fixes: df12be096302 ("rose: release netdev ref and destroy orphaned incoming sockets")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c    | 44 ++++++++++++++++++++++++++++++++++++++-----
 net/rose/rose_timer.c |  5 +++++
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 97893498e6111..48b82fe3bee18 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -390,11 +390,25 @@ void rose_destroy_socket(struct sock *sk)
 	rose_clear_queues(sk);		/* Flush the queues */
 
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
-		if (skb->sk != sk) {	/* A pending connection */
-			/* Queue the unaccepted socket for death */
-			sock_set_flag(skb->sk, SOCK_DEAD);
-			rose_start_heartbeat(skb->sk);
-			rose_sk(skb->sk)->state = ROSE_STATE_0;
+		struct sock *child = skb->sk;
+
+		if (child != sk) {	/* A pending connection */
+			/* Queue the unaccepted socket for death, unless
+			 * rose_heartbeat_expiry() has already reaped it or is
+			 * about to (SOCK_DESTROY).
+			 */
+			local_bh_disable();
+			bh_lock_sock_nested(child);
+			if (!sock_flag(child, SOCK_DESTROY)) {
+				sock_set_flag(child, SOCK_DEAD);
+				rose_start_heartbeat(child);
+				rose_sk(child)->state = ROSE_STATE_0;
+			}
+			bh_unlock_sock(child);
+			local_bh_enable();
+
+			skb->sk = NULL;
+			sock_put(child);	/* the queue's reference */
 		}
 
 		kfree_skb(skb);
@@ -980,6 +994,7 @@ static int rose_accept(struct socket *sock, struct socket *newsock,
 	 *	The write queue this time is holding sockets ready to use
 	 *	hooked into the SABM we saved
 	 */
+again:
 	for (;;) {
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 
@@ -1005,12 +1020,27 @@ static int rose_accept(struct socket *sock, struct socket *newsock,
 		goto out_release;
 
 	newsk = skb->sk;
+	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
+	if (sock_flag(newsk, SOCK_DESTROY)) {
+		/* The call went away and rose_heartbeat_expiry() reaped (or
+		 * is about to reap) the socket before it was accepted: drop
+		 * it and wait for the next one.
+		 */
+		release_sock(newsk);
+		skb->sk = NULL;
+		kfree_skb(skb);
+		sk_acceptq_removed(sk);
+		sock_put(newsk);	/* the queue's reference */
+		goto again;
+	}
 	sock_graft(newsk, newsock);
+	release_sock(newsk);
 
 	/* Now attach up the new socket */
 	skb->sk = NULL;
 	kfree_skb(skb);
 	sk_acceptq_removed(sk);
+	sock_put(newsk);		/* the queue's reference */
 
 out_release:
 	release_sock(sk);
@@ -1124,6 +1154,10 @@ int rose_rx_call_request(struct sk_buff *skb, struct net_device *dev, struct ros
 
 	rose_insert_socket(make);
 
+	/* The listener's queue holds a reference on the pending socket
+	 * until rose_accept() or rose_destroy_socket() takes it off.
+	 */
+	sock_hold(make);
 	skb_queue_head(&sk->sk_receive_queue, skb);
 
 	rose_start_heartbeat(make);
diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index d967cbc1db3db..4130ddf848504 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -188,6 +188,11 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 				rose_neigh_put(rose->neighbour);
 				rose->neighbour = NULL;
 			}
+			/* Tell rose_accept() and the listener's teardown, which
+			 * may still hold this socket on their queue, that it is
+			 * gone.
+			 */
+			sock_set_flag(sk, SOCK_DESTROY);
 			bh_unlock_sock(sk);
 			rose_destroy_socket(sk);
 			sock_put(sk);
-- 
2.53.0



