Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207494;
	b=E9H1lbw9I1MQSX6PM33LIamde2XXraI/TGl9ZUGTKEsPSJmtM73x/hf7VfAaA2dhI0zU
	 MUdQQnp1NKpKPuGOnut1kIvSGkHg+wrtgFuoKUHb0zW9XcF6/ABCyq6geKuDGdqjtgAGr
	 /uIV1hCT3PD+wgh0geLqfOqfL60BE3rXwX9A11EV8syelNS10T6VMarUGNZNzxJFn1AVe
	 yksITgmIcFCQow65/RP3QY/nDc6jSSi4O3bdesIS1j3uaqZ8WTQEaTPR43VtwraApTcLs
	 3Do4kdsI5d/CV2kg+FbDBgiApNNtwOhKZR7xyzaJP1EipkSXzQfCnfQ080fSYgfWdzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ukGGCTjr2HRkcBEFl4iY50fzCBgTkKRTjZfxUxylCo=;
	b=aau/aZH1QguJtcj1YDMF8IXR2+cPvDHXNFh/mf8y6AeRxpX6ZgCXV5Liy7AUFkaXmSuu
	 xGAjOvZgDjLflbmNxqA9076CmXUMnebXeWjr3y+EUAPVf3IHJo8kWi7TsneE6gFBmZ5dH
	 srDV0OyDzE7Ek46dI+9gtZKXWfIWGMq5quBUFBXwTlzxBxxfLdoUsJqdJrPYdfe0cNbyH
	 GBXOT/vH4FceSbU+AAmGS9S5nK65CBu5xgsyQ3XMXSXSiO7EkUOxFnO7S4tcPkAY06vry
	 DZiIEvL8jUNuagTAjzn3IJ21Nv4BeFdSwhjd7tX9b+oV/VV59BvrRO64fiLOieNcL7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wu57gPVQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3708606A329;
	Wed, 28 Oct 2026 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wu57gPVQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C0E1F031E9;
	Wed, 28 Oct 2026 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207493;
	bh=8ukGGCTjr2HRkcBEFl4iY50fzCBgTkKRTjZfxUxylCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wu57gPVQhtrgqXojPVfZtpejKqdLLBdrbFVabO2fJwZt3EQrEc8FDeC1j8DJ9u2nO
	 JOD7WHRrVmjNOoqknXF3lRSPEU+cwXTlZ0ZBzqUognCjDKVHBolYbEs0zQbkMywTPr
	 wFtFzwhLKhr4QKAQ8tTaJ1Ro/PvP5jnKyuC/wQP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/247] rose: dont free fd-owned sockets when reaping in the heartbeat
Date: Wed, 28 Oct 2026 17:56:48 +0100
Message-ID: <20261028165947.484035430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

The heartbeat reaps orphaned ROSE sockets after their bound device goes
down. A socket still attached to a struct socket (sk->sk_socket != NULL --
e.g. an incoming connection an fpad client has accepted and kept open) is
owned by that userspace fd: rose_release() frees it on close(). Freeing it
from the heartbeat left the fd dangling, so the eventual close() touched
freed memory -- slab-use-after-free in rose_release().

Reap only sockets with sk->sk_socket == NULL (unaccepted incoming
connections and post-close orphans). For an fd-owned socket whose device
went down, disconnect it and fall through to the switch so close() does
the teardown. Also release the neighbour reference held by orphaned
incoming sockets before tearing them down.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>

(cherry picked from commit 56576518920edd7b6c3479477d8d490fe2ebdaaa)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_timer.c | 57 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index b2c5f4653b11d..3cd7e020422a5 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -126,13 +126,68 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 		sk_reset_timer(sk, &sk->sk_timer, jiffies + HZ/20);
 		goto out;
 	}
+
+	/* The bound device went down while we still hold a reference on it.
+	 * This catches the narrow race where rose_loopback_timer() created a
+	 * socket in the window after rose_kill_by_device()'s NETDEV_DOWN sweep
+	 * but before rose_insert_socket() -- leaving a STATE_3 socket that no
+	 * other branch reaps.  A down device means the link is dead, so tear
+	 * the socket down regardless of state.  rose_destroy_socket() releases
+	 * the held netdev reference (rose->device still set).
+	 */
+	if (rose->device && !netif_running(rose->device)) {
+		if (rose->neighbour) {
+			rose_neigh_put(rose->neighbour);
+			rose->neighbour = NULL;
+		}
+		rose_disconnect(sk, ENETDOWN, -1, -1);
+
+		/* Only reap the socket if userspace no longer holds it.  A socket
+		 * still attached to a struct socket (sk->sk_socket != NULL -- e.g.
+		 * a connection an fpad client has accepted and kept open) is owned
+		 * by that fd: rose_release() will destroy it on close().  Dropping
+		 * the last reference here leaves the open fd dangling, so the
+		 * eventual close() touches freed memory -> slab-use-after-free in
+		 * rose_release().  Unaccepted incoming sockets and post-close
+		 * orphans have sk->sk_socket == NULL and stay safe to reap here.
+		 */
+		if (!sk->sk_socket) {
+			sock_set_flag(sk, SOCK_DESTROY);
+			bh_unlock_sock(sk);
+			rose_destroy_socket(sk);
+			sock_put(sk);
+			return;
+		}
+
+		/* Owned by userspace: the link is down and the socket is now
+		 * disconnected (rose_disconnect() moved it to STATE_0).  Fall
+		 * through to the switch, which re-arms the heartbeat; the close()
+		 * will tear the socket down. */
+	}
+
 	switch (rose->state) {
 	case ROSE_STATE_0:
 		/* Destroy any orphaned STATE_0 socket: either explicitly
 		 * flagged SOCK_DESTROY, or SOCK_DEAD (covers both unaccepted
 		 * incoming connections and listening sockets whose link died).
 		 */
-		if (sock_flag(sk, SOCK_DESTROY) || sock_flag(sk, SOCK_DEAD)) {
+		if ((sock_flag(sk, SOCK_DESTROY) || sock_flag(sk, SOCK_DEAD)) &&
+		    !sk->sk_socket) {
+			/* Reap only orphaned sockets (sk->sk_socket == NULL).  A
+			 * socket still owned by a userspace fd reaches here via the
+			 * STATE_2 device-gone branch, which sets SOCK_DESTROY without
+			 * knowing about the fd; freeing it would race rose_release()
+			 * at close() -> use-after-free.  Leave it for close().
+			 *
+			 * Orphaned incoming sockets (rose_rx_call_request) hold a
+			 * neighbour reference; release it before teardown, as the
+			 * STATE_2 and device-down branches do.  rose_destroy_socket()
+			 * does not drop it.
+			 */
+			if (rose->neighbour) {
+				rose_neigh_put(rose->neighbour);
+				rose->neighbour = NULL;
+			}
 			bh_unlock_sock(sk);
 			rose_destroy_socket(sk);
 			sock_put(sk);
-- 
2.53.0



