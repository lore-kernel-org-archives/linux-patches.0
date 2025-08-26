Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616243568F3;
	Tue, 26 Aug 2025 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218920; cv=none; b=WfJfwZhgnz3rL04QDUH7ao0DVmDAyrS/8VtJuyVthjGUwbmtfB7Y8EpNh1oBh4f5zLiHmVMgS/Uu2rN5/9ROCE0uUI9Azm1KrWRsDEAimuaGFcrt75d01mIXggMdpVHzqmSAjH4V213JrCZru4U08VvfIRg2O3Ib4GWLazfC3R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218920; c=relaxed/simple;
	bh=kEV67ClEMn5EfBRA2DJ4DWWpEKIOnA2YUuNgTHeA5Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1PH0RnjPb/tmYoaNt76yn/QtKLeDRSHvuXUfZSWHDVgCB/QALMWoO2/Er/aexTDPUzfGhCp6oEu60YSwEwe2GIMEfaKUHQzRXs2hnKVFLZOibqrZGzt+ImEOn/nszxWw8IloA9ndgeOlg5K0QGhjw07a259zgRaDDaS+3WcQjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxYdLzhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxYdLzhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CECC4CEF1;
	Tue, 26 Aug 2025 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218917;
	bh=kEV67ClEMn5EfBRA2DJ4DWWpEKIOnA2YUuNgTHeA5Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxYdLzhATn0EIid8RZLbQjvHlx5VfKd0nY3o0oQGM0R3RPujfOQQy6CnTm0uy7iSw
	 //KQZ6jvCj5wbxTR2WGlD8X2Q8QntPuxR+F5S+Mi0xIWrarFowRiiVJpFQTLwXdPuf
	 WLGODLOJ7LNyCjf4YPRyYk01A2QztmEBo1R3FT4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 152/403] vsock: Do not allow binding to VMADDR_PORT_ANY
Date: Tue, 26 Aug 2025 13:07:58 +0200
Message-ID: <20250826110911.080522737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -487,7 +487,8 @@ static int __vsock_bind_stream(struct vs
 		unsigned int i;
 
 		for (i = 0; i < MAX_PORT_RETRIES; i++) {
-			if (port <= LAST_RESERVED_PORT)
+			if (port == VMADDR_PORT_ANY ||
+			    port <= LAST_RESERVED_PORT)
 				port = LAST_RESERVED_PORT + 1;
 
 			new_addr.svm_port = port++;


