Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207417;
	b=Pu77Vskql0maL9typuA9Ptp/mXPMMbtz4LLmsNKXKIDqmzJvZ/QVefA+42qUJhdSFdS4
	 nwkmleWlgDnMtPsX8SzHftxVzHqHALksdSObTfxyJFDKWgwif7jUcBzr1cWR9CmPkkYMV
	 x8ZPdxU3jDVJoXFiEuId2MPTMA9yn7QGEEvpPswWGtuAU6ZBRv34fS7/lq7wzyo+tg/5J
	 opJVYu2/Ok/FE7U7jtNNBsNiOWnmHgoSydtE6tqPUAgv5zgJmKutZrUFjhuPwZug27RU4
	 czMQi69O4bYh1uQkUVu2+KUnnBdq3KefpnJ08B8SwGnnbGRVNRqTOGcJ1fy5kjYbgbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AzCXF0tYu7y+dM+yKgoOjkBTBmUMoJpiFAwLgledSME=;
	b=y6+3Dkcc23fT9rl7h+y7XDuz+XsdEpw2hUyW24Qg0zD8T3TeJYjqvM9W08bbqHVGMYcf
	 vqgZrSFOVNLspkvgz4LsBxf8kyS0nlHAK+5eSLkuuFF3yUxOsZZTQvqwMOpDN6N6haEK7
	 6n33tozDCmGHADbIvoXsFv0tYTHKMepl1tklib3yF1+XFFOZ6r7oysC7i4ACA7L/50xmv
	 S9Q6hSLbtTOgWjDupF/eqILjzHIZ83P3o1jVWczqBnBSfh6rOJSwroOqQbFEGijQa4YBT
	 P0SynYN5gys6KnQ8ctEzLoMavTfuurxrX8olByh5NEVMU6cklQE7fKX7fwPRRopH7aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQEgbW34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26FD606A31A;
	Wed, 28 Oct 2026 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQEgbW34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0491F01825;
	Wed, 28 Oct 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207416;
	bh=AzCXF0tYu7y+dM+yKgoOjkBTBmUMoJpiFAwLgledSME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQEgbW340ZytikjmKQLgtcq6RZ8h7Sk47VQMOWlVqFN3xyHF1k03Zbhlwr2D7bfvA
	 8DZciQEBKimjo012XUtCOZ7boKTpP6vP9wESVpa61VjldPy9KtMSO66bVW4VFbcrzE
	 XtOfwayffYlA9AhM6uOCJ5ny/9BbGVW7vFG/A8Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/247] rose: hold a reference on incoming sockets queued for accept()
Date: Wed, 28 Oct 2026 17:56:53 +0100
Message-ID: <20261028165947.601458126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

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
(cherry picked from commit 6b0223a4795f5db52dee038a7a29e9906122b0f7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c    | 44 ++++++++++++++++++++++++++++++++++++++-----
 net/rose/rose_timer.c |  5 +++++
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index e0294a5183b47..420408a5ad61c 100644
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
index 3cd7e020422a5..5ba0c89e4ee1b 100644
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



