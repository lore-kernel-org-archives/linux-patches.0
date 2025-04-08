Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6340819AD5C;
	Tue,  8 Apr 2025 11:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112177; cv=none; b=axPkRmrRC125r+hXhzTylZ6gwhSTco+4nOogaUYK2SyHD8TtsbmjQ2qyiZ6izqTus4HVQsKjwyFSaGuWhypz8z4yUBFPasw/ghbu1sn/HXXoUnon5biQgipXe6FjgaY3O/mZizbR4xn+S5PdCfhFHTc5+GjGRYdvsnKq8vu5iaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112177; c=relaxed/simple;
	bh=jT6dq7RYd+yJ0Vhdeg7w3+DxCtAN2GrM84Zi4BFGa7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5JDKI+jsD6sVkpG/De0GdrmVzZu3BXcDjmfMNDHTmd4qq7wiUwOY9/LJSorP6yjKpYz5MC3laT3xFHdQ9h4jx7/BI0RhKfj2Z23Ls+ikFvlAR3FFaaIc9c578Qs6CYELUfrrdtslYh1AXhGmZ6+lQP4p2Ue8fB5tgwttSsyG+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCIZnf1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCIZnf1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC218C4CEE5;
	Tue,  8 Apr 2025 11:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112177;
	bh=jT6dq7RYd+yJ0Vhdeg7w3+DxCtAN2GrM84Zi4BFGa7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCIZnf1I7R2HQFRXqcDKIVZI2e45ryb0ZOVy4oNdT+YzOf0XodicU7YAF0kXOQ6Gc
	 xmQM0LD7QgQpUroRogusYEC8UD85i9nD5NT6CjbxEAXC9JvTgSyh4FUDivO9ioOmC5
	 PJGP9vxiwuZ4IInwyfUIYn3TsEq7ucl0/prXfnQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.14 704/731] ksmbd: fix null pointer dereference in alloc_preauth_hash()
Date: Tue,  8 Apr 2025 12:50:01 +0200
Message-ID: <20250408104930.643459435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit c8b5b7c5da7d0c31c9b7190b4a7bba5281fc4780 upstream.

The Client send malformed smb2 negotiate request. ksmbd return error
response. Subsequently, the client can send smb2 session setup even
thought conn->preauth_info is not allocated.
This patch add KSMBD_SESS_NEED_SETUP status of connection to ignore
session setup request if smb2 negotiate phase is not complete.

Cc: stable@vger.kernel.org
Tested-by: Steve French <stfrench@microsoft.com>
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-26505
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.h        |   11 +++++++++++
 fs/smb/server/mgmt/user_session.c |    4 ++--
 fs/smb/server/smb2pdu.c           |   14 +++++++++++---
 3 files changed, 24 insertions(+), 5 deletions(-)

--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -27,6 +27,7 @@ enum {
 	KSMBD_SESS_EXITING,
 	KSMBD_SESS_NEED_RECONNECT,
 	KSMBD_SESS_NEED_NEGOTIATE,
+	KSMBD_SESS_NEED_SETUP,
 	KSMBD_SESS_RELEASING
 };
 
@@ -187,6 +188,11 @@ static inline bool ksmbd_conn_need_negot
 	return READ_ONCE(conn->status) == KSMBD_SESS_NEED_NEGOTIATE;
 }
 
+static inline bool ksmbd_conn_need_setup(struct ksmbd_conn *conn)
+{
+	return READ_ONCE(conn->status) == KSMBD_SESS_NEED_SETUP;
+}
+
 static inline bool ksmbd_conn_need_reconnect(struct ksmbd_conn *conn)
 {
 	return READ_ONCE(conn->status) == KSMBD_SESS_NEED_RECONNECT;
@@ -217,6 +223,11 @@ static inline void ksmbd_conn_set_need_n
 	WRITE_ONCE(conn->status, KSMBD_SESS_NEED_NEGOTIATE);
 }
 
+static inline void ksmbd_conn_set_need_setup(struct ksmbd_conn *conn)
+{
+	WRITE_ONCE(conn->status, KSMBD_SESS_NEED_SETUP);
+}
+
 static inline void ksmbd_conn_set_need_reconnect(struct ksmbd_conn *conn)
 {
 	WRITE_ONCE(conn->status, KSMBD_SESS_NEED_RECONNECT);
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -374,13 +374,13 @@ void destroy_previous_session(struct ksm
 	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_RECONNECT);
 	err = ksmbd_conn_wait_idle_sess_id(conn, id);
 	if (err) {
-		ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_NEGOTIATE);
+		ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_SETUP);
 		goto out;
 	}
 
 	ksmbd_destroy_file_table(&prev_sess->file_table);
 	prev_sess->state = SMB2_SESSION_EXPIRED;
-	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_NEGOTIATE);
+	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_SETUP);
 	ksmbd_launch_ksmbd_durable_scavenger();
 out:
 	up_write(&conn->session_lock);
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1249,7 +1249,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 	}
 
 	conn->srv_sec_mode = le16_to_cpu(rsp->SecurityMode);
-	ksmbd_conn_set_need_negotiate(conn);
+	ksmbd_conn_set_need_setup(conn);
 
 err_out:
 	ksmbd_conn_unlock(conn);
@@ -1271,6 +1271,9 @@ static int alloc_preauth_hash(struct ksm
 	if (sess->Preauth_HashValue)
 		return 0;
 
+	if (!conn->preauth_info)
+		return -ENOMEM;
+
 	sess->Preauth_HashValue = kmemdup(conn->preauth_info->Preauth_HashValue,
 					  PREAUTH_HASHVALUE_SIZE, KSMBD_DEFAULT_GFP);
 	if (!sess->Preauth_HashValue)
@@ -1674,6 +1677,11 @@ int smb2_sess_setup(struct ksmbd_work *w
 
 	ksmbd_debug(SMB, "Received smb2 session setup request\n");
 
+	if (!ksmbd_conn_need_setup(conn) && !ksmbd_conn_good(conn)) {
+		work->send_no_response = 1;
+		return rc;
+	}
+
 	WORK_BUFFERS(work, req, rsp);
 
 	rsp->StructureSize = cpu_to_le16(9);
@@ -1909,7 +1917,7 @@ out_err:
 			if (try_delay) {
 				ksmbd_conn_set_need_reconnect(conn);
 				ssleep(5);
-				ksmbd_conn_set_need_negotiate(conn);
+				ksmbd_conn_set_need_setup(conn);
 			}
 		}
 		smb2_set_err_rsp(work);
@@ -2243,7 +2251,7 @@ int smb2_session_logoff(struct ksmbd_wor
 		ksmbd_free_user(sess->user);
 		sess->user = NULL;
 	}
-	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_NEGOTIATE);
+	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_logoff_rsp));


