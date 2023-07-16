Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FF68F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE47C433C8;
	Sun, 16 Jul 2023 20:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538386;
	bh=y7VRiLT8hSrsmV6QzmdIteHviiG4TkZZsdh5b24euI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCZOEGz4P/wMCNZITEHx8jJj5q8jvFIVr0HIjH2eAD2z9iw3EJfXfc45UKaLkp0z5
	 YclBPz7V7m0isgDiT2jv49YaQ8CUrV2Dek56JAHtfzg1mDzfORjweQJziKHteWPbBv
	 1lswUdCQti6IQ/wS6ze2oETGe2H0emcYPNE/Piag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 425/800] ovl: update of dentry revalidate flags after copy up
Date: Sun, 16 Jul 2023 21:44:38 +0200
Message-ID: <20230716194958.960743977@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit b07d5cc93e1b28df47a72c519d09d0a836043613 ]

After copy up, we may need to update d_flags if upper dentry is on a
remote fs and lower dentries are not.

Add helpers to allow incremental update of the revalidate flags.

Fixes: bccece1ead36 ("ovl: allow remote upper")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c   |  2 ++
 fs/overlayfs/dir.c       |  3 +--
 fs/overlayfs/export.c    |  3 +--
 fs/overlayfs/namei.c     |  3 +--
 fs/overlayfs/overlayfs.h |  6 ++++--
 fs/overlayfs/super.c     |  2 +-
 fs/overlayfs/util.c      | 24 ++++++++++++++++++++----
 7 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f658cc8ea4920..95dce240ba17a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -575,6 +575,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 			/* Restore timestamps on parent (best effort) */
 			ovl_set_timestamps(ofs, upperdir, &c->pstat);
 			ovl_dentry_set_upper_alias(c->dentry);
+			ovl_dentry_update_reval(c->dentry, upper);
 		}
 	}
 	inode_unlock(udir);
@@ -894,6 +895,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		inode_unlock(udir);
 
 		ovl_dentry_set_upper_alias(c->dentry);
+		ovl_dentry_update_reval(c->dentry, ovl_dentry_upper(c->dentry));
 	}
 
 out:
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index fc25fb95d5fc0..9be52d8013c83 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -269,8 +269,7 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 
 	ovl_dir_modified(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
-	ovl_dentry_update_reval(dentry, newdentry,
-			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_reval(dentry, newdentry);
 
 	if (!hardlink) {
 		/*
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index defd4e231ad2c..5c36fb3a7bab1 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -326,8 +326,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (upper_alias)
 		ovl_dentry_set_upper_alias(dentry);
 
-	ovl_dentry_update_reval(dentry, upper,
-			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_reval(dentry, upper);
 
 	return d_instantiate_anon(dentry, inode);
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index cfb3420b7df0e..100a492d2b2a6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1122,8 +1122,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
-	ovl_dentry_update_reval(dentry, upperdentry,
-			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_reval(dentry, upperdentry);
 
 	revert_creds(old_cred);
 	if (origin_path) {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4d0b278f5630e..e100c55bb924a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -375,8 +375,10 @@ bool ovl_index_all(struct super_block *sb);
 bool ovl_verify_lower(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
-void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
-			     unsigned int mask);
+void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry);
+void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry);
+void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
+			   unsigned int mask);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f97ad8b40dbbd..ae1058fbfb5b2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1877,7 +1877,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
-	ovl_dentry_update_reval(root, upperdentry, DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_flags(root, upperdentry, DCACHE_OP_WEAK_REVALIDATE);
 
 	return root;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 923d66d131c16..6a0652bd51f24 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -94,14 +94,30 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 	return oe;
 }
 
+#define OVL_D_REVALIDATE (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)
+
 bool ovl_dentry_remote(struct dentry *dentry)
 {
-	return dentry->d_flags &
-		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	return dentry->d_flags & OVL_D_REVALIDATE;
+}
+
+void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry)
+{
+	if (!ovl_dentry_remote(realdentry))
+		return;
+
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= realdentry->d_flags & OVL_D_REVALIDATE;
+	spin_unlock(&dentry->d_lock);
+}
+
+void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry)
+{
+	return ovl_dentry_init_flags(dentry, upperdentry, OVL_D_REVALIDATE);
 }
 
-void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
-			     unsigned int mask)
+void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
+			   unsigned int mask)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 	unsigned int i, flags = 0;
-- 
2.39.2



