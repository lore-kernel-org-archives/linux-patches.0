Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E138E4746B8;
	Sat, 12 Sep 2026 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211718; cv=none; b=kVj1oJaeR+1ruEOld2PI+wQHyQPlOYRvCg1NGwW1mZDS0Jkr+Iujf0W9Ch5RhjZmI8dEO5D2vJF3oU1nW3yLWIUwqp30bAPH0X44pTkjjt7pqjLYdSx0/W0zxI166ZNckpkDoagU7TU0RYeI9kgMaHSdWsdJQu1FQ+VyYS5bxO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211718; c=relaxed/simple;
	bh=O8f5Sh+bQkKEK6ROA/RkUpc7TqB0jD958PRE8pgUrgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oslhJ0/KpdVn0U8faVslY9wjphuZdZIZ9bI1/nVvZKrlQiwlbQj7Ev/kncNxZdydl/oy25n5xS5Kakz3IpdySh5hK8SmCIwZhLVuflrwB/gX44PAihA/xyXM2Pa51dfJu4bpgkiqlNEXCL9kjQrRjTysf6ES+YnBJ7ArfxbcR64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PU44fwtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PU44fwtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6241F000FF;
	Sat, 12 Sep 2026 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211716;
	bh=YMHhN3tc7MJzyf/0mIHdF0niP/Ns1BVeNQJg7m5o52A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PU44fwtJ0U3sqlk/vADq+ItCtd1eYWZaJyiVaBvWSx+ZLJaHqdF/JPrR6qsDAZ2Kn
	 EZo1kGg+PzUcR0+smwa9RvFLrWuBYK0DeIL5Y6NqCDZt4lMCTog8YMuJXlR/VpRa9v
	 Lg+0P+8039RLBVDUJI5uW48G2TKC1/yqU+fH19CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1245/1518] smb/server: fix session leak in ksmbd_session_register()
Date: Sat, 12 Sep 2026 08:56:54 +0200
Message-ID: <20260912065651.672386127@linuxfoundation.org>
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

From: Ze Tan <tanze@kylinos.cn>

[ Upstream commit 99b25b046e47e4904373cfeb445c5483f1633d88 ]

See the procedure below:

  smb2_sess_setup
    ksmbd_smb2_session_create
      __session_create
        atomic_set(&sess->refcnt, 2)
        hash_add(sessions_table, &sess->hlist, sess->id)
    ksmbd_session_register
      xa_store(&conn->sessions, sess->id, sess) // fail
    ksmbd_user_session_put
      atomic_dec(&sess->refcnt) // refcnt is 1, session is not freed

Remove the session from sessions_table and drop its table reference if
xa_store() fails.

Fixes: f5c779b7ddbd ("ksmbd: fix racy issue from session setup and logoff")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index b15531665ed5e..e815915665211 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -212,10 +212,21 @@ static void ksmbd_expire_session(struct ksmbd_conn *conn)
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess)
 {
+	int ret;
+
 	sess->dialect = conn->dialect;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 	ksmbd_expire_session(conn);
-	return xa_err(xa_store(&conn->sessions, sess->id, sess, KSMBD_DEFAULT_GFP));
+	ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
+			      KSMBD_DEFAULT_GFP));
+	if (ret) {
+		down_write(&sessions_table_lock);
+		hash_del(&sess->hlist);
+		up_write(&sessions_table_lock);
+		ksmbd_user_session_put(sess);
+	}
+
+	return ret;
 }
 
 static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
-- 
2.53.0



