Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590938;
	b=T+zh5ISasuoVqFjJT+gJUeSZrvOlUFH24l8Md4FkCN841bvdmL3aZr0+F+qMKa2rl3wc
	 DIxkovUhQGzFQYjApRFQ8jXkZq8CFrffgFCoOY6yxdxx2PM7oZmMg57hOsmAOu2CyjoRg
	 knatOAo+a4JO6iE4BQU7AA9hpjmWfPFfviWOwtqrlEafAFBsyDAVuQdHCucnBwBM4nYgW
	 gloxpuwMWJikaf7JyS2vPLCNJ4rKUE9OdzKqGxRfYOQhdTJg9Jt6QHplc8vyTt8bmIV3z
	 wH+srVn+mferbTDbm7UgENnihDhOWVdnnX1i7t4YsX98dljG80V59Jzhp0Z9dch8x5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4jjJ5ft182jm/YB5kMHOtLEwLcAyurptWgVTpCUy4Qc=;
	b=UcR+q9Xz3myyOrkfY4EDLl0KfuvK/nZ592ub4Qh5msPlkQ220YmYbtpH4t7P0uEkdBcy
	 0CHlAxbJwBAENEcRAwDuBb3916qrbABSAyJ6YwIenUG51YOEDD7ckiDiH7W6wedW8YSbF
	 KCwEiwyDNZyCmaOY+09RlUhuYySYgNxn1K7Q6LX2pDi6skgZEDjr6aQdRPMRzNBDoxlYh
	 7m4HOgI95Pt5JBDf+J73ngrRc3lAHnUp/B/VjFyA1L9HHKAny2CC1ACygs+MaTuZYThoQ
	 fpgCReMFtToSjbmrqTu79qqex+z5izioMp9Fvw1dqKNpc/2DjW5Zuv12R0QDP3HVkIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5nZ4dN3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05DC606B450;
	Fri, 13 Nov 2026 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5nZ4dN3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7501F000C5;
	Fri, 13 Nov 2026 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590937;
	bh=4jjJ5ft182jm/YB5kMHOtLEwLcAyurptWgVTpCUy4Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5nZ4dN3nQEw3QzvbZjIL5mOrk7+lJ1H4GjIaI95ptSxOSJlbOtTPrq6LW3QVsU74
	 P1QYcC3IIeD4ObIaLrfmir4Hf71QYoJaWpMcdw7ofmEk7eA5kEs6a/n+dNJgqzVJ+i
	 g09sDOPaIjftE+gOQZ17qt+Xg7j/Sh+waabt7axc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/670] ax25: let a socket connect again after a failed or ended connection
Date: Fri, 13 Nov 2026 10:44:46 -0500
Message-ID: <20261113153815.952319937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

When a connection fails or ends, ax25_disconnect() sets SOCK_DEAD on
the socket and shuts it down for sending, although the socket is still
open and its owner may call connect() again. ax25_connect() resets the
socket states but leaves both:

- the new attempt changes the state under SOCK_DEAD, and both
  ax25_disconnect() and the UA handling in state 1 skip
  sk_state_change() on a SOCK_DEAD socket: a blocking connect() is
  never woken up, whether the new link comes up or fails, and returns
  only on a signal;

- once connected, every send() fails with -EPIPE, since sendmsg()
  tests SEND_SHUTDOWN first.

Clear SOCK_DEAD and sk_shutdown when connect() starts a new attempt.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). A listens on TESTA-9. B calls TESTA-8, where
nobody listens, then calls TESTA-9 with the same socket, a 20 s alarm
set, and sends a message:

  before: the second connect() returns only when the alarm fires
          20 s later, send() fails with -EPIPE, A receives nothing
  after:  the second connect() returns at once, send() succeeds and
          A receives the message

Applications that open a new socket for each call are not affected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit d3773f1e0b60711b93529c658b672633f55f19fc)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 43f4ea1ef88e8..6ee944e575bd8 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1302,6 +1302,15 @@ static int __must_check ax25_connect(struct socket *sock,
 		goto out_release;
 	}
 
+	/*
+	 * A connection that failed or ended through ax25_disconnect() left
+	 * the socket SOCK_DEAD and shut down for sending. The socket is still
+	 * its owner's: start afresh, or the state changes of the new attempt
+	 * would wake no one and every send() would fail with -EPIPE.
+	 */
+	sock_reset_flag(sk, SOCK_DEAD);
+	sk->sk_shutdown = 0;
+
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
-- 
2.53.0



