Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4338932C92B;
	Fri, 17 Oct 2025 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713919; cv=none; b=JLntmJY8ClGhkwqsj9pmfXE8hJr8rm4/zJqtUigBNZZ/w1AGAyQso7N/PW2eA9BQzAm3zbAf7jKGrfo+wk4cf0CEmAsmBzN48EMH7Pq2LXrPF4MHmXiP/tZ7YL7br7J8oERXtX4nrc5s54ADBG/D2rzZzTykflWU3ShMsK6Qi4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713919; c=relaxed/simple;
	bh=6aTWQWd79dioWS1LrupDTL9F44ycQt+8IcC9G1gXvXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzXAKB7Yj/A8dZvzVaEyWff3O0lTvjhM3D1CnfIeoq8/+N58v7u6AVmvuJyGO9tOfaTs20PlHpywd6cbEzF+QYeKKMz5imaQbcH2aaQCxR//zD067KWKMjmdUzeWffTdoUPbAL7sGkZ4pvrUaa8AHOJq+ZAqE8iAIKee3b5j3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMVcacFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMVcacFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FA4C4CEE7;
	Fri, 17 Oct 2025 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713919;
	bh=6aTWQWd79dioWS1LrupDTL9F44ycQt+8IcC9G1gXvXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMVcacFSStExZ+FQlAGnty3Fik9r+VoGhHJUu4k+9G7gBLNQPIxF6KhTbfPJz/jIL
	 q+12ReLozwV97P0IsV70Jl8Kw6r69LsS7sV2U8njkRvaV2cTjHftrtVcW8ruo1fcGu
	 JMD3LI6/p/j3aiCF+T6LKDOOgexd/57161rkB+tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/201] ksmbd: add max ip connections parameter
Date: Fri, 17 Oct 2025 16:53:47 +0200
Message-ID: <20251017145140.835319880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit d8b6dc9256762293048bf122fc11c4e612d0ef5d ]

This parameter set the maximum number of connections per ip address.
The default is 8.

Cc: stable@vger.kernel.org
Fixes: c0d41112f1a5 ("ksmbd: extend the connection limiting mechanism to support IPv6")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Adjust reserved room ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/ksmbd_netlink.h |    5 +++--
 fs/smb/server/server.h        |    1 +
 fs/smb/server/transport_ipc.c |    3 +++
 fs/smb/server/transport_tcp.c |   28 +++++++++++++++++-----------
 4 files changed, 24 insertions(+), 13 deletions(-)

--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -108,10 +108,11 @@ struct ksmbd_startup_request {
 	__u32	smb2_max_credits;	/* MAX credits */
 	__u32	smbd_max_io_size;	/* smbd read write size */
 	__u32	max_connections;	/* Number of maximum simultaneous connections */
-	__u32	reserved[126];		/* Reserved room */
+	__u32	max_ip_connections;	/* Number of maximum connection per ip address */
+	__u32	reserved[125];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
-};
+} __packed;
 
 #define KSMBD_STARTUP_CONFIG_INTERFACES(s)	((s)->____payload)
 
--- a/fs/smb/server/server.h
+++ b/fs/smb/server/server.h
@@ -43,6 +43,7 @@ struct ksmbd_server_config {
 	unsigned int		auth_mechs;
 	unsigned int		max_connections;
 	unsigned int		max_inflight_req;
+	unsigned int		max_ip_connections;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 };
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -321,6 +321,9 @@ static int ipc_server_config_on_startup(
 	if (req->max_connections)
 		server_conf.max_connections = req->max_connections;
 
+	if (req->max_ip_connections)
+		server_conf.max_ip_connections = req->max_ip_connections;
+
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
 	ret |= ksmbd_set_work_group(req->work_group);
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -240,6 +240,7 @@ static int ksmbd_kthread_fn(void *p)
 	struct interface *iface = (struct interface *)p;
 	struct ksmbd_conn *conn;
 	int ret;
+	unsigned int max_ip_conns;
 
 	while (!kthread_should_stop()) {
 		mutex_lock(&iface->sock_release_lock);
@@ -257,34 +258,39 @@ static int ksmbd_kthread_fn(void *p)
 			continue;
 		}
 
+		if (!server_conf.max_ip_connections)
+			goto skip_max_ip_conns_limit;
+
 		/*
 		 * Limits repeated connections from clients with the same IP.
 		 */
+		max_ip_conns = 0;
 		down_read(&conn_list_lock);
-		list_for_each_entry(conn, &conn_list, conns_list)
+		list_for_each_entry(conn, &conn_list, conns_list) {
 #if IS_ENABLED(CONFIG_IPV6)
 			if (client_sk->sk->sk_family == AF_INET6) {
 				if (memcmp(&client_sk->sk->sk_v6_daddr,
-					   &conn->inet6_addr, 16) == 0) {
-					ret = -EAGAIN;
-					break;
-				}
+					   &conn->inet6_addr, 16) == 0)
+					max_ip_conns++;
 			} else if (inet_sk(client_sk->sk)->inet_daddr ==
-				 conn->inet_addr) {
-				ret = -EAGAIN;
-				break;
-			}
+				 conn->inet_addr)
+				max_ip_conns++;
 #else
 			if (inet_sk(client_sk->sk)->inet_daddr ==
-			    conn->inet_addr) {
+			    conn->inet_addr)
+				max_ip_conns++;
+#endif
+			if (server_conf.max_ip_connections <= max_ip_conns) {
 				ret = -EAGAIN;
 				break;
 			}
-#endif
+		}
 		up_read(&conn_list_lock);
 		if (ret == -EAGAIN)
 			continue;
 
+skip_max_ip_conns_limit:
+
 		if (server_conf.max_connections &&
 		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
 			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",


