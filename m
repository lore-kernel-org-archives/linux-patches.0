Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A3E2E7BD4;
	Tue, 12 Aug 2025 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023027; cv=none; b=Yk5KC8zmWmwLdcC74fZehEALLEbi7HgWYeqJz/W7/P8BqjvhkRDu55sL6BzEZ/Av/blCnyZM+3r4DrsUe87lb6+V5iwlZPc3WqmOs6Q3vqZZtwYgEs3dLkYOTNdVK4SDZoWJhGENlLnlfQ0/x8PruS9+wxLIVrGHg2Yl2wF4NYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023027; c=relaxed/simple;
	bh=WW8n3AN53Q8PjOEncfCWbR4mMpJOWD41alg48nHginQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MekqzFOBnOpz4DWE4F/JbDEKeoX6tVOF0QIDglEdpsumlm8+DWioKjiybziBUiqHdAmM3PDshs4xUk8RNRqKVpe7ZjFhmegNnQPndooSdNnQOjgPrdsN4ESuyMFnSpZS29hF0B2UDdGrltCKEZhz0xXR0MUPVYAUos0UD5UhiTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuhBPHYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuhBPHYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42997C4CEF7;
	Tue, 12 Aug 2025 18:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023027;
	bh=WW8n3AN53Q8PjOEncfCWbR4mMpJOWD41alg48nHginQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuhBPHYsRUrEy3ONeqvPX0Qm1owPelBlO51Srr+1fjybBEIlZz97LVe90SfX5gMCe
	 ghE4l1VBP4k+nljO6pPzFHHyW9y26/95ipCjQXadDlKXdacECqnu75TSkaszWGR3ma
	 MOoBh350Ue3zHHVX/Tnsk9ZzcWHHqu5IkjcB7vDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 329/369] vsock: Do not allow binding to VMADDR_PORT_ANY
Date: Tue, 12 Aug 2025 19:30:26 +0200
Message-ID: <20250812173029.089176088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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


