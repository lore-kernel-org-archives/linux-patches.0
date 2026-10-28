Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207884;
	b=bXKMfxQTNnG0D86aKCfBRHqQaOeg1DJL1mjMzUb+497Yn+ZhA0JGKzYhCQNbsZXuUhf9
	 9V2T8kB77y7k8M7+KOt3hxhYyS/seKG2chdoTAC4enxaPiKeiOAhN8X8NYhSk/LuKp7lr
	 v+9lf7/0JZMa+o7GVrZSpeC5RX6PUnmb8kFv9Sa8u0pDp6TYvdWIDZyqQeOKn9YwAqr2w
	 40o/3ZEIH9HDnU9pGXUyCSElZfsYdb0y8jqwhGVMLkolBDn3PZUJtbVxCC5+BlsiWLS+u
	 dpkIWlJ6KX0ovWOn6nwo5+qQG0vutcXnR4PGyPgmdSd1ikzSerP7JEQvqQH90hLQkmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QZsNGyeAwyVzqvIzRqiYnCKevmWD8Egm5A9WCWuxv/c=;
	b=mQ4oYpMdE59oLLVksTsL8c/iV+nm102z22iIURg81R2UTQ7nuS8/Ocgfl7KqYjChqxNR
	 LxSLQ0w0GpBTcprsP0aEURssII9vG/EPrQKq2iPBgOeCjdqdB+cnKiN/zRkUCXrpxeldc
	 qme53gt5cgaUJXluxOtkxCGnlSGRSX/LalV+cB29TvcPbwB8FBq49NVYqtsoUD1QO2Ksx
	 uC3tP+m0ubvCXaloKFGGfKr/GSebBzCfhRMLFbuWzhUew6pY+BN5+RWiVZQEWDLcUDVgO
	 IpyVOGQyxhA1Ik8OiXA7s7VyfYrkeYiZ00ZBvo53r3iB0mC6zLQE5BuPQD6TYm+8w2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooO+A2WM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F31C60A2635;
	Wed, 28 Oct 2026 17:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooO+A2WM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B12E1F01828;
	Wed, 28 Oct 2026 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207883;
	bh=QZsNGyeAwyVzqvIzRqiYnCKevmWD8Egm5A9WCWuxv/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooO+A2WM82USHaNGlmadZV1lJW3cmTzZ0EzGNdZt0d1DpeFj+WPkCSaZu6uxPxkqR
	 q0a24Rq2EJ5E1Ah4HVKqp97xjpoY+1FczerBxoz4wD753qmRI2cO3Ix9QHqtwMLJRW
	 rodrDYJJmKZ1mtr42UXR13YR37auMwraHnslK7tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/247] ax25: serialise the transmission of I frames on a connection
Date: Wed, 28 Oct 2026 17:59:34 +0100
Message-ID: <20261028165951.472050774@linuxfoundation.org>
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

ax25_kick() takes frames off the write queue, numbers them from V(S)
and moves them to the ack queue, with no lock. It is called from
process context by the senders (ax25_output()) and from softirq context
by the receive path and the timers. A connection used by ROSE or NET/ROM
carries several circuits, so ax25_output() can run for the same
connection on two CPUs at once, and against the receive path. Both then
read the same V(S) and two different I frames are sent under the same
N(S). The peer keeps the first and rejects the second; the go-back-N
that follows resends whatever the ack queue holds for that number, and
one of the two frames is never sent again while the AX.25 counters look
consistent on both sides. The layer above sees a hole: a ROSE circuit
receives its frames out of sequence, ignores them, and stays frozen
with its window full.

Seen on a live ROSE node relaying several circuits over one AX.25 link:

  fm F6BVP-9 to F6BVP-13 ctl I55^ pid=1(X.25) len 254   LCI 030 DATA S2
  fm F6BVP-9 to F6BVP-13 ctl I55^ pid=1(X.25) len 254   LCI 02E DATA S2
  fm F6BVP-13 to F6BVP-9 ctl REJ6v

Add a lock to the ax25_cb covering V(S), V(A) and the write and ack
queues, taken in ax25_kick(), ax25_frames_acked() and
ax25_requeue_frames(). The frames are not sent with the lock held,
since ax25_transmit_buffer() may end up in ax25_disconnect(): ax25_kick()
puts the numbered frames on a transmit queue which is emptied, in
order, by one context at a time once the lock is dropped.

Tested in QEMU, two 4-CPU nodes with lockdep and KASAN over a KISS
serial link, four ROSE circuits each sending 400 numbered messages at
the same time: before, every circuit freezes and 300 to 600 of the 1600
messages get through; after, no sender is blocked and more than 1500
get through (the ROSE side needs "rose: process received frames and
send with the socket locked" for the rest: 1600/1600 in order on six
runs out of six with both). No lockdep, KASAN or refcount report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
[F6BVP: v2: in ax25_frames_acked(), loop on what skb_dequeue() returns
 instead of on skb_peek(): ax25_clear_queues() purges the ack queue
 without ax25->lock, so skb_dequeue() could return NULL and
 __skb_queue_tail() dereference it in softirq context (reported by
 Sasha Levin). Same fix submitted to mod-orphan.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 3f42b974059565c9e60229a9ff1ca21d10334671)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ax25.h   |  5 ++++
 net/ax25/af_ax25.c   |  2 ++
 net/ax25/ax25_out.c  | 56 ++++++++++++++++++++++++++++++++++++++++----
 net/ax25/ax25_subr.c | 37 ++++++++++++++++++++++-------
 4 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index a7bba42dde153..0fe92fa6ef075 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -252,6 +252,11 @@ typedef struct ax25_cb {
 	struct sk_buff_head	reseq_queue;
 	struct sk_buff_head	ack_queue;
 	struct sk_buff_head	frag_queue;
+	/* I frames numbered by ax25_kick(), waiting to go to the device */
+	struct sk_buff_head	xmit_queue;
+	/* serialises V(S)/V(A) and the write, ack and xmit queues */
+	spinlock_t		lock;
+	unsigned char		xmit_running;
 	unsigned char		window;
 	struct timer_list	timer, dtimer;
 	struct sock		*sk;		/* Backlink to socket */
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3ee7dba343100..164e9f46f0e77 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -537,6 +537,8 @@ ax25_cb *ax25_create_cb(void)
 	skb_queue_head_init(&ax25->frag_queue);
 	skb_queue_head_init(&ax25->ack_queue);
 	skb_queue_head_init(&ax25->reseq_queue);
+	skb_queue_head_init(&ax25->xmit_queue);
+	spin_lock_init(&ax25->lock);
 
 	ax25_setup_timers(ax25);
 
diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index 8bca2ace98e51..1b9a91b9c9831 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -218,6 +218,11 @@ void ax25_output(ax25_cb *ax25, int paclen, struct sk_buff *skb)
  *  This procedure is passed a buffer descriptor for an iframe. It builds
  *  the rest of the control part of the frame and then writes it out.
  */
+/*
+ *	Number an I frame and queue it for the device. Called by ax25_kick()
+ *	with ax25->lock held: the frame is sent by ax25_run_xmit_queue() once
+ *	the lock is dropped.
+ */
 static void ax25_send_iframe(ax25_cb *ax25, struct sk_buff *skb, int poll_bit)
 {
 	unsigned char *frame;
@@ -245,7 +250,34 @@ static void ax25_send_iframe(ax25_cb *ax25, struct sk_buff *skb, int poll_bit)
 
 	ax25_start_idletimer(ax25);
 
-	ax25_transmit_buffer(ax25, skb, AX25_COMMAND);
+	skb_queue_tail(&ax25->xmit_queue, skb);
+}
+
+/*
+ *	Hand the frames numbered by ax25_kick() to the device, in order. Only
+ *	one context does it at a time, so that frames queued by two senders
+ *	cannot overtake each other; the one already running picks up whatever
+ *	the others have queued. The lock is not held while transmitting.
+ */
+static void ax25_run_xmit_queue(ax25_cb *ax25)
+{
+	struct sk_buff *skb;
+
+	spin_lock_bh(&ax25->lock);
+	if (ax25->xmit_running) {
+		spin_unlock_bh(&ax25->lock);
+		return;
+	}
+	ax25->xmit_running = 1;
+
+	while ((skb = skb_dequeue(&ax25->xmit_queue)) != NULL) {
+		spin_unlock_bh(&ax25->lock);
+		ax25_transmit_buffer(ax25, skb, AX25_COMMAND);
+		spin_lock_bh(&ax25->lock);
+	}
+
+	ax25->xmit_running = 0;
+	spin_unlock_bh(&ax25->lock);
 }
 
 void ax25_kick(ax25_cb *ax25)
@@ -260,14 +292,25 @@ void ax25_kick(ax25_cb *ax25)
 	if (ax25->condition & AX25_COND_PEER_RX_BUSY)
 		return;
 
+	/*
+	 * ax25_kick() is called from process context by the senders and
+	 * from softirq context by the receive path and the timers, possibly
+	 * for several ROSE or NET/ROM circuits sharing this connection. Two
+	 * of them running here at the same time would read the same V(S) and
+	 * send two different frames under the same N(S); the peer keeps one
+	 * and the other is never sent again. Take the frames off the write
+	 * queue and number them under the lock.
+	 */
+	spin_lock_bh(&ax25->lock);
+
 	if (skb_peek(&ax25->write_queue) == NULL)
-		return;
+		goto out;
 
 	start = (skb_peek(&ax25->ack_queue) == NULL) ? ax25->va : ax25->vs;
 	end   = (ax25->va + ax25->window) % ax25->modulus;
 
 	if (start == end)
-		return;
+		goto out;
 
 	/*
 	 * Transmit data until either we're out of data to send or
@@ -281,7 +324,7 @@ void ax25_kick(ax25_cb *ax25)
 	 */
 	skb  = skb_dequeue(&ax25->write_queue);
 	if (!skb)
-		return;
+		goto out;
 
 	ax25->vs = start;
 
@@ -331,6 +374,11 @@ void ax25_kick(ax25_cb *ax25)
 		ax25_calculate_t1(ax25);
 		ax25_start_t1timer(ax25);
 	}
+
+out:
+	spin_unlock_bh(&ax25->lock);
+
+	ax25_run_xmit_queue(ax25);
 }
 
 void ax25_transmit_buffer(ax25_cb *ax25, struct sk_buff *skb, int type)
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index d0719267e5484..fbfeb09784119 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -34,6 +34,7 @@ void ax25_clear_queues(ax25_cb *ax25)
 {
 	skb_queue_purge(&ax25->write_queue);
 	skb_queue_purge(&ax25->ack_queue);
+	skb_queue_purge(&ax25->xmit_queue);
 	skb_queue_purge(&ax25->reseq_queue);
 	skb_queue_purge(&ax25->frag_queue);
 }
@@ -45,31 +46,51 @@ void ax25_clear_queues(ax25_cb *ax25)
  */
 void ax25_frames_acked(ax25_cb *ax25, unsigned short nr)
 {
+	struct sk_buff_head acked;
 	struct sk_buff *skb;
 
+	__skb_queue_head_init(&acked);
+
 	/*
-	 * Remove all the ack-ed frames from the ack queue.
+	 * Remove all the ack-ed frames from the ack queue. ax25_kick() may be
+	 * filling it from another CPU: move V(A) and the queue together, and
+	 * free the frames once the lock is dropped.
 	 */
-	if (ax25->va != nr) {
-		while (skb_peek(&ax25->ack_queue) != NULL && ax25->va != nr) {
-			skb = skb_dequeue(&ax25->ack_queue);
-			kfree_skb(skb);
-			ax25->va = (ax25->va + 1) % ax25->modulus;
-		}
+	spin_lock_bh(&ax25->lock);
+	/*
+	 * ax25_clear_queues() purges the ack queue without ax25->lock: test
+	 * what skb_dequeue() returns, not what skb_peek() saw before it.
+	 */
+	while (ax25->va != nr && (skb = skb_dequeue(&ax25->ack_queue)) != NULL) {
+		__skb_queue_tail(&acked, skb);
+		ax25->va = (ax25->va + 1) % ax25->modulus;
 	}
+	spin_unlock_bh(&ax25->lock);
+
+	__skb_queue_purge(&acked);
 }
 
 void ax25_requeue_frames(ax25_cb *ax25)
 {
+	struct sk_buff_head stale;
 	struct sk_buff *skb;
 
+	__skb_queue_head_init(&stale);
+
 	/*
 	 * Requeue all the un-ack-ed frames on the output queue to be picked
 	 * up by ax25_kick called from the timer. This arrangement handles the
-	 * possibility of an empty output queue.
+	 * possibility of an empty output queue. Copies that ax25_kick() has
+	 * numbered but not sent yet are stale: they will be sent again.
 	 */
+	spin_lock_bh(&ax25->lock);
+	while ((skb = skb_dequeue(&ax25->xmit_queue)) != NULL)
+		__skb_queue_tail(&stale, skb);
 	while ((skb = skb_dequeue_tail(&ax25->ack_queue)) != NULL)
 		skb_queue_head(&ax25->write_queue, skb);
+	spin_unlock_bh(&ax25->lock);
+
+	__skb_queue_purge(&stale);
 }
 
 /*
-- 
2.53.0



