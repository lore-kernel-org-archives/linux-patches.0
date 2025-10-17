Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045AB1D5CE0;
	Fri, 17 Oct 2025 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713372; cv=none; b=uGZ3JuSXVVHz/jkMzvO/0E77pnOYZ0gYC71lcqz3luej5RoFUyYh1m7n/NaPoyBZg7x9AvQv5XLye0XYqEDPkOLiIh20lDSDbOhqImv/B+vMEYwaMRfcyrxzfthwllnCtjoadPALRP0MRp4fxHPZFht40GpIvBVAVsw6WLVdID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713372; c=relaxed/simple;
	bh=XlDU8NBS2PLZ+jMOXn6+wi7/cUF0FDeVBv3FLa3H8CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoInbPJPV3bXf5BksT6x9TIgbF5fCOLJkuLfoNQLUn48zPNiemCrN2D/1nnT3dC1t8S4HIML0VTFSHI/MsSGB3zrmJnTyYTAWX65D1ttzfJrRRQG98yOGHjsE/F/LYTj0EPtxSaVPMZxlkf9o6qy+PKI6/e2+r8CHpm8k5BwUkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRVmm6W1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRVmm6W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB81C4CEE7;
	Fri, 17 Oct 2025 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713371;
	bh=XlDU8NBS2PLZ+jMOXn6+wi7/cUF0FDeVBv3FLa3H8CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRVmm6W1vcbokflM0M/YFH2l0qQxFblWNXnyRGCcfCDNAGUy4IshrQvK/2T7/1Dc3
	 6WsJQ1KP47YAlgU9pOWI874VjSu2xkEasjFsNXnBcj2TvA+vNYYmAUJ41uq2c6M3LY
	 E8fZ0rehGNukygfA+egdG5gfVuHK0f6UDLVETk0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/168] ksmbd: add max ip connections parameter
Date: Fri, 17 Oct 2025 16:53:42 +0200
Message-ID: <20251017145134.301185226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit d8b6dc9256762293048bf122fc11c4e612d0ef5d ]

This parameter set the maximum number of connections per ip address.
The default is 8.

Cc: stable@vger.kernel.org
Fixes: c0d41112f1a5 ("ksmbd: extend the connection limiting mechanism to support IPv6")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ adjust reserved room ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/ksmbd_netlink.h |    5 +++--
 fs/smb/server/server.h        |    1 +
 fs/smb/server/transport_ipc.c |    3 +++
 fs/smb/server/transport_tcp.c |   27 ++++++++++++++++-----------
 4 files changed, 23 insertions(+), 13 deletions(-)

--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -107,10 +107,11 @@ struct ksmbd_startup_request {
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
@@ -42,6 +42,7 @@ struct ksmbd_server_config {
 	struct smb_sid		domain_sid;
 	unsigned int		auth_mechs;
 	unsigned int		max_connections;
+	unsigned int		max_ip_connections;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 };
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -318,6 +318,9 @@ static int ipc_server_config_on_startup(
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
@@ -236,6 +236,7 @@ static int ksmbd_kthread_fn(void *p)
 	struct interface *iface = (struct interface *)p;
 	struct ksmbd_conn *conn;
 	int ret;
+	unsigned int max_ip_conns;
 
 	while (!kthread_should_stop()) {
 		mutex_lock(&iface->sock_release_lock);
@@ -253,34 +254,38 @@ static int ksmbd_kthread_fn(void *p)
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
 		if (server_conf.max_connections &&
 		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
 			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",


