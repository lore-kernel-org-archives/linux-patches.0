Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B395248BA6;
	Wed, 15 Jan 2025 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937880; cv=none; b=BmFytN/vLnpKicBx2ve/5w/p2FnbbE1EKRwK35fLolUfJNBNxPI+VHkHvtygyMoQ8LPiAvEQNVzl38EJszzHVQq+JeZkF/UnOZomnmwA9B/Rd6finT2t9NqLChC33OjXhViakHb6EiuQ5FEiPA73CF6HlLG3YIpE/hkCtvnJTjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937880; c=relaxed/simple;
	bh=UlCxOZqXZg0CfuOv88F+P+kFG4vc2eBivck5NqvdJls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdkKx/Z1c6kajTWICWD3I2BWmJlfu2GkH2A1GKy1N16vRa/6d+GEhbbsE4GsOAf8kVoFLMVqMgpyT7sNCSiWAhdWV6E9jrbSVopoPWYtApZNszkmlLT+7tOO4nzm6aT3r3Fg+oG04rKcSOSI49ZU1D/f3EE413kzGBYIp/JioK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nsf2MAgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nsf2MAgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B023AC4CEDF;
	Wed, 15 Jan 2025 10:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937880;
	bh=UlCxOZqXZg0CfuOv88F+P+kFG4vc2eBivck5NqvdJls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nsf2MAgIpo3kIt/WB00dVfK3strBxlWib3TcC4jA0MfgPQtvTxtmWXQT9y8FPNeXs
	 nEyduERTWO9KJgRbA4w7qkzj1n+QmxZfR6Zw+c07GOUbFhyBS7Pn1VswffdCflxvaD
	 TsDJCPAgXxuLZOUz04ncx2LxUrlxcx5CY8xvbQ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/189] ovl: pass realinode to ovl_encode_real_fh() instead of realdentry
Date: Wed, 15 Jan 2025 11:35:15 +0100
Message-ID: <20250115103607.125372637@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 07aeefae7ff44d80524375253980b1bdee2396b0 ]

We want to be able to encode an fid from an inode with no alias.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20250105162404.357058-2-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode with no alias")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c   | 11 ++++++-----
 fs/overlayfs/export.c    |  5 +++--
 fs/overlayfs/namei.c     |  4 ++--
 fs/overlayfs/overlayfs.h |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2ed6ad641a20..a11a9d756a7b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -416,13 +416,13 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
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
@@ -439,7 +439,8 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	 * the price or reconnecting the dentry.
 	 */
 	dwords = buflen >> 2;
-	fh_type = exportfs_encode_fh(real, (void *)fh->fb.fid, &dwords, 0);
+	fh_type = exportfs_encode_inode_fh(realinode, (void *)fh->fb.fid,
+					   &dwords, NULL, 0);
 	buflen = (dwords << 2);
 
 	err = -EIO;
@@ -481,7 +482,7 @@ struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry *origin)
 	if (!ovl_can_decode_fh(origin->d_sb))
 		return NULL;
 
-	return ovl_encode_real_fh(ofs, origin, false);
+	return ovl_encode_real_fh(ofs, d_inode(origin), false);
 }
 
 int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
@@ -506,7 +507,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
 	const struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, upper, true);
+	fh = ovl_encode_real_fh(ofs, d_inode(upper), true);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 5868cb222955..036c9f39a14d 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -223,6 +223,7 @@ static int ovl_check_encode_origin(struct dentry *dentry)
 static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
 			     u32 *fid, int buflen)
 {
+	struct inode *inode = d_inode(dentry);
 	struct ovl_fh *fh = NULL;
 	int err, enc_lower;
 	int len;
@@ -236,8 +237,8 @@ static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
 		goto fail;
 
 	/* Encode an upper or lower file handle */
-	fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_dentry_lower(dentry) :
-				ovl_dentry_upper(dentry), !enc_lower);
+	fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_inode_lower(inode) :
+				ovl_inode_upper(inode), !enc_lower);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5764f91d283e..42b73ae5ba01 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -542,7 +542,7 @@ int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, real, is_upper);
+	fh = ovl_encode_real_fh(ofs, d_inode(real), is_upper);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh)) {
 		fh = NULL;
@@ -738,7 +738,7 @@ int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, origin, false);
+	fh = ovl_encode_real_fh(ofs, d_inode(origin), false);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0bfe35da4b7b..844874b4a91a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -869,7 +869,7 @@ int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct super_block *sb, const struct path *path, struct dentry *new);
 int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
+struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct inode *realinode,
 				  bool is_upper);
 struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry *origin);
 int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
-- 
2.39.5



