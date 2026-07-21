Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17B846EF6B;
	Tue, 21 Jul 2026 19:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661344; cv=none; b=Vi1ECM6zDRDIZ13XBS707Z2zJ060xcffvqrN8q6rhPLI+3sHoKkjVMjxpcjNGcmfdX1DGNCnK4MPObCTkisxuQt/9yllQ04GGAZsXDaA2lS1edGQ6+Y+BoxGhxl2JQcQWXweIvUB+Yy0h2mzzTmGoMiz6I/20stMHCNEnInjZ/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661344; c=relaxed/simple;
	bh=k7NxUikLLhX15ZJI6rs1L6Wvr4OQHShyuMY76JKlZag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exF7XHUopPed4qUDEsHN5Ee/HbcmGNih9NyS6HdoX2vH98GqrcPgsKsGpSaBtnd+vPKD7r6WlmM08jPL1D+xMIj2Xhetj/PGNC+ud2Y7Z5X1ghAPfEE+IIoxhT1wZb+4m0a4GNJs1NQ1iL8BXmf5UvJ9qudJJWWn+Aw5SZNP5Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsP8Xrby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsP8Xrby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA981F000E9;
	Tue, 21 Jul 2026 19:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661343;
	bh=DjHJ+4gqYxBwB+sA3CzukBXcvYV4vfFT6QE1Wuqq8VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsP8XrbyQd58vYxLcLqLKGI5LmzDMohHdgJ6UXWF/KKMnJYkxIHO1vGpdA1d8a5et
	 oTZt2XrsW9zmj3zSapU7NEB3g/wkRs3rJyzo3P9NACn0m+tUzHE+/rCFWpTddLaYM6
	 rujh3Css8m7kuc3hyHfLClxMYmo4kd+TAixxRmL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0031/1276] af_unix: Dont hold unix_state_lock() in __unix_dgram_recvmsg().
Date: Tue, 21 Jul 2026 17:07:54 +0200
Message-ID: <20260721152446.779261259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit b429a5ad19cb4efe63d18388a2a4deebcba742c6 ]

When __skb_try_recv_datagram() returns NULL in __unix_dgram_recvmsg(),
we hold unix_state_lock() unconditionally.

This is because SOCK_SEQPACKET sk needs to return EOF in case its peer
has been close()d concurrently.

This behaviour totally depends on the timing of the peer's close() and
reading sk->sk_shutdown, and taking the lock does not play a role.

Let's drop the lock from __unix_dgram_recvmsg() and use READ_ONCE().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250702223606.1054680-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c64d8ee0ede435..f50049ea54a5a4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2463,12 +2463,10 @@ int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
 					      &err, &timeo, last));
 
 	if (!skb) { /* implies iolock unlocked */
-		unix_state_lock(sk);
 		/* Signal EOF on disconnected non-blocking SEQPACKET socket. */
 		if (sk->sk_type == SOCK_SEQPACKET && err == -EAGAIN &&
-		    (sk->sk_shutdown & RCV_SHUTDOWN))
+		    (READ_ONCE(sk->sk_shutdown) & RCV_SHUTDOWN))
 			err = 0;
-		unix_state_unlock(sk);
 		goto out;
 	}
 
-- 
2.53.0



