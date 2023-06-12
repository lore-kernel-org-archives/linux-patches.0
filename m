Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2E7D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3305DC433EF;
	Mon, 12 Jun 2023 10:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566948;
	bh=cZfWCa99St9eb01zjbzxJth1IR50E8rE0F8769taugE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWB7B9BEpV0FBspdUpJpb60hXVwMwJuLOox9WQWUYk3uOTLrQodwPUYDrWIcHPEHP
	 8kxvf2HypTmOI2KbSZ4qOXBAyA8QSyGNPpEkdWR0Kqmn+DinnW+1HXnuw9WUWC67Ll
	 bO9mDW7wpgGvH2fQ5GPopUmEG5dWKN6+aKXDpvEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.3 093/160] can: j1939: j1939_sk_send_loop_abort(): improved error queue handling in J1939 Socket
Date: Mon, 12 Jun 2023 12:27:05 +0200
Message-ID: <20230612101719.278069942@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 2a84aea80e925ecba6349090559754f8e8eb68ef upstream.

This patch addresses an issue within the j1939_sk_send_loop_abort()
function in the j1939/socket.c file, specifically in the context of
Transport Protocol (TP) sessions.

Without this patch, when a TP session is initiated and a Clear To Send
(CTS) frame is received from the remote side requesting one data packet,
the kernel dispatches the first Data Transport (DT) frame and then waits
for the next CTS. If the remote side doesn't respond with another CTS,
the kernel aborts due to a timeout. This leads to the user-space
receiving an EPOLLERR on the socket, and the socket becomes active.

However, when trying to read the error queue from the socket with
sock.recvmsg(, , socket.MSG_ERRQUEUE), it returns -EAGAIN,
given that the socket is non-blocking. This situation results in an
infinite loop: the user-space repeatedly calls epoll(), epoll() returns
the socket file descriptor with EPOLLERR, but the socket then blocks on
the recv() of ERRQUEUE.

This patch introduces an additional check for the J1939_SOCK_ERRQUEUE
flag within the j1939_sk_send_loop_abort() function. If the flag is set,
it indicates that the application has subscribed to receive error queue
messages. In such cases, the kernel can communicate the current transfer
state via the error queue. This allows for the function to return early,
preventing the unnecessary setting of the socket into an error state,
and breaking the infinite loop. It is crucial to note that a socket
error is only needed if the application isn't using the error queue, as,
without it, the application wouldn't be aware of transfer issues.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-by: David Jander <david@protonic.nl>
Tested-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20230526081946.715190-1-o.rempel@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/socket.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -1088,6 +1088,11 @@ void j1939_sk_errqueue(struct j1939_sess
 
 void j1939_sk_send_loop_abort(struct sock *sk, int err)
 {
+	struct j1939_sock *jsk = j1939_sk(sk);
+
+	if (jsk->state & J1939_SOCK_ERRQUEUE)
+		return;
+
 	sk->sk_err = err;
 
 	sk_error_report(sk);


