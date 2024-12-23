Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695971B2EEB;
	Mon, 23 Dec 2024 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970331; cv=none; b=YM67mHu3TL9fZw5nfg00974HD1itaHsfJP+fq15RdX4BQ0dHVnxUy7psPZQAntLdji8wc6yVd0vAEIqJWKor4VgnovW8TbeJnZR+9IFMVa8vp0kxVv/ooqITKnNlrW8nzEcroaNGo16fRKshxbLZGauT7Nxipx6Ht0eqfEjqDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970331; c=relaxed/simple;
	bh=47L0W/176HgYsc4ZuhiDfqZc0lO260ofMiQ2tcxTd9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJE8yW6Ql5F4KvnXEgL6gUHCSWPB0+Tpzji5l9ClkbWQwlKX8HlQp8H/mkIOZmiHPyUIhZFzWL2grYRNrCIVzEliB9QctAtnebD4GNoxiNAP84mBEZHXLYWFC37OwJ/feMSrBmZaQobhUKgNZjvQwzreIONbRAF8X8a9dlQHPM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvE8t0E2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvE8t0E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B97C4CED6;
	Mon, 23 Dec 2024 16:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970331;
	bh=47L0W/176HgYsc4ZuhiDfqZc0lO260ofMiQ2tcxTd9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvE8t0E2EMvs8YDkVHMT3PrZws+Pdu9xCIfzIhh/VQXuHoumSknt8z2tOTbvo7Llp
	 D5cMVNcWEQmzgksaS5gpRN61L3qCzieFHxai2ARc2uoCYLSOAse5FDBkAv1b5udeBb
	 5SHO4hlItbwnoEg8jDggpFvC7c16WwJ8GN2XZ5h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/116] ksmbd: fix broken transfers when exceeding max simultaneous operations
Date: Mon, 23 Dec 2024 16:58:41 +0100
Message-ID: <20241223155401.541917044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 43fb7bce8866e793275c4f9f25af6a37745f3416 ]

Since commit 0a77d947f599 ("ksmbd: check outstanding simultaneous SMB
operations"), ksmbd enforces a maximum number of simultaneous operations
for a connection. The problem is that reaching the limit causes ksmbd to
close the socket, and the client has no indication that it should have
slowed down.

This behaviour can be reproduced by setting "smb2 max credits = 128" (or
lower), and transferring a large file (25GB).

smbclient fails as below:

  $ smbclient //192.168.1.254/testshare -U user%pass
  smb: \> put file.bin
  cli_push returned NT_STATUS_USER_SESSION_DELETED
  putting file file.bin as \file.bin smb2cli_req_compound_submit:
  Insufficient credits. 0 available, 1 needed
  NT_STATUS_INTERNAL_ERROR closing remote file \file.bin
  smb: \> smb2cli_req_compound_submit: Insufficient credits. 0 available,
  1 needed

Windows clients fail with 0x8007003b (with smaller files even).

Fix this by delaying reading from the socket until there's room to
allocate a request. This effectively applies backpressure on the client,
so the transfer completes, albeit at a slower rate.

Fixes: 0a77d947f599 ("ksmbd: check outstanding simultaneous SMB operations")
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c    | 13 +++++++++++--
 fs/smb/server/connection.h    |  1 -
 fs/smb/server/server.c        |  7 +------
 fs/smb/server/server.h        |  1 +
 fs/smb/server/transport_ipc.c |  5 ++++-
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 5ded9372b2fb..f3178570329a 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -70,7 +70,6 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	atomic_set(&conn->refcnt, 1);
-	atomic_set(&conn->mux_smb_requests, 0);
 	conn->total_credits = 1;
 	conn->outstanding_credits = 0;
 
@@ -133,6 +132,8 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 
 	atomic_dec(&conn->req_running);
+	if (waitqueue_active(&conn->req_running_q))
+		wake_up(&conn->req_running_q);
 
 	if (list_empty(&work->request_entry) &&
 	    list_empty(&work->async_request_entry))
@@ -309,7 +310,7 @@ int ksmbd_conn_handler_loop(void *p)
 {
 	struct ksmbd_conn *conn = (struct ksmbd_conn *)p;
 	struct ksmbd_transport *t = conn->transport;
-	unsigned int pdu_size, max_allowed_pdu_size;
+	unsigned int pdu_size, max_allowed_pdu_size, max_req;
 	char hdr_buf[4] = {0,};
 	int size;
 
@@ -319,6 +320,7 @@ int ksmbd_conn_handler_loop(void *p)
 	if (t->ops->prepare && t->ops->prepare(t))
 		goto out;
 
+	max_req = server_conf.max_inflight_req;
 	conn->last_active = jiffies;
 	set_freezable();
 	while (ksmbd_conn_alive(conn)) {
@@ -328,6 +330,13 @@ int ksmbd_conn_handler_loop(void *p)
 		kvfree(conn->request_buf);
 		conn->request_buf = NULL;
 
+recheck:
+		if (atomic_read(&conn->req_running) + 1 > max_req) {
+			wait_event_interruptible(conn->req_running_q,
+				atomic_read(&conn->req_running) < max_req);
+			goto recheck;
+		}
+
 		size = t->ops->read(t, hdr_buf, sizeof(hdr_buf), -1);
 		if (size != sizeof(hdr_buf))
 			break;
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 368295fb18a7..82343afc8d04 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -107,7 +107,6 @@ struct ksmbd_conn {
 	__le16				signing_algorithm;
 	bool				binding;
 	atomic_t			refcnt;
-	atomic_t			mux_smb_requests;
 };
 
 struct ksmbd_conn_ops {
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 7f9aca4aa742..71e1c1db9dea 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -270,7 +270,6 @@ static void handle_ksmbd_work(struct work_struct *wk)
 
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->mux_smb_requests);
 	/*
 	 * Checking waitqueue to dropping pending requests on
 	 * disconnection. waitqueue_active is safe because it
@@ -300,11 +299,6 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	if (err)
 		return 0;
 
-	if (atomic_inc_return(&conn->mux_smb_requests) >= conn->vals->max_credits) {
-		atomic_dec_return(&conn->mux_smb_requests);
-		return -ENOSPC;
-	}
-
 	work = ksmbd_alloc_work_struct();
 	if (!work) {
 		pr_err("allocation for work failed\n");
@@ -367,6 +361,7 @@ static int server_conf_init(void)
 	server_conf.auth_mechs |= KSMBD_AUTH_KRB5 |
 				KSMBD_AUTH_MSKRB5;
 #endif
+	server_conf.max_inflight_req = SMB2_MAX_CREDITS;
 	return 0;
 }
 
diff --git a/fs/smb/server/server.h b/fs/smb/server/server.h
index db7278181760..4d06f2eb0d6a 100644
--- a/fs/smb/server/server.h
+++ b/fs/smb/server/server.h
@@ -42,6 +42,7 @@ struct ksmbd_server_config {
 	struct smb_sid		domain_sid;
 	unsigned int		auth_mechs;
 	unsigned int		max_connections;
+	unsigned int		max_inflight_req;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 };
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 8752ac82c557..c12b70d01880 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -305,8 +305,11 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 		init_smb2_max_write_size(req->smb2_max_write);
 	if (req->smb2_max_trans)
 		init_smb2_max_trans_size(req->smb2_max_trans);
-	if (req->smb2_max_credits)
+	if (req->smb2_max_credits) {
 		init_smb2_max_credits(req->smb2_max_credits);
+		server_conf.max_inflight_req =
+			req->smb2_max_credits;
+	}
 	if (req->smbd_max_io_size)
 		init_smbd_max_io_size(req->smbd_max_io_size);
 
-- 
2.39.5



