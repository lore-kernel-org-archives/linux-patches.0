Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7228434E774;
	Sat, 12 Sep 2026 15:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225730; cv=none; b=Vu66PBqSCaqazHJBhvFn5ex2LWiyjNmDJpwjadMAt4aPmPxhohRAnLUOhGylEBD13AOEqwAjPL5SgBRP7wGn30XLhaI6l06tShV1in/j/+oRnswpA6CoWYt4IXmL0WQ2Puj6zFq59zwV9Rn6vQjh9vVK2wp9lvN1oriB5m34gcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225730; c=relaxed/simple;
	bh=k/gZC63uwahlPRoX6JNPhXv6Wd3RLB3xyJhbfIDysag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/1PsHniq/KvCYBuqG7KilprATyoCBHj77dTIx2us81nLg6GZEI0VVYMR8/yYbiI/iMWNsX4okrgHN3YjGkdTKNs6InuQQXrB7yRcLQ+EQVEPTiJ5Pl+S9XN7y/F2LCl+0U4YQlYUOCnorG3+oxNiO2cUR/HSAnys9q1ZDhj600=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZCSQqmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZCSQqmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E237E1F00893;
	Sat, 12 Sep 2026 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225729;
	bh=K5dgJ4vwBFPUSos+viGHV7H8yiL+9vtDlhTjfa/Mvbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZCSQqmKz2B750x7u3gtbzImeqNnZphyGpddSRotvk9FUFUGvVPjZ26bnga4eiwyu
	 nEbAwNEPBTihn5I8QjkUqg30VFNm5vpE8Mh3xMhuLC00HwAfArAh7eeeKLGvsTdok2
	 1EWD3hQyy0XS3bdvGlJqtpUr2yxLNnvbIsBAedk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1256/1424] ksmbd: disconnect on SMB3 decryption failure
Date: Sat, 12 Sep 2026 09:01:28 +0200
Message-ID: <20260912065635.408908217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

[ Upstream commit 12a6680ce59bcd431730c9f049caddb017964c64 ]

MS-SMB2 requires the server to disconnect a connection when an
encrypted transform cannot be associated with a session or fails
authenticated decryption. This includes an encrypted request that
still carries a SessionId invalidated through PreviousSessionId.

Move the connection to EXITING and shut down its transport when
decrypt_req() fails. Add the missing TCP shutdown callback so a receive
blocked in kernel_recvmsg() is released; SMB Direct already provides
the corresponding callback.

Plaintext requests using an invalidated SessionId do not take this
path and continue to receive STATUS_USER_SESSION_DELETED.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c    | 16 ++++++++++++++++
 fs/smb/server/connection.h    |  1 +
 fs/smb/server/server.c        |  4 +++-
 fs/smb/server/transport_tcp.c |  6 ++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 672c7f56546c3..8edae6eada3d1 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -255,6 +255,22 @@ void ksmbd_all_conn_set_status(u64 sess_id, u32 status)
 	up_read(&conn_list_lock);
 }
 
+void ksmbd_conn_abort(struct ksmbd_conn *conn)
+{
+	bool shutdown = false;
+
+	spin_lock(&conn->request_lock);
+	if (!ksmbd_conn_exiting(conn) && !ksmbd_conn_releasing(conn)) {
+		ksmbd_conn_set_exiting(conn);
+		shutdown = true;
+	}
+	spin_unlock(&conn->request_lock);
+	wake_up_all(&conn->req_running_q);
+
+	if (shutdown && conn->transport->ops->shutdown)
+		conn->transport->ops->shutdown(conn->transport);
+}
+
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn)
 {
 	wait_event(conn->req_running_q, atomic_read(&conn->req_running) < 2);
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index e277c224ef34c..01b9020146a41 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -165,6 +165,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
 void ksmbd_conn_put(struct ksmbd_conn *conn);
+void ksmbd_conn_abort(struct ksmbd_conn *conn);
 int ksmbd_conn_wq_init(void);
 void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 21869bcd7f2cd..247595d8cb90b 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -170,8 +170,10 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	if (conn->ops->is_transform_hdr &&
 	    conn->ops->is_transform_hdr(work->request_buf)) {
 		rc = conn->ops->decrypt_req(work);
-		if (rc < 0)
+		if (rc < 0) {
+			ksmbd_conn_abort(conn);
 			return;
+		}
 		work->encrypted = true;
 	}
 
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index b3a1df597d50c..faf6f7a34a2be 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -468,6 +468,11 @@ static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 		atomic_dec(&active_num_conn);
 }
 
+static void ksmbd_tcp_shutdown(struct ksmbd_transport *t)
+{
+	kernel_sock_shutdown(TCP_TRANS(t)->sock, SHUT_RDWR);
+}
+
 static void tcp_destroy_socket(struct socket *ksmbd_socket)
 {
 	int ret;
@@ -721,5 +726,6 @@ static struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.shutdown	= ksmbd_tcp_shutdown,
 	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.53.0



