Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2737FF60;
	Sat, 12 Sep 2026 13:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218596; cv=none; b=l6aIN4SsUVzKh7kri3x73J+mkJjgQ0GtHTDkZzcsjpTZ9cDZX7JsD1xOtQI6/FsmVKACBZYc96Sng5ZrkxTs0VYOlYzXA7feX2UfBAbAxaKQhHru2lAOpCz8leyiK4Z9E3HCEabdQy5u1lagvbYzTwLC0Xxg9IycDRMNxfOX5eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218596; c=relaxed/simple;
	bh=quZ+a8JmQRHZva/ojtISFEgoPNGW9Yri4L7Wo1xHANo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/9ODmFVV3Wzw2f+WyYKE/pD1PtI1myxmPbwFEu6BFK+gGPvYEfvQRZjvkT847an5eaAeEBiKEhXdP32SFlljQ3ot9pX/eTb1hoKf5zXMJMqhoEaTPDkZjzckqdvv0C6k1J/txynHNKhDub+uVszgfN1hcJ69CL+NWvWrb8BItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvN6sgtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvN6sgtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BD51F000FF;
	Sat, 12 Sep 2026 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218595;
	bh=YSrtyA26s0Fh7QMCo3GU6vGC63ENQjsSGURNJvB7DlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvN6sgtb17RRdXPg1CZ0Sn+QmFQpsuVYc5ZlzWd7RRZsSxaik7n63o/zbR48/NvpQ
	 eRfSz+4tZrXR+PlXXqk8g647KbWIOT1Yhtl99XvcDcDOfwsIEe9gfeuZyrzUdISSeV
	 8duBJZTJwTUNvN9/2RpSWe2JThP7dRAjFu7kNfAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1177/1376] ksmbd: disconnect on SMB3 decryption failure
Date: Sat, 12 Sep 2026 09:00:03 +0200
Message-ID: <20260912065633.784262963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 6808fee63f284..c5f9705825b87 100644
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
index 8728899d5e756..96ef441330512 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -166,6 +166,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
 void ksmbd_conn_put(struct ksmbd_conn *conn);
+void ksmbd_conn_abort(struct ksmbd_conn *conn);
 int ksmbd_conn_wq_init(void);
 void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 4c7924e254174..a618638875012 100644
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
index d731bab985683..902a6265e323c 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -467,6 +467,11 @@ static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
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
@@ -722,5 +727,6 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.shutdown	= ksmbd_tcp_shutdown,
 	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.53.0



