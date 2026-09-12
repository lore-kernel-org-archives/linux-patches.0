Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D4C400DF6;
	Sat, 12 Sep 2026 09:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204090; cv=none; b=rsumhUEfeCdCWQSFDa5Fnyet5OPWsrfsJirh3aImumE0f4Rj917BZega/9yXdjiudHdILFIacfxo3YaZxYEbPUtBuRJsmXPZ8zTMDfpzEq5fWdz0NOPCXrGytl7pQAn95iQjkLT5MEZbnyLs6S2Y2LOR1ta2VrhApu9wXYI0jho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204090; c=relaxed/simple;
	bh=DFdaYN/YnWSrGbwyvfTC8oNEvmUiOD6mdGvKQ0PFpk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe9GO5N90Sd2Wvt/0JxVZAsBZBG8aLQcz1AosKhV0CUBI7kBXC+AilER+8tJHRPqNR2DZMIhhACT1DV3zzNm9c64yXE6G9T2JqHDM64j+v5DLYW7CuYz8+CtRkhr5uAounIi3B5l8W8RCG8y7NwIjWR17VU6dp4KcrufDHV/9Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4GWwnYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4GWwnYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA431F000FF;
	Sat, 12 Sep 2026 09:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204089;
	bh=T0TLJCNVcsiCNNYQf2tuNbgx1Le5veeqFOf4T3kboTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4GWwnYGkOiz4sALjwWs+Ppz+XoqC5VCrQXVkUHRKUBgvIuItJGIDClRSfovCmX+K
	 067QehRt6Y+O3EiwwgCLkUupm8k4bBqSSsrJdrxMnpaHqBzQWYkIhHYwM9k+oD0Cnn
	 vbmOhAKgX19OG9DK12S58UqDD5ylsQkYepCJT0tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1540/1815] smb/server: fix session leak in ksmbd_session_register()
Date: Sat, 12 Sep 2026 08:54:50 +0200
Message-ID: <20260912065725.159910513@linuxfoundation.org>
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
index 3273c500eff44..745db1fa566c5 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -433,10 +433,21 @@ static void ksmbd_expire_session(struct ksmbd_conn *conn)
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



