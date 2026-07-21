Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA77547010A;
	Tue, 21 Jul 2026 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657024; cv=none; b=G3cHKPR7+nVYRc3wN8GOnWDCfOq9MLDHAL97ZNCZyoe7Sg6CSGKeBO4tCF0MXfQuLzwHhMh9kYcIJuE8O1J69yiKg4urgN+vO88miZ0aKqMfr94MRbjC1zyrO8nY8Q9p7GzKcVV3T5ebQPUa9fvnmB/Yeu0kz/kTDc8bLVSgKMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657024; c=relaxed/simple;
	bh=rJ+3hAzkyAQz5+KzeOCv6SBQ8Gun5zgq/8ZOiYHLOns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0gubk8Ton1L1p2sB44PAAf6lmk/YORMa/QaWdGdaCEF+LOLRWx2LPuNhVJNMuqbyvT34p0SH2mn6EFsJRKBmy/Tca6sW2wuVIosdecogV8V6V76ZWgsaNUMdvGkyMbGkYsDZU/h6fv5Lk3fDtuTMKvr/PrrpVYtzuEdJJfO/Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbfWp92E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbfWp92E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265B81F000E9;
	Tue, 21 Jul 2026 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657023;
	bh=kMR86d0fol0W1P34RZ6IQXyQDM+eIOakx856wj7NofA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbfWp92EuD5WO7VRj0RIB/uRspZaFPHHPhyz9u8pX1Nmwfl+Nqgkmu8vdDhH4QoH+
	 w4YYVavU3ugLsXWcjI3A1fMa3ZHiAb1D5yxlw5d3HdCG19od9zDe6h4j2t+PnvK0xD
	 doEETO6zpBHoccmDP6vVT61WlVR4tyFwkIB12mfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0565/1611] 9p: avoid returning ERR_PTR(0) from mkdir operations
Date: Tue, 21 Jul 2026 17:11:21 +0200
Message-ID: <20260721152528.089571690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 314b58c01a9047567fd19446ca5fd46c473b89ff ]

When mkdir succeeds, v9fs_vfs_mkdir_dotl() and v9fs_vfs_mkdir() return
ERR_PTR(0) which is incorrect. They should return NULL instead for
success and ERR_PTR() only with negative error codes for failure.

Return NULL instead of passing to ERR_PTR while err is zero
Fixes smatch warnings:
  fs/9p/vfs_inode_dotl.c:420 v9fs_vfs_mkdir_dotl() warn: passing zero to 'ERR_PTR'
  fs/9p/vfs_inode.c:695 v9fs_vfs_mkdir() warn: passing zero to 'ERR_PTR'

The v9fs_vfs_mkdir() code was further simplified because v9fs_create()
can never return NULL, so we do not need to check for fid being set
separately, and the error path can be a simple return immediately after
v9fs_create() failure.
There is no intended functional change.

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Acked-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Message-ID: <20260520022650.14217-1-zenghongling@kylinos.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c      | 19 ++++++-------------
 fs/9p/vfs_inode_dotl.c |  4 ++--
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 0f3189a0a516af..e2225bfa55035b 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -672,27 +672,20 @@ v9fs_vfs_create(struct mnt_idmap *idmap, struct inode *dir,
 static struct dentry *v9fs_vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 				     struct dentry *dentry, umode_t mode)
 {
-	int err;
 	u32 perm;
 	struct p9_fid *fid;
 	struct v9fs_session_info *v9ses;
 
 	p9_debug(P9_DEBUG_VFS, "name %pd\n", dentry);
-	err = 0;
 	v9ses = v9fs_inode2v9ses(dir);
 	perm = unixmode2p9mode(v9ses, mode | S_IFDIR);
 	fid = v9fs_create(v9ses, dir, dentry, NULL, perm, P9_OREAD);
-	if (IS_ERR(fid)) {
-		err = PTR_ERR(fid);
-		fid = NULL;
-	} else {
-		inc_nlink(dir);
-		v9fs_invalidate_inode_attr(dir);
-	}
-
-	if (fid)
-		p9_fid_put(fid);
-	return ERR_PTR(err);
+	if (IS_ERR(fid))
+		return ERR_CAST(fid);
+	inc_nlink(dir);
+	v9fs_invalidate_inode_attr(dir);
+	p9_fid_put(fid);
+	return NULL;
 }
 
 /**
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 6312b3590f7438..cbc72a17b01a87 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -349,7 +349,7 @@ static struct dentry *v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
 					  struct inode *dir, struct dentry *dentry,
 					  umode_t omode)
 {
-	int err;
+	int err = 0;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL, *dfid = NULL;
 	kgid_t gid;
@@ -412,7 +412,7 @@ static struct dentry *v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
 	p9_fid_put(fid);
 	v9fs_put_acl(dacl, pacl);
 	p9_fid_put(dfid);
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 }
 
 static int
-- 
2.53.0



