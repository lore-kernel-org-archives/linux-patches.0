Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE233471D03;
	Sat, 12 Sep 2026 11:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211707; cv=none; b=CjV44DJFndatZEl9rIIW4Oj6NCsf+XyFOe5AJuQuoTD2smNMPYHAs/CLVJF10ayLKLSv7BQf4acDQnNPSc61pUMe1en48I9VJElBEUY78kSGmHioz0tVe+j7lV7hV2HKzDzimuTBxmLwC4rp+nq54PoZO7CsBHC9VdAMk6dRnuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211707; c=relaxed/simple;
	bh=mllucZU/iUKUooPhyWSyNwv+HRiqaWHxCzcjEEqC+ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW95v8pg6a51C1VJiPjpMBFDUJfLq3NR73pZJgsHf9CVFU28T6fIIH5XYHaGJ8gJygVo18bMWBuA5KBPZOaBM9gStoAwUexi7zc8JAFbgaHkHeonewb9G1wxdyLSnn8FQag+jUT78bYBPTf5no2Go+EDkqlCrjl4wRfJshl3VUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbrFZkX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbrFZkX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C332E1F000FF;
	Sat, 12 Sep 2026 11:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211706;
	bh=tmJWcaQpv8Q9q1FQ+Rapfih50P13aC75344+mADKe3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbrFZkX+st80y+/20woLU0yEMK1ljUuAWrIrQ5a5Qw80hpdafScuTb3aPivYvQcID
	 qMIFfh2hKCurG9xXKiHYR/svrT8/UHGHlLTinJTwoUC22G7gBp2JH6nXQrH33gm6PT
	 xyA2qgyWdWRaeulcjUJ4n7GfiLSoOtXRgnPrvT7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1243/1518] ksmbd: disconnect on SMB3 decryption failure
Date: Sat, 12 Sep 2026 08:56:52 +0200
Message-ID: <20260912065651.626479692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bc370e86217c7..ff6cdd720dd43 100644
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
index f8f88651166b9..ceb1c1aefbf64 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -168,6 +168,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
 void ksmbd_conn_put(struct ksmbd_conn *conn);
+void ksmbd_conn_abort(struct ksmbd_conn *conn);
 int ksmbd_conn_wq_init(void);
 void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 9da4525010ccd..76515d9777e30 100644
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
index a09b07b3b108d..78c909d66814f 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -454,6 +454,11 @@ static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
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
@@ -709,5 +714,6 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.shutdown	= ksmbd_tcp_shutdown,
 	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.53.0



