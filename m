Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD3F32D42B;
	Sat, 30 May 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160763; cv=none; b=GzIGz9rUkpBMFpwTpqd4B7DkP0TO3+X+Dx88r9CPCxovrFpwwT3EJYRHQY4fvO6J+ovb80l1z32KWE8yTyBAhZMOnHZQd8wKs/PQs1qZj86xiZxbsUejzw6ESTFLyD8e2CDFnWlw5sA3RCI3ACYLMjvdD4drDn8e9BepQEnOnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160763; c=relaxed/simple;
	bh=0dtlA36WnvNCnxYzcjrMG2rZNUd0lyz83Q53hdCuGJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkIpyyEUcraEhMlUSgEGg99uR2ZZmMFTQ8lNCv8X4CAb839nQzUa1oNXLQe4uVnUeVGZFggudzZ3/JmLphgSp7v6+g4yhx70J9OPLv6VXVF9alM2pHlYJ+i7izdu/SS6LEyz4xWYXjIL7eQfihhSy3O50IZgCV0pYVcvoO8jGKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RamkycTk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RamkycTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC601F00893;
	Sat, 30 May 2026 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160762;
	bh=JBh6e5+m3KvnPSWUniNWs/yf7jFyOdplMMrjXOpWbPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RamkycTkXu6vNXuNXysbQEZjw3ZW7kKSrvwKjkE41H35FDfZ3MFLuBloflJhbAlBT
	 20z9VtckE8mkBKj9PiEYRKgIZW7SGogBMyppQHztebQNM6Z2tejDd5s/pj8vdQ3YCK
	 9IMwBrfWYWneWxE8vXLLpNtDvT/Ijyy4c14tRIHQ=
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
Subject: [PATCH 6.1 427/969] vsock/virtio: fix accept queue count leak on transport mismatch
Date: Sat, 30 May 2026 17:59:11 +0200
Message-ID: <20260530160312.051256173@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1259,8 +1259,6 @@ virtio_transport_recv_listen(struct sock
 		return -ENOMEM;
 	}
 
-	sk_acceptq_added(sk);
-
 	lock_sock_nested(child, SINGLE_DEPTH_NESTING);
 
 	child->sk_state = TCP_ESTABLISHED;
@@ -1282,6 +1280,7 @@ virtio_transport_recv_listen(struct sock
 		return ret;
 	}
 
+	sk_acceptq_added(sk);
 	if (virtio_transport_space_update(child, skb))
 		child->sk_write_space(child);
 


