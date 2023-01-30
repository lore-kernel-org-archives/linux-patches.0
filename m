Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6217C28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8593C433D2;
	Mon, 30 Jan 2023 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087460;
	bh=M2iVxVjjRJlpNjPZWgAqDm81DU7ZJe6FFbF92Hwt9P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6aTwIk/z0cI21gbi1vUl0hl+g4BeZ+co96I9eUK/JaOTXzhuRq8FCCzDS2THNMyj
	 2sLOpbPCOA1lz3ZytSjh6N+B3V/3Pb3xAO3cI2iBwGMUn5yDXscRvlww8oh0UHuseE
	 QYfLk6BkRh3aJv/oKOMBd9UHxHda9We+Es8rw8wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 216/313] ksmbd: add max connections parameter
Date: Mon, 30 Jan 2023 14:50:51 +0100
Message-Id: <20230130134346.764594957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 0d0d4680db22eda1eea785c47bbf66a9b33a8b16 upstream.

Add max connections parameter to limit number of maximum simultaneous
connections.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ksmbd_netlink.h |    3 ++-
 fs/ksmbd/server.h        |    1 +
 fs/ksmbd/transport_ipc.c |    3 +++
 fs/ksmbd/transport_tcp.c |   17 ++++++++++++++++-
 4 files changed, 22 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -105,7 +105,8 @@ struct ksmbd_startup_request {
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
 	__u32	smb2_max_credits;	/* MAX credits */
 	__u32	smbd_max_io_size;	/* smbd read write size */
-	__u32	reserved[127];		/* Reserved room */
+	__u32	max_connections;	/* Number of maximum simultaneous connections */
+	__u32	reserved[126];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
--- a/fs/ksmbd/server.h
+++ b/fs/ksmbd/server.h
@@ -41,6 +41,7 @@ struct ksmbd_server_config {
 	unsigned int		share_fake_fscaps;
 	struct smb_sid		domain_sid;
 	unsigned int		auth_mechs;
+	unsigned int		max_connections;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 };
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -308,6 +308,9 @@ static int ipc_server_config_on_startup(
 	if (req->smbd_max_io_size)
 		init_smbd_max_io_size(req->smbd_max_io_size);
 
+	if (req->max_connections)
+		server_conf.max_connections = req->max_connections;
+
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
 	ret |= ksmbd_set_work_group(req->work_group);
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -15,6 +15,8 @@
 #define IFACE_STATE_DOWN		BIT(0)
 #define IFACE_STATE_CONFIGURED		BIT(1)
 
+static atomic_t active_num_conn;
+
 struct interface {
 	struct task_struct	*ksmbd_kthread;
 	struct socket		*ksmbd_socket;
@@ -185,8 +187,10 @@ static int ksmbd_tcp_new_connection(stru
 	struct tcp_transport *t;
 
 	t = alloc_transport(client_sk);
-	if (!t)
+	if (!t) {
+		sock_release(client_sk);
 		return -ENOMEM;
+	}
 
 	csin = KSMBD_TCP_PEER_SOCKADDR(KSMBD_TRANS(t)->conn);
 	if (kernel_getpeername(client_sk, csin) < 0) {
@@ -239,6 +243,15 @@ static int ksmbd_kthread_fn(void *p)
 			continue;
 		}
 
+		if (server_conf.max_connections &&
+		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
+			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
+					    atomic_read(&active_num_conn));
+			atomic_dec(&active_num_conn);
+			sock_release(client_sk);
+			continue;
+		}
+
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
@@ -368,6 +381,8 @@ static int ksmbd_tcp_writev(struct ksmbd
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 {
 	free_transport(TCP_TRANS(t));
+	if (server_conf.max_connections)
+		atomic_dec(&active_num_conn);
 }
 
 static void tcp_destroy_socket(struct socket *ksmbd_socket)


