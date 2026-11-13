Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590089;
	b=SBJj+q6pQIx4nZpXd95Vb78NDO6pJ9KUXnWTFUVj5adVJ/uqEIbCETjdwrOS9VgIlpZ3
	 Lvb1vvT/sBjjZJ1e3tbqCbj+x9y3D59iH7JCRZqcGq1MAb4Iw78KXjgJteGYu7zYd3/yZ
	 7IGxNYi7CjFN0LhfiLitH8fy3xvxJcGhN172BTdYApPdaM26xrTaxszXWQM03ZbYGd8YY
	 MOPR/aKT60J9euPEViUyz5n8ManZwyaxeE3Z6Bk/mgQhXZPziNKiTmXeV3X7ag7tYHnhl
	 8sCPPQlpbEiNQFBaWijXQENZ1olACTVJ4AgsX0LHaGo2HQN03cdI6yBnyyX8c49+08A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMuHy1stJmHbBFdyVfKe/Gxqlgh6pq8bI3Cqi4JWa3Q=;
	b=ifmYBfn4LcH/+Knn2SKM10q06OU7AysA8XaxgszCdhSNrztEzji2zfndylAnYNIsZKfh
	 u7tL+Vt8VyCAgDjEntiU75J+X0BwI8BDRrduyxY3M8rj9OqwisrUVgODwAdISZW21x5lj
	 qWG8tytnDKBQx3xilPKzr6BLVTVp4ARK+A+tQIVF0p3a1XxmsOu7gu0KGmVTeNnwKjiYJ
	 6Pq1nCN0LWJjwtOj6ul58HiUYHignApJ2c0T8li7UBLOiPBv+tXaUUfAfLvNMoPau2bue
	 rOb97GUxN1UanjOQLsAjkY5A9MBEUJHWEcuYfB4Z7/G6icz34n60yYoIdxvf8TV4Yzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flkRSl+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA5A606A887;
	Fri, 13 Nov 2026 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flkRSl+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3797E1F000C4;
	Fri, 13 Nov 2026 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590089;
	bh=aMuHy1stJmHbBFdyVfKe/Gxqlgh6pq8bI3Cqi4JWa3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flkRSl+iapPrTc/woeXJZDzgJMt3X9CG6D/fyAtkkR0xb5GL/PkZbbzFPZEdXo7d0
	 Qh7WO3aaFARdcobeseqkDyriFUFnPTEJDzLGK+7HGDWrNAtQbtDswPaoFs7u/bu4FZ
	 gwMjST4HdnCAPQP0qj8az1ZFhnhDL9ll4Kp1OR2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/686] ax25: dont take a reference on a gone device in ax25_accept()
Date: Fri, 13 Nov 2026 10:44:09 -0500
Message-ID: <20261113153824.770794586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

A connection made on an incoming SABM waits on the listener's receive
queue until accept(). If its device goes down meanwhile,
ax25_kill_by_device() finds it on ax25_list, disconnects it and clears
its ax25_dev. It drops no device reference, since the socket has not
been grafted yet, but the skb stays on the listener's queue. The next
accept() then reads ax25->ax25_dev and passes NULL->dev to
netdev_hold():

  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:ax25_accept+0x58f/0x7e0 [ax25]

A listener bound to a device is itself closed by ax25_kill_by_device(),
so accept() returns -EINVAL unless it was already waiting and wakes up
in between. A listener bound to no device, which any user can create,
stays open, and the next accept() crashes every time.

ax25_accept() also grafts the socket and takes the device references
without the lock of the new socket, while ax25_kill_by_device() decides
under that lock, from sk->sk_socket, whether those references are there
to drop.

Graft the socket and take the references under its lock, and take none
when the device has already gone. accept() then returns the connection
closed, as it is: getpeername() and recv() give -ENOTCONN, and close()
frees it.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). A listens on TESTA-9 bound to no device, B calls
it, A removes ax0 by detaching the N_AX25 line discipline, then calls
accept():

  before: null-ptr-deref in ax25_accept(), kernel panic
  after:  accept() returns the socket, -ENOTCONN on it, ax25 refcount
          back to its starting value once closed, no KASAN or lockdep
          report, five runs out of five

A plain accept() run before that case behaves the same before and
after.

Fixes: 9fd75b66b8f6 ("ax25: Fix refcount leaks caused by ax25_cb_del()")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit b75827388dea3c54c44df39b003750b0849f9d31)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6b43aaf31b252..4c5f82e2593c7 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1498,16 +1498,29 @@ static int ax25_accept(struct socket *sock, struct socket *newsock,
 		goto out;
 
 	newsk		 = skb->sk;
+
+	/*
+	 * ax25_kill_by_device() detaches a connection from a device going
+	 * down under the lock of its socket, clears its ax25_dev and drops
+	 * the device references if the socket has been grafted by then.
+	 * Graft the socket and take those references under the same lock,
+	 * and take none if the device has already gone: the connection is
+	 * closed then, and the socket is returned as such.
+	 */
+	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sock_graft(newsk, newsock);
+	ax25 = sk_to_ax25(newsk);
+	ax25_dev = ax25->ax25_dev;
+	if (ax25_dev) {
+		netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
+		ax25_dev_hold(ax25_dev);
+	}
+	release_sock(newsk);
 
 	/* Now attach up the new socket */
 	kfree_skb(skb);
 	sk_acceptq_removed(sk);
 	newsock->state = SS_CONNECTED;
-	ax25 = sk_to_ax25(newsk);
-	ax25_dev = ax25->ax25_dev;
-	netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
-	ax25_dev_hold(ax25_dev);
 
 out:
 	release_sock(sk);
-- 
2.53.0



