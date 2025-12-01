Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E31725D546;
	Mon,  1 Dec 2025 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588778; cv=none; b=G7S4AIdml8tDrKO0fh3EpAxlNb2xoaZ7S5NSaNyliB5uoQrxYFb5tlaLLOLOzluURupknPIr0ehZybuWtEFB2q8rympl6B2R7oAAd2+Bfz7xu+2Go+J13jyIKafuJHVkrTQZ1331ivu4n2phX+m9K7LNWc1/NF7Q2+Z2QkwK9YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588778; c=relaxed/simple;
	bh=gE/yu6sasT8wGD94GG8nUl58l7Cy/Ybg6Vq4vCwL2Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgqvlH3nZnK/NMvgZmt8KKvUP+Vgm+SdVxrX7+OwhQO9GhI+VNkG2Gh436zKhYk1T89nquIH3Ose+p5eGLoohV6bgr7cTUvc/vKxQEVULKP1go+kkZC3QHYhPsZ8Z8oQ6VqFwBqyakMJUzdmqQOIqC5Ar9IFfbMVH5b4VXatchg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7D7asFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7D7asFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800ECC4CEF1;
	Mon,  1 Dec 2025 11:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588777;
	bh=gE/yu6sasT8wGD94GG8nUl58l7Cy/Ybg6Vq4vCwL2Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7D7asFF33ByYHmTRr2elGIpwuJUbD5HsmzZkS1yqy6H57pa9ASLvdaq/ExS0w5uq
	 qb206XC68xXLsvczaysaykTlbRqSNz1BnBY4W8t6ZuFky1WInRZzFlplyI/yoKo1zh
	 sXJc+rebRdkNmmr8l86BEWKdWLhRSzV+Qh/Wyaz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/187] vsock: Ignore signal/timeout on connect() if already established
Date: Mon,  1 Dec 2025 12:24:36 +0100
Message-ID: <20251201112247.280731031@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 831ca8da84813..2202a8ba2dfdc 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1235,18 +1235,40 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
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



