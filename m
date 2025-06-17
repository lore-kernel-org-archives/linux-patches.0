Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A42EBDCC;
	Tue, 17 Jun 2025 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174924; cv=none; b=oFtVlDhK9xxZWVn6+KFxeV3pwq1r6PeKZg2eSsf34505gak2EPEcwChEBxpt3oqn1xSyHenAFi0DOa6BPjstGouO1bTFH8358mkyQFychkJ/KCRXK7TCWxhu+mPQvE7yJGP4+StZj4DSX1X+Ksjguvf1xFJ/iTdqmnHH4Ul+u4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174924; c=relaxed/simple;
	bh=GJ33CNgEHl9VlrzVs6axAEznPdloTU6zLxdcNVDfqEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiiFiBvyR+nZVzgPNtYoh5LcMFEWFSP7mrrrAln/ZwOuPlxpJWIJCNb7GIRS/zCb4UAMIILP+1v1RiGfSDjicV9/+R6uGA6kXL7Bb0FqKd0tNPFKc2hkF68pFbQHUfvfhdpHfxVUvyFGr9prqwjew/yn1/HkGCg2JkeSGd41vPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mdTOONE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mdTOONE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDB4C4CEE3;
	Tue, 17 Jun 2025 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174924;
	bh=GJ33CNgEHl9VlrzVs6axAEznPdloTU6zLxdcNVDfqEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mdTOONEGdMYsrfNPh2wRfw3xuBvQhT4t0Zc5xxrQwh0cUE1sTXAMo9/tyI2KWCCE
	 UhyutTQthzgRLPotjF2WxRsVXdTeBYncWvs2XnK0UBAERDw4onJcQnPFcT8ZgazNcI
	 79AznjX/xqdNhbWqPdtRvFUSiVMdR7VFGINGy3lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 016/780] gfs2: Move GIF_ALLOC_FAILED check out of gfs2_ea_dealloc
Date: Tue, 17 Jun 2025 17:15:24 +0200
Message-ID: <20250617152452.161488222@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 0cc617a54dfe6b44624c9a03e2e11a24eb9bc720 ]

Don't check for the GIF_ALLOC_FAILED flag in gfs2_ea_dealloc() and pass
that information explicitly instead.  This allows for a cleaner
follow-up patch.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c |  2 +-
 fs/gfs2/xattr.c | 11 ++++++-----
 fs/gfs2/xattr.h |  2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 3f49f848c6b4e..e25a24ae2197f 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1314,7 +1314,7 @@ static int evict_unlinked_inode(struct inode *inode)
 	}
 
 	if (ip->i_eattr) {
-		ret = gfs2_ea_dealloc(ip);
+		ret = gfs2_ea_dealloc(ip, !test_bit(GIF_ALLOC_FAILED, &ip->i_flags));
 		if (ret)
 			goto out;
 	}
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 17ae5070a90e6..df9c93de94c79 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -1383,7 +1383,7 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 	return error;
 }
 
-static int ea_dealloc_block(struct gfs2_inode *ip)
+static int ea_dealloc_block(struct gfs2_inode *ip, bool initialized)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd;
@@ -1416,7 +1416,7 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 	ip->i_eattr = 0;
 	gfs2_add_inode_blocks(&ip->i_inode, -1);
 
-	if (likely(!test_bit(GIF_ALLOC_FAILED, &ip->i_flags))) {
+	if (initialized) {
 		error = gfs2_meta_inode_buffer(ip, &dibh);
 		if (!error) {
 			gfs2_trans_add_meta(ip->i_gl, dibh);
@@ -1435,11 +1435,12 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 /**
  * gfs2_ea_dealloc - deallocate the extended attribute fork
  * @ip: the inode
+ * @initialized: xattrs have been initialized
  *
  * Returns: errno
  */
 
-int gfs2_ea_dealloc(struct gfs2_inode *ip)
+int gfs2_ea_dealloc(struct gfs2_inode *ip, bool initialized)
 {
 	int error;
 
@@ -1451,7 +1452,7 @@ int gfs2_ea_dealloc(struct gfs2_inode *ip)
 	if (error)
 		return error;
 
-	if (likely(!test_bit(GIF_ALLOC_FAILED, &ip->i_flags))) {
+	if (initialized) {
 		error = ea_foreach(ip, ea_dealloc_unstuffed, NULL);
 		if (error)
 			goto out_quota;
@@ -1463,7 +1464,7 @@ int gfs2_ea_dealloc(struct gfs2_inode *ip)
 		}
 	}
 
-	error = ea_dealloc_block(ip);
+	error = ea_dealloc_block(ip, initialized);
 
 out_quota:
 	gfs2_quota_unhold(ip);
diff --git a/fs/gfs2/xattr.h b/fs/gfs2/xattr.h
index eb12eb7e37c19..3c9788e0e1375 100644
--- a/fs/gfs2/xattr.h
+++ b/fs/gfs2/xattr.h
@@ -54,7 +54,7 @@ int __gfs2_xattr_set(struct inode *inode, const char *name,
 		     const void *value, size_t size,
 		     int flags, int type);
 ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size);
-int gfs2_ea_dealloc(struct gfs2_inode *ip);
+int gfs2_ea_dealloc(struct gfs2_inode *ip, bool initialized);
 
 /* Exported to acl.c */
 
-- 
2.39.5



