Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273ACDDC5;
	Thu, 28 May 2026 20:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000047; cv=none; b=jurYED83iLxYNMVugmlcrWbzwgo4+dw6tqd0/s0ILnPJNXc6f+TNSMxeJR7rxctmgqvMTJy1RF3GpUYlTofp68EpTljNMB/4xQCKCd7QpDTZ7b+BRobZJ53qlxwvl2x+RrQZNQ9z+PJtExH7pbxZEqZfSEcEI4R9UEQLHMcWNsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000047; c=relaxed/simple;
	bh=rRqZKv9Q7zzgOondW7B0s6CvmJ6Yo/mMdozEA1hPqII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9WrJvv/TUKEBCLBegvHOEzfRC+pm5QkTRxz1JuRJ8W3BcZOyl+FUA1jmnPx2t7wWb4dR6yCHRqBTouwcpMEFcl7Xc6DBXzGb2CE9Jg3f/QLCM05dLiZ+JbF+2LqIvmImq0IzTaRVMiLaX+rZzevrq8zms+mNYAwLdMfCKFikj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfNniC0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfNniC0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBC61F000E9;
	Thu, 28 May 2026 20:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000045;
	bh=TABISjAnavl4EgV8bjMrkX+tQGWIzyNJMB43iNc0KBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfNniC0lFTzKVk+TPfjgxshagQMpvspNuApV1kT+AQI20FcVk4WnFvDE5G9p+IJ2T
	 rSFytmyjqIhbeqq4D0T6TsZAtS+Q9cUC+E7fj5OhNXHrcjO9NTld8vE+LwcSiySwXC
	 LZmzl34DmQNmRbK1+zBAsJWzct3jA2KWA+vOE/Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Carlier <devnexen@gmail.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/377] ovpn: tcp - use cached peer pointer in ovpn_tcp_close()
Date: Thu, 28 May 2026 21:48:42 +0200
Message-ID: <20260528194646.578279376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 775d8d7ad02aa345e1588424a6a8b9ae49fb9012 ]

ovpn_tcp_close() loads the ovpn_socket via rcu_dereference_sk_user_data()
under rcu_read_lock(), takes a reference on sock->peer, caches the peer
pointer in a local, and drops the read lock. It then passes sock->peer
(rather than the cached local) to ovpn_peer_del(), re-dereferencing the
ovpn_socket after the RCU read section has ended.

Unlike ovpn_tcp_sendmsg(), which uses the same "load under RCU, use
after unlock" pattern but is protected by lock_sock() held across the
function, ovpn_tcp_close() runs without the socket lock: inet_release()
invokes sk_prot->close() without taking lock_sock first.

ovpn_socket_release() can therefore complete its kref_put -> detach ->
synchronize_rcu -> kfree(sock) sequence concurrently, in the window
after ovpn_tcp_close() drops rcu_read_lock() but before it dereferences
sock->peer. The synchronize_rcu() in ovpn_socket_release() protects
readers that use the dereferenced pointer inside the RCU read section,
not those that escape the pointer to a local and use it afterwards.

A reproducer follows the pattern of commit 94560267d6c4 ("ovpn: tcp -
don't deref NULL sk_socket member after tcp_close()"): trigger a peer
removal (keepalive expiration or netlink OVPN_CMD_DEL_PEER) at the same
moment userspace closes the TCP fd. That commit fixed the detach-side
of the same race window; this one fixes the close-side at a different
victim.

Tighten the entry block to read sock->peer exactly once into the cached
peer local, and route all subsequent uses (the hold check, the
ovpn_peer_del() call, and the prot->close() invocation) through that
local. sock->peer is only ever written once in ovpn_socket_new() under
lock_sock(), before rcu_assign_sk_user_data() publishes the ovpn_socket,
and is never reassigned afterwards - but the previous multi-read pattern
made that invariant implicit rather than explicit. The same multi-read
shape exists in ovpn_tcp_recvmsg(), ovpn_tcp_sendmsg(),
ovpn_tcp_data_ready() and ovpn_tcp_write_space(); those will be cleaned
up via a dedicated helper in a follow-up net-next series.

Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/tcp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index 5499c1572f3e2..5f345ae7d59d2 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -581,14 +581,19 @@ static void ovpn_tcp_close(struct sock *sk, long timeout)
 
 	rcu_read_lock();
 	sock = rcu_dereference_sk_user_data(sk);
-	if (!sock || !sock->peer || !ovpn_peer_hold(sock->peer)) {
+	if (!sock) {
 		rcu_read_unlock();
 		return;
 	}
+
 	peer = sock->peer;
+	if (!peer || !ovpn_peer_hold(peer)) {
+		rcu_read_unlock();
+		return;
+	}
 	rcu_read_unlock();
 
-	ovpn_peer_del(sock->peer, OVPN_DEL_PEER_REASON_TRANSPORT_DISCONNECT);
+	ovpn_peer_del(peer, OVPN_DEL_PEER_REASON_TRANSPORT_DISCONNECT);
 	peer->tcp.sk_cb.prot->close(sk, timeout);
 	ovpn_peer_put(peer);
 }
-- 
2.53.0



