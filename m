Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F4119ABC6;
	Thu, 25 Jun 2026 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392850; cv=none; b=QS+W3P6RVsY4JrvCHXJqfVj4jYWnxmwE6vFbQQ96vSmYnxoFGVbaiC2A943IN21g7f//lxvkDK4TlXXs7I7/EmNQgTm6DZlzuc55NXKzACtCZ7LV3z+OetHmE58kVwcMZ+GY49jKrZaigyXis2e2DRcEppxrfZRTZKe6RUEfTIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392850; c=relaxed/simple;
	bh=7HXxXJRHvd3fZw432IBjyYs+E/MgqeeCAgUF5ZN0MgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCN4UQ2bm9Zfpg76ozPFxyYbTgrvk/iGjnvFsq+5V8ze3ID1VAMMXgs1YcvMwqDBX0BzMEPJc/BlsqcvcpJ8u4CNwY0kOhuwC8ihukwCCALOKqo4Sla23GNLwrKcYMJL+DPlF3Fw615LXczrxu9GxC91vNzfj5k9SfrWmfUEmSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcuRv79I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcuRv79I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26231F000E9;
	Thu, 25 Jun 2026 13:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392849;
	bh=9lUknqL8cR7BI7R4STF75FvN1LMV0nJC6ICLNglyNjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcuRv79IB9sJKGZGBNMm+olgT8LMRTABKULCpZApR0iW41GFyf2bifqW3E1zML/iM
	 rFUvT801MJIgz7J8qDy2E2vkVlUanv7ht/KZbEfpVIGMIB/aq1df2qSIV3foGure9m
	 Tqy9AnthovM3rhI0dJwL/ntBuBpzJIF0k3rue5tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 28/60] rose: dont free fd-owned sockets when reaping in the heartbeat
Date: Thu, 25 Jun 2026 14:03:13 +0100
Message-ID: <20260625125649.672139221@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


