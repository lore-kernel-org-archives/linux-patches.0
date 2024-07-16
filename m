Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9181B19AD72;
	Tue, 16 Jul 2024 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145484; cv=none; b=N1+7yPbLL4WXNatnxn3/NfQOAhqeSpqxr9vXAVLMPENpHnXZunlLvH2qQK/jRLS+hoCVwd4tO9b908JwFflYECMsi9FiirQRB33ljC5RbRsTmE1V7OhZox14G/BH/fMAEb8kUEZiZstjtGZRNQ5R7OlioaK5ICqV05Z0A6Xa1u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145484; c=relaxed/simple;
	bh=7eFwqu1QrNCsSNGFZruFPkLBdKk4voiSyBhGIAuqJzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EO6GY1TdBWZEUAEh76gQFKqPEsqtGFb71Fp5tY7GKcepq7Bf//zhQhXSpw5Tko+RjBlEwwTiVd0NfKRFr+oG8yGK9SNP6ogf+ODCknk+ttKxysb9I37nGaLuic6u3TFpkdSbhLg2uhOcn5yOwmlIHG/2gL6SVoShtmt6cPLULoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1XFpwep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1XFpwep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BB2C116B1;
	Tue, 16 Jul 2024 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145484;
	bh=7eFwqu1QrNCsSNGFZruFPkLBdKk4voiSyBhGIAuqJzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1XFpwepT40vCKe9tPVPCTp5fd8YDizJ1LU9P2zRvRFy9siT7yeBbu5fE6PagO6qA
	 s1cL+MbtWW+UAW1UW+S1oK8g4pF8c6f9FL9rEZcbWy9QELlV57I2Z4ynWA/ew6XaAF
	 ofGCiwpHeQL6QOwidczBdG1YRLG2ene9ura4S7aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Andrew Paniakin <apanyaki@amazon.com>
Subject: [PATCH 6.1 81/96] cifs: use origin fullpath for automounts
Date: Tue, 16 Jul 2024 17:32:32 +0200
Message-ID: <20240716152749.630108183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@cjr.nz>

commit 7ad54b98fc1f141cfb70cfe2a3d6def5a85169ff upstream.

Use TCP_Server_Info::origin_fullpath instead of cifs_tcon::tree_name
when building source paths for automounts as it will be useful for
domain-based DFS referrals where the connections and referrals would
get either re-used from the cache or re-created when chasing the dfs
link.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
[apanyaki: backport to v6.1-stable]
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_dfs_ref.c |   34 ++++++++++++++++++++++++++++++++--
 fs/smb/client/cifsproto.h    |   18 ++++++++++++++++++
 fs/smb/client/dir.c          |   21 +++++++++++++++------
 3 files changed, 65 insertions(+), 8 deletions(-)

--- a/fs/smb/client/cifs_dfs_ref.c
+++ b/fs/smb/client/cifs_dfs_ref.c
@@ -258,6 +258,31 @@ compose_mount_options_err:
 	goto compose_mount_options_out;
 }
 
+static int set_dest_addr(struct smb3_fs_context *ctx, const char *full_path)
+{
+	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
+	char *str_addr = NULL;
+	int rc;
+
+	rc = dns_resolve_server_name_to_ip(full_path, &str_addr, NULL);
+	if (rc < 0)
+		goto out;
+
+	rc = cifs_convert_address(addr, str_addr, strlen(str_addr));
+	if (!rc) {
+		cifs_dbg(FYI, "%s: failed to convert ip address\n", __func__);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	cifs_set_port(addr, ctx->port);
+	rc = 0;
+
+out:
+	kfree(str_addr);
+	return rc;
+}
+
 /*
  * Create a vfsmount that we can automount
  */
@@ -295,8 +320,7 @@ static struct vfsmount *cifs_dfs_do_auto
 	ctx = smb3_fc2context(fc);
 
 	page = alloc_dentry_path();
-	/* always use tree name prefix */
-	full_path = build_path_from_dentry_optional_prefix(mntpt, page, true);
+	full_path = dfs_get_automount_devname(mntpt, page);
 	if (IS_ERR(full_path)) {
 		mnt = ERR_CAST(full_path);
 		goto out;
@@ -313,6 +337,12 @@ static struct vfsmount *cifs_dfs_do_auto
 	if (rc) {
 		mnt = ERR_PTR(rc);
 		goto out;
+	}
+
+	rc = set_dest_addr(ctx, full_path);
+	if (rc) {
+		mnt = ERR_PTR(rc);
+		goto out;
 	}
 
 	rc = smb3_parse_devname(full_path, ctx);
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -57,8 +57,26 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern const char *build_path_from_dentry(struct dentry *, void *);
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix);
 extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
 						    void *page, bool prefix);
+static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	if (unlikely(!server->origin_fullpath))
+		return ERR_PTR(-EREMOTE);
+
+	return __build_path_from_dentry_optional_prefix(dentry, page,
+							server->origin_fullpath,
+							strlen(server->origin_fullpath),
+							true);
+}
+
 static inline void *alloc_dentry_path(void)
 {
 	return __getname();
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -78,14 +78,13 @@ build_path_from_dentry(struct dentry *di
 						      prefix);
 }
 
-char *
-build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
-				       bool prefix)
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix)
 {
 	int dfsplen;
 	int pplen = 0;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	char dirsep = CIFS_DIR_SEP(cifs_sb);
 	char *s;
 
@@ -93,7 +92,7 @@ build_path_from_dentry_optional_prefix(s
 		return ERR_PTR(-ENOMEM);
 
 	if (prefix)
-		dfsplen = strnlen(tcon->tree_name, MAX_TREE_SIZE + 1);
+		dfsplen = strnlen(tree, tree_len + 1);
 	else
 		dfsplen = 0;
 
@@ -123,7 +122,7 @@ build_path_from_dentry_optional_prefix(s
 	}
 	if (dfsplen) {
 		s -= dfsplen;
-		memcpy(s, tcon->tree_name, dfsplen);
+		memcpy(s, tree, dfsplen);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
@@ -135,6 +134,16 @@ build_path_from_dentry_optional_prefix(s
 	return s;
 }
 
+char *build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					     bool prefix)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
+	return __build_path_from_dentry_optional_prefix(direntry, page, tcon->tree_name,
+							MAX_TREE_SIZE, prefix);
+}
+
 /*
  * Don't allow path components longer than the server max.
  * Don't allow the separator character in a path component.


