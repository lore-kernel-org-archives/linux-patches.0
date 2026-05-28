Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C902F260C;
	Thu, 28 May 2026 20:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998857; cv=none; b=WaCV8SK5kGcfrutk9RzagQcvGabJzNF+6yA6xTFQfDqknl1erCj2ocUKOpP98tM+M2n3H7an58yOMvrtrhKpbInuvyXtD3Qc0R3ZVC9pEi8n60+pZe4d1KPKEgT/dUGjwNCX0wbFj1CtEwod5FG+bUIsb+NF/GT73DFml//x1M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998857; c=relaxed/simple;
	bh=m+BvINh02Uitbk/2ep3ImlAgBTm0v2wPxuWHI4cYPlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzLuYl9mxZThYAIkT3BaGdKVBPNE+hs6inQICIzYtU0zpmBLF2dRz4zvPQJd2p4V1dbvaG+fErcjciOpU722RN9Yq+pQCDS7fhzwzJGbi1MgmekRCuY9kqWnFN2fgBd6+RjQxdW8piVKLA6NT9wTJW04uDB98ArEtityuuCK2+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr4T028A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr4T028A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869371F000E9;
	Thu, 28 May 2026 20:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998856;
	bh=CWSRE04BBId5477a/gGzPF+6SYFZHFNbF8h+Khd3Teo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gr4T028A8v2z1uMU4Lg3yTer9r03mf5kNlNsBdaWeqsp4kU8GhpXfZOD6O68E236p
	 0yqK2lew/Fkk4VwkVB9Ed+nH3J4DbBCiMMYygbXJ6tOHhRgOsNZB0Y4VyMQCzb300J
	 z+SRrNX8z1lKs3KN90YcgrIdsjlRyyNRUwKcdzw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RAJASI MANDAL <rajasimandalos@gmail.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	DaeMyung Kang <charsyam@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 323/461] cifs: client: stage smb3_reconfigure() updates and restore ctx on failure
Date: Thu, 28 May 2026 21:47:32 +0200
Message-ID: <20260528194656.671158459@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit ab26dfeba278b0efbcea012f1698cf524d9b5695 ]

smb3_reconfigure() moves strings out of cifs_sb->ctx before the
multichannel update, so a later failure can leave the live context
with NULL strings or options that do not match the session.

Stage the new ctx separately, commit it only on success, and restore
the snapshot on failure. Also make smb3_sync_session_ctx_passwords()
all-or-nothing.

Commit session passwords before channel updates so newly added channels
authenticate with the staged credentials.

Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com/
Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug2pxm7wy7nbms@iq6cf5taa65v/
Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 161 +++++++++++++++++++++++++------------
 1 file changed, 108 insertions(+), 53 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index a46764c247107..59598d334bae1 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -761,7 +761,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 					    void *data);
 static int smb3_get_tree(struct fs_context *fc);
-static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels);
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels);
 static int smb3_reconfigure(struct fs_context *fc);
 
 static const struct fs_context_operations smb3_fs_context_ops = {
@@ -1035,25 +1035,34 @@ do {									\
 
 int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 {
+	char *password = NULL, *password2 = NULL;
+
 	if (ses->password &&
 	    cifs_sb->ctx->password &&
 	    strcmp(ses->password, cifs_sb->ctx->password)) {
-		kfree_sensitive(cifs_sb->ctx->password);
-		cifs_sb->ctx->password = kstrdup(ses->password, GFP_KERNEL);
-		if (!cifs_sb->ctx->password)
+		password = kstrdup(ses->password, GFP_KERNEL);
+		if (!password)
 			return -ENOMEM;
 	}
 	if (ses->password2 &&
 	    cifs_sb->ctx->password2 &&
 	    strcmp(ses->password2, cifs_sb->ctx->password2)) {
-		kfree_sensitive(cifs_sb->ctx->password2);
-		cifs_sb->ctx->password2 = kstrdup(ses->password2, GFP_KERNEL);
-		if (!cifs_sb->ctx->password2) {
-			kfree_sensitive(cifs_sb->ctx->password);
-			cifs_sb->ctx->password = NULL;
+		password2 = kstrdup(ses->password2, GFP_KERNEL);
+		if (!password2) {
+			kfree_sensitive(password);
 			return -ENOMEM;
 		}
 	}
+
+	if (password) {
+		kfree_sensitive(cifs_sb->ctx->password);
+		cifs_sb->ctx->password = password;
+	}
+	if (password2) {
+		kfree_sensitive(cifs_sb->ctx->password2);
+		cifs_sb->ctx->password2 = password2;
+	}
+
 	return 0;
 }
 
@@ -1066,7 +1075,7 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
  * with the session's channel lock. This should be called whenever the maximum
  * allowed channels for a session changes (e.g., after a remount or reconfigure).
  */
-static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 {
 	spin_lock(&ses->chan_lock);
 	ses->chan_max = max_channels;
@@ -1076,12 +1085,15 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channe
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	struct smb3_fs_context *new_ctx = NULL;
+	struct smb3_fs_context *old_ctx = NULL;
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
 	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
+	bool need_mchan_update;
 	int rc;
 
 	if (ses->expired_pwd)
@@ -1091,6 +1103,16 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (rc)
 		return rc;
 
+	old_ctx = kzalloc_obj(*old_ctx);
+	if (!old_ctx)
+		return -ENOMEM;
+
+	rc = smb3_fs_context_dup(old_ctx, cifs_sb->ctx);
+	if (rc) {
+		kfree(old_ctx);
+		return rc;
+	}
+
 	/*
 	 * We can not change UNC/username/password/domainname/
 	 * workstation_name/nodename/iocharset
@@ -1100,16 +1122,22 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, UNC);
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
+	STEAL_STRING(cifs_sb, ctx, domainname);
+	STEAL_STRING(cifs_sb, ctx, nodename);
+	STEAL_STRING(cifs_sb, ctx, iocharset);
 
-	if (need_recon == false)
+	if (!need_recon) {
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
-	else  {
+	} else {
 		if (ctx->password) {
 			new_password = kstrdup(ctx->password, GFP_KERNEL);
-			if (!new_password)
-				return -ENOMEM;
-		} else
+			if (!new_password) {
+				rc = -ENOMEM;
+				goto restore_ctx;
+			}
+		} else {
 			STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
+		}
 	}
 
 	/*
@@ -1119,11 +1147,29 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (ctx->password2) {
 		new_password2 = kstrdup(ctx->password2, GFP_KERNEL);
 		if (!new_password2) {
-			kfree_sensitive(new_password);
-			return -ENOMEM;
+			rc = -ENOMEM;
+			goto restore_ctx;
 		}
-	} else
+	} else {
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
+	}
+
+	/* if rsize or wsize not passed in on remount, use previous values */
+	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
+	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
+
+	new_ctx = kzalloc_obj(*new_ctx);
+	if (!new_ctx) {
+		rc = -ENOMEM;
+		goto restore_ctx;
+	}
+
+	rc = smb3_fs_context_dup(new_ctx, ctx);
+	if (rc)
+		goto restore_ctx;
+
+	need_mchan_update = ctx->multichannel != cifs_sb->ctx->multichannel ||
+			    ctx->max_channels != cifs_sb->ctx->max_channels;
 
 	/*
 	 * we may update the passwords in the ses struct below. Make sure we do
@@ -1134,54 +1180,55 @@ static int smb3_reconfigure(struct fs_context *fc)
 	/*
 	 * smb2_reconnect may swap password and password2 in case session setup
 	 * failed. First get ctx passwords in sync with ses passwords. It should
-	 * be okay to do this even if this function were to return an error at a
-	 * later stage
+	 * be done before committing new passwords.
 	 */
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		kfree_sensitive(new_password);
-		kfree_sensitive(new_password2);
-		return rc;
+		goto cleanup_new_ctx;
+	}
+
+	/*
+	 * If multichannel or max_channels has changed, update the session's channels accordingly.
+	 * This may add or remove channels to match the new configuration.
+	 */
+	if (need_mchan_update) {
+		/* Prevent concurrent scaling operations */
+		spin_lock(&ses->ses_lock);
+		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
+			spin_unlock(&ses->ses_lock);
+			mutex_unlock(&ses->session_mutex);
+			rc = -EINVAL;
+			goto cleanup_new_ctx;
+		}
+		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
 	}
 
 	/*
-	 * now that allocations for passwords are done, commit them
+	 * Commit session passwords before any channel work so newly added
+	 * channels authenticate with the new credentials.
 	 */
 	if (new_password) {
 		kfree_sensitive(ses->password);
 		ses->password = new_password;
+		new_password = NULL;
 	}
 	if (new_password2) {
 		kfree_sensitive(ses->password2);
 		ses->password2 = new_password2;
+		new_password2 = NULL;
 	}
 
-	/*
-	 * If multichannel or max_channels has changed, update the session's channels accordingly.
-	 * This may add or remove channels to match the new configuration.
-	 */
-	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
-	    (ctx->max_channels != cifs_sb->ctx->max_channels)) {
-
+	if (need_mchan_update) {
 		/* Synchronize ses->chan_max with the new mount context */
 		smb3_sync_ses_chan_max(ses, ctx->max_channels);
-		/* Now update the session's channels to match the new configuration */
-		/* Prevent concurrent scaling operations */
-		spin_lock(&ses->ses_lock);
-		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
-			spin_unlock(&ses->ses_lock);
-			mutex_unlock(&ses->session_mutex);
-			return -EINVAL;
-		}
-		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
-		spin_unlock(&ses->ses_lock);
 
 		mutex_unlock(&ses->session_mutex);
 
-		rc = smb3_update_ses_channels(ses, ses->server,
-					       false /* from_reconnect */,
-					       false /* disable_mchan */);
+		smb3_update_ses_channels(ses, ses->server,
+					 false /* from_reconnect */,
+					 false /* disable_mchan */);
 
 		/* Clear scaling flag after operation */
 		spin_lock(&ses->ses_lock);
@@ -1191,22 +1238,30 @@ static int smb3_reconfigure(struct fs_context *fc)
 		mutex_unlock(&ses->session_mutex);
 	}
 
-	STEAL_STRING(cifs_sb, ctx, domainname);
-	STEAL_STRING(cifs_sb, ctx, nodename);
-	STEAL_STRING(cifs_sb, ctx, iocharset);
-
-	/* if rsize or wsize not passed in on remount, use previous values */
-	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
-	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
-
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
-	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
+	memcpy(cifs_sb->ctx, new_ctx, sizeof(*new_ctx));
+	kfree(new_ctx);
+	new_ctx = NULL;
+	smb3_cleanup_fs_context(old_ctx);
+	old_ctx = NULL;
 	smb3_update_mnt_flags(cifs_sb);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
 
+	return rc;
+
+cleanup_new_ctx:
+	smb3_cleanup_fs_context_contents(new_ctx);
+restore_ctx:
+	kfree(new_ctx);
+	kfree_sensitive(new_password);
+	kfree_sensitive(new_password2);
+	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
+	memcpy(cifs_sb->ctx, old_ctx, sizeof(*old_ctx));
+	kfree(old_ctx);
+
 	return rc;
 }
 
-- 
2.53.0



