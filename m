Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390EC2F90C8;
	Tue, 12 Aug 2025 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021823; cv=none; b=Y59TO3uKK7uGpVZf/aTUPs56aiclhTyMOM8FuDFSDjkzvBQ0jWeEfwbSVRk+DNCw3uTSxzmBvZDqOo3rxuxBLrVsuihfEgOW7zhxyQo19au4voq0aIz4vBkpodOhDdNPLohqy5n//0f2MrpK4Ny9CaCFbmPPKKV5QrBOuT8Kn+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021823; c=relaxed/simple;
	bh=uyDlPsu6Xz81az/L8CIWbQ3yjJ8TWVtBbzQpD7O9r8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPef2WBfSD/cJX6y6iVoAxSoLa6POE3RKsqoYzvl60FimcKYfC+TB0yLRQNfLuWOymzAOjdZKA7He/c23CI+Bak3fSvZd8gjP4XmXYxad77/sEBNem8rxPRphEbAHBG6yCNdRYb0LB6HoZ0cUg+53yBX3Q+KKvqgnMbai9UMLu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYoJpxg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYoJpxg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C33C4CEF6;
	Tue, 12 Aug 2025 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021823;
	bh=uyDlPsu6Xz81az/L8CIWbQ3yjJ8TWVtBbzQpD7O9r8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYoJpxg4+ywh7zYU+ZkcagrRROZxMYIo1FclcDOlM0+pRChO+pNO7tBPfNz9EzzZ9
	 kezaE77/O7660GXi7wyZHB5P/NuawkiCTgFuI+Uv4sE6xHMTbXAMKOHXzcfnZK2o50
	 uNwhvnLEgJuaecSO8VVhgkQcpiy/SCbj2iDE17AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 236/262] vsock: Do not allow binding to VMADDR_PORT_ANY
Date: Tue, 12 Aug 2025 19:30:24 +0200
Message-ID: <20250812173003.208617070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -688,7 +688,8 @@ static int __vsock_bind_connectible(stru
 		unsigned int i;
 
 		for (i = 0; i < MAX_PORT_RETRIES; i++) {
-			if (port <= LAST_RESERVED_PORT)
+			if (port == VMADDR_PORT_ANY ||
+			    port <= LAST_RESERVED_PORT)
 				port = LAST_RESERVED_PORT + 1;
 
 			new_addr.svm_port = port++;


