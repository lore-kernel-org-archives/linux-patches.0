Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806130E0DC;
	Sat, 30 May 2026 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163856; cv=none; b=bVu3BLIbnElhquQ5VHATU8CbxGBnHIt271tto/V3WMM82RrdfxlMfZMlX05m17PZH0XYF2+hdkO6dAluFFtq5sV7gDB/TDdbiH/SeYpnkXzzRfK+RaPCaNf3CgpsGPADU33w92iNwRsJmdDKyUaxC86cG7JdjB45wc4HBEX494E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163856; c=relaxed/simple;
	bh=VuftIgEo+2vEWkN1umeY85h6tgEmtyb6Eu2+4yi6NQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWX9TIiROYn3zi+x6LZ4aSd5aXjyiXSRqO8o0bOMGQCJ1GqaJQg3ZDNacvq6vfzVL7+6iE6P3jSCDrtWfmlR2+RLUsNp0Q5DznbRPr8Opb8U3ATbjUVnC4p6Nba5khjLLWT8qcLXSyUh1KJgHL6Gw/Nb93xU7vkhz7+RD6p2AU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT39R65X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT39R65X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB341F00893;
	Sat, 30 May 2026 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163855;
	bh=rcR0mTGCKO6k6ebQPg7TPxPvNd4JaYDX8/JMVrU7HUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT39R65Xjsatywcw8y6Q1OpSOPZXgzzK+dcxDbXnhcGTsf9SpS9++tdYZ3iQA/CNr
	 oD30LpGgJaXJKPlnWlA/qPhl2erAFijejATMmNECQcm3fjri8HSKHoJBhAbfEInLll
	 YiYJseGOVLxtS1NzKiOrbVwnqjuNR1adYDFiDLwE=
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
Subject: [PATCH 5.15 382/776] vsock/virtio: fix accept queue count leak on transport mismatch
Date: Sat, 30 May 2026 18:01:36 +0200
Message-ID: <20260530160250.388961106@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
Signed-off-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1223,8 +1223,6 @@ virtio_transport_recv_listen(struct sock
 		return -ENOMEM;
 	}
 
-	sk_acceptq_added(sk);
-
 	lock_sock_nested(child, SINGLE_DEPTH_NESTING);
 
 	child->sk_state = TCP_ESTABLISHED;
@@ -1246,6 +1244,7 @@ virtio_transport_recv_listen(struct sock
 		return ret;
 	}
 
+	sk_acceptq_added(sk);
 	if (virtio_transport_space_update(child, pkt))
 		child->sk_write_space(child);
 


