Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D4914900C;
	Wed, 19 Jun 2024 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802122; cv=none; b=qIFOqSnaGW6nmgA5iq1fX7LL6tWHHPofbq8NjFld2SAE31LytAgZBTPcuFD4PR+Ktu1kX2ofU3obwRHgJn4xxNC+WP24GvIok2mFO623owH5Cf4l83n+7XsMpzH+XIoMRs53TJz+MWVmJmJrXTwyg9YbPoqBeyIWYJ74HImK8Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802122; c=relaxed/simple;
	bh=EcWbleftUVtE2ZTnWOYHNP/BklYxmsB+HKgDARHz/+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhatTbOIgDKs0uvf4mgcK9nNH/YfYI53aA40vH1KPd11KcdZy6JzSE89/hBpQj8Q9CSevYAnZBJx0cF5UOiHVZ8JU3X7VHYbG6db7n8ldwP7YzWm9YweJl+qL3neFkcgR7cwAUvlbB1k82jTHUngmo9CTrrvOtvQ1lQBePrGlik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNZQ0ADf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNZQ0ADf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5EEC2BBFC;
	Wed, 19 Jun 2024 13:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802122;
	bh=EcWbleftUVtE2ZTnWOYHNP/BklYxmsB+HKgDARHz/+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNZQ0ADfPgdQ9k6GIdr0qAxIVUkgRlpY1HKZcGNpU5VV2udkVXsoMjzgU+L3DPhhF
	 QeDQGwj93bMGGvy3W3Lg+tQPv/O2ODfXH1c9kgqatjoI5610UvXKumfCaIw+p3528E
	 DXdAHk9eHnuXWHmGlODbqkIa4hdI3Yf8TwMzKCjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/267] af_unix: Set sk->sk_state under unix_state_lock() for truly disconencted peer.
Date: Wed, 19 Jun 2024 14:53:19 +0200
Message-ID: <20240619125608.209095299@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 26bfb8b57063f52b867f9b6c8d1742fcb5bd656c ]

When a SOCK_DGRAM socket connect()s to another socket, the both sockets'
sk->sk_state are changed to TCP_ESTABLISHED so that we can register them
to BPF SOCKMAP.

When the socket disconnects from the peer by connect(AF_UNSPEC), the state
is set back to TCP_CLOSE.

Then, the peer's state is also set to TCP_CLOSE, but the update is done
locklessly and unconditionally.

Let's say socket A connect()ed to B, B connect()ed to C, and A disconnects
from B.

After the first two connect()s, all three sockets' sk->sk_state are
TCP_ESTABLISHED:

  $ ss -xa
  Netid State  Recv-Q Send-Q  Local Address:Port  Peer Address:PortProcess
  u_dgr ESTAB  0      0       @A 641              * 642
  u_dgr ESTAB  0      0       @B 642              * 643
  u_dgr ESTAB  0      0       @C 643              * 0

And after the disconnect, B's state is TCP_CLOSE even though it's still
connected to C and C's state is TCP_ESTABLISHED.

  $ ss -xa
  Netid State  Recv-Q Send-Q  Local Address:Port  Peer Address:PortProcess
  u_dgr UNCONN 0      0       @A 641              * 0
  u_dgr UNCONN 0      0       @B 642              * 643
  u_dgr ESTAB  0      0       @C 643              * 0

In this case, we cannot register B to SOCKMAP.

So, when a socket disconnects from the peer, we should not set TCP_CLOSE to
the peer if the peer is connected to yet another socket, and this must be
done under unix_state_lock().

Note that we use WRITE_ONCE() for sk->sk_state as there are many lockless
readers.  These data-races will be fixed in the following patches.

Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d01314dc86ecb..348f9e34f6696 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -571,7 +571,6 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 			sk_error_report(other);
 		}
 	}
-	other->sk_state = TCP_CLOSE;
 }
 
 static void unix_sock_destructor(struct sock *sk)
@@ -1434,8 +1433,15 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 
 		unix_state_double_unlock(sk, other);
 
-		if (other != old_peer)
+		if (other != old_peer) {
 			unix_dgram_disconnected(sk, old_peer);
+
+			unix_state_lock(old_peer);
+			if (!unix_peer(old_peer))
+				WRITE_ONCE(old_peer->sk_state, TCP_CLOSE);
+			unix_state_unlock(old_peer);
+		}
+
 		sock_put(old_peer);
 	} else {
 		unix_peer(sk) = other;
-- 
2.43.0



