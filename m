Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E48C3D34B5;
	Fri, 15 May 2026 16:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862831; cv=none; b=mpH0GRIXY6/s46REBVOW2FH//O31aUCpJXN4E/QRE3LRj2cczGH3dRxsAs9/K2MibfE5Y7icgyAyz8owuTqAbE2ho7XFSBlBH+qQ45NQDEwmBHw+1Q7P/W/ig8qPDdfSFZORphdE1AO1l2PZw6KrQSkw/Ao1sWXDV0GMqwFFDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862831; c=relaxed/simple;
	bh=ZSCvgmwu4PfcnCI/tSLSv91bBjDzg/tLz+5jG69rTPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhKnSghr6wGTnlr96b+jkTBHaWYnWRTN6DstpIOYYX8M8f1ps7lU349JDaNR+k0rUN49gBrynX0Ytt7K27QPu+krdhU3jUtkIDSE9qYXdR8dAGuBoYsqf0fpHK7kfaswrAn3D8nzw1YfqoF1rYZH32EU5kL5v5lKx9vPEvtLj8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIqySaX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIqySaX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B2AC2BCB0;
	Fri, 15 May 2026 16:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862831;
	bh=ZSCvgmwu4PfcnCI/tSLSv91bBjDzg/tLz+5jG69rTPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIqySaX4WQN6t9y7SLQBA1oyJdmdQfk1mffPnstBA9aUh8Har41QNkNoIMzYQ7982
	 5CguCq86bnOj4sov8C6aR6Q5OGzH7v6aH1BEXh03IQBKl8R49Djt4GuueYhV4gRU6f
	 7/L/RTUmVYaMV0df1X6A+h+bbuG8v9vXF8kx90wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.0 199/201] vsock/virtio: fix accept queue count leak on transport mismatch
Date: Fri, 15 May 2026 17:50:17 +0200
Message-ID: <20260515154702.890804926@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

commit 52bcb57a4e8a0865a76c587c2451906342ae1b2d upstream.

virtio_transport_recv_listen() calls sk_acceptq_added() before
vsock_assign_transport(). If vsock_assign_transport() fails or
selects a different transport, the error path returns without
calling sk_acceptq_removed(), permanently incrementing
sk_ack_backlog.

After approximately backlog+1 such failures, sk_acceptq_is_full()
returns true, causing the listener to reject all new connections.

Fix by moving sk_acceptq_added() to after the transport validation,
matching the pattern used by vmci_transport and hyperv_transport.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260413131409.19022-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Cc: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1546,8 +1546,6 @@ virtio_transport_recv_listen(struct sock
 		return -ENOMEM;
 	}
 
-	sk_acceptq_added(sk);
-
 	lock_sock_nested(child, SINGLE_DEPTH_NESTING);
 
 	child->sk_state = TCP_ESTABLISHED;
@@ -1569,6 +1567,7 @@ virtio_transport_recv_listen(struct sock
 		return ret;
 	}
 
+	sk_acceptq_added(sk);
 	if (virtio_transport_space_update(child, skb))
 		child->sk_write_space(child);
 


