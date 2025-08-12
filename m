Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9402DE1E2;
	Tue, 12 Aug 2025 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021271; cv=none; b=hqrfM9cC3nkfg4PWjDgeBFy7ISrO5iptwtFf/3j56GKhwoWil3XzAQGUe/Gqk/N1yyF1QkLj6ZDa+SXdPi9P+Z5PtX7TeUd0XwsDA19oDY2WHhooEmnD+RITo6ZFjE8YCf4qzlmcpU5DDYAcCgI5YmRSi5UL1OmfaGbXOAM2GHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021271; c=relaxed/simple;
	bh=tv2kMlPB1unzEKw2b6QSXiKutxmEu5YFj1oQWdgV8zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNOjMtipVA2mqECA/GDaWq2nmE1xUEmGYp8035C6EpvQTwWjekGQ4S46fI9yvQdddErGYGvYs+PfiDmNtTNVHUakm6aGEudHUGZN8jP57qmYMocXSIHYLc1BbZJPrLjrhE27pCKXSfhjrbklfq3R1zVqsT9nyGnzpuiunPKVzb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWiaxjwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWiaxjwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C914C4CEF0;
	Tue, 12 Aug 2025 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021270;
	bh=tv2kMlPB1unzEKw2b6QSXiKutxmEu5YFj1oQWdgV8zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWiaxjwg/nC7AH5mGavBlhHzA1JIRe1wcaqPEUSuAXuvOvjwfCde/btR5QK5DC5LT
	 SWfA/Q7TApU5qrZOPEDaR/XrVLZc7ln6ySOj7k4KibzJdrzEv9tuRUFlLS6Qy3W4k2
	 zNNGUCuDFHzt/M1qDhLscvTqoybb6GwD7pQHvLbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 238/253] vsock: Do not allow binding to VMADDR_PORT_ANY
Date: Tue, 12 Aug 2025 19:30:26 +0200
Message-ID: <20250812172958.964282391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,7 +686,8 @@ static int __vsock_bind_connectible(stru
 		unsigned int i;
 
 		for (i = 0; i < MAX_PORT_RETRIES; i++) {
-			if (port <= LAST_RESERVED_PORT)
+			if (port == VMADDR_PORT_ANY ||
+			    port <= LAST_RESERVED_PORT)
 				port = LAST_RESERVED_PORT + 1;
 
 			new_addr.svm_port = port++;


