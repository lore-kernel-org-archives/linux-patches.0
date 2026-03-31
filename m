Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6198D2C21F2;
	Tue, 31 Mar 2026 17:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976693; cv=none; b=cYqAN2gxzn8mMsdzSwnCVnr0DnanuqV6almcLLNQWuulZNUqqxK2L710LaNfwxG8r31IijeacXxHmDx8/UsII4/Qr4PuGno6KnRx2ElDGWpcyH0JTIWHsQ+CYaJFo5EJ8NpPlzkLwGtda9OvSq04WhU4+nRwvt+sMwmidk1e9RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976693; c=relaxed/simple;
	bh=cj7sj7qZEc6EOo/0pxV6V20W+/99KpU1/fXsL+Whf5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guUpVI7Ahh/xUmRQgXH5n7SBLn3MbfCPLGueyPhubU81AIjq7FA6t2EdxMhqKkQrrIzF3g7TRiFr0EB87SI7NJ7W5CPL3H8ACRJFpVzZNdbqZ7okUylxDiaCghMNwNdUobjjQvATumyTqKQxjnxt+kmRY7vYSHaQJJHbBWKGXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yVh1apq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yVh1apq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9940C19423;
	Tue, 31 Mar 2026 17:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976693;
	bh=cj7sj7qZEc6EOo/0pxV6V20W+/99KpU1/fXsL+Whf5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yVh1apquSj8vyh4d5TN/D/8WpwngP+wddiMIKZ8wyMwiQEsUJN6RwjgpOOArOJ9K
	 if1KmB7G8n+fNVmvZOQKbhV5nwleqdlqyGNExHroMKxvRwUlIVclTNVJjhehu16R9k
	 gZoI4ipF7elWi2iGEESPXT2jDQb3paKEd8ui+gqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Norouzi <ali.norouzi@keysight.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 191/309] can: isotp: fix tx.buf use-after-free in isotp_sendmsg()
Date: Tue, 31 Mar 2026 18:21:34 +0200
Message-ID: <20260331161800.488014996@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 424e95d62110cdbc8fd12b40918f37e408e35a92 upstream.

isotp_sendmsg() uses only cmpxchg() on so->tx.state to serialize access
to so->tx.buf. isotp_release() waits for ISOTP_IDLE via
wait_event_interruptible() and then calls kfree(so->tx.buf).

If a signal interrupts the wait_event_interruptible() inside close()
while tx.state is ISOTP_SENDING, the loop exits early and release
proceeds to force ISOTP_SHUTDOWN and continues to kfree(so->tx.buf)
while sendmsg may still be reading so->tx.buf for the final CAN frame
in isotp_fill_dataframe().

The so->tx.buf can be allocated once when the standard tx.buf length needs
to be extended. Move the kfree() of this potentially extended tx.buf to
sk_destruct time when either isotp_sendmsg() and isotp_release() are done.

Fixes: 96d1c81e6a04 ("can: isotp: add module parameter for maximum pdu size")
Cc: stable@vger.kernel.org
Reported-by: Ali Norouzi <ali.norouzi@keysight.com>
Co-developed-by: Ali Norouzi <ali.norouzi@keysight.com>
Signed-off-by: Ali Norouzi <ali.norouzi@keysight.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260319-fix-can-gw-and-can-isotp-v2-2-c45d52c6d2d8@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1230,12 +1230,6 @@ static int isotp_release(struct socket *
 	so->ifindex = 0;
 	so->bound = 0;
 
-	if (so->rx.buf != so->rx.sbuf)
-		kfree(so->rx.buf);
-
-	if (so->tx.buf != so->tx.sbuf)
-		kfree(so->tx.buf);
-
 	sock_orphan(sk);
 	sock->sk = NULL;
 
@@ -1604,6 +1598,21 @@ static int isotp_notifier(struct notifie
 	return NOTIFY_DONE;
 }
 
+static void isotp_sock_destruct(struct sock *sk)
+{
+	struct isotp_sock *so = isotp_sk(sk);
+
+	/* do the standard CAN sock destruct work */
+	can_sock_destruct(sk);
+
+	/* free potential extended PDU buffers */
+	if (so->rx.buf != so->rx.sbuf)
+		kfree(so->rx.buf);
+
+	if (so->tx.buf != so->tx.sbuf)
+		kfree(so->tx.buf);
+}
+
 static int isotp_init(struct sock *sk)
 {
 	struct isotp_sock *so = isotp_sk(sk);
@@ -1648,6 +1657,9 @@ static int isotp_init(struct sock *sk)
 	list_add_tail(&so->notifier, &isotp_notifier_list);
 	spin_unlock(&isotp_notifier_lock);
 
+	/* re-assign default can_sock_destruct() reference */
+	sk->sk_destruct = isotp_sock_destruct;
+
 	return 0;
 }
 


