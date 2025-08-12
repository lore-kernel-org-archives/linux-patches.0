Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A131E47AD;
	Tue, 12 Aug 2025 19:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026913; cv=none; b=KU5Ttnwp18y71bFa3FaR5pTLgS0dQBPwDnELDPCS4XhGj9JZ5Gsxo77rqe2c3iDIZdQ1NB6xOmNLlXr8HjzrCP3Wl8+Ff6UV+9+OUxOl6hITRT3yE7whmeJM6gvW2AwAT88zhLXPBoYcVEe1/xHV+Lt30+IbzkkEm198NWIZiOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026913; c=relaxed/simple;
	bh=/h0fpu35yGryy9oEnbyt3OnM58z/9FB5lY+uQcPTZ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ue+nD6aln7L5uxcxNlsWkfsqLyncPCE2G+okmFtfZXomiVkRrODHjGwOECHdaj9kx9zV/h6+Ckb7R9LIxAAkJ/ImT7cnSRRF+6xyRSM0LYCPhnCEDhei8YUe0TatPyy5X5nKsyrYNytLdZcT2W+VFmQhL/EKoWJd1L9ksfVBsVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyV9HTxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyV9HTxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C18C4CEF0;
	Tue, 12 Aug 2025 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026912;
	bh=/h0fpu35yGryy9oEnbyt3OnM58z/9FB5lY+uQcPTZ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyV9HTxdM0DyGMiDnK1+AeL6bqR9YnxV23cQH+SsQYV3HdpY09QEb51TpqDsGF0yY
	 FHsB3/ZRGeiMz2OhsImWkLw1RmG3mcS1jV1EhXfar6NhbQr0FbcSYmxhdDAltn5qdH
	 zkUQmnHNVRsfl8y2+e360fzL6SrhtokKOkCUONNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 443/480] vsock: Do not allow binding to VMADDR_PORT_ANY
Date: Tue, 12 Aug 2025 19:50:51 +0200
Message-ID: <20250812174415.663500234@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -689,7 +689,8 @@ static int __vsock_bind_connectible(stru
 		unsigned int i;
 
 		for (i = 0; i < MAX_PORT_RETRIES; i++) {
-			if (port <= LAST_RESERVED_PORT)
+			if (port == VMADDR_PORT_ANY ||
+			    port <= LAST_RESERVED_PORT)
 				port = LAST_RESERVED_PORT + 1;
 
 			new_addr.svm_port = port++;


