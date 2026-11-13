Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590084;
	b=gsbImD3NcRMkBerrGpKZ+gXA+3T8Fx+l0JhksVZ8qCQFmEBFqep4/fNywuWx8dDpiOiz
	 cMI8XtIHySmhcLbrMEsuEeNqCny7TiPZk5HW775agIyW9VqpRwAakgsVbWKNYIArcLU2R
	 VFitHpnyfTgFEoQOD5k14NTdzJ7dlEvF3HN0bpfIBZ7lytH5r+22FWppYK5dCGht5HJ/d
	 qePbUjLfYUw6veWfeaZ1JrC31ZOgw654GZrnLQpkAD3VbKuTB9bVZK34Cjl74gafWNb7C
	 1FlsA3QmVa3VmzRZzfdoSyS4wAYdv8f2jaYMaEFaF3gYvjKTSrDLD60gP1qTqru+D/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5HPH8BokxfOEGyGVqKIrAArrKT7488pG4FTnFfuLVPg=;
	b=KmjVoUJFcPfAUC22sTFWbkQh/YRb8T6eCKzKK8+Y2g4G6iMQ1afWb43HnWzr+oKOQnON
	 ungJM8kaKnJ5fsfzeb2gPuBZaoDRB58UtD6d3Y2MZUhhS1R5zDXsj9ez8oBRIhvhzF0f4
	 ZKxsdMl1OsFY/B1vJAarOK/lTTCPLwCbSWbBWCVWfMYW3K3aTJonxiROzTuXYjo+98RQI
	 CGlhwYPz9bV6CZk7jGbh+EKHuj5vMTAudfBzlfe6rLL3YkXTKAxYzln9ytfiFrpPZ87CD
	 zd315Q/HpfDVpUCK21fL95AL9I+Ca0Pio+ezaWNN4nTMwepECGF9LF5UVYgYghCa3oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j565eZnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0077606A32E;
	Fri, 13 Nov 2026 17:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j565eZnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD941F000C5;
	Fri, 13 Nov 2026 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590084;
	bh=5HPH8BokxfOEGyGVqKIrAArrKT7488pG4FTnFfuLVPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j565eZnj5aFqzrpAUf/vZT5bjOPTTOXEXYeOmWcKiW44ljdGt+WefX0SHDBELtYnv
	 zG/AdHXmdmz4SvAvHRyD/SwkbjuVT3CQNb7vlUVY4xxG80DE645azh15AWDOB4W68V
	 eWgfRyQ2mP/LUYX75UUkDyJkOuZYl7xpn/eJCtvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/686] ax25: free a closed socket when its device goes down
Date: Fri, 13 Nov 2026 10:44:05 -0500
Message-ID: <20261113153824.639302559@linuxfoundation.org>
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

A SOCK_SEQPACKET socket closed by its owner is marked SOCK_DESTROY and
left to its heartbeat, which calls ax25_destroy_socket() once the link
is down. A connection that a listener never accepted gets the same
treatment when the listener is closed (TCP_LISTEN and SOCK_DEAD).
Neither socket has a struct socket left, so nothing else frees it.

If the device goes away during that time, ax25_kill_by_device() calls
ax25_disconnect() with ENETUNREACH, which since commit fc6d01ff9ef0
("ax25: Fix NULL pointer dereferences in ax25 timers") stops the
heartbeat with timer_delete_sync() whatever the socket state, and then
takes the control block off the list. The socket is never freed and
keeps a reference on the ax25 module, so ax25 can no longer be unloaded.

This shows up on a node that closes a connection and restarts
kissattach, or unloads bpqether, within the few seconds the heartbeat
needs: each such connection adds one to the ax25 module refcount for
good.

Free those sockets in ax25_kill_by_device() with ax25_destroy_socket(),
under the same condition the heartbeat uses.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link): three client connections closed and ax0 removed
one second later, then a connection left unaccepted by a closed
listener and ax0 removed one second later. ax25 refcount after each:

                        before   after
  3 closed clients        +3       0
  unaccepted connection   +1       0
  control (ax0 removed     0       0
  25 s after close)

Same result over five runs, with no KASAN or lockdep report. Also seen
on two live nodes over bpqether, where ax25 could no longer be
reloaded until a reboot.

Fixes: fc6d01ff9ef0 ("ax25: Fix NULL pointer dereferences in ax25 timers")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 2e9cb81885fefea3690a9b94b9ff5ebf761bea73)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 5ce59d1ba8221..63fe99746d328 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -78,6 +78,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 	ax25_dev *ax25_dev;
 	ax25_cb *s;
 	struct sock *sk;
+	bool orphan;
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
@@ -109,6 +110,16 @@ static void ax25_kill_by_device(struct net_device *dev)
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
+			/*
+			 * A socket closed by its owner, or a connection left
+			 * unaccepted by a closed listener, is freed by its
+			 * heartbeat once it is down. ax25_disconnect() below
+			 * stops that heartbeat for good, so free the socket
+			 * here, or it is never freed and pins the module.
+			 */
+			orphan = sock_flag(sk, SOCK_DESTROY) ||
+				 (sk->sk_state == TCP_LISTEN &&
+				  sock_flag(sk, SOCK_DEAD));
 			ax25_disconnect(s, ENETUNREACH);
 			WRITE_ONCE(s->ax25_dev, NULL);
 			if (sk->sk_socket) {
@@ -116,7 +127,10 @@ static void ax25_kill_by_device(struct net_device *dev)
 					   &s->dev_tracker);
 				ax25_dev_put(ax25_dev);
 			}
-			ax25_cb_del(s);
+			if (orphan)
+				ax25_destroy_socket(s);
+			else
+				ax25_cb_del(s);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
-- 
2.53.0



