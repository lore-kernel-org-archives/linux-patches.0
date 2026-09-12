Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDF9395AD8;
	Sat, 12 Sep 2026 19:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240285; cv=none; b=ZcMiyLiqaVaKcerJLgcCb+OhprRFhvxMGAZx8HqZlme8ub8T76TyRjRKUY+8OD2IexyvHUDG62RaPYevltu6ZansWQjR4O+Z3WyvDdtoIbtkn2Y2/UNbkEwTaJqbnyLbpDEhEqdXg7rZISal+nXKIpFhuXRLA2/fUgodJcxIlDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240285; c=relaxed/simple;
	bh=Kfuu03h9LcMYRGFohGjBXk42JS+5juJLykPPZB2FYtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpoygFPYfWA2SqXS1uAiiPSeDPwJUozniOAIXeM1ke7nOB1P3R6HMOXMQZDHml48TfJTpDC+L53kWoZQQvfBLeandBSSQRQF8oI8J07Anka8wrhG2hcEdo7Q6Tzf8jYJ4ofFpcpLTgXAu5A0Ol9J8V3flnNYtaico+k/tcCxHiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pjcf8QyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pjcf8QyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31F11F000FF;
	Sat, 12 Sep 2026 19:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240284;
	bh=BJURJbKl8Wid+cRB82flynUyp9wjZA24AoCyxqncLP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pjcf8QyE8wFLKYnsdSUVa6C2kxxOly4j8JU5F1wRtg5Vg+MuzXACYCqNtKnx0Xje5
	 paaXDwCD3mMfmsYco9kYd/djGi/Nzy9Vgs+lkp0lV1HjA8LJWKHoBJ0kF3w5T3KXfJ
	 bkX5j2z5JMwV2912AyBsD/ygdn7sbn74Ko84ofnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 837/935] ksmbd: extend the connection limiting mechanism to support IPv6
Date: Sat, 12 Sep 2026 09:04:27 +0200
Message-ID: <20260912065546.021718908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c0d41112f1a5828c194b59cca953114bc3776ef2 ]

Update the connection tracking logic to handle both IPv4 and IPv6
address families.

Cc: stable@vger.kernel.org
Fixes: e6bb91939740 ("ksmbd: limit repeated connections from clients with the same IP")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 39f203209671 ("smb/server: fix tree connection leak in smb2_tree_connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.h    |  7 ++++++-
 fs/ksmbd/transport_tcp.c | 26 +++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 9af95be54b22e..d01f137223b42 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
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
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 7d03a68819b36..029e9c6c80c36 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -88,7 +88,14 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
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
@@ -230,7 +237,6 @@ static int ksmbd_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
-	struct inet_sock *csk_inet;
 	struct ksmbd_conn *conn;
 	int ret;
 
@@ -253,13 +259,27 @@ static int ksmbd_kthread_fn(void *p)
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
+				ret = -EAGAIN;
+				break;
+			}
+#else
+			if (inet_sk(client_sk->sk)->inet_daddr ==
+			    conn->inet_addr) {
 				ret = -EAGAIN;
 				break;
 			}
+#endif
 		up_read(&conn_list_lock);
 		if (ret == -EAGAIN)
 			continue;
-- 
2.53.0



