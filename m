Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44D47461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CFEC433C8;
	Sun, 17 Sep 2023 20:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981195;
	bh=IAq/cjosYB8nS5o8U9XLwgDoa+Y+GvVTWhu0cKlRVjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4mwlvaS0mMxCv3g+zMRsOTQrrWB8gih1cBts6cDvsX8nkeVM6olYPgwwwtl2b6E1
	 XYgUlLkid1odmvRHGSSB17zN6E8M8q/wUUFvvpB0Ww/9xtrZLki0DZoaUg2lYxc75A
	 0hEuKKMPMqN5PmQvNg2/JCM5a8bkoIRGcJlr+mio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/219] cifs: use fs_context for automounts
Date: Sun, 17 Sep 2023 21:13:32 +0200
Message-ID: <20230917191044.048246502@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

[ Upstream commit 9fd29a5bae6e8f94b410374099a6fddb253d2d5f ]

Use filesystem context support to handle dfs links.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: efc0b0bcffcb ("smb: propagate error code of extract_sharename()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_dfs_ref.c | 100 ++++++++++++++---------------------
 1 file changed, 40 insertions(+), 60 deletions(-)

diff --git a/fs/smb/client/cifs_dfs_ref.c b/fs/smb/client/cifs_dfs_ref.c
index b0864da9ef434..020e71fe1454e 100644
--- a/fs/smb/client/cifs_dfs_ref.c
+++ b/fs/smb/client/cifs_dfs_ref.c
@@ -258,61 +258,23 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	goto compose_mount_options_out;
 }
 
-/**
- * cifs_dfs_do_mount - mounts specified path using DFS full path
- *
- * Always pass down @fullpath to smb3_do_mount() so we can use the root server
- * to perform failover in case we failed to connect to the first target in the
- * referral.
- *
- * @mntpt:		directory entry for the path we are trying to automount
- * @cifs_sb:		parent/root superblock
- * @fullpath:		full path in UNC format
- */
-static struct vfsmount *cifs_dfs_do_mount(struct dentry *mntpt,
-					  struct cifs_sb_info *cifs_sb,
-					  const char *fullpath)
-{
-	struct vfsmount *mnt;
-	char *mountdata;
-	char *devname;
-
-	devname = kstrdup(fullpath, GFP_KERNEL);
-	if (!devname)
-		return ERR_PTR(-ENOMEM);
-
-	convert_delimiter(devname, '/');
-
-	/* TODO: change to call fs_context_for_mount(), fill in context directly, call fc_mount */
-
-	/* See afs_mntpt_do_automount in fs/afs/mntpt.c for an example */
-
-	/* strip first '\' from fullpath */
-	mountdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-					       fullpath + 1, NULL, NULL);
-	if (IS_ERR(mountdata)) {
-		kfree(devname);
-		return (struct vfsmount *)mountdata;
-	}
-
-	mnt = vfs_submount(mntpt, &cifs_fs_type, devname, mountdata);
-	kfree(mountdata);
-	kfree(devname);
-	return mnt;
-}
-
 /*
  * Create a vfsmount that we can automount
  */
-static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
+static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 {
+	int rc;
+	struct dentry *mntpt = path->dentry;
+	struct fs_context *fc;
 	struct cifs_sb_info *cifs_sb;
-	void *page;
+	void *page = NULL;
+	struct smb3_fs_context *ctx, *cur_ctx;
+	struct smb3_fs_context tmp;
 	char *full_path;
 	struct vfsmount *mnt;
 
-	cifs_dbg(FYI, "in %s\n", __func__);
-	BUG_ON(IS_ROOT(mntpt));
+	if (IS_ROOT(mntpt))
+		return ERR_PTR(-ESTALE);
 
 	/*
 	 * The MSDFS spec states that paths in DFS referral requests and
@@ -321,29 +283,47 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	 * gives us the latter, so we must adjust the result.
 	 */
 	cifs_sb = CIFS_SB(mntpt->d_sb);
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) {
-		mnt = ERR_PTR(-EREMOTE);
-		goto cdda_exit;
-	}
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
+		return ERR_PTR(-EREMOTE);
+
+	cur_ctx = cifs_sb->ctx;
+
+	fc = fs_context_for_submount(path->mnt->mnt_sb->s_type, mntpt);
+	if (IS_ERR(fc))
+		return ERR_CAST(fc);
+
+	ctx = smb3_fc2context(fc);
 
 	page = alloc_dentry_path();
 	/* always use tree name prefix */
 	full_path = build_path_from_dentry_optional_prefix(mntpt, page, true);
 	if (IS_ERR(full_path)) {
 		mnt = ERR_CAST(full_path);
-		goto free_full_path;
+		goto out;
 	}
 
-	convert_delimiter(full_path, '\\');
+	convert_delimiter(full_path, '/');
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
-	mnt = cifs_dfs_do_mount(mntpt, cifs_sb, full_path);
-	cifs_dbg(FYI, "%s: cifs_dfs_do_mount:%s , mnt:%p\n", __func__, full_path + 1, mnt);
+	tmp = *cur_ctx;
+	tmp.source = full_path;
+	tmp.UNC = tmp.prepath = NULL;
+
+	rc = smb3_fs_context_dup(ctx, &tmp);
+	if (rc) {
+		mnt = ERR_PTR(rc);
+		goto out;
+	}
+
+	rc = smb3_parse_devname(full_path, ctx);
+	if (!rc)
+		mnt = fc_mount(fc);
+	else
+		mnt = ERR_PTR(rc);
 
-free_full_path:
+out:
+	put_fs_context(fc);
 	free_dentry_path(page);
-cdda_exit:
-	cifs_dbg(FYI, "leaving %s\n" , __func__);
 	return mnt;
 }
 
@@ -354,9 +334,9 @@ struct vfsmount *cifs_dfs_d_automount(struct path *path)
 {
 	struct vfsmount *newmnt;
 
-	cifs_dbg(FYI, "in %s\n", __func__);
+	cifs_dbg(FYI, "%s: %pd\n", __func__, path->dentry);
 
-	newmnt = cifs_dfs_do_automount(path->dentry);
+	newmnt = cifs_dfs_do_automount(path);
 	if (IS_ERR(newmnt)) {
 		cifs_dbg(FYI, "leaving %s [automount failed]\n" , __func__);
 		return newmnt;
-- 
2.40.1



