Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEAB14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVnN57Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C4C433C9;
	Mon, 23 Oct 2023 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059737;
	bh=mR5wNJgCT2aUH35qsk5XKO6/aoONaxoLEGBl5yPeMwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVnN57ZuyrI39PnegDQenpZRFh9ffQ1iCjeUTLXFH2Zm0hz2mHWzFLjPBN1x9jZeg
	 rMm+GKaedgcGkMzOTkCUCIk3rMR87SbvWyACfn439CbXeG5z5T+6P72CPdYbq8F0Vd
	 FbZSC2i9RgsrDIzotsxhTCoz5NGcRzhT0RRxoClk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jordan Rife <jrife@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 09/98] net: prevent address rewrite in kernel_bind()
Date: Mon, 23 Oct 2023 12:55:58 +0200
Message-ID: <20231023104813.906875007@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Rife <jrife@google.com>

commit c889a99a21bf124c3db08d09df919f0eccc5ea4c upstream.

Similar to the change in commit 0bdf399342c5("net: Avoid address
overwrite in kernel_connect"), BPF hooks run on bind may rewrite the
address passed to kernel_bind(). This change

1) Makes a copy of the bind address in kernel_bind() to insulate
   callers.
2) Replaces direct calls to sock->ops->bind() in net with kernel_bind()

Link: https://lore.kernel.org/netdev/20230912013332.2048422-1-jrife@google.com/
Fixes: 4fbac77d2d09 ("bpf: Hooks for sys_bind")
Cc: stable@vger.kernel.org
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jordan Rife <jrife@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_sync.c |    4 ++--
 net/rds/tcp_connect.c           |    2 +-
 net/rds/tcp_listen.c            |    2 +-
 net/socket.c                    |    6 +++++-
 4 files changed, 9 insertions(+), 5 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1444,7 +1444,7 @@ static int bind_mcastif_addr(struct sock
 	sin.sin_addr.s_addr  = addr;
 	sin.sin_port         = 0;
 
-	return sock->ops->bind(sock, (struct sockaddr*)&sin, sizeof(sin));
+	return kernel_bind(sock, (struct sockaddr *)&sin, sizeof(sin));
 }
 
 static void get_mcast_sockaddr(union ipvs_sockaddr *sa, int *salen,
@@ -1551,7 +1551,7 @@ static int make_receive_sock(struct netn
 
 	get_mcast_sockaddr(&mcast_addr, &salen, &ipvs->bcfg, id);
 	sock->sk->sk_bound_dev_if = dev->ifindex;
-	result = sock->ops->bind(sock, (struct sockaddr *)&mcast_addr, salen);
+	result = kernel_bind(sock, (struct sockaddr *)&mcast_addr, salen);
 	if (result < 0) {
 		pr_err("Error binding to the multicast addr\n");
 		goto error;
--- a/net/rds/tcp_connect.c
+++ b/net/rds/tcp_connect.c
@@ -141,7 +141,7 @@ int rds_tcp_conn_path_connect(struct rds
 		addrlen = sizeof(sin);
 	}
 
-	ret = sock->ops->bind(sock, addr, addrlen);
+	ret = kernel_bind(sock, addr, addrlen);
 	if (ret) {
 		rdsdebug("bind failed with %d at address %pI6c\n",
 			 ret, &conn->c_laddr);
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -332,7 +332,7 @@ struct socket *rds_tcp_listen_init(struc
 		addr_len = sizeof(*sin);
 	}
 
-	ret = sock->ops->bind(sock, (struct sockaddr *)&ss, addr_len);
+	ret = kernel_bind(sock, (struct sockaddr *)&ss, addr_len);
 	if (ret < 0) {
 		rdsdebug("could not bind %s listener socket: %d\n",
 			 isv6 ? "IPv6" : "IPv4", ret);
--- a/net/socket.c
+++ b/net/socket.c
@@ -3427,7 +3427,11 @@ static long compat_sock_ioctl(struct fil
 
 int kernel_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 {
-	return sock->ops->bind(sock, addr, addrlen);
+	struct sockaddr_storage address;
+
+	memcpy(&address, addr, addrlen);
+
+	return sock->ops->bind(sock, (struct sockaddr *)&address, addrlen);
 }
 EXPORT_SYMBOL(kernel_bind);
 


