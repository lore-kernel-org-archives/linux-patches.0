Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A3137AA65;
	Sat, 12 Sep 2026 09:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204100; cv=none; b=D/7CvS4gGtHds7pOvDfaF8ZJpdu1chAl/HzBHGo5mosNrzVw7WlG6z2rSbYc3e1oOU2csJSThrKtU+DcGIT0PZbKe4y5grwyPxR6cEyOREclA+MDXjEFv9LDKEKAi/1lks4k8xNVUhs8hAldSpRnyyg2dnK/dblHQputejD+MzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204100; c=relaxed/simple;
	bh=SizT2z7M06KtGAAjRz6V/sWq+KCd17cj7MGwoRKfbLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7vjeR4LavMWPrK+XtHO+EODbiPRptz+0sY6BGUkscXRAxCAsh6wydwX52fJHU1lNXAkHlfpxulLAJFc6sG+VlOXS7537mwWzM3g2kuksjA8z5wKCsSOgP02qXYFYmxhxFqU/IQCnNg+TOjqRUb9UYNzX9ebUj1n5HSEUAoK0a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUI3xqfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUI3xqfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E080B1F000FF;
	Sat, 12 Sep 2026 09:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204098;
	bh=1Yd/P7z+PsN2CLLOnycGimZtztrU30Daa7i0PtS2Jq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUI3xqfFWHNLIe7FeAW1uDMwe5FbMVeHcCuJdkwJQpKnXC59qD4xtmlCNHaGckh3l
	 09vroek03ngX47iHXMufsf8jdpYMsT1b260cryStrB8tHiZtTKVAaK1WWEyvTQq0Qk
	 xvTTxk44XLVQxvdoeBjF8JpPaemJniFVboJveo6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1542/1815] smb/server: warn if ksmbd_proc_create() fails
Date: Sat, 12 Sep 2026 08:54:52 +0200
Message-ID: <20260912065725.205336427@linuxfoundation.org>
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

[ Upstream commit 9a74739026fb71d1197183a067eef657bb5fba77 ]

Print a warning if the sessions procfs entry cannot be created.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 492b24b5b651 ("smb/server: update session counter under sessions table lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c        | 3 ++-
 fs/smb/server/mgmt/user_session.c | 5 ++++-
 fs/smb/server/server.c            | 8 ++++++--
 fs/smb/server/vfs_cache.c         | 6 ++++--
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 49ee4f281a1f2..af73c2ed5d249 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -665,7 +665,8 @@ int ksmbd_conn_transport_init(void)
 	}
 out:
 	mutex_unlock(&init_lock);
-	create_proc_clients();
+	if (create_proc_clients())
+		pr_warn("Unable to create clients procfs entry\n");
 	return ret;
 }
 
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 745db1fa566c5..215f4e66deda0 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -188,6 +188,8 @@ static int create_proc_session(struct ksmbd_session *sess)
 	snprintf(name, sizeof(name), "sessions/%llu", sess->id);
 	sess->proc_entry = ksmbd_proc_create(name,
 					     show_proc_session, sess);
+	if (!sess->proc_entry)
+		return -ENOMEM;
 	return 0;
 }
 
@@ -724,7 +726,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
 
-	create_proc_session(sess);
+	if (create_proc_session(sess))
+		pr_warn_ratelimited("Unable to create session %llu procfs entry\n", sess->id);
 	ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS);
 	return sess;
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 7d17e2901dabb..0b080972e9085 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -644,8 +644,12 @@ static int __init ksmbd_server_init(void)
 	ret = ksmbd_proc_init();
 	if (ret)
 		goto err_unregister;
-	create_proc_sessions();
-	create_proc_shares();
+
+	if (create_proc_sessions())
+		pr_warn("Unable to create sessions procfs entry\n");
+
+	if (create_proc_shares())
+		pr_warn("Unable to create shares procfs entry\n");
 
 	ksmbd_server_tcp_callbacks_init();
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 9e5a3bfaefaf8..293dab9b43be1 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -124,7 +124,8 @@ static int proc_show_files(struct seq_file *m, void *v)
 
 static int create_proc_files(void)
 {
-	ksmbd_proc_create("files", proc_show_files, NULL);
+	if (!ksmbd_proc_create("files", proc_show_files, NULL))
+		return -ENOMEM;
 	return 0;
 }
 #else
@@ -1678,7 +1679,8 @@ void ksmbd_close_session_fds(struct ksmbd_work *work)
 
 int ksmbd_init_global_file_table(void)
 {
-	create_proc_files();
+	if (create_proc_files())
+		pr_warn("Unable to create files procfs entry\n");
 	return ksmbd_init_file_table(&global_ft);
 }
 
-- 
2.53.0



