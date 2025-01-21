Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA831F5439;
	Tue, 21 Jan 2025 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482193; cv=none; b=ttjeigapbQevMYO7+xtmvx3vn8h+c8iwXDNAlR1DpNX0qz+NMOsFzQLTN9R2B4HwLWFIkeNbY3FOXp7Y6y//mw+8fIrJM5lRN1A/3FmbbcInZ1HO1OahpnnIVnqCUS+92fox9qmty5++3l8OaZX66GnFvnUuJsLU9VbwqbuMUQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482193; c=relaxed/simple;
	bh=IjODkHgrH5tojHz/7BLzQpePxh43RwnNA89bJx8aqpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7J5K+o3NGA67xRgvZdu72Scn5sFiydMkjHA0I74zwWn9QgsNFC52+Jgf/HXtLOln8UBo99l6M4trg9FixKjQroJmsOyHFCjyrsVINh1/rGnpCbyu6g+2pLqkPuQBnrIEMue2yAU9MV6YwYKMgKXP7VR6aK+tFiX91P0JPIu4eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cW75nArx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cW75nArx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF6BC4CEDF;
	Tue, 21 Jan 2025 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482192;
	bh=IjODkHgrH5tojHz/7BLzQpePxh43RwnNA89bJx8aqpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cW75nArxcH6w1JU/JmKTDqGbbFtH1jaR3k0RWyK1NjFUzqkCCbB5NmE9P4XM61GvO
	 vY5QoD8gCN+mkkrrBxweeyPFxPamGyHqPXOxPLUopjDJdMoBMJDtrQ0YfSqGrYxADS
	 WTwrMOYeUVVYY7K5CNem8Sbe4/HkBBaP+cjVlMyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 66/72] ovl: pass realinode to ovl_encode_real_fh() instead of realdentry
Date: Tue, 21 Jan 2025 18:52:32 +0100
Message-ID: <20250121174525.977509294@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 07aeefae7ff44d80524375253980b1bdee2396b0 upstream.

We want to be able to encode an fid from an inode with no alias.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20250105162404.357058-2-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode with no alias")
Signed-off-by: Sasha Levin <sashal@kernel.org>
[re-applied over v6.6.71 with conflict resolved]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c   |   11 ++++++-----
 fs/overlayfs/export.c    |    5 +++--
 fs/overlayfs/namei.c     |    4 ++--
 fs/overlayfs/overlayfs.h |    2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -371,13 +371,13 @@ int ovl_set_attr(struct ovl_fs *ofs, str
 	return err;
 }
 
-struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
+struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct inode *realinode,
 				  bool is_upper)
 {
 	struct ovl_fh *fh;
 	int fh_type, dwords;
 	int buflen = MAX_HANDLE_SZ;
-	uuid_t *uuid = &real->d_sb->s_uuid;
+	uuid_t *uuid = &realinode->i_sb->s_uuid;
 	int err;
 
 	/* Make sure the real fid stays 32bit aligned */
@@ -394,7 +394,8 @@ struct ovl_fh *ovl_encode_real_fh(struct
 	 * the price or reconnecting the dentry.
 	 */
 	dwords = buflen >> 2;
-	fh_type = exportfs_encode_fh(real, (void *)fh->fb.fid, &dwords, 0);
+	fh_type = exportfs_encode_inode_fh(realinode, (void *)fh->fb.fid,
+					   &dwords, NULL, 0);
 	buflen = (dwords << 2);
 
 	err = -EIO;
@@ -438,7 +439,7 @@ int ovl_set_origin(struct ovl_fs *ofs, s
 	 * up and a pure upper inode.
 	 */
 	if (ovl_can_decode_fh(lower->d_sb)) {
-		fh = ovl_encode_real_fh(ofs, lower, false);
+		fh = ovl_encode_real_fh(ofs, d_inode(lower), false);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
@@ -461,7 +462,7 @@ static int ovl_set_upper_fh(struct ovl_f
 	const struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, upper, true);
+	fh = ovl_encode_real_fh(ofs, d_inode(upper), true);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -228,6 +228,7 @@ static int ovl_check_encode_origin(struc
 static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
 			     u32 *fid, int buflen)
 {
+	struct inode *inode = d_inode(dentry);
 	struct ovl_fh *fh = NULL;
 	int err, enc_lower;
 	int len;
@@ -241,8 +242,8 @@ static int ovl_dentry_to_fid(struct ovl_
 		goto fail;
 
 	/* Encode an upper or lower file handle */
-	fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_dentry_lower(dentry) :
-				ovl_dentry_upper(dentry), !enc_lower);
+	fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_inode_lower(inode) :
+				ovl_inode_upper(inode), !enc_lower);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -523,7 +523,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, real, is_upper);
+	fh = ovl_encode_real_fh(ofs, d_inode(real), is_upper);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh)) {
 		fh = NULL;
@@ -720,7 +720,7 @@ int ovl_get_index_name(struct ovl_fs *of
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, origin, false);
+	fh = ovl_encode_real_fh(ofs, d_inode(origin), false);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -821,7 +821,7 @@ int ovl_copy_up_with_data(struct dentry
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct super_block *sb, const struct path *path, struct dentry *new);
 int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
+struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct inode *realinode,
 				  bool is_upper);
 int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
 		   struct dentry *upper);


