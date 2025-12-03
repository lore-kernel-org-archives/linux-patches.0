Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EE6345759;
	Wed,  3 Dec 2025 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778292; cv=none; b=Mb5mtNLYZ5AkOF+FWNb3diaEpsiamjcRELnvCP+H3rpVFIMJc9GC9TJRy/A0R3+W0j9NC+c4sGdR6BR11ZT4mfLQib/CtBJKum5LGhtNBQn/qNCfPFE7hkGJq3ByeMVNRJwHxDANVhwxElMzO9xlk9uhpM/g2RVMspXLJNXC1t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778292; c=relaxed/simple;
	bh=KRYhewRz7rigzkdviFkL1IgfVcNX7AXDKHxK120FQnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5zP/w/r4dCz7/5kM84UZzfB1ICFvPmNxHnAqrMP2s04KL4QEHSSPXfaJs1cpqr4fShBfKhdfudASygXy65iah04mW7d2iOlba5o3/yvDs9FZyU+Ziwun0eWrT0NDB04SS/xI4/UdVYjifjTyslGC/ob7mdEV6zxga3xYcdOGvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLK+RNoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLK+RNoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF83C4CEF5;
	Wed,  3 Dec 2025 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778292;
	bh=KRYhewRz7rigzkdviFkL1IgfVcNX7AXDKHxK120FQnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLK+RNoLHFmEUyGWfxX1QaCENgR9Q/e2IrBUOBdHZ7S7VJO49yaAbP5QA/vcd/cS3
	 RPCBBf2TaJzsfOiVi0nJlj+4Llm1BLEc2RzqQDggA0OwcV66ngURzAY4RydwFkTgzu
	 j+oBzY72TCwI3ZN9dyPw5mMFzyj2NYAlT0A2ghDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/392] vsock: Ignore signal/timeout on connect() if already established
Date: Wed,  3 Dec 2025 16:27:31 +0100
Message-ID: <20251203152425.243603270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 002541ef650b742a198e4be363881439bb9d86b4 ]

During connect(), acting on a signal/timeout by disconnecting an already
established socket leads to several issues:

1. connect() invoking vsock_transport_cancel_pkt() ->
   virtio_transport_purge_skbs() may race with sendmsg() invoking
   virtio_transport_get_credit(). This results in a permanently elevated
   `vvs->bytes_unsent`. Which, in turn, confuses the SOCK_LINGER handling.

2. connect() resetting a connected socket's state may race with socket
   being placed in a sockmap. A disconnected socket remaining in a sockmap
   breaks sockmap's assumptions. And gives rise to WARNs.

3. connect() transitioning SS_CONNECTED -> SS_UNCONNECTED allows for a
   transport change/drop after TCP_ESTABLISHED. Which poses a problem for
   any simultaneous sendmsg() or connect() and may result in a
   use-after-free/null-ptr-deref.

Do not disconnect socket on signal/timeout. Keep the logic for unconnected
sockets: they don't linger, can't be placed in a sockmap, are rejected by
sendmsg().

[1]: https://lore.kernel.org/netdev/e07fd95c-9a38-4eea-9638-133e38c2ec9b@rbox.co/
[2]: https://lore.kernel.org/netdev/20250317-vsock-trans-signal-race-v4-0-fc8837f3f1d4@rbox.co/
[3]: https://lore.kernel.org/netdev/60f1b7db-3099-4f6a-875e-af9f6ef194f6@rbox.co/

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20251119-vsock-interrupted-connect-v2-1-70734cf1233f@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 033fcdffc9e50..d79a755388318 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1493,18 +1493,40 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		timeout = schedule_timeout(timeout);
 		lock_sock(sk);
 
-		if (signal_pending(current)) {
-			err = sock_intr_errno(timeout);
-			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
-			sock->state = SS_UNCONNECTED;
-			vsock_transport_cancel_pkt(vsk);
-			vsock_remove_connected(vsk);
-			goto out_wait;
-		} else if ((sk->sk_state != TCP_ESTABLISHED) && (timeout == 0)) {
-			err = -ETIMEDOUT;
+		/* Connection established. Whatever happens to socket once we
+		 * release it, that's not connect()'s concern. No need to go
+		 * into signal and timeout handling. Call it a day.
+		 *
+		 * Note that allowing to "reset" an already established socket
+		 * here is racy and insecure.
+		 */
+		if (sk->sk_state == TCP_ESTABLISHED)
+			break;
+
+		/* If connection was _not_ established and a signal/timeout came
+		 * to be, we want the socket's state reset. User space may want
+		 * to retry.
+		 *
+		 * sk_state != TCP_ESTABLISHED implies that socket is not on
+		 * vsock_connected_table. We keep the binding and the transport
+		 * assigned.
+		 */
+		if (signal_pending(current) || timeout == 0) {
+			err = timeout == 0 ? -ETIMEDOUT : sock_intr_errno(timeout);
+
+			/* Listener might have already responded with
+			 * VIRTIO_VSOCK_OP_RESPONSE. Its handling expects our
+			 * sk_state == TCP_SYN_SENT, which hereby we break.
+			 * In such case VIRTIO_VSOCK_OP_RST will follow.
+			 */
 			sk->sk_state = TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
+
+			/* Try to cancel VIRTIO_VSOCK_OP_REQUEST skb sent out by
+			 * transport->connect().
+			 */
 			vsock_transport_cancel_pkt(vsk);
+
 			goto out_wait;
 		}
 
-- 
2.51.0



