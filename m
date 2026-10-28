Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215128;
	b=BTZOL5Oq3KDaJK7Sbrld54dMWRD3RWQu5aBFwL0VKTnKtCvj2lnvVmpDwAis5cG/m7BM
	 TjyXSTlcvc+kfaxBL+ukVOOFNEbn3bppXuTmxSNzv0IcgIpDK1d96VSqHGtGF1/DmekdS
	 H7KFPZ/LXj9qyiMulueb2QuFLUwjiGSPfIs7ax3x1dhC5LzEFAt7/JE9KPLzfjV/RpzgK
	 OsEvLHBABeEHYlRFpzkkzxW4BO+lSGUsFRM0gSbNdvHs3oKTlKbJ5aMi0OWV86iZDQD5r
	 g+VpCWhOkccxG2uMFUVaKB/qoAFfSbe1HuPfpVtrHuobEOgOtQB3y5LmSdZDUCLVAVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=a0ziMax+DtCxEDbDQl+3u+my7m1GLdXwvLU7A6C3spY=;
	b=QEwDKLsWtbEpoBoP393u6GAasZbUM8pLxT+gMuFq6GTPlY5NG7CO4QIXHtM2w6OTpuAj
	 bKLVqw0G1z8OgepUVC4VdV44BBe/KwyoB1ouwXG+4HSLAVkODprFI6JasZyccEWes8JiS
	 NigIm1nBBesUfcNQGuKKNIZPCTkpEr1ZjkF+6C30rVSoDeOJpnrIRCDMgZ377m4j0IDxp
	 GixZPmG0jZSJ8Q3EsIdcbbUKk26eT74LvElzvbl6u/KXAZUR5TssP4H0hT0h4SX58KdG+
	 XbFpuN9RzAoBD52Q/NpxCC1ZcOzHKJcST44juzWwCizx7waHBD5d+TL5i/4bxmB67ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hDY1pLp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69C7606A321;
	Wed, 28 Oct 2026 19:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hDY1pLp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5551F01825;
	Wed, 28 Oct 2026 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215127;
	bh=a0ziMax+DtCxEDbDQl+3u+my7m1GLdXwvLU7A6C3spY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hDY1pLpaB5DpeII1xATfAY3CGTN2JsOFzFO59VdQqPEtM9eDsvcyJW5nDJr5kfeQ
	 B3za2XzjrWOAryJivgNV3eTln0qyeqT3qbh4dfIxS1BFN0tZkSwnnhg5H/KAUjIBct
	 RKd8PbzwN5Oxz4wIByrz8pwdsJVsSHIzdRjBj6Cg=
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
Subject: [PATCH 6.1 1103/1887] net: phonet: do not BUG_ON() in pn_socket_autobind() on failed bind
Date: Wed, 28 Oct 2026 17:53:19 +0100
Message-ID: <20261028170524.506171905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 71e2caf6ab859..c15eef4316506 100644
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



