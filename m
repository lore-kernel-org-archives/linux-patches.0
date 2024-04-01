Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0C93EA83;
	Mon,  1 Apr 2024 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986971; cv=none; b=NXHpYPRVC9yqrRpq1EtiTDL/cfTjGmVY1mIEwgWNHkc8VwGYzl1/DLZJ7PhSuBOtAL7eoT+TxfEDvTbFPUKGzDeh9sdrvNet1m5QF5Q6Ao02edgUrVnWqbptCTEwD1oyMR5+zAMJlu1V8DnQb9i94HtBzv7XTHkj5lYGDRzsA/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986971; c=relaxed/simple;
	bh=LVv5iI+ogXGex4x5zDyw6l/mnR6poHJxFhM9rzWOe2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdvQJG8vj+k2qloVsPIZoZxf2joWacyPi+loKJw0noTXceqR79eETM6FqmgG3y8KZI42vIJG0LHqCxsJSl0QXmT1YBqiWpG9JMFW4zt8fLBi9zGhddOiGgmUe66LS7kXW0QF6ST4JNA+m05k0f1QW91zr+NhXNcEtYLgO0eTexo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3JxApjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3JxApjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46083C433C7;
	Mon,  1 Apr 2024 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986970;
	bh=LVv5iI+ogXGex4x5zDyw6l/mnR6poHJxFhM9rzWOe2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3JxApjy3aX8FtFPNVWe5HnT3nFTJCfcq3Y/HCxGSbYHvkbZd6wftM5UTTQm9+ScJ
	 XVpk1rjQWpgF7FScboGIb/gCzCa8JE3jjAyClhNQpAekSb861kL//1Ie8s3tA2MhnU
	 SLuOXPooTeNYs+bLO/0AtiTD5uBUVnhVR30aT8mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 144/399] cifs: allow changing password during remount
Date: Mon,  1 Apr 2024 17:41:50 +0200
Message-ID: <20240401152553.489698464@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit c1eb537bf4560b3ad4df606c266c665624f3b502 ]

There are cases where a session is disconnected and password has changed
on the server (or expired) for this user and this currently can not
be fixed without unmount and mounting again.  This patch allows
remount to change the password (for the non Kerberos case, Kerberos
ticket refresh is handled differently) when the session is disconnected
and the user can not reconnect due to still using old password.

Future patches should also allow us to setup the keyring (cifscreds)
to have an "alternate password" so we would be able to change
the password before the session drops (without the risk of races
between when the password changes and the disconnect occurs -
ie cases where the old password is still needed because the new
password has not fully rolled out to all servers yet).

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c |  2 ++
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/fs_context.c | 27 ++++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c    |  5 +++++
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 3e4209f41c18f..23d2622b969f0 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -488,6 +488,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				ses->ses_count, ses->serverOS, ses->serverNOS,
 				ses->capabilities, ses->ses_status);
 			}
+			if (ses->expired_pwd)
+				seq_puts(m, "password no longer valid ");
 			spin_unlock(&ses->ses_lock);
 
 			seq_printf(m, "\n\tSecurity type: %s ",
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 53c75cfb33ab9..ec9a26bd05a12 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1066,6 +1066,7 @@ struct cifs_ses {
 	enum securityEnum sectype; /* what security flavor was specified? */
 	bool sign;		/* is signing required? */
 	bool domainAuto:1;
+	bool expired_pwd;  /* track if access denied or expired pwd so can know if need to update */
 	unsigned int flags;
 	__u16 session_flags;
 	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 4b2f5aa2ea0e1..415e87635d5aa 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -772,7 +772,7 @@ static void smb3_fs_context_free(struct fs_context *fc)
  */
 static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 				       struct smb3_fs_context *new_ctx,
-				       struct smb3_fs_context *old_ctx)
+				       struct smb3_fs_context *old_ctx, bool need_recon)
 {
 	if (new_ctx->posix_paths != old_ctx->posix_paths) {
 		cifs_errorf(fc, "can not change posixpaths during remount\n");
@@ -798,8 +798,15 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 	}
 	if (new_ctx->password &&
 	    (!old_ctx->password || strcmp(new_ctx->password, old_ctx->password))) {
-		cifs_errorf(fc, "can not change password during remount\n");
-		return -EINVAL;
+		if (need_recon == false) {
+			cifs_errorf(fc,
+				    "can not change password of active session during remount\n");
+			return -EINVAL;
+		} else if (old_ctx->sectype == Kerberos) {
+			cifs_errorf(fc,
+				    "can not change password for Kerberos via remount\n");
+			return -EINVAL;
+		}
 	}
 	if (new_ctx->domainname &&
 	    (!old_ctx->domainname || strcmp(new_ctx->domainname, old_ctx->domainname))) {
@@ -843,9 +850,14 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
+	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	bool need_recon = false;
 	int rc;
 
-	rc = smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx);
+	if (ses->expired_pwd)
+		need_recon = true;
+
+	rc = smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx, need_recon);
 	if (rc)
 		return rc;
 
@@ -858,7 +870,12 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, UNC);
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
-	STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
+	if (need_recon == false)
+		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
+	else  {
+		kfree_sensitive(ses->password);
+		ses->password = kstrdup(ctx->password, GFP_KERNEL);
+	}
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 608ee05491e26..a500380d1b2e9 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1536,6 +1536,11 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 			    &sess_data->buf0_type,
 			    CIFS_LOG_ERROR | CIFS_SESS_OP, &rsp_iov);
 	cifs_small_buf_release(sess_data->iov[0].iov_base);
+	if (rc == 0)
+		sess_data->ses->expired_pwd = false;
+	else if ((rc == -EACCES) || (rc == -EKEYEXPIRED) || (rc == -EKEYREVOKED))
+		sess_data->ses->expired_pwd = true;
+
 	memcpy(&sess_data->iov[0], &rsp_iov, sizeof(struct kvec));
 
 	return rc;
-- 
2.43.0



