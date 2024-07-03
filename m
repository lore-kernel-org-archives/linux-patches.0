Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E96176FBD;
	Wed,  3 Jul 2024 11:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005254; cv=none; b=TjxgRQeppu9rA2jXiMeOZCWgL/TtnKYZzgJXMgAp2XNm0YnTB0CDmkUCgdzX4PGPkl0FWJSTAwqdtrql9qZ+7DTMTk7Q0eEmNC2tOIJVNVzLYa8acmAPzZ1QTq4hHuoZLaP1HIeuNKbyi4/NUVkp9WVbBJUKdxkY7p4R9S4XLhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005254; c=relaxed/simple;
	bh=aXXQt4+VxBCUvIEwEC/qbwiYuJO9ia/tcga8MRJtIRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxZlIzIEH3tDccCfVZz2FXG1T5Imbj9e7iHlwxfrN21GvbjD2FcsL/VdewKPM2027DIXmof2hV1t2F91B8b3QojJ5gmBoGj90XvUD0cSwRxAx27gYDQNkEszrvEbKU1et52/URktwYD9JclLR3C0rOmhoOs7Fiv6X+GsikV2eps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwJ4PJzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwJ4PJzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D1AC2BD10;
	Wed,  3 Jul 2024 11:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005254;
	bh=aXXQt4+VxBCUvIEwEC/qbwiYuJO9ia/tcga8MRJtIRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwJ4PJzpRncX5MZ22ltWKI8aHBwNpBs95awjcfICHpjhmP/QTuU6xteNqWJsTSS4P
	 WV6lo3zTdgf8enoRqQExCifF8vA5b4smEKtpR3WrnF1MokMV9hcvzFjG+rqy6rG1cE
	 uplhE9ginjTiddsP1bC7Agk1QlXEj2wNw2Hp2PY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/356] af_unix: Set sk->sk_state under unix_state_lock() for truly disconencted peer.
Date: Wed,  3 Jul 2024 12:35:56 +0200
Message-ID: <20240703102913.864509376@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 80f91b5ab4012..914e40697f00a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -495,7 +495,6 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 			sk_error_report(other);
 		}
 	}
-	other->sk_state = TCP_CLOSE;
 }
 
 static void unix_sock_destructor(struct sock *sk)
@@ -1277,8 +1276,15 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 
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



