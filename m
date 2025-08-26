Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E40F341ABD;
	Tue, 26 Aug 2025 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217556; cv=none; b=LZW/kvrKyJhwXXA9P6IdpEFlotbuw9pHLEyooWAM211Qc9DgRNvTqdmhG9XkAeKr+ZItdZr6jt2dCQH/GjlpUlWHW0p1C+pEDKlHcNO1zS/bcW8V4ASNaRgTlcQag0IMoKeA0lTQWxyGUJaMgmhx02GF/LiQEJ/s+zJv57CD2lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217556; c=relaxed/simple;
	bh=+uu7/+H0c66ypD3JGWlcebD3VshWzWxvgyRV9YX5C2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQWDNDdDwwlebpuLeP2oOFeFnRGul2ocGQ/O1G3YPBORxCfESCjwvYXxwGu40x63PZDUJrJ5lsirzJsRmk2mR5Ti3o6XuJC/WUX5HORwGCQLf4Ji9CmJLxMVlzcHteQK73bYIV2wscWYi10t4XOzJjHMbExubLh7eKFeZowK+Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYQNrMSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYQNrMSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A85C4CEF1;
	Tue, 26 Aug 2025 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217556;
	bh=+uu7/+H0c66ypD3JGWlcebD3VshWzWxvgyRV9YX5C2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYQNrMSaqalwM+yyvXy0O8xk/6b92hV1xS8aT7FF8ijqzgTRTPWPt/AekPSo7f+Yg
	 RsXI3fxKr5sXdie5enO22pA+Kq0mc9/TXR+pdnD7DzwEMvfZPaQoheKR1rahgr1o4e
	 cm1KzT5TvkRpKHHQNyIOuLzzT5YdvNEe1CdeV3hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 187/523] vsock: Do not allow binding to VMADDR_PORT_ANY
Date: Tue, 26 Aug 2025 13:06:37 +0200
Message-ID: <20250826110929.065327889@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Budimir Markovic <markovicbudimir@gmail.com>

commit aba0c94f61ec05315fa7815d21aefa4c87f6a9f4 upstream.

It is possible for a vsock to autobind to VMADDR_PORT_ANY. This can
cause a use-after-free when a connection is made to the bound socket.
The socket returned by accept() also has port VMADDR_PORT_ANY but is not
on the list of unbound sockets. Binding it will result in an extra
refcount decrement similar to the one fixed in fcdd2242c023 (vsock: Keep
the binding until socket destruction).

Modify the check in __vsock_bind_connectible() to also prevent binding
to VMADDR_PORT_ANY.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Signed-off-by: Budimir Markovic <markovicbudimir@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20250807041811.678-1-markovicbudimir@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -674,7 +674,8 @@ static int __vsock_bind_stream(struct vs
 		unsigned int i;
 
 		for (i = 0; i < MAX_PORT_RETRIES; i++) {
-			if (port <= LAST_RESERVED_PORT)
+			if (port == VMADDR_PORT_ANY ||
+			    port <= LAST_RESERVED_PORT)
 				port = LAST_RESERVED_PORT + 1;
 
 			new_addr.svm_port = port++;


