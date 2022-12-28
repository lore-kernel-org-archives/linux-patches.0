Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D135A1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B9DC433D2;
	Wed, 28 Dec 2022 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245204;
	bh=TUh3zcjqJXcPH8Ndvikh/WKp9PyCEtQbYfKbxmwZ1KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEmJABoRofEbP6JB+HdRyOjJ6qXPpO3XwO9UeYR03DUpqpheFFTm24Pd/qY7Lk0XH
	 g06WTJ07HUmKC+JPztZaHFPGjToPIN7gicsh2c5HAZNASkuNDYPmiF70Hdwe/M8gyO
	 5jmp4dBYWp9dSW37iyqj/r4Eq9nOFcvBkHQY0v4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kirill Tkhai <tkhai@ya.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0850/1073] unix: Fix race in SOCK_SEQPACKETs unix_dgram_sendmsg()
Date: Wed, 28 Dec 2022 15:40:38 +0100
Message-Id: <20221228144351.107161324@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kirill Tkhai <tkhai@ya.ru>

[ Upstream commit 3ff8bff704f4de125dca2262e5b5b963a3da1d87 ]

There is a race resulting in alive SOCK_SEQPACKET socket
may change its state from TCP_ESTABLISHED to TCP_CLOSE:

unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
  sock_orphan(peer)
    sock_set_flag(peer, SOCK_DEAD)
                                           sock_alloc_send_pskb()
                                             if !(sk->sk_shutdown & SEND_SHUTDOWN)
                                               OK
                                           if sock_flag(peer, SOCK_DEAD)
                                             sk->sk_state = TCP_CLOSE
  sk->sk_shutdown = SHUTDOWN_MASK

After that socket sk remains almost normal: it is able to connect, listen, accept
and recvmsg, while it can't sendmsg.

Since this is the only possibility for alive SOCK_SEQPACKET to change
the state in such way, we should better fix this strange and potentially
danger corner case.

Note, that we will return EPIPE here like this is normally done in sock_alloc_send_pskb().
Originally used ECONNREFUSED looks strange, since it's strange to return
a specific retval in dependence of race in kernel, when user can't affect on this.

Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
to fix race with unix_dgram_connect():

unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
                                       unix_peer(sk) = NULL
                                       unix_state_unlock(sk)
  unix_state_double_lock(sk, other)
  sk->sk_state  = TCP_ESTABLISHED
  unix_peer(sk) = other
  unix_state_double_unlock(sk, other)
                                       sk->sk_state  = TCP_CLOSED

This patch fixes both of these races.

Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
Link: https://lore.kernel.org/r/135fda25-22d5-837a-782b-ceee50e19844@ya.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 02fad8e8f4cd..48cc8223b06b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1969,13 +1969,20 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			unix_state_lock(sk);
 
 		err = 0;
-		if (unix_peer(sk) == other) {
+		if (sk->sk_type == SOCK_SEQPACKET) {
+			/* We are here only when racing with unix_release_sock()
+			 * is clearing @other. Never change state to TCP_CLOSE
+			 * unlike SOCK_DGRAM wants.
+			 */
+			unix_state_unlock(sk);
+			err = -EPIPE;
+		} else if (unix_peer(sk) == other) {
 			unix_peer(sk) = NULL;
 			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
 
+			sk->sk_state = TCP_CLOSE;
 			unix_state_unlock(sk);
 
-			sk->sk_state = TCP_CLOSE;
 			unix_dgram_disconnected(sk, other);
 			sock_put(other);
 			err = -ECONNREFUSED;
-- 
2.35.1



