Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09272E7373;
	Sun,  7 Jun 2026 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827265; cv=none; b=Bx6rNgvUXd1Nu7btF61PUGX+AqyuCz9Q1ar/jprMJ5zjSTujnSwUzfLv9BFAfCPPS9GmTNx3JJ3WfWk5GYtFSTDStJx78ttuLzeRtVSMFM5rUYeaZDRbNd4PiCasgddMro3o2AC0iVvtY2ilyHA2uySTTZVjohGUNB6xQv062mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827265; c=relaxed/simple;
	bh=VrWrXbFZjjNiTO5N0hNCXtSGYih4rWczD3VRmFceyE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRXhGOFrTZa0J/NPgEMeZPEbl0HY98Idz4sgTOk5pAPDqp9iIyXGeKw/Bj612qPCyjC8a7Ja5jPRu8z81tLTLH3AlXZ8Yc195CmxY1ptInjxmASHcKMj0ON+V9HH0jyfO+Dbf8FBDwkj0g3bzWqKqs82NvjCK5ggtUN0kz0VqB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1za+Rel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1za+Rel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C8B1F00893;
	Sun,  7 Jun 2026 10:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827263;
	bh=M6typTFKWPeVPDy/PNDI/8BriFCQBjlwG/OiXHBp53M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1za+RelQVq8/qtIuV/FUtj7yNfs3vMvCMIVCb3swP1lYfDkTRsjuHJ8l0hjwEkHE
	 roGw6oqrTnKVT67qIRbWDcGpXfJ92Pt8MNVNKc7cQVhw7E9K9gzsNBclVrj/6769uf
	 nW7eOvO/PDYEFGcRSgkb9ULKefTXE4zHq12gS+kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyu Zhang <ziyuzhang201@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/307] vsock: keep poll shutdown state consistent
Date: Sun,  7 Jun 2026 11:57:13 +0200
Message-ID: <20260607095729.007373392@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyu Zhang <ziyuzhang201@gmail.com>

[ Upstream commit aae9d8a5528b8ee9ff8dc5d3558b8a9f852a724a ]

vsock_poll() reads vsk->peer_shutdown before taking the socket lock
to set EPOLLHUP and EPOLLRDHUP, then reads it again after taking
the lock to report EOF readability. A shutdown packet can update
peer_shutdown while poll is waiting for the lock, so one poll invocation
can report EOF readability without the corresponding HUP/RDHUP bits.

For connectible sockets, take one peer_shutdown snapshot after
lock_sock() and use it for all peer-shutdown-derived poll bits. For
datagram sockets, which do not take lock_sock() in poll(), take one
lockless READ_ONCE() snapshot and pair it with WRITE_ONCE() on the
writer side.

This keeps the peer-shutdown-derived bits internally consistent for each
poll pass.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Ziyu Zhang <ziyuzhang201@gmail.com>
Link: https://patch.msgid.link/20260519165636.62542-1-ziyuzhang201@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c                | 49 ++++++++++++++++---------
 net/vmw_vsock/hyperv_transport.c        |  9 +++--
 net/vmw_vsock/virtio_transport_common.c | 14 ++++---
 net/vmw_vsock/vmci_transport.c          |  8 ++--
 4 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 1db7a1f8e55f6d..f03e00cae028a5 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -523,7 +523,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		 */
 		sock_reset_flag(sk, SOCK_DONE);
 		sk->sk_state = TCP_CLOSE;
-		vsk->peer_shutdown = 0;
+		WRITE_ONCE(vsk->peer_shutdown, 0);
 	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
@@ -814,7 +814,7 @@ static struct sock *__vsock_create(struct net *net,
 	vsk->rejected = false;
 	vsk->sent_request = false;
 	vsk->ignore_connecting_rst = false;
-	vsk->peer_shutdown = 0;
+	WRITE_ONCE(vsk->peer_shutdown, 0);
 	INIT_DELAYED_WORK(&vsk->connect_work, vsock_connect_timeout);
 	INIT_DELAYED_WORK(&vsk->pending_work, vsock_pending_work);
 
@@ -1099,6 +1099,25 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	return err;
 }
 
+static __poll_t vsock_poll_shutdown(struct sock *sk, u32 peer_shutdown)
+{
+	__poll_t mask = 0;
+
+	/* INET sockets treat local write shutdown and peer write shutdown as a
+	 * case of EPOLLHUP set.
+	 */
+	if (sk->sk_shutdown == SHUTDOWN_MASK ||
+	    ((sk->sk_shutdown & SEND_SHUTDOWN) &&
+	     (peer_shutdown & SEND_SHUTDOWN)))
+		mask |= EPOLLHUP;
+
+	if (sk->sk_shutdown & RCV_SHUTDOWN ||
+	    peer_shutdown & SEND_SHUTDOWN)
+		mask |= EPOLLRDHUP;
+
+	return mask;
+}
+
 static __poll_t vsock_poll(struct file *file, struct socket *sock,
 			       poll_table *wait)
 {
@@ -1116,24 +1135,17 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		/* Signify that there has been an error on this socket. */
 		mask |= EPOLLERR;
 
-	/* INET sockets treat local write shutdown and peer write shutdown as a
-	 * case of EPOLLHUP set.
-	 */
-	if ((sk->sk_shutdown == SHUTDOWN_MASK) ||
-	    ((sk->sk_shutdown & SEND_SHUTDOWN) &&
-	     (vsk->peer_shutdown & SEND_SHUTDOWN))) {
-		mask |= EPOLLHUP;
-	}
-
-	if (sk->sk_shutdown & RCV_SHUTDOWN ||
-	    vsk->peer_shutdown & SEND_SHUTDOWN) {
-		mask |= EPOLLRDHUP;
-	}
-
 	if (sk_is_readable(sk))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	if (sock->type == SOCK_DGRAM) {
+		u32 peer_shutdown = READ_ONCE(vsk->peer_shutdown);
+
+		/* DGRAM sockets do not take lock_sock() in poll(), so use one
+		 * lockless snapshot for all shutdown-derived mask bits.
+		 */
+		mask |= vsock_poll_shutdown(sk, peer_shutdown);
+
 		/* For datagram sockets we can read if there is something in
 		 * the queue and write as long as the socket isn't shutdown for
 		 * sending.
@@ -1148,6 +1160,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 
 	} else if (sock_type_connectible(sk->sk_type)) {
 		const struct vsock_transport *transport;
+		u32 peer_shutdown;
 
 		lock_sock(sk);
 
@@ -1180,8 +1193,10 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		 * terminated should also be considered read, and we check the
 		 * shutdown flag for that.
 		 */
+		peer_shutdown = READ_ONCE(vsk->peer_shutdown);
+		mask |= vsock_poll_shutdown(sk, peer_shutdown);
 		if (sk->sk_shutdown & RCV_SHUTDOWN ||
-		    vsk->peer_shutdown & SEND_SHUTDOWN) {
+		    peer_shutdown & SEND_SHUTDOWN) {
 			mask |= EPOLLIN | EPOLLRDNORM;
 		}
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 34871ed1a099c6..865e004ee286f2 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -264,7 +264,7 @@ static void hvs_do_close_lock_held(struct vsock_sock *vsk,
 	struct sock *sk = sk_vsock(vsk);
 
 	sock_set_flag(sk, SOCK_DONE);
-	vsk->peer_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(vsk->peer_shutdown, SHUTDOWN_MASK);
 	if (vsock_stream_has_data(vsk) <= 0)
 		sk->sk_state = TCP_CLOSING;
 	sk->sk_state_change(sk);
@@ -593,7 +593,9 @@ static int hvs_update_recv_data(struct hvsock *hvs)
 		return -EIO;
 
 	if (payload_len == 0)
-		hvs->vsk->peer_shutdown |= SEND_SHUTDOWN;
+		WRITE_ONCE(hvs->vsk->peer_shutdown,
+			   READ_ONCE(hvs->vsk->peer_shutdown) |
+			   SEND_SHUTDOWN);
 
 	hvs->recv_data_len = payload_len;
 	hvs->recv_data_off = 0;
@@ -704,7 +706,8 @@ static s64 hvs_stream_has_data(struct vsock_sock *vsk)
 		ret = 1;
 		break;
 	case 0:
-		vsk->peer_shutdown |= SEND_SHUTDOWN;
+		WRITE_ONCE(vsk->peer_shutdown,
+			   READ_ONCE(vsk->peer_shutdown) | SEND_SHUTDOWN);
 		ret = 0;
 		break;
 	default: /* -1 */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index c182886136b445..b588ccd133eaa7 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1234,7 +1234,7 @@ static void virtio_transport_do_close(struct vsock_sock *vsk,
 	struct sock *sk = sk_vsock(vsk);
 
 	sock_set_flag(sk, SOCK_DONE);
-	vsk->peer_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(vsk->peer_shutdown, SHUTDOWN_MASK);
 	if (vsock_stream_has_data(vsk) <= 0)
 		sk->sk_state = TCP_CLOSING;
 	sk->sk_state_change(sk);
@@ -1437,12 +1437,15 @@ virtio_transport_recv_connected(struct sock *sk,
 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
 		sk->sk_write_space(sk);
 		break;
-	case VIRTIO_VSOCK_OP_SHUTDOWN:
+	case VIRTIO_VSOCK_OP_SHUTDOWN: {
+		u32 peer_shutdown = READ_ONCE(vsk->peer_shutdown);
+
 		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SHUTDOWN_RCV)
-			vsk->peer_shutdown |= RCV_SHUTDOWN;
+			peer_shutdown |= RCV_SHUTDOWN;
 		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
-			vsk->peer_shutdown |= SEND_SHUTDOWN;
-		if (vsk->peer_shutdown == SHUTDOWN_MASK) {
+			peer_shutdown |= SEND_SHUTDOWN;
+		WRITE_ONCE(vsk->peer_shutdown, peer_shutdown);
+		if (peer_shutdown == SHUTDOWN_MASK) {
 			if (vsock_stream_has_data(vsk) <= 0 && !sock_flag(sk, SOCK_DONE)) {
 				(void)virtio_transport_reset(vsk, NULL);
 				virtio_transport_do_close(vsk, true);
@@ -1457,6 +1460,7 @@ virtio_transport_recv_connected(struct sock *sk,
 		if (le32_to_cpu(virtio_vsock_hdr(skb)->flags))
 			sk->sk_state_change(sk);
 		break;
+	}
 	case VIRTIO_VSOCK_OP_RST:
 		virtio_transport_do_close(vsk, true);
 		break;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 4cd11f355e9d6b..443125e48f2481 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -811,7 +811,7 @@ static void vmci_transport_handle_detach(struct sock *sk)
 		/* On a detach the peer will not be sending or receiving
 		 * anymore.
 		 */
-		vsk->peer_shutdown = SHUTDOWN_MASK;
+		WRITE_ONCE(vsk->peer_shutdown, SHUTDOWN_MASK);
 
 		/* We should not be sending anymore since the peer won't be
 		 * there to receive, but we can still receive if there is data
@@ -1534,7 +1534,9 @@ static int vmci_transport_recv_connected(struct sock *sk,
 		if (pkt->u.mode) {
 			vsk = vsock_sk(sk);
 
-			vsk->peer_shutdown |= pkt->u.mode;
+			WRITE_ONCE(vsk->peer_shutdown,
+				   READ_ONCE(vsk->peer_shutdown) |
+				   pkt->u.mode);
 			sk->sk_state_change(sk);
 		}
 		break;
@@ -1551,7 +1553,7 @@ static int vmci_transport_recv_connected(struct sock *sk,
 		 * a clean shutdown.
 		 */
 		sock_set_flag(sk, SOCK_DONE);
-		vsk->peer_shutdown = SHUTDOWN_MASK;
+		WRITE_ONCE(vsk->peer_shutdown, SHUTDOWN_MASK);
 		if (vsock_stream_has_data(vsk) <= 0)
 			sk->sk_state = TCP_CLOSING;
 
-- 
2.53.0



