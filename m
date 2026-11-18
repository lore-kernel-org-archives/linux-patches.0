Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028906;
	b=Tk+Xio5fQoObJiwMNB4Vvry1K6qq6tE2ZY+2AnBaOIDioKfYNncYMEA0QWbUKnz5pgfN
	 z2DNkvqLrmurawU3NUm/v1NPXeUNFFdweoWfz6zMr0DHoEguZSojbPnKOmVoLnKIkm5Sj
	 xAF9fBlxfOedVwGtqBEJNkHQxiRZbk/vLc8iNVkNcdwQHDkx/K55V1EKlTOTIN+AwyHV+
	 h6Gg5Nu/3fOR2d33EsbCjgByQdwiHivGnGj8rTNDlq854bFUN95UzgJ+RuGLzU9Dmqp5b
	 9o7dOXUX/VCP6M6VDacd3JZIbUXBbQ75i27yc2YFUSX9MYZYdzvTK1XiqOSHrAevbsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bY/1D4A/jad/pHy441NugA6yCV/c5TuVqAdk4pq6Ems=;
	b=fWz2oec7vQXFw5gORiGiv0t+xmBULpwlvdnB2u6i/aDUZvHBv+SRH8Dc1ZmD2oDHudm2
	 +OqBYn/O0jF3Q13gdoAEkvzdtlaerwESk7DiRChOYmZ3cm22H7ggbDndhhC/B5uy85OSp
	 S7fB64b24hgG6BbMHcBIIK0udjI9MWRgs1I+TK8fp61ujkCWh3deJ74tZONG6dQ5x3Y6z
	 pXGcyBg2R2VMRN+YGB/fKn2Xt+Hd7/8FhDUSf1FV/vnC1R5FPSlVVAPxMVhwCijv6SQVU
	 Dg47bxIy/GgLxK5MnfakrW07I32JeYEBPvsBcOvJjSCLxKClOGisPxaeUitdoNTh5DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2QvS7Xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17564606A33B;
	Wed, 18 Nov 2026 19:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2QvS7Xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229911F000C4;
	Wed, 18 Nov 2026 19:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028905;
	bh=bY/1D4A/jad/pHy441NugA6yCV/c5TuVqAdk4pq6Ems=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2QvS7XnNWA6/uLp7SPg8v1A2xeUljz25yHhxC90SpOPjRPNRtk7ox82o+ChewlwN
	 P9PMGy7NhuYqkK9fWkcjGfGc7qDQ8R6tpP0aA466YpkEzDxKWmaCRf4Sxob4PzUS2N
	 5oC4+Jhi/n/qz/fbVp1Rphjxf72WIjSXwLj67bFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0114/1756] rose: disconnect sockets under their lock when a neighbour goes away
Date: Wed, 18 Nov 2026 15:37:21 +0100
Message-ID: <20261118150012.736886316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

rose_kill_by_neigh() disconnects every socket that uses a neighbour
whose link has failed, restarted or gone down, holding only
rose_list_lock. rose_disconnect() stops the timers, purges the queues
and changes the state of the socket, but its timers and the frames
received for it work on the same socket under bh_lock_sock() only, on
other CPUs, and are not kept out by rose_list_lock.

Disconnect each socket under its lock. rose_rx_call_request() and
rose_kill_by_device() take the socket lock before rose_list_lock, so
do as rose_kill_by_device() does: take a reference on the sockets that
use the neighbour under rose_list_lock, drop it, and lock each socket
in turn, checking that it still uses the neighbour. The neighbour is
still taken under rose_list_lock as well: rose_release() takes it under
that lock while it owns the socket, which bh_lock_sock() does not keep
out.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 250c2ad2174f0a1aeb6c306e7bcc259a7fe2178d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 48 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 2cb096068e5ed..2a610cf8425af 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -162,19 +162,52 @@ static void rose_remove_socket(struct sock *sk)
  */
 void rose_kill_by_neigh(struct rose_neigh *neigh)
 {
-	struct sock *s;
+	struct sock *s, *array[16];
+	bool rescan;
+	int i, cnt;
 
+	/*
+	 * Each socket is disconnected under its lock, which its timers and
+	 * the frames received for it hold while they work on it. That lock
+	 * is taken before rose_list_lock elsewhere, so collect the sockets
+	 * first, as rose_kill_by_device() does. rose_list_lock is still
+	 * held around the change of the neighbour, which rose_release()
+	 * takes under it while it owns the socket. A socket done with has
+	 * no neighbour left and is not collected again.
+	 */
+again:
+	rescan = false;
+	cnt = 0;
 	spin_lock_bh(&rose_list_lock);
 	sk_for_each(s, &rose_list) {
-		struct rose_sock *rose = rose_sk(s);
+		if (rose_sk(s)->neighbour != neigh)
+			continue;
+		if (cnt == ARRAY_SIZE(array)) {
+			rescan = true;
+			break;
+		}
+		sock_hold(s);
+		array[cnt++] = s;
+	}
+	spin_unlock_bh(&rose_list_lock);
+
+	for (i = 0; i < cnt; i++) {
+		struct rose_sock *rose = rose_sk(array[i]);
 
+		bh_lock_sock(array[i]);
+		/* rose_release() takes the neighbour under rose_list_lock */
+		spin_lock_bh(&rose_list_lock);
 		if (rose->neighbour == neigh) {
-			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
+			rose_disconnect(array[i], ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
 			rose_neigh_put(rose->neighbour);
 			rose->neighbour = NULL;
 		}
+		spin_unlock_bh(&rose_list_lock);
+		bh_unlock_sock(array[i]);
+		sock_put(array[i]);
 	}
-	spin_unlock_bh(&rose_list_lock);
+	if (rescan)
+		goto again;
 }
 
 /*
@@ -721,9 +754,10 @@ static int rose_release(struct socket *sock)
 		 * Disconnect before the socket lock is dropped: frames put on
 		 * the backlog meanwhile, a Clear Confirmation for one, then
 		 * find it in state 0 instead of dropping the neighbour
-		 * reference a second time. rose_kill_by_neigh() does not take
-		 * the socket lock: take the neighbour under rose_list_lock, as
-		 * it does, so that only one of them drops the reference.
+		 * reference a second time. rose_kill_by_neigh() can run while
+		 * the socket is owned here: take the neighbour under
+		 * rose_list_lock, as it does, so that only one of them drops
+		 * the reference.
 		 */
 		rose_disconnect(sk, 0, -1, -1);
 		spin_lock_bh(&rose_list_lock);
-- 
2.53.0



