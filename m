Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC8937AA7D;
	Thu, 20 Aug 2026 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247631; cv=none; b=Xm5VPoxqzGuVbRH5aWITEi2eSLIbqeOvvVbo8BAL9tjU+S7FB93y7bmypEhIi7tz2jbrS345OqxZXkZBjM/GYqEH5ViqhghAIedjOI89Zc9Bhhn0HzmgLJRAOC4vyDWOxzrFBLrBNfNahzW5qTv3w8Txo8p1BpXoV5Rd709fTP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247631; c=relaxed/simple;
	bh=l/S0wSKvwUedHOpBSC4hmPKbjrZZ6TjO4CdvJ9Mv6jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuObgIt4saRX0iyddcQT7TYU6B/HI7uin5gmHS/GwxCbeUY9C+HojfsMgEjtsxAUCDGPFthuU0HTSTjvWjKlTw18sTEBNtpG3nq0KAnGpdcNHVj1mPO79CmEaZ/DCpxyDuCv29SBkDGuHT6eXEdRdFkR/TFnkJRRQMNdLwvEWSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVrQqby1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVrQqby1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC4E1F000E9;
	Thu, 20 Aug 2026 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247629;
	bh=9hxwYvn73A2Auzn/uRJ4Ysxz3+QQZFy2K5d+m+A62vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVrQqby1OfiPDbMUu34RMix0hGf48hY1ePRNppqZvvqfQr5mbGfVTDnpbqV0wLdoa
	 jT+ISJV/YJIOpxBchwEa0wFsJis9fhdTnQkpO8wJOV8eGlDdHUGlatPhDqjnwA7dqf
	 ETsnGLCT7tEk4+mi7VhIVtZmCVQoo+bfGKR7cPxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runa Takemoto <takemotoruna223@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/166] ksmbd: reject repeated SMB2 NEGOTIATE requests
Date: Thu, 20 Aug 2026 16:56:11 +0200
Message-ID: <20260820145214.534869296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

[ Upstream commit cb469993b3a61a72653770856d37af616d72d05f ]

Unauthenticated client can send multiple successful SMB2 NEGOTIATE
requests on one connection before SESSION_SETUP. While the connection is
in KSMBD_SESS_NEED_SETUP, smb2_handle_negotiate() accepts another
SMB3.1.1 NEGOTIATE and overwrites conn->preauth_info with a new allocation.
Only the final allocation is freed when the connection is released, leaking
one object for every additional successful request.

A repeated SMB2 NEGOTIATE after a dialect has been selected is a protocol
violation. MS-SMB2 section 3.3.5.4 requires the server to disconnect
without replying in this case. Set the connection exiting when rejecting
the request, in addition to suppressing the response.

Reject SMB2 NEGOTIATE unless the connection is new or is waiting for the
SMB2 NEGOTIATE that follows an SMB1 multi-protocol negotiate. Serialize
both SMB1 and SMB2 negotiation paths under conn->srv_mutex, since they
update connection-wide dialect and negotiation state.

Move the locking contract to ksmbd_smb_negotiate_common(), where the state
and dialect are selected, and add ksmbd_conn_new() for consistent state
access.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: Runa Takemoto <takemotoruna223@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.h |    5 +++++
 fs/smb/server/smb2pdu.c    |   10 ++--------
 fs/smb/server/smb_common.c |   37 ++++++++++++++++++++++++++++++-------
 3 files changed, 37 insertions(+), 15 deletions(-)

--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -194,6 +194,11 @@ void ksmbd_conn_r_count_dec(struct ksmbd
  * This is a hack. We will move status to a proper place once we land
  * a multi-sessions support.
  */
+static inline bool ksmbd_conn_new(struct ksmbd_conn *conn)
+{
+	return READ_ONCE(conn->status) == KSMBD_SESS_NEW;
+}
+
 static inline bool ksmbd_conn_good(struct ksmbd_conn *conn)
 {
 	return READ_ONCE(conn->status) == KSMBD_SESS_GOOD;
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1095,6 +1095,8 @@ static __le32 deassemble_neg_contexts(st
  * smb2_handle_negotiate() - handler for smb2 negotiate command
  * @work:	smb work containing smb request buffer
  *
+ * The caller holds conn->srv_mutex.
+ *
  * Return:      0
  */
 int smb2_handle_negotiate(struct ksmbd_work *work)
@@ -1108,13 +1110,6 @@ int smb2_handle_negotiate(struct ksmbd_w
 
 	ksmbd_debug(SMB, "Received negotiate request\n");
 	conn->need_neg = false;
-	if (ksmbd_conn_good(conn)) {
-		pr_err("conn->tcp_status is already in CifsGood State\n");
-		work->send_no_response = 1;
-		return rc;
-	}
-
-	ksmbd_conn_lock(conn);
 	smb2_buf_len = get_rfc1002_len(work->request_buf);
 	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
 	if (smb2_neg_size > smb2_buf_len) {
@@ -1265,7 +1260,6 @@ int smb2_handle_negotiate(struct ksmbd_w
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
-	ksmbd_conn_unlock(conn);
 	if (rc)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -592,23 +592,46 @@ int ksmbd_smb_negotiate_common(struct ks
 	struct ksmbd_conn *conn = work->conn;
 	int ret;
 
-	conn->dialect =
-		ksmbd_negotiate_smb_dialect(work->request_buf);
-	ksmbd_debug(SMB, "conn->dialect 0x%x\n", conn->dialect);
-
 	if (command == SMB2_NEGOTIATE_HE) {
+		/*
+		 * An SMB2 NEGOTIATE is valid for a new connection, or after an
+		 * SMB1 multi-protocol negotiate has selected SMB2. Do not allow
+		 * a second SMB2 NEGOTIATE to replace connection-wide state
+		 * while a session setup is pending. KSMBD_SESS_NEED_RECONNECT
+		 * is a transient session state and does not restart transport
+		 * negotiation.
+		 */
+		ksmbd_conn_lock(conn);
+		if (!ksmbd_conn_new(conn) &&
+		    !ksmbd_conn_need_negotiate(conn)) {
+			work->send_no_response = 1;
+			ksmbd_conn_set_exiting(conn);
+			ksmbd_conn_unlock(conn);
+			return 0;
+		}
+
+		conn->dialect =
+			ksmbd_negotiate_smb_dialect(work->request_buf);
+		ksmbd_debug(SMB, "conn->dialect 0x%x\n", conn->dialect);
 		ret = smb2_handle_negotiate(work);
+		ksmbd_conn_unlock(conn);
 		return ret;
 	}
 
 	if (command == SMB_COM_NEGOTIATE) {
+		ksmbd_conn_lock(conn);
+		conn->dialect =
+			ksmbd_negotiate_smb_dialect(work->request_buf);
+		ksmbd_debug(SMB, "conn->dialect 0x%x\n", conn->dialect);
 		if (__smb2_negotiate(conn)) {
 			init_smb3_11_server(conn);
-			init_smb2_neg_rsp(work);
+			ret = init_smb2_neg_rsp(work);
 			ksmbd_debug(SMB, "Upgrade to SMB2 negotiation\n");
-			return 0;
+		} else {
+			ret = smb_handle_negotiate(work);
 		}
-		return smb_handle_negotiate(work);
+		ksmbd_conn_unlock(conn);
+		return ret;
 	}
 
 	pr_err("Unknown SMB negotiation command: %u\n", command);


