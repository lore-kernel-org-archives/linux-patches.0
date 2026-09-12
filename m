Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF69A3DB62E;
	Sat, 12 Sep 2026 09:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204066; cv=none; b=XWUTzmDjiBovui5uMflJSoaLxgOl75HHgSANp44cHDVXvHBINr1fSwIPS2t5K04RXw/+m/QrWeC1iN02VdZgakVUma42fJabsbLlZw4MNAVJzujMCPlEwePuAJZQvOA9xaZyZZrfcUmHINTe9igCn4/F2TTu17kv6AopccgL7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204066; c=relaxed/simple;
	bh=UzuHFTwqStzaGb7+sFDcr/3bOO2Pi7lt7AiibXajx38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJ+Q49LkLatKlT8lRg4pV/+vGVuTh86aBkuOROqqd+CKcNzilANkX9V5IRnWoWjbwfdr81DUmTiKMWSQTUesMAE8OPjuTp/rlO0KVBzsnuWgMcV3GzGuFE3RXe5ZGSaJRUFvdVK3a5GbLVkCxaENRQ2TaPm3DL67ghk6RMas5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6mVZKWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6mVZKWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE001F000FF;
	Sat, 12 Sep 2026 09:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204064;
	bh=8tKlK3l2eB8hgObJ867mHex0yjMKdk61i6Uihcu4Ndo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6mVZKWltpWSiy6l9mgnF+FswJyQfzsH8Mz6BNmxt2coc1TElgLnWqLKzPWRoA04v
	 cXF9EK7gboaBOEC2jgFAN5sEAhvwTqPyVS98GRXrOdVrvZdfWOIxKIncJjHVcoJ0MI
	 h4Rd6Hcc/FH87grKyyCp80sfCBPRQfZukg691dF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1536/1815] ksmbd: disconnect on SMB3 decryption failure
Date: Sat, 12 Sep 2026 08:54:46 +0200
Message-ID: <20260912065725.067136021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 37d9ab7e937ad..49ee4f281a1f2 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -339,6 +339,22 @@ void ksmbd_all_conn_set_status(struct ksmbd_session *sess, u32 status)
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
index 7f7bc1f24a63d..242a9757eb0db 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -174,6 +174,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
 void ksmbd_conn_put(struct ksmbd_conn *conn);
+void ksmbd_conn_abort(struct ksmbd_conn *conn);
 int ksmbd_conn_wq_init(void);
 void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 943c619cbf848..0425ef045db0b 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -183,8 +183,10 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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
index 13b711ea575d8..990b14e5d3ea2 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -434,6 +434,11 @@ static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
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
@@ -680,5 +685,6 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.shutdown	= ksmbd_tcp_shutdown,
 	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.53.0



