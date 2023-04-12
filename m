Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08C12F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268B0C433D2;
	Wed, 12 Apr 2023 08:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289475;
	bh=dqOfdoiMD5nlhVVX/fukRIEfw9Nvjb0Ds7Q8VFsAq7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdPq2xTNWZtfEIKnw+/LFhPeqJTf29kkMnokkU6uQBQttmjdHi5PZbw+F05RYiN4W
	 sLnEk5thUAR6bBHjj1RtbGok9NpkWJ89Sd1PtvN32HMeQ00BEJiCcctFzdcGKEL1j5
	 JZfrPHeBxgE/PMUjYUwUrnRnp4QJsrB4+SzuN5lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dae R. Jeong" <threeearcat@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.2 113/173] can: isotp: fix race between isotp_sendsmg() and isotp_release()
Date: Wed, 12 Apr 2023 10:33:59 +0200
Message-Id: <20230412082842.647047452@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 051737439eaee5bdd03d3c2ef5510d54a478fd05 upstream.

As discussed with Dae R. Jeong and Hillf Danton here [1] the sendmsg()
function in isotp.c might get into a race condition when restoring the
former tx.state from the old_state.

Remove the old_state concept and implement proper locking for the
ISOTP_IDLE transitions in isotp_sendmsg(), inspired by a
simplification idea from Hillf Danton.

Introduce a new tx.state ISOTP_SHUTDOWN and use the same locking
mechanism from isotp_release() which resolves a potential race between
isotp_sendsmg() and isotp_release().

[1] https://lore.kernel.org/linux-can/ZB%2F93xJxq%2FBUqAgG@dragonet

v1: https://lore.kernel.org/all/20230331102114.15164-1-socketcan@hartkopp.net
v2: https://lore.kernel.org/all/20230331123600.3550-1-socketcan@hartkopp.net
    take care of signal interrupts for wait_event_interruptible() in
    isotp_release()
v3: https://lore.kernel.org/all/20230331130654.9886-1-socketcan@hartkopp.net
    take care of signal interrupts for wait_event_interruptible() in
    isotp_sendmsg() in the wait_tx_done case
v4: https://lore.kernel.org/all/20230331131935.21465-1-socketcan@hartkopp.net
    take care of signal interrupts for wait_event_interruptible() in
    isotp_sendmsg() in ALL cases

Cc: Dae R. Jeong <threeearcat@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Fixes: 4f027cba8216 ("can: isotp: split tx timer into transmission and timeout")
Link: https://lore.kernel.org/all/20230331131935.21465-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
[mkl: rephrase commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   55 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -119,7 +119,8 @@ enum {
 	ISOTP_WAIT_FIRST_FC,
 	ISOTP_WAIT_FC,
 	ISOTP_WAIT_DATA,
-	ISOTP_SENDING
+	ISOTP_SENDING,
+	ISOTP_SHUTDOWN,
 };
 
 struct tpcon {
@@ -880,8 +881,8 @@ static enum hrtimer_restart isotp_tx_tim
 					     txtimer);
 	struct sock *sk = &so->sk;
 
-	/* don't handle timeouts in IDLE state */
-	if (so->tx.state == ISOTP_IDLE)
+	/* don't handle timeouts in IDLE or SHUTDOWN state */
+	if (so->tx.state == ISOTP_IDLE || so->tx.state == ISOTP_SHUTDOWN)
 		return HRTIMER_NORESTART;
 
 	/* we did not get any flow control or echo frame in time */
@@ -918,7 +919,6 @@ static int isotp_sendmsg(struct socket *
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
-	u32 old_state = so->tx.state;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
@@ -928,23 +928,24 @@ static int isotp_sendmsg(struct socket *
 	int off;
 	int err;
 
-	if (!so->bound)
+	if (!so->bound || so->tx.state == ISOTP_SHUTDOWN)
 		return -EADDRNOTAVAIL;
 
+wait_free_buffer:
 	/* we do not support multiple buffers - for now */
-	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
-	    wq_has_sleeper(&so->wait)) {
-		if (msg->msg_flags & MSG_DONTWAIT) {
-			err = -EAGAIN;
-			goto err_out;
-		}
+	if (wq_has_sleeper(&so->wait) && (msg->msg_flags & MSG_DONTWAIT))
+		return -EAGAIN;
 
-		/* wait for complete transmission of current pdu */
-		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
-		if (err)
-			goto err_out;
+	/* wait for complete transmission of current pdu */
+	err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+	if (err)
+		goto err_event_drop;
+
+	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE) {
+		if (so->tx.state == ISOTP_SHUTDOWN)
+			return -EADDRNOTAVAIL;
 
-		so->tx.state = ISOTP_SENDING;
+		goto wait_free_buffer;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH) {
@@ -1074,7 +1075,9 @@ static int isotp_sendmsg(struct socket *
 
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
-		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		if (err)
+			goto err_event_drop;
 
 		if (sk->sk_err)
 			return -sk->sk_err;
@@ -1082,13 +1085,15 @@ static int isotp_sendmsg(struct socket *
 
 	return size;
 
+err_event_drop:
+	/* got signal: force tx state machine to be idle */
+	so->tx.state = ISOTP_IDLE;
+	hrtimer_cancel(&so->txfrtimer);
+	hrtimer_cancel(&so->txtimer);
 err_out_drop:
 	/* drop this PDU and unlock a potential wait queue */
-	old_state = ISOTP_IDLE;
-err_out:
-	so->tx.state = old_state;
-	if (so->tx.state == ISOTP_IDLE)
-		wake_up_interruptible(&so->wait);
+	so->tx.state = ISOTP_IDLE;
+	wake_up_interruptible(&so->wait);
 
 	return err;
 }
@@ -1150,10 +1155,12 @@ static int isotp_release(struct socket *
 	net = sock_net(sk);
 
 	/* wait for complete transmission of current pdu */
-	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+	while (wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE) == 0 &&
+	       cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SHUTDOWN) != ISOTP_IDLE)
+		;
 
 	/* force state machines to be idle also when a signal occurred */
-	so->tx.state = ISOTP_IDLE;
+	so->tx.state = ISOTP_SHUTDOWN;
 	so->rx.state = ISOTP_IDLE;
 
 	spin_lock(&isotp_notifier_lock);


