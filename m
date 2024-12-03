Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F461F7591;
	Tue,  3 Dec 2024 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242796; cv=none; b=Lp/APQSb1qB+njNDz01GkRo32MfFXhVDhGGY+NIuliwUpwDg56LOkgIgylxTM41PxTksiSRChTILTC+8rgwPznPqHirqO5WXODA9LT/iMcQTP9LbMBqtI1o/SfZkhfmJ6dbnPiHRs44CuFii9TyRwCQDHZ2u+pBY/ekJnPysATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242796; c=relaxed/simple;
	bh=fghnyjDL8bV++MNTVCk14zRDFf4yQwdfJs2TWT3Z0QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itAPzehZyPGRqJldzXmdvrfV50Hltb4abklMqUBTt9OqKIoG+J9havZzIRJ0Lwk7+m912Gz6OiR4thofV692reM2rYlxORSfg1dqsvRp0Gk4obP7DJQ/40CteAYWkKhXAM0VJikzdflACsc8Uew2agjpPzmcGMM/0DsmCyjhFjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPbUrIM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPbUrIM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E643C4CED8;
	Tue,  3 Dec 2024 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242796;
	bh=fghnyjDL8bV++MNTVCk14zRDFf4yQwdfJs2TWT3Z0QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPbUrIM2GmhVTvUj6b8n32S/30YpyIlGixkpAc6y1E3s+YLfnZQ7N5gEiHVCQLFXS
	 iTL4FGgMhG6FjovXc8M4zHkJCEPzWeqOIPq4SKq0eLvoZZVhBAxmf/ZsiHer/AnRug
	 VJlduBy6/9a7Vygn5gCI5wGiP5f8pIhklPin+xcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 812/826] cifs: during remount, make sure passwords are in sync
Date: Tue,  3 Dec 2024 15:48:59 +0100
Message-ID: <20241203144815.429776521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 0f0e357902957fba28ed31bde0d6921c6bd1485d ]

This fixes scenarios where remount can overwrite the only currently
working password, breaking reconnect.

We recently introduced a password2 field in both ses and ctx structs.
This was done so as to allow the client to rotate passwords for a mount
without any downtime. However, when the client transparently handles
password rotation, it can swap the values of the two password fields
in the ses struct, but not in smb3_fs_context struct that hangs off
cifs_sb. This can lead to a situation where a remount unintentionally
overwrites a working password in the ses struct.

In order to fix this, we first get the passwords in ctx struct
in-sync with ses struct, before replacing them with what the passwords
that could be passed as a part of remount.

Also, in order to avoid race condition between smb2_reconnect and
smb3_reconfigure, we make sure to lock session_mutex before changing
password and password2 fields of the ses structure.

Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changing on the server by allowing password rotation")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 83 +++++++++++++++++++++++++++++++++-----
 fs/smb/client/fs_context.h |  1 +
 2 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 5c5a52019efad..1a5842ced489d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -890,12 +890,37 @@ do {									\
 	cifs_sb->ctx->field = NULL;					\
 } while (0)
 
+int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
+{
+	if (ses->password &&
+	    cifs_sb->ctx->password &&
+	    strcmp(ses->password, cifs_sb->ctx->password)) {
+		kfree_sensitive(cifs_sb->ctx->password);
+		cifs_sb->ctx->password = kstrdup(ses->password, GFP_KERNEL);
+		if (!cifs_sb->ctx->password)
+			return -ENOMEM;
+	}
+	if (ses->password2 &&
+	    cifs_sb->ctx->password2 &&
+	    strcmp(ses->password2, cifs_sb->ctx->password2)) {
+		kfree_sensitive(cifs_sb->ctx->password2);
+		cifs_sb->ctx->password2 = kstrdup(ses->password2, GFP_KERNEL);
+		if (!cifs_sb->ctx->password2) {
+			kfree_sensitive(cifs_sb->ctx->password);
+			cifs_sb->ctx->password = NULL;
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
 	int rc;
 
@@ -915,21 +940,61 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, UNC);
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
+
 	if (need_recon == false)
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
 	else  {
-		kfree_sensitive(ses->password);
-		ses->password = kstrdup(ctx->password, GFP_KERNEL);
-		if (!ses->password)
-			return -ENOMEM;
-		kfree_sensitive(ses->password2);
-		ses->password2 = kstrdup(ctx->password2, GFP_KERNEL);
-		if (!ses->password2) {
-			kfree_sensitive(ses->password);
-			ses->password = NULL;
+		if (ctx->password) {
+			new_password = kstrdup(ctx->password, GFP_KERNEL);
+			if (!new_password)
+				return -ENOMEM;
+		} else
+			STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
+	}
+
+	/*
+	 * if a new password2 has been specified, then reset it's value
+	 * inside the ses struct
+	 */
+	if (ctx->password2) {
+		new_password2 = kstrdup(ctx->password2, GFP_KERNEL);
+		if (!new_password2) {
+			kfree_sensitive(new_password);
 			return -ENOMEM;
 		}
+	} else
+		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
+
+	/*
+	 * we may update the passwords in the ses struct below. Make sure we do
+	 * not race with smb2_reconnect
+	 */
+	mutex_lock(&ses->session_mutex);
+
+	/*
+	 * smb2_reconnect may swap password and password2 in case session setup
+	 * failed. First get ctx passwords in sync with ses passwords. It should
+	 * be okay to do this even if this function were to return an error at a
+	 * later stage
+	 */
+	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
+	if (rc)
+		return rc;
+
+	/*
+	 * now that allocations for passwords are done, commit them
+	 */
+	if (new_password) {
+		kfree_sensitive(ses->password);
+		ses->password = new_password;
 	}
+	if (new_password2) {
+		kfree_sensitive(ses->password2);
+		ses->password2 = new_password2;
+	}
+
+	mutex_unlock(&ses->session_mutex);
+
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 890d6d9d4a592..c8c8b4451b3bc 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -299,6 +299,7 @@ static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *f
 }
 
 extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
+extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
 extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
 /*
-- 
2.43.0



