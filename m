Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CDA13B7AE;
	Thu, 23 May 2024 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470668; cv=none; b=dprLZxNybaLh+W/b/N1IJqpvza3Jzurzc06033v3vTDwt8xhs0c8lnxeujfUwaWO7/ReaT5DAMaU9a3OWkgdMv4/EiMRhKXnq3CV11nBSrejhgC8MDStDLfH0dBcF0JEr5v8k5G9iU/Qy6bBfcUVsoSh5DOP/EjEjXArJp7O0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470668; c=relaxed/simple;
	bh=9BpMwaQhSvz70AAWDBweazrI6frK9tnSA8ulSlU3kPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXTyL5L4356dnMNWt5yoIGaia+bZ/IxffRcuSqIonVJCYoCKMgnhsjKxkAbEFz1ArS10agAVgzL81bnR8F+gg7PDx4izqKF5uPecQUfoaIkN8I3AG26lqR96BYcfx40tROe0nHYbW9+O+hLFMaWt1jCLjRcqbxwXvXfXBquWRj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwZpk2XC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwZpk2XC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC73C32781;
	Thu, 23 May 2024 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470668;
	bh=9BpMwaQhSvz70AAWDBweazrI6frK9tnSA8ulSlU3kPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwZpk2XCSew5GK5MKK4EMwr8xeRz2vq2UJHnWeNkawlUuGxPy/mQ/oKPNOtKm+ySo
	 y78aTlOLe+fEaarsK4FrG2rwnIiBpxEoqrq7J08IZlEAUqW3hmb5zQ6D9YkNQH9hAq
	 QEkkHmc1DpZPq+EtBTtF90kMg0IDQGoogXe1q8eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/102] smb: client: introduce reparse mount option
Date: Thu, 23 May 2024 15:13:10 +0200
Message-ID: <20240523130344.164234887@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit eb90e8ecb2b54ac1af51e28596e0ef7ba351476d ]

Allow the user to create special files and symlinks by choosing
between WSL and NFS reparse points via 'reparse={nfs,wsl}' mount
options.  If unset or 'reparse=default', the client will default to
creating them via NFS reparse points.

Creating WSL reparse points isn't supported yet, so simply return
error when attempting to mount with 'reparse=wsl' for now.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h   |  6 ++++++
 fs/smb/client/connect.c    |  2 ++
 fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++++++++
 fs/smb/client/fs_context.h |  9 +++++++++
 4 files changed, 52 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index fdadda4024f46..08540541046c1 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -153,6 +153,12 @@ enum securityEnum {
 	Kerberos,		/* Kerberos via SPNEGO */
 };
 
+enum cifs_reparse_type {
+	CIFS_REPARSE_TYPE_NFS,
+	CIFS_REPARSE_TYPE_WSL,
+	CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NFS,
+};
+
 struct session_key {
 	unsigned int len;
 	char *response;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e28f011f11d6c..deba1cfd11801 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2805,6 +2805,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 		return 0;
 	if (old->ctx->closetimeo != new->ctx->closetimeo)
 		return 0;
+	if (old->ctx->reparse_type != new->ctx->reparse_type)
+		return 0;
 
 	return 1;
 }
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index f119035a82725..535885fbdf51d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -175,6 +175,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("vers", Opt_vers),
 	fsparam_string("sec", Opt_sec),
 	fsparam_string("cache", Opt_cache),
+	fsparam_string("reparse", Opt_reparse),
 
 	/* Arguments that should be ignored */
 	fsparam_flag("guest", Opt_ignore),
@@ -297,6 +298,35 @@ cifs_parse_cache_flavor(struct fs_context *fc, char *value, struct smb3_fs_conte
 	return 0;
 }
 
+static const match_table_t reparse_flavor_tokens = {
+	{ Opt_reparse_default,	"default" },
+	{ Opt_reparse_nfs,	"nfs" },
+	{ Opt_reparse_wsl,	"wsl" },
+	{ Opt_reparse_err,	NULL },
+};
+
+static int parse_reparse_flavor(struct fs_context *fc, char *value,
+				struct smb3_fs_context *ctx)
+{
+	substring_t args[MAX_OPT_ARGS];
+
+	switch (match_token(value, reparse_flavor_tokens, args)) {
+	case Opt_reparse_default:
+		ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
+		break;
+	case Opt_reparse_nfs:
+		ctx->reparse_type = CIFS_REPARSE_TYPE_NFS;
+		break;
+	case Opt_reparse_wsl:
+		cifs_errorf(fc, "unsupported reparse= option: %s\n", value);
+		return 1;
+	default:
+		cifs_errorf(fc, "bad reparse= option: %s\n", value);
+		return 1;
+	}
+	return 0;
+}
+
 #define DUP_CTX_STR(field)						\
 do {									\
 	if (ctx->field) {						\
@@ -1595,6 +1625,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_rdma:
 		ctx->rdma = true;
 		break;
+	case Opt_reparse:
+		if (parse_reparse_flavor(fc, param->string, ctx))
+			goto cifs_parse_mount_err;
+		break;
 	}
 	/* case Opt_ignore: - is ignored as expected ... */
 
@@ -1683,6 +1717,7 @@ int smb3_init_fs_context(struct fs_context *fc)
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
 	ctx->retrans = 1;
+	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 
 /*
  *	short int override_uid = -1;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 369a3fea1dfe0..e77ee81846b31 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -41,6 +41,13 @@ enum {
 	Opt_cache_err
 };
 
+enum cifs_reparse_parm {
+	Opt_reparse_default,
+	Opt_reparse_nfs,
+	Opt_reparse_wsl,
+	Opt_reparse_err
+};
+
 enum cifs_sec_param {
 	Opt_sec_krb5,
 	Opt_sec_krb5i,
@@ -149,6 +156,7 @@ enum cifs_param {
 	Opt_vers,
 	Opt_sec,
 	Opt_cache,
+	Opt_reparse,
 
 	/* Mount options to be ignored */
 	Opt_ignore,
@@ -275,6 +283,7 @@ struct smb3_fs_context {
 	char *leaf_fullpath;
 	struct cifs_ses *dfs_root_ses;
 	bool dfs_automount:1; /* set for dfs automount only */
+	enum cifs_reparse_type reparse_type;
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
-- 
2.43.0



