Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D502014036D;
	Tue, 18 Jun 2024 12:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714832; cv=none; b=qbBLc8ov5hFi2rY14He7B/u99RIm5MPqH306cho8ZIbEC5jG0iNRryhQOxEs1/JLlu07ZjsyHBZTMZIajC8yC3zsL+qSVPcr2tHEauHCI5XTRr/UTAGAVCZRhoFrgFDwBIC8MEjofUvMlJQ+dIzos8TIMOG62O7fAgfDisSKZk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714832; c=relaxed/simple;
	bh=G+EVvizf7nzqq6FvRtSHkjXSGd5/roWVccOmH8Raad8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slqUaQwTOgDzQkgIRpUBEhjy/01nFVqFSC4wKdZjuidzVGW/0CkEH6C+J4RsJJ9DRCuEDp+QHXBX2RmL93FK1MAxQ8cXa1kPcEXWFsjKX4fN1XKfk7Aixt7zSm0Vhf9PdOrzRp5F/wa3aao0XcPQqtwvJV8XMCt6HupK0SpVU1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7lV63Wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7lV63Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3BCC3277B;
	Tue, 18 Jun 2024 12:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714831;
	bh=G+EVvizf7nzqq6FvRtSHkjXSGd5/roWVccOmH8Raad8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7lV63WdWf85EHlcuFxZoPItTheL+fYjWvKiKbXoa6yd1ChKH2aHE1eL4PnclwDXc
	 3JTyR5G8rYWnMZaBEyavuqDlIeoY/GeMasxRq4bqzaKVLVwjYUjgdjTge1ouPPzd4G
	 fVK4CwHAzdszsdDHxPrOnz+owc+mcVaFIF2IO5+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/770] exportfs: Add a function to return the raw output from fh_to_dentry()
Date: Tue, 18 Jun 2024 14:29:15 +0200
Message-ID: <20240618123411.213061517@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d045465fc6cbfa4acfb5a7d817a7c1a57a078109 ]

In order to allow nfsd to accept return values that are not
acceptable to overlayfs and others, add a new function.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exportfs/expfs.c      | 32 ++++++++++++++++++++++++--------
 include/linux/exportfs.h |  5 +++++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 2dd55b172d57f..0106eba46d5af 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -417,9 +417,11 @@ int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
 }
 EXPORT_SYMBOL_GPL(exportfs_encode_fh);
 
-struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
-		int fh_len, int fileid_type,
-		int (*acceptable)(void *, struct dentry *), void *context)
+struct dentry *
+exportfs_decode_fh_raw(struct vfsmount *mnt, struct fid *fid, int fh_len,
+		       int fileid_type,
+		       int (*acceptable)(void *, struct dentry *),
+		       void *context)
 {
 	const struct export_operations *nop = mnt->mnt_sb->s_export_op;
 	struct dentry *result, *alias;
@@ -432,10 +434,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	if (!nop || !nop->fh_to_dentry)
 		return ERR_PTR(-ESTALE);
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
-	if (PTR_ERR(result) == -ENOMEM)
-		return ERR_CAST(result);
 	if (IS_ERR_OR_NULL(result))
-		return ERR_PTR(-ESTALE);
+		return result;
 
 	/*
 	 * If no acceptance criteria was specified by caller, a disconnected
@@ -561,10 +561,26 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 
  err_result:
 	dput(result);
-	if (err != -ENOMEM)
-		err = -ESTALE;
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL_GPL(exportfs_decode_fh_raw);
+
+struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
+				  int fh_len, int fileid_type,
+				  int (*acceptable)(void *, struct dentry *),
+				  void *context)
+{
+	struct dentry *ret;
+
+	ret = exportfs_decode_fh_raw(mnt, fid, fh_len, fileid_type,
+				     acceptable, context);
+	if (IS_ERR_OR_NULL(ret)) {
+		if (ret == ERR_PTR(-ENOMEM))
+			return ret;
+		return ERR_PTR(-ESTALE);
+	}
+	return ret;
+}
 EXPORT_SYMBOL_GPL(exportfs_decode_fh);
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index d829403ffd3bb..846df3c96730f 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -223,6 +223,11 @@ extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
 				    int *max_len, struct inode *parent);
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
 	int *max_len, int connectable);
+extern struct dentry *exportfs_decode_fh_raw(struct vfsmount *mnt,
+					     struct fid *fid, int fh_len,
+					     int fileid_type,
+					     int (*acceptable)(void *, struct dentry *),
+					     void *context);
 extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	int fh_len, int fileid_type, int (*acceptable)(void *, struct dentry *),
 	void *context);
-- 
2.43.0



