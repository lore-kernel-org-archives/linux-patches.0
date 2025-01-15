Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470CD248BD4;
	Wed, 15 Jan 2025 10:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938609; cv=none; b=TRyjtaQhLMmSLDiEiHhpRSZSw7wANK0fBXLV3DYOO4wg2cGrCMUunP98ePb8Jmw3d7Zj8o80BD2K+oqyVZMPKWRoM81AcJDFLBdyhO/bJJ1aXyO0TdZjaKz2IMDld+HykjKDTuoqFEfrRqVUpIgRoOs+TlSlJ3g7qGj5NnCPde8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938609; c=relaxed/simple;
	bh=TTt5oPI0lENqjaHSCqlVvWS//yxms8J26gg1zYgUyHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hR/IQQJSU+LcxBlSNgHLjyul31Gca2cmMQwDmRLKbI9zndnUoKBJTuPWnLubJ/tmVHR9yLrJuZ8AJvlmDaoYaJ7aRCjBhQHRyUgL8t0v5VCtUN4sw/oe2rZseAy6n5E42kQQ1J7rQIlVr7NHc7Mu/y3MUEIto7dRKGcrmMgpgDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7LxuSUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7LxuSUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE2BC4CEDF;
	Wed, 15 Jan 2025 10:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938609;
	bh=TTt5oPI0lENqjaHSCqlVvWS//yxms8J26gg1zYgUyHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7LxuSUGelH6YtofAkGlYejGx4RhoB/weFAioj/JME0BrJiU5ZHRTz18EdO4kADkx
	 /FCGZtUi3YicN8jVpB0/OvKEsURHWO1+fteLG8vwZfL0eJF8sqdody6QOzg6CeS7+f
	 WZ6PeM26xpwhjUdZ2t2/7NkVKkeljcnDcN7T5WPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <dima@arista.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/129] ovl: support encoding fid from inode with no alias
Date: Wed, 15 Jan 2025 11:36:27 +0100
Message-ID: <20250115103554.860722494@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

[ Upstream commit c45beebfde34aa71afbc48b2c54cdda623515037 ]

Dmitry Safonov reported that a WARN_ON() assertion can be trigered by
userspace when calling inotify_show_fdinfo() for an overlayfs watched
inode, whose dentry aliases were discarded with drop_caches.

The WARN_ON() assertion in inotify_show_fdinfo() was removed, because
it is possible for encoding file handle to fail for other reason, but
the impact of failing to encode an overlayfs file handle goes beyond
this assertion.

As shown in the LTP test case mentioned in the link below, failure to
encode an overlayfs file handle from a non-aliased inode also leads to
failure to report an fid with FAN_DELETE_SELF fanotify events.

As Dmitry notes in his analyzis of the problem, ovl_encode_fh() fails
if it cannot find an alias for the inode, but this failure can be fixed.
ovl_encode_fh() seldom uses the alias and in the case of non-decodable
file handles, as is often the case with fanotify fid info,
ovl_encode_fh() never needs to use the alias to encode a file handle.

Defer finding an alias until it is actually needed so ovl_encode_fh()
will not fail in the common case of FAN_DELETE_SELF fanotify events.

Fixes: 16aac5ad1fa9 ("ovl: support encoding non-decodable file handles")
Reported-by: Dmitry Safonov <dima@arista.com>
Closes: https://lore.kernel.org/linux-fsdevel/CAOQ4uxiie81voLZZi2zXS1BziXZCM24nXqPAxbu8kxXCUWdwOg@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20250105162404.357058-3-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/export.c | 46 +++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index c56e4e0b8054..3a17e4366f28 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -181,35 +181,37 @@ static int ovl_connect_layer(struct dentry *dentry)
  *
  * Return 0 for upper file handle, > 0 for lower file handle or < 0 on error.
  */
-static int ovl_check_encode_origin(struct dentry *dentry)
+static int ovl_check_encode_origin(struct inode *inode)
 {
-	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
 	bool decodable = ofs->config.nfs_export;
+	struct dentry *dentry;
+	int err;
 
 	/* No upper layer? */
 	if (!ovl_upper_mnt(ofs))
 		return 1;
 
 	/* Lower file handle for non-upper non-decodable */
-	if (!ovl_dentry_upper(dentry) && !decodable)
+	if (!ovl_inode_upper(inode) && !decodable)
 		return 1;
 
 	/* Upper file handle for pure upper */
-	if (!ovl_dentry_lower(dentry))
+	if (!ovl_inode_lower(inode))
 		return 0;
 
 	/*
 	 * Root is never indexed, so if there's an upper layer, encode upper for
 	 * root.
 	 */
-	if (dentry == dentry->d_sb->s_root)
+	if (inode == d_inode(inode->i_sb->s_root))
 		return 0;
 
 	/*
 	 * Upper decodable file handle for non-indexed upper.
 	 */
-	if (ovl_dentry_upper(dentry) && decodable &&
-	    !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+	if (ovl_inode_upper(inode) && decodable &&
+	    !ovl_test_flag(OVL_INDEX, inode))
 		return 0;
 
 	/*
@@ -218,17 +220,25 @@ static int ovl_check_encode_origin(struct dentry *dentry)
 	 * ovl_connect_layer() will try to make origin's layer "connected" by
 	 * copying up a "connectable" ancestor.
 	 */
-	if (d_is_dir(dentry) && decodable)
-		return ovl_connect_layer(dentry);
+	if (!decodable || !S_ISDIR(inode->i_mode))
+		return 1;
+
+	dentry = d_find_any_alias(inode);
+	if (!dentry)
+		return -ENOENT;
+
+	err = ovl_connect_layer(dentry);
+	dput(dentry);
+	if (err < 0)
+		return err;
 
 	/* Lower file handle for indexed and non-upper dir/non-dir */
 	return 1;
 }
 
-static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
+static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct inode *inode,
 			     u32 *fid, int buflen)
 {
-	struct inode *inode = d_inode(dentry);
 	struct ovl_fh *fh = NULL;
 	int err, enc_lower;
 	int len;
@@ -237,7 +247,7 @@ static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
 	 * Check if we should encode a lower or upper file handle and maybe
 	 * copy up an ancestor to make lower file handle connectable.
 	 */
-	err = enc_lower = ovl_check_encode_origin(dentry);
+	err = enc_lower = ovl_check_encode_origin(inode);
 	if (enc_lower < 0)
 		goto fail;
 
@@ -257,8 +267,8 @@ static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
 	return err;
 
 fail:
-	pr_warn_ratelimited("failed to encode file handle (%pd2, err=%i)\n",
-			    dentry, err);
+	pr_warn_ratelimited("failed to encode file handle (ino=%lu, err=%i)\n",
+			    inode->i_ino, err);
 	goto out;
 }
 
@@ -266,19 +276,13 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
 			 struct inode *parent)
 {
 	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
-	struct dentry *dentry;
 	int bytes, buflen = *max_len << 2;
 
 	/* TODO: encode connectable file handles */
 	if (parent)
 		return FILEID_INVALID;
 
-	dentry = d_find_any_alias(inode);
-	if (!dentry)
-		return FILEID_INVALID;
-
-	bytes = ovl_dentry_to_fid(ofs, dentry, fid, buflen);
-	dput(dentry);
+	bytes = ovl_dentry_to_fid(ofs, inode, fid, buflen);
 	if (bytes <= 0)
 		return FILEID_INVALID;
 
-- 
2.39.5



