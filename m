Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C27523792;
	Wed, 30 Sep 2026 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790541; cv=none; b=MmYUZkeR/Fkrvabttu0TxRGE2HoFRkG0gFaY1UMGcRzlxbNErmOW/i8E1lc+O8GBVqwCURvTaqr0vLVxRqosGJMUl+MtJyxC2NoCUCK+Di3/NKI38+pZtEpt07QoWNlzdf3FE89bUPRhW7BKa0pIU8SctA+/ugpt7h3pfFZrAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790541; c=relaxed/simple;
	bh=BA248UK98kK3fkhSH/wYrDCokvNnjKoOz/RrxSddP4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orYjJbBOAb8P5pC8Ztngan0iUufE6vu/FaXDmClsV9xQ1NfQtApLh785NSBsGlaXu4CmgX3WWKNqjvWsWKv4fsJgr1gtJcCXQNUXRngbZtUzR54xhD3lXLaozEXHuvVZnKRc+gDmARgqrW9jzjt17t0UzlBSWUQUhWmMMPpNKfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqrXV7v/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqrXV7v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48B91F000FF;
	Wed, 30 Sep 2026 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790540;
	bh=nMriUo286LNHWOYqt1cupbRhlpU4dCnuufmM1d+2Yf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqrXV7v/15I1sgwXaMoXwfXZJL36Xhg71c5eO0y8iXWi2KeCKTT+dCN+iqKF9kJfa
	 ASllZGDFCmTEqf7vLBQPXvM5wpIzdtHg1c6EGf6O51lWrbcw9bOZ++zSC9k1Smxdo7
	 ssy/VHPEvBQq+UCdQRR/jwsKsoiXGX2ON0uATt1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 864/877] rose: release netdev ref and destroy orphaned incoming sockets
Date: Wed, 30 Sep 2026 17:29:35 +0200
Message-ID: <20260930152433.381204859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit df12be096302d2c947388acc25764456c7f18cc1 upstream.

Two related cleanup gaps left the module unremovable after a loopback
session:

1. rose_destroy_socket() did not release the device reference.  When
   an unaccepted incoming socket (created by rose_rx_call_request()) is
   destroyed via rose_heartbeat_expiry(), it is removed from rose_list
   before rose_kill_by_device() can find it, so the netdev_hold() taken
   in rose_rx_call_request() was never matched by netdev_put().  Add the
   release at the top of rose_destroy_socket() guarded by a NULL check
   so that rose_release() and rose_kill_by_device(), which already call
   netdev_put() and set device = NULL, are not affected.

2. rose_heartbeat_expiry() STATE_0 cleanup required TCP_LISTEN in
   addition to SOCK_DEAD.  Unaccepted incoming sockets are
   TCP_ESTABLISHED, so the condition was never true and those sockets
   lingered forever, holding the module use count above zero and
   blocking rmmod.  Drop the TCP_LISTEN restriction: any STATE_0 +
   SOCK_DEAD socket is orphaned and should be destroyed.

Together with the earlier rose_make_new() double-hold fix these three
patches allow clean rmmod after loopback sessions.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c    |    9 +++++++++
 net/rose/rose_timer.c |    9 +++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -363,6 +363,7 @@ static void rose_destroy_timer(struct ti
  */
 void rose_destroy_socket(struct sock *sk)
 {
+	struct rose_sock *rose = rose_sk(sk);
 	struct sk_buff *skb;
 
 	rose_remove_socket(sk);
@@ -370,6 +371,14 @@ void rose_destroy_socket(struct sock *sk
 	rose_stop_idletimer(sk);
 	rose_stop_timer(sk);
 
+	/* Drop any device reference not already released by rose_kill_by_device()
+	 * or rose_release() -- e.g. incoming sockets that were never accepted.
+	 */
+	if (rose->device) {
+		netdev_put(rose->device, &rose->dev_tracker);
+		rose->device = NULL;
+	}
+
 	rose_clear_queues(sk);		/* Flush the queues */
 
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -128,10 +128,11 @@ static void rose_heartbeat_expiry(struct
 	}
 	switch (rose->state) {
 	case ROSE_STATE_0:
-		/* Magic here: If we listen() and a new link dies before it
-		   is accepted() it isn't 'dead' so doesn't get removed. */
-		if (sock_flag(sk, SOCK_DESTROY) ||
-		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
+		/* Destroy any orphaned STATE_0 socket: either explicitly
+		 * flagged SOCK_DESTROY, or SOCK_DEAD (covers both unaccepted
+		 * incoming connections and listening sockets whose link died).
+		 */
+		if (sock_flag(sk, SOCK_DESTROY) || sock_flag(sk, SOCK_DEAD)) {
 			bh_unlock_sock(sk);
 			rose_destroy_socket(sk);
 			sock_put(sk);


