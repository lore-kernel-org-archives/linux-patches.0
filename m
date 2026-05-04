Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3353E4C6C;
	Mon,  4 May 2026 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904881; cv=none; b=tM+hUfUW62fjDTKkeCre9MmV2/YZEmwC2DZI8yXBV3YHM2vSo6mBIGOSCH/c7HOUa0K3r4sC/2iz1cDqn9tOk7OMXCuBX1uBWDhca1g8dYBVtlPinXasdfLusQ0ys9a6SIgRo4Gbp1W7RE/JVRXcpbTIha+dt+/ZT11bMBNZhmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904881; c=relaxed/simple;
	bh=GK34AlDGlmYByAPk/aIxAFjVQbUsfw2LjRhEQeylCBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqQmwtkoSLoSNEQKcxVxTR6GhGq+YH2Gi8ErC2JQbUIr+m4twUete6O42nMZjxHuOBvRWNuod3lQYo+WYn3a9zHuf6/hjJJaxcaiZ9R3YJy/THlSex15OG93NJnrIf086ZJw876N18mW6cjsZ8UAEZRK6cmeZKpZewQXNnTwvMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XzTcBG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XzTcBG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25135C2BCB8;
	Mon,  4 May 2026 14:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904881;
	bh=GK34AlDGlmYByAPk/aIxAFjVQbUsfw2LjRhEQeylCBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XzTcBG7phxzg4a91MLkf+nwDKxqxgEDFFeA6QPvX+SRfc6vS5Puk9XerPqqLL8DR
	 J4koAxeIuEo+5o9KHG3sI2CcdIWVi6KqZa4EaUpVHsep7zy6m5yMamKMg/MAUg8HjG
	 VCoGjh/o3RSPpjLuxEQXrXm9GRsq9404vCOD7AvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/215] ksmbd: replace connection list with hash table
Date: Mon,  4 May 2026 15:53:17 +0200
Message-ID: <20260504135136.709368878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 0bcc831be535269556f59cb70396f7e34f03a276 ]

Replace connection list with hash table to improve lookup performance.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: def036ef87f8 ("ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c     |   23 +++++++++++------------
 fs/smb/server/connection.h     |    6 ++++--
 fs/smb/server/smb2pdu.c        |    4 ++--
 fs/smb/server/transport_rdma.c |    5 +++++
 fs/smb/server/transport_tcp.c  |   25 +++++++++++++++++++++----
 5 files changed, 43 insertions(+), 20 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -19,7 +19,7 @@ static DEFINE_MUTEX(init_lock);
 
 static struct ksmbd_conn_ops default_conn_ops;
 
-LIST_HEAD(conn_list);
+DEFINE_HASHTABLE(conn_list, CONN_HASH_BITS);
 DECLARE_RWSEM(conn_list_lock);
 
 /**
@@ -33,7 +33,7 @@ DECLARE_RWSEM(conn_list_lock);
 void ksmbd_conn_free(struct ksmbd_conn *conn)
 {
 	down_write(&conn_list_lock);
-	list_del(&conn->conns_list);
+	hash_del(&conn->hlist);
 	up_write(&conn_list_lock);
 
 	xa_destroy(&conn->sessions);
@@ -78,7 +78,6 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 
 	init_waitqueue_head(&conn->req_running_q);
 	init_waitqueue_head(&conn->r_count_q);
-	INIT_LIST_HEAD(&conn->conns_list);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
 	spin_lock_init(&conn->request_lock);
@@ -91,19 +90,17 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 
 	init_rwsem(&conn->session_lock);
 
-	down_write(&conn_list_lock);
-	list_add(&conn->conns_list, &conn_list);
-	up_write(&conn_list_lock);
 	return conn;
 }
 
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c)
 {
 	struct ksmbd_conn *t;
+	int bkt;
 	bool ret = false;
 
 	down_read(&conn_list_lock);
-	list_for_each_entry(t, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, t, hlist) {
 		if (memcmp(t->ClientGUID, c->ClientGUID, SMB2_CLIENT_GUID_SIZE))
 			continue;
 
@@ -164,9 +161,10 @@ void ksmbd_conn_unlock(struct ksmbd_conn
 void ksmbd_all_conn_set_status(u64 sess_id, u32 status)
 {
 	struct ksmbd_conn *conn;
+	int bkt;
 
 	down_read(&conn_list_lock);
-	list_for_each_entry(conn, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, conn, hlist) {
 		if (conn->binding || xa_load(&conn->sessions, sess_id))
 			WRITE_ONCE(conn->status, status);
 	}
@@ -182,14 +180,14 @@ int ksmbd_conn_wait_idle_sess_id(struct
 {
 	struct ksmbd_conn *conn;
 	int rc, retry_count = 0, max_timeout = 120;
-	int rcount = 1;
+	int rcount = 1, bkt;
 
 retry_idle:
 	if (retry_count >= max_timeout)
 		return -EIO;
 
 	down_read(&conn_list_lock);
-	list_for_each_entry(conn, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, conn, hlist) {
 		if (conn->binding || xa_load(&conn->sessions, sess_id)) {
 			if (conn == curr_conn)
 				rcount = 2;
@@ -480,10 +478,11 @@ static void stop_sessions(void)
 {
 	struct ksmbd_conn *conn;
 	struct ksmbd_transport *t;
+	int bkt;
 
 again:
 	down_read(&conn_list_lock);
-	list_for_each_entry(conn, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, conn, hlist) {
 		t = conn->transport;
 		ksmbd_conn_set_exiting(conn);
 		if (t->ops->shutdown) {
@@ -494,7 +493,7 @@ again:
 	}
 	up_read(&conn_list_lock);
 
-	if (!list_empty(&conn_list)) {
+	if (!hash_empty(conn_list)) {
 		msleep(100);
 		goto again;
 	}
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -52,11 +52,12 @@ struct ksmbd_conn {
 		u8			inet6_addr[16];
 #endif
 	};
+	unsigned int			inet_hash;
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
 	struct nls_table		*local_nls;
 	struct unicode_map		*um;
-	struct list_head		conns_list;
+	struct hlist_node		hlist;
 	struct rw_semaphore		session_lock;
 	/* smb session 1 per user */
 	struct xarray			sessions;
@@ -151,7 +152,8 @@ struct ksmbd_transport {
 #define KSMBD_TCP_SEND_TIMEOUT	(5 * HZ)
 #define KSMBD_TCP_PEER_SOCKADDR(c)	((struct sockaddr *)&((c)->peer_addr))
 
-extern struct list_head conn_list;
+#define CONN_HASH_BITS	12
+extern DECLARE_HASHTABLE(conn_list, CONN_HASH_BITS);
 extern struct rw_semaphore conn_list_lock;
 
 bool ksmbd_conn_alive(struct ksmbd_conn *conn);
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7427,7 +7427,7 @@ int smb2_lock(struct ksmbd_work *work)
 	int nolock = 0;
 	LIST_HEAD(lock_list);
 	LIST_HEAD(rollback_list);
-	int prior_lock = 0;
+	int prior_lock = 0, bkt;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -7537,7 +7537,7 @@ int smb2_lock(struct ksmbd_work *work)
 		nolock = 1;
 		/* check locks in connection list */
 		down_read(&conn_list_lock);
-		list_for_each_entry(conn, &conn_list, conns_list) {
+		hash_for_each(conn_list, bkt, conn, hlist) {
 			spin_lock(&conn->llist_lock);
 			list_for_each_entry_safe(cmp_lock, tmp2, &conn->lock_list, clist) {
 				if (file_inode(cmp_lock->fl->c.flc_file) !=
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -381,6 +381,11 @@ static struct smb_direct_transport *allo
 	conn = ksmbd_conn_alloc();
 	if (!conn)
 		goto err;
+
+	down_write(&conn_list_lock);
+	hash_add(conn_list, &conn->hlist, 0);
+	up_write(&conn_list_lock);
+
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_smb_direct_transport_ops;
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -89,13 +89,21 @@ static struct tcp_transport *alloc_trans
 	}
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (client_sk->sk->sk_family == AF_INET6)
+	if (client_sk->sk->sk_family == AF_INET6) {
 		memcpy(&conn->inet6_addr, &client_sk->sk->sk_v6_daddr, 16);
-	else
+		conn->inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+	} else {
 		conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
+		conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+	}
 #else
 	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
+	conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
 #endif
+	down_write(&conn_list_lock);
+	hash_add(conn_list, &conn->hlist, conn->inet_hash);
+	up_write(&conn_list_lock);
+
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
@@ -242,7 +250,7 @@ static int ksmbd_kthread_fn(void *p)
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
 	struct ksmbd_conn *conn;
-	int ret;
+	int ret, inet_hash;
 	unsigned int max_ip_conns;
 
 	while (!kthread_should_stop()) {
@@ -267,9 +275,18 @@ static int ksmbd_kthread_fn(void *p)
 		/*
 		 * Limits repeated connections from clients with the same IP.
 		 */
+#if IS_ENABLED(CONFIG_IPV6)
+		if (client_sk->sk->sk_family == AF_INET6)
+			inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+		else
+			inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+#else
+		inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+#endif
+
 		max_ip_conns = 0;
 		down_read(&conn_list_lock);
-		list_for_each_entry(conn, &conn_list, conns_list) {
+		hash_for_each_possible(conn_list, conn, hlist, inet_hash) {
 #if IS_ENABLED(CONFIG_IPV6)
 			if (client_sk->sk->sk_family == AF_INET6) {
 				if (memcmp(&client_sk->sk->sk_v6_daddr,


