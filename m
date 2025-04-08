Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375532676E1;
	Tue,  8 Apr 2025 12:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114918; cv=none; b=cfN4s/xqXk61JtFYaF+YVOQn6Cf0Asci0rX5bGH7iYUz4A7sJHyrN8vCWosQdghpNV6VzGNoI9X/fVOSCtI1Nf8fjfQ2/H5411/zaFrB/o0jvBLf5ib9ioBGb6h58S5ypL8/OIEHfcS2WhS0iIFSUDxCj+BDbqgl5Z/AlmPeaig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114918; c=relaxed/simple;
	bh=MaYz2j1/fDrLaA6q17qwLr6drInU7Zwy/M9cphGq1FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AitIKLhTvmssTVIljSHOvYX9mVjjJ3Oog82Hu+gZbqoUSe9zDCZaLI/eXND1/XnqDjf+0XUjJxh59FU6h079+ZsfURjduxQ64GL5W3sT2GiQ0f1jinnPvNrNaj03EysUklazAiO7wtowhRf+1PE0z0+ywSmy9HvEX8mrojkxBto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XglIOytr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XglIOytr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A473DC4CEE5;
	Tue,  8 Apr 2025 12:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114918;
	bh=MaYz2j1/fDrLaA6q17qwLr6drInU7Zwy/M9cphGq1FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XglIOytrQde2FWrPpsmQKK3aeYnMug789myc19JKpRj7r+uNnzwFiOTk5Gx8XrbAY
	 NX1zDa7NjR3xSrbhgT0ixdtajj32S3akfSqnYsSskCJ8A2IP51LDzrYZkGjk3FM1SX
	 P0Ska6nGVYq52Nlc2Tw6X8bobUkAUSmy3MeFsovM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 282/499] ksmbd: fix multichannel connection failure
Date: Tue,  8 Apr 2025 12:48:14 +0200
Message-ID: <20250408104858.249800604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 71c6939dfbf13..e5c835c8822ca 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -256,6 +256,22 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
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
index c1c4b20bd5c6c..f21348381d598 100644
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
index 91de0224902f3..2dfe578ed6e7a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1706,44 +1706,38 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
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
@@ -1909,6 +1903,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 			sess->last_active = jiffies;
 			sess->state = SMB2_SESSION_EXPIRED;
+			ksmbd_user_session_put(sess);
+			work->sess = NULL;
 			if (try_delay) {
 				ksmbd_conn_set_need_reconnect(conn);
 				ssleep(5);
-- 
2.39.5



