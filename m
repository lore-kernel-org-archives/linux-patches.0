Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D13B7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB697C433CA;
	Sun, 17 Sep 2023 20:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981421;
	bh=YGFx+3RPt45e91Kkgf2hRSz22toku8q2AVKcb6Mjh1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggiQnMkn9xg96QJuYo+4DAgnRZnoKkYPBqbbCj1vS7DJNCZOtwWRJP4J3aHjSzx7Z
	 GB6oEkv8mVEugNomoRROfs7Vgy/YWRTU/VTMa7tvmk8wb48xsYbpso1y0gYD9lZ1h+
	 ecONpcvLDZUzZU1s1/5oywVX/hlQPUCYY9UeqZ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jrife@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 051/511] net: Avoid address overwrite in kernel_connect
Date: Sun, 17 Sep 2023 21:07:58 +0200
Message-ID: <20230917191115.110073662@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jordan Rife <jrife@google.com>

commit 0bdf399342c5acbd817c9098b6c7ed21f1974312 upstream.

BPF programs that run on connect can rewrite the connect address. For
the connect system call this isn't a problem, because a copy of the address
is made when it is moved into kernel space. However, kernel_connect
simply passes through the address it is given, so the caller may observe
its address value unexpectedly change.

A practical example where this is problematic is where NFS is combined
with a system such as Cilium which implements BPF-based load balancing.
A common pattern in software-defined storage systems is to have an NFS
mount that connects to a persistent virtual IP which in turn maps to an
ephemeral server IP. This is usually done to achieve high availability:
if your server goes down you can quickly spin up a replacement and remap
the virtual IP to that endpoint. With BPF-based load balancing, mounts
will forget the virtual IP address when the address rewrite occurs
because a pointer to the only copy of that address is passed down the
stack. Server failover then breaks, because clients have forgotten the
virtual IP address. Reconnects fail and mounts remain broken. This patch
was tested by setting up a scenario like this and ensuring that NFS
reconnects worked after applying the patch.

Signed-off-by: Jordan Rife <jrife@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -3453,7 +3453,11 @@ EXPORT_SYMBOL(kernel_accept);
 int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags)
 {
-	return sock->ops->connect(sock, addr, addrlen, flags);
+	struct sockaddr_storage address;
+
+	memcpy(&address, addr, addrlen);
+
+	return sock->ops->connect(sock, (struct sockaddr *)&address, addrlen, flags);
 }
 EXPORT_SYMBOL(kernel_connect);
 


