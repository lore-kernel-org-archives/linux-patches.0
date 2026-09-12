Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E09D37FF60;
	Sat, 12 Sep 2026 09:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204110; cv=none; b=LUdymfxzi22Bn3/TnTNyLKwxikx0UFioxuyKM5nnpqFmoapSrZkNe+7iapOntXvHCg82TJGMRzoXzz/xIeiE0kV1tHYk4GBiUctVamLoD8aRzeZF4Vdcopj3ZBU3ZdLmWr30Y3/aQ4J0+lphirHaoiZREn/aHJ/3iv86rnDKbB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204110; c=relaxed/simple;
	bh=kkracyWfR9teuyPwZy9RO6G6Z/TS3BH4lTCL+klWi+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFAZDTIu1gTiCTmXgVq+Nk1lcUcdXEi56T5/moAXp44pDFOD5i5LptBhkdd2WBvY00oCfIZICDUtrVUFKddnmGs1m00l+o+u2zpeo75Ck2lJY2Q0lQkOyLxdBCCoynhHX0uQkSLEdj8whnXzVBO/aZcV7qwG7h/C9056MBAokag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsSABbJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsSABbJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11941F000FF;
	Sat, 12 Sep 2026 09:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204109;
	bh=S+2Ao0Ln8C5MEuKZYrms0i2h6pOdE9cEw4uWlAqa4Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsSABbJAtnamABncrGh+1YQ5eAlgHdyaMw+g8cTcvL9xbaYXRdXGS3CfySlonkxJW
	 b+yyZhQAAg0xGr4vEMJjYbDEoSe6GYcbVa8NAaooLyxkvlqcnDz2WdnohRk9K7czsu
	 zPcD3hrYMKeZXdjYDPwU//fa8GU+x63IvhdIh0vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1544/1815] smb/server: fix session counter on session removal
Date: Sat, 12 Sep 2026 08:54:54 +0200
Message-ID: <20260912065725.252261770@linuxfoundation.org>
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

[ Upstream commit 7de5cf9bcf96bf2ee2ea2ad1d35a7b950f71161a ]

See the procedure below:

  smb2_sess_setup
    ksmbd_smb2_session_create
      __session_create
        hash_add(sessions_table, &sess->hlist, sess->id)
        ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS)
  ksmbd_conn_handler_loop
    ksmbd_server_terminate_conn
      ksmbd_sessions_deregister
        hash_del(&sess->hlist)
        // do not decrement KSMBD_COUNTER_SESSIONS

KSMBD_COUNTER_SESSIONS tracks sessions published in sessions_table, but
session removal does not decrement it. The value therefore keeps growing
after sessions are expired, rejected during registration, or removed on
the last channel disconnect.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 5b734acc00736..d91dde3f9e619 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -397,6 +397,12 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	kfree(sess);
 }
 
+static void ksmbd_session_remove_from_table(struct ksmbd_session *sess)
+{
+	hash_del(&sess->hlist);
+	ksmbd_counter_dec(KSMBD_COUNTER_SESSIONS);
+}
+
 struct ksmbd_session *__session_lookup(unsigned long long id)
 {
 	struct ksmbd_session *sess;
@@ -423,7 +429,7 @@ static void ksmbd_expire_session(struct ksmbd_conn *conn)
 		     time_after(jiffies,
 			       sess->last_active + SMB2_SESSION_TIMEOUT))) {
 			xa_erase(&conn->sessions, sess->id);
-			hash_del(&sess->hlist);
+			ksmbd_session_remove_from_table(sess);
 			ksmbd_session_destroy(sess);
 			continue;
 		}
@@ -444,7 +450,7 @@ int ksmbd_session_register(struct ksmbd_conn *conn,
 			      KSMBD_DEFAULT_GFP));
 	if (ret) {
 		down_write(&sessions_table_lock);
-		hash_del(&sess->hlist);
+		ksmbd_session_remove_from_table(sess);
 		up_write(&sessions_table_lock);
 		ksmbd_user_session_put(sess);
 	}
@@ -477,7 +483,7 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 	hash_for_each_safe(sessions_table, bkt, tmp, sess, hlist) {
 		if (!ksmbd_chann_del(conn, sess) &&
 		    xa_empty(&sess->ksmbd_chann_list)) {
-			hash_del(&sess->hlist);
+			ksmbd_session_remove_from_table(sess);
 			down_write(&conn->session_lock);
 			xa_erase(&conn->sessions, sess->id);
 			up_write(&conn->session_lock);
@@ -491,7 +497,7 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 		ksmbd_chann_del(conn, sess);
 		if (xa_empty(&sess->ksmbd_chann_list)) {
 			xa_erase(&conn->sessions, sess->id);
-			hash_del(&sess->hlist);
+			ksmbd_session_remove_from_table(sess);
 			if (atomic_dec_and_test(&sess->refcnt))
 				ksmbd_session_destroy(sess);
 		}
-- 
2.53.0



