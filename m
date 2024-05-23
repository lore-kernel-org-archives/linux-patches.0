Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2D914AD38;
	Thu, 23 May 2024 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470703; cv=none; b=c+8pkpQ6GKzLNT7ErLl3VGM9zC5MWK9Ty866zSOfrle1B2Kb149sbEkkmjEuD6h4Ytx8MzkZB8Pq6NFSSo55Tp/GfL9zVyBS+ouv3F3ct6Qkn3uz9SfGQUdNt3jd2iMMIEZ6aRZXUgYjbJQyMVuLZFZAH3z1ZOqfLrGLsRxkCik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470703; c=relaxed/simple;
	bh=obhP4V58EqHvyyGo9rvZ2dydYexh4YrxrU4ZSpP0a5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ipa+yC8qa+EKHttQlIP2IZqYGvm6dBja4SPeLgIALuPqZERDs917LYJtGXmLqkdNESm23uqNR8fo8FutIlVvB33UJ7qPyU2i4R1Y+uqtWFW1X2EUqAwgbZCRB+v5buamjndGqXjVp48qy+nij4Z77zE98IrsSrRmolfW7YMgtu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5XngfPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5XngfPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94722C2BD10;
	Thu, 23 May 2024 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470703;
	bh=obhP4V58EqHvyyGo9rvZ2dydYexh4YrxrU4ZSpP0a5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5XngfPQxeKdKakPJxywVvAKLgplmMXu5PU6DPvmXK/YS2Swp7BZl5Ui/gJfW7UUT
	 XHlIvi6B21WY1SaK+9MKMfGCWtcXG5QTh2kQ3JDvxX66NfTVvnxclORyXRfoBEeDFn
	 /CQhzLbEduu6jRdCyMek/T0pMr9xqY6OvmuQXA2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/102] ksmbd: mark SMB2_SESSION_EXPIRED to session when destroying previous session
Date: Thu, 23 May 2024 15:13:24 +0200
Message-ID: <20240523130344.696018317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit fa9415d4024fd0c58d24a4ad4f1826fb8bfcc4aa ]

Currently ksmbd exit connection as well destroying previous session.
When testing durable handle feaure, I found that
destroy_previous_session() should destroy only session, i.e. the
connection should be still alive. This patch mark SMB2_SESSION_EXPIRED
on the previous session to be destroyed later and not used anymore.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 27 ++++++++++++++++++++++++++-
 fs/smb/server/mgmt/user_session.h |  3 +++
 fs/smb/server/smb2pdu.c           | 24 ------------------------
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 15f68ee050894..83074672fe812 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -156,7 +156,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	kfree(sess);
 }
 
-static struct ksmbd_session *__session_lookup(unsigned long long id)
+struct ksmbd_session *__session_lookup(unsigned long long id)
 {
 	struct ksmbd_session *sess;
 
@@ -305,6 +305,31 @@ struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 	return sess;
 }
 
+void destroy_previous_session(struct ksmbd_conn *conn,
+			      struct ksmbd_user *user, u64 id)
+{
+	struct ksmbd_session *prev_sess;
+	struct ksmbd_user *prev_user;
+
+	down_write(&sessions_table_lock);
+	down_write(&conn->session_lock);
+	prev_sess = __session_lookup(id);
+	if (!prev_sess || prev_sess->state == SMB2_SESSION_EXPIRED)
+		goto out;
+
+	prev_user = prev_sess->user;
+	if (!prev_user ||
+	    strcmp(user->name, prev_user->name) ||
+	    user->passkey_sz != prev_user->passkey_sz ||
+	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
+		goto out;
+
+	prev_sess->state = SMB2_SESSION_EXPIRED;
+out:
+	up_write(&conn->session_lock);
+	up_write(&sessions_table_lock);
+}
+
 static bool ksmbd_preauth_session_id_match(struct preauth_session *sess,
 					   unsigned long long id)
 {
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 63cb08fffde84..dc9fded2cd437 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -88,8 +88,11 @@ struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess);
 void ksmbd_sessions_deregister(struct ksmbd_conn *conn);
+struct ksmbd_session *__session_lookup(unsigned long long id);
 struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 					       unsigned long long id);
+void destroy_previous_session(struct ksmbd_conn *conn,
+			      struct ksmbd_user *user, u64 id);
 struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 						    u64 sess_id);
 struct preauth_session *ksmbd_preauth_session_lookup(struct ksmbd_conn *conn,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index fb9eea631069e..61717917db765 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -611,30 +611,6 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	return -ENOENT;
 }
 
-static void destroy_previous_session(struct ksmbd_conn *conn,
-				     struct ksmbd_user *user, u64 id)
-{
-	struct ksmbd_session *prev_sess = ksmbd_session_lookup_slowpath(id);
-	struct ksmbd_user *prev_user;
-	struct channel *chann;
-	long index;
-
-	if (!prev_sess)
-		return;
-
-	prev_user = prev_sess->user;
-
-	if (!prev_user ||
-	    strcmp(user->name, prev_user->name) ||
-	    user->passkey_sz != prev_user->passkey_sz ||
-	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
-		return;
-
-	prev_sess->state = SMB2_SESSION_EXPIRED;
-	xa_for_each(&prev_sess->ksmbd_chann_list, index, chann)
-		ksmbd_conn_set_exiting(chann->conn);
-}
-
 /**
  * smb2_get_name() - get filename string from on the wire smb format
  * @src:	source buffer
-- 
2.43.0



