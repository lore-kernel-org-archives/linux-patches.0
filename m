Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA551F9F69;
	Tue,  3 Dec 2024 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239990; cv=none; b=VVzMYc1IbNH7L4iWY7oscuy4rqS6BwQsrybLEjTa2t4a9G/FYBOL5y2+dxCTAUak4BYx80zhcAkKcMsAhsyxNkn/A6V9F08sP8W8XhKpTrcowpRak/O7/Q35yTnqbp5EXEPdO5eFJ32sQq8lCohMVwwmZRflBd4B+gbl7fhgPmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239990; c=relaxed/simple;
	bh=lwKpGtQNgmHJIxGoUg8Jd/AzY2P0+VusoE6OF3u2vYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2Yw90oizDp928JIBdDR+PjeljvYooul/O5AZPT3PBwmKS8BW9nrtz6TdKwjeE/AukJwAst3iE3IYS2/1LitMPWvocItHBfZQpb+oldPPQfAomfL+nNY0Kb//EF1MMqAl57n3kqjL7/xoDRFWe3vBspd/i3TxtrIrOEJroFqOrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVTVbgoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVTVbgoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D8BC4CECF;
	Tue,  3 Dec 2024 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239989;
	bh=lwKpGtQNgmHJIxGoUg8Jd/AzY2P0+VusoE6OF3u2vYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVTVbgoWp6WK6KMIKDD3cretLCknq9EB9+5pwr5CZWegOBRqda3ao0FiceGY2ZaN1
	 DVLkY5kJWso/095KZi6xRSYVE4+iRk7vmC7tVOdJfW/J75/dY4fDomiAUWcWQDTPNx
	 BVJqH43J08WmjhMBXSvxBniPrM0adZqDOnnb1u9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 803/817] cifs: during remount, make sure passwords are in sync
Date: Tue,  3 Dec 2024 15:46:15 +0100
Message-ID: <20241203144027.790527267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4069b69fbc7e0..e84660b48d533 100644
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
index cf577ec0dd0ac..bbd2063ab838d 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -298,6 +298,7 @@ static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *f
 }
 
 extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
+extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
 extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
 /*
-- 
2.43.0



