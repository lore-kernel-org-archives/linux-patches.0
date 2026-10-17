Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AAE9460;
	Sat, 17 Oct 2026 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258864; cv=none; b=FGsw0FCDSUqiLTnnbEt6th6lutKpuSGdxtV+AQqhx9rFDuldqAy9eHOdzSC8ZEJyMOeVBlq7PTPj4MlyIIl8Uo+OQyBZh9G2+6Xk74UI/jPpq8duy6LO47s5pJoMhIv8nauUS3KoWzuibstaP9uMD8t6DtYkVHWNt+glLwz5XZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258864; c=relaxed/simple;
	bh=Tg4TbNCxm1fOOZIJyxuKKskAFn73yt7XTa2Wlx6hBUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GRsSGbEjpMnksYMaABBY+yOgGOzSB9fI/PLuKQ8IoSI48CyLSt4Y+YH8lMNwOnLHmGZfzZX+xjMi7vdTIbXbv6eZLKsXVqv79J6jtjBZXfujwjq6gJE0yCUjg7nBWlgYpdXFTV5PR9m3fWc9YS+cvDKUocDXcBBqzCOY4AqqA3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsXBxoDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsXBxoDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E101F000C4;
	Sat, 17 Oct 2026 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258863;
	bh=fiw6IZfQTHxkP3WFzXVR11obyBY3iazlUO5Yivv5O/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsXBxoDXcNUeARUGrLlRchHyKC2He8NImtfhUULYNTUpJ9WAUMWMA5RDBdX1nXon1
	 e7J5SJ75P53W9kD30JVVg/9WuwMrY0F5yYBF9hAOwIlgix4RPUV8Gd1QEWorJXK51v
	 SOVAFdAly5h64N4f1ITrcfHwFQWG/m1wRwnloE60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+706f5eb79044e686c794@syzkaller.appspotmail.com,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Morduan Zang <zhangdandan@uniontech.com>,
	zhanjun <zhanjun@uniontech.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1025/1674] net: phonet: do not BUG_ON() in pn_socket_autobind() on failed bind
Date: Sat, 17 Oct 2026 17:54:57 +0200
Message-ID: <20261017160457.443715118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Morduan Zang <zhangdandan@uniontech.com>

[ Upstream commit 5b0c911bcdbd982f7748d11c0b39ec5808eae2de ]

syzbot reported a kernel BUG triggered from pn_socket_sendmsg() via
pn_socket_autobind():

  kernel BUG at net/phonet/socket.c:213!
  RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
  RIP: 0010:pn_socket_sendmsg+0x240/0x250 net/phonet/socket.c:421
  Call Trace:
   sock_sendmsg_nosec+0x112/0x150 net/socket.c:797
   __sock_sendmsg net/socket.c:812 [inline]
   __sys_sendto+0x402/0x590 net/socket.c:2280
   ...

pn_socket_autobind() calls pn_socket_bind() with port 0 and, on
-EINVAL, assumes the socket was already bound and asserts that the
port is non-zero:

  err = pn_socket_bind(sock, ..., sizeof(struct sockaddr_pn));
  if (err != -EINVAL)
          return err;
  BUG_ON(!pn_port(pn_sk(sock->sk)->sobject));
  return 0; /* socket was already bound */

However pn_socket_bind() also returns -EINVAL when sk->sk_state is not
TCP_CLOSE, even when the socket has never been bound and pn_port() is
still 0.  In that case the BUG_ON() fires and panics the kernel from a
user-triggerable path.

Treat the "bind returned -EINVAL but pn_port() is still 0" case as a
regular error and propagate -EINVAL to the caller instead of crashing.
Existing callers already translate a non-zero return from
pn_socket_autobind() into -ENOBUFS/-EAGAIN, so returning -EINVAL here
only changes behaviour from panic to a normal errno.

Fixes: ba113a94b750 ("Phonet: common socket glue")
Reported-by: syzbot+706f5eb79044e686c794@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=706f5eb79044e686c794
Suggested-by: Remi Denis-Courmont <courmisch@gmail.com>
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
Signed-off-by: zhanjun <zhanjun@uniontech.com>
Acked-by: Rémi Denis-Courmont <remi@remlab.net>
Link: https://patch.msgid.link/87A8960A2045AF3C+20260423010557.138124-1-zhangdandan@uniontech.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/socket.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 1018340d89a7d..0b93de85802c9 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -208,9 +208,15 @@ static int pn_socket_autobind(struct socket *sock)
 	sa.spn_family = AF_PHONET;
 	err = pn_socket_bind(sock, (struct sockaddr *)&sa,
 				sizeof(struct sockaddr_pn));
-	if (err != -EINVAL)
+	/*
+	 * pn_socket_bind() also returns -EINVAL when sk_state != TCP_CLOSE
+	 * without a prior bind, so -EINVAL alone is not sufficient to infer
+	 * that the socket was already bound.  Only treat it as "already
+	 * bound" when the port is non-zero; otherwise propagate the error
+	 * instead of crashing the kernel.
+	 */
+	if (err != -EINVAL || unlikely(!pn_port(pn_sk(sock->sk)->sobject)))
 		return err;
-	BUG_ON(!pn_port(pn_sk(sock->sk)->sobject));
 	return 0; /* socket was already bound */
 }
 
-- 
2.53.0



