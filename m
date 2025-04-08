Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD3326461E;
	Tue,  8 Apr 2025 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115837; cv=none; b=W+TIMnPvFb2QBFhpAFLIxWa8tc0mXRns2ISLi7DtGeSnLyNc+xrZpoc2fjRrgCPJPYiVDETighlRjt3KvOE3+1YzXtLRK5xqX+nsVjzmNarzQhH3vSYNdHXZMfdqJjCeXkIsH0f6ZQQYiD6Hz6wsuiOPnPcKm/d9WK4b2DYVzRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115837; c=relaxed/simple;
	bh=IhFh2bLjFL6nt42bjHzhGvw2Cr5HP0XozIxaPhuWy7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFDc/rTth2Yt5yLmgiDBJna6HPw3w4F3LssVgK4RavHm5JEGlwEADpAETNY6k1/OP1JtAufGFJ29IBzDkO31i6c42x77MFUXJ1d3YPL+mWGfIbZNQwXz0213tIp7ejoO3AVeWfSJoIZrOGRsIz4fJn7a3BjrJ1SMjGeE3jXkpwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoKnm6QR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoKnm6QR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDFFC4CEE5;
	Tue,  8 Apr 2025 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115837;
	bh=IhFh2bLjFL6nt42bjHzhGvw2Cr5HP0XozIxaPhuWy7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoKnm6QRQEc4uYknpDCEF5CjV9sndcngP/2Qf31+hZXqe/bClqTpUftl7coec+Xvd
	 lTFRPKPQmAJqifeZZ2yP54almf2uqUZd4IdDY+eQArtoXCLo/PAVsb5GNezJ+1foj6
	 d8u/xw1/xo8XIzww5q0N7NAWhtbhwz+6HcK9goYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/204] ksmbd: fix multichannel connection failure
Date: Tue,  8 Apr 2025 12:50:46 +0200
Message-ID: <20250408104823.723823996@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c1883049aa9b2b7dffd3a68c5fc67fa92c174bd9 ]

ksmbd check that the session of second channel is in the session list of
first connection. If it is in session list, multichannel connection
should not be allowed.

Fixes: b95629435b84 ("ksmbd: fix racy issue from session lookup and expire")
Reported-by: Sean Heelan <seanheelan@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 16 ++++++++++++++++
 fs/smb/server/mgmt/user_session.h |  2 ++
 fs/smb/server/smb2pdu.c           | 12 ++++--------
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index b1c2219ec0b42..3bcfe739ba136 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -255,6 +255,22 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 	up_write(&sessions_table_lock);
 }
 
+bool is_ksmbd_session_in_connection(struct ksmbd_conn *conn,
+				   unsigned long long id)
+{
+	struct ksmbd_session *sess;
+
+	down_read(&conn->session_lock);
+	sess = xa_load(&conn->sessions, id);
+	if (sess) {
+		up_read(&conn->session_lock);
+		return true;
+	}
+	up_read(&conn->session_lock);
+
+	return false;
+}
+
 struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 					   unsigned long long id)
 {
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index ce91b1d698e71..f4da293c4dbb2 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -87,6 +87,8 @@ void ksmbd_session_destroy(struct ksmbd_session *sess);
 struct ksmbd_session *ksmbd_session_lookup_slowpath(unsigned long long id);
 struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 					   unsigned long long id);
+bool is_ksmbd_session_in_connection(struct ksmbd_conn *conn,
+				     unsigned long long id);
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess);
 void ksmbd_sessions_deregister(struct ksmbd_conn *conn);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 646c4047d3b94..12bf3712ba2d3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1723,44 +1723,38 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (conn->dialect != sess->dialect) {
 			rc = -EINVAL;
-			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (!(req->hdr.Flags & SMB2_FLAGS_SIGNED)) {
 			rc = -EINVAL;
-			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (strncmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
-			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (sess->state == SMB2_SESSION_IN_PROGRESS) {
 			rc = -EACCES;
-			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (sess->state == SMB2_SESSION_EXPIRED) {
 			rc = -EFAULT;
-			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
-		ksmbd_user_session_put(sess);
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			sess = NULL;
 			goto out_err;
 		}
 
-		sess = ksmbd_session_lookup(conn, sess_id);
-		if (!sess) {
+		if (is_ksmbd_session_in_connection(conn, sess_id)) {
 			rc = -EACCES;
 			goto out_err;
 		}
@@ -1926,6 +1920,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 			sess->last_active = jiffies;
 			sess->state = SMB2_SESSION_EXPIRED;
+			ksmbd_user_session_put(sess);
+			work->sess = NULL;
 			if (try_delay) {
 				ksmbd_conn_set_need_reconnect(conn);
 				ssleep(5);
-- 
2.39.5



