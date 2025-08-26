Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E32E23A9AE;
	Tue, 26 Aug 2025 13:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213430; cv=none; b=UOIfqqmWTZTMx5jJqY7ru9B//ySD1j6NCEZKJISJPITy3k963xqZTQk/uCyEScRpWG0rkzyZtBZsmtyWXua3nNrn+tJVFj/ah2p6CXUs1UieAhpN5z1RH3fo2QXr7E/JwGgA44Ld24Ifc3QvceldNS8NqhxI+ILUHO24ffZ6peU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213430; c=relaxed/simple;
	bh=CrJCv5fa2BfyVF58DNo0yXYig4y6lXCjLMKQA0KA5dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gtgo1BXLE/1XmrqmbEFgNDjkDN96qXgboobhaDiF5HrjVR1IGYHmekba+YHpSZYtX6Zhgc0zj+wYCQXmk8ShApshpMpuUoUHpF/Ib/hSeiaUm97iN6Vd5Z+ko4jvilFj/H+F4NFqHmXA26YcMteWAO3eMm34a0imrx7ysLRiiAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV5QJTrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV5QJTrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E459AC113CF;
	Tue, 26 Aug 2025 13:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213430;
	bh=CrJCv5fa2BfyVF58DNo0yXYig4y6lXCjLMKQA0KA5dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV5QJTrkDZmDF4i5F/eXzvVtM1h5kYZHET2UGLieT1pQ19HmUKqgJKT9hhJWBkZUu
	 Ma0eJn7UjvzBrojm93sVRJG4jMBmN9UidRFZ8qhO3R7wX0SyiytPeFbtEiqvvubw6U
	 IYg3RAD3o8GVKgb9kUoO3rXJuHx5pw0dYCXdSJQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 346/587] ksmbd: extend the connection limiting mechanism to support IPv6
Date: Tue, 26 Aug 2025 13:08:15 +0200
Message-ID: <20250826111001.716503892@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit c0d41112f1a5828c194b59cca953114bc3776ef2 upstream.

Update the connection tracking logic to handle both IPv4 and IPv6
address families.

Cc: stable@vger.kernel.org
Fixes: e6bb91939740 ("ksmbd: limit repeated connections from clients with the same IP")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.h    |    7 ++++++-
 fs/smb/server/transport_tcp.c |   26 +++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)

--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -45,7 +45,12 @@ struct ksmbd_conn {
 	struct mutex			srv_mutex;
 	int				status;
 	unsigned int			cli_cap;
-	__be32				inet_addr;
+	union {
+		__be32			inet_addr;
+#if IS_ENABLED(CONFIG_IPV6)
+		u8			inet6_addr[16];
+#endif
+	};
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
 	struct nls_table		*local_nls;
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -87,7 +87,14 @@ static struct tcp_transport *alloc_trans
 		return NULL;
 	}
 
+#if IS_ENABLED(CONFIG_IPV6)
+	if (client_sk->sk->sk_family == AF_INET6)
+		memcpy(&conn->inet6_addr, &client_sk->sk->sk_v6_daddr, 16);
+	else
+		conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
+#else
 	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
+#endif
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
@@ -231,7 +238,6 @@ static int ksmbd_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
-	struct inet_sock *csk_inet;
 	struct ksmbd_conn *conn;
 	int ret;
 
@@ -254,13 +260,27 @@ static int ksmbd_kthread_fn(void *p)
 		/*
 		 * Limits repeated connections from clients with the same IP.
 		 */
-		csk_inet = inet_sk(client_sk->sk);
 		down_read(&conn_list_lock);
 		list_for_each_entry(conn, &conn_list, conns_list)
-			if (csk_inet->inet_daddr == conn->inet_addr) {
+#if IS_ENABLED(CONFIG_IPV6)
+			if (client_sk->sk->sk_family == AF_INET6) {
+				if (memcmp(&client_sk->sk->sk_v6_daddr,
+					   &conn->inet6_addr, 16) == 0) {
+					ret = -EAGAIN;
+					break;
+				}
+			} else if (inet_sk(client_sk->sk)->inet_daddr ==
+				 conn->inet_addr) {
 				ret = -EAGAIN;
 				break;
 			}
+#else
+			if (inet_sk(client_sk->sk)->inet_daddr ==
+			    conn->inet_addr) {
+				ret = -EAGAIN;
+				break;
+			}
+#endif
 		up_read(&conn_list_lock);
 		if (ret == -EAGAIN)
 			continue;


