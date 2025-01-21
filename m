Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302B11F55E5;
	Tue, 21 Jan 2025 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483145; cv=none; b=tPVVTVjtFEBQFdgNAeA0CLolQsz3W4XWnPQfZ3cphhFvJxZ1wCHrtUx9XMGNi+jv9hzUv+/l0sHq303qyybchEhZR1bOeKxNANZQMK3D3fzqKCCZYP4Fjw1k5cFkJdQSjHEq0yDdWdShThYuCConLYfPflLHjcDNkQLV01BBm2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483145; c=relaxed/simple;
	bh=aLRZ8hOx2ol2oBCkNWdDZeTJ4g+4aNS8bEhJtTfFPqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLjcYN5Uuy3ikzkdgfiRhraqXGq3u4uRlpKHUD2OnLZzgBAfBqbFrKK2VdFjOby/s+5ovq85nwEdJwHQRC6ecvUxLX0E3jFkMsef9JpQt82qUVLYUe/BsLUi2NYIzahHKtd7DQzZHC5mcjZu/YE7FszEon43SD77JtSpuZ+O91U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWRWrVGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWRWrVGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5B7C4CEE0;
	Tue, 21 Jan 2025 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483145;
	bh=aLRZ8hOx2ol2oBCkNWdDZeTJ4g+4aNS8bEhJtTfFPqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWRWrVGU9yq8BfjDkWUjWrkQBKYUj6Y+fUMd/TJ8WxT/YCENGTpdbSLIjisjeYCev
	 J6g4+G8ikubMcypCFdknNpkskUm0/2Jm5SoUmYj4QqyDSjguzc11EZolP0P7vufVOr
	 hDhyyvo8tQiKIZ4zQZZtbo3sNIRsly7x+uy+FvUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 106/127] vsock/virtio: cancel close work in the destructor
Date: Tue, 21 Jan 2025 18:52:58 +0100
Message-ID: <20250121174533.740793661@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefano Garzarella <sgarzare@redhat.com>

commit df137da9d6d166e87e40980e36eb8e0bc90483ef upstream.

During virtio_transport_release() we can schedule a delayed work to
perform the closing of the socket before destruction.

The destructor is called either when the socket is really destroyed
(reference counter to zero), or it can also be called when we are
de-assigning the transport.

In the former case, we are sure the delayed work has completed, because
it holds a reference until it completes, so the destructor will
definitely be called after the delayed work is finished.
But in the latter case, the destructor is called by AF_VSOCK core, just
after the release(), so there may still be delayed work scheduled.

Refactor the code, moving the code to delete the close work already in
the do_close() to a new function. Invoke it during destruction to make
sure we don't leave any pending work.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Closes: https://lore.kernel.org/netdev/Z37Sh+utS+iV3+eb@v4bel-B760M-AORUS-ELITE-AX/
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Tested-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -26,6 +26,9 @@
 /* Threshold for detecting small packets to copy */
 #define GOOD_COPY_LEN  128
 
+static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
+					       bool cancel_timeout);
+
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
 {
@@ -811,6 +814,8 @@ void virtio_transport_destruct(struct vs
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
+	virtio_transport_cancel_close_work(vsk, true);
+
 	kfree(vvs);
 	vsk->trans = NULL;
 }
@@ -899,17 +904,11 @@ static void virtio_transport_wait_close(
 	}
 }
 
-static void virtio_transport_do_close(struct vsock_sock *vsk,
-				      bool cancel_timeout)
+static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
+					       bool cancel_timeout)
 {
 	struct sock *sk = sk_vsock(vsk);
 
-	sock_set_flag(sk, SOCK_DONE);
-	vsk->peer_shutdown = SHUTDOWN_MASK;
-	if (vsock_stream_has_data(vsk) <= 0)
-		sk->sk_state = TCP_CLOSING;
-	sk->sk_state_change(sk);
-
 	if (vsk->close_work_scheduled &&
 	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
 		vsk->close_work_scheduled = false;
@@ -921,6 +920,20 @@ static void virtio_transport_do_close(st
 	}
 }
 
+static void virtio_transport_do_close(struct vsock_sock *vsk,
+				      bool cancel_timeout)
+{
+	struct sock *sk = sk_vsock(vsk);
+
+	sock_set_flag(sk, SOCK_DONE);
+	vsk->peer_shutdown = SHUTDOWN_MASK;
+	if (vsock_stream_has_data(vsk) <= 0)
+		sk->sk_state = TCP_CLOSING;
+	sk->sk_state_change(sk);
+
+	virtio_transport_cancel_close_work(vsk, cancel_timeout);
+}
+
 static void virtio_transport_close_timeout(struct work_struct *work)
 {
 	struct vsock_sock *vsk =


