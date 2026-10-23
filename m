Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774494;
	b=o5VQWQuEQVXrX8UtUX9s2GsRnm6GQiph8pKmBML3iFL4BMNAifEN4qxOCR8uf8SP9mt6
	 YcIfuZoM1V56G9k+O6hyLwhef/DZByO906NW+2Ho4ASFc2m4RluvzcfOKWcJHbXw8xzl8
	 73/Yu5B83WYbAnaJEQozqRbMDNlpXw4IgsZO5g5hNSp/uC+biVTRq1efc/FUBXWt5qMst
	 cEpJzSGKJeZiOa7Go2njvXZueRyQPz/dfdli1Q0Y3eeI1UP0Q+7dfPdHdpnSxzbT9TE3e
	 peMGFM73LzOELKYSTmb17xUDZPf7eRwEkTcuYfh1Trclm9ThNl2Uy+ItWT3YYfW6ryA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jLbFpgMO1wUg3bfOvl7c2fwlXwBa+j3MDQPfs8HZfOQ=;
	b=SBmdqvV/q3sGMCllR6oSYctADCIzsM4rG+oxz9GypkgR41dU/T7zo3yxpoTn9/UtO4SC
	 nEnnCp/QyV04ZroJrN7BfVoBQMlRKXSbtmQwraSwAiRJWIhkKp2dEA7oiet0UBbRRHuy+
	 b10dW7SFHAyfvW0Tgg7E1VJ9iK59N/WrEOhRWB+tuXNSShGivhmh2WcyK1/uLkF7Z1gDo
	 bD8sXPc5gvaPwt4hOr3LH6ze3v8xTBjLwxa+3JuqQFRFYpHpKCmdfsZ2nwXqvZpdK4inS
	 t1X3z1fFLVg/XMKRwQOPafeoDOOX/PMqT8KvCRPUGhEa4QBkIt5ezCl5r3qY5GqXNOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLE11+fo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C89606A31B;
	Fri, 23 Oct 2026 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLE11+fo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2E61F01828;
	Fri, 23 Oct 2026 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774493;
	bh=jLbFpgMO1wUg3bfOvl7c2fwlXwBa+j3MDQPfs8HZfOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLE11+fonQbKMYmJ8B/1NR1odgZTgULx4l4V29OmR1y8ToVgN/UIe61THanV4ccrI
	 aT4qN5AR6x5QMP2hBDVU1Fi0LsF/IWuILvBKxKwVAJYa8b9ywflqdehjTVOUEZ3hVv
	 OkrBJlE3ZH36I9SoZzLgi427y3L+2kDzyKFJFm4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 060/242] fs: add switch_fs_struct()
Date: Fri, 23 Oct 2026 18:38:22 +0200
Message-ID: <20261023163715.202482475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 21bcea3ef2025796a29ba88f2747d864ed535758 ]

Don't open-code the guts of replacing current's fs struct.

Link: https://patch.msgid.link/20260601-work-kthread-nullfs-v4-1-77ee053060e0@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d2bdb9b61b42 ("fs: let idle threads share init_fs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_struct.c            | 18 ++++++++++++++++++
 include/linux/fs_struct.h |  2 ++
 kernel/fork.c             | 22 ++++++----------------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 394875d06fd60..c441586537e7e 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -147,6 +147,24 @@ int unshare_fs_struct(void)
 }
 EXPORT_SYMBOL_GPL(unshare_fs_struct);
 
+struct fs_struct *switch_fs_struct(struct fs_struct *new_fs)
+{
+	struct fs_struct *fs;
+
+	scoped_guard(task_lock, current) {
+		fs = current->fs;
+		read_seqlock_excl(&fs->seq);
+		current->fs = new_fs;
+		if (--fs->users)
+			new_fs = NULL;
+		else
+			new_fs = fs;
+		read_sequnlock_excl(&fs->seq);
+	}
+
+	return new_fs;
+}
+
 /* to be mentioned only in INIT_TASK */
 struct fs_struct init_fs = {
 	.users		= 1,
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 0070764b790a3..ade459383f925 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -40,6 +40,8 @@ static inline void get_fs_pwd(struct fs_struct *fs, struct path *pwd)
 	read_sequnlock_excl(&fs->seq);
 }
 
+struct fs_struct *switch_fs_struct(struct fs_struct *new_fs);
+
 extern bool current_chrooted(void);
 
 static inline int current_umask(void)
diff --git a/kernel/fork.c b/kernel/fork.c
index 854448152696b..739659e71af53 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3220,7 +3220,7 @@ static int unshare_fd(unsigned long unshare_flags, struct files_struct **new_fdp
  */
 int ksys_unshare(unsigned long unshare_flags)
 {
-	struct fs_struct *fs, *new_fs = NULL;
+	struct fs_struct *new_fs = NULL;
 	struct files_struct *new_fd = NULL;
 	struct cred *new_cred = NULL;
 	struct nsproxy *new_nsproxy = NULL;
@@ -3298,23 +3298,13 @@ int ksys_unshare(unsigned long unshare_flags)
 			new_nsproxy = NULL;
 		}
 
-		task_lock(current);
+		if (new_fs)
+			new_fs = switch_fs_struct(new_fs);
 
-		if (new_fs) {
-			fs = current->fs;
-			read_seqlock_excl(&fs->seq);
-			current->fs = new_fs;
-			if (--fs->users)
-				new_fs = NULL;
-			else
-				new_fs = fs;
-			read_sequnlock_excl(&fs->seq);
-		}
-
-		if (new_fd)
+		if (new_fd) {
+			guard(task_lock)(current);
 			swap(current->files, new_fd);
-
-		task_unlock(current);
+		}
 
 		if (new_cred) {
 			/* Install the new user namespace */
-- 
2.53.0



