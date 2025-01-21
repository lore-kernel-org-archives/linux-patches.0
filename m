Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC4D1F5439;
	Tue, 21 Jan 2025 18:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482469; cv=none; b=SvRG4UFCHNl8Yj1u8sbWYERDy//AlWhuYiQLxLXFtHAOdfwqJvubdf1Xi8achqhPVSJGRHMRVMrf0znbyqwkqS8pvdVnUI9YJUwBQlkfH6mzNO931DU+7zFFJ6kAJfUXi97N5HfZ7k8Ar6nAGl1TnAbKP5T6sfZ8AiH2QmJDwWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482469; c=relaxed/simple;
	bh=Dgq1oX+bSWMOtkyMl/Dubo5g9genSl+TcyL8NVlPLqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWDiOthnX1a+LNjktwFD3VO7ySoVYpET2xO3qKtUCjZzNCRVK/dliHApTfjkxko5csWvAbsRlsSAg6nx8hi6hJHtcg26qupUGmVWTU73u7f2XhFSBxgFsSu+dcvanj8optexOc7YyH7uXm4uR4u/ae3OYtGToxSBiCbd9ZhvLjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFLYNiyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFLYNiyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44914C4CEDF;
	Tue, 21 Jan 2025 18:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482469;
	bh=Dgq1oX+bSWMOtkyMl/Dubo5g9genSl+TcyL8NVlPLqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFLYNiyFiavjjEI+LCQ1vffu/1z7xH7F0pprvEz3QZ2zb5gP+4Q3EzqmUQh+kW7Sx
	 Ayn+WBrMqYDC4xu1KGtkmobBzLBA7gsPB3wuFnCApawd5w8fCQoXeO+2vNhBuTdfCW
	 yE/BaaMjMT0hewFzu3NnhoFGauUYZgI/hWZw5GDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 087/122] vsock: reset socket state when de-assigning the transport
Date: Tue, 21 Jan 2025 18:52:15 +0100
Message-ID: <20250121174536.372098197@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

commit a24009bc9be60242651a21702609381b5092459e upstream.

Transport's release() and destruct() are called when de-assigning the
vsock transport. These callbacks can touch some socket state like
sock flags, sk_state, and peer_shutdown.

Since we are reassigning the socket to a new transport during
vsock_connect(), let's reset these fields to have a clean state with
the new transport.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -491,6 +491,15 @@ int vsock_assign_transport(struct vsock_
 		 */
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
+
+		/* transport's release() and destruct() can touch some socket
+		 * state, since we are reassigning the socket to a new transport
+		 * during vsock_connect(), let's reset these fields to have a
+		 * clean state.
+		 */
+		sock_reset_flag(sk, SOCK_DONE);
+		sk->sk_state = TCP_CLOSE;
+		vsk->peer_shutdown = 0;
 	}
 
 	/* We increase the module refcnt to prevent the transport unloading


