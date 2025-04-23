Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3CC288C9E;
	Wed, 23 Apr 2025 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422331; cv=none; b=A1QGoK30wIwIL5Keq8EpPcyWo1FD/3F33AJJc3b54j2t+I2IZ6PdRw5R4QunA4xajak0ZUA/eLBgoEnpCfLw5vwAWBWI5Rv1HOmLqMFFFErpkRvqsN1kj9JW5mn/+0ISqZh/3OangH79dd2TI67pWVO3hBkx4yXC7AJNuwTmh1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422331; c=relaxed/simple;
	bh=3tvOn2UlNCdsbegrifsRjxJ3l1cqpX/oxPyHFMAPhNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QK5CPDnnvwVMGuKMREYORShiCbzh17m0bXmuX+Bm9r1WJOKA2Epv2PWkJx2pyeBSvgnHh/Ans3CN+Zm13KSx+59gpyKCwwmkYCCT2MwKYTsZx0kqSldIpWF4LEEAwo4KYu/leR5E5FsCAdXRH0nvlQgREOD3eiu7Jk5uMoXqyfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHjB0Go5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHjB0Go5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BC7C4CEE2;
	Wed, 23 Apr 2025 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422330;
	bh=3tvOn2UlNCdsbegrifsRjxJ3l1cqpX/oxPyHFMAPhNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHjB0Go503QAJkgS7aPHWQbFLmbmKcPabQeIldYCTV53gikpdzsSGD93inw5nTtbz
	 eAIlsjCr/ml3MZ4sbVOixrOy0YlyBPx+KofRj2OBdvEQFd6LDr+RAzyKbvGq6lut0m
	 mw+9Dr8tdus2C+RcTWw+1I3OiGTClS+EBcAzhlhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Andrew Paniakin <apanyaki@amazon.com>
Subject: [PATCH 6.1 278/291] cifs: use origin fullpath for automounts
Date: Wed, 23 Apr 2025 16:44:27 +0200
Message-ID: <20250423142635.790666731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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
 fs/smb/client/cifsproto.h    |   21 +++++++++++++++++++++
 fs/smb/client/dir.c          |   21 +++++++++++++++------
 3 files changed, 68 insertions(+), 8 deletions(-)

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
@@ -57,8 +57,29 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern const char *build_path_from_dentry(struct dentry *, void *);
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix);
 extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
 						    void *page, bool prefix);
+
+#ifdef CONFIG_CIFS_DFS_UPCALL
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
+#endif
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


