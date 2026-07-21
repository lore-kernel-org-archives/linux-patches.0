Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3398284662;
	Tue, 21 Jul 2026 19:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663175; cv=none; b=KutzPQ7bDJszfYy+hdds5aSwjFiwjaOjOmM5yXpLazfaWJetTTZszTfW7iv06mTbrTHIhXZ+3BlH7VHhoOdtj+ST7luZ+MZOK/x62EbuWvRzxZ+v1Nl6QUtP/0zicbxkPPwmrg+HZ9tRgzpFJMfr/VY7HAG9fQUTAWzOHnkQSfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663175; c=relaxed/simple;
	bh=mbJoCeCpRRRRWGm0jwPle8k/ngC/mjRK2Cx2p2sXSNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuPDvGOgk7A2AdrKqBPZz7UzHHLutv1+7m7OhfowViVVR7LU5wTx/uLcTKzEIxn5HeKxbCzEsYUSzfWeE1DZ2WDiW+D9J8lk1Jcok40Ms8KJ8wbHp9+ugxLYlUko6/Aa07NbtoauVqjJaJF1ArLmMIzLzEfbMtTnqb1CwEHytt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpqdnPFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpqdnPFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115CC1F000E9;
	Tue, 21 Jul 2026 19:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663173;
	bh=aspgZuQ1+XKL0/8Yb0loVXzReY5SCtsTWTeSE89cmqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpqdnPFZ/ujTvIASvfnCgWug1emjZ3cXoy/pjx20f4k8ucb6bDotbp9M7lkixyFnH
	 GCX06ro9rNL836ctZJJgBDKfBS7mZ7g5b596iVF77Ue0iMblZqcfYQEH+ZYOaREyga
	 vkirTLhmVbD5nbOXK8RbcM28dT9XXnuKfPXld/Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0722/1276] ksmbd: fix use-after-free of fp->owner.name in durable handle owner check
Date: Tue, 21 Jul 2026 17:19:25 +0200
Message-ID: <20260721152502.247728745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Portnoy <dddhkts1@gmail.com>

[ Upstream commit 38637163501fd9e2f684b8cd275d0db5d79f37c6 ]

Two concurrent SMB2 durable reconnects (DH2C/DHnC) on the same
persistent_id race the fp->owner.name compare-read in
ksmbd_vfs_compare_durable_owner() against the kfree() in
ksmbd_reopen_durable_fd()'s reopen-success path. fp->owner.name is a
standalone kstrdup() buffer whose lifetime is independent of the fp
refcount, and the two sites share no lock: the compare reads the buffer
while the reopen frees it, so the strcmp() can dereference freed memory.

Commit 7ce4fc40018d ("ksmbd: fix durable reconnect double-bind race in
ksmbd_reopen_durable_fd") made the fp->conn claim atomic under
global_ft.lock (closing the owner.name double-free and the ksmbd_file
write-UAF), but the compare-read versus reopen-free pair was left
unserialized.

  BUG: KASAN: slab-use-after-free in strcmp+0x2c/0x80
  Read of size 1 by task kworker
    strcmp
    ksmbd_vfs_compare_durable_owner
    smb2_check_durable_oplock
    smb2_open
  Freed by task kworker:
    kfree
    ksmbd_reopen_durable_fd
    smb2_open
  Allocated by task kworker:
    kstrdup
    session_fd_check
    smb2_session_logoff
  The buggy address belongs to the cache kmalloc-8

Serialize both sides of the race with fp->f_lock.  The global durable
file-table lock still protects the durable reconnect claim, but
fp->owner.name is per-open state and does not need to block unrelated
durable table lookups or reconnects.  The teardown is left at its
existing location after the reopen-success point so that an __open_id()
rollback still retains owner.name for a later legitimate reconnect to
verify.

Fixes: 49110a8ce654 ("ksmbd: validate owner of durable handle on reconnect")
Assisted-by: Henry (Claude):claude-opus-4
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index a1f59a8e16e281..fad426fe3d14d6 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -980,16 +980,21 @@ void ksmbd_stop_durable_scavenger(void)
 static int ksmbd_vfs_copy_durable_owner(struct ksmbd_file *fp,
 		struct ksmbd_user *user)
 {
+	char *name;
+
 	if (!user)
 		return -EINVAL;
 
 	/* Duplicate the user name to ensure identity persistence */
-	fp->owner.name = kstrdup(user->name, GFP_KERNEL);
-	if (!fp->owner.name)
+	name = kstrdup(user->name, GFP_KERNEL);
+	if (!name)
 		return -ENOMEM;
 
+	spin_lock(&fp->f_lock);
 	fp->owner.uid = user->uid;
 	fp->owner.gid = user->gid;
+	fp->owner.name = name;
+	spin_unlock(&fp->f_lock);
 
 	return 0;
 }
@@ -1007,18 +1012,24 @@ static int ksmbd_vfs_copy_durable_owner(struct ksmbd_file *fp,
 bool ksmbd_vfs_compare_durable_owner(struct ksmbd_file *fp,
 		struct ksmbd_user *user)
 {
-	if (!user || !fp->owner.name)
+	bool ret = false;
+
+	if (!user)
 		return false;
 
+	spin_lock(&fp->f_lock);
+	if (!fp->owner.name)
+		goto out;
+
 	/* Check if the UID and GID match first (fast path) */
 	if (fp->owner.uid != user->uid || fp->owner.gid != user->gid)
-		return false;
+		goto out;
 
 	/* Validate the account name to ensure the same SecurityContext */
-	if (strcmp(fp->owner.name, user->name))
-		return false;
-
-	return true;
+	ret = (strcmp(fp->owner.name, user->name) == 0);
+out:
+	spin_unlock(&fp->f_lock);
+	return ret;
 }
 
 static bool session_fd_check(struct ksmbd_tree_connect *tcon,
@@ -1172,9 +1183,11 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	}
 	up_write(&ci->m_lock);
 
+	spin_lock(&fp->f_lock);
 	fp->owner.uid = fp->owner.gid = 0;
 	kfree(fp->owner.name);
 	fp->owner.name = NULL;
+	spin_unlock(&fp->f_lock);
 
 	return 0;
 }
-- 
2.53.0



