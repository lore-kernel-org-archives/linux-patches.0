Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888AF345CCF;
	Tue, 16 Dec 2025 11:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885064; cv=none; b=mNBoTpyoSB6OGY8IJwGU7yU2PXVksfhioDPjheaJ/XsqRn4+GPPhpbQscSnqN+I9P3XYk2c7Qqh1E7bEs6pW3GZzPkpDZ6waw+qn0a8KUoPeSDNp4oRk66GKYByTWeluXtrSVJJGZcI+toos9/L/nXLTOHuLi73dL8h5bqy8HB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885064; c=relaxed/simple;
	bh=njsckYUFE/WgEjpKmNMWn6Eb9aSjtwRkadhDcnRNzL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3oUQ8VKMx8cIr/RSgNHkPLmQ+THQYzeGCSrMpWLx6G8fVmA0IizOKzdGfmr2tLlzYuaax1xiPzTNWGyAPfAq17EDwarvckv5HCGONcH3NWsieYM7O26r8MBGJaiw7+KR0OFZKxQY3WkH91zEd1LkWbpGmFF3XraPlUqMotqj1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1Hw8PJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1Hw8PJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F10AC4CEF1;
	Tue, 16 Dec 2025 11:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885064;
	bh=njsckYUFE/WgEjpKmNMWn6Eb9aSjtwRkadhDcnRNzL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1Hw8PJS1Vx6s9cGOmV1nayZs3t0fWVR5MgeomLnpSwepNQ1nwf7565nUzcnFT2eg
	 p/Ykf5zOuIeqD0Q7rwwIIcUm+Ol3vLK8eR5xuwXNUfUAXn4ctsYuVYxbHGFHN78D+P
	 Nv6iHZ7g+/CfHFnGu1REh4ucFDTxXwIWxZv5AUkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 005/507] smack: fix bug: invalid label of unix socket file
Date: Tue, 16 Dec 2025 12:07:26 +0100
Message-ID: <20251216111345.724107547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit 78fc6a94be252b27bb73e4926eed70b5e302a8e0 ]

According to [1], the label of a UNIX domain socket (UDS)
file (i.e., the filesystem object representing the socket)
is not supposed to participate in Smack security.

To achieve this, [1] labels UDS files with "*"
in smack_d_instantiate().

Before [2], smack_d_instantiate() was responsible
for initializing Smack security for all inodes,
except ones under /proc

[2] imposed the sole responsibility for initializing
inode security for newly created filesystem objects
on smack_inode_init_security().

However, smack_inode_init_security() lacks some logic
present in smack_d_instantiate().
In particular, it does not label UDS files with "*".

This patch adds the missing labeling of UDS files
with "*" to smack_inode_init_security().

Labeling UDS files with "*" in smack_d_instantiate()
still works for stale UDS files that already exist on
disk. Stale UDS files are useless, but I keep labeling
them for consistency and maybe to make easier for user
to delete them.

Compared to [1], this version introduces the following
improvements:

  * UDS file label is held inside inode only
    and not saved to xattrs.

  * relabeling UDS files (setxattr, removexattr, etc.)
    is blocked.

[1] 2010-11-24 Casey Schaufler
commit b4e0d5f0791b ("Smack: UDS revision")

[2] 2023-11-16 roberto.sassu
Fixes: e63d86b8b764 ("smack: Initialize the in-memory inode in smack_inode_init_security()")
Link: https://lore.kernel.org/linux-security-module/20231116090125.187209-5-roberto.sassu@huaweicloud.com/

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/LSM/Smack.rst |  5 +++
 security/smack/smack_lsm.c              | 58 +++++++++++++++++++------
 2 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/LSM/Smack.rst b/Documentation/admin-guide/LSM/Smack.rst
index 6d44f4fdbf59f..1b554b5bf98e6 100644
--- a/Documentation/admin-guide/LSM/Smack.rst
+++ b/Documentation/admin-guide/LSM/Smack.rst
@@ -696,6 +696,11 @@ sockets.
 	A privileged program may set this to match the label of another
 	task with which it hopes to communicate.
 
+UNIX domain socket (UDS) with a BSD address functions both as a file in a
+filesystem and as a socket. As a file, it carries the SMACK64 attribute. This
+attribute is not involved in Smack security enforcement and is immutably
+assigned the label "*".
+
 Smack Netlabel Exceptions
 ~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 5cd19f3498cbd..30f20fef3331e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1020,6 +1020,16 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	bool trans_cred;
 	bool trans_rule;
 
+	/*
+	 * UNIX domain sockets use lower level socket data. Let
+	 * UDS inode have fixed * label to keep smack_inode_permission() calm
+	 * when called from unix_find_bsd()
+	 */
+	if (S_ISSOCK(inode->i_mode)) {
+		/* forced label, no need to save to xattrs */
+		issp->smk_inode = &smack_known_star;
+		goto instant_inode;
+	}
 	/*
 	 * If equal, transmuting already occurred in
 	 * smack_dentry_create_files_as(). No need to check again.
@@ -1056,14 +1066,16 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 		}
 	}
 
-	issp->smk_flags |= (SMK_INODE_INSTANT | transflag);
-	if (rc)
-		return rc;
-
-	return xattr_dupval(xattrs, xattr_count,
+	if (rc == 0)
+		if (xattr_dupval(xattrs, xattr_count,
 			    XATTR_SMACK_SUFFIX,
 			    issp->smk_inode->smk_known,
-		     strlen(issp->smk_inode->smk_known));
+		     strlen(issp->smk_inode->smk_known)
+		))
+			rc = -ENOMEM;
+instant_inode:
+	issp->smk_flags |= (SMK_INODE_INSTANT | transflag);
+	return rc;
 }
 
 /**
@@ -1337,13 +1349,23 @@ static int smack_inode_setxattr(struct mnt_idmap *idmap,
 	int check_import = 0;
 	int check_star = 0;
 	int rc = 0;
+	umode_t const i_mode = d_backing_inode(dentry)->i_mode;
 
 	/*
 	 * Check label validity here so import won't fail in post_setxattr
 	 */
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
+	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
+		/*
+		 * UDS inode has fixed label
+		 */
+		if (S_ISSOCK(i_mode)) {
+			rc = -EINVAL;
+		} else {
+			check_priv = 1;
+			check_import = 1;
+		}
+	} else if (strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
+		   strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
 		check_priv = 1;
 		check_import = 1;
 	} else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
@@ -1353,7 +1375,7 @@ static int smack_inode_setxattr(struct mnt_idmap *idmap,
 		check_star = 1;
 	} else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
 		check_priv = 1;
-		if (!S_ISDIR(d_backing_inode(dentry)->i_mode) ||
+		if (!S_ISDIR(i_mode) ||
 		    size != TRANS_TRUE_SIZE ||
 		    strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
 			rc = -EINVAL;
@@ -1484,12 +1506,15 @@ static int smack_inode_removexattr(struct mnt_idmap *idmap,
 	 * Don't do anything special for these.
 	 *	XATTR_NAME_SMACKIPIN
 	 *	XATTR_NAME_SMACKIPOUT
+	 *	XATTR_NAME_SMACK if S_ISSOCK (UDS inode has fixed label)
 	 */
 	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
-		struct super_block *sbp = dentry->d_sb;
-		struct superblock_smack *sbsp = smack_superblock(sbp);
+		if (!S_ISSOCK(d_backing_inode(dentry)->i_mode)) {
+			struct super_block *sbp = dentry->d_sb;
+			struct superblock_smack *sbsp = smack_superblock(sbp);
 
-		isp->smk_inode = sbsp->smk_default;
+			isp->smk_inode = sbsp->smk_default;
+		}
 	} else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0)
 		isp->smk_task = NULL;
 	else if (strcmp(name, XATTR_NAME_SMACKMMAP) == 0)
@@ -3607,7 +3632,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		 */
 
 		/*
-		 * UNIX domain sockets use lower level socket data.
+		 * UDS inode has fixed label (*)
 		 */
 		if (S_ISSOCK(inode->i_mode)) {
 			final = &smack_known_star;
@@ -4872,6 +4897,11 @@ static int smack_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 
 static int smack_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
 {
+	/*
+	 * UDS inode has fixed label. Ignore nfs label.
+	 */
+	if (S_ISSOCK(inode->i_mode))
+		return 0;
 	return smack_inode_setsecurity(inode, XATTR_SMACK_SUFFIX, ctx,
 				       ctxlen, 0);
 }
-- 
2.51.0



