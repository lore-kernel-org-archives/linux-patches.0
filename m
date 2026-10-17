Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC87C3A1E92;
	Sat, 17 Oct 2026 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259986; cv=none; b=LUboOZzextNtsFXdRZkz1Ru8qPP/kLscJVexVU3H37C2sbPrWnOqhmx2WJY/sR6eMiNnKLsKxgXruFuBBfAVGLyRDOVxbGe02iQU+X6zM+gmwmRnT86rOYmKcJKjn61tGyFxVNSdZpgCZpckjm2S4Lf6MhvQXGyLASnSTlAxs7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259986; c=relaxed/simple;
	bh=iM09/9wEXJSAD6yfkSAiL+eKBhXcGfNmwyR/OHBM3oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBLEh3lHNIHaaVSegvKDKqyFiV22z4S4sR5AZFfULeZyAnLkM0FxiA51h7KRMOsJzLJ85Kmf+7hxHZW1S5EM7FMmk/6svssF8QEpd8/7i2SHNkRmj5jo4/XYIxfOCAtRQs3Fv5E/hdzjZaR6xIT6mVCHA+i60PqnZdfSgMpoepM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daVlsVDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daVlsVDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D0B1F000C4;
	Sat, 17 Oct 2026 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259985;
	bh=l2ov7AV96P7hSCRWW6Zqi0koiL6F8mlT4tnkSDB0C1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=daVlsVDi/Hsh50bIMdjY3CTCfmZcNp3CPo7+nqrIPIOXysWl7k/+5aVcP3f0fOzHp
	 +TNQxL0kMhkoDeaE63Vtc90QyVHssQ0FWRE/NuMEclr+mvMbfTu+Yh4tp3t0q4U+R0
	 wb05MfyLstF6v3JdXQeHd+FmWsty3S1OAmR8JbWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1394/1674] smb/server: fix session leak in ksmbd_session_register()
Date: Sat, 17 Oct 2026 18:01:06 +0200
Message-ID: <20261017160506.953707742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 fs/smb/server/mgmt/user_session.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 26c1bfff242a5..3c10a928e325a 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -212,10 +212,20 @@ static void ksmbd_expire_session(struct ksmbd_conn *conn)
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess)
 {
+	int ret;
+
 	sess->dialect = conn->dialect;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 	ksmbd_expire_session(conn);
-	return xa_err(xa_store(&conn->sessions, sess->id, sess, GFP_KERNEL));
+	ret = xa_err(xa_store(&conn->sessions, sess->id, sess, GFP_KERNEL));
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



