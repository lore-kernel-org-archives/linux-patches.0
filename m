Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E562F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68ACC433EF;
	Wed, 12 Apr 2023 08:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289478;
	bh=JJ9nssTwufA28MFU7n5bX97ooj8HJFUxVwvZdpFq9ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltLsP2WYVR0WLllpH1fX3YVD4Wh9F0GPa2uPCkWoRQzdTRnFexR1wjNIAsCaheByv
	 TqB+1sPu+oHcGlGSS93Qlux77aCHXZjzTa4kHmkSxCepoBgmA4nnVzeJ1pukm5hC/W
	 p8v4UDY7oMqm/y5AG9jqH3/BCzC1Xiz51eIy+gO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Sojka <michal.sojka@cvut.cz>,
	Jakub Jira <jirajak2@fel.cvut.cz>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.2 114/173] can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events
Date: Wed, 12 Apr 2023 10:34:00 +0200
Message-Id: <20230412082842.691135151@linuxfoundation.org>
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

From: Michal Sojka <michal.sojka@cvut.cz>

commit 79e19fa79cb5d5f1b3bf3e3ae24989ccb93c7b7b upstream.

When using select()/poll()/epoll() with a non-blocking ISOTP socket to
wait for when non-blocking write is possible, a false EPOLLOUT event
is sometimes returned. This can happen at least after sending a
message which must be split to multiple CAN frames.

The reason is that isotp_sendmsg() returns -EAGAIN when tx.state is
not equal to ISOTP_IDLE and this behavior is not reflected in
datagram_poll(), which is used in isotp_ops.

This is fixed by introducing ISOTP-specific poll function, which
suppresses the EPOLLOUT events in that case.

v2: https://lore.kernel.org/all/20230302092812.320643-1-michal.sojka@cvut.cz
v1: https://lore.kernel.org/all/20230224010659.48420-1-michal.sojka@cvut.cz
    https://lore.kernel.org/all/b53a04a2-ba1f-3858-84c1-d3eb3301ae15@hartkopp.net

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
Reported-by: Jakub Jira <jirajak2@fel.cvut.cz>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20230331125511.372783-1-michal.sojka@cvut.cz
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1615,6 +1615,21 @@ static int isotp_init(struct sock *sk)
 	return 0;
 }
 
+static __poll_t isotp_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct isotp_sock *so = isotp_sk(sk);
+
+	__poll_t mask = datagram_poll(file, sock, wait);
+	poll_wait(file, &so->wait, wait);
+
+	/* Check for false positives due to TX state */
+	if ((mask & EPOLLWRNORM) && (so->tx.state != ISOTP_IDLE))
+		mask &= ~(EPOLLOUT | EPOLLWRNORM);
+
+	return mask;
+}
+
 static int isotp_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -1630,7 +1645,7 @@ static const struct proto_ops isotp_ops
 	.socketpair = sock_no_socketpair,
 	.accept = sock_no_accept,
 	.getname = isotp_getname,
-	.poll = datagram_poll,
+	.poll = isotp_poll,
 	.ioctl = isotp_sock_no_ioctlcmd,
 	.gettstamp = sock_gettstamp,
 	.listen = sock_no_listen,


