Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DF81ADFFE;
	Tue, 26 Aug 2025 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214817; cv=none; b=ocXvwagMpuLVQOw3GiPgCnhsEGtgqxNWajY/7jUyY173HVOa+DxMaXvS08YwhMb5wkjqlxia4sAKFTEX2g7yuOr473JzSt8rr6Xgkx7Fb7euQb474c/MWMytHl7LE8JkHIsu0xC1DLnewE0vg0U9ltAQkfK5X5UzeGWPUEmGq20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214817; c=relaxed/simple;
	bh=RllgTZIXbPPoBTtDOfwDthP3XrhHtj3c1OlKniJe+ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNA38wjyLWrwwSmKc7wKuj+LTmMpDR8o8pCvfnPL06L4HcBtpCkCJ4Hb5d9Xvraatab3gG2eXpuBT8xczuMCtSfZGpiD3+Iq2oSWUVWeGD8x20vOzK1KeE7xGMelqfEp62yAhrhqRDOw4twx6M1PxaHJkULi8WVzPiGFj2+hTAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enBTwOP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enBTwOP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAC2C4CEF1;
	Tue, 26 Aug 2025 13:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214816;
	bh=RllgTZIXbPPoBTtDOfwDthP3XrhHtj3c1OlKniJe+ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enBTwOP0Mk5cDnNV/CHeJV6BG2Lt2umKGEtUrRxjP4khAeJ7c2BfFhJln+fpNVmW8
	 voJ+cEEfVwXAgeSMBEfthL4ZQt7qCgABv3EOTLMNTCznONpvnZjGDZBC5FtvTAocxx
	 nm5HvjCcSNqZWUNodGy0vqSxf2TKVdp8XLUjCGxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 279/482] ksmbd: extend the connection limiting mechanism to support IPv6
Date: Tue, 26 Aug 2025 13:08:52 +0200
Message-ID: <20250826110937.674671975@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
@@ -227,7 +234,6 @@ static int ksmbd_kthread_fn(void *p)
 {
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
-	struct inet_sock *csk_inet;
 	struct ksmbd_conn *conn;
 	int ret;
 
@@ -250,13 +256,27 @@ static int ksmbd_kthread_fn(void *p)
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


