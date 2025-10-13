Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1DB308F3C;
	Mon, 13 Oct 2025 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370260; cv=none; b=fUoABWmI0rKe8fik496OnaNpy8z5ytvSjMWKUX+wk5zS0fiMaESJqndtntVDvEnuld3CIgeN0xHPAeegtJr1kZJt6MubKya8GQwTJ0cZ2s1Fv3BlHtBTozA8sffhmhDb2J/AcdfRr8yt0Kh4aPxuFFjP9HfR6DJK3AkAXtFRufA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370260; c=relaxed/simple;
	bh=66kCY8GA45mi+58App3Hyp0JC7XTM0cHNyDB9VBl3ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnXPegzCb4KcWSW5W4fIx0S4GGarXVNEIEXnbQc+zp9aSp7C7z0YMaHLop7wGXV1aaGTXmlYEGLLNwprsNk7y+SW7hykTRJsenEECpNUy5XcJLDunTKmoQi9JUF/3PahyIE6AT2oq0b3/SsyaOaClvvI75P7B1xEPGRTj9e/1gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rveoY9DZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rveoY9DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF26C4CEE7;
	Mon, 13 Oct 2025 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370260;
	bh=66kCY8GA45mi+58App3Hyp0JC7XTM0cHNyDB9VBl3ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rveoY9DZG8KWK1Oou0W1YF+Gq+TkgvcNUmWWslO+p9wS1u77FU/oiOi3iWQB5s6GO
	 f9iwq2aGClg7EdNLIx4kTD0xdHz0kNBvTYSbhrxXxomWrrgZi7Siysr6IuWMUlafnf
	 XsrEcQ1TSump5L2lGK4tBAbDkAL2+IygK7v/ADTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 535/563] ksmbd: add max ip connections parameter
Date: Mon, 13 Oct 2025 16:46:36 +0200
Message-ID: <20251013144430.690839381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit d8b6dc9256762293048bf122fc11c4e612d0ef5d upstream.

This parameter set the maximum number of connections per ip address.
The default is 8.

Cc: stable@vger.kernel.org
Fixes: c0d41112f1a5 ("ksmbd: extend the connection limiting mechanism to support IPv6")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/ksmbd_netlink.h |    5 +++--
 fs/smb/server/server.h        |    1 +
 fs/smb/server/transport_ipc.c |    3 +++
 fs/smb/server/transport_tcp.c |   27 ++++++++++++++++-----------
 4 files changed, 23 insertions(+), 13 deletions(-)

--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -112,10 +112,11 @@ struct ksmbd_startup_request {
 	__u32	smbd_max_io_size;	/* smbd read write size */
 	__u32	max_connections;	/* Number of maximum simultaneous connections */
 	__s8	bind_interfaces_only;
-	__s8	reserved[503];		/* Reserved room */
+	__u32	max_ip_connections;	/* Number of maximum connection per ip address */
+	__s8	reserved[499];		/* Reserved room */
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
 	struct task_struct	*dh_task;
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -335,6 +335,9 @@ static int ipc_server_config_on_startup(
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
@@ -238,6 +238,7 @@ static int ksmbd_kthread_fn(void *p)
 	struct interface *iface = (struct interface *)p;
 	struct ksmbd_conn *conn;
 	int ret;
+	unsigned int max_ip_conns;
 
 	while (!kthread_should_stop()) {
 		mutex_lock(&iface->sock_release_lock);
@@ -255,34 +256,38 @@ static int ksmbd_kthread_fn(void *p)
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


