Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590939;
	b=NnsRCSQ+kMxTORDI/Wffr2LKwShM+KsDxdZQLbiZ+d1LUYU7dVvXCUIC7YJVVbrGC7vr
	 u4jqTr7BTek6AmzK8q47negiR0Uisg/yUSwgc57C7IY/5xddT5/yvsE7QvvQpupppYhFh
	 XUkLIRF3IOdtLU9dXreymAEOJZ9AVpQnHsn1xrURvVqIOGAM0BZpAC4b1+qg0NTnEsY16
	 5qFwEZa0yDnNItE5d6CDn7iNZgQ4CJLjKP21wK9pIGfHXHvnrtZ3uorvbo04MBkiGP6OJ
	 j15SYlTvj1scxmq2o3Kbz3a791m/4BkExzWx9JrJSTmOUZnmvLQv5v+0wV6NBCbt/Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uBEajWS/+X3HrrSpfbbHJZZ6cO6yqF2fefYx2y7SOM=;
	b=rhWkYlQMaDhy4GnE2BoKV4NWw5r/HaOQP84HON+/cMoZSUo8cM5rcU8w2VUsm6E1JK5D
	 6fDI1f2dU+XU1uxKtXMU7tgE4SQ3yjrtEfD6rAPEQV27r7MLg4movhAE7XW7azEIvIQdg
	 IWvtGnu7rVBOeYc97FgQBiEAZYb8B15qdYTTU96nlLhLqoc7iIqShwNs5AZ9Uh43VIzr7
	 wTWYCJm56vZvypP2ERxVbJXGOhWcog3sJBW1koYV1e4F7zI9fnpM3ySvmVhzEQsDQWA9X
	 0gBBK5q+fT5E5ju0a9KQmWedqdFblXARt44CVF/9ruavM8Xgmhap4xm8oojr+SZ3yLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSpLA+6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D50606A8A0;
	Fri, 13 Nov 2026 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSpLA+6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23A01F000C4;
	Fri, 13 Nov 2026 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590939;
	bh=4uBEajWS/+X3HrrSpfbbHJZZ6cO6yqF2fefYx2y7SOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSpLA+6WMA9fwPJrMMzvaheWJx2Hn0wHtm6EQqg5lD9di/rUy9FBBWNK4S48O3sI0
	 c0W/cPa6AD0inZgFXeZSbjrxMsVZr0RVwaUEReYhbPlOqdXmgKBk4KIVSUkBigm1/I
	 +fl/xRwIUvolkiwWkjSZgXiHpxgBpeYMxB9oArxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/670] ax25: dont let connect() find its own socket when calling the same station
Date: Fri, 13 Nov 2026 10:44:47 -0500
Message-ID: <20261113153815.986748657@linuxfoundation.org>
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

Before it starts a link, ax25_connect() looks on ax25_list for an
existing connection with the same source, destination, digipeater path
and device, and returns -EADDRINUSE if there is one. A bound socket is
on that list itself, with the destination of its previous attempt, and
its digipeater path was just freed. When a connect() failed or the
connection ended, a new connect() to the same station without
digipeaters thus finds the socket itself, and fails with -EADDRINUSE
every time.

Forget the previous destination before the lookup, under
ax25_list_lock, where the list readers compare it.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). A starts listening on TESTA-9 after 7 s. B calls
TESTA-9 with one socket before that, which times out, then calls
TESTA-9 again with the same socket, non-blocking, and checks 3 s later:

  before: -EADDRINUSE on the second call and on the check, A accepts
          nothing
  after:  -EINPROGRESS, then the check returns 0 and A accepts the
          connection, three runs out of three

send() on the new connection still fails with -EPIPE unless "ax25: let
a socket connect again after a failed or ended connection" is applied
as well; with both, and with "ax25: free the old digipeater path of a
listed socket under ax25_list_lock", A receives the message.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit efd5dce53a6bc296186212d4a16961174fd3df83)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6ee944e575bd8..d464f8ea4e558 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1374,6 +1374,15 @@ static int __must_check ax25_connect(struct socket *sock,
 		goto out_release;
 	}
 
+	/*
+	 * The socket is on ax25_list with the destination of its previous
+	 * attempt, if any: forget it, or the lookup below finds the socket
+	 * itself when the same station is called again.
+	 */
+	spin_lock_bh(&ax25_list_lock);
+	ax25->dest_addr = null_ax25_address;
+	spin_unlock_bh(&ax25_list_lock);
+
 	if (sk->sk_type == SOCK_SEQPACKET &&
 	    (ax25t=ax25_find_cb(&ax25->source_addr, &fsa->fsa_ax25.sax25_call, digi,
 			 ax25->ax25_dev->dev))) {
-- 
2.53.0



