Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A443C470
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlPN4c1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869BDC433C8;
	Wed, 15 Nov 2023 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077144;
	bh=xtYCGKIIz+gXerS1GWwdKHB626nPCCDn9CV2ODfuOB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlPN4c1tZKwZjiHi4sYdPpS6JOOKiVb8IMFQVQeLtrhixHlAfUkH13v3Wua2sWi5k
	 CXERXKeki43q6YhxDjbCjDuR3BLyVMq37rpH4uN/BWTlymACugZ2V9OKHrXIKpfqLT
	 Z4ZRTlKnrXf7BO7ItzwyU9j8foiSvNi1ZY44w/0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Luigi Leonardi <luigi.leonardi@outlook.com>,
	Filippo Storniolo <f.storniolo95@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 522/550] vsock/virtio: remove socket from connected/bound list on shutdown
Date: Wed, 15 Nov 2023 14:18:26 -0500
Message-ID: <20231115191637.118598066@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filippo Storniolo <f.storniolo95@gmail.com>

[ Upstream commit 3a5cc90a4d1756072619fe511d07621bdef7f120 ]

If the same remote peer, using the same port, tries to connect
to a server on a listening port more than once, the server will
reject the connection, causing a "connection reset by peer"
error on the remote peer. This is due to the presence of a
dangling socket from a previous connection in both the connected
and bound socket lists.
The inconsistency of the above lists only occurs when the remote
peer disconnects and the server remains active.

This bug does not occur when the server socket is closed:
virtio_transport_release() will eventually schedule a call to
virtio_transport_do_close() and the latter will remove the socket
from the bound and connected socket lists and clear the sk_buff.

However, virtio_transport_do_close() will only perform the above
actions if it has been scheduled, and this will not happen
if the server is processing the shutdown message from a remote peer.

To fix this, introduce a call to vsock_remove_sock()
when the server is handling a client disconnect.
This is to remove the socket from the bound and connected socket
lists without clearing the sk_buff.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Reported-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Tested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Filippo Storniolo <f.storniolo95@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc2589315..f5ea654ca659b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1150,11 +1150,17 @@ virtio_transport_recv_connected(struct sock *sk,
 			vsk->peer_shutdown |= RCV_SHUTDOWN;
 		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
-		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
-		    vsock_stream_has_data(vsk) <= 0 &&
-		    !sock_flag(sk, SOCK_DONE)) {
-			(void)virtio_transport_reset(vsk, NULL);
-			virtio_transport_do_close(vsk, true);
+		if (vsk->peer_shutdown == SHUTDOWN_MASK) {
+			if (vsock_stream_has_data(vsk) <= 0 && !sock_flag(sk, SOCK_DONE)) {
+				(void)virtio_transport_reset(vsk, NULL);
+				virtio_transport_do_close(vsk, true);
+			}
+			/* Remove this socket anyway because the remote peer sent
+			 * the shutdown. This way a new connection will succeed
+			 * if the remote peer uses the same source port,
+			 * even if the old socket is still unreleased, but now disconnected.
+			 */
+			vsock_remove_sock(vsk);
 		}
 		if (le32_to_cpu(virtio_vsock_hdr(skb)->flags))
 			sk->sk_state_change(sk);
-- 
2.42.0



