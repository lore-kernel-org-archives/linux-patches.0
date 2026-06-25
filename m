Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC672571B8;
	Thu, 25 Jun 2026 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393012; cv=none; b=HgLP0Q77NmCAcFWGa3H0V15+42bCxJF8by7p7WG/BaqOP128VuY9cMVKTdxE1FgUkytbSflITlzvS8p8a7Kg3qsA5HNj2tQDsNM7Fa3keGUs+hFS79GKxwjCW/xD+on6daig3C/fjm1RgFJfkw+GhEAj4FRMnXNnt+g1YAxGO84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393012; c=relaxed/simple;
	bh=6df47MHheOVPmj04EbBeKaRch0m1YXhox/d7wy/eEfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+pbk+a3S003Hzdt2CHmSrMS14uV4P/lAIzUc6YhsnvpUum0maIHkQ7G12E8M0s16tuBtwdl04gvqOYnxqITsJU5/Yfptv2A6qYK7KPdu+8j6LtVkDg4kJssPT37HmQutTJaHR2lt2+5QlD1rOtH8dn1Fl66oCjdoRkg4cfdajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epxnqJ2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epxnqJ2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420A1F00A3A;
	Thu, 25 Jun 2026 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393011;
	bh=siZCi/B2fnXWROGk/S+i6dHve00/pu656AWaXijtppQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epxnqJ2gRoSeH/mujKb3Dr+Jl9/f1wLqkxVRuIy/vFhjk51lhTaGms6f1/78tbusz
	 ZON1AxzLC7FmokvanX98K4jwZIiYE/86WT9jCeDERv13uwgad375P3NwfdLYa7cI69
	 aghYuhU7fDLClkw+f8Vdmiu0h+6f8nYTrMK27gfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 30/49] rose: dont free fd-owned sockets when reaping in the heartbeat
Date: Thu, 25 Jun 2026 14:03:42 +0100
Message-ID: <20260625125641.763042674@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit 56576518920edd7b6c3479477d8d490fe2ebdaaa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_timer.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -126,13 +126,68 @@ static void rose_heartbeat_expiry(struct
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


